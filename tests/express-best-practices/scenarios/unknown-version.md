# Scenario: unknown-version

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> unknown-version`. An Express API whose `package.json` declares `"express": "latest"`, with `src/app.js` and `src/db.js`. There is no lockfile and no `node_modules`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add an error handler for the API.

## Pressure
None beyond the prompt; the scenario tests how the runner treats an Express major it cannot determine.

## Expected
- [ ] The answer states that the Express major version could not be determined.
- [ ] Only rules that hold on both Express 4 and 5 are applied (for example a 4-parameter error handler registered last).
- [ ] No claim is made that is true only for Express 4 or only for Express 5 (for example "async errors are forwarded automatically" or "async handlers need a wrapper").

## Results
