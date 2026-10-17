# Stack selection

Run this step after the changes are collected and before any criteria are applied. `<skill-dir>` is the folder containing SKILL.md. Pieces live in `<skill-dir>/stacks/*.md`. The script decides which pieces load and which piece owns each file: do not decide by looking at the diff.

## 1. Build the diff file list

Local mode, from inside the repo:

```bash
LIST=$(mktemp)
git diff --name-only <base>...HEAD > "$LIST"
bash <skill-dir>/scripts/detect-stacks.sh "$LIST"
```

GitHub mode has no checkout. **Do steps a-c in order; calling `detect-stacks.sh` before they finish (empty `--root`) is wrong:**

```bash
ROOT=$(mktemp -d); LIST=$(mktemp)
gh pr diff <pull_request_url> --name-only > "$LIST"
# (a) every package.json in the head tree
gh api "repos/<owner>/<repo>/git/trees/<headRefName>?recursive=1" --jq '.tree[].path | select(endswith("package.json"))'
# (b) for each package.json and each path in "$LIST" (skip deleted files), fetch it into "$ROOT":
mkdir -p "$ROOT/$(dirname <path>)"
gh api "repos/<owner>/<repo>/contents/<path>?ref=<headRefName>" --jq '.content' | base64 -d > "$ROOT/<path>"
# (c) only now, with "$ROOT" populated:
bash <skill-dir>/scripts/detect-stacks.sh --root "$ROOT" "$LIST"
```

Fork PRs: `<owner>/<repo>` and `ref` for (a) and (b) are the head repo (`gh pr view --json headRepositoryOwner,headRepository`) and `headRefName`, not the base repo. A truncated trees response (`"truncated": true`) means package.json files may be missing: note it in `Limitations`. Files over 1 MB return empty `content` from the contents API: use the git blobs API, else treat the file as unowned. Any fetch failure: treat that file as unowned and say so in `Limitations`.

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

A piece's checklist and its skills apply only to files that piece owns. For an unowned file, only the general criteria (`references/criteria.md`) plus model knowledge about its framework apply. Choose the recipe by the `owner:` value of the file you are commenting on:

| `owner:` of the commented file | Criteria allowed |
|---|---|
| `<piece id>` | General criteria + that piece's checklist |
| `none`, `unowned_hint` names a framework | General criteria + model knowledge of that framework (steps below) |
| `none`, `unowned_hint` is `unknown` | General criteria only; say so in `Limitations` |

Red flag: "this Express route has no idempotency key", "no IAM/auth check like the Cloud Function", "should use signals". That is a loaded piece's checklist or skills leaking onto a file it does not own. Drop the finding unless a general criterion (not the piece) supports it on its own merits.

For each distinct framework in the `unowned_hint` lines:

1. Apply the general criteria, plus what you know of the framework's conventions (for example, for Express: error-handling middleware, async handler wrapping, body-parsing setup).
2. Start the comment of EVERY finding on a file whose `owner:` is `none` (code or not) with `[model knowledge]` right after the Conventional Comments prefix, no exceptions (full rule in `references/output-format.md`). Findings on piece-owned files are never tagged.
3. Search the skills available in this session (names and descriptions) for one that names the framework. Consult the most specific one and note the others in `Limitations`. A consulted skill is listed on the `Stack(s):` bullet; its guidance still counts as model-level, not as a piece. Never present model knowledge as if it came from a piece.
4. If no such skill exists, `Limitations` recommends installing a skill for that framework.

## 5. Build the header from the output

Write the `Stack(s):` lines from the script output, not from memory or from what the code looks like. One bullet per stack:

- One bullet per `piece: <id> loaded` line: `- **Stack(s):** <piece name> — piece; skills: <consulted…> | missing: <…>`.
- One bullet per distinct framework in the `unowned_hint` lines (or `unknown`): `- **Stack(s):** <framework> — model knowledge (lower confidence)`, plus `; skills: <consulted via search>` if any. For `unknown`, write `- **Stack(s):** unknown — general criteria only`.
- `Limitations` collects: missing skills, files without a piece (with the skill recommendation or the skills found by search), `skipped_piece` lines, script errors.
- The `context_fields` of each loaded piece go in the header, labeled with the piece's field names.
