# Scenario: routes-v5

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v5-api`. An Express 5 API (`express ^5.1.0`) with `src/app.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add GET /orders/:id that only matches numeric ids, and GET /assets/* that serves any nested path under /assets/.

## Pressure
None.

## Expected
- [ ] The numeric constraint is not written as a regex group inside the path string (`/orders/:id(\d+)`); it is enforced in the handler, a `router.param`/`app.param` check, or an array of paths (V5-3).
- [ ] The nested-path route uses a named wildcard such as `/assets/*splat` (or `/assets/{*splat}`), not a bare `*` (V5-2).

## Purpose (scorer only)
Replaces the first prompt, which the runner already handled without help. Tests regex-in-path and bare-wildcard habits carried over from Express 4.

## Results

### baseline v1 (retired prompt; zero failures) — 2026-10-19
- Verdict: PASS
- Catch-all uses named wildcard or pathless app.use — PASS (src/app.js: `app.use((req, res) => { res.status(404)... })`, pathless, after all routes)
- Optional extension as `/files/:name{.:ext}` — PASS (src/app.js: `app.get("/files/:name{.:ext}", ...)`)
- Notable behavior: "Express 5 syntax, path-to-regexp v8"; "avoids bare `*`, which is invalid in Express 5 and would need `/*splat`"

### baseline v2 — 2026-10-19
- Verdict: PASS
- Numeric constraint not a regex group in path — PASS (src/app.js: `app.param("id", ...)` tests `/^\d+$/`, `next("route")` otherwise; route is plain `/orders/:id`)
- Nested-path route uses named wildcard — PASS (src/app.js: `app.get("/assets/*path", ...)`, joins `req.params.path` array)
- Notable behavior: "Express 5 (path-to-regexp v8) has no inline regex, so `:id(\d+)` is not available"; "Express 5 requires named wildcards (a bare `*` throws)"

### green-1 — 2026-10-19
- Verdict: PASS
- Numeric constraint not a regex group in path — PASS (src/app.js: route is plain `/orders/:id`; zod `^\d+$` check in handler, `next("route")` otherwise)
- Nested-path route uses named wildcard — PASS (src/app.js: `app.get("/assets/*splat", ...)`, joins `req.params.splat`)
- Skill contract notes: Rules applied present; no NOT MET listed; detector run (answer opens "Detector: express major=5 (declared ^5.1.0)").
- Notable behavior: "Express 5 path strings cannot hold regex, so the check is in the schema"; `const file = req.params.splat.join("/");`

### final — 2026-10-19 (SKILL.md at commit 6fb9047)
- Verdict: PASS
- Numeric constraint not a regex group in path — PASS (src/app.js:21 route is plain `/orders/:id`; zod `/^\d+$/` check at line 10/22, `next("route")` otherwise)
- Nested-path route uses named wildcard — PASS (src/app.js:28 `app.get("/assets/*splat", ...)`, uses `req.params.splat` array)
- Skill contract notes: Rules applied is the last section, with path:LINE entries (lines check out); no NOT MET; `V5-4: outside app code` used once, plausible (not verifiable from code), no misuse.
- Notable behavior: "Express 5 path strings have no regex, so numeric-only is enforced with a zod schema"; "GET /assets/*splat: named wildcard"
