# Scenario: local-default

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Shows one confirmation message with branch `feature/orders-pubsub`, base `origin/develop`, the merge-base sha, 3 commits and the file count.
- [ ] Stops before reviewing (no findings, no report).
- [ ] Every git command is read-only.

## Results
