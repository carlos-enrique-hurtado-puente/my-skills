#!/usr/bin/env bash
# Structure check for skills/planning/verifying-spec-facts. Run from repo root.
fail=0
bad() { echo "FAIL: $1"; fail=1; }
cd "$(dirname "$0")/../../.." || exit 1
S=${VERIFY_SKILL_DIR:-skills/planning/verifying-spec-facts}

if [ ! -f "$S/SKILL.md" ]; then
  bad "$S/SKILL.md does not exist"
else
  fm=$(awk 'NR==1 && $0=="---"{f=1;next} f&&$0=="---"{exit} f{print}' "$S/SKILL.md")
  echo "$fm" | grep -qx 'name: verifying-spec-facts' || bad "frontmatter lacks 'name: verifying-spec-facts'"
  echo "$fm" | grep -qx 'disable-model-invocation: true' || bad "frontmatter lacks 'disable-model-invocation: true'"
  desc=$(echo "$fm" | sed -n 's/^description: //p')
  if [ -z "$desc" ]; then bad "description missing"; else
    case "$desc" in "Use when "*) ;; *) bad "description does not start with 'Use when '" ;; esac
    [ "${#desc}" -le 500 ] || bad "description is ${#desc} chars (> 500)"
  fi
  for h in "## Start" "## Verify" "## Outcome" "## Rules"; do
    grep -qx "$h" "$S/SKILL.md" || bad "SKILL.md lacks heading '$h'"
  done
  grep -qF 'How it works today' "$S/SKILL.md" || bad "SKILL.md does not name the brief heading 'How it works today'"
  for h in '## Facts that changed' '## Decisions affected' '## Next step'; do
    grep -qF -- "\`$h\`" "$S/SKILL.md" || bad "SKILL.md does not name the report heading '$h'"
  done
  for n in '/reviewing-tech-specs' '/discovering-tech-changes' '/writing-tech-specs' 'git --no-optional-locks'; do
    grep -qF -- "$n" "$S/SKILL.md" || bad "SKILL.md does not mention $n"
  done
  ! grep -qE 'ITV-[0-9]+' "$S/SKILL.md" || bad "SKILL.md mentions an ITV ticket"
fi

if [ ! -f "$S/agents/openai.yaml" ]; then
  bad "$S/agents/openai.yaml does not exist"
else
  awk '/^policy:/{p=1;next} p&&/^[^ #]/{p=0} p&&/^[ \t]+allow_implicit_invocation: false[ \t]*$/{f=1} END{exit !f}' "$S/agents/openai.yaml" || bad "openai.yaml lacks 'allow_implicit_invocation: false'"
fi

T=tests/planning/verifying-spec-facts
for f in README.md fixtures/brief-mute-old.md fixtures/review-mute-old.md scenarios/all-facts-hold.md scenarios/fact-changed.md scenarios/no-review.md; do
  [ -s "$T/$f" ] || bad "$T/$f missing or empty"
done
[ -d "$T/fixtures/chat-app/src" ] || bad "$T/fixtures/chat-app missing"
# Re-verify commands in the fixture brief must work against chat-app (copy, commit, run, clean up).
if [ -d "$T/fixtures/chat-app/src" ]; then
  tmp=$(mktemp -d); cp -R "$T/fixtures/chat-app" "$tmp/app"
  ( cd "$tmp/app" && git init -q && git add -A && git -c user.email=t@t -c user.name=t commit -qm fixture ) >/dev/null 2>&1
  out=$(cd "$tmp/app" && git --no-optional-locks grep -n "MAX_SNOOZE_MINUTES" -- src/)
  [ -n "$out" ] || bad "chat-app: MAX_SNOOZE_MINUTES re-verify command finds nothing"
  out=$(cd "$tmp/app" && git --no-optional-locks grep -n "isSnoozed" -- src/webhooks/ src/jobs/ src/notifications/)
  [ -z "$out" ] || bad "chat-app: isSnoozed appears where the brief says no check"
  rm -rf "$tmp"
fi

if [ "$fail" -eq 0 ]; then echo "OK: structure checks passed"; fi
exit "$fail"
