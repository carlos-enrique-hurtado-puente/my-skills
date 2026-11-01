#!/usr/bin/env bash
# Fails if any planning skill still names the old ~/.tech-specs folder. Run from repo root.
cd "$(dirname "$0")/../.." || exit 1
hits=$(grep -rn '\.tech-specs' skills/planning)
if [ -n "$hits" ]; then
  echo "$hits" | while IFS= read -r l; do
    f=${l%%:*}; rest=${l#*:}; n=${rest%%:*}
    echo "FAIL: $f:$n"
  done
  exit 1
fi
echo "OK: no old folder in skills"
