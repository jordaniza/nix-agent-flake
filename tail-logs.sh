#!/usr/bin/env bash
set -euo pipefail

REMOTE="${1:?Usage: tail-logs.sh <REMOTE> <SSH_KEY> <SSH_OPTS> <TASK> [POLL]}"
SSH_KEY="${2:?}"
SSH_OPTS="${3:-}"
TASK="${4:?}"
POLL="${5:-2}"

# shellcheck disable=SC2086
ssh -i "$SSH_KEY" $SSH_OPTS "$REMOTE" bash -s "$TASK" "$POLL" <<'EOF'
set -euo pipefail
TASK="$1"
POLL="$2"
LOG_DIR="$HOME/tasks/$TASK/logs"

# Wait for log directory
while [ ! -d "$LOG_DIR" ]; do
  echo "Waiting for $LOG_DIR to appear..."
  sleep "$POLL"
done
echo "Streaming logs for $TASK (poll=${POLL}s)..."
echo ""

SEEN_RUN=0
declare -A SEEN_JSONL
CURRENT_FILE=""

while true; do
  # --- run.log: stage progress ---
  if [ -f "$LOG_DIR/run.log" ]; then
    LINES=$(wc -l < "$LOG_DIR/run.log")
    if [ "$LINES" -gt "$SEEN_RUN" ]; then
      echo ""
      tail -n +$((SEEN_RUN + 1)) "$LOG_DIR/run.log" | head -n $((LINES - SEEN_RUN))
      SEEN_RUN=$LINES
    fi
  fi

  # --- JSONL: agent output ---
  for f in "$LOG_DIR"/*.jsonl; do
    [ -f "$f" ] || continue
    LINES=$(wc -l < "$f")
    PREV=${SEEN_JSONL["$f"]:-0}
    if [ "$LINES" -gt "$PREV" ]; then
      # Print a header when switching to a new log file
      if [ "$f" != "$CURRENT_FILE" ]; then
        CURRENT_FILE="$f"
        LABEL=$(basename "$f" .jsonl)
        echo ""
        echo "--- $LABEL ---"
      fi
      tail -n +$((PREV + 1)) "$f" | head -n $((LINES - PREV)) \
        | jq -rj 'select(.type == "assistant") | .message.content[]?
            | if .type == "text" then .text
              elif .type == "tool_use" then "\n__TOOL__\(.name)\n"
              else empty end' 2>/dev/null \
        | awk '
          function flush_tools() {
            if (n > 0) {
              printf "  >"
              for (i=1; i<=n; i++) {
                t = order[i]
                if (i > 1) printf ","
                if (count[t] > 1) printf " %s x%d", t, count[t]
                else printf " %s", t
              }
              printf "\n"
              delete count; delete seen; delete order; n=0
            }
          }
          /^__TOOL__/ {
            tool = substr($0, 9)
            count[tool]++
            if (!(tool in seen)) { seen[tool]=1; order[++n]=tool }
            next
          }
          /^[[:space:]]*$/ {
            # blank lines: swallow while buffering tools, print otherwise
            if (n > 0) next
            print
            next
          }
          {
            flush_tools()
            print
          }
          END { flush_tools() }' || true
      SEEN_JSONL["$f"]=$LINES
    fi
  done

  # --- exit when pipeline finishes ---
  if [ -f "$LOG_DIR/run.log" ] && grep -q "Pipeline completed" "$LOG_DIR/run.log" 2>/dev/null; then
    echo ""
    echo "Pipeline completed."
    exit 0
  fi

  sleep "$POLL"
done
EOF
