# verifying-spec-facts

**English** | [Español](verifying-spec-facts.es.md)

Checks whether the facts a spec review flagged as old still hold in today's code. If they all hold it refreshes their dates in the brief; if one changed it writes a report and sends the developer to a new discovery. Source: [`skills/planning/verifying-spec-facts/`](../../../skills/planning/verifying-spec-facts/SKILL.md).

## Usage

In Claude Code: `/verifying-spec-facts`. In Codex: `$verifying-spec-facts`. Manual-only: it never loads from an implicit prompt.

```text
/verifying-spec-facts the feature folder is ~/.tech-specs/2026-09-01-mute-conversation/ and the code is in ./chat-app
```

- Input: the feature folder with `brief.md` and the review report `review-<date>.md`, plus the repository. It takes only the facts under the report's `## Facts to re-verify`, matches each to its row in the brief's section `How it works today`, runs the row's re-verify command read-only, reads the code, and labels the fact holds, changed or cannot verify.
- Every fact holds: only the "Date and commit" cell of each flagged row is changed, to today's date and the current commit. No report, no new brief.
- Any fact changed or cannot be verified: writes `~/.tech-specs/<feature>/verify-<YYYY-MM-DD>.md` with `## Facts that changed`, `## Decisions affected`, `## Next step`. The brief is not touched, not even the dates of the facts that hold. Next step: `/discovering-tech-changes` for a new brief, then `/writing-tech-specs`.
- No review report: it asks for one and, if there is none, points to `/reviewing-tech-specs`. It does not run the age check itself.
- It is read-only toward repositories (git with `--no-optional-locks`) and writes only under `~/.tech-specs/`.

## Scope

In scope: re-checking the flagged facts. Out of scope: deciding which facts are old (`/reviewing-tech-specs`), writing briefs (`/discovering-tech-changes`), rewriting specs (`/writing-tech-specs`). Tests: [`tests/planning/verifying-spec-facts/`](../../../tests/planning/verifying-spec-facts/README.md).
