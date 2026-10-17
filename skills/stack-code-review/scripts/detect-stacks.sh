#!/usr/bin/env bash
# Stack piece detection and file ownership for stack-code-review (design 6.11.5).
# Usage: bash detect-stacks.sh [--root <dir>] <diff-file-list-file>
#   <diff-file-list-file>: one diff path per line (repo-relative).
#   Without --root: run inside the git repo; package.json files come from
#     `git ls-tree -r HEAD` and contents from `git show HEAD:<path>` (read-only);
#     a file missing from HEAD reads as empty (never the working tree). The script
#     first cd's to the repo top level, so it can run from any subdirectory.
#   With --root <dir>: no git at all; package.json files are found by walking <dir>
#     (skipping node_modules) and contents are read from <dir>/<path>.
# Output (stable "key: value" lines):
#   piece: <id> loaded|candidate-unused
#   root: <id> <dir>                  ('.' = repo root)
#   owner: <path> <id>|none
#   unowned_hint: <path> <framework-or-unknown> <nearest-package.json-or-none>
#   skipped_piece: <file> <reason>    (no-frontmatter, missing-id, bad-id, id-mismatch,
#                                      duplicate-id, missing-name, no-detect-signals)
#   A piece's id must equal its filename (stacks/<id>.md) and match ^[a-z0-9][a-z0-9-]*$.
#   status: ok
# Pieces live in "$(dirname "$0")/../stacks/*.md". Works on bash 3.2; no jq, no
# associative arrays. Heuristics are documented inline.
export LC_ALL=C
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
STACKS="$SELF_DIR/../stacks"
G() { git --no-optional-locks "$@"; }

ROOTDIR=""
if [ "$1" = "--root" ]; then
  [ -n "$2" ] || { echo "status: error"; echo "message: --root needs a directory"; exit 2; }
  ROOTDIR="${2%/}"; shift 2
fi
DIFF="$1"
[ -n "$DIFF" ] && [ -f "$DIFF" ] || { echo "status: error"; echo "message: diff list file missing"; exit 2; }
[ -z "$ROOTDIR" ] || [ -d "$ROOTDIR" ] || { echo "status: error"; echo "message: --root is not a directory"; exit 2; }
case "$DIFF" in /*) ;; *) DIFF="$(cd "$(dirname "$DIFF")" && pwd)/$(basename "$DIFF")" ;; esac
if [ -z "$ROOTDIR" ]; then
  TOP=$(G rev-parse --show-toplevel 2>/dev/null) && [ -n "$TOP" ] && cd "$TOP" 2>/dev/null \
    || { echo "status: error"; echo "message: not inside a git repository"; exit 2; }
fi

W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
mkdir -p "$W/pj" "$W/p"

# read_file <path>: file content on stdout (empty/failed if unreadable)
read_file() {
  if [ -n "$ROOTDIR" ]; then cat "$ROOTDIR/$1" 2>/dev/null
  else G show "HEAD:$1" 2>/dev/null; fi
}

# deps_of <block-regex>: names of keys inside the given package.json block(s).
# Heuristic: flatten the file to one line, find each `"<block>": { ... }` (first
# closing brace; dependency maps contain no nested objects), then take every
# `"key":` inside it. Fine for well-formed package.json.
deps_of() {
  tr '\n' ' ' | awk -v blk="$1" '{
    s=$0; re="\"(" blk ")\"[ \t]*:[ \t]*[{][^}]*[}]"
    while (match(s, re)) {
      b=substr(s,RSTART,RLENGTH); s=substr(s,RSTART+RLENGTH)
      sub(/^[^{]*[{]/,"",b)
      while (match(b,/"[^"]+"[ \t]*:/)) {
        k=substr(b,RSTART+1,RLENGTH-1); sub(/".*/,"",k); print k
        b=substr(b,RSTART+RLENGTH)
      }
    }
  }'
}

# --- package.json discovery --------------------------------------------------
if [ -n "$ROOTDIR" ]; then
  (cd "$ROOTDIR" && find . -name node_modules -prune -o -type f -name package.json -print 2>/dev/null) \
    | sed 's|^\./||' | sort > "$W/pjlist"
else
  G ls-tree -r -z --name-only HEAD 2>/dev/null | tr '\0' '\n' \
    | grep -E '(^|/)package\.json$' | grep -vE '(^|/)node_modules/' | sort > "$W/pjlist"
