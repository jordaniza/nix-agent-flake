#!/usr/bin/env bash
set -euo pipefail

TASK="${1:?Usage: setup-task.sh <TASK> <REMOTE> <SSH_KEY>}"
REMOTE="$2"
SSH_KEY="$3"

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
SSH="ssh -i $SSH_KEY $SSH_OPTS"

TASK_DIR="~/tasks/$TASK"

# Build the remote directory layout in a local staging dir
STAGING=$(mktemp -d)
trap "rm -rf $STAGING" EXIT

mkdir -p "$STAGING"/{output,logs}

# Shared task brief: use task.md if it exists, fall back to worker.md
if [ -f "tasks/${TASK}/task.md" ]; then
  cp "tasks/${TASK}/task.md" "$STAGING/task.md"
else
  cp "tasks/${TASK}/worker.md" "$STAGING/task.md"
fi
cp "tasks/${TASK}/pipeline" "$STAGING/pipeline"

# Per-persona directories with CLAUDE.md and optional instructions
for f in personas/*.md; do
  role=$(basename "$f" .md | tr 'A-Z' 'a-z')
  mkdir -p "$STAGING/$role"
  cp "$f" "$STAGING/$role/CLAUDE.md"

  instructions="tasks/${TASK}/${role}.md"
  if [ -f "$instructions" ]; then
    cp "$instructions" "$STAGING/$role/instructions.md"
  fi
done

# Credentials
if [ -f .env ]; then
  cp .env "$STAGING/.env"
else
  echo "Warning: No .env file found. Agents will have no service credentials."
fi

# Single transfer: tar pipe over one SSH connection
$SSH "$REMOTE" "mkdir -p $TASK_DIR"
tar cf - -C "$STAGING" . | $SSH "$REMOTE" "tar xf - -C $TASK_DIR"

# Run script lives at ~/run.sh (outside task dir) — one extra transfer
cat run.sh | $SSH "$REMOTE" "cat > ~/run.sh && chmod +x ~/run.sh"

echo "Task $TASK deployed to $REMOTE"
