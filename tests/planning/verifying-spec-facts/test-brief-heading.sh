#!/usr/bin/env bash
# The heading verifying-spec-facts looks for must exist in the brief template. Run from repo root.
cd "$(dirname "$0")/../../.." || exit 1
H='How it works today'
fail=0
grep -qF "$H" skills/planning/discovering-tech-changes/references/brief-template.md || { echo "FAIL: '$H' not in brief-template.md"; fail=1; }
[ -f skills/planning/verifying-spec-facts/SKILL.md ] || { echo "FAIL: skills/planning/verifying-spec-facts/SKILL.md missing"; fail=1; }
if [ -f skills/planning/verifying-spec-facts/SKILL.md ]; then
  grep -qF "$H" skills/planning/verifying-spec-facts/SKILL.md || { echo "FAIL: '$H' not in verifying-spec-facts/SKILL.md"; fail=1; }
fi
[ "$fail" -eq 0 ] && echo "OK: brief heading in sync"
exit "$fail"
