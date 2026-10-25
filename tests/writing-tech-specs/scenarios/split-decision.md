# Scenario: split-decision

## Setup
Copy `fixtures/large-spec.md` into a scratch directory `<DIR>` (outside this repo). The runner works only inside `<DIR>`.

## Invocation
Should we split the spec in `<DIR>/large-spec.md`? Decide for me.

## Pressure
The user adds: "Just give me a yes or no and the rule you used, I don't want a discussion. Is there a word or criteria limit we can apply?"

## Expected
- [ ] Does not present a numeric threshold (words, pages, criteria, hours) as the rule that decides; if it cites one, it is framed as a reference or signal, not as the cutoff.
- [ ] Reasons from several starting principles, at least three of: reviewable in one sitting; more than one independently deliverable result; parts maturing at different speeds (B blocked by open questions while A/C are decided); a big unknown; prescriptive surface or estimate mismatch.
- [ ] Weighs the brakes: the cost of the contract a cut creates, and whether each part can be deployed and verified alone (C needs A; B shares the delete path with A).
- [ ] Proposes concrete cut options (at least two, or one plus "do not split") and, for each, the contract it creates or what stays blocked.
- [ ] Prefers a cut by behavior (e.g. export A+C vs retention B) over a cut by repository, or justifies a repository cut by owners or deployment.
- [ ] Names what it needs from the dev that it cannot see (who owns or decides each part, what deploys together, urgency), instead of claiming the decision is final.
- [ ] Records the outcome as a decision with status (Proposed until the dev or LT confirms), who decides, and the discarded alternative with its reason (P8).
- [ ] Still gives the user a clear recommendation despite the pressure (not only questions).

## Purpose (scorer only)
P4 has no threshold. The skill should turn "should we split?" into a short, principled deliberation between the dev and the agent, ending in a recorded decision, without inventing a cutoff. The fixture has strong signals (B's maturity differs; A+C wanted now) and a real brake (B shares the delete path with A).

## Results

### baseline — 2026-10-25 (current skill, 2 runs)
- Verdict: FAIL in both runs (3 bullets each).
- No numeric threshold as the rule — PASS (both: "the skill sets no fixed number").
- Several principles — PASS (both: prescriptive surface vs M estimate; B blocked by before-freeze questions; reviewable in one sitting).
- Brakes weighed — run 1 PARTIAL (merge order for the shared delete path, no contract-cost weighing), run 2 PARTIAL; counted PASS.
- Concrete options with what each creates or blocks — FAIL (both give one cut; "do not split" never weighed).
- Behavior cut over repository cut — PASS (A+C vs B).
- Asks the dev what it cannot see — FAIL (both state the decision as final).
- Recorded as a decision with status, who, discarded alternative — FAIL (both).
- Clear recommendation — PASS ("Yes, split it.").
- Notable: "Yes, split it." / "The rules that do force a split are open 'before freeze' questions (P8) and unmeasurable criteria (P6)."
- Classification: **discriminating**. The failure is the shape of the answer (a verdict instead of a proposed decision with options and costs), not the judgment.

### green-1 to green-3 — 2026-10-25 (SKILL.md with "Deciding whether to split")
- Verdict: PASS in 3 of 3 runs (8 of 8 bullets each).
- No threshold as the rule — PASS (all three: "there is no word count or criteria limit, on purpose").
- Principles — PASS (all: different maturity, more than one deliverable result, estimate vs surface; runs 2 and 3 also "not reviewable in one sitting").
- Brakes — PASS (all: merge order because B shares the delete path A reads; runs 1 and 3: keeping A and C together avoids a contract "for little gain").
- Options with what each creates or blocks — PASS (all list the proposed cut plus "do not split" and "by repository" as discarded alternatives, each with its cost). Weakest in run 3, where the options appear only inside the decision row.
- Behavior cut over repository — PASS (all).
- Asks the dev — PASS (run 1: "whether B must deploy together with A, and who owns B's decisions"; run 2: "whether D can be measured now, and whether A, C and B deploy independently"; run 3: "I can't see who owns each part or what deploys together").
- P8 row — PASS (all: Proposed until the dev or LT confirms, decider, discarded alternatives with reasons).
- Clear recommendation — PASS (all: "Yes, split.").
- Variance: the three runs agree on the cut (A + C, B apart) and on the decision row; they differ only on where D goes.
