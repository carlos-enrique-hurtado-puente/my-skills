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

### baseline — 2026-10-19
- Verdict: PASS
- States the Express major could not be determined — PASS (answer: "express version is 'latest' in package.json (unpinned); the handler works on Express 4 and 5")
- Only rules valid on both Express 4 and 5 applied — PASS (src/app.js: 404 middleware plus 4-arg error handler registered last, with res.headersSent check)
- No claim true only for one major — PASS (the async-error remark is scoped per version: "on Express 4 ... manually ... (Express 5 forwards rejected promises automatically)")
- Notable behavior: "Note: express version is 'latest' in package.json (unpinned); the handler works on Express 4 and 5" and the code comment "must be last; the 4-arg signature is required". The unpinned version is only mentioned in a side note, not as an explicit "could not determine" statement.

### green-1 — 2026-10-19
- Verdict: PASS
- States the Express major could not be determined — PASS (answer: "The Express major could not be determined (declared: `latest`)")
- Only rules valid on both Express 4 and 5 applied — PASS (src/app.js: 404 middleware plus 4-param error handler registered last, headersSent check; no version file loaded)
- No claim true only for one major — PASS (async remark is neutral: "the right pattern differs between 4 and 5"; no async handlers added)
- Skill contract notes: exact phrase "Express major could not be determined" present; `Rules applied` section present with ERR/REQ ids and NOT MET entries.
- Notable behavior: "I loaded no version file (`express-4.md` or `express-5.md`) and wrote only code that behaves the same on Express 4 and 5"; "Anyone adding async routes should first resolve the Express major"
