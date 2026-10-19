#!/usr/bin/env bash
# Structure check for skills/express-best-practices. Run from repo root.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
cd "$(dirname "$0")/../.." || exit 1
S=${EXPRESS_SKILL_DIR:-skills/express-best-practices}
R="$S/references"

if [ ! -f "$S/SKILL.md" ]; then
  bad "$S/SKILL.md does not exist"
else
  fm=$(awk 'NR==1 && $0=="---"{f=1;next} f&&$0=="---"{exit} f{print}' "$S/SKILL.md")
  echo "$fm" | grep -qx 'name: express-best-practices' || bad "frontmatter lacks 'name: express-best-practices'"
  echo "$fm" | grep -qx 'disable-model-invocation: true' || bad "frontmatter lacks 'disable-model-invocation: true'"
  desc=$(echo "$fm" | sed -n 's/^description: //p')
  if [ -z "$desc" ]; then bad "description missing"; else
    case "$desc" in "Use when "*) ;; *) bad "description does not start with 'Use when '" ;; esac
    [ "${#desc}" -le 500 ] || bad "description is ${#desc} chars (> 500)"
  fi
  words=$(wc -w < "$S/SKILL.md" | tr -d ' ')
  [ "$words" -lt 500 ] || bad "SKILL.md is $words words including frontmatter (>= 500)"
fi

if [ ! -f "$S/agents/openai.yaml" ]; then
  bad "$S/agents/openai.yaml does not exist"
else
  awk '/^policy:/{p=1;next} p&&/^[^ #]/{p=0} p&&/^[ \t]+allow_implicit_invocation: false[ \t]*$/{f=1} END{exit !f}' "$S/agents/openai.yaml" || bad "openai.yaml lacks 'allow_implicit_invocation: false'"
fi

ALLIDS=""
for pair in request-handling:REQ errors:ERR security:SEC production:PRD express-4:V4 express-5:V5; do
  name=${pair%%:*}; prefix=${pair##*:}
  f="$R/$name.md"
  if [ ! -f "$f" ]; then bad "$f does not exist"; continue; fi
  rows=0
  while IFS= read -r line; do
    case "$line" in "| "*-[0-9]*" | "*) ;; *) continue ;; esac
    id=${line#| }; id=${id%% *}
    case "$id" in [A-Z]*-[0-9]*) ;; *) continue ;; esac
    rows=$((rows+1))
    if ! echo "$line" | grep -qE '^\| (REQ|ERR|SEC|PRD|V4|V5)-[0-9]+ \| .+ \| (O|C) \| https://[^ ]+ \|$'; then
      bad "$name.md: malformed row for $id"
    fi
    case "$id" in "$prefix"-*) ;; *) bad "$name.md: $id does not use prefix $prefix" ;; esac
    case " $ALLIDS " in *" $id "*) bad "duplicate ID $id" ;; esac
    ALLIDS="$ALLIDS $id"
  done < "$f"
  [ "$rows" -ge 1 ] || bad "$name.md has no rule rows"
  if grep -qiE 'SOLID|folder structure|directory structure|naming convention|dependency rule|repository pattern|use case' "$f"; then
    bad "$name.md contains an out-of-scope word"
  fi
  if [ -f "$S/SKILL.md" ]; then
    grep -qF "$name.md" "$S/SKILL.md" || bad "SKILL.md does not link $name.md"
  fi
done

if [ "$fail" -eq 0 ]; then echo "OK: structure checks passed"; fi
exit "$fail"
