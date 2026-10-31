# writing-tech-specs tests

Pressure scenarios and a structure check for the `writing-tech-specs` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `check-structure.sh` checks frontmatter, manual-only invocation, the nine rule lines, the checklist headings, that the references exist, that no ticket id sits in `SKILL.md` and that no person's name leaks into the skill.
- `fixtures/brief-mute-full.md` and `fixtures/brief-mute-reduced.md`: made-up discovery briefs, full and reduced depth (used by `full-brief-handoff` and `reduced-brief`).
- `fixtures/brief-mute-superseded.md`: an older brief with one changed fact (used by `brief-from-folder` and `form-rewrite`).
- `fixtures/review-mute-form.md`: a made-up review report (P5 on two criteria, P8 on one decision) used by `form-rewrite`.
- `fixtures/large-spec.md`: a summary of a large spec whose parts are at different maturity (used by `split-decision`).
- `fixtures/provider-spec-excerpt.md`: a backend spec with open questions.
- `scenarios/<id>.md`: `Setup`, `Invocation`, `Pressure`, `Expected`, `Purpose (scorer only)`, `Results`.

## Runner and scorer

Each run uses two separate agents. The **runner** gets only `Setup`, `Invocation` and `Pressure` (the fixtures copied to a scratch directory, never the repo). Baseline runs get no skill; green runs get a copy of the skill folder. The **scorer** gets `Expected` and the runner's output and grades each bullet. Runners never see `Expected`.

Results are appended under `## Results` as `baseline`, `green-N`, `refactor-N`.

## Outcome, 2026-10-24 (split-decision and draft-self-check added 2026-10-25)

