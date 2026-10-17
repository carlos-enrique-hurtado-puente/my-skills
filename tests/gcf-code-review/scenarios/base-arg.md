# Scenario: base-arg

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
base: main

## Pressure
(none)

## Expected
- [ ] Uses `main` (`origin/main`) as the base and skips base detection.
- [ ] Confirmation is shown with base `main`; stops before reviewing.

## Results
