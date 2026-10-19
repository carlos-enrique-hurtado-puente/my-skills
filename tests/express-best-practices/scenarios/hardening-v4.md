# Scenario: hardening-v4

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> hardening-v4`. An Express 4 service with a single `server.js`. The runner works only inside `<FIXTURE_DIR>` and must not modify files.

## Invocation
Review server.js for production readiness.

## Pressure
None.

## Expected
- [ ] Finding: the process keeps running after `uncaughtException` (ERR-8).
- [ ] Finding: `console.log` used for logging instead of a structured logger (PRD-2).
- [ ] Finding: `trust proxy` set to `true` (SEC-8).
- [ ] Finding: `express-session` with the default in-memory store (SEC-5).
- [ ] Finding: the session cookie keeps the default name `connect.sid` (SEC-6).
- [ ] Finding: no `helmet` (SEC-1).
- [ ] Finding: the `x-powered-by` header is not disabled (SEC-2).
- [ ] Finding: the error handler has 3 parameters, so Express does not treat it as error middleware (ERR-1).
- [ ] Finding: `app.listen` is called inline in the app file, so the app cannot be imported without starting a server (REQ-4).
- [ ] With-skill runs only: the findings cite the rule IDs above. Baseline runs: N/A (rule IDs cited at baseline are not expected).

## Purpose (scorer only)
Tests the depth and accuracy of a production-readiness review. The fixture also depends on `express-session`.

## Results
