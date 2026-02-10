#!/usr/bin/env bash
set -euo pipefail

TASK="${1:?Usage: run.sh <TASK>}"
TASK_DIR="$HOME/tasks/$TASK"
PIPELINE="$TASK_DIR/pipeline"
LOG_DIR="$TASK_DIR/logs"
STATE_LOG="$TASK_DIR/state.log"

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
  local session_file="$TASK_DIR/.session-${role}"
  local started_file="$TASK_DIR/.session-${role}.active"

  # Generate session ID if needed
  if [ ! -f "$session_file" ]; then
    uuidgen > "$session_file"
  fi
  local sid
  sid=$(cat "$session_file")

  cd "$dir"

  local -a session_args=()
  if [ -f "$started_file" ]; then
    session_args=(-r "$sid" -p "Continue your work. Check for new feedback.")
  else
    session_args=(--session-id "$sid" -p "Do your work. Read CLAUDE.md for instructions.")
  fi

  claude --dangerously-skip-permissions \
    "${session_args[@]}" \
    --output-format stream-json --verbose < /dev/null 2>&1 \
    | tee "$logfile" \
    | jq -rj 'select(.type == "assistant") | .message.content[]?
      | if .type == "text" then .text + "\n"
        elif .type == "tool_use" then "[tool: \(.name)] \(.input | tostring)\n"
        else empty end' 2>/dev/null
  echo ""

  touch "$started_file"
}

# --- Resume logic ---

stage_status() {
  local stage="$1"
  if [ ! -f "$STATE_LOG" ]; then
    echo "pending"
    return
  fi
  # Check for terminal states (approved/exhausted)
  if grep -qE "^${stage}:[0-9]+ (approved|exhausted)$" "$STATE_LOG"; then
    echo "done"
    return
  fi
  # Check for completed rounds (in-progress stage)
  local last_round
  last_round=$(grep -oP "^${stage}:\K[0-9]+" "$STATE_LOG" | tail -1)
  if [ -n "$last_round" ]; then
    echo "$last_round"
    return
  fi
  echo "pending"
}

if [ -f "$STATE_LOG" ]; then
  log "=== Resuming from existing state.log ==="
  echo "resumed" >> "$STATE_LOG"
fi

# --- Pipeline execution ---

while read -r stage max_rounds agents_str <&3; do
  [[ -z "$stage" || "$stage" == \#* ]] && continue
  read -ra agents <<< "$agents_str"

  status=$(stage_status "$stage")
  if [ "$status" = "done" ]; then
    log "=== Skipping $stage (already completed) ==="
    continue
  fi

  start_round=1
  if [ "$status" != "pending" ]; then
    start_round=$((status + 1))
    log "=== Resuming $stage from round $start_round ==="
  fi

  log "=== Stage: $stage ==="

  if [ ${#agents[@]} -eq 1 ]; then
    log "=== $stage: ${agents[0]} (solo) ==="
    run_claude "${agents[0]}" "$TASK_DIR/${agents[0]}" "${stage}-${agents[0]}-r1"
    echo "${stage}:1 approved" >> "$STATE_LOG"
  else
    primary="${agents[0]}"
    feedback="${agents[1]}"
    approved=false

    for round in $(seq "$start_round" "$max_rounds"); do
      log "=== $stage round $round/$max_rounds: $primary ==="
      run_claude "$primary" "$TASK_DIR/$primary" "${stage}-${primary}-r${round}"

      log "=== $stage round $round/$max_rounds: $feedback ==="
      lines_before=$(wc -l < "$TASK_DIR/$feedback/review-log.md" 2>/dev/null || echo 0)
      run_claude "$feedback" "$TASK_DIR/$feedback" "${stage}-${feedback}-r${round}"

      if tail -n +"$((lines_before + 1))" "$TASK_DIR/$feedback/review-log.md" 2>/dev/null | grep -q "^APPROVED"; then
        log "=== $stage approved on round $round ==="
        echo "${stage}:${round} approved" >> "$STATE_LOG"
        approved=true
        break
      fi

      echo "${stage}:${round}" >> "$STATE_LOG"
    done

    if [ "$approved" = false ]; then
      log "=== $stage exhausted after $max_rounds rounds ==="
      echo "${stage}:${max_rounds} exhausted" >> "$STATE_LOG"
    fi
  fi
done 3< "$PIPELINE"

log "=== Pipeline completed ==="
