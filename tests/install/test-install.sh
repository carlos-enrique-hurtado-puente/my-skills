#!/usr/bin/env bash
# Tests for install.sh. Always runs with a temporary HOME.
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INSTALL="$ROOT/install.sh"
TARGET="$ROOT/skills/gcf-code-review"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
nfail=0
ok()  { echo "PASS: $1"; }
bad() { echo "FAIL: $1"; nfail=$((nfail+1)); }
newhome() { H="$TMP/h$RANDOM$RANDOM"; mkdir -p "$H"; }
run() { OUT=$(HOME="$H" bash "$INSTALL" "$@" 2>"$TMP/err"); RC=$?; ERR=$(cat "$TMP/err"); }
check() { # check <name> <condition-exit-code>
  if [ "$2" -eq 0 ]; then ok "$1"; else bad "$1"; fi
}
points_to() { [ -L "$1" ] && [ "$(readlink "$1")" = "$TARGET" ]; }

# (a) fresh HOME without ~/.agents
newhome; run
[ "$RC" -eq 0 ] && points_to "$H/.claude/skills/gcf-code-review" && points_to "$H/.agents/skills/gcf-code-review"
check "a: fresh home creates both links" $?

# (b) second run is a no-op
before=$(ls -lR "$H/.claude" "$H/.agents" 2>/dev/null)
run
after=$(ls -lR "$H/.claude" "$H/.agents" 2>/dev/null)
[ "$RC" -eq 0 ] && [ "$before" = "$after" ] && [ -z "$ERR" ]
check "b: idempotent second run" $?

# (c) real dir at claude target
newhome; mkdir -p "$H/.claude/skills/gcf-code-review"; echo keep > "$H/.claude/skills/gcf-code-review/mine"
run
[ "$RC" -eq 0 ] && [ ! -L "$H/.claude/skills/gcf-code-review" ] && [ -f "$H/.claude/skills/gcf-code-review/mine" ] \
  && echo "$ERR" | grep -qi "warn" && points_to "$H/.agents/skills/gcf-code-review"
check "c: real dir untouched, warning, codex still linked" $?

# (d) symlink pointing elsewhere
newhome; mkdir -p "$H/.claude/skills" "$TMP/elsewhere"; ln -s "$TMP/elsewhere" "$H/.claude/skills/gcf-code-review"
run
[ "$RC" -eq 0 ] && [ "$(readlink "$H/.claude/skills/gcf-code-review")" = "$TMP/elsewhere" ] && echo "$ERR" | grep -qi "warn"
check "d: foreign symlink untouched, warning" $?

# (e) --codex only
newhome; run --codex
[ "$RC" -eq 0 ] && [ ! -e "$H/.claude" ] && points_to "$H/.agents/skills/gcf-code-review"
check "e: --codex creates no claude link" $?
newhome; run --claude
[ "$RC" -eq 0 ] && [ ! -e "$H/.agents" ] && points_to "$H/.claude/skills/gcf-code-review"
check "e2: --claude creates no codex link" $?

# (f) legacy gcf-pr-review
newhome; mkdir -p "$H/.claude/skills/gcf-pr-review"; echo old > "$H/.claude/skills/gcf-pr-review/SKILL.md"
run
[ "$RC" -eq 0 ] && echo "$ERR" | grep -q "gcf-pr-review" && [ -f "$H/.claude/skills/gcf-pr-review/SKILL.md" ] && [ ! -L "$H/.claude/skills/gcf-pr-review" ]
check "f: legacy gcf-pr-review warned, untouched" $?

# (g) link cannot be created (~/.claude is a file): explicit warning, exit 1, codex still linked
newhome; echo x > "$H/.claude"
run
[ "$RC" -eq 1 ] && echo "$ERR" | grep -q "warning: could not link $H/.claude/skills/gcf-code-review" \
  && points_to "$H/.agents/skills/gcf-code-review"
check "g: failed link warned, exit 1, codex still linked" $?

# (h) existing link to the same skill spelled differently: accepted, no warning
newhome; mkdir -p "$H/.claude/skills"; ln -s "$TARGET/" "$H/.claude/skills/gcf-code-review"
ln -s "$ROOT" "$TMP/alias$RANDOM" && ALIAS=$(ls -d "$TMP"/alias* | head -1)
mkdir -p "$H/.agents/skills"; ln -s "$ALIAS/skills/gcf-code-review" "$H/.agents/skills/gcf-code-review"
run
[ "$RC" -eq 0 ] && [ -z "$ERR" ] && echo "$OUT" | grep -q "ok: $H/.claude/skills/gcf-code-review" \
  && echo "$OUT" | grep -q "ok: $H/.agents/skills/gcf-code-review"
check "h: same target via trailing slash or symlinked path is ok, no warning" $?

# unknown flag
newhome; run --bogus
[ "$RC" -eq 2 ] && echo "$ERR" | grep -qi "usage"
check "unknown flag: usage + exit 2" $?

[ "$nfail" -eq 0 ] && echo "ALL PASS" || echo "$nfail FAILED"
[ "$nfail" -eq 0 ]
