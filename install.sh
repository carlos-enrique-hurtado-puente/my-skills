#!/usr/bin/env bash
# Installs the skills in skills/<category>/*/ as flat symlinks (by skill name) for Claude Code and/or Codex.
# Usage: bash install.sh [--claude] [--codex]   (no flag = both)
REPO="$(cd "$(dirname "$0")" && pwd)"

usage() { echo "Usage: bash install.sh [--claude] [--codex]" >&2; }

do_claude=0; do_codex=0
for arg in "$@"; do
  case "$arg" in
    --claude) do_claude=1 ;;
    --codex) do_codex=1 ;;
    *) echo "Unknown option: $arg" >&2; usage; exit 2 ;;
  esac
done
if [ "$do_claude" -eq 0 ] && [ "$do_codex" -eq 0 ]; then do_claude=1; do_codex=1; fi

failed=0

physical() { (cd "$1" 2>/dev/null && pwd -P); } # resolved path of a dir, empty if unreachable

link_skill() { # link_skill <skills-dir> <src>
  local dir="$1" src="$2" name dest cur
  name="$(basename "$src")"
  dest="$dir/$name"
  if [ -L "$dest" ]; then
    cur="$(readlink "$dest")"
    if [ "$cur" = "$src" ] || [ "$(physical "$dest")" = "$(physical "$src")" ]; then
      echo "ok: $dest already linked"
    elif [ "${cur%/}" = "$REPO/skills/$name" ]; then # this skill's path before categories
      if ln -sfn "$src" "$dest"; then
        echo "relinked: $dest -> $src"
      else
        echo "warning: could not relink $dest (see the error above)" >&2
        failed=1
      fi
    else
      echo "warning: $dest is a symlink to $cur; leaving it untouched" >&2
    fi
  elif [ -e "$dest" ]; then
    echo "warning: $dest already exists and is not a symlink; leaving it untouched" >&2
  elif mkdir -p "$dir" && ln -s "$src" "$dest"; then
    echo "linked: $dest -> $src"
  else
    echo "warning: could not link $dest (see the error above)" >&2
    failed=1
  fi
}

for src in "$REPO"/skills/*/*/; do
  src="${src%/}"
  [ -f "$src/SKILL.md" ] || continue
  [ "$do_claude" -eq 1 ] && link_skill "$HOME/.claude/skills" "$src"
  [ "$do_codex" -eq 1 ] && link_skill "$HOME/.agents/skills" "$src"
done

if [ "$do_claude" -eq 1 ] && [ -e "$HOME/.claude/skills/gcf-pr-review" ] && [ ! -L "$HOME/.claude/skills/gcf-pr-review" ]; then
  echo "warning: old skill found at $HOME/.claude/skills/gcf-pr-review; it was replaced by stack-code-review. Move it to a backup." >&2
fi
if [ "$do_claude" -eq 1 ] && { [ -e "$HOME/.claude/skills/reviewing-angular-prs" ] || [ -L "$HOME/.claude/skills/reviewing-angular-prs" ]; }; then
  echo "warning: old skill found at $HOME/.claude/skills/reviewing-angular-prs; it was replaced by stack-code-review (piece angular). Move it to $HOME/.claude/skills-backup/reviewing-angular-prs-<date>; it was left untouched." >&2
fi
for legacy in "$HOME/.claude/skills/gcf-code-review" "$HOME/.agents/skills/gcf-code-review"; do
  if [ -e "$legacy" ] || [ -L "$legacy" ]; then
    echo "warning: old skill found at $legacy; it was renamed to stack-code-review. Remove or move it manually; it was left untouched." >&2
  fi
done
exit "$failed"
