# discovering-tech-changes

**English** | [Español](discovering-tech-changes.es.md)

Helps you understand a requirement (FRD, user stories, a task or a design) and the code it touches, and prepares a discovery brief before you write the technical spec. It works step by step: each step ends at a checkpoint where you validate or correct before it goes on. It explains in plain words first and keeps code identifiers as evidence underneath. Source: [`skills/planning/discovering-tech-changes/`](../../../skills/planning/discovering-tech-changes/SKILL.md). Each step is grounded in cited sources and in real Jira evidence, as open heuristics rather than closed rules.

## Usage

In Claude Code: `/discovering-tech-changes`. In Codex: `$discovering-tech-changes`. The skill is manual-only: it never loads from an implicit prompt.

```text
/discovering-tech-changes help me understand this FRD before I write the spec: https://<site>.atlassian.net/wiki/spaces/ENG/pages/12345
/discovering-tech-changes ABC-123: what does the code do today and what can I reuse?
/discovering-tech-changes ./docs/frd-export-limits.md, reduced depth, it is a small change
```

- **Input:** pasted text, a local file, a Confluence page, a Jira ticket (through the Atlassian tools) or a design. The skill reads all of it; if it cannot, it says so and asks for the text. It never works from a title or from memory.
- **Depth:** before step 1 it asks you to choose **full** (steps 1 to 7) or **reduced** (steps 3 and 4 plus a short brief, for a change you can describe in one sentence). It says which one fits and why; you choose.
- **Language:** the brief is written in your language.

## The seven steps

Each step ends at a checkpoint: it stops, shows the result in plain words and waits for your answer, even if you ask it to hurry. Steps 3 to 6 are revisited when something learned changes an earlier answer.

| # | Step | What it does | Checkpoint |
|---|---|---|---|
| 1 | Intake | Restates what is asked and the outcome; marks omissions, ambiguity and contradictions; settles in the code the doubts the code can answer (waiting for any code search it delegated); starts the list of corrections to the input | Is this what is asked? Only the doubts the code could not settle |
| 2 | Framing | Goals, non-goals and how success is known | Do you confirm goals and non-goals? |
| 3 | How it works today | Observable behavior first, then the whole flow: every caller, other readers and writers of the data, side effects, contracts, silent drops, tests, history | Correct the explanation |
| 4 | Reuse and conventions | For each needed behavior, searches by behavior (it may exist under another name); records conventions; reuse, adapt or create, with the reason | Do you confirm the inventory? |
| 5 | Surroundings | Other specs, branches and work in progress touching the same files, flows or contracts; contracts checked against the provider; deploy order; limits | Do you confirm the list and each owner? |
| 6 | Options | Two or three, including a smaller one and "keep as is" when meaningful; one is recommended with the reason | Which direction do you choose? |
| 7 | Brief | Consolidates everything | Do you validate the whole brief? |

## The brief

Delivered in chat by default, with an offer to save it as a file; Confluence only on request. Sections:

0. Header: input, date, commit, depth, what was validated.
1. In plain words: problem, outcome, today and proposal, on one page and without identifiers.
2. Corrections to the input.
3. Goals and non-goals.
4. How it works today: each fact with how it is known, date, commit and a command to re-verify it.
5. Reuse inventory and conventions, with what was searched.
6. Surroundings: the state and owner of each item.
7. Options and recommendation.
8. Open questions: item, owner, moment.

Every fact is labeled as observed in code, inferred, or told by you. A gap in the input or the code becomes an open question with an owner; the skill never invents an answer. Nearby work counts as a dependency until you say otherwise.

## What is in the skill

| File | Content |
|---|---|
| `SKILL.md` | Start (input, depth, read-only), the seven steps with their checkpoints, the brief, the rules |
| `references/steps.md` | Per step: signals to look for, checkpoint question, sources |
| `references/brief-template.md` | Section-by-section template of the brief |
| `references/evidence.md` | Sources and support level behind each step, and the Jira cases |
| `agents/openai.yaml` | Codex manual-only policy |

## Limits

- Read-only toward your repo, Jira and Confluence: it writes nothing there.
- It does not decide. It proposes and recommends; you decide and the decision is recorded in the spec.
- It is not an implementation plan and not the spec: no code steps and no acceptance criteria. Hand the validated brief to [`writing-tech-specs`](writing-tech-specs.md).
- The Jira evidence behind the heuristics comes from one team.
- Not tested on large real codebases, on real Jira or Confluence reading, or on Codex. See [what is not covered](../../../tests/planning/discovering-tech-changes/README.md#not-covered).

## Tests

```bash
bash tests/planning/discovering-tech-changes/check-structure.sh
bash tests/planning/discovering-tech-changes/check-scenarios.sh
```

Eleven pressure scenarios (run by hand with a runner and a separate scorer), a decision micro-test for step 1 while a delegated code search is running, and their outcome are in [`tests/planning/discovering-tech-changes/`](../../../tests/planning/discovering-tech-changes/README.md). In the micro-test, the step 1 checkpoint waited for the search in 5 of 5 runs after the 2026-10-29 change, against 1 of 5 before. Outcome of the first ten: 9 of 10 scenarios pass with the skill (runs on mixed skill commits; see Not covered in the tests README); 5 of 10 discriminate against the baseline (the others are guards that a strong model also passes without the skill). The `plain-language` scenario still misses one point: a directory path remains outside the evidence columns, in a "what was searched" cell.
