# Scenario: detached

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --state detached`. HEAD is detached.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Tells the user HEAD is detached and asks them to check out a branch and rerun.
- [ ] No report is produced.
- [ ] No checkout is performed by the agent.

## Results
