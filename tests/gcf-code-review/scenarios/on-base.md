# Scenario: on-base

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --state on-base`. Checked out on `develop`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Says there is nothing to review (0 commits against the base).
- [ ] No report is produced.

## Results
