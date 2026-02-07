#!/usr/bin/env bash
set -euo pipefail

TASK="${1:?Usage: setup-task.sh <TASK> <REMOTE> <SSH_KEY>}"
REMOTE="$2"
SSH_KEY="$3"

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
SCP="scp -i $SSH_KEY $SSH_OPTS"
SSH="ssh -i $SSH_KEY $SSH_OPTS"

TASK_DIR="~/tasks/$TASK"

# Create base directories
$SSH "$REMOTE" "mkdir -p $TASK_DIR/{output,logs}"

# Copy shared task brief and pipeline
$SCP "tasks/${TASK}/worker.md" "$REMOTE:$TASK_DIR/task.md"
$SCP "tasks/${TASK}/pipeline" "$REMOTE:$TASK_DIR/pipeline"

# Create one directory per persona, copy CLAUDE.md and optional instructions
for f in personas/*.md; do
  role=$(basename "$f" .md | tr 'A-Z' 'a-z')
  $SSH "$REMOTE" "mkdir -p $TASK_DIR/$role"
  $SCP "$f" "$REMOTE:$TASK_DIR/$role/CLAUDE.md"

  instructions="tasks/${TASK}/${role}.md"
  if [ -f "$instructions" ]; then
    $SCP "$instructions" "$REMOTE:$TASK_DIR/$role/instructions.md"
  fi
done

# Copy run script
$SCP run.sh "$REMOTE:~/run.sh"
$SSH "$REMOTE" "chmod +x ~/run.sh"

# Copy credentials if available
if [ -f .env ]; then
  $SCP .env "$REMOTE:$TASK_DIR/.env"
  echo "Copied .env to VPS"
else
  echo "Warning: No .env file found. Agents will have no service credentials."
fi
