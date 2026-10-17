#!/usr/bin/env bash
# Structure check for skills/gcf-code-review. Run from repo root.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
S=skills/gcf-code-review

if [ ! -f "$S/SKILL.md" ]; then
  bad "$S/SKILL.md does not exist"
else
  fm=$(awk 'NR==1 && $0=="---"{f=1;next} f&&$0=="---"{exit} f{print}' "$S/SKILL.md")
  echo "$fm" | grep -qx 'name: gcf-code-review' || bad "frontmatter lacks 'name: gcf-code-review'"
  echo "$fm" | grep -qx 'disable-model-invocation: true' || bad "frontmatter lacks 'disable-model-invocation: true'"
  desc=$(echo "$fm" | sed -n 's/^description: //p')
  case "$desc" in "Use when"*) ;; *) bad "description does not start with 'Use when'" ;; esac
  [ "${#desc}" -le 500 ] || bad "description is ${#desc} chars (> 500)"
  [ -n "$desc" ] || bad "description missing"
fi

if [ ! -f "$S/agents/openai.yaml" ]; then
  bad "$S/agents/openai.yaml does not exist"
else
  grep -q 'allow_implicit_invocation: false' "$S/agents/openai.yaml" || bad "openai.yaml lacks 'allow_implicit_invocation: false'"
fi

[ ! -e skills/gcf-pr-review ] || bad "skills/gcf-pr-review still exists"

if [ "$fail" -eq 0 ]; then echo "OK: structure checks passed"; fi
exit "$fail"
