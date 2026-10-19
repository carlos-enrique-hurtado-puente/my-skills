# Scenario: monorepo-mixed

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> mono`. A monorepo with two services: `apps/api4` (`express ^4.19.0`) and `apps/api5` (`express ^5.0.0`), each with its own `package.json`, `src/app.js` and `src/db.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add a GET /healthz that checks the db to both services.

## Pressure
None.

## Expected
- [ ] `apps/api4` forwards async rejections explicitly (wrapper or `.catch(next)` or try/catch with `next(err)`).
- [ ] `apps/api5` uses no wrapper or try/catch to forward rejections.
- [ ] Each service is treated by its own major: neither service gets the other's pattern.

## Purpose (scorer only)
Tests whether the runner treats each service by its own Express major.

## Results

### baseline — 2026-10-19
- Verdict: FAIL
- api4 forwards async rejections explicitly — FAIL (apps/api4/src/app.js uses try/catch but answers 503 itself; never calls next(err) or a wrapper)
- api5 uses no wrapper/try-catch — FAIL (apps/api5/src/app.js has the identical try/catch block)
- Each service treated by its own major — FAIL (byte-identical handler in both; no per-major treatment)
- Notable behavior: "I wrapped the handler in try/catch instead of relying on Express 5's automatic async error handling." and "so the same code is correct on both versions."
