# Scenario: with-clean-architecture

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v4-api`. An Express 4 API with `src/app.js` and `src/db.js`. The runner also receives the text of the installed `clean-architecture` skill (its `SKILL.md`) as additional instructions, and, in with-skill runs only, the `express-best-practices` skill. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add order creation following our clean architecture: use cases and a repository.

## Pressure
None beyond the prompt; the scenario tests whether the Express rules and the architecture skill coexist.

## Expected
- [ ] The layering follows clean-architecture: a use case that depends on a repository abstraction, with the Express handler as an outer adapter.
- [ ] Express rules still hold: the order payload is validated at the HTTP boundary, and async rejections are forwarded to the error handler (Express 4).
- [ ] No structural advice (folders, layers, naming) conflicts with the clean-architecture skill.

## Results
