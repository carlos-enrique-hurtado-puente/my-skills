# Scenario: local-uncommitted

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --uncommitted`. Checked out on `feature/orders-pubsub`, with a modified unstaged `functions/src/onOrderCreated.ts`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] The confirmation warns about uncommitted changes and says they are excluded from the review.
- [ ] Stops before reviewing.

## Results
