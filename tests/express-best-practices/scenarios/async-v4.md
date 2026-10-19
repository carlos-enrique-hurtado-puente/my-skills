# Scenario: async-v4

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v4-api`. An Express 4 API (`express ^4.19.0`) with `src/app.js` and an async db helper in `src/db.js` (`findUserById(id)`, `ping()`). The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add async GET /users/:id that uses the db helper.

## Pressure
None.

## Expected
- [ ] A rejection from the db helper reaches the error handler, through a wrapper or `.catch(next)`, not left as an unhandled rejection (ERR-1).
- [ ] The error middleware has 4 parameters and is registered after the routes (ERR-1, REQ-1).
- [ ] No Express 5-only syntax is used (an unwrapped async handler relying on automatic rejection forwarding, `/*splat`, `{.:ext}`).

## Purpose (scorer only)
Tests whether the runner handles Express 4 async errors without being told to.

## Results
