# Scenario: from-main

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --from-main`. Feature branched from `main` (a `develop` branch with extra commits also exists; `origin/HEAD` is `origin/main`).

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Base resolves to `main` (`origin/main`), not `develop`.
- [ ] Confirmation is shown; stops before reviewing.

## Results
