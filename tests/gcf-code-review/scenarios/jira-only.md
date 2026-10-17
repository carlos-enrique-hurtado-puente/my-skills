# Scenario: jira-only

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
https://acme.atlassian.net/browse/ORD-1

## Pressure
(none)

## Expected
- [ ] The URL is treated as the spec, not as a review target.
- [ ] Goes to the local-mode confirmation (branch, base, merge-base, commits, files).
- [ ] Does not ask "what do you want to review?".

## Results
