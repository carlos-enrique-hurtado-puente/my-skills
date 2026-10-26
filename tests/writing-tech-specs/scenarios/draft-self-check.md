# Scenario: draft-self-check

## Setup
Not reproducible from this repo alone: it needs the team's FRD "Mejoras del Recupero de Conversaciones en Cortex" (Confluence page 4724686849, v7) saved as `frd.md` with people replaced by roles, and a `git archive` snapshot of `agent-builder` (develop 943d3ec1) and `agent-builder-functions` (develop 643e5d76) from 2026-09-14, before the feature was built. Put them with a copy of `SKILL.md` in a scratch directory `<DIR>`; the runner reads only `<DIR>` and uses no Jira, Confluence or web tools.

## Invocation
Write the technical spec for HU-02 (runtime resolution of the recovery) of the FRD in `<DIR>/frd.md`. HU-01 (configuration) is being specified in parallel by another dev. Code snapshot as of 2026-09-15 in `<DIR>/code`. Output to `<DIR>/out/`.

## Pressure
The user is not available to answer questions; the spec goes to a dev who was not in the discussions.

## Expected
- [ ] The draft ends with a self-check against the Before freezing list: one line per item (P1 to P9), each `yes` citing the section or ID that satisfies it, each `no` turned into a fix or an open question with owner and moment.
- [ ] The race "the client replies while the condition is being evaluated or the attempt is being prepared" is covered, as a criterion or as an open question (P7 question 2).
- [ ] Every acceptance criterion has given / when / then; none names a collection, table, key, flag or command (P5). At most one slip counts as PASS.
- [ ] Every decision or open question has status, owner and when it is resolved (P8). At most one slip counts as PASS.
- [ ] The criterion about the model judging the condition states cases, runs per case and what counts as met (P6).
- [ ] The configuration contract with HU-01 has one home and is requested as "I need", not redefined (P9).
- [ ] No invented facts: anything not in the FRD or the code appears as an assumption with its commit or as an open question.

## Purpose (scorer only)
In a full run on this FRD (2026-10-25) the runner missed the client-replies-during-evaluation race and left criteria without "when" and decisions without a resolution moment, all covered by the skill's own rules. The skill only asked for the checklist when given an existing spec. This scenario checks whether a self-check on the runner's own draft closes those gaps. The race is the one that actually reached code review in ITV-831.

## Results

### baseline — 2026-10-25 (SKILL.md at 49e6ec9, 2 runs, separate scorer)
- Verdict: FAIL in 2 of 2.
- Self-check — FAIL both (no self-check; drafts end at their last content section).
- Race during evaluation — PASS both (not discriminating on this prompt).
- Given/when/then, no storage names — FAIL both (6 and 3 slips: criteria without "when" or without any given/when/then).
- Status, owner, when — FAIL both (4 and 4 slips: decision tables without a "when" column).
- Model criterion — PASS both. HU-01 contract — PASS both.
- No invented facts — 1 of 2 (one draft gives "stays open until Flowbuilder's own timeout" as fact, unsupported).

### green-1 to green-3 — 2026-10-25 (self-check step added)
- Verdict: FAIL in 3 of 3, but closer.
- Self-check — PASS 3 of 3, cited `yes` lines checked true.
- Given/when/then — PASS 2 of 3 (1, 0 and 2 slips).
- Status, owner, when — PASS 1 of 3 (2, 3 and 1 slips). Cause: P8 asked a "when" for open questions only, not for decisions.
- No invented facts — PASS 1 of 3. Two drafts misread the code ("the engine never writes contact fields"; it does, through `client-updater` and `update-fields`). A self-check cannot catch a misreading; not addressed.

### refactor-1 to refactor-3 — 2026-10-25 (P8: one table with item | status | who | when)
- Verdict: PASS in 2 of 3.
- Self-check — PASS 2 of 3. The failing run's P5 line says every criterion points to the ticket; only the tasks do (a false `yes`).
- Race — PASS 3 of 3. Given/when/then — PASS 3 of 3 (0 slips). Status, owner, when — PASS 3 of 3 (0, 1, 0 slips). Model criterion, HU-01 contract, no invented facts — PASS 3 of 3 (all three read the contact-field write correctly).
- Residual risk: the self-check can still mark itself `yes` wrongly (1 false `yes` in 3 runs). The skill keeps asking for a reader who did not write the spec.
