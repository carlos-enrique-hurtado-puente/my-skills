# writing-tech-specs

**English** | [Español](writing-tech-specs.es.md)

Helps at two moments of a technical spec's life: before writing it (what context to gather) and before freezing it (a checklist built on nine principles). Source: [`skills/writing-tech-specs/`](../../skills/writing-tech-specs/SKILL.md). It is a distillation of the team's spec-writing guide (Spanish original, kept outside this repo).

## Usage

In Claude Code: `/writing-tech-specs`. In Codex: `$writing-tech-specs`. The skill is manual-only: it never loads from an implicit prompt.

```text
/writing-tech-specs I need to write the spec for muting a conversation for 24 hours; what do I find out first?
/writing-tech-specs review this spec before the freeze: ./specs/digest.md
/writing-tech-specs review https://<site>.atlassian.net/wiki/spaces/ENG/pages/12345
```

- **No spec given:** the skill runs **Before writing**: it needs a discovery brief and points to [`discovering-tech-changes`](discovering-tech-changes.md) to make one. It maps the brief's sections to the rules (plain words to what we are building, corrections to a "spec says / is" table, dated code facts to Assumptions, reuse reasons beside fixed mechanisms, surroundings to contracts and work in flight, options and open questions to the decisions table). If the user declines, the gaps become open questions with owner and moment, never invented facts. Exact lines, signatures and file names are not needed. Then it drafts with the rules and checks its own draft against the Before freezing list: the draft ends with a `Self-check` section, one line per principle citing where it is met, or the fix or open question when it is not.
- **A spec given:** the skill runs **Before freezing**. The spec can be pasted text, a local file, a Confluence page (read through the Atlassian tools when connected), a Jira ticket or anything else readable. If it cannot read the source it says so and asks you to paste the text. The answer is a `yes` / `no` / `n.a.` line per principle, each `no` quoting the spec and giving a fix or an open decision with owner and moment, then a verdict on whether it can freeze. The review does not rewrite the spec unless you ask.

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

Each rule carries a support tag: **B**acked, **P**artial, **O**wn, **H**ypothesis. In the team's blind tests the most reliable were P6 (verifiability), P9 (contracts and sibling specs), P8 (decision status) and P1 (mechanism against behavior). P4 (size against surface) is useful to size a spec but did not predict friction, and the design reconciliation in P3 is barely tested.

## Scope

In scope: the text of the spec and what must be known before writing it.

Out of scope: changes the tech lead, PM or dev make during implementation or code review, QA process, and review tickets closed without a PR. The skill only makes each decision's reason and status explicit.

## Tests

```bash
bash tests/writing-tech-specs/check-structure.sh
```

Pressure scenarios (run by hand with a runner and a separate scorer) are in [`tests/writing-tech-specs/`](../../tests/writing-tech-specs/README.md).
