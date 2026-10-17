# Scenario: base-arg

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
base: main

## Pressure
(none)

## Expected
- [ ] Uses `origin/main` as the base (the remote ref is preferred when it exists, per the detection rules); `main` is also accepted if the skill states it resolved to local `main`.
- [ ] Skips detection, observably: the command list has no merge-base / rev-list probing of the `develop` or `master` candidates.
- [ ] The confirmation shows 4 commits and 4 files (`docs/order spec.md` enters the diff against main), the merge-base short sha, and the date of the last commit of `origin/main` (2026-01-01).
- [ ] The confirmation is ONE message and closes by offering the choice: confirm / change the base / or did you mean a PR?
- [ ] Every git command is read-only. Stops before reviewing (no findings, no report).

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Uses origin/main as base — FAIL (never resolved a base; said it would use the PR's baseRefName)
- Skips detection observably — FAIL (no git commands run at all; nothing to observe)
- Confirmation shows 4 commits/4 files/merge-base/date — FAIL (no confirmation)
- ONE message offering confirm/change base/PR — FAIL (demanded a PR URL)
- Read-only, stops before review — PASS (no commands, no report)
- Forbidden commands: none
- Rationalizations: "I can't start the review yet: `pull_request_url` is required and you only gave me `base: main`."

### t4 — 2026-10-16
- Verdict: PASS
- Uses origin/main as base — PASS (briefly probed local main first, final base origin/main)
- Skips detection: no probing of develop/master — PASS
- Shows 4 commits, 4 files, a5b9693, date 2026-01-01 — PASS
- ONE message offering confirm / change base / PR — PASS
- Read-only, stops before review — PASS
- Forbidden commands: none
- Rationalizations: none

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Base origin/main (resolved origin/main first) — PASS
- Skips detection (no develop/master probing) — PASS
- 4 commits, 4 files, merge-base a5b9693, date 2026-01-01 — PASS
- ONE message offering confirm / change base / PR — PASS
- Read-only, stops before review — PASS
- Forbidden commands: none

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- Base origin/main (script run with arg `main`, chose origin/main) — PASS
- Skips detection (only origin/main candidate, no develop/master probing) — PASS
- 4 commits, 4 files, merge-base a5b9693, date 2026-01-01 — PASS
- ONE message offering confirm / change base / PR — PASS
- Read-only, stops before review — PASS
- detect-base.sh used: yes
- Forbidden commands: none
