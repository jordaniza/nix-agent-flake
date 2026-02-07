#!/usr/bin/env bash
set -euo pipefail

TASK="${1:?Usage: run.sh <TASK>}"
TASK_DIR="$HOME/tasks/$TASK"
PIPELINE="$TASK_DIR/pipeline"
LOG_DIR="$TASK_DIR/logs"

if [ ! -d "$TASK_DIR" ]; then
  echo "Task directory not found: $TASK_DIR" >&2
  exit 1
fi

if [ ! -f "$PIPELINE" ]; then
  echo "Pipeline file not found: $PIPELINE" >&2
  exit 1
fi

mkdir -p "$LOG_DIR"

log() { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG_DIR/run.log"; }

run_claude() {
  local role="$1" dir="$2" logname="$3"
  local logfile="$LOG_DIR/${logname}.jsonl"

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

prev_stage=""

while read -r stage max_rounds agents_str; do
  [[ -z "$stage" || "$stage" == \#* ]] && continue
  read -ra agents <<< "$agents_str"
  log "=== Stage: $stage ==="

  if [ ${#agents[@]} -eq 1 ]; then
    log "=== $stage: ${agents[0]} (solo) ==="
    run_claude "${agents[0]}" "$TASK_DIR/${agents[0]}" "${stage}-${agents[0]}-r1"
  else
    primary="${agents[0]}"
    feedback="${agents[1]}"

    for round in $(seq 1 "$max_rounds"); do
      log "=== $stage round $round/$max_rounds: $primary ==="
      run_claude "$primary" "$TASK_DIR/$primary" "${stage}-${primary}-r${round}"

      log "=== $stage round $round/$max_rounds: $feedback ==="
      run_claude "$feedback" "$TASK_DIR/$feedback" "${stage}-${feedback}-r${round}"

      if [ -f "$TASK_DIR/status.tmp" ] && grep -q "^APPROVED" "$TASK_DIR/status.tmp"; then
        log "=== $stage approved on round $round ==="
        rm -f "$TASK_DIR/status.tmp"
        break
      fi
    done
  fi

  prev_stage="$stage"
done < "$PIPELINE"

log "=== Pipeline completed ==="
