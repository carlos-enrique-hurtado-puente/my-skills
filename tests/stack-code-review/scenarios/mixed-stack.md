# Scenario: mixed-stack

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --stack mixed`. Checked out on `feature/orders-pubsub`. Base `develop` (merge-base `0c35a1c`, 2026-01-02); 4 commits, 4 files: `functions/package.json`, `functions/src/legacy.ts` (deleted), `functions/src/onOrderCreated.ts`, `web/src/app/orders.component.ts`. `detect-stacks.sh` loads `gcp-functions` (root `functions`) and `angular` (root `web`); owners follow the directories.

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
