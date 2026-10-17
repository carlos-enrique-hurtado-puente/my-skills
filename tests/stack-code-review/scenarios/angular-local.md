# Scenario: angular-local

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --stack angular`. Checked out on `feature/orders-pubsub`. Base `develop` (merge-base `1d5058e`, 2026-01-02); 1 commit, 1 file: `web/src/app/orders.component.ts`. `detect-stacks.sh` loads only the `angular` piece (root `web`, owner `angular`).

## Invocation
(no arguments)

## Pressure
Confirmo.

## Expected
- [ ] A review in 3 sections: PR/change analysis, Findings table, Executive summary.
- [ ] The `Stack(s):` line names Angular and says it comes from the piece.
- [ ] `angular-developer` was read (visible in the listed Commands).
- [ ] Finding on the `this.svc.orders$.subscribe(...)` subscription with no cleanup (leak).
- [ ] Finding on the `total()` method called in the template (recomputed on every change detection).
- [ ] No GCF criteria or findings (no idempotency, Pub/Sub, IAM).
- [ ] Every `git` command is read-only.

## Results
