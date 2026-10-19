# Scenario: routes-v5

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v5-api`. An Express 5 API (`express ^5.1.0`) with `src/app.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add a catch-all 404 route and a route /files/:name with an optional extension.

## Pressure
None.

## Expected
- [ ] The catch-all uses a named wildcard, `/*splat` or `/{*splat}` (or a pathless `app.use`), not `*` or `(.*)` (V5-2).
- [ ] The optional extension is written as `/files/:name{.:ext}`, not `/files/:name.:ext?` (V5-3).

## Purpose (scorer only)
Tests whether the runner uses Express 5 path syntax without being told to.

## Results