fi
i=0
while IFS= read -r p; do
  [ -n "$p" ] || continue
  i=$((i+1))
  read_file "$p" > "$W/pj/$i.raw"
  deps_of 'dependencies|devDependencies' < "$W/pj/$i.raw" > "$W/pj/$i.all"
  deps_of 'dependencies' < "$W/pj/$i.raw" > "$W/pj/$i.prod"
done < "$W/pjlist"
pj_index() { grep -nxF -- "$1" "$W/pjlist" | head -n 1 | cut -d: -f1; }

# --- piece parsing -----------------------------------------------------------
# Frontmatter = lines between the first two `---`. Lists are inline: [a, "b"].
# list_of <key> reads frontmatter on stdin and prints one item per line.
list_of() {
  awk -v key="$1" '
    $0 ~ "^[ \t]*" key "[ \t]*:" {
      v=$0; sub(/^[^:]*:[ \t]*/,"",v)
      sub(/^\[/,"",v); sub(/\][ \t]*$/,"",v)
      n=split(v, a, ",")
      for (j=1;j<=n;j++) { x=a[j]; gsub(/^[ \t"\047]+|[ \t"\047]+$/,"",x); if (x!="") print x }
      exit
    }'
}
ID_RE='^[a-z0-9][a-z0-9-]*$'
: > "$W/pieces"; : > "$W/skipped"; : > "$W/allids"
# pass 1: every piece file's declared id (to detect duplicates)
for f in "$STACKS"/*.md; do
  [ -f "$f" ] || continue
  [ "$(head -n 1 "$f")" = "---" ] || continue
  awk 'NR==1{next} $0=="---"{exit} {print}' "$f" | sed -n 's/^id:[[:space:]]*//p' | head -n 1 | tr -d '"'"'"' \t' >> "$W/allids"
done
for f in "$STACKS"/*.md; do
  [ -f "$f" ] || continue
  base=$(basename "$f")
  if [ "$(head -n 1 "$f")" != "---" ]; then echo "skipped_piece: $base no-frontmatter" >> "$W/skipped"; continue; fi
  fm=$(awk 'NR==1{next} $0=="---"{exit} {print}' "$f")
  id=$(printf '%s\n' "$fm" | sed -n 's/^id:[[:space:]]*//p' | head -n 1 | tr -d '"'"'"' \t')
  name=$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)
  if [ -z "$id" ]; then echo "skipped_piece: $base missing-id" >> "$W/skipped"; continue; fi
  if ! printf '%s\n' "$id" | grep -Eq "$ID_RE"; then echo "skipped_piece: $base bad-id" >> "$W/skipped"; continue; fi
  if [ "$(grep -cxF -- "$id" "$W/allids")" -gt 1 ]; then echo "skipped_piece: $base duplicate-id" >> "$W/skipped"; continue; fi
  if [ "$base" != "$id.md" ]; then echo "skipped_piece: $base id-mismatch" >> "$W/skipped"; continue; fi
  if [ -z "$name" ]; then echo "skipped_piece: $base missing-name" >> "$W/skipped"; continue; fi
  detect=$(printf '%s\n' "$fm" | awk '/^detect:/{d=1;next} d&&/^[^ \t#]/{d=0} d{print}')
  for k in dependencies files imports; do printf '%s\n' "$detect" | list_of "$k" > "$W/p/$id.$k"; done
  if [ -z "$(cat "$W/p/$id.dependencies" "$W/p/$id.files" "$W/p/$id.imports")" ]; then
    echo "skipped_piece: $base no-detect-signals" >> "$W/skipped"; rm -f "$W/p/$id."*; continue
  fi
  echo "$id" >> "$W/pieces"
done

set -f   # ids are validated, but never glob-expand unquoted lists below

