# Support levels and test results

## How to read the support levels
- **Backed:** several sources agree.
- **Partial:** one source covers part of it and the rest is the team's own rule.
- **Own:** it comes from the team's tickets and no source covers it.
- **Hypothesis:** reasonable, not validated.

| Principle | Level |
|---|---|
| P1 behavior first | Backed |
| P2 self-sufficient | Partial |
| P3 assumptions, design reconciliation | Partial; reconciliation barely tested |
| P4 size by surface | Hypothesis; weak as a predictor |
| P5 criteria and tasks | Backed (shape); Own (the rest) |
| P6 verifiability | Backed (measurable form); Own (the rest) |
| P7 close the cases | Partial |
| P8 decision status | Backed |
| P9 contracts | Backed, adapted from HTTP services to Firestore and callable functions |

## Evidence base
- Six specs compared with their tickets, subtickets and comments: ITV-831 (recoveries backend), ITV-835 (recoveries front), ITV-813, ITV-804, ITV-823, ITV-878.
- Twelve more stories of sprints 15 and 16, read with their specs, tickets and QA evaluations.
- Blind tests (a reviewer saw only the guide and the spec, and wrote predictions that were compared with what happened later):
  - Round 1: five Sprint 15 specs, not used to derive the guide. Of 25 evaluable signals, 20 were right at least in part.
  - Round 2: four specs, previous guide against new guide, with a blind judge: 78 % of evaluable signals right at least in part (54 % with the previous guide); 5 false alarms (12).
  - Round 3: eight specs by other authors. Rounds 2 and 3 together: 72 % against 57 %; 18 false alarms against 26; 66 of 107 real changes anticipated against 58.
- Most reliable rules: P6 (right in all nine units of rounds 2 and 3), P9 (first real test, no false alarms), P8, P1.
- Weak or untested: P4 sizes a spec but did not predict friction (two of three signals failed in round 3); P3 design reconciliation was barely tested because no spec depended much on a Figma.

## Limits of the evidence
- All specs come from one team.
- PR diffs were not read.
- The reasons for many changes are inference, because the dev's comment does not always explain them.
- One pair of reviewers per spec; many signals have no evidence because tickets have few comments.
- The "before → after" examples are illustrative, rewritten from the specs, not their original text.

## What no version of the guide anticipates
Decisions that the dev, the LT or the PM change during implementation or code review (seven cases: ITV-734, 754, 735, 736, 888/883, 866, 707). It is process. The guide only makes the reason and status of each decision visible. Whether the LT should review decisions before freezing is still open with the team.

## Candidates not applied (not enough evidence)
Destructive operations with no way back, cost of data operations, data stored before the change, LT self-approval and privacy of customer data. Reviewers raise them repeatedly, with no observed effect on tickets.

## Note on sources
The pages were read through a summarizing tool, so details are paraphrase. Confirm a source before quoting it outside the team.
