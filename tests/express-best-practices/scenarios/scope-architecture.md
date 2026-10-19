# Scenario: scope-architecture

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v4-api`. An Express 4 API with `src/app.js` and `src/db.js`. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Where should the order logic go and how should I lay out the folders? Just tell me your best structure.

## Pressure
None.

## Expected
- [ ] Route handlers are kept thin: HTTP concerns in the handler, order logic outside it.
- [ ] The structure advice is not attributed to this skill: no rule IDs are cited for folder layout or layering.
- [ ] The structure advice is not presented as an Express rule or requirement (it is offered as a design choice).

## Purpose (scorer only)
The prompt itself ("Just tell me your best structure") pushes for an opinionated answer. Tests that structure advice stays outside this skill's scope.

## Results

### baseline — 2026-10-19
- Verdict: PASS
- Route handlers thin, order logic outside — PASS (answer: "Route/controller (HTTP only)... No business rules"; rules live in orders.service.js)
- Structure advice not attributed to the skill, no rule IDs — PASS (no skill present; no rule IDs cited for layout or layering)
- Structure advice not presented as an Express rule — PASS (framed as a design recommendation: "Group by feature... rather than by type"; "Do not over-build")
- Notable behavior: "Use three layers, split by responsibility. Only the service holds business rules."; "Do not over-build. At this size, you can start with orders.routes.js, orders.service.js, orders.repository.js"

### green-1 — 2026-10-19
- Verdict: PASS
- Route handlers thin, order logic outside — PASS (out/scope-architecture.md: "Keep the route handler thin... The real logic belongs outside the handler.")
- Structure advice not attributed to the skill, no rule IDs for layout/layering — PASS (declined layout: "I'm not recommending a folder layout or layer names"; rule IDs cited only for Express mechanics REQ-2, V4-1, ERR-*)
- Structure advice not presented as an Express rule — PASS (no structure advice given; "folders, layers and naming belong to an architecture skill")
- Skill contract notes: Rules applied section present, listing REQ-1, REQ-2, REQ-4 (src/app.js:12-14), V4-1, ERR-1, ERR-3, mostly NOT MET since no files changed; matches Scope section (defer layout to architecture skill).
- Notable behavior: "I'm not recommending a folder layout or layer names."; "run your architecture skill (for example clean-architecture...) ... I haven't invoked it."
