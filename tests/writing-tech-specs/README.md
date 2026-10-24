# writing-tech-specs tests

Pressure scenarios and a structure check for the `writing-tech-specs` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `check-structure.sh` checks frontmatter, manual-only invocation, the nine rule lines, the checklist headings, that the references exist, that no ticket id sits in `SKILL.md` and that no person's name leaks into the skill.
- `fixtures/seeded-spec.md`: a made-up spec with twelve seeded defects (D1 to D12, listed in the scenario's `Expected`) and a few deliberately correct parts. `fixtures/provider-spec-excerpt.md`: a backend spec with open questions.
- `scenarios/<id>.md`: `Setup`, `Invocation`, `Pressure`, `Expected`, `Purpose (scorer only)`, `Results`.

## Runner and scorer

Each run uses two separate agents. The **runner** gets only `Setup`, `Invocation` and `Pressure` (the fixtures copied to a scratch directory, never the repo). Baseline runs get no skill; green runs get a copy of the skill folder. The **scorer** gets `Expected` and the runner's output and grades each bullet. Runners never see `Expected`.

Results are appended under `## Results` as `baseline`, `green-N`, `refactor-N`.

## Outcome, 2026-10-24

| Scenario | Baseline | With skill (1 run) | Role |
|---|---|---|---|
| `before-writing` | FAIL (4 of 8 bullets: no dated assumptions, no work in flight, no platform limits, and it advised collecting exact lines, signatures and file names) | PASS 8 of 8 | discriminating |
| `consumer-spec` | FAIL (2 of 5: defined its own shape and built the form before the open questions were answered; no deployable steps) | PASS 5 of 5 | discriminating |
| `review-seeded-spec` | Finds 12 of 12 seeded defects but flags the correct AC-1 | PASS: 12 of 12, correct parts named | guard |

Honest reading: the model already reviews a seeded spec well without the skill, so that scenario is a guard (checks the skill does not cost coverage or add false alarms), not evidence that the skill helps. The gains show in the two scenarios where the skill adds a rule the model does not apply on its own: dated assumptions plus "do not collect lines and signatures", and one home for a contract with no building on unfrozen fields.

## Not covered

- One run per cell; no repetitions, so variance is unmeasured.
- Reading a spec from Confluence or Jira (depends on the Atlassian connector being authorized) and from a local file other than the one in the fixtures.
- The reference files were not exercised by a scenario.
- The skill was not tested on a real, large spec from the team.
