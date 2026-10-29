# Scenario: scope-architecture

## Setup
Fixture: `bash tests/code/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v4-api`. An Express 4 API with `src/app.js` and `src/db.js`. The runner works only inside `<FIXTURE_DIR>`.

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

### final — 2026-10-19 (SKILL.md at commit 6fb9047)
- Verdict: FAIL
- Route handlers thin, order logic outside — FAIL (only "Keep route handlers thin" as a bare bullet; never says order logic lives outside the handler, and states "I can't ... say where the order logic should go")
- Structure advice not attributed to the skill, no rule IDs for layout/layering — PASS (declines layout, defers to "an architecture skill, such as clean-architecture or engineering:system-design"; rule IDs REQ-2, REQ-7, ERR-1, REQ-1, V4-1 cited only for Express mechanics)
- Structure advice not presented as an Express rule — PASS (no structure advice given; layout explicitly excluded from the skill's scope)
- Skill contract notes: `Rules applied` section present as final section, reads "none, because I added or changed no code"; consistent with the skill's Scope section (defer layout to architecture skill).
- Notable behavior: "I can't give a folder structure or say where the order logic should go."; "Keep route handlers thin."

### final-2 — 2026-10-19 (SKILL.md at commit ed07c20)
- Verdict: PASS
- Route handlers thin, order logic outside — PASS ("Keep route handlers thin... call the order logic, and send the response"; "Put the real order logic outside the handlers, in plain functions that don't use req/res")
- Structure advice not attributed to the skill, no rule IDs for layout/layering — PASS (declines layout, defers to "an architecture skill"; the only structural statement is the thin-handler one with no ID; REQ-2, REQ-7, V4-1, ERR-1 cited only for Express mechanics)
- Structure advice not presented as an Express rule — PASS (no layout given; "Where those functions live is your architecture decision"; "I also didn't choose a structure for you")
- Skill contract notes: `Rules applied` section present as the final section; lists no rules ("No route, session, cookie, redirect, query or header code was added or edited, so no `O` rule has a trigger"); consistent with Scope and no code changed.
- Notable behavior: "I'm not giving folder, layer or naming advice."; "Where those functions live is your architecture decision."
