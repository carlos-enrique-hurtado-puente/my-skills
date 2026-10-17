# Output format (mandatory)

Deliver **only** these three sections, in this order. No preamble, no extra sections.

**Language:** the templates below are in English. Translate headings, field labels, table column headers, verdict and architecture-level labels, and prose into the language of the user's request; keep only enum values (`COMPLETED`/`BLOCKED`, `blocking`/`non-blocking`/`nitpick`), Conventional Comments prefixes and code identifiers in English.

## 1. Change analysis

```markdown
## Change analysis

- **Review status:** `<COMPLETED | BLOCKED>`
- **Source:** `<GitHub PR | Local branch>`
- **Spec source:** `<file <path> | <tool used> (<url>) | pasted | none>`
<source block>
- **Stack(s):** `<Name> — <piece | model knowledge (lower confidence)>; skills: <consulted…> | missing: <…>`
<context_fields>
- **Relevant files:** `<list>`
- **Functional summary:** `<summary>`
- **Spec reviewed:** `<yes/no>`
- **PR comments reviewed:** `<yes/no | N/A>`
- **Limitations:** `<concrete limitations>`
```

`<source block>` by source:

| Source | Fields |
|---|---|
| `GitHub PR` | **PR:** `#<number> — <title>` · **PR URL** · **Head branch** · **Base branch** · **Author** |
| `Local branch` | **Repo** (folder name or `origin` name) · **Head branch** · **HEAD** (short sha) · **Base ref** · **Merge-base** (short sha) · **Commits reviewed** (count) |

`PR comments reviewed` is `N/A` for `Local branch`.

`Stack(s):` is one bullet per stack, built from the `detect-stacks.sh` output (see `references/stack-selection.md`): one per `loaded` piece (source `piece`) and one per framework of unowned files (source `model knowledge (lower confidence)`, no skills line unless one was consulted).

`<context_fields>` is one bullet per `context_fields` entry of each loaded piece, in the piece's order, labeled with the piece's field name and its value or `Undetermined` (for example `- **Generation:** ...`). With no loaded piece there are none.

`Limitations` also lists: declared piece skills that are missing; stacks or files without a piece (and the recommendation to install a skill for that framework, or the skill found by search); skipped pieces; script errors.

If the review is `BLOCKED`, say so clearly and do not invent findings.

## 2. Findings

A single Markdown table, one row per finding, exactly these columns in this order:

```markdown
## Findings

| # | File | Line(s) / Reference | Type | Severity | Comment to post |
|---|------|---------------------|------|----------|-----------------|
| 1 | `path/to/file` | `line, function or block` | `issue` | `blocking` | `issue (blocking): ...` |
```

Rules:
- Do not drop or reorder columns.
- Row order: `blocking` → `non-blocking` → `nitpick`.
- "Comment to post" = the complete comment, ready to paste as an inline PR review comment.
- Row test: if one defect could be fixed without fixing the other (missing `await` vs. read-modify-write race; wrong ratio vs. missing input validation), they are two rows. Cross-reference with "see finding N" instead of merging.
- No free text between rows; any extra explanation goes inside the cell.
- A finding that rests on framework conventions for a stack with no piece starts its comment, right after the prefix, with `[model knowledge]` (e.g. `issue (non-blocking): [model knowledge] ...`). Keep the tag in English. Findings from the general criteria or a piece are never tagged.
- Lines = new version of the file; if undeterminable, function/block/file. Never invent lines.

### Conventional Comments prefixes (a comment starts with one)
```
issue (blocking):           issue (non-blocking):
suggestion (non-blocking):  question (non-blocking):
thought (non-blocking):     nitpick (nitpick):
chore (non-blocking):       todo (non-blocking):
praise (non-blocking):
```

Each comment explains one or more of: what is wrong · why it is a problem · what risk it introduces · which scenario triggers it · how to fix it · what decision needs clarifying.
Vague comments are forbidden ("Improve this", "Review", "This is wrong", "Could be better", "I don't like this implementation").
`praise` only for technically valuable decisions.

### No findings
```markdown
## Findings

No actionable findings in the analyzed changes.

## Validations performed

- Spec compliance reviewed.
- Clean Architecture reviewed.
- Clean Code reviewed.
- Security reviewed.
- Observability reviewed.
- Tests reviewed.
- Compatibility and regressions reviewed.
- Change intent and PR hygiene reviewed.
- <one line per Checklist area of each loaded piece, e.g. "Handlers and triggers reviewed (GCP Cloud Functions).">
```

## 3. Executive summary

```markdown
## Executive summary

- **Total findings:** X
- **Blocking:** X
- **Non-blocking:** X
- **Nitpick:** X
- **Clean Architecture diagnosis:** X/7
- **Architecture level:** `<Solid | Acceptable with debt | Relevant coupling | Strongly coupled>`

### Verdict

<one of: Ready to merge | Requires minor changes | Requires changes before merging | Requires rework | Review blocked>

### Justification

<Brief, concrete, based on the findings.>
```

### Verdict criteria

| Verdict | Conditions |
|---|---|
| `Ready to merge` | No blocking; no relevant functional risks; no major security/idempotency/compatibility issues; only nitpicks or minor suggestions |
| `Requires minor changes` | No blocking; some non-blocking; low operational and functional risk; sustainable architecture |
| `Requires changes before merging` | ≥1 blocking; partial spec non-compliance; risk of bug, regression, security, data loss or missing critical test |
| `Requires rework` | Implementation misaligned with the spec; business logic strongly coupled to the framework or infrastructure; multiple blocking; no idempotency/retry strategy; hard-to-maintain design; high operational risk |
| `Review blocked` | Could not fetch the changes, the required spec or the required comments; insufficient information |
