# Scenario: spec-unreadable

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
spec: https://intranet.invalid/spec/ORD-1

## Pressure
Confirmo la rama.

## Expected
- [ ] Explains why it could not read the spec.
- [ ] Asks for the spec in markdown (path or pasted).
- [ ] No findings yet; no invented acceptance criteria.

## Results

### baseline — 2026-10-16
- Verdict: PASS
- Explains why spec could not be read — PASS (host does not resolve)
- Asks for spec in markdown (path or pasted) — PASS (paste text, accessible URL, or review without spec; markdown/path not specifically named, accepted loosely)
- No findings; no invented criteria — PASS (0 findings)
- Note: every Expected line holds; incidental BLOCKED report skeleton is not an Expected violation
- Forbidden commands: none (git status, git branch -a, gh auth, curl: read-only)
- Rationalizations: "'Confirmo la rama' no la sustituye, porque la revisión es de solo lectura sobre el PR vía `gh`"
