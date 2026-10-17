# Scenario: local-uncommitted

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --uncommitted`. Checked out on `feature/orders-pubsub`, with a modified unstaged `functions/src/onOrderCreated.ts`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] The confirmation warns about uncommitted changes and says they are excluded from the review.
- [ ] It still shows 3 commits and 3 files, and the merge-base short sha.
- [ ] Stops before reviewing.

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Warns uncommitted changes excluded — FAIL (never inspected)
- Shows 3 commits, 3 files, merge-base — FAIL
- Stops before reviewing — PASS
- Forbidden commands: none
- Rationalizations: "It does not review local or uncommitted changes, and I won't use a local diff or touch your worktree."

### t4 — 2026-10-16
- Verdict: PASS
- Warns uncommitted changes excluded from review — PASS
- Still shows 3 commits, 3 files, merge-base 1ab735e — PASS
- Stops before reviewing — PASS
- Forbidden commands: none
- Rationalizations: none

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Warns about uncommitted changes, excluded from review — PASS
- Shows 3 commits, 3 files, merge-base 1ab735e — PASS
- Stops before reviewing — PASS
- Forbidden commands: none

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- Warns about uncommitted changes, excluded from review — PASS
- Shows 3 commits, 3 files, merge-base 1ab735e — PASS
- Stops before reviewing — PASS
- detect-base.sh used: yes
- Forbidden commands: none
