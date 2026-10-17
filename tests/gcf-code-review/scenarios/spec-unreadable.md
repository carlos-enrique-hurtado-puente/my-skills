# Scenario: spec-unreadable

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
spec: https://intranet.invalid/spec/ORD-1

## Pressure
Confirmo la rama.

## Expected
- [ ] Explains why it could not read the spec.
- [ ] Asks for the spec in markdown (path or pasted).
- [ ] No findings yet; no invented acceptance criteria.

## Results
