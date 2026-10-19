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

### baseline — 2026-10-19
- Verdict: PASS
- uncaughtException keeps process running (ERR-8) — PASS (item 6: "Logging and continuing leaves the process in an undefined state"; log, exit non-zero)
- console.log instead of structured logger (PRD-2) — PASS (item 19: "`console.log` only. Use structured logging (pino)")
- trust proxy true (SEC-8) — PASS (item 5: set to exact hop count, spoofable X-Forwarded-For)
- express-session default MemoryStore (SEC-5) — PASS (item 3: use Redis or another persistent store)
- default cookie name connect.sid (SEC-6) — PASS (item 4: custom `name` (avoid the default `connect.sid`))
- no helmet (SEC-1) — PASS (item 12: "Add `helmet`")
- x-powered-by not disabled (SEC-2) — PASS (item 12: `app.disable("x-powered-by")`)
- 3-param error handler (ERR-1) — PASS (item 1: `function (err, req, res)` has 3 arguments, needs `next`)
- inline app.listen, app not importable (REQ-4) — PASS (item 22: "Separate `app` from `listen`" so it can be tested)
- With-skill rule IDs cited — N/A (baseline run)
- Notable behavior: "Verdict: not production ready." Thorough review with 24 findings; also added extras (IDOR, `users[req.params.id]` prototype lookup, saveUninitialized). Correct Express 4 awareness: "Express 4 does not catch rejected promises from async handlers".

### green-1 — 2026-10-19
- Verdict: PASS
- uncaughtException keeps process running (ERR-8) — PASS (item 2, server.js:28-30: "only logs and keeps running in an undefined state")
- console.log instead of structured logger (PRD-2) — PASS (item 10: "`console.log` is used for logging. Use pino")
- trust proxy true (SEC-8) — PASS (item 6, server.js:6: spoofable X-Forwarded-For, set hop count)
- express-session default MemoryStore (SEC-5) — PASS (item 3, server.js:8: in-memory store, use connect-redis)
- default cookie name connect.sid (SEC-6) — PASS (item 5: "keeps the default name `connect.sid`")
- no helmet (SEC-1) — PASS (item 11: "no `helmet()`")
- x-powered-by not disabled (SEC-2) — PASS (item 11: no `app.disable("x-powered-by")`)
- 3-param error handler (ERR-1) — PASS (item 1, server.js:23: 3 parameters, never called for errors)
- inline app.listen, app not importable (REQ-4) — PASS (item 15, server.js:32: tests cannot import `app`)
- With-skill rule IDs cited — PASS (every finding cites IDs: ERR-1, ERR-8, SEC-5, SEC-6, SEC-8, SEC-1/SEC-2, PRD-2, REQ-4)
- Skill contract notes: `Rules applied` section present; stayed a review ("No files were modified"); detector line reported.
- Notable behavior: "Reviewed as Express 4; loaded express-4.md, request-handling.md, errors.md, security.md, production.md." Extras beyond Expected (SEC-12 hard-coded secret, REQ-2 proto lookup, PRD-7 graceful shutdown).
