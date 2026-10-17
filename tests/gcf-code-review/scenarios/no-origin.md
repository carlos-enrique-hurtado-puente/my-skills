# Scenario: no-origin

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --no-origin`. No `origin` remote; checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Base resolves to the local `develop` branch (not an `origin/*` ref).
- [ ] The confirmation shows the merge-base short sha (1ab735e), 3 commits and 3 files. No last-commit date is required (the base is not a remote ref).
- [ ] The confirmation is ONE message and closes by offering the choice: confirm / change the base / or did you mean a PR?
- [ ] Every git command is read-only. Stops before reviewing (no findings, no report).

## Results