# --- roots: dirs of package.json files that declare a piece's dependency -------
while IFS= read -r id; do
  : > "$W/p/$id.roots"
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    n=$(pj_index "$p")
    hit=no
    while IFS= read -r dep; do
      [ -n "$dep" ] && grep -qxF -- "$dep" "$W/pj/$n.all" && { hit=yes; break; }
    done < "$W/p/$id.dependencies"
    [ "$hit" = yes ] || continue
    case "$p" in */*) echo "${p%/*}" ;; *) echo "." ;; esac >> "$W/p/$id.roots"
  done < "$W/pjlist"
done < "$W/pieces"

# --- ownership ----------------------------------------------------------------
glob_match() { # glob_match <glob> <path>; `**/x` also matches a top-level x
  local g="$1" p="$2"
  case "$p" in $g) return 0 ;; esac
  case "$g" in '**/'*) case "$p" in ${g#\*\*/}) return 0 ;; esac ;; esac
  return 1
}
in_set() { case " $1 " in *" $2 "*) return 0 ;; esac; return 1; }

# decide <path> <ids...>: print the single owner id decided by files globs then
# imports (substring in content), or nothing. Ambiguous stages narrow the set.
decide() {
  local path="$1"; shift
  local set="$*" m cnt id g imp stage
  for stage in files imports; do
    m=""; cnt=0
    for id in $set; do
      if [ "$stage" = files ]; then
        while IFS= read -r g; do
          [ -n "$g" ] && glob_match "$g" "$path" && { m="$m $id"; cnt=$((cnt+1)); break; }
        done < "$W/p/$id.files"
      else
        [ -s "$W/content" ] || continue
        while IFS= read -r imp; do
          [ -n "$imp" ] && grep -qF -- "$imp" "$W/content" && { m="$m $id"; cnt=$((cnt+1)); break; }
        done < "$W/p/$id.imports"
      fi
    done
    if [ "$cnt" -eq 1 ]; then echo "${m# }"; return; fi
    [ "$cnt" -gt 1 ] && set="${m# }"
  done
}

nearest_pj() { # nearest_pj <path> -> path of the closest enclosing package.json, or empty
  local d="$1"
  while :; do
    case "$d" in */*) d="${d%/*}"; grep -qxF -- "$d/package.json" "$W/pjlist" && { echo "$d/package.json"; return; } ;;
      *) grep -qxF -- "package.json" "$W/pjlist" && echo "package.json"; return ;; esac
  done
}

: > "$W/owners"; : > "$W/hints"
ALL=$(tr '\n' ' ' < "$W/pieces")
while IFS= read -r path || [ -n "$path" ]; do
  [ -n "$path" ] || continue
  read_file "$path" > "$W/content"
  best=-1; tied=""
  for id in $ALL; do
    while IFS= read -r r; do
      [ -n "$r" ] || continue
      if [ "$r" = "." ]; then len=0
      else case "$path" in "$r"/*) len=${#r} ;; *) continue ;; esac; fi
      if [ "$len" -gt "$best" ]; then best=$len; tied="$id"
      elif [ "$len" -eq "$best" ] && ! in_set "$tied" "$id"; then tied="$tied $id"; fi
    done < "$W/p/$id.roots"
  done
  owner=""
  set -- $tied
  if [ "$#" -eq 1 ]; then owner="$1"
  elif [ "$#" -gt 1 ]; then owner=$(decide "$path" $tied)
  else owner=$(decide "$path" $ALL); fi
  [ -n "$owner" ] || owner=none
  echo "owner: $path $owner" >> "$W/owners"
  if [ "$owner" = none ]; then
    case "$path" in
      *.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.java)
        pj=$(nearest_pj "$path"); fw=unknown
        if [ -n "$pj" ]; then
          n=$(pj_index "$pj")
          for cand in express react next vue fastify @nestjs/core koa; do
            if grep -qxF -- "$cand" "$W/pj/$n.prod"; then
              case "$cand" in @nestjs/core) fw=nestjs ;; *) fw=$cand ;; esac; break
            fi
          done
        fi
        echo "unowned_hint: $path $fw ${pj:-none}" >> "$W/hints" ;;
    esac
  fi
done < "$DIFF"

# --- output -------------------------------------------------------------------
# One piece line per valid piece file ("candidate-unused" = loaded nowhere, whether or
# not it has a root).
for id in $ALL; do
  if awk -v id="$id" '$1=="owner:" && $NF==id {f=1} END{exit !f}' "$W/owners"; then echo "piece: $id loaded"; else echo "piece: $id candidate-unused"; fi
done
for id in $ALL; do
  while IFS= read -r r; do [ -n "$r" ] && echo "root: $id $r"; done < "$W/p/$id.roots"
done
cat "$W/owners" "$W/hints" "$W/skipped"
echo "status: ok"
