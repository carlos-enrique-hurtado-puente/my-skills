#!/usr/bin/env bash
# Express major-version detection for express-best-practices.
# Usage: bash detect-express-version.sh [--root <dir>]
#   Without --root: the git top level, else the current directory.
#   Reads the working tree only; never writes to it.
# Output (stable lines, sorted by dir):
#   express: major=<integer|unknown> resolved=<version|none> declared=<range-without-spaces> dir=<dir>
#   status: ok | no-express | error   (error also prints "message: ..." and exits 2)
# resolved = version of express in the package-lock.json of the package dir or the
# nearest ancestor up to the root. Lookup order: v2/v3 "<pkg>/node_modules/express"
# (<pkg> = package dir relative to the lock's dir), then v2/v3 "node_modules/express",
# then v1 top-level "dependencies" -> "express". It wins over declared. declared = dependencies.express, else devDependencies.express;
# it yields a major only if it matches ^[\^~=v]*[0-9]+(\.[0-9x*]+)*$.
# Works on bash 3.2; no jq, no associative arrays.
export LC_ALL=C

usage_error() { echo "status: error"; echo "message: $1 (usage: detect-express-version.sh [--root <dir>])"; exit 2; }
ROOTDIR=""
case $# in
  0) ;;
  2) [ "$1" = "--root" ] || usage_error "unknown argument: $1"
     [ -n "$2" ] || usage_error "--root needs a directory"
     ROOTDIR="${2%/}"; [ -n "$ROOTDIR" ] || ROOTDIR="/" ;;
  *) [ "$1" = "--root" ] && [ $# -eq 1 ] && usage_error "--root needs a directory"
     usage_error "unexpected arguments: $*" ;;
esac
if [ -z "$ROOTDIR" ]; then
  ROOTDIR=$(git --no-optional-locks rev-parse --show-toplevel 2>/dev/null) || ROOTDIR="."
fi
[ -d "$ROOTDIR" ] || { echo "status: error"; echo "message: --root is not a directory"; exit 2; }

W=$(mktemp -d); trap 'rm -rf "$W"' EXIT

# dep_value <block>: express version string inside the given package.json block, read
# from stdin. Flattens to one line, takes the block up to its first closing brace
# (dependency maps hold no nested objects), then the value of "express".
dep_value() {
  tr '\n' ' ' | awk -v blk="$1" '{
    re="\"" blk "\"[ \t]*:[ \t]*[{][^}]*[}]"
    if (match($0, re)) {
      b=substr($0,RSTART,RLENGTH)
      if (match(b, /"express"[ \t]*:[ \t]*"[^"]*"/)) {
        v=substr(b,RSTART,RLENGTH); sub(/^"express"[ \t]*:[ \t]*"/,"",v); sub(/"$/,"",v); print v
      }
    }
  }'
}

