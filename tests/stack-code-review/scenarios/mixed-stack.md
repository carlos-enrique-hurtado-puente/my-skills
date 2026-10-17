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
