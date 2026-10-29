# writing-tech-specs tests

Pressure scenarios and a structure check for the `writing-tech-specs` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `check-structure.sh` checks frontmatter, manual-only invocation, the nine rule lines, the checklist headings, that the references exist, that no ticket id sits in `SKILL.md` and that no person's name leaks into the skill.
- `fixtures/brief-mute-full.md` and `fixtures/brief-mute-reduced.md`: made-up discovery briefs, full and reduced depth (used by `full-brief-handoff` and `reduced-brief`).
- `fixtures/large-spec.md`: a summary of a large spec whose parts are at different maturity (used by `split-decision`).
- `fixtures/seeded-spec.md`: a made-up spec with twelve seeded defects (D1 to D12, listed in the scenario's `Expected`) and a few deliberately correct parts. `fixtures/provider-spec-excerpt.md`: a backend spec with open questions.
- `scenarios/<id>.md`: `Setup`, `Invocation`, `Pressure`, `Expected`, `Purpose (scorer only)`, `Results`.

## Runner and scorer

Each run uses two separate agents. The **runner** gets only `Setup`, `Invocation` and `Pressure` (the fixtures copied to a scratch directory, never the repo). Baseline runs get no skill; green runs get a copy of the skill folder. The **scorer** gets `Expected` and the runner's output and grades each bullet. Runners never see `Expected`.

Results are appended under `## Results` as `baseline`, `green-N`, `refactor-N`.

## Outcome, 2026-10-24 (split-decision and draft-self-check added 2026-10-25)

| Scenario | Baseline | With skill (1 run) | Role |
|---|---|---|---|
| `before-writing` | Rewritten on 2026-10-26 for the discovery brief (5 bullets). Previous skill: FAIL 3 of 5 (red-2: no request for the brief, no offer of `/discovering-tech-changes`, no handling of a declined offer) | PASS 5 of 5 after one fix (green-2 failed 1 of 5 because the skill let the runner assume there was no brief; green-3 passes). The original 8-bullet baseline and green-1 results (2026-10-24) remain in the scenario file's Results | discriminating |
| `consumer-spec` | FAIL (2 of 5: defined its own shape and built the form before the open questions were answered; no deployable steps) | PASS 5 of 5 | discriminating |
| `split-decision` | FAIL in 2 of 2 runs (3 bullets: one verdict, no options or "do not split", no questions for the dev, no recorded decision) | PASS 3 of 3 | discriminating |
| `draft-self-check` | FAIL in 2 of 2 (no self-check; criteria without "when"; decisions without a resolution moment) | PASS 2 of 3 after two iterations (the third run has one false `yes` in its self-check) | discriminating; needs the team's FRD and a code snapshot, not reproducible from this repo |
| `full-brief-handoff` (added 2026-10-26) | FAIL 3 of 4 (out of scope, re-verify commands and the brief's name already kept; never offered a next step) | PASS 4 of 4 | discriminating on the kept out of scope, re-verify commands and brief name; the next-step offer was removed on 2026-10-29, so the 3-of-4 baseline and 4-of-4 result predate that bullet |
| `reduced-brief` (added 2026-10-26) | FAIL 2 of 3 (named the missing contracts, work in flight and design version, but not goals, non-goals or options) | PASS 3 of 3 | discriminating |
| `review-seeded-spec` | Finds 12 of 12 seeded defects but flags the correct AC-1 | PASS: 12 of 12, correct parts named | guard |

Honest reading: the model already reviews a seeded spec well without the skill, so that scenario is a guard (checks the skill does not cost coverage or add false alarms), not evidence that the skill helps. The gains show in the two scenarios where the skill adds a rule the model does not apply on its own: dated assumptions plus "do not collect lines and signatures", and one home for a contract with no building on unfrozen fields.

## Not covered

- One run per cell except `split-decision` (2 baseline runs, 3 with the skill); variance elsewhere is unmeasured.
- Reading a spec from Confluence or Jira (depends on the Atlassian connector being authorized) and from a local file other than the one in the fixtures.
- The reference files were not exercised by a scenario.
- The skill was not tested on a real, large spec from the team.
- `consumer-spec`, `split-decision`, `draft-self-check` and `review-seeded-spec` were not re-run after the Before writing change. `draft-self-check` needs the team's FRD and a code snapshot and cannot be reproduced from this repo; it may now stop to ask for a brief before drafting.
- 2026-10-29: after removing the spec-to-jira-stories offer, full-brief-handoff ran twice (green-3, green-4); each run missed one bullet (re-verify commands, or naming the brief), and a control run on the previous version missed the brief name too. The variance pre-dates the change; hardening those two rules is a separate follow-up.
