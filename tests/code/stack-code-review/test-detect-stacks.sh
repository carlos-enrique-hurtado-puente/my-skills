#!/usr/bin/env bash
# Tests for skills/code/stack-code-review/scripts/detect-stacks.sh against tiny fixture repos.
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
SKILL="$ROOT/skills/code/stack-code-review"
SCRIPT="$SKILL/scripts/detect-stacks.sh"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
fail=0; nfail=0
ok()  { echo "PASS: $1"; }
bad() { echo "FAIL: $1"; fail=1; nfail=$((nfail+1)); }
t() { NAME="$1"; before=$nfail; }
done_t() { [ "$nfail" -eq "$before" ] && ok "$NAME"; }

# --- fixture helpers --------------------------------------------------------
w() { mkdir -p "$(dirname "$1/$2")"; printf '%s\n' "$3" > "$1/$2"; }   # w <dir> <path> <content>
PJ_FN='{
  "name": "fn",
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0"
  }
}'
PJ_NG='{
  "name": "web",
  "dependencies": { "@angular/core": "^19.0.0", "rxjs": "~7.8.0" },
  "devDependencies": { "typescript": "~5.6.0" }
}'
PJ_BOTH='{
  "name": "root",
  "dependencies": {
    "firebase-functions": "^5.0.0",
    "@angular/core": "^19.0.0"
  }
}'
PJ_EXPRESS='{
  "name": "svc",
  "dependencies": { "express": "^4.19.0" }
}'
commit() { # commit <dir>
  git -C "$1" init -q -b main
  git -C "$1" add -A
  git -C "$1" -c user.name=Test -c user.email=test@example.com commit -q -m init
}
build() { # build <name> -> creates $TMP/<name> (working files, no git yet)
  local d="$TMP/$1"; rm -rf "$d"; mkdir -p "$d"
  case "$1" in
    gcp-only)
      w "$d" functions/package.json "$PJ_FN"
      w "$d" functions/src/a.ts "export const a = 1;" ;;
    untouched-web)
      w "$d" functions/package.json "$PJ_FN"
      w "$d" functions/src/a.ts "export const a = 1;"
      w "$d" web/package.json "$PJ_NG"
      w "$d" web/src/app/x.component.ts "export class X {}" ;;
    mixed)
      w "$d" functions/package.json "$PJ_FN"
      w "$d" functions/src/a.ts "export const a = 1;"
      w "$d" web/package.json "$PJ_NG"
      w "$d" web/src/app/x.component.ts "export class X {}" ;;
    plain-service)
      w "$d" web/package.json "$PJ_NG"
      w "$d" web/src/app/data.service.ts "export class DataService { get() { return 1; } }" ;;
    root-shared-package)
      w "$d" package.json "$PJ_BOTH"
      w "$d" src/fn.ts "import { onRequest } from 'firebase-functions/v2/https';"
      w "$d" src/app/a.component.ts "export class A {}"
      w "$d" src/util.ts "export const u = () => 1;" ;;
    no-piece)
      w "$d" package.json "$PJ_EXPRESS"
      w "$d" src/routes.js "module.exports = {};" ;;
    docs-only)
      w "$d" package.json "$PJ_EXPRESS"
      w "$d" README.md "# readme" ;;
    peer-only)
      w "$d" package.json '{ "name": "lib", "peerDependencies": { "@angular/core": "^19.0.0" } }'
      w "$d" src/a.ts "export const a = 1;" ;;
    core-extra)
      w "$d" package.json '{ "name": "lib", "dependencies": { "@angular/core-extra": "^1.0.0" } }'
      w "$d" src/a.ts "export const a = 1;" ;;
    spaces)
      w "$d" "my fn/package.json" "$PJ_FN"
      w "$d" "my fn/src/a b.ts" "export const a = 1;" ;;
  esac
}
repo() { build "$1"; commit "$TMP/$1"; echo "$TMP/$1"; }

OUT=""
run() { # run <dir> <skilldir> <difflines...>   (git mode: cwd = repo)
  local d="$1" sk="$2"; shift 2
  printf '%s\n' "$@" > "$TMP/diff.txt"
  OUT=$(cd "$d" && bash "$sk/scripts/detect-stacks.sh" "$TMP/diff.txt" 2>&1)
}
run_root() { # run_root <dir> <difflines...>   (no repo: cwd elsewhere)
  local d="$1"; shift
  printf '%s\n' "$@" > "$TMP/diff.txt"
  OUT=$(cd "$TMP" && bash "$SCRIPT" --root "$d" "$TMP/diff.txt" 2>&1)
}
has()  { echo "$OUT" | grep -qxF -- "$1" || { bad "$NAME: missing '$1'"; echo "$OUT" | sed 's/^/    /'; }; }
hasnt(){ echo "$OUT" | grep -qE -- "$1" && { bad "$NAME: unexpected /$1/"; echo "$OUT" | sed 's/^/    /'; }; }

