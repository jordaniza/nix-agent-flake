#!/usr/bin/env bash
set -euo pipefail

TASK="${1:?Usage: run.sh <TASK> [MAX_ROUNDS]}"
MAX_ROUNDS="${2:-5}"
TASK_DIR="$HOME/tasks/$TASK"
LOG_DIR="$TASK_DIR/logs"

if [ ! -d "$TASK_DIR" ]; then
  echo "Task directory not found: $TASK_DIR" >&2
  exit 1
fi

mkdir -p "$LOG_DIR"

log() { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG_DIR/run.log"; }

run_claude() {
  local role="$1" dir="$2" round="$3"
  local logfile="$LOG_DIR/${role}-r${round}.jsonl"

  cd "$dir"
  claude --dangerously-skip-permissions \
    -p "Do your work. Read CLAUDE.md for instructions." \
    --output-format stream-json --verbose 2>&1 \
    | tee "$logfile" \
    | jq -rj 'select(.type == "assistant") | .message.content[]?
      | if .type == "text" then .text + "\n"
        elif .type == "tool_use" then "[tool: \(.name)] \(.input | tostring)\n"
        else empty end' 2>/dev/null
  echo ""
}

for round in $(seq 1 "$MAX_ROUNDS"); do
  log "=== Round $round/$MAX_ROUNDS: Worker ==="
  run_claude worker "$TASK_DIR/worker" "$round"

  log "=== Round $round/$MAX_ROUNDS: Reviewer ==="
  run_claude reviewer "$TASK_DIR/reviewer" "$round"

  if grep -q "^DONE" "$TASK_DIR/worker/review.md" 2>/dev/null; then
    log "=== Approved on round $round ==="
    exit 0
  fi
done

log "=== Reached max rounds ($MAX_ROUNDS) without approval ==="
exit 1
