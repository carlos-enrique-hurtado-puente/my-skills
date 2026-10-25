# spec-to-jira-stories tests

Pressure scenarios for the `spec-to-jira-stories` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `scenarios/<id>.md`: `Setup`, `Invocation`, `Pressure`, `Expected`, `Purpose (scorer only)`, `Results`. Eight scenarios: `one-story-two-layers`, `split-blocker`, `three-repos-one-story`, `backend-only`, `older-reference`, `bulk-create-pressure`, `missing-acceptance-criteria`, `unreadable-spec`.
- Inputs are links only (a Confluence page id, a Jira key). No spec or ticket content is copied into the repo.

## Runner and scorer

Each run uses two separate agents. The **runner** gets only `Setup`, `Invocation` and `Pressure`. Baseline runners get no skill; green runners get the path to `skills/spec-to-jira-stories/` to read. The **scorer** gets `Expected`, `Purpose (scorer only)` and the runner's output and grades each bullet. Runners never see `Expected`.

Live read-only rule: runners read specs and tickets live through the Atlassian connector (read tools only). Jira write tools are off limits in this test; if a runner would create a ticket, it writes the exact call it would make as text and stops. Runners write no files.

Results are appended under `## Results` as `baseline`, `green-N`, `refactor-N`.

## Outcome, 2026-10-25

| Scenario | Baseline | With skill (green-1) | Role |
|---|---|---|---|
| `one-story-two-layers` | FAIL (4 of 10 bullets missed: placeholder story, no certification table, no code review PR lines, did not ask for the epic) | PASS 10 of 10 | discriminating |
| `split-blocker` | FAIL (2 of 4 missed: split rested on size, no "relates to" link) | PASS 4 of 4 | discriminating |
| `three-repos-one-story` | PASS 4 of 4 | PASS 4 of 4 | guard |
| `backend-only` | FAIL (1 of 3 missed: three backend sub-tasks for size) | PASS 3 of 3 | discriminating |
| `older-reference` | FAIL (2 of 4 missed: copied the reference structure and file-and-line checklists) | PASS 4 of 4 | discriminating |
| `bulk-create-pressure` | FAIL (3 of 4 missed: no full draft, no confirm-each, no creation order) | PASS 4 of 4 | discriminating |
| `missing-acceptance-criteria` | FAIL (1 of 3 missed: derived criteria without offering to wait for the author) | PASS 3 of 3 | discriminating |
| `unreadable-spec` | PASS 3 of 3 | PASS 3 of 3 | guard |

Honest reading: without the skill the model already keeps one story for three repos (quoting the deploy order) and already stops when the spec cannot be read, so those two scenarios are guards (they check the skill does not cost behavior), not evidence that it helps. The gains show in the other six, where the skill adds a rule the model does not apply on its own: full content instead of placeholders, splits only on quoted evidence with a "relates to" link, one development sub-task per PR, method over the reference's structure, draft first and confirm each creation, and asking derive-or-wait for missing criteria.

Refactor guard runs: pending.

## Not covered

- One run per cell; no repetitions, so variance is unmeasured.
- Runners were sonnet only; other models were not tried.
- Runs are single-turn, with an assumed "Sí, sigue" reply after the proposal; the multi-turn flow is untested.
- Live reads depend on the Atlassian connector being authorized in the session.
- Jira creation itself is never exercised: write tools are off limits, so the real create calls and their results are untested.
