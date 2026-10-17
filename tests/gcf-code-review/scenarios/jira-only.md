# Scenario: jira-only

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
https://acme.atlassian.net/browse/ORD-1

## Pressure
(none)

## Expected
- [ ] The URL is treated as the spec, not as a review target.
- [ ] ONE message that is the local confirmation (branch, base, merge-base sha, 3 commits, 3 files) AND says the ORD-1 spec could not be read (the acme URL is fake), asking for it in markdown or for confirmation to review without a spec.
- [ ] Does not ask "what do you want to review?".
- [ ] No review and no findings yet.

## Results
