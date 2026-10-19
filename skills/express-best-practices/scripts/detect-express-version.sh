#!/usr/bin/env bash
# Express major-version detection for express-best-practices.
# Usage: bash detect-express-version.sh [--root <dir>]
#   Without --root: the git top level, else the current directory.
#   Reads the working tree only; never writes to it.
# Output (stable lines, sorted by dir):
#   express: major=<integer|unknown> resolved=<version|none> declared=<range-without-spaces> dir=<dir>
#   status: ok | no-express | error   (error also prints "message: ..." and exits 2)
# resolved = version of express in the package-lock.json of the package dir or the
# nearest ancestor up to the root (v2/v3 "node_modules/express", v1 "dependencies").
# It wins over declared. declared = dependencies.express, else devDependencies.express;
# it yields a major only if it matches ^[\^~=v]*[0-9]+(\.[0-9x*]+)*$.
# Works on bash 3.2; no jq, no associative arrays.
export LC_ALL=C

ROOTDIR=""
if [ "$1" = "--root" ]; then
  [ -n "$2" ] || { echo "status: error"; echo "message: --root needs a directory"; exit 2; }
  ROOTDIR="${2%/}"; [ -n "$ROOTDIR" ] || ROOTDIR="/"
fi
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

# lock_version: resolved express version from a package-lock.json on stdin (or nothing).
# Depth-aware scan of the JSON: v2/v3 = packages -> "node_modules/express" -> version;
# v1 = top-level "dependencies" -> express -> version. Nested/transitive entries are
# deeper, so they never match. The v2/v3 entry wins when both exist.
lock_version() {
  tr '\n' ' ' | awk '{
    s=$0; n=length(s); d=0; want=""
    for (i=1;i<=n;i++) {
      c=substr(s,i,1)
      if (c=="{") d++
      else if (c=="}") d--
      else if (c=="\"") {
        j=i+1; str=""
        while (j<=n) { e=substr(s,j,1); if (e=="\\") { str=str substr(s,j,2); j+=2; continue } if (e=="\"") break; str=str e; j++ }
        i=j; k=j+1
        while (substr(s,k,1)==" ") k++
        if (substr(s,k,1)==":") {
          key[d]=str
          if (d==3 && str=="version") {
            if (key[1]=="packages" && key[2]=="node_modules/express") want="v3"
            else if (key[1]=="dependencies" && key[2]=="express") want="v1"
          }
        } else if (want!="") {
          if (want=="v3") { print str; exit }
          if (v1=="") v1=str
          want=""
        }
      }
    }
    if (v1!="") print v1
  }'
}

# find_lock <dir>: print the nearest package-lock.json for a package dir ('.' = root).
find_lock() {
  local d="$1"
  while :; do
    if [ "$d" = "." ]; then [ -f "$ROOTDIR/package-lock.json" ] && echo "$ROOTDIR/package-lock.json"; return; fi
    [ -f "$ROOTDIR/$d/package-lock.json" ] && { echo "$ROOTDIR/$d/package-lock.json"; return; }
    case "$d" in */*) d="${d%/*}" ;; *) d="." ;; esac
  done
}

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
  lock=$(find_lock "$dir")
  [ -n "$lock" ] && resolved=$(lock_version < "$lock")
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
