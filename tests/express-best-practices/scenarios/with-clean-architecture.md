# Scenario: with-clean-architecture

## Setup
Fixture: `bash tests/express-best-practices/fixtures/make-project.sh <FIXTURE_DIR> v4-api`. An Express 4 API with `src/app.js` and `src/db.js`. The runner also receives the text of the installed `clean-architecture` skill (its `SKILL.md`) as additional instructions. The runner works only inside `<FIXTURE_DIR>`.

## Invocation
Add order creation following our clean architecture: use cases and a repository.

## Pressure
None.

## Expected
- [ ] The layering follows clean-architecture: a use case that depends on a repository abstraction, with the Express handler as an outer adapter.
- [ ] Express rules still hold: the order payload is validated at the HTTP boundary, and async rejections are forwarded to the error handler (Express 4).
- [ ] No structural advice (folders, layers, naming) conflicts with the clean-architecture skill.

## Purpose (scorer only)
Tests whether the Express rules and the architecture skill coexist. Green and refactor runs additionally receive the `express-best-practices` skill; the baseline does not.

## Results

### baseline — 2026-10-19
- Verdict: FAIL
- Layering follows clean-architecture — PASS (usecases/createOrder.js takes injected orderRepository/customerRepository ports; adapters/orderController.js is the outer adapter; app.js is composition root)
- Payload validated at HTTP boundary and async rejections forwarded (Express 4) — FAIL (validation lives only in the domain entity domain/order.js, no HTTP-boundary validation or schema; the try/catch with `next(err)` for async errors is present, but the validation half is missing)
- No structural advice conflicts with clean-architecture — PASS (no Express-skill advice given; structure is consistent with the clean-architecture skill)
- Notable behavior: "src/adapters/orderController.js: translates HTTP to use case input and maps errors to 400/404/201; does not import Express." and `const { customerId, items } = req.body || {}; const order = await createOrder({ customerId, items });` (passes raw body straight to the use case)

### green-1 — 2026-10-19
- Verdict: PASS
- Layering follows clean-architecture — PASS (application/create-order.js makeCreateOrder takes injected orderRepository/customerRepository/idGenerator ports; http/orders-router.js is the outer adapter; app.js composition root; infrastructure adapters wrap db)
- Payload validated at HTTP boundary and async rejections forwarded (Express 4) — PASS (zod bodySchema.safeParse in orders-router.js returns 400; try/catch -> next(err); central 4-arg error handler in app.js)
- No structural advice conflicts with clean-architecture — PASS (Rules applied cites only rule IDs with file:line locations; no folder/layer/naming advice attributed to the express skill)
- Skill contract notes: `Rules applied` section exists (V4-1, REQ-2, ERR-1, etc.); no structural claim attributed to the express skill.
- Notable behavior: "Thin controller: validate HTTP input, call the use case, shape the response." and "Composition root: the only place concrete adapters are wired to use cases."
