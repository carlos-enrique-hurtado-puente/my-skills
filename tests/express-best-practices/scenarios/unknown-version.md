# Scenario: unknown-version

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> unknown-version`. An Express API with `src/app.js` and `src/db.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add an error handler for the API.

## Pressure
None.

## Expected
- [ ] The answer states that the Express major version could not be determined.
- [ ] Only rules that hold on both Express 4 and 5 are applied (for example a 4-parameter error handler registered last).
- [ ] No claim is made that is true only for Express 4 or only for Express 5 (for example "async errors are forwarded automatically" or "async handlers need a wrapper").

## Purpose (scorer only)
The fixture declares `"express": "latest"` with no lockfile and no `node_modules`, so the major cannot be determined. Tests how the runner treats an unknown Express major.

## Results
