#!/usr/bin/env bash
# Structure check for skills/planning/discovering-tech-changes. Run from repo root.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
cd "$(dirname "$0")/../../.." || exit 1
S=${DISCOVERING_SKILL_DIR:-skills/planning/discovering-tech-changes}

if [ ! -f "$S/SKILL.md" ]; then
  bad "$S/SKILL.md does not exist"
else
  fm=$(awk 'NR==1 && $0=="---"{f=1;next} f&&$0=="---"{exit} f{print}' "$S/SKILL.md")
  echo "$fm" | grep -qx 'name: discovering-tech-changes' || bad "frontmatter lacks 'name: discovering-tech-changes'"
  echo "$fm" | grep -qx 'disable-model-invocation: true' || bad "frontmatter lacks 'disable-model-invocation: true'"
  desc=$(echo "$fm" | sed -n 's/^description: //p')
  if [ -z "$desc" ]; then bad "description missing"; else
    case "$desc" in "Use when "*) ;; *) bad "description does not start with 'Use when '" ;; esac
    [ "${#desc}" -le 500 ] || bad "description is ${#desc} chars (> 500)"
  fi
  for h in "## Start" "## Steps" "## The brief" "## Rules"; do
    grep -qx "$h" "$S/SKILL.md" || bad "SKILL.md lacks heading '$h'"
  done
  words=$(wc -w < "$S/SKILL.md" | tr -d ' ')
  [ "$words" -le 900 ] || bad "SKILL.md has $words words (> 900)"
  # Evidence stays out of the body: no ticket ids.
  ! grep -qE 'ITV-[0-9]+' "$S/SKILL.md" || bad "SKILL.md mentions an ITV ticket (belongs in references/)"
  for k in "checkpoint" "plain" "reuse" "convention" "owner" "depth"; do
    grep -qi "$k" "$S/SKILL.md" || bad "SKILL.md does not mention '$k'"
  done
  # Every reference named in SKILL.md exists.
  for f in $(grep -o '`[a-z-]*\.md`' "$S/SKILL.md" | tr -d '`' | sort -u); do
    [ -f "$S/references/$f" ] || bad "SKILL.md names $f but references/$f does not exist"
  done
fi

if [ ! -f "$S/agents/openai.yaml" ]; then
  bad "$S/agents/openai.yaml does not exist"
else
  awk '/^policy:/{p=1;next} p&&/^[^ #]/{p=0} p&&/^[ \t]+allow_implicit_invocation: false[ \t]*$/{f=1} END{exit !f}' "$S/agents/openai.yaml" || bad "openai.yaml lacks 'allow_implicit_invocation: false'"
fi

for f in steps brief-template evidence; do
  [ -s "$S/references/$f.md" ] || bad "references/$f.md missing or empty"
done
if [ -f "$S/references/evidence.md" ]; then
  urls=$(grep -o 'https://' "$S/references/evidence.md" | wc -l | tr -d ' ')
  [ "$urls" -ge 10 ] || bad "references/evidence.md has $urls https:// URLs (< 10)"
fi
# No personal names from the source material leak into the skill.
if [ -d "$S" ]; then
  ! grep -rqiE 'henry|javier|constanza|romero|alejandro|yenny|trejos|leonardo|valencia' "$S" || bad "a person's name appears in the skill"
fi

if [ "$fail" -eq 0 ]; then echo "OK: structure checks passed"; fi
exit "$fail"