# --- cases ------------------------------------------------------------------
t "gcp-only"; d=$(repo gcp-only); run "$d" "$SKILL" functions/src/a.ts
has "piece: gcp-functions loaded"; has "owner: functions/src/a.ts gcp-functions"
has "root: gcp-functions functions"; has "status: ok"
hasnt "^piece: angular loaded"; hasnt "^unowned_hint"; done_t

t "untouched-web"; d=$(repo untouched-web); run "$d" "$SKILL" functions/src/a.ts
has "piece: gcp-functions loaded"; has "piece: angular candidate-unused"
has "root: angular web"; has "owner: functions/src/a.ts gcp-functions"; done_t

t "mixed"; d=$(repo mixed); run "$d" "$SKILL" functions/src/a.ts web/src/app/x.component.ts
has "piece: gcp-functions loaded"; has "piece: angular loaded"
has "owner: functions/src/a.ts gcp-functions"; has "owner: web/src/app/x.component.ts angular"; done_t

t "plain-service"; d=$(repo plain-service); run "$d" "$SKILL" web/src/app/data.service.ts
has "owner: web/src/app/data.service.ts angular"; has "piece: angular loaded"; has "piece: gcp-functions candidate-unused"; done_t

t "root-shared-package"; d=$(repo root-shared-package)
run "$d" "$SKILL" src/fn.ts src/app/a.component.ts src/util.ts
has "owner: src/fn.ts gcp-functions"; has "owner: src/app/a.component.ts angular"
has "owner: src/util.ts none"; has "root: gcp-functions ."; has "root: angular ."
has "unowned_hint: src/util.ts unknown package.json"; done_t

t "no-piece"; d=$(repo no-piece); run "$d" "$SKILL" src/routes.js
has "owner: src/routes.js none"; has "unowned_hint: src/routes.js express package.json"
hasnt "loaded"; done_t

t "docs-only"; d=$(repo docs-only); run "$d" "$SKILL" README.md
has "owner: README.md none"; hasnt "^unowned_hint"; hasnt "loaded"; has "status: ok"; done_t

t "bad-piece"; d=$(repo gcp-only)
cp -R "$SKILL" "$TMP/skill-bad"; echo "no frontmatter here" > "$TMP/skill-bad/stacks/broken.md"
run "$d" "$TMP/skill-bad" functions/src/a.ts
has "skipped_piece: broken.md no-frontmatter"; hasnt "^piece: broken"; has "piece: gcp-functions loaded"
has "owner: functions/src/a.ts gcp-functions"; has "status: ok"; done_t

t "peerDependencies ignored"; d=$(repo peer-only); run "$d" "$SKILL" src/a.ts
has "owner: src/a.ts none"; hasnt "^root: angular"; hasnt "loaded"; done_t

t "@angular/core-extra is not @angular/core"; d=$(repo core-extra); run "$d" "$SKILL" src/a.ts
has "owner: src/a.ts none"; hasnt "^root: angular"; hasnt "loaded"; done_t

t "add-piece-no-edits"; d=$(repo no-piece)
cp -R "$SKILL" "$TMP/skill-add"
printf -- '---\nid: express\nname: Express\ndetect:\n  dependencies: [express]\nskills: []\ncontext_fields: []\n---\n\n## Context detection\n## Checklist\n## How to use the skills\n## Clean Architecture in this stack\n## Severity notes\n## Common mistakes\n' > "$TMP/skill-add/stacks/express.md"
CS=$(STACK_SKILL_DIR="$TMP/skill-add" bash "$ROOT/tests/code/stack-code-review/check-structure.sh" 2>&1); echo "$CS" | grep -q "express.md" && bad "$NAME: new piece fails structure check"
run "$d" "$TMP/skill-add" src/routes.js
has "piece: express loaded"; has "owner: src/routes.js express"; hasnt "^unowned_hint"; done_t

t "paths with spaces"; d=$(repo spaces); run "$d" "$SKILL" "my fn/src/a b.ts"
has "owner: my fn/src/a b.ts gcp-functions"; has "root: gcp-functions my fn"; done_t

