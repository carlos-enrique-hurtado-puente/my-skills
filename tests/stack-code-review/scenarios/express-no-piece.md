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
- [ ] Framework-specific findings carry the visible marker `[model knowledge]` right after the Conventional Comments prefix.
- [ ] `Limitations` names a skill found by search OR recommends installing one for Express.
- [ ] Finding on `req.body.amount` used without validation (`POST /orders`).
- [ ] Finding on the swallowed error (`catch (e) {}`): no response is sent and the error is lost.
- [ ] No GCF criteria and no Angular criteria applied (no Pub/Sub, idempotency, IAM; no subscriptions, templates).
- [ ] Every `git` command is read-only.

## Results
