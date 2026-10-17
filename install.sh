#!/usr/bin/env bash
# Installs the skills in skills/*/ as symlinks for Claude Code and/or Codex.
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

link_skill() { # link_skill <skills-dir> <src>
  local dir="$1" src="$2" name dest cur
  name="$(basename "$src")"
  dest="$dir/$name"
  if [ -L "$dest" ]; then
    cur="$(readlink "$dest")"
    if [ "$cur" = "$src" ]; then
      echo "ok: $dest already linked"
    else
      echo "warning: $dest is a symlink to $cur; leaving it untouched" >&2
    fi
  elif [ -e "$dest" ]; then
    echo "warning: $dest already exists and is not a symlink; leaving it untouched" >&2
  else
    mkdir -p "$dir" && ln -s "$src" "$dest" && echo "linked: $dest -> $src"
  fi
}

for src in "$REPO"/skills/*/; do
  src="${src%/}"
  [ -f "$src/SKILL.md" ] || continue
  [ "$do_claude" -eq 1 ] && link_skill "$HOME/.claude/skills" "$src"
  [ "$do_codex" -eq 1 ] && link_skill "$HOME/.agents/skills" "$src"
done

if [ "$do_claude" -eq 1 ] && [ -e "$HOME/.claude/skills/gcf-pr-review" ] && [ ! -L "$HOME/.claude/skills/gcf-pr-review" ]; then
  echo "warning: old skill found at $HOME/.claude/skills/gcf-pr-review; it was replaced by gcf-code-review. Move it to a backup (see README, Migración)." >&2
fi
exit 0
