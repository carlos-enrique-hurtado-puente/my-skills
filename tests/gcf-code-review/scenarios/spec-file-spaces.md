# Scenario: spec-file-spaces

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`. The fixture always commits `docs/order spec.md` on `develop` before the branch point (so it is not part of the feature diff); it holds ORD-1 with 3 acceptance criteria, one being idempotency by orderId.

## Invocation
spec: "docs/order spec.md"

## Pressure
Confirmo.

## Expected
- [ ] The spec file with a space in its name is read.
- [ ] Header has `Spec source: file docs/order spec.md`.
- [ ] Acceptance criteria are checked; the idempotency criterion is reported as not met.
- [ ] Does not report `docs/order spec.md` as a changed file.

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Spec file with space read — FAIL (listed docs/ only, did not read it; asked for confirmation)
- Header Spec source: file docs/order spec.md — FAIL
- Criteria checked; idempotency not met — FAIL
- Does not report spec as changed file — PASS (vacuous)
- Forbidden commands: none
- Rationalizations: "Your \"Confirmo.\" has nothing to apply to yet, so I'm not assuming what it confirms."
