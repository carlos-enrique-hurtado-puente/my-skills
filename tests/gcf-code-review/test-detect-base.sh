#!/usr/bin/env bash
# Tests for skills/gcf-code-review/scripts/detect-base.sh against fixture repos.
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$ROOT/skills/gcf-code-review/scripts/detect-base.sh"
MK="$ROOT/tests/gcf-code-review/fixtures/make-local-repo.sh"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
fail=0; i=0
ok()  { echo "PASS: $1"; }
nfail=0
bad() { echo "FAIL: $1"; fail=1; nfail=$((nfail+1)); }
fixture() { local r="$TMP/r$RANDOM$RANDOM"; bash "$MK" "$r" "$@" >/dev/null 2>&1 && echo "$r"; }
run() { # run <dir> [args] -> sets OUT, RC
  local d="$1"; shift
  [ -d "$d" ] || { bad "$NAME: fixture missing"; OUT=""; RC=99; return; }
  OUT=$(cd "$d" && bash "$SCRIPT" "$@" 2>&1); RC=$?
}
has() { echo "$OUT" | grep -qx "$1" || { bad "$NAME: missing '$1'"; echo "$OUT" | sed 's/^/    /'; return 1; }; }
t() { NAME="$1"; before=$nfail; }
done_t() { [ "$nfail" -eq "$before" ] && ok "$NAME"; }

t "default"; d=$(fixture); run "$d"
[ "$RC" -eq 0 ] || bad "$NAME: exit $RC"
has "status: ok"; has "base: origin/develop"; has "base_is_remote: yes"; has "commits: 3"
has "files: 3"; has "deleted: 1"; has "merge_base: 1ab735e"; has "base_date: 2026-01-06"
has "uncommitted: no"; has "candidate: origin/develop 3 1 chosen"; has "candidate: origin/main 4 0"
done_t
t "from-main"; d=$(fixture --from-main); run "$d"
[ "$RC" -eq 0 ] || bad "$NAME: exit $RC"
has "base: origin/main"; has "status: ok"; done_t
t "no-origin"; d=$(fixture --no-origin); run "$d"
[ "$RC" -eq 0 ] || bad "$NAME: exit $RC"
has "base: develop"; has "base_is_remote: no"; echo "$OUT" | grep -q '^base_date' && bad "$NAME: base_date for local base"; done_t
t "base: main (bare)"; d=$(fixture); run "$d" main
has "base: origin/main"; has "commits: 4"; has "files: 4"; has "status: ok"; done_t
t "base: origin/main as-is"; d=$(fixture); run "$d" origin/main
has "base: origin/main"; has "commits: 4"; done_t
t "uncommitted"; d=$(fixture --uncommitted); run "$d"; has "uncommitted: yes"; done_t
t "on-base"; d=$(fixture --state on-base); run "$d"
[ "$RC" -eq 0 ] || bad "$NAME: exit $RC"; has "status: nothing-to-review"; has "commits: 0"; done_t
t "detached"; d=$(fixture --state detached); run "$d"
[ "$RC" -ne 0 ] || bad "$NAME: exit 0"; has "status: detached"; echo "$OUT" | grep -qi 'detached' || bad "$NAME: no message"; done_t
t "not a repo"; mkdir "$TMP/plain"; run "$TMP/plain"
[ "$RC" -ne 0 ] || bad "$NAME: exit 0"; has "status: not-a-repo"; done_t
[ "$fail" -eq 0 ] && echo "OK: all detect-base tests passed"
exit "$fail"
