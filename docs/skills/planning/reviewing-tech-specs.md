# reviewing-tech-specs

**English** | [Español](reviewing-tech-specs.es.md)

Reviews a written technical spec before it is frozen: a yes/no pass over the nine principles of [`writing-tech-specs`](writing-tech-specs.md) and an age check on the facts of its discovery brief. Source: [`skills/planning/reviewing-tech-specs/`](../../../skills/planning/reviewing-tech-specs/SKILL.md).

## Usage

In Claude Code: `/reviewing-tech-specs`. In Codex: `$reviewing-tech-specs`. Manual-only: it never loads from an implicit prompt.

```text
/reviewing-tech-specs review ./spec-mute.md; its brief is in ~/.specflow/2026-09-01-mute-conversation/
```

- The review reads the spec you point to. If you name none and the feature folder has `spec.md`, it uses that copy and says its source and date (the published spec may have changed since); it never writes `spec.md`.
- The review reads the whole spec and the feature folder's `brief.md` (never a `brief-superseded-*`). It never reads code and does not rewrite the spec.
- Checklist: one `P1` to `P9` line, `yes`, `no` or `n.a.`; every `no` quotes the spec and gives the fix. It does not invent defects in parts that comply.
- Age check: each row of the brief's section "How it works today" older than 21 days, or with no date, is listed as a fact to re-verify, with the spec decisions that depend on it. A commit alone gives no age. Without a brief, the review says the age cannot be checked and points to `/discovering-tech-changes`.
- The verdict never says plain "can freeze" while facts are stale or there is no brief: freezing is conditional on current facts (with no brief the next step is `/discovering-tech-changes`).
- Report: saved at `~/.specflow/<feature>/review-<YYYY-MM-DD>.md` (a second report on the same day is `review-<YYYY-MM-DD>-2.md`, then `-3`...; never overwritten) with `## Verdict`, `## Checklist`, `## Facts to re-verify`, `## Next step`. The next step is `/verifying-spec-facts` when there are facts to re-verify, `/writing-tech-specs` with the report when an item is `no`, both in that order if both apply. With no feature folder the report stays in the answer and no file is written.

## What is in the skill

| File | Content |
|---|---|
| `SKILL.md` | Terms, the nine rules, how to review, the checklist, the report |
| `references/*.md` | The same four reference files as `writing-tech-specs` (byte-identical) |

The rules, checklist and references are copied from `writing-tech-specs`; `tests/planning/reviewing-tech-specs/test-rules-sync.sh` fails if they drift.

## Scope

In scope: judging the text of a spec and the age of the facts it rests on. Out of scope: rewriting the spec (`/writing-tech-specs`), checking facts against the code (`/verifying-spec-facts`), and QA process.
