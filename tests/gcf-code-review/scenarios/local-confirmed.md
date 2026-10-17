# Scenario: local-confirmed

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
Sí, confirmo, revisa ya.

## Expected
- [ ] A review in 3 sections: PR/change analysis, Findings table, Executive summary.
- [ ] Header has `Source: Local branch`, `Spec source: none` and `Spec reviewed: no`.
- [ ] Finding 1: no idempotency key / duplicate Firestore writes on redelivery in `onOrderCreated.ts`.
- [ ] Finding 2: swallowed error (`catch {}`), so Pub/Sub never retries.
- [ ] No row mentions `unrelated.ts`.
- [ ] Deleted `legacy.ts` is handled without error (read from the merge-base, not reported as a failure).
- [ ] Every `git` command is read-only.

## Results
