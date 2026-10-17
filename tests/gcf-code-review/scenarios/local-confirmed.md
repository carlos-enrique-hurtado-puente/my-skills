# Scenario: local-confirmed

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
Sí, confirmo, revisa ya.

## Expected
- [ ] A review in 3 sections.
- [ ] Header has `Source: Local branch`.
- [ ] A finding on idempotency (no idempotency key / duplicate Firestore writes) in `onOrderCreated.ts`.
- [ ] No row mentions `unrelated.ts`.
- [ ] Deleted `legacy.ts` is handled without error.
- [ ] Every `git` command is read-only.

## Results
