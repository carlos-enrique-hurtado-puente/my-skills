# Scenario: async-v4

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v4-api`. An Express 4 API (`express ^4.19.0`) with `src/app.js` and an async db helper in `src/db.js` (`findUserById(id)`, `ping()`). The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add GET /users/:id/export that loads the user with the db helper, writes a CSV of the user to a file with the callback version of fs.writeFile (not fs/promises), and responds with the file path.

## Pressure
Keep the change small: one route, no new dependencies.

## Expected
- [ ] A rejection from the db helper reaches the error handler, through a wrapper or `.catch(next)` or an explicit `next(err)`, not left as an unhandled rejection (V4-1).
- [ ] An error from the `fs.writeFile` callback is passed to `next(err)` (or the callback is wrapped into a promise that is awaited inside a handler that forwards rejections); it is not ignored, thrown inside the callback, or answered only with a local `res.status(...)` (ERR-2).
- [ ] The error middleware has 4 parameters and is registered after the routes (ERR-1, REQ-1).
- [ ] No Express 5-only reliance (an unwrapped async handler depending on automatic rejection forwarding).

## Purpose (scorer only)
Replaces the first prompt, which the runner already handled without help. Tests the callback-API error path and Express 4 async forwarding in one route.

## Results

### baseline v1 (retired prompt; zero failures) — 2026-10-19
- Verdict: PASS
- Rejection reaches error handler via wrapper or .catch(next) — PASS (src/app.js: try/catch around await findUserById, `next(err)` in catch)
- Error middleware has 4 params and is registered after routes — PASS (src/app.js: `app.use((err, req, res, next) => ...)` after the /users/:id route)
- No Express 5-only syntax — PASS (route is `/users/:id`; async handler explicitly forwards errors, no reliance on auto rejection forwarding)
- Notable behavior: "Express 4 does not handle rejected promises from async handlers, so the handler wraps the await in try/catch and calls next(err)." Also code comment: "Express 4 does not catch rejected promises; forward to the error handler."

### baseline v2 — 2026-10-19
- Verdict: FAIL
- db rejection reaches error handler — PASS (src/app.js: try/catch around `await findUserById`, `next(err)` in catch)
- fs.writeFile callback error passed to next(err) — PASS (src/app.js: `fs.writeFile(filePath, csv, (err) => { if (err) return next(err); ...`)
- Error middleware has 4 params, registered after routes — FAIL (src/app.js defines no error middleware at all; errors fall to Express default handler)
- No Express 5-only reliance — PASS (async handler wrapped in try/catch with explicit next(err))
- Notable behavior: "Express 4 does not catch rejected promises from async handlers, so errors are forwarded to next() explicitly." Final answer: "I could not run the route because express is not installed in the project."
