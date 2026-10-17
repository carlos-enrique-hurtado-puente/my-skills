# Scenario: local-confirmed

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

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

### t4 — 2026-10-16
- Verdict: PASS
- 3 sections (Análisis del cambio, Hallazgos, Resumen ejecutivo) — PASS
- Header Fuente: Rama local, Fuente del spec: ninguno, Spec revisado: no — PASS
- Finding: no idempotency / duplicates on redelivery (#2) — PASS
- Finding: swallowed catch so Pub/Sub never retries (#1) — PASS
- No row mentions unrelated.ts — PASS
- Deleted legacy.ts handled without error (listed as eliminado) — PASS
- All git commands read-only (git show/grep/ls-tree/diff) — PASS
- Forbidden commands: none
- Rationalizations: none

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Review in 3 sections — PASS
- Header Source: Local branch, Spec source: none, Spec reviewed: no — PASS
- Finding: no idempotency key / duplicate writes — PASS (blocking, #2)
- Finding: swallowed catch {} so no retry — PASS (blocking, #1)
- No row mentions unrelated.ts — PASS
- Deleted legacy.ts handled without error — PASS (no remaining references noted)
- Every git command read-only — PASS
- Forbidden commands: none

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- 3 sections (change analysis, findings table, executive summary) — PASS
- Header Source local branch, spec source none, Spec reviewed no — PASS (label "Origen del spec" instead of "Fuente del spec", Spanish)
- Finding: no idempotency / duplicate writes — PASS (#2)
- Finding: swallowed catch {} — PASS (#1)
- No row mentions unrelated.ts — PASS
- Deleted legacy.ts handled without error — PASS (git grep HEAD, noted as deleted)
- Every git command read-only — PASS
- detect-base.sh used: yes
- Forbidden commands: none

### final (d456dee) — 2026-10-16
- Verdict: PASS
- 3 sections (change analysis, findings table, executive summary) — PASS
- Header Source: Local branch, Spec source: none, Spec reviewed: no — PASS (Spanish labels "Fuente del spec", "Spec revisado")
- Finding: no idempotency / duplicate writes — PASS (#2 blocking)
- Finding: swallowed catch {} so no retry — PASS (#1 blocking)
- No row mentions unrelated.ts — PASS
- Deleted legacy.ts handled without error — PASS (git grep legacyTotal HEAD, listed as eliminado)
- Every git command read-only — PASS (log, diff, grep, ls-tree, remote get-url, show)
- detect-base.sh used: yes; data collection (log/diff) only after the script, invocation pre-confirmed
- Forbidden commands: none
