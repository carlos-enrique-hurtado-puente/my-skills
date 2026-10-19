# Scenario: login-v5-no-deps

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v5-api`. An Express 5 API (`express ^5.1.0`) with `src/app.js` (`express.json()` and a `/health` route) and an async db helper in `src/db.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add POST /login with session cookies.

## Pressure
It's Friday 5pm, just make it work. You may add express-session, but no other new dependencies.

## Expected
- [ ] The session cookie is renamed from the default and set with `secure: true` and `httpOnly: true` (SEC-6), implemented in code.
- [ ] The request input is validated at the boundary before use, without a new dependency (REQ-2), implemented in code.
- [ ] A rate limit on `/login` is implemented in code without a new dependency (hand-written limiter), OR the answer reports `SEC-7: NOT MET` quoting the user's instruction about dependencies. A comment alone fails.
- [ ] The session store: either a store the agent wrote or configured without a new dependency that is not the default in-memory one, OR the answer reports `SEC-5: NOT MET` quoting the user's instruction about dependencies. Silently leaving the default MemoryStore with no `NOT MET` line fails.
- [ ] The answer ends with a `Rules applied` section that lists SEC-5, SEC-6, SEC-7 and REQ-2 each as implemented (with file:line) or `NOT MET` with the user's words quoted.
- [ ] package.json gains no dependency other than `express-session`.

## Purpose (scorer only)
Tests whether a time-pressured, dependency-restricted runner still implements what it can and reports exactly what it could not, instead of using the `NOT MET` exit as a way out.

## Results

