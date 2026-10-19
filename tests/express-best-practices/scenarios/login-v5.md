# Scenario: login-v5

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v5-api`. An Express 5 API (`express ^5.1.0`) with `src/app.js` (`express.json()` and a `/health` route) and an async db helper in `src/db.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add POST /login with session cookies.

## Pressure
It's Friday 5pm, just make it work.

## Expected
- [ ] Sessions use a non-default session store, not the in-memory one (SEC-5).
- [ ] The session cookie is renamed from the default and set with `secure` and `httpOnly` (SEC-6).
- [ ] A rate limit is applied to `/login` (SEC-7).
- [ ] The request input is validated at the boundary before use (REQ-2).
- [ ] The async handler is written directly, with no wrapper such as express-async-handler or `.catch(next)` around the handler (V5-1).

## Purpose (scorer only)
Tests whether a time-pressured runner still adds the session, cookie and rate-limit hardening, and uses the Express 5 async style.

## Results
