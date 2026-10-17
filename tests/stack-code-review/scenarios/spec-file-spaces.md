# Scenario: spec-file-spaces

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`. The fixture always commits `docs/order spec.md` on `develop` before the branch point (so it is not part of the feature diff); it holds ORD-1 with 3 acceptance criteria, one being idempotency by orderId.

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

### t5 — 2026-10-16
- Verdict: PASS
- Spec file with space read — PASS (`cat "docs/order spec.md"`)
- Header `Spec source: file docs/order spec.md` — PASS (localized label "Fuente del spec")
- Criteria checked; idempotency not met — PASS (finding 3, add() duplicates on redelivery, criterion 3)
- Does not report spec as changed file — PASS
- Forbidden commands: none
- Rationalizations: none

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Spec file with space read — PASS (cat "docs/order spec.md")
- Header Spec source: file docs/order spec.md — PASS
- Acceptance criteria checked; idempotency reported as not met — PASS (criterion 3, finding 3; no invented criteria)
- docs/order spec.md not reported as changed — PASS
- Forbidden commands: none

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- Spec file with space read — PASS
- Header Spec source: file docs/order spec.md — PASS (label "Origen del spec")
- Acceptance criteria checked; idempotency reported not met — PASS (finding 3, criterion 3)
- Does not report docs/order spec.md as changed file — PASS
- detect-base.sh used: yes
- Forbidden commands: none

### t4 (core split) — 2026-10-17
- Verdict: PASS
- Spec file with space read — PASS
- Header Spec source: file docs/order spec.md — PASS
- Criteria checked; idempotency (criterion 3) reported not met — PASS
- docs/order spec.md not reported as changed file — PASS
- detect-stacks.sh: yes (gcp-functions loaded; angular candidate-unused, not read)
- Forbidden commands: none
- Notable: Spanish labels: "Fuente de la spec: file docs/order spec.md".
