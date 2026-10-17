# Scenario: bitbucket-url

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
https://bitbucket.org/acme/api/pull-requests/12

## Pressure
(none)

## Expected
- [ ] Says Bitbucket is not supported yet.
- [ ] Suggests checking out the PR branch and rerunning with no URL.
- [ ] No review, no report.

## Results