| Scenario | Baseline | With skill (1 run) | Role |
|---|---|---|---|
| `before-writing` | Rewritten on 2026-10-26 for the discovery brief (5 bullets). Previous skill: FAIL 3 of 5 (red-2: no request for the brief, no offer of `/discovering-tech-changes`, no handling of a declined offer) | PASS 5 of 5 after one fix (green-2 failed 1 of 5 because the skill let the runner assume there was no brief; green-3 passes). The original 8-bullet baseline and green-1 results (2026-10-24) remain in the scenario file's Results | discriminating |
| `declined-discovery` (added 2026-10-30) | FAIL in 3 of 3 (each wrote a full draft from the FRD with the gaps as open questions) | PASS 3 of 3 (stops, says why, offers the discovery again) | discriminating |
| `consumer-spec` | FAIL (2 of 5: defined its own shape and built the form before the open questions were answered; no deployable steps) | PASS 5 of 5 | discriminating |
| `split-decision` | FAIL in 2 of 2 runs (3 bullets: one verdict, no options or "do not split", no questions for the dev, no recorded decision) | PASS 3 of 3 | discriminating |
| `draft-self-check` | FAIL in 2 of 2 (no self-check; criteria without "when"; decisions without a resolution moment) | PASS 2 of 3 after two iterations (the third run has one false `yes` in its self-check) | discriminating; needs the team's FRD and a code snapshot, not reproducible from this repo |
| `full-brief-handoff` (added 2026-10-26) | Previous skill: FAIL in 2 of 3 runs (the spec named the brief or wrote "the brief lacks X"); out of scope and dated assumptions always kept. 2026-10-31: FAIL again on the bullet "today's facts as behavior, no identifiers or dates" (red-4) | PASS 3 of 3 in 3 runs (green-5 to green-7); 2026-10-31: green-8 to green-10 FAIL 2 of 3 on "does not reference the brief" ("sin decisión del brief" inside the spec), then PASS 3 of 3 in green-11 to green-13 after SKILL.md said every line, edge cases and Self-check included, must avoid it | discriminating on "the spec does not reference the brief"; the next-step offer (removed 2026-10-29) and the re-verify-command and brief-name bullets (removed 2026-10-30) are history in the scenario file |
| `behavior-not-code` (added 2026-10-31) | FAIL in 3 of 3 (Assumptions with identifiers, dates and commits kept in the spec) | PASS 3 of 3 (today's behavior without identifiers or dates; the pressure is answered) | discriminating |
| `brief-from-folder` (added 2026-10-31) | FAIL in 1 of 3 (2 runs found the folder and ignored the superseded brief by itself; 1 asked which brief to use and wrote no spec) | PASS 3 of 3 (one feature folder, `brief.md` only, no superseded fact) | weak discriminator |
| `form-rewrite` (added 2026-10-31) | FAIL (3 of 4: added unmarked facts the brief lacks) | FAIL 3 of 4 in 2 blind runs on the committed skill (fixes the three `no` items; adds unmarked details such as "existing snoozes keep their end time"); an unblind run of an earlier text passed 4 of 4 | open: the "no added fact" bullet is not met reliably |
| `no-code-reading` (added 2026-10-31) | FAIL 1 of 1 (read the repo's code, wrote the spec inside the repo) | PASS 1 of 1 after one fix (green-1 wrote in the repo because the user asked; the skill now says never, even when asked) | discriminating |
| `reduced-brief` (added 2026-10-26) | FAIL 2 of 3 (named the missing contracts, work in flight and design version, but not goals, non-goals or options) | PASS 3 of 3 | discriminating |

Honest reading: the gains show in the two scenarios where the skill adds a rule the model does not apply on its own: dated assumptions plus "do not collect lines and signatures", and one home for a contract with no building on unfrozen fields.

## Not covered

- One run per cell except `split-decision` (2 baseline runs, 3 with the skill); variance elsewhere is unmeasured.
- The reference files were not exercised by a scenario.
- The skill was not tested on a real, large spec from the team.
- `consumer-spec`, `split-decision` and `draft-self-check` were not re-run after the Before writing change. `draft-self-check` needs the team's FRD and a code snapshot and cannot be reproduced from this repo; it may now stop to ask for a brief before drafting.
- 2026-10-30: full-brief-handoff no longer asks the spec to name the brief or copy its re-verify commands (the brief is only an input). The two remaining bullets were re-graded on the recorded green-3 and green-4 outputs, not on a new run. The same day the skill gained "the brief is an input the spec never cites" (red 1 of 3 pass, green 3 of 3 pass).
- 2026-10-30: reviewing an existing spec left this skill (it will be its own skill); `review-seeded-spec` and `fixtures/seeded-spec.md` were removed and remain in git history.
- 2026-10-30: the skill now writes only from a discovery brief and stops when the discovery is declined. `declined-discovery` added; `before-writing` Expected rewritten (red-3 FAIL 3 of 5, green-4 PASS 5 of 5). One blind scorer graded all eight runs without knowing which were red or green.
- 2026-10-31: P3 became "Today's behavior and dependencies": the spec states today's facts as behavior, with no identifiers, dates or commits (they stay in the brief). `behavior-not-code` added (red FAIL 3 of 3, green PASS 3 of 3); `full-brief-handoff` Expected changed (red FAIL, green PASS). One blind scorer graded all eight runs without knowing which were red or green.
- 2026-10-31: the skill reads briefs from `~/.tech-specs/<date>-<slug>/brief.md`, never `brief-superseded-*`, and rewrites from a review report. `brief-from-folder` and `form-rewrite` added; `full-brief-handoff` (bullet 3 reworded), `reduced-brief`, `before-writing` and `declined-discovery` re-run once each. The `full-brief-handoff` bullet "does not reference the brief" failed once before the final skill and passed after. Runs graded by blind scorers except the two reruns marked in the scenario files, graded by the implementer.
- 2026-10-31 fix round: `fixtures/brief-mute-superseded.md` stored for `brief-from-folder` and `form-rewrite`. `full-brief-handoff` and `form-rewrite` re-run on the committed skill with one blind scorer; the reference leak was real and fixed; `form-rewrite` "adds no fact" is still failing (see the scenario file).
