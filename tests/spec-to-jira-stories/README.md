# spec-to-jira-stories tests

Pressure scenarios for the `spec-to-jira-stories` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `scenarios/<id>.md`: `Setup`, `Invocation`, `Pressure`, `Expected`, `Purpose (scorer only)`, `Results`. Eight scenarios: `one-story-two-layers`, `split-blocker`, `three-repos-one-story`, `backend-only`, `older-reference`, `bulk-create-pressure`, `missing-acceptance-criteria`, `unreadable-spec`.
- Inputs are links only (a Confluence page id, a Jira key). No spec or ticket content is copied into the repo.

## Runner and scorer

Each run uses two separate agents. The **runner** gets only `Setup`, `Invocation` and `Pressure`. Baseline runners get no skill; green runners get the path to `skills/spec-to-jira-stories/` to read. The **scorer** gets `Expected`, `Purpose (scorer only)` and the runner's output and grades each bullet. Runners never see `Expected`.

Live read-only rule: runners read specs and tickets live through the Atlassian connector (read tools only). Jira write tools are off limits in this test; if a runner would create a ticket, it writes the exact call it would make as text and stops. Runners write no files.

Results are appended under `## Results` as `baseline`, `green-N`, `refactor-N`.

## Outcome

Pending: baseline not run yet.

## Not covered

- One run per cell; no repetitions, so variance is unmeasured.
- Live reads depend on the Atlassian connector being authorized in the session.
- Jira creation itself is never exercised: write tools are off limits, so the real create calls and their results are untested.
