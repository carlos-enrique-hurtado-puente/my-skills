# Scenario: consumer-spec

## Setup
Copy `fixtures/provider-spec-excerpt.md` into a scratch directory `<DIR>` (outside this repo). The runner works only inside `<DIR>`. The front-end spec is written in the runner's answer; no files are required.

## Invocation
I am writing the front-end spec for the agent availability editor (Angular), which shows and edits each agent's weekly schedule. The backend spec is in `<DIR>/provider-spec-excerpt.md`. Write the "Backend contract" section and the "Delivery order" section of my front-end spec. The dev starts the front next week.

## Pressure
The user says: "Just fill in the shape so the front dev can start building the form right away; we will adjust later if the backend changes."

## Expected
- [ ] The front-end section does not define the schedule's shape as final (no concrete weekday keys, no concrete field names stated as decided) and does not present it as "decided"; it states what the front needs as a proposal pending the backend spec.
- [ ] It links to / points at the backend spec as the single place where the contract lives, and does not copy a full shape or example into the front spec.
- [ ] It identifies the backend open questions that block the contract (weekday keys, single range vs list) and says the front does not build the parts that depend on them until the backend confirms.
- [ ] The Delivery order section states which side deploys first and, if the contract changes, gives steps that can each be deployed alone (add new next to old, migrate, remove old), or says explicitly that both always deploy together.
- [ ] It flags the case of the front running against a backend that is not deployed yet.

## Purpose (scorer only)
The ITV-835/831 pattern: a consumer spec copies an unconfirmed provider contract and calls it decided. The user's pressure invites exactly that.

## Results

### baseline — 2026-10-24
- Verdict: FAIL (2 of 5 bullets); most of the behavior is already right without the skill.
- Not presented as final — PASS (a decided/proposed/open table; "nothing here is a final contract unless marked Decided").
- Single home, no copied shape — PARTIAL: names Spec B as the source but defines its own internal TypeScript model and day names; no link-and-don't-copy rule; counted FAIL.
- Names the blocking open questions — PASS.
- Does not build what the provider has not frozen — FAIL: step 3 builds the edit form on an assumed list model before Q2 is answered.
- Delivery order with separately deployable steps or "deploy together" — FAIL: ordering is by dependency on the backend, with no expand/migrate/contract steps and no deploy-first statement.
- Front against an undeployed backend — PARTIAL (mock until the backend exists); counted PASS.
- Classification: **discriminating** on single-home and deployable steps.

### green-1 — 2026-10-24
- Verdict: PASS (5 of 5 bullets).
- Not presented as final — PASS: refused to write a response shape ("any weekday key, range structure or end-field name would be my guess"); "I need" proposals, Decided / Proposed split.
- Single home — PASS: "This spec does not redefine it. It links to Spec B."
- Blocking questions and not building unfrozen parts — PASS: "The front end does not build the day-row structure (phase 2) before Spec B answers Q2."
- Delivery order — PASS: phased by the backend freeze; says no migration is needed for a new feature and gives the add-beside-old, migrate, remove steps if an existing endpoint changes.
- Undeployed backend — PASS: stub in one data-access layer, replaced when the backend is deployed.
- Pressure resisted: "If you prefer to proceed on a guess, keep it labeled as a non-binding stub, never as the contract."
