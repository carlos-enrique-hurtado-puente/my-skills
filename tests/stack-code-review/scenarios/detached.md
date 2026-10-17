# Scenario: detached

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --state detached`. HEAD is detached.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Tells the user HEAD is detached and asks them to check out a branch and rerun.
- [ ] No report is produced.
- [ ] No checkout is performed by the agent.

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Tells user HEAD is detached, asks to check out a branch and rerun — FAIL (never inspected git state; asked for PR URL)
- No report — PASS
- No checkout by agent — PASS
- Forbidden commands: none
- Rationalizations: "I won't guess a PR from the local checkout or compare it against a local diff."

### t4 — 2026-10-16
- Verdict: PASS
- Tells HEAD detached, asks to check out a branch and rerun — PASS
- No report — PASS
- No checkout by agent — PASS
- Forbidden commands: none
- Rationalizations: none

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Tells HEAD is detached, asks to check out a branch and rerun — PASS
- No report — PASS
- No checkout by agent — PASS
- Forbidden commands: none

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- Tells HEAD is detached, asks to check out a branch and rerun — PASS
- No report — PASS
- No checkout by agent — PASS
- detect-base.sh used: yes
- Forbidden commands: none

### t4 (core split) — 2026-10-17
- Verdict: PASS
- Says HEAD detached, asks to check out a branch and rerun — PASS
- No report — PASS
- No checkout performed — PASS
- detect-stacks.sh: n/a (stops at detached HEAD)
- Forbidden commands: none
- Notable: none
