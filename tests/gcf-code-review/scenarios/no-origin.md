# Scenario: no-origin

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --no-origin`. No `origin` remote; checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
(none)

## Expected
- [ ] Base resolves to the local `develop` branch (not an `origin/*` ref).
- [ ] The confirmation shows the merge-base short sha (1ab735e), 3 commits and 3 files. No last-commit date is required (the base is not a remote ref).
- [ ] The confirmation is ONE message and closes by offering the choice: confirm / change the base / or did you mean a PR?
- [ ] Every git command is read-only. Stops before reviewing (no findings, no report).

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Base resolves to local develop — FAIL (noted no origin but did no base detection)
- Confirmation shows 1ab735e, 3 commits, 3 files — FAIL
- ONE message offering confirm/change base/PR — FAIL (asked for PR URL)
- Read-only, stops before review — PASS (git remote -v, git branch --show-current)
- Forbidden commands: none
- Rationalizations: "I can't infer it: ... it has no remote (no `origin`), so I can't look up an associated PR."

### t4 — 2026-10-16
- Verdict: PASS
- Base resolves to local develop — PASS
- Shows 1ab735e, 3 commits, 3 files — PASS
- ONE message offering confirm / change base / PR — PASS
- Read-only, stops before review — PASS
- Forbidden commands: none
- Rationalizations: none

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Base local develop — PASS
- 1ab735e, 3 commits, 3 files — PASS
- ONE message offering confirm / change base / PR — PASS
- Read-only, stops before review — PASS
- Forbidden commands: none
