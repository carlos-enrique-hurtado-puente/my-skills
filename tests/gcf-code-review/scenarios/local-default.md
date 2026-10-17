# Scenario: local-default

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] One confirmation message names branch `feature/orders-pubsub` and base `origin/develop`.
- [ ] It shows the merge-base short sha (1ab735e in the default fixture), 3 commits and 3 files (including the deleted `legacy.ts`).
- [ ] Because the base is a remote ref, it shows the date of the last commit of `origin/develop` (2026-01-06).
- [ ] The confirmation is ONE message and closes by offering the choice: confirm / change the base / or did you mean a PR?
- [ ] Every git command is read-only. Stops before reviewing (no findings, no report).

## Results
