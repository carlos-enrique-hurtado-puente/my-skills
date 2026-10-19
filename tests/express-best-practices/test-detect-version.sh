#!/usr/bin/env bash
# Tests for skills/express-best-practices/scripts/detect-express-version.sh against fixture dirs.
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$ROOT/skills/express-best-practices/scripts/detect-express-version.sh"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
fail=0; nfail=0
ok()  { echo "PASS: $1"; }
bad() { echo "FAIL: $1"; fail=1; nfail=$((nfail+1)); }
t() { NAME="$1"; before=$nfail; }
done_t() { [ "$nfail" -eq "$before" ] && ok "$NAME"; }

w() { mkdir -p "$(dirname "$1/$2")"; printf '%s\n' "$3" > "$1/$2"; }   # w <dir> <path> <content>
newd() { local d="$TMP/$1"; rm -rf "$d"; mkdir -p "$d"; echo "$d"; }
pj() { # pj <dir> <path> <depkey> <range>
  w "$1" "$2" "{
  \"name\": \"x\",
  \"$3\": { \"express\": \"$4\" }
}"
}
OUT=""; RC=0
run() { OUT=$(cd "$TMP" && bash "$SCRIPT" --root "$1" 2>&1); RC=$?; }
expect() { # expect <expected-output-with-\n>
  local exp; exp=$(printf '%b' "$1")
  [ "$OUT" = "$exp" ] || { bad "$NAME: output differs"; echo "  expected:"; echo "$exp" | sed 's/^/    /'; echo "  got:"; echo "$OUT" | sed 's/^/    /'; }
}

t "caret-4"; d=$(newd c4); pj "$d" package.json dependencies '^4.19.0'; run "$d"
expect 'express: major=4 resolved=none declared=^4.19.0 dir=.\nstatus: ok'; done_t

t "tilde-5"; d=$(newd t5); pj "$d" package.json dependencies '~5.1.0'; run "$d"
expect 'express: major=5 resolved=none declared=~5.1.0 dir=.\nstatus: ok'; done_t

t "dev-only"; d=$(newd dev); pj "$d" package.json devDependencies '^4.18.0'; run "$d"
expect 'express: major=4 resolved=none declared=^4.18.0 dir=.\nstatus: ok'; done_t

t "resolved-wins"; d=$(newd rw); pj "$d" package.json dependencies '>=4'
w "$d" package-lock.json '{
  "lockfileVersion": 3,
  "packages": {
    "": { "name": "x" },
    "node_modules/express": {
      "version": "5.1.0",
      "resolved": "https://registry.npmjs.org/express/-/express-5.1.0.tgz"
    }
  }
}'; run "$d"
expect 'express: major=5 resolved=5.1.0 declared=>=4 dir=.\nstatus: ok'; done_t

t "lock-v1"; d=$(newd l1); pj "$d" package.json dependencies '^4.17.0'
w "$d" package-lock.json '{
  "lockfileVersion": 1,
  "dependencies": {
    "accepts": { "version": "1.3.8" },
    "express": {
      "version": "4.17.3",
      "requires": { "accepts": "~1.3.8" }
    }
  }
}'; run "$d"
expect 'express: major=4 resolved=4.17.3 declared=^4.17.0 dir=.\nstatus: ok'; done_t

t "ambiguous"; i=0
for r in 'latest' '*' '>=4 <6' '4 || 5' 'workspace:*' 'git+https://x/y.git'; do
  i=$((i+1)); d=$(newd amb$i); pj "$d" package.json dependencies "$r"; run "$d"
  nospace=$(printf '%s' "$r" | tr -d ' ')
  expect "express: major=unknown resolved=none declared=$nospace dir=.\nstatus: ok"
done; done_t

t "workspace-lock"; d=$(newd wl); w "$d" package.json '{ "name": "root", "workspaces": ["packages/*"] }'
pj "$d" packages/api/package.json dependencies '^4.0.0'
w "$d" package-lock.json '{
  "lockfileVersion": 3,
  "packages": {
    "node_modules/express": { "version": "4.21.2" }
  }
}'; run "$d"
expect 'express: major=4 resolved=4.21.2 declared=^4.0.0 dir=packages/api\nstatus: ok'; done_t

t "mixed-majors"; d=$(newd mm); pj "$d" apps/api5/package.json dependencies '^5.0.0'; pj "$d" apps/api4/package.json dependencies '^4.19.0'; run "$d"
expect 'express: major=4 resolved=none declared=^4.19.0 dir=apps/api4\nexpress: major=5 resolved=none declared=^5.0.0 dir=apps/api5\nstatus: ok'; done_t

t "skips-node-modules"; d=$(newd nm); pj "$d" node_modules/foo/package.json dependencies '^4.0.0'; run "$d"
expect 'status: no-express'; done_t

t "no-express"; d=$(newd ne); w "$d" package.json '{ "name": "x", "dependencies": { "koa": "^2.0.0" } }'; run "$d"
expect 'status: no-express'; done_t

t "no-package-json"; d=$(newd np); run "$d"
expect 'status: no-express'; done_t

t "dir-with-spaces"; d=$(newd sp); pj "$d" "my api/package.json" dependencies '^5.0.0'; run "$d"
expect 'express: major=5 resolved=none declared=^5.0.0 dir=my api\nstatus: ok'; done_t

t "bad-root"; run /nonexistent
[ "$RC" -eq 2 ] || bad "$NAME: exit code $RC, expected 2"
echo "$OUT" | grep -qx "status: error" || bad "$NAME: no status: error"
echo "$OUT" | grep -q "^message: " || bad "$NAME: no message line"; done_t

if [ "$fail" -eq 0 ]; then echo "ALL PASSED"; else echo "$nfail FAILED"; fi
exit "$fail"
