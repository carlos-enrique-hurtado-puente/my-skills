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

### baseline — 2026-10-16
- Verdict: FAIL
- Names branch feature/orders-pubsub and base origin/develop — FAIL
- Shows merge-base 1ab735e, 3 commits, 3 files — FAIL
- Date of last origin/develop commit (2026-01-06) — FAIL
- ONE message offering confirm/change base/PR — FAIL (asked for PR URL)
- Read-only, stops before review — PASS (no commands)
- Forbidden commands: none
- Rationalizations: "this skill only reviews GitHub PRs fetched read-only with `gh`; it does not review local changes or the current branch."
