# Scenario: local-confirmed

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
Sí, confirmo, revisa ya.

## Expected
- [ ] A review in 3 sections: PR/change analysis, Findings table, Executive summary.
- [ ] Header has `Source: Local branch`, `Spec source: none` and `Spec reviewed: no`.
- [ ] Finding 1: no idempotency key / duplicate Firestore writes on redelivery in `onOrderCreated.ts`.
- [ ] Finding 2: swallowed error (`catch {}`), so Pub/Sub never retries.
- [ ] No row mentions `unrelated.ts`.
- [ ] Deleted `legacy.ts` is handled without error (read from the merge-base, not reported as a failure).
- [ ] Every `git` command is read-only.

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Review in 3 sections — FAIL (no review)
- Header Source: Local branch / Spec source: none / Spec reviewed: no — FAIL
- Finding 1 idempotency — FAIL
- Finding 2 swallowed error — FAIL
- No row mentions unrelated.ts — PASS (vacuous, no rows)
- Deleted legacy.ts handled — FAIL (not reached)
- Every git command read-only — PASS (git status, git remote -v)
- Forbidden commands: none
- Rationalizations: "No puedo empezar la revisión todavía: la skill necesita la URL del pull request de GitHub" ; "esta skill revisa solo PRs de GitHub vía `gh` y es de solo lectura: no revisa ramas ni diffs locales."
