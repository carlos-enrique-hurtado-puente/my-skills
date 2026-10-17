# Stack selection

Run this step after the changes are collected and before any criteria are applied. `<skill-dir>` is the folder containing SKILL.md. Pieces live in `<skill-dir>/stacks/*.md`. The script decides which pieces load and which piece owns each file: do not decide by looking at the diff.

## 1. Build the diff file list

Local mode, from inside the repo:

```bash
LIST=$(mktemp)
git diff --name-only <base>...HEAD > "$LIST"
bash <skill-dir>/scripts/detect-stacks.sh "$LIST"
```

GitHub mode has no checkout, so materialize the inputs with read-only calls first:

```bash
ROOT=$(mktemp -d); LIST=$(mktemp)
gh pr diff <pull_request_url> --name-only > "$LIST"
# every package.json in the head tree
gh api "repos/<owner>/<repo>/git/trees/<headRefName>?recursive=1" --jq '.tree[].path | select(endswith("package.json"))'
# for each package.json and each path in "$LIST" (skip deleted files):
mkdir -p "$ROOT/$(dirname <path>)"
gh api "repos/<owner>/<repo>/contents/<path>?ref=<headRefName>" --jq '.content' | base64 -d > "$ROOT/<path>"
bash <skill-dir>/scripts/detect-stacks.sh --root "$ROOT" "$LIST"
```

The script takes the diff list file as its last argument; calling it without that file fails with `diff list file missing`: rerun it with the file, do not give up on it. Paths in the list are repo-relative. If the script reports `status: error`, fix the call and rerun; if it still fails, say so in `Limitations` and review with the general criteria only.

## 2. Read the output

| Line | Meaning |
|---|---|
| `piece: <id> loaded` | The piece owns at least one diff file. Read `stacks/<id>.md` fully. |
| `piece: <id> candidate-unused` | Detected in the repo, owns nothing in the diff. **Never read its file.** |
| `root: <id> <dir>` | The directory the piece applies to (`.` = repo root). |
| `owner: <path> <id>` | Use this piece's checklist for that file, and only for that file. |
| `owner: <path> none` | No piece owns the file. Use the fallback (section 4). |
| `unowned_hint: <path> <framework> <package.json>` | Framework clue for an unowned file (`unknown` if none). |
| `skipped_piece: <file> <reason>` | A malformed piece was ignored; list it in `Limitations`. |

## 3. Load and apply

1. For each `loaded` piece, read its file fully, then check the `skills` it declares: those available in this session are consulted as the piece's "How to use the skills" says; a missing one goes to `Limitations` and the review continues with the piece's checklist alone.
2. Fill the piece's `context_fields` following its "Context detection".
3. Evaluate every finding against the general criteria plus the checklist of the piece that **owns the commented file** (`owner:` line). One report for all stacks.

## 4. Fallback: files with `owner: ... none`

Apply the general criteria only. Add a `Limitations` note listing those files and, from `unowned_hint`, the framework you could not cover with a piece.

## 5. Build the header from the output

Write the `Stack(s):` lines from the script output, not from memory or from what the code looks like. One bullet per stack:

- One bullet per `piece: <id> loaded` line: `- **Stack(s):** <piece name> — piece; skills: <consulted…> | missing: <…>`.
- One bullet per distinct framework in the `unowned_hint` lines (or `unknown`): `- **Stack(s):** <framework> — model knowledge (lower confidence)`.
- `Limitations` collects: missing skills, files without a piece, `skipped_piece` lines, script errors.
- The `context_fields` of each loaded piece go in the header, labeled with the piece's field names.
