#!/usr/bin/env bash
# The rules (P1-P9), the numbered checklist and the four references are copied between
# writing-tech-specs and reviewing-tech-specs. Fail if they drift. Run from anywhere.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
cd "$(dirname "$0")/../../.." || exit 1
A=${WRITING_SKILL_DIR:-skills/planning/writing-tech-specs}
B=${REVIEWING_SKILL_DIR:-skills/planning/reviewing-tech-specs}

for d in "$A" "$B"; do
  [ -f "$d/SKILL.md" ] || bad "$d/SKILL.md missing"
done
if [ "$fail" -eq 0 ]; then
  for n in 1 2 3 4 5 6 7 8 9; do
    a=$(grep "^- \*\*P$n " "$A/SKILL.md")
    b=$(grep "^- \*\*P$n " "$B/SKILL.md")
    [ -n "$a" ] || bad "P$n rule line missing in $A/SKILL.md"
    [ "$a" = "$b" ] || bad "P$n rule line differs between the two SKILL.md files"
    a=$(grep "^$n\. \*\*P$n\*\* " "$A/SKILL.md")
    b=$(grep "^$n\. \*\*P$n\*\* " "$B/SKILL.md")
    [ -n "$a" ] || bad "checklist line $n missing in $A/SKILL.md"
    [ "$a" = "$b" ] || bad "checklist line $n differs between the two SKILL.md files"
  done
  for f in content statements decisions-contracts evidence; do
    cmp -s "$A/references/$f.md" "$B/references/$f.md" || bad "references/$f.md differs or is missing"
  done
fi
if [ "$fail" -eq 0 ]; then echo "OK: rules in sync"; fi
exit "$fail"
