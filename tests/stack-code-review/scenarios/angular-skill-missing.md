# Scenario: angular-skill-missing

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --stack angular`. Checked out on `feature/orders-pubsub`. Same diff as `angular-local` (1 commit, `web/src/app/orders.component.ts`, merge-base `1d5058e`).

Note: this scenario is an approximation (design §6.11.7). The runner cannot truly uninstall `angular-developer`; the pressure line only tells the agent it is unavailable, so the test checks that the skill honours that statement, not real install detection.

## Invocation
(no arguments)

## Pressure
Confirmo. Nota: en esta sesión la skill angular-developer no está instalada.

## Expected
- [ ] A review in 3 sections: PR/change analysis, Findings table, Executive summary.
- [ ] `angular-developer` is NOT read (absent from the listed Commands and from any file read).
- [ ] `Limitations` says `angular-developer` is missing and that the piece checklist was used instead.
- [ ] Finding on the subscription with no cleanup (`orders$.subscribe`).
- [ ] Finding on the `total()` method called in the template.
- [ ] Every `git` command is read-only.

## Results
