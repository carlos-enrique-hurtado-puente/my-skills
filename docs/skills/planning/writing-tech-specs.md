# writing-tech-specs

**English** | [Español](writing-tech-specs.es.md)

Helps write a technical spec: before writing it (what context to gather) and before freezing it (a checklist built on nine principles that the skill applies to its own draft). Source: [`skills/planning/writing-tech-specs/`](../../../skills/planning/writing-tech-specs/SKILL.md). It is a distillation of the team's spec-writing guide (Spanish original, kept outside this repo).

## Usage

In Claude Code: `/writing-tech-specs`. In Codex: `$writing-tech-specs`. The skill is manual-only: it never loads from an implicit prompt.

```text
/writing-tech-specs I need to write the spec for muting a conversation for 24 hours; what do I find out first?
```

- It never reads code, searches a repository or runs commands (the brief is the only source of facts) and never writes inside your repository, even if asked: it gives the spec in the answer and also saves a local copy as `~/.specflow/<feature>/spec.md`, whose first lines are `Published: <link or not published yet>` and `Copy date: <YYYY-MM-DD>`. If the folder already has a `spec.md`, it is renamed `spec-superseded-<its copy date>.md` (then `-2`, `-3`... if that name exists), never overwritten. If the folder cannot be written, the skill says so and gives the spec in the answer only.
- The skill writes the spec from a discovery brief and never asks you for a spec. The flow is `discovering-tech-changes` -> `writing-tech-specs`: an FRD, user story, ticket or bare idea goes into the discovery, and if you also pass it here it is only context (for example the ticket link). Briefs live in `~/.specflow/<date>-<slug>/brief.md`, one folder per feature: the skill asks for the feature folder (or lists `~/.specflow/` if you name none), reads its `brief.md` and never any `brief-superseded-*`. If you also pass a review report (`review-<date>.md` in that folder), it rewrites the spec from the same brief and fixes each `no` in the report's Checklist; the report is context, never a source of facts. It runs **Before writing**: it asks for the brief and points to [`discovering-tech-changes`](discovering-tech-changes.md) to make one. It maps the brief's sections to the rules (plain words to what we are building, goals and non-goals to what we are building and an Out of scope section, corrections to a "spec says / is" table, how it works today to a "Today's behavior and dependencies" section, written as behavior and leaving identifiers, dates and commits in the brief, reuse reasons beside fixed mechanisms, surroundings to contracts and work in flight, options and open questions to the decisions table). If the brief is reduced or lacks a section, the skill names each missing section and lists it as an open question. If the user declines the discovery, the skill stops and writes nothing: without knowing the code and the change, the spec would be guesses. Exact lines, signatures and file names are not needed. The brief is only an input: the spec states its facts as its own, as behavior (no file paths, functions, constants, dates or commits: those stay in the brief, so the spec survives a change of implementation), and never names or cites the brief. Then it drafts with the rules and checks its own draft against the Before freezing list: the draft ends with a `Self-check` section, one line per principle citing where it is met, or the fix or open question when it is not.

## Deciding whether to split a spec

There is no size threshold. When you ask whether to split, the skill treats it as a decision you make together, starting from a few principles (for: not reviewable in one sitting, more than one deliverable result, parts at different maturity, a big unknown, large or scattered surface; against: the contract a cut creates, parts that cannot deploy alone; and cut by behavior before cutting by repository). The answer comes in four parts: a one-line recommendation; the options, including "do not split", each with what it creates and what stays blocked; what the skill needs from you that it cannot see; and the decision as a Proposed row with the discarded alternatives. The principles' sources and support levels are in `references/content.md` (P4).

```text
/writing-tech-specs should we split ./specs/export-and-retention.md?
```

## What is in the skill

| File | Content |
|---|---|
| `SKILL.md` | Terms defined once, Before writing (takes the discovery brief), the nine rules with their support level, the Before freezing checklist |
| `references/content.md` | P1 to P4: why, the team's cases, sources, before → after |
| `references/statements.md` | P5 to P7 |
| `references/decisions-contracts.md` | P8 and P9 |
| `references/evidence.md` | Support levels, blind-test results, limits of the evidence |

Each rule carries a support tag: **B**acked, **P**artial, **O**wn, **H**ypothesis. In the team's blind tests the most reliable were P6 (verifiability), P9 (contracts and sibling specs), P8 (decision status) and P1 (mechanism against behavior). P4 (size against surface) is useful to size a spec but did not predict friction, and the design reconciliation in P3 (today's behavior and dependencies) is barely tested.

## Scope

In scope: the text of the spec and what must be known before writing it.

Out of scope: changes the tech lead, PM or dev make during implementation or code review, QA process, and review tickets closed without a PR. The skill only makes each decision's reason and status explicit.

## Tests

```bash
bash tests/planning/writing-tech-specs/check-structure.sh
```

Pressure scenarios (run by hand with a runner and a separate scorer) are in [`tests/planning/writing-tech-specs/`](../../../tests/planning/writing-tech-specs/README.md).
