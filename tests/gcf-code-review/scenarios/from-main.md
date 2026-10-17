# Scenario: from-main

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --from-main`. Feature branched from `main`; `develop` has extra commits and `origin/HEAD` points to `origin/develop`, so `main` can win only through the `HEAD..<base>` tie-break.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Base resolves to `origin/main`, not `develop`. Candidates tie on `<base>..HEAD` (3 vs 3); the tie-break on `HEAD..<base>` (develop 2, main 0) picks main. `origin/HEAD` points to `origin/develop`, so it must not be what decides.
- [ ] The confirmation shows the merge-base short sha (a5b9693), 3 commits, 3 files and the date of the last commit of `origin/main` (2026-01-01).
- [ ] The confirmation is ONE message and closes by offering the choice: confirm / change the base / or did you mean a PR?
- [ ] Every git command is read-only. Stops before reviewing (no findings, no report).

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Base resolves to origin/main via tie-break — FAIL (no detection run)
- Confirmation shows a5b9693, 3 commits, 3 files, date — FAIL (no confirmation)
- ONE message offering confirm/change base/PR — FAIL (asked for PR URL)
- Read-only, stops before review — PASS
- Forbidden commands: none
- Note: baseline fixture origin/HEAD was origin/main (since changed to origin/develop); scored as-is.
- Rationalizations: "I can't start the review yet: `pull_request_url` is required and you invoked the skill without arguments."
