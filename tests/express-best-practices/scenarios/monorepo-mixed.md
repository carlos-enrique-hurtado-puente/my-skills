# Scenario: monorepo-mixed

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> mono`. A monorepo with two services: `apps/api4` (`express ^4.19.0`) and `apps/api5` (`express ^5.0.0`), each with its own `package.json`, `src/app.js` and `src/db.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add GET /users/:id to both services, using the db helper.

## Pressure
None.

## Expected
- [ ] `apps/api4` forwards async rejections explicitly (wrapper or `.catch(next)` or try/catch with `next(err)`).
- [ ] `apps/api5` uses no wrapper or try/catch to forward rejections.
- [ ] Each service is treated by its own major: neither service gets the other's pattern.

## Purpose (scorer only)
Tests whether the runner treats each service by its own Express major.
The first prompt (a /healthz endpoint) was retired: a health check should catch its own failure and answer 503, so no error-forwarding behavior could be graded. A user lookup is a route where forwarding the error is the natural handling.

## Results

### baseline v1 (retired prompt: /healthz is a legitimate catch-and-503) — 2026-10-19
- Verdict: FAIL
- api4 forwards async rejections explicitly — FAIL (apps/api4/src/app.js uses try/catch but answers 503 itself; never calls next(err) or a wrapper)
- api5 uses no wrapper/try-catch — FAIL (apps/api5/src/app.js has the identical try/catch block)
- Each service treated by its own major — FAIL (byte-identical handler in both; no per-major treatment)
- Notable behavior: "I wrapped the handler in try/catch instead of relying on Express 5's automatic async error handling." and "so the same code is correct on both versions."

### green-1 v1 (retired prompt: /healthz is a legitimate catch-and-503) — 2026-10-19
- Verdict: FAIL
- api4 forwards async rejections explicitly — FAIL (apps/api4/src/app.js /healthz uses try/catch but answers 503 itself; no next(err), wrapper or .catch(next))
- api5 uses no wrapper/try-catch — FAIL (apps/api5/src/app.js /healthz has the same try/catch block)
- Each service treated by its own major — FAIL (the two /healthz handlers are byte-identical; the answer claims they differ, but the code does not)
- Skill contract notes: Rules applied present; REQ-2 NOT MET is justified (no user input); detector run (reported majors 4 and 5); answer's claim of per-major handlers is not backed by the code.
- Notable behavior: "The handlers are not identical across majors." (answer) vs. identical `try { await db.ping(); ... } catch (err) { res.status(503)... }` in both files

### baseline v2 — 2026-10-19
- Verdict: PASS
- api4 forwards async rejections explicitly — PASS (apps/api4/src/app.js: try/catch with `next(err)`)
- api5 uses no wrapper/try-catch — PASS (apps/api5/src/app.js: plain async handler, no try/catch or wrapper)
- Each service treated by its own major — PASS (api4 has the try/catch + next, api5 plain async; neither has the other's pattern)
- Notable behavior: "since Express 4 does not catch rejected promises from async handlers" and "plain async handler, since Express 5 forwards rejected promises to the error handler automatically"

### green-2 — 2026-10-19
- Verdict: PASS
- api4 forwards async rejections explicitly — PASS (apps/api4/src/app.js: try/catch with `next(err)` in GET /users/:id)
- api5 uses no wrapper/try-catch — PASS (apps/api5/src/app.js: bare `async (req, res)` handler, no try/catch or .catch)
- Each service treated by its own major — PASS (api4 has try/catch + next, api5 bare async; neither has the other's pattern)
- Skill contract notes: Detector run (answer reports majors 4 and 5); Rules applied present; per-service claims (V4-1 try/catch, V5-1 no wrapper) match the code.
- Notable behavior: "api5: bare async handler, no wrapper or `.catch(next)` (V5-1)." and `} catch (err) { next(err); }` in api4

### final — 2026-10-19 (SKILL.md at commit 6fb9047)
- Verdict: PASS
- api4 forwards async rejections explicitly — PASS (apps/api4/src/app.js:17-30 try/catch with `next(err)`)
- api5 uses no wrapper/try-catch — PASS (apps/api5/src/app.js:17-27 bare `async (req, res)`, no try/catch or .catch)
- Each service treated by its own major — PASS (api4 has try/catch + next, api5 bare async; neither has the other's pattern; package.json majors 4 and 5 match)
- Skill contract notes: Detector run with `--root .` (answer reports majors 4 and 5); `Rules applied` is the last section with `ID: path:LINE` entries; per-service claims match the code.
- Notable behavior: "Each service got its own version-specific handler; nothing was copied across unchanged." and `} catch (err) { next(err); }` in api4
