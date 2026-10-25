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
| `split-options-backend` (added 2026-10-25) | FAIL 2 of 6 with the previous skill (four `[BACKEND]` parts by PR size, no evaluated options) | PASS 6 of 6 | discriminating |
| `existing-ticket-lengths` (added 2026-10-25) | FAIL 1 of 5 on the previous skill (graded from an earlier HU-04 run: no ticket search, 23 certification rows, 11 review points) | PASS 5 of 5 | discriminating |

Honest reading: without the skill the model already keeps one story for three repos (quoting the deploy order) and already stops when the spec cannot be read, so those two scenarios are guards (they check the skill does not cost behavior), not evidence that it helps. The gains show in the other six, where the skill adds a rule the model does not apply on its own: full content instead of placeholders, splits only on quoted evidence with a "relates to" link, one development sub-task per PR, method over the reference's structure, draft first and confirm each creation, and asking derive-or-wait for missing criteria.

Refactor guard runs, 2026-10-25: `refactor-1` (on the first refactor commit) passed `bulk-create-pressure` 4/4, `split-blocker` 4/4 and `one-story-two-layers` 10/10; after the fix round restored two trimmed rules, `refactor-2` passed `older-reference` 4/4. The `bulk-create-pressure` refactor-2 run is recorded as skipped: its scorer dispatch was interrupted, and it was not retried or faked. One scorer graded a bullet FAIL and corrected itself to PASS in the same reply, and two orchestrators abbreviated long answers before scoring; treat single verdicts as indicative, not exact.

**Revision, 2026-10-25: split options and split criteria.** "One development sub-task ≈ one PR" was replaced by four split criteria (own deliverable, no overlap, low-dependency seam, a reason worth the cost) and a split options phase before the draft. RED: `split-options-backend` failed 2 of 6 on the previous skill. GREEN (`green-options-1`): `split-options-backend` 6/6, `backend-only` 3/3 (its first Expected bullet was rewritten from "exactly one or Parte N" to the four criteria), `one-story-two-layers` 10/10, `three-repos-one-story` 4/4, `split-blocker` 4/4, `bulk-create-pressure` 4/4. The `SKILL.md` word cap went from 700 to 850.

**Revision, 2026-10-25: existing tickets and lengths.** The skill now searches Jira read-only for tickets already made from the spec, limits certification to one row per criterion plus at most 5 risk-tied negative or edge rows, and limits code review "pay attention to" to the 3 to 5 most critical points. GREEN: `existing-ticket-lengths` 5/5 (found ITV-866), `one-story-two-layers` 10/10. The RED for this scenario was graded by the controller from an earlier run, not by a separate runner and scorer. The `SKILL.md` cap went from 850 to 900 words.

## Not covered

- One run per cell; no repetitions, so variance is unmeasured.
- Runners were sonnet only; other models were not tried.
- Runs are single-turn, with an assumed "Sí, sigue" reply after the proposal; the multi-turn flow is untested.
- Live reads depend on the Atlassian connector being authorized in the session.
- Jira creation itself is never exercised: write tools are off limits, so the real create calls and their results are untested.
