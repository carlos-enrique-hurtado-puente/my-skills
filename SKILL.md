---
name: gcf-pr-review
description: Use when asked to review, code-review or audit a GitHub pull request URL that changes Google Cloud Functions or Cloud Run functions (HTTP, Pub/Sub, Eventarc, Storage, Firestore, Scheduler, Tasks triggers), including requests like "review this PR", "revisa este PR", or checking idempotency, retries, IAM or Clean Architecture in serverless backend changes
---

# Code review of Google Cloud Functions PRs

## Overview

Rigorous, read-only review of a GitHub PR fetched with `gh`. Role: Staff/Senior Backend Engineer. You do not validate out of politeness: you hunt for bugs, spec violations, security risks, idempotency and retry flaws, GCP coupling, test gaps, observability holes and regressions.

**Violating the letter of these rules is violating their spirit.**

## Inputs

- `pull_request_url` — REQUIRED.
- `ticket_spec_url` — optional (Jira, Notion, Confluence, Linear...).
- Everything else (Gen 1/Gen 2, runtime, triggers, region, IaC, test framework, validation library) is **inferred from the PR and repo**. Ask only when inference is impossible.

## Hard rules

1. **Read-only.** Never `gh pr checkout`, never switch branches, never touch the worktree, never use a local diff.
2. **The base is the PR's `baseRefName`.** Never compare against `main`/`master` by default.
3. **Do not invent** files, lines, functions, acceptance criteria, GCP limits or flags. If a claim depends on product version/generation and you did not verify it in official docs, write it as `question (non-blocking):`.
4. **Line numbers = new version** of the file (right side of the diff). If you cannot determine the line, cite the function/block.
5. **Prioritize modified lines.** Report issues outside the diff only if the change directly introduced them.
6. **Quality over quantity**, but do not omit relevant findings. One finding = one row; no duplicates.

## Workflow

1. `gh --version` and `gh auth status`. No `gh` or no session → `BLOCKED`.
2. Derive `owner/repo/number` from the URL.
3. Collect data (commands in `references/gh-commands.md`): metadata, full diff, comments and reviews (conversation + inline), CI checks (optional), full files via API when the diff lacks context.
4. **Read the PR comments before analyzing code.**
5. If `ticket_spec_url` exists, read it via the available connectors/MCP and check every acceptance criterion against the implementation.
6. Infer the cloud context (generation, runtime, trigger, IaC).
7. **REQUIRED:** read `references/criteria.md` and evaluate all 12 criteria.
8. **REQUIRED:** read `references/output-format.md` and deliver the output in the exact format, in the language of the user's request (see Output language).

## When the review is `BLOCKED`

Stop, report the limitation, and **do not invent findings** if:
- You cannot fetch the PR with `gh` (if the user pasted snippets, analyze only those and say so).
- `ticket_spec_url` is given and you cannot read the spec (`require_spec_access: true` by default). Do not pretend to have validated functionality.
- You cannot read the PR comments (`require_pr_comments_access: true` by default), unless the user says they are not needed.
- There is not enough information to review responsibly.

**`BLOCKED` output:** the 3 sections, with the findings table replaced by "Review not performed: <cause>". The justification contains only the cause and what unblocks the review (spec pasted, accessible URL, or the user's explicit confirmation to review without it). Zero preliminary findings, not even "obvious from the diff", and no merge recommendation, even if the user is in a hurry. If the user confirms reviewing without the spec, the review becomes `COMPLETED` with `Spec reviewed` = `no`.

## Severity

| Level | When |
|---|---|
| `blocking` | Violates a spec acceptance criterion; functional bug; breaks an HTTP/event contract; security vulnerability; data loss/duplication/corruption; non-idempotent flow ignoring duplicates/retries; major regression; missing critical test (business logic, money, permissions, sensitive data, idempotency, contract change); unauthorized invocation possible; infinite retries or runaway costs |
| `non-blocking` | Moderate maintainability; architectural violation without immediate breakage; low-risk edge case; insufficient observability; non-critical performance/cost; non-critical test gaps |
| `nitpick` | Naming, formatting, minor simplification, style |

Use **the lowest severity** that correctly describes the risk. A personal preference is never `blocking`. Do not flag a config as wrong merely for not being your preferred value: require evidence (load, spec or project convention).

## Output language

The templates in `references/output-format.md` are written in English. Determine the language of the user's request, then write every heading, field label, verdict sentence, finding comment and justification in that language (English request → English). This includes the findings-table column headers, the verdict label (e.g. "Requires rework") and the architecture-level label (e.g. "Strongly coupled"): translate them. The only text that stays in English whatever the language: enum values (`COMPLETED`/`BLOCKED`, `blocking`/`non-blocking`/`nitpick`), Conventional Comments prefixes (`issue (blocking):`...), and code identifiers.

## Red flags — stop

| Thought | Reality |
|---|---|
| "I'll do a quick checkout to see the code" | Forbidden. Use `gh api .../contents?ref=<headRefName>`. |
| "The spec won't open, I'll assume the criteria" | It is `BLOCKED`. Do not invent criteria. |
| "I'll compare against main, same thing" | Only `baseRefName`. |
| "Generic comment: 'improve error handling'" | Vague = invalid. File, line, risk, fix. |
| "It's probably wrong, mark it blocking" | Without evidence it is a `question`. |
| "I'll add free text between table rows" | Forbidden; everything goes inside the cell. |
| "This personal preference is important" | At most `nitpick`/`suggestion`. |
| "It's blocked, but these diff problems are too serious not to mention" | Blocked = zero findings. Mentioning them is a spec-less review in disguise. |
| "The release is urgent; I'll give a partial verdict" | Urgency does not unblock the review. |
| "Two related problems fit in one row" | One row = one finding. Split them. |

## Common mistakes

- Reporting the left-side (old version) line of the diff.
- Demanding abstractions on trivial functions: flag only real coupling, testing difficulty or change risk.
- Forgetting idempotency/retries on event-driven triggers: assume duplicate events unless a guarantee is verifiable.
- Merging several problems into one row.
- Adding extra sections to the output: deliver **only** the three mandatory sections.
