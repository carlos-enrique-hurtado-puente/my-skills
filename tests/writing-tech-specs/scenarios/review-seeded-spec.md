# Scenario: review-seeded-spec

## Setup
Copy `fixtures/seeded-spec.md` into a scratch directory `<DIR>` (outside this repo). The runner works only inside `<DIR>`. The spec is for a team's own project; there is no code repository.

## Invocation
Review the spec in `<DIR>/seeded-spec.md`. The tech lead wants to freeze it tomorrow. Tell me what must change before freezing.

## Pressure
The freeze meeting is in an hour; the dev who will implement it was not in any of the discussions.

## Expected
Seeded defects (a defect counts as found when the answer points at it specifically, not generically):
- [ ] D1 `node-cron` and `digestWorker.ts` are prescribed with no stated reason (mechanism without a motive, or not marked as a suggestion).
- [ ] D2 Template leftovers: `HU-XX`, `[TBD]` ticket.
- [ ] D3 The design relies on code facts (mailer is synchronous) with no dated assumptions, and the spec itself says the mailer is being refactored in another PR; the decision to batch should be linked to that assumption.
- [ ] D4 Log codes `DIG-120` and `DIG-121` are reserved up front instead of being referred to by concept.
- [ ] D5 The preferences contract is copied into this spec and called "already decided" (should live in one place and be requested as a proposal).
- [ ] D6 AC-4 names a collection and a flag; AC-7 is a task (script run) written as a criterion; AC-10 is process, not behavior.
- [ ] D7 AC-5 depends on the path ("if the front does not prevent it ... another path").
- [ ] D8 AC-6 has no number, percentile, load or measuring point, and no evidence line.
- [ ] D9 AC-8 (LLM never includes private notes) has no cases, number of runs or way to force the case; AC-9 needs a real inbox and says so nowhere (environment dependency).
- [ ] D10 "Agreed" contains an item marked pending validation with the PM; the open questions have no stage (before freeze / during / out of scope).
- [ ] D11 Contradiction: 20 cases (Agreed, Risks) vs 25 cases (AC-3).
- [ ] D12 Missing cases: duplicate or retried digest (only mentioned as a risk), failure of the mailer, agent with zero cases handled only as an open question, timezone edge cases.
- [ ] The answer gives a clear verdict on whether the spec can be frozen (it cannot).
- [ ] Pass: at least 9 of D1..D12 found. Verdict is PASS only if this holds and the verdict bullet holds.
- [ ] Guard: the answer does not call AC-1, AC-2 or the "Out of scope" item defective.

## Purpose (scorer only)
Tests that the review covers the guide's rule families (mechanisms, assumptions, contracts, criteria form, measurability, verifiability, decision status, consistency, cases) instead of only the obvious ones. AC-1 and AC-2 are deliberately correct.

## Results

### baseline — 2026-10-24
- Verdict: FAIL (guard bullet only); discovery is strong without the skill.
- Found: D1 (#14), D2 (#16), D3 partly (#2: names the mailer refactor, asks for the PR/owner; no dated assumptions), D4 partly (#13: asks about collisions, does not say "refer by concept"), D5 (#3), D6 (#5, #8, #9), D7 (#4), D8 (#7), D9 (#6, #8; AC-9 framed as manual process, not as environment dependency), D10 (#12, #17), D11 (#1), D12 (#11, #12). 12 of 12 at least in part; the verdict "do NOT freeze as-is" is present.
- Guard FAIL: flagged AC-1 as under-specified (#10: timezone source, DST).
- Notable: the answer is a long numbered list of 17 items with a "minimum before the meeting" section; no yes/no pass over the rule families, nothing tied to a status of decisions.
- Classification: **guard** (the runner already finds the seeded defects). Its value is in with-skill runs: same coverage, in checklist form, without inventing new defects in AC-1/AC-2.

### green-1 — 2026-10-24
- Verdict: PASS.
- D1..D12 all found, each tied to a principle (P1, P2, P3, P5, P6, P7, P8, P9): D3 as dated assumptions (mailer synchronous, refactor PR named, ~6 weeks since the spec against the ~3-week rule), D4 "refer to them by concept", D5 "replace the copy with a link and write 'I need'", D9 with cases, runs per case and a way to force the case (seeded marker in the private notes) and the real-inbox dependency. Verdict "cannot freeze as is".
- Guard: PASS. A "Parts that comply" section names AC-1, AC-2, the Out-of-scope item and the context. One residual note says AC-1 lacks a verification path for the timezone clock (a P6 point, not a defect claim).
- Shape: grouped by principle with a blocker list and a suggested order for the hour left; it did not rewrite the spec.
- Difference from baseline: same coverage, but organised by principle, the explicit compliant-parts section removes the false alarm on AC-1, and the reserved-code and dated-assumption defects get the specific fix instead of a generic "check for collisions".
