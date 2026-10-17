#!/usr/bin/env bash
# Base detection for gcf-code-review local mode. Read-only git only.
# Usage (from inside the repo): bash detect-base.sh [base]
# Prints stable "key: value" lines; "status:" is always printed. Exit 0 for ok and
# nothing-to-review, non-zero otherwise. Works on bash 3.2.
G() { git --no-optional-locks "$@"; }
fin() { # fin <status> <exit> <message>
  echo "status: $1"; [ -n "$3" ] && echo "message: $3"; exit "$2"
}
has() { G rev-parse --verify -q "$1" >/dev/null 2>&1; }

G rev-parse --is-inside-work-tree >/dev/null 2>&1 || fin not-a-repo 1 "not a git repository"
has HEAD || fin unborn 1 "nothing committed yet (HEAD is unborn)"
G symbolic-ref -q HEAD >/dev/null 2>&1 || fin detached 1 "HEAD is detached: check out the branch to review and rerun"

echo "branch: $(G rev-parse --abbrev-ref HEAD)"
echo "head: $(G rev-parse --short HEAD)"
if [ -n "$(G status --porcelain 2>/dev/null)" ]; then echo "uncommitted: yes"; else echo "uncommitted: no"; fi

count() { G rev-list --count "$1" 2>/dev/null; }
base=""; cand=""   # cand lines: ahead behind notHeadTarget order ref
if [ $# -ge 1 ] && [ -n "$1" ]; then
  arg="$1"
  case "$arg" in
    */*|refs/*) has "$arg" && base="$arg" ;;
    *) if has "refs/remotes/origin/$arg"; then base="origin/$arg"
       elif has "refs/heads/$arg"; then base="$arg"; fi ;;
  esac
  [ -n "$base" ] || fin base-unresolved 1 "base '$arg' does not resolve; ask the user for another"
  cand="$(count "$base..HEAD") $(count "HEAD..$base") 0 0 $base"
else
  headt=$(G symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null); headt="${headt#origin/}"
  order=0; seen=" "
  for x in develop main master $headt; do
    [ -n "$x" ] || continue
    case "$seen" in *" $x "*) continue ;; esac
    seen="$seen$x "; order=$((order+1))
    if has "refs/remotes/origin/$x"; then r="origin/$x"
    elif has "refs/heads/$x"; then r="$x"
    else continue; fi
    nh=1; [ "$x" = "$headt" ] && nh=0
    cand="$cand$(count "$r..HEAD") $(count "HEAD..$r") $nh $order $r
"
  done
  [ -n "$cand" ] || fin no-candidate 1 "no develop/main/master or origin/HEAD base exists: ask the user for the base"
  base=$(printf '%s' "$cand" | sort -k1,1n -k2,2n -k3,3n -k4,4n | head -n 1 | awk '{print $5}')
fi

printf '%s\n' "$cand" | awk 'NF{print $1, $2, $5}' | while read -r a b r; do
  if [ "$r" = "$base" ]; then echo "candidate: $r $a $b chosen"; else echo "candidate: $r $a $b"; fi
done
echo "base: $base"
if has "refs/remotes/$base"; then
  echo "base_is_remote: yes"; echo "base_date: $(G log -1 --format=%cs "$base")"
else echo "base_is_remote: no"; fi
mb=$(G merge-base "$base" HEAD 2>/dev/null) || fin unrelated 1 "no merge-base between $base and HEAD (unrelated histories)"
echo "merge_base: $(G rev-parse --short "$mb")"
n=$(count "$base..HEAD"); echo "commits: $n"
ns=$(G diff --name-status "$base...HEAD")
if [ -n "$ns" ]; then
  echo "files: $(printf '%s\n' "$ns" | wc -l | tr -d ' ')"
  echo "deleted: $(printf '%s\n' "$ns" | grep -c '^D')"
else echo "files: 0"; echo "deleted: 0"; fi
if [ "$n" -eq 0 ]; then fin nothing-to-review 0 "nothing to review against $base"; fi
echo "status: ok"
