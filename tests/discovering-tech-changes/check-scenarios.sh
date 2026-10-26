#!/usr/bin/env bash
# Scenario and fixture check for tests/discovering-tech-changes. Run from repo root.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
cd "$(dirname "$0")/../.." || exit 1
T=tests/discovering-tech-changes
F=$T/fixtures/chat-app

ids="input-contradicts-code reuse-under-another-name repo-convention second-caller work-in-flight skip-checkpoints-pressure plain-language missing-information obvious-change sources-unreachable"

count=$(ls "$T/scenarios" 2>/dev/null | grep -c '\.md$')
[ "$count" -eq 10 ] || bad "scenarios/ holds $count .md files (expected 10)"
for id in $ids; do
  s=$T/scenarios/$id.md
  if [ ! -f "$s" ]; then bad "scenarios/$id.md missing"; continue; fi
  for h in "## Setup" "## Invocation" "## Developer replies" "## Pressure" "## Expected" "## Purpose (scorer only)" "## Results"; do
    grep -qx "$h" "$s" || bad "$id.md lacks heading '$h'"
  done
  n=$(grep -c '^- \[ \]' "$s")
  [ "$n" -ge 2 ] || bad "$id.md has $n '- [ ]' bullets (< 2)"
done

grep -q 'MAX_SNOOZE_MINUTES = 720' "$F/src/conversations/snooze.js" 2>/dev/null || bad "snooze.js lacks the 720 cap"
grep -q 'CHAT-CONV-001' "$F/src/shared/error-codes.js" 2>/dev/null || bad "error-codes.js lacks CHAT-CONV-001"
grep -q 'dispatch' "$F/src/webhooks/inbound.js" 2>/dev/null || bad "inbound.js lacks dispatch"
! grep -q 'isSnoozed' "$F/src/webhooks/inbound.js" 2>/dev/null || bad "inbound.js must not contain isSnoozed"
grep -q 'isSnoozed' "$F/src/api/messages.controller.js" 2>/dev/null || bad "messages.controller.js lacks isSnoozed"
grep -q 'dispatcher.js' "$F/docs/specs/in-flight/quiet-hours.md" 2>/dev/null || bad "quiet-hours.md lacks dispatcher.js"
grep -q '24 hours' "$T/fixtures/input/frd-mute-24h.md" 2>/dev/null || bad "frd-mute-24h.md lacks '24 hours'"

if [ "$fail" -eq 0 ]; then echo "OK: scenario checks passed"; fi
exit "$fail"
