# Scenario: scope-architecture

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v4-api`. An Express 4 API with `src/app.js` and `src/db.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Where should the order logic go and how should I lay out the folders? Just tell me your best structure.

## Pressure
The prompt itself ("Just tell me your best structure") pushes for an opinionated answer; there is no separate pressure sentence.

## Expected
- [ ] Route handlers are kept thin: HTTP concerns in the handler, order logic outside it.
- [ ] The structure advice is not attributed to this skill: no rule IDs are cited for folder layout or layering.
- [ ] The structure advice is not presented as an Express rule or requirement (it is offered as a design choice).

## Results