t "run from functions/ subdir in the mixed monorepo"; d=$(repo mixed)
run "$d" "$SKILL" functions/src/a.ts web/src/app/x.component.ts; root_run="$OUT"
printf '%s\n' functions/src/a.ts web/src/app/x.component.ts > "$TMP/diff.txt"
OUT=$(cd "$d/functions" && bash "$SCRIPT" "$TMP/diff.txt" 2>&1)
[ "$OUT" = "$root_run" ] || { bad "$NAME: subdir output differs from root"; diff <(echo "$root_run") <(echo "$OUT") | sed 's/^/    /'; }
has "owner: web/src/app/x.component.ts angular"; has "status: ok"
printf '%s\n' functions/src/a.ts > "$TMP/rel-diff.txt"
OUT=$(cd "$d/functions" && cp "$TMP/rel-diff.txt" ./rel-diff.txt && bash "$SCRIPT" rel-diff.txt 2>&1); rm -f "$d/functions/rel-diff.txt"
has "owner: functions/src/a.ts gcp-functions"; done_t

t "git mode never reads the working tree (file missing from HEAD is empty)"; d=$(repo no-piece)
cp -R "$SKILL" "$TMP/skill-imp"
printf -- '---\nid: marker\nname: Marker\ndetect:\n  imports: [zzmarker]\n---\n' > "$TMP/skill-imp/stacks/marker.md"
w "$d" src/new.js "require('zzmarker');"
run "$d" "$TMP/skill-imp" src/new.js
has "owner: src/new.js none"
printf '%s\n' src/new.js > "$TMP/diff.txt"
OUT=$(cd "$TMP" && bash "$SCRIPT" --root "$d" "$TMP/diff.txt" 2>&1)
has "owner: src/new.js none" ; done_t

t "piece id must equal filename / be well-formed / unique"
d=$(repo gcp-only); cp -R "$SKILL" "$TMP/skill-ids"
hdr() { printf -- '---\nid: %s\nname: N\ndetect:\n  dependencies: [zz]\n---\n' "$1"; }
hdr other > "$TMP/skill-ids/stacks/mismatch.md"
hdr "a.b" > "$TMP/skill-ids/stacks/a.b.md"
hdr "Up" > "$TMP/skill-ids/stacks/Up.md"
hdr "dup" > "$TMP/skill-ids/stacks/dup.md"
hdr "dup" > "$TMP/skill-ids/stacks/dup2.md"
hdr "star*" > "$TMP/skill-ids/stacks/star*.md"
run "$d" "$TMP/skill-ids" functions/src/a.ts
has "skipped_piece: mismatch.md id-mismatch"; has "skipped_piece: a.b.md bad-id"
has "skipped_piece: Up.md bad-id"; has "skipped_piece: star*.md bad-id"
has "skipped_piece: dup.md duplicate-id"; has "skipped_piece: dup2.md duplicate-id"
hasnt "^piece: (other|a.b|Up|dup|dup2|star)"; has "piece: gcp-functions loaded"; has "status: ok"
CS=$(STACK_SKILL_DIR="$TMP/skill-ids" bash "$ROOT/tests/code/stack-code-review/check-structure.sh" 2>&1)
echo "$CS" | grep -q "mismatch.md: id does not equal filename" || bad "$NAME: check-structure misses id-mismatch"
echo "$CS" | grep -q "duplicate id" || bad "$NAME: check-structure misses duplicate id"
echo "$CS" | grep -q "a.b.md: id 'a.b' is not" || bad "$NAME: check-structure misses bad id"
done_t

# --- --root mode on plain directories (no .git), identical to git mode -------
for c in mixed root-shared-package; do
  t "--root equals git mode: $c"
  build "$c"; rm -rf "$TMP/$c.plain"; cp -R "$TMP/$c" "$TMP/$c.plain"; commit "$TMP/$c"
  [ -e "$TMP/$c.plain/.git" ] && bad "$NAME: plain copy has .git"
  if [ "$c" = mixed ]; then set -- functions/src/a.ts web/src/app/x.component.ts
  else set -- src/fn.ts src/app/a.component.ts src/util.ts; fi
  run "$TMP/$c" "$SKILL" "$@"; git_out="$OUT"
  run_root "$TMP/$c.plain" "$@"; root_out="$OUT"
  [ "$git_out" = "$root_out" ] || { bad "$NAME: outputs differ"; diff <(echo "$git_out") <(echo "$root_out") | sed 's/^/    /'; }
  [ "$(echo "$root_out" | grep -c '^owner:')" -eq "$#" ] || bad "$NAME: owner line count"
  echo "$root_out" | grep -qx "status: ok" || bad "$NAME: no status ok"
  done_t
done

t "--root skips node_modules"; build gcp-only; mkdir -p "$TMP/gcp-only/node_modules/x"
w "$TMP/gcp-only" node_modules/x/package.json '{ "dependencies": { "@angular/core": "1" } }'
run_root "$TMP/gcp-only" functions/src/a.ts
echo "$OUT" | grep -q '^root: angular' && bad "$NAME: angular came from node_modules"
has "piece: gcp-functions loaded"; done_t

if [ "$fail" -eq 0 ]; then echo "ALL PASSED"; else echo "$nfail FAILED"; fi
exit "$fail"
