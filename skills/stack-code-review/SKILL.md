---
name: stack-code-review
description: Use when the user explicitly invokes /stack-code-review (Claude Code) or $stack-code-review (Codex) to review code changes of any stack (pieces for Google Cloud Functions and Angular), from a GitHub PR URL or the current local git branch
disable-model-invocation: true
---
# Code review by stack

# Code review by stack
## Overview

Rigorous, read-only review of a set of changes (see Sources). Role: Staff/Senior Backend Engineer. You do not validate out of politeness: you hunt for bugs, spec violations, security risks, idempotency and retry flaws, GCP coupling, test gaps, observability holes and regressions.

**Violating the letter of these rules is violating their spirit.**

## Inputs

| Input | Required | Values |
|---|---|---|
| `target` | no | GitHub PR URL, Bitbucket PR URL, or nothing |
| `spec` | no | local file path, URL, or pasted text |
| `base` | no | local mode only: base branch name; skips base detection. Given with a GitHub PR URL it is ignored; say so |

Everything else (Gen 1/Gen 2, runtime, triggers, region, IaC, test framework, validation library) is **inferred from the changes and repo**. Ask only when inference is impossible.

## Mode selection

What arrives decides the mode:

| Observable input | Action |
|---|---|
| `https://github.com/<owner>/<repo>/pull/<n>`, also with a longer path such as `/pull/12/files` | GitHub mode, no question asked. |
| Bitbucket PR URL (`bitbucket.org/.../pull-requests/<n>`) | Reply that Bitbucket is not supported yet and suggest checking out that PR's branch and rerunning without a URL (local mode). Nothing else: no commands, no report. |
| No target (empty, or only `spec` / `base`) | Local mode, with the confirmation defined in `references/sources/local-git.md`. |
| A bare number, or text that is neither a spec nor a target | Ask what the user wants to review. |

**Reading the arguments** (the invocation is free text):

| Argument | It is the |
|---|---|
| GitHub or Bitbucket PR URL | `target` |
| Any other URL, or a path to an existing file | `spec` |
| `spec: ...` / `base: ...` prefix | that input; a prefix wins over guessing |
| Remaining text that reads like a spec (acceptance criteria, requirements) | `spec`, pasted |
| Other remaining text | ask |

`/stack-code-review https://acme.atlassian.net/browse/X-1` therefore means local mode with that spec.

## Sources

Pick the source from the target, then read **only that source's file** (paths are relative to `<skill-dir>`, the folder containing this SKILL.md); it holds the prerequisites, how to fetch the changes, its header fields and its `BLOCKED` conditions.

| Target | Source | File |
|---|---|---|
| GitHub PR URL | `GitHub PR` | `references/sources/github.md` |
| nothing (current git branch) | `Local branch` | `references/sources/local-git.md` |

## Hard rules

1. **Read-only.** The source file adds its own restrictions.
2. **Do not invent** files, lines, functions, acceptance criteria, GCP limits or flags. If a claim depends on product version/generation and you did not verify it in official docs, write it as `question (non-blocking):`.
3. **Line numbers = new version** of the file (right side of the diff). If you cannot determine the line, cite the function/block.
4. **Prioritize modified lines.** Report issues outside the diff only if the change directly introduced them.
5. **Quality over quantity**, but do not omit relevant findings. One finding = one row; no duplicates.

## Workflow

1. Choose the source (table above) and read its file. Check its prerequisites. Local mode order: run the script, do the spec step (3), send the confirmation and stop; collect data (2) only after the user confirms (or the invocation already did).
2. Collect the data the source file lists: metadata, full diff, prior comments (if the source has them), full files when the diff lacks context. Read prior comments before analyzing code.
3. **Spec step.** If a `spec` was given, read `references/spec-sources.md` and follow it (in local mode, before the confirmation): read the spec, check every acceptance criterion against the implementation, and record `Spec source`. With no spec, do not ask: `Spec reviewed: no`, `Spec source: none`.
4. Infer the cloud context (generation, runtime, trigger, IaC).
5. **REQUIRED:** read `references/criteria.md` and evaluate all 12 criteria.
6. **REQUIRED:** read `references/output-format.md` and deliver the output in the exact format, in the language of the user's request (see Output language).

## When the review is `BLOCKED`

Stop, report the limitation, and **do not invent findings** if:
- A `BLOCKED` condition of the active source file applies.
- A spec was given, could not be read, and the user declined to provide it as markdown or to confirm reviewing without it (`references/spec-sources.md`). In GitHub mode the first reply is a stop message asking for it, not a `BLOCKED` report. Do not pretend to have validated functionality.
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
| "I'll do a quick checkout to see the code" | Forbidden, even if the user says it is fine. Fetch files the way the source file says: GitHub `gh api repos/<owner>/<repo>/contents/<path>?ref=<headRefName>`; local `git show HEAD:<path>`. |
| "The spec won't open, I'll assume the criteria" | Never. Say why it failed, ask for it as markdown (path or pasted); without it, `BLOCKED` unless the user confirms reviewing without it. |
| "I'll compare against main, same thing" | Use the base the source file defines. |
| "origin/HEAD points to main, so the base is main" | origin/HEAD is the last tie-break. The base comes only from `scripts/detect-base.sh`, never from `origin/HEAD` by hand; list every `candidate:` line in the confirmation. |
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