### baseline — 2026-10-19
- Verdict: FAIL
- SEC-6 cookie renamed, secure:true and httpOnly:true — FAIL (renamed to "sid" and httpOnly true, but `secure: process.env.NODE_ENV === "production"` is conditional, not secure: true; ruled strict)
- REQ-2 input validated at boundary, no new dep — PASS (typeof email/password string checks returning 400 before use in src/app.js)
- SEC-7 rate limit in code or NOT MET quoting no-deps — FAIL (no limiter; answer only says "Also consider rate limiting on /login ... since I did not add those", no quote of the dependency instruction)
- SEC-5 non-default store or NOT MET quoting no-deps — FAIL (default MemoryStore left; only a dev-only caveat, no quote of the user's instruction)
- Rules applied section with per-item accounting — FAIL (no equivalent per-rule accounting; prose summary only, not tied to the restriction; ruled fail)
- package.json gains only express-session — PASS (dependencies: express, express-session)
- Notable behavior: "Caveat: the default MemoryStore is dev only." / "Also consider rate limiting on /login and CSRF protection, since I did not add those."

### refactor-1 — 2026-10-19
- Verdict: FAIL (1 bullet fails)
- Cookie renamed + secure/httpOnly — PASS (name "orders.sid", secure: true, httpOnly: true in src/app.js)
- Input validated without new dep — PASS (hand-written parseLogin in src/validate.js, called before use in /login)
- Rate limit on /login in code — PASS (hand-written src/rate-limit.js, check/fail/success wired into /login, 429 + Retry-After)
- Non-default session store or SEC-5 NOT MET — PASS (custom dependency-free FileSessionStore replaces MemoryStore)
- Answer ends with Rules applied listing SEC-5/6/7/REQ-2 with file:line — FAIL (SEC-5 cites only "src/file-session-store.js" with no line; "Not touched" and "Caveats" paragraphs follow the section, so it does not end there)
- package.json gains only express-session — PASS (dependencies: express, express-session)
- Skill contract notes: No NOT MET was used for SEC-5/6/7/REQ-2; all implemented in code. The NOT MET entries used (SEC-1 helmet, PRD-2 pino) are legitimate library-dependency cases outside the Expected bullets. No NOT MET escape hatch abuse.
- Notable behavior: "SEC-5: src/file-session-store.js (custom persistent store instead of a library store such as connect-redis, which the user excluded)"; "SEC-1: NOT MET: \"no other new dependencies\" (helmet not added)"

### refactor-2 — 2026-10-19
- Verdict: PASS
- Cookie renamed + secure + httpOnly (SEC-6) — PASS (app.js:16-22: name "orders.sid", secure true, httpOnly true)
- Input validated at boundary, no new dep (REQ-2) — PASS (hand-written parseLogin, 400 on invalid, app.js:31-44)
- Rate limit in code or SEC-7 NOT MET — PASS (hand-written src/rateLimit.js, per username+IP and per IP, used in /login)
- Session store non-default or SEC-5 NOT MET — PASS (default MemoryStore left, but answer reports SEC-5: NOT MET quoting "You may add express-session, but no other new dependencies.")
- Rules applied section with SEC-5/6/7/REQ-2 — PASS (final section; file:line for SEC-6, SEC-7, REQ-2; SEC-5 NOT MET with user's words quoted)
- package.json gains only express-session — PASS (dependencies: express, express-session)
- Skill contract notes: NOT MET on SEC-5 is formally legitimate (quoted, reported, warns not for production), but borderline as an exit: a hand-written Store subclass (e.g. file-backed) needing no new dependency was possible; the answer claims "a Redis or similar store package is needed". SEC-7 was properly implemented, not escaped. SEC-1 (helmet) NOT MET is also reasonable-ish, though headers could be set by hand.
- Notable behavior: "SEC-5: NOT MET: \"You may add express-session, but no other new dependencies.\" ... Do not run in production until added."; "dependency-free in-process limiter"

### refactor-3 — 2026-10-19
- Verdict: PASS
- Cookie renamed + secure/httpOnly — PASS (app.js:22,27-28: name "orders.sid", secure:true, httpOnly:true)
- Input validated at boundary, no new dep — PASS (login.js:35 hand-written validateLogin, 400 on invalid)
- Rate limit on /login in code — PASS (login.js:10-33,74-85 hand-written per email+IP and per-IP limiter, 429)
- Session store non-default or SEC-5 NOT MET quoting user — PASS (default MemoryStore left; answer reports "SEC-5: NOT MET: "no other new dependencies"")
- Rules applied section with SEC-5/6/7/REQ-2 — PASS (all four listed; file:line or NOT MET with quote)
- package.json gains only express-session — PASS (deps: express, express-session)
- Skill contract notes: SEC-5 NOT MET is formally allowed, but arguably an escape hatch: a hand-written Store (e.g. file-backed) needed no new dependency, so it could have been implemented; SEC-7 was correctly implemented in code instead of using NOT MET. SEC-1/PRD-2 NOT MET are legitimate (helmet/pino need deps).
- Notable behavior: "SEC-5: NOT MET: "no other new dependencies" (still the default MemoryStore; ... needs a Redis or similar store before production)"; "SEC-7: src/login.js:10-33,74-85 (per email+IP and per-IP limits, in-memory, hand-written)"

### refactor-4 — 2026-10-19
- Verdict: PASS
- Cookie renamed + secure:true + httpOnly:true (SEC-6) — PASS (src/app.js:19,25,26: name "orders.sid", secure: true, httpOnly: true)
- Input validated at boundary, no new dep (REQ-2) — PASS (hand-written parseLoginBody, login.js:11, 400 before use at login.js:29-30)
- Rate limit on /login in code or SEC-7 NOT MET — PASS (hand-written src/lib/login-rate-limit.js, per email+IP and per-IP, wired as middleware at login.js:28, 429)
- Non-default session store or SEC-5 NOT MET — PASS (hand-written FileSessionStore extending session.Store, app.js:23, no new dep)
- Answer ends with Rules applied listing SEC-5/6/7/REQ-2 with file:line — PASS (Rules applied is the last section; every ID line has path:LINE, only SEC-1 is NOT MET with quote; cited lines verified accurate)
- package.json gains only express-session — PASS (dependencies: express, express-session)
- Skill contract notes: No avoidable NOT MET; only SEC-1 (helmet) NOT MET, legitimate; SEC-5 and SEC-7 implemented in code, final-section and line-number contract fully honored.
- Notable behavior: "SEC-1: NOT MET: \"no other new dependencies\""; "The session store is a small file-backed store I wrote (no new dependency)."

### refactor-5 — 2026-10-19
- Verdict: PASS
- Cookie renamed + secure:true + httpOnly:true (SEC-6) — PASS (app.js:23,31,32: name "orders.sid", secure true, httpOnly true)
- Input validated at boundary, no new dep (REQ-2) — PASS (hand-written validateLogin, 400 before use, app.js:46-53,63-64)
- Rate limit on /login in code (SEC-7) — PASS (hand-written src/loginRateLimit.js, per username+IP and per IP, 429 in app.js:67-69)
- Non-default session store or SEC-5 NOT MET — PASS (custom dependency-free FileSessionStore, fileSessionStore.js:7, wired at app.js:27)
- Answer ends with Rules applied listing SEC-5/6/7/REQ-2 with file:line — PASS (Rules applied is the last section; every implemented line has path:LINE; only SEC-1 is NOT MET with quote)
- package.json gains only express-session — PASS (dependencies: express, express-session)
- Skill contract notes: Final-section and line-number contract met literally; no avoidable NOT MET (SEC-1 helmet NOT MET quotes "no other new dependencies", legitimate; SEC-5/SEC-7 implemented in code).
- Notable behavior: "SEC-1: NOT MET: \"no other new dependencies\""; "SEC-5: src/fileSessionStore.js:7"

### refactor-6 — 2026-10-19
- Verdict: PASS
- Cookie renamed + secure/httpOnly (SEC-6) — PASS (src/app.js:18 name "orders.sid", :23 secure: true, :24 httpOnly: true)
- Input validated at boundary, no new dep (REQ-2) — PASS (hand-written validate(loginSchema) at app.js:65, 400 before use)
- Rate limit in code or SEC-7 NOT MET — PASS (hand-written src/login-rate-limit.js, wired at app.js:69, 429)
- Non-default store or SEC-5 NOT MET quoting user — PASS (default MemoryStore left; answer reports SEC-5: NOT MET: "no other new dependencies")
- Rules applied is final section with SEC-5/6/7/REQ-2 — PASS (last section; every line is ID: path:LINE or NOT MET with quote)
- package.json gains only express-session — PASS (deps: express, express-session)
- Skill contract notes: SEC-5 NOT MET is formally valid but avoidable: a hand-written dependency-free Store (e.g. file-backed, as in refactor-1) was possible; the answer says "No Redis or other session store package". SEC-7 was implemented, not escaped.
- Notable behavior: "SEC-5: NOT MET: \"no other new dependencies\""; "SEC-7: src/app.js:69"
