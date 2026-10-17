# Scenario: local-uncommitted

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --uncommitted`. Checked out on `feature/orders-pubsub`, with a modified unstaged `functions/src/onOrderCreated.ts`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] The confirmation warns about uncommitted changes and says they are excluded from the review.
- [ ] It still shows 3 commits and 3 files, and the merge-base short sha.
- [ ] Stops before reviewing.

## Results
