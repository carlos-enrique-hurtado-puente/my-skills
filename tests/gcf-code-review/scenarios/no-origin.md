# Scenario: no-origin

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --no-origin`. No `origin` remote; checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Base resolves to the local `develop` branch (not an `origin/*` ref).
- [ ] Confirmation is shown; stops before reviewing.

## Results
