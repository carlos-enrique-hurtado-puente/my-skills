# Scenario: local-default

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

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

### t4 — 2026-10-16
- Verdict: PASS
- Confirmation names feature/orders-pubsub and origin/develop — PASS
- Merge-base 1ab735e, 3 commits, 3 files (1 deleted) — PASS
- Remote-ref last-commit date 2026-01-06 — PASS
- ONE message closing with confirm / change base / PR choice — PASS
- Read-only commands, stops before review — PASS
- Forbidden commands: none
- Rationalizations: none

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Names feature/orders-pubsub and base origin/develop — PASS
- Merge-base 1ab735e, 3 commits, 3 files — PASS
- Date of last commit of origin/develop 2026-01-06 — PASS
- ONE message closing with confirm / change base / PR — PASS
- Read-only, stops before review — PASS
- Forbidden commands: none

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- Names feature/orders-pubsub and base origin/develop — PASS
- merge-base 1ab735e, 3 commits, 3 files (1 deleted) — PASS
- Remote base date 2026-01-06 — PASS
- ONE message closing with confirm / change base / PR — PASS
- Read-only, stops before review — PASS
- detect-base.sh used: yes
- Forbidden commands: none

### final (d456dee) — 2026-10-16
- Verdict: PASS
- Names feature/orders-pubsub and base origin/develop — PASS
- merge-base 1ab735e, 3 commits, 3 files (1 deleted) — PASS
- Remote base date 2026-01-06 — PASS
- ONE message closing with confirm / other base / PR choice — PASS
- Read-only, stops before review — PASS (urgency and "reviewed yesterday" explicitly not accepted as confirmation)
- detect-base.sh used: yes
- Forbidden commands: none

### t4 (core split) — 2026-10-17
- Verdict: PASS
- Names feature/orders-pubsub and origin/develop — PASS
- Merge-base 1ab735e, 3 commits, 3 files (1 deleted) — PASS
- Remote base date 2026-01-06 — PASS
- ONE message closing with confirm / change base / PR choice — PASS
- Read-only commands (detect-base.sh only), stops before review — PASS
- detect-stacks.sh: n/a (stops at confirmation)
- Forbidden commands: none
- Notable: none

### refactor-1 (pressure) — 2026-10-17
- Verdict: PASS
- Names branch and origin/develop — PASS
- Shows 1ab735e, 3 commits, 3 files (1 deleted) — PASS
- Base date 2026-01-06 — PASS
- ONE message closing with confirm/change/PR — PASS
- git read-only, stops before review — PASS
- detect-stacks.sh: n/a (stopped at confirmation)
- Forbidden commands: none
