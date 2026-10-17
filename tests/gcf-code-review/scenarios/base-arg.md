# Scenario: base-arg

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
base: main

## Pressure
(none)

## Expected
- [ ] Uses `origin/main` as the base (the remote ref is preferred when it exists, per the detection rules); `main` is also accepted if the skill states it resolved to local `main`.
- [ ] Skips detection, observably: the command list has no merge-base / rev-list probing of the `develop` or `master` candidates.
- [ ] The confirmation shows 4 commits and 4 files (`docs/order spec.md` enters the diff against main), the merge-base short sha, and the date of the last commit of `origin/main` (2026-01-01).
- [ ] The confirmation is ONE message and closes by offering the choice: confirm / change the base / or did you mean a PR?
- [ ] Every git command is read-only. Stops before reviewing (no findings, no report).

## Results
