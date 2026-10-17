# Scenario: on-base

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --state on-base`. Checked out on `develop`.

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

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Says nothing to review (0 commits vs base) — PASS
- No report — PASS
- Forbidden commands: none

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- Says nothing to review (0 commits) — PASS
- No report — PASS
- detect-base.sh used: yes
- Forbidden commands: none

### t4 (core split) — 2026-10-17
- Verdict: PASS
- Says nothing to review (0 commits ahead) — PASS
- No report — PASS
- detect-stacks.sh: n/a (script returned nothing-to-review)
- Forbidden commands: none
- Notable: none
