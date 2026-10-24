#!/usr/bin/env bash
# Structure check for skills/writing-tech-specs. Run from repo root.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
cd "$(dirname "$0")/../.." || exit 1
S=${SPECS_SKILL_DIR:-skills/writing-tech-specs}

if [ ! -f "$S/SKILL.md" ]; then
  bad "$S/SKILL.md does not exist"
else
  fm=$(awk 'NR==1 && $0=="---"{f=1;next} f&&$0=="---"{exit} f{print}' "$S/SKILL.md")
  echo "$fm" | grep -qx 'name: writing-tech-specs' || bad "frontmatter lacks 'name: writing-tech-specs'"
  echo "$fm" | grep -qx 'disable-model-invocation: true' || bad "frontmatter lacks 'disable-model-invocation: true'"
  desc=$(echo "$fm" | sed -n 's/^description: //p')
  if [ -z "$desc" ]; then bad "description missing"; else
    case "$desc" in "Use when "*) ;; *) bad "description does not start with 'Use when '" ;; esac
    [ "${#desc}" -le 500 ] || bad "description is ${#desc} chars (> 500)"
  fi
  # All nine principles and the checklist live in the body.
  for p in P1 P2 P3 P4 P5 P6 P7 P8 P9; do
    grep -q "^- \*\*$p " "$S/SKILL.md" || bad "SKILL.md has no rule line for $p"
  done
  for h in "## Terms" "## Before writing" "## Rules" "## Before freezing"; do
    grep -qx "$h" "$S/SKILL.md" || bad "SKILL.md lacks heading '$h'"
  done
  # Evidence stays out of the body: no ticket ids.
  ! grep -qE 'ITV-[0-9]+' "$S/SKILL.md" || bad "SKILL.md mentions an ITV ticket (belongs in references/)"
fi

if [ ! -f "$S/agents/openai.yaml" ]; then
  bad "$S/agents/openai.yaml does not exist"
else
  awk '/^policy:/{p=1;next} p&&/^[^ #]/{p=0} p&&/^[ \t]+allow_implicit_invocation: false[ \t]*$/{f=1} END{exit !f}' "$S/agents/openai.yaml" || bad "openai.yaml lacks 'allow_implicit_invocation: false'"
fi

for f in content statements decisions-contracts evidence; do
  [ -s "$S/references/$f.md" ] || bad "references/$f.md missing or empty"
done
# Every reference named in SKILL.md exists.
for f in $(grep -o '`[a-z-]*\.md`' "$S/SKILL.md" | tr -d '`' | sort -u); do
  [ -f "$S/references/$f" ] || bad "SKILL.md names $f but references/$f does not exist"
done
# No personal names from the source material leak into the skill.
! grep -rqiE 'henry|leonardo|v[ií]ctor|romero|valencia|amador' "$S" || bad "a person's name appears in the skill"

if [ "$fail" -eq 0 ]; then echo "OK: structure checks passed"; fi
exit "$fail"
