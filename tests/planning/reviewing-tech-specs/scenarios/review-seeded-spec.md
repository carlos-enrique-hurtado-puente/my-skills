# Scenario: review-seeded-spec

## Setup
Copy `fixtures/seeded-spec.md` into a scratch directory `<DIR>` (outside this repo). The runner works only inside `<DIR>`. Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`; it holds no folder for this spec (no brief is given). The spec is for a team's own project; there is no code repository. Today is 2026-10-31.

## Invocation
Review the spec in `<DIR>/seeded-spec.md`. The tech lead wants to freeze it tomorrow. Tell me what must change before freezing.

## Pressure
The freeze meeting is in an hour; the dev who will implement it was not in any of the discussions.

## Expected
Seeded defects (a defect counts as found when the answer points at it specifically, not generically):
- [ ] D1 `node-cron` and `digestWorker.ts` are prescribed with no stated reason (mechanism without a motive, or not marked as a suggestion).
- [ ] D2 Template leftovers: `HU-XX`, `[TBD]` ticket.
- [ ] D3 The spec states code facts (the mailer is synchronous, file names) instead of behavior, and does not link the batching decision to it; the mailer is being refactored in another PR.
- [ ] D4 Log codes `DIG-120` and `DIG-121` are reserved up front instead of being referred to by concept.
- [ ] D5 The preferences contract is copied into this spec and called "already decided" (should live in one place and be requested as a proposal).
- [ ] D6 AC-4 names a collection and a flag; AC-7 is a task (script run) written as a criterion; AC-10 is process, not behavior.
- [ ] D7 AC-5 depends on the path ("if the front does not prevent it ... another path").
- [ ] D8 AC-6 has no number, percentile, load or measuring point, and no evidence line.
- [ ] D9 AC-8 (LLM never includes private notes) has no cases, number of runs or way to force the case; AC-9 needs a real inbox and says so nowhere (environment dependency).
- [ ] D10 "Agreed" contains an item marked pending validation with the PM; the open questions have no stage (before freeze / during / out of scope).
- [ ] D11 Contradiction: 20 cases (Agreed, Risks) vs 25 cases (AC-3).
- [ ] D12 Missing cases: duplicate or retried digest (only mentioned as a risk), failure of the mailer, agent with zero cases handled only as an open question, timezone edge cases.
- [ ] The answer is a review report with the headings `## Verdict`, `## Checklist`, `## Facts to re-verify`, `## Next step` in that order, and the Checklist has one `P<n> yes|no|n.a.` line for each of P1-P9. It writes no file into any repo (there is no feature folder, so the report stays in the answer).
- [ ] The answer gives a clear verdict on whether the spec can be frozen (it cannot).
- [ ] Pass: at least 9 of D1..D12 found. Verdict is PASS only if this holds and the verdict bullet holds.
- [ ] Guard: the answer does not call AC-1, AC-2 or the "Out of scope" item defective. A P6 note that AC-1 or AC-2 needs a verification path (08:00 cannot be provoked from the UI) is the skill's own rule and does not fail this bullet; rewriting their given/when/then or calling them wrong does.

## Purpose (scorer only)
Tests that the review covers the guide's rule families (mechanisms, assumptions, contracts, criteria form, measurability, verifiability, decision status, consistency, cases) instead of only the obvious ones. AC-1 and AC-2 are deliberately correct.

## Results

### red-1 - 2026-10-31 (no skill; blind scorer)
- Verdict: FAIL on the report-shape bullet only: found about 11-12 of D1..D12, clear verdict, guard held, but no four-heading report with P1-P9 lines (free-form list).

### green-1 - 2026-10-31 (skill; blind scorer)
- Verdict: PASS. D1..D12 all found, four headings in order plus an extra "Closing" section, P1-P9 `no` lines, "Can freeze: no", guard held, no file written (no feature folder).
