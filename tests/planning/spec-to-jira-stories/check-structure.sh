#!/usr/bin/env bash
# Structure check for skills/planning/spec-to-jira-stories. Run from repo root.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
cd "$(dirname "$0")/../../.." || exit 1
S=${SPEC_JIRA_SKILL_DIR:-skills/planning/spec-to-jira-stories}

if [ ! -f "$S/SKILL.md" ]; then
  bad "$S/SKILL.md does not exist"
else
  fm=$(awk 'NR==1 && $0=="---"{f=1;next} f&&$0=="---"{exit} f{print}' "$S/SKILL.md")
  echo "$fm" | grep -qx 'name: spec-to-jira-stories' || bad "frontmatter lacks 'name: spec-to-jira-stories'"
  echo "$fm" | grep -qx 'disable-model-invocation: true' || bad "frontmatter lacks 'disable-model-invocation: true'"
  desc=$(echo "$fm" | sed -n 's/^description: //p')
  if [ -z "$desc" ]; then bad "description missing"; else
    case "$desc" in "Use when "*) ;; *) bad "description does not start with 'Use when '" ;; esac
    [ "${#desc}" -le 500 ] || bad "description is ${#desc} chars (> 500)"
  fi
  for h in "## Inputs" "## Reading the spec" "## Deciding the breakdown" "## Ticket content" "## Draft and creation"; do
    grep -qx "$h" "$S/SKILL.md" || bad "SKILL.md lacks heading '$h'"
  done
  words=$(wc -w < "$S/SKILL.md" | tr -d ' ')
  [ "$words" -le 900 ] || bad "SKILL.md has $words words (> 900)"
  # Evidence stays out of the body: no ticket ids.
  ! grep -qE 'ITV-[0-9]+' "$S/SKILL.md" || bad "SKILL.md mentions an ITV ticket (belongs in references/)"
  for k in "emoji" "confirm" "epic" "reference ticket"; do
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

for f in splitting sub-tasks ticket-content evidence; do
  [ -s "$S/references/$f.md" ] || bad "references/$f.md missing or empty"
done
if [ -f "$S/references/evidence.md" ]; then
  urls=$(grep -o 'https://' "$S/references/evidence.md" | wc -l | tr -d ' ')
  [ "$urls" -ge 10 ] || bad "references/evidence.md has $urls https:// URLs (< 10)"
fi
# No personal names from the source material leak into the skill.
if [ -d "$S" ]; then
  ! grep -rqiE 'henry|javier|constanza|romero|alejandro' "$S" || bad "a person's name appears in the skill"
fi

if [ "$fail" -eq 0 ]; then echo "OK: structure checks passed"; fi
exit "$fail"