# lock_table: express entries of a pretty-printed package-lock.json on stdin, one per
# line: "p<TAB><key><TAB><version>" for v2/v3 "packages" keys ending in node_modules/express,
# "d<TAB>express<TAB><version>" for the v1 top-level "dependencies" -> "express" entry.
# Line based (npm pretty-prints locks): sections are found by indentation, and only
# direct children of "packages"/"dependencies" and their direct "version" lines count,
# so nested or transitive entries never match.
lock_table() {
  awk '
  function ind(s) { match(s, /^[ \t]*/); return RLENGTH }
  function ver(s,  v) {
    if (!match(s, /"version"[ \t]*:[ \t]*"[^"]*"/)) return ""
    v = substr(s, RSTART, RLENGTH); sub(/^"version"[ \t]*:[ \t]*"/, "", v); sub(/"$/, "", v); return v
  }
  function emit(t, k, v) { if (!((t SUBSEP k) in seen)) { seen[t SUBSEP k] = 1; print t "\t" k "\t" v } }
  BEGIN { top = -1 }
  {
    i = ind($0)
    if (want != "") {
      if (i <= wind) want = ""
      else {
        if (eind < 0) eind = i
        if (i == eind && (v = ver($0)) != "") { emit(wtype, want, v); want = "" }
        next
      }
    }
    if ($0 !~ /^[ \t]*"/) next
    if (top < 0) top = i
    if (i == top) {
      sect = ""; cind = -1
      if ($0 ~ /^[ \t]*"packages"[ \t]*:[ \t]*[{]/) sect = "p"
      else if ($0 ~ /^[ \t]*"dependencies"[ \t]*:[ \t]*[{]/) sect = "d"
      next
    }
    if (sect == "" || i < top) next
    if (cind < 0) cind = i
    if (i != cind) next
    k = $0; sub(/^[ \t]*"/, "", k); sub(/".*$/, "", k)
    if (!(sect == "p" && k ~ /(^|\/)node_modules\/express$/) && !(sect == "d" && k == "express")) next
    if ($0 !~ /:[ \t]*[{]/) next
    if ((v = ver($0)) != "") { emit(sect, k, v); next }
    want = k; wtype = sect; wind = i; eind = -1
  }'
}

# lock_version <lockfile> <pkg>: resolved express version for package dir <pkg>
# (relative to the lock's dir, '.' = same dir). Each lock is parsed once and cached.
lock_version() {
  local n key
  n=$(awk -F'\t' -v f="$1" '$2 == f { print $1; exit }' "$W/lockindex")
  if [ -z "$n" ]; then
    n=$(($(wc -l < "$W/lockindex") + 1))
    lock_table < "$1" > "$W/lock.$n"
    printf '%s\t%s\n' "$n" "$1" >> "$W/lockindex"
  fi
  if [ "$2" = "." ]; then key="node_modules/express"; else key="$2/node_modules/express"; fi
  awk -F'\t' -v k="$key" '
    $1 == "p" && $2 == k { a = $3 }
    $1 == "p" && $2 == "node_modules/express" { b = $3 }
    $1 == "d" { c = $3 }
    END { if (a != "") print a; else if (b != "") print b; else if (c != "") print c }' "$W/lock.$n"
}

# find_lock <dir>: print the dir ('.' = root) of the nearest package-lock.json for a
# package dir, searching the dir and its ancestors up to the root.
find_lock() {
  local d="$1"
  while :; do
    if [ "$d" = "." ]; then [ -f "$ROOTDIR/package-lock.json" ] && echo "."; return; fi
    [ -f "$ROOTDIR/$d/package-lock.json" ] && { echo "$d"; return; }
    case "$d" in */*) d="${d%/*}" ;; *) d="." ;; esac
  done
}

: > "$W/lockindex"
(cd "$ROOTDIR" && find . -name node_modules -prune -o -type f -name package.json -print 2>/dev/null) \
  | sed 's|^\./||' | sort > "$W/pjlist"

: > "$W/out"
while IFS= read -r p; do
  [ -n "$p" ] || continue
  declared=$(dep_value dependencies < "$ROOTDIR/$p" 2>/dev/null)
  [ -n "$declared" ] || declared=$(dep_value devDependencies < "$ROOTDIR/$p" 2>/dev/null)
  [ -n "$declared" ] || continue
  case "$p" in */*) dir="${p%/*}" ;; *) dir="." ;; esac
  declared=$(printf '%s' "$declared" | tr -d ' \t')
  resolved=""
  ld=$(find_lock "$dir")
  if [ -n "$ld" ]; then
    if [ "$ld" = "." ]; then lock="$ROOTDIR/package-lock.json"; rel="$dir"
    else lock="$ROOTDIR/$ld/package-lock.json"; if [ "$dir" = "$ld" ]; then rel="."; else rel="${dir#"$ld"/}"; fi
    fi
    resolved=$(lock_version "$lock" "$rel")
  fi
  major=unknown
  if [ -n "$resolved" ]; then
    m=$(printf '%s' "$resolved" | sed -n 's/^[^0-9]*\([0-9][0-9]*\).*/\1/p')
    [ -n "$m" ] && major="$m"
  elif printf '%s\n' "$declared" | grep -Eq '^[\^~=v]*[0-9]+(\.[0-9x*]+)*$'; then
    major=$(printf '%s' "$declared" | sed -n 's/^[^0-9]*\([0-9][0-9]*\).*/\1/p')
  fi
  printf '%s\texpress: major=%s resolved=%s declared=%s dir=%s\n' "$dir" "$major" "${resolved:-none}" "$declared" "$dir" >> "$W/out"
done < "$W/pjlist"

if [ -s "$W/out" ]; then
  sort -t "$(printf '\t')" -k1,1 "$W/out" | cut -f2-; echo "status: ok"
else
  echo "status: no-express"
fi
