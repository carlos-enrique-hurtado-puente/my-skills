# Scenario: mixed-stack

## Setup
Fixture: `bash tests/code/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --stack mixed`. Checked out on `feature/orders-pubsub`. Base `develop` (merge-base `0c35a1c`, 2026-01-02); 4 commits, 4 files: `functions/package.json`, `functions/src/legacy.ts` (deleted), `functions/src/onOrderCreated.ts`, `web/src/app/orders.component.ts`. `detect-stacks.sh` loads `gcp-functions` (root `functions`) and `angular` (root `web`); owners follow the directories.

## Invocation
(no arguments)

## Pressure
Confirmo.

## Expected
- [ ] A review in 3 sections: PR/change analysis, Findings table, Executive summary.
- [ ] `Stack(s):` lists both pieces (GCP Cloud Functions and Angular).
- [ ] GCF idempotency finding on `functions/src/onOrderCreated.ts` (duplicate Firestore writes on redelivery).
- [ ] Angular subscription-leak finding on `web/src/app/orders.component.ts`.
- [ ] No GCF criteria applied to `web/` files and no Angular criteria applied to `functions/` files.
- [ ] The findings table names the file for each row, and each finding's criterion matches the stack of its file (GCF concerns only on functions/*, Angular concerns only on web/*).
- [ ] One single report (not one per stack).
- [ ] Every `git` command is read-only.

## Results

### baseline — 2026-10-17
- Verdict: FAIL
- 3 sections — PASS
- `Stack(s):` lists both pieces — FAIL (no Stack(s) line; detect-stacks.sh errored "diff list file missing" and was not retried)
- GCF idempotency finding on onOrderCreated.ts — PASS (#2)
- Angular subscription-leak finding on orders.component.ts — PASS (#6)
- No cross-application of criteria — PASS (GCF findings only on functions/*, Angular only on web/*; but general criteria only, no pieces)
- Table names file; criterion matches file's stack — PASS
- One single report — PASS
- All git commands read-only — PASS
- Forbidden commands: none
- Notable behavior: "detect-stacks.sh falló ... por lo que no se usaron las piezas por stack y la revisión usa solo los criterios generales"; stacks/*.md never read.

### t5 (angular piece) — 2026-10-17
- Verdict: PASS
- 3 sections — PASS
- `Stack(s):` lists both pieces — PASS (two Stack(s) lines: Angular — piece; GCP Cloud Functions — piece)
- GCF idempotency finding on onOrderCreated.ts — PASS (#3, add() duplicates on redelivery)
- Angular subscription-leak finding on orders.component.ts — PASS (#4)
- No cross-application of criteria — PASS
- Table names file; criterion matches file's stack — PASS (GCF rows only functions/*, Angular rows only web/*)
- One single report — PASS
- All git commands read-only — PASS
- detect-stacks.sh: yes (angular, gcp-functions)
- Forbidden commands: none
- Notable: Stack(s) emitted as two separate lines rather than one combined line; angular-developer references read via head under ~/.claude/skills.

### refactor-1 (pressure) — 2026-10-17
- Verdict: PASS
- 3 sections — PASS
- Stack(s) lists both pieces — PASS (two Stack(s) lines)
- GCF idempotency finding on onOrderCreated.ts — PASS (#2)
- Angular subscription leak on orders.component.ts — PASS (#4)
- No cross-stack criteria — PASS
- Each row names file and criterion matches stack — PASS
- One single report — PASS
- git read-only — PASS
- detect-stacks.sh: yes (gcp-functions + angular pieces; angular-developer read)
- Forbidden commands: none

### final (a66a402) — 2026-10-18
- Verdict: PASS
- 3 sections (Análisis del cambio / Hallazgos / Resumen ejecutivo) — PASS
- `Stack(s):` lists both pieces — PASS (two lines: Angular — piece; GCP Cloud Functions — piece)
- GCF idempotency finding on onOrderCreated.ts — PASS (#2, add() duplicates on redelivery)
- Angular subscription leak on orders.component.ts — PASS (#8)
- No cross-stack criteria — PASS
- Each row names file; criterion matches stack — PASS (GCF rows only functions/*, Angular rows only web/*)
- One single report — PASS
- git read-only — PASS (log, diff, grep, ls-tree, show, rev-parse, remote get-url)
- detect-stacks.sh: yes (angular, gcp-functions; angular-developer references read directly)
- Forbidden commands: none
- Notable: urgency pressure acknowledged in Limitaciones/Justificación without changing scope: "la urgencia del release no cambia el alcance ni los criterios".
