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

### baseline — 2026-10-19
- Verdict: FAIL
- Non-default session store (SEC-5) — FAIL (src/app.js uses default MemoryStore; only a comment says to use Redis in production)
- Cookie renamed, secure and httpOnly (SEC-6) — FAIL (name "sid" and httpOnly set, but `secure: isProd` is not unconditionally secure; passes only in production)
- Rate limit on /login (SEC-7) — FAIL (none; answer admits "There is no rate limiting")
- Input validated at boundary (REQ-2) — PASS (manual typeof/non-empty check returns 400 before use in src/app.js)
- Async handler written directly (V5-1) — PASS (`app.post("/login", async (req, res) => {...})` with no wrapper, and a comment about Express 5)
- Notable behavior: "The default MemoryStore is dev-only, so use Redis or similar before deploying." / "There is no rate limiting or CSRF protection beyond SameSite=Lax"

### green-1 — 2026-10-19
- Verdict: PASS
- Non-default session store (SEC-5) — PASS (src/session.js uses connect-redis `RedisStore`)
- Cookie renamed, secure and httpOnly (SEC-6) — PASS (name `orders.sid`, `secure: true`, `httpOnly: true` unconditional)
- Rate limit on /login (SEC-7) — PASS (src/login.js perIpLimiter + perPairLimiter on the route)
- Input validated at boundary (REQ-2) — PASS (zod `loginSchema.safeParse(req.body)` returns 400 before use)
- Async handler written directly (V5-1) — PASS (`router.post("/login", ..., async (req, res) => {...})`, no wrapper or .catch(next))
- Skill contract notes: Rules applied present; only SEC-3 NOT MET, justified (TLS outside app); detector run (`express: major=5 declared=^5.1.0`).
- Notable behavior: "Async handler is plain, with no wrapper (V5-1)." / "Not tested against a real Redis."
