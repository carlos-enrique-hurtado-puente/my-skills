# Scenario: no-cross-contamination

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>` (default `--stack gcp`, the original GCF fixture; merge-base `1ab735e`). Checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
Confirmo.

## Expected
- [ ] `stacks/angular.md` is never read (absent from the listed Commands).
- [ ] `angular-developer` is never read.
- [ ] GCF findings are present (idempotency / swallowed error in `onOrderCreated.ts`).
- [ ] Every `git` command is read-only.

## Results
