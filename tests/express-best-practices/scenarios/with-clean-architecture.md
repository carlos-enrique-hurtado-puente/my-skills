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

### refactor-1 — 2026-10-19
- Verdict: PASS
- Layering follows clean-architecture — PASS (application/create-order.js makeCreateOrder takes injected orderRepository/userRepository/idGenerator ports; http/orders-router.js is the outer adapter; app.js composition root; infrastructure gateways wrap db)
- Payload validated at HTTP boundary and async rejections forwarded (Express 4) — PASS (zod createOrderBody.safeParse in orders-router.js returns 400; try/catch -> next(err); 4-arg error middleware in app.js)
- No structural advice conflicts with clean-architecture — PASS (layout is the clean-architecture one; Rules applied cites only rule IDs with file locations; no structural claim attributed to the express skill; "Conflicts ... none")
- Skill contract notes: Answer ends with `Rules applied` section (REQ-1, REQ-2, ERR-1, V4-1, SEC-1, etc.); no structural claim attributed to the express skill.
- Notable behavior: "Composition root wiring concrete implementations" and "// Interface adapter: translates HTTP to the CreateOrder use case and back."

### refactor-2 — 2026-10-19
- Verdict: PASS
- Layering follows clean-architecture — PASS (usecases/createOrder.js makeCreateOrder takes injected orderRepository/userRepository ports defined by the use case; http/ordersRouter.js is the outer adapter; adapters/repositories.js gateways; app.js composition root)
- Payload validated at HTTP boundary and async rejections forwarded (Express 4) — PASS (zod bodySchema.safeParse in ordersRouter.js throws 400; async handler try/catch -> next(err); 4-arg error middleware in app.js)
- No structural advice conflicts with clean-architecture — PASS (layout section is the developer's own; Rules applied lists only rule IDs with file:line, no structural claim attributed to the express skill)
- Skill contract notes: Answer ends with `Rules applied` section (V4-1, REQ-1..5, ERR-1..7, V4-3); no structural claim attributed to the express skill.
- Notable behavior: "ports are defined by the use case (contract in comments)" and "Composition root: concrete adapters are wired to use cases here."

### refactor-3 — 2026-10-19
- Verdict: PASS
- Layering follows clean-architecture — PASS (application/create-order.js use case takes injected orderRepository/customerRepository ports; http/orders-router.js is outer adapter; infrastructure adapters implement ports; app.js composition root; domain has no outer imports)
- Payload validated at HTTP boundary and async rejections forwarded (Express 4) — PASS (zod strict schema safeParse in orders-router.js returns 400; try/catch -> next(err); 4-arg errorHandler registered last in app.js)
- No structural advice conflicts with clean-architecture — PASS (structure section describes the clean-architecture layout; Rules applied lists only rule IDs with file:line, none are structural claims attributed to the express skill)
- Skill contract notes: Answer ends with `Rules applied` (REQ-1..5, V4-1, V4-3, ERR-1..7); no structural claim attributed to the express skill.
- Notable behavior: "Composition root: the only place that wires concrete adapters to use cases." and "Controller: translates HTTP into the use case request model and back."

### final — 2026-10-19 (SKILL.md at commit 6fb9047)
- Verdict: PASS
- Layering follows clean-architecture — PASS (application/create-order.js makeCreateOrder takes injected orderRepository/customerRepository ports; http/orders-router.js is outer adapter; infrastructure adapters wrap db; domain has no imports; app.js composition root)
- Payload validated at HTTP boundary and async rejections forwarded (Express 4) — PASS (zod strict bodySchema.safeParse in orders-router.js:24 returns 400; createOrder(...).catch(next) at :33; 4-arg errorHandler registered last in app.js)
- No structural advice conflicts with clean-architecture — PASS (Structure section is the clean-architecture layout; error-to-HTTP mapping kept in http layer; no structural claim attributed to express skill)
- Skill contract notes: `Rules applied` is last section, every entry has file:line or "outside app code"; REQ-2 cited for boundary validation; no structural claim attributed to the express skill.
- Notable behavior: "Composition root: the only place concrete adapters meet use cases." and "error-to-HTTP mapping lives in the http layer by error class, so inner layers carry no status codes."
