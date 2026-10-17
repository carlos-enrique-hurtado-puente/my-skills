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

### baseline — 2026-10-16
- Verdict: FAIL
- Says nothing to review (0 commits vs base) — FAIL (asked for PR URL; never checked state)
- No report — PASS
- Forbidden commands: none
- Rationalizations: "I need the GitHub pull request URL to run the review (`pull_request_url` is required)."

### t4 — 2026-10-16
- Verdict: PASS
- Says nothing to review (0 commits vs origin/develop) — PASS
- No report produced — PASS
- Forbidden commands: none
- Rationalizations: none
