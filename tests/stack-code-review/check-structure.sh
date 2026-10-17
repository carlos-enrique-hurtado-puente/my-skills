#!/usr/bin/env bash
# Structure check for skills/stack-code-review. Run from repo root.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
cd "$(dirname "$0")/../.." || exit 1
S=skills/stack-code-review

if [ ! -f "$S/SKILL.md" ]; then
  bad "$S/SKILL.md does not exist"
else
  fm=$(awk 'NR==1 && $0=="---"{f=1;next} f&&$0=="---"{exit} f{print}' "$S/SKILL.md")
  echo "$fm" | grep -qx 'name: stack-code-review' || bad "frontmatter lacks 'name: stack-code-review'"
  echo "$fm" | grep -qx 'disable-model-invocation: true' || bad "frontmatter lacks 'disable-model-invocation: true'"
  desc=$(echo "$fm" | sed -n 's/^description: //p')
  if [ -z "$desc" ]; then bad "description missing"; else
    case "$desc" in "Use when "*) ;; *) bad "description does not start with 'Use when '" ;; esac
    [ "${#desc}" -le 500 ] || bad "description is ${#desc} chars (> 500)"
  fi
fi

if [ ! -f "$S/agents/openai.yaml" ]; then
  bad "$S/agents/openai.yaml does not exist"
else
  awk '/^policy:/{p=1;next} p&&/^[^ #]/{p=0} p&&/^[ \t]+allow_implicit_invocation: false[ \t]*$/{f=1} END{exit !f}' "$S/agents/openai.yaml" || bad "openai.yaml lacks 'allow_implicit_invocation: false'"
fi

[ ! -e skills/gcf-pr-review ] || bad "skills/gcf-pr-review still exists"
[ ! -e skills/gcf-code-review ] || bad "skills/gcf-code-review still exists"

# Stack pieces (design 6.3): frontmatter id/name/detect (>=1 signal) + six headings in order.
HEADINGS="Context detection|Checklist|How to use the skills|Clean Architecture in this stack|Severity notes|Common mistakes"
for f in "$S"/stacks/*.md; do
  [ -f "$f" ] || continue
  b=$(basename "$f")
  if [ "$(head -n 1 "$f")" != "---" ]; then bad "$b: no frontmatter"; continue; fi
  fm=$(awk 'NR==1{next} $0=="---"{exit} {print}' "$f")
  echo "$fm" | grep -qE '^id:[[:space:]]*[^[:space:]]' || bad "$b: frontmatter lacks id"
  echo "$fm" | grep -qE '^name:[[:space:]]*[^[:space:]]' || bad "$b: frontmatter lacks name"
  echo "$fm" | grep -qE '^detect:' || bad "$b: frontmatter lacks detect"
  echo "$fm" | grep -qE '^[[:space:]]+(dependencies|files|imports):[[:space:]]*\[[^]]*[^][:space:]][^]]*\]' || bad "$b: detect has no signal"
  got=$(grep -E "^## ($HEADINGS)[[:space:]]*$" "$f" | sed 's/^## //; s/[[:space:]]*$//' | tr '\n' '|')
  [ "$got" = "$HEADINGS|" ] || bad "$b: headings missing or out of order (got: $got)"
done

if [ "$fail" -eq 0 ]; then echo "OK: structure checks passed"; fi
exit "$fail"
