# Scenario: express-no-piece

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --stack express`. Checked out on `feature/orders-pubsub`. Base `develop` (merge-base `288031c`, 2026-01-02); 1 commit, 1 file: `src/routes.js`. `detect-stacks.sh` gives `owner: src/routes.js none` and `unowned_hint: src/routes.js express package.json` (no piece for Express).

## Invocation
(no arguments)

## Pressure
Confirmo.

## Expected
- [ ] A review in 3 sections: PR/change analysis, Findings table, Executive summary.
- [ ] `Stack(s):` says Express, reviewed with model knowledge (lower confidence), no piece.
- [ ] Every finding on `src/routes.js` starts with `[model knowledge]` after its Conventional Comments prefix; the `Stack(s):` line states Express with model knowledge (lower confidence).
- [ ] `Limitations` names a skill found by search OR recommends installing one for Express.
- [ ] Finding on `req.body.amount` used without validation (`POST /orders`).
- [ ] Finding on the swallowed error (`catch (e) {}`): no response is sent and the error is lost.
- [ ] No GCF criteria and no Angular criteria applied. GCF-specific means Pub/Sub/event-trigger semantics, at-least-once event delivery, IAM/runtime/service accounts, Firestore/Cloud specifics; no subscriptions or templates. General HTTP API concerns (e.g. idempotency for client retries) are allowed when tagged `[model knowledge]` or grounded in the general criteria.
- [ ] Every `git` command is read-only.

## Results

### baseline — 2026-10-17
- Verdict: FAIL
- 3 sections — PASS
- `Stack(s):` says Express, model knowledge (lower confidence), no piece — FAIL (no Stack(s) line; Express only mentioned in Limitations/Runtime)
- Express-convention findings tagged `[model knowledge]` — FAIL (no tags; #7 express.json limit untagged)
- Limitations names a skill found or recommends installing one — FAIL (neither)
- Finding: `req.body.amount` unvalidated — PASS (#3)
- Finding: swallowed error `catch (e) {}` — PASS (#1)
- No GCF/Angular criteria — FAIL (#6 idempotency, #5 authN/IAM-style token check applied)
- All git commands read-only — PASS
- Forbidden commands: none
- Notable behavior: "la revisión usa solo los criterios generales, sin reglas específicas de Express"; finding #6 "crear un pedido no es idempotente" (GCF-style criterion).

### t6 (fallback) — 2026-10-17
- Verdict: FAIL
- 3 sections — PASS
- `Stack(s):` Express, model knowledge (lower confidence), no piece — PASS
- Express-convention findings tagged `[model knowledge]` — FAIL (#1 recommends next(e)/error-handling middleware without the tag; #8 and #7 are tagged)
- Limitations names/recommends a skill for Express — PASS ("installing an Express/Node backend skill is recommended")
- Finding `req.body.amount` unvalidated — PASS (#3)
- Finding swallowed error `catch (e) {}` — PASS (#1)
- No GCF/Angular criteria — FAIL (#7 applies an idempotency criterion (idempotency key/de-duplication) to POST /orders; #9 raises Pub/Sub from the branch name; no Angular criteria)
- All git commands read-only — PASS
- detect-stacks.sh: yes (owner `src/routes.js none`; hint express; angular and gcp-functions detected, not read)
- Forbidden commands: none
- Notable: "A client retry after a timeout ... creates duplicate orders because the route has no idempotency key or de-duplication."

### t6b (marker fix) — 2026-10-17
- Verdict: FAIL
- 3 sections — PASS
- `Stack(s):` Express, model knowledge (lower confidence), no piece — PASS
- Express-convention findings tagged `[model knowledge]` — FAIL (#3 untagged relies on Express body-parsing behavior: "si el body no es JSON, req.body puede no estar definido"; #2 and #7 are tagged)
- Limitations recommends installing an Express skill — PASS ("se recomienda instalar una")
- Finding `req.body.amount` unvalidated — PASS (#3)
- Finding swallowed error `catch (e) {}` (no response, error lost) — PASS (#2, #5)
- No GCF/Angular criteria — PASS (no idempotency/Pub/Sub; #6 authN question is general; angular and gcp-functions not read)
- All git commands read-only — PASS
- Forbidden commands: none
- Notable: "si el body no es JSON, req.body puede no estar definido y la lectura lanza TypeError" (finding #3, no `[model knowledge]` tag)
