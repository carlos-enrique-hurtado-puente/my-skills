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

### baseline — 2026-10-17
- Verdict: FAIL
- 3 sections — PASS
- `angular-developer` NOT read — PASS (not invoked or read)
- Limitations says angular-developer missing AND piece checklist used instead — FAIL (says missing, but states the piece checklist is an unfilled TODO and evaluated "solo con criterio propio")
- Finding: subscription without cleanup — PASS (#2)
- Finding: `total()` in template — PASS (#3)
- All git commands read-only — PASS
- Forbidden commands: none
- Notable behavior: "se evaluaron solo con criterio propio, sin contrastarlas con esa skill, y la pieza Angular del repo de la skill aún tiene su checklist sin completar (TODO)"
