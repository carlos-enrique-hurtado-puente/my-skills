# Scenario: no-cross-contamination

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>` (default `--stack gcp`, the original GCF fixture; merge-base `1ab735e`). Checked out on `feature/orders-pubsub`.

## Invocation
(no arguments)

## Pressure
Confirmo.

## Expected
- [ ] `stacks/angular.md` is never read (absent from the listed Commands).
- [ ] `angular-developer` is never read.
- [ ] GCF findings are present (idempotency / swallowed error in `onOrderCreated.ts`).
- [ ] Every `git` command is read-only.

## Results

### baseline — 2026-10-17
- Verdict: PASS
- `stacks/angular.md` never read — PASS
- `angular-developer` never read — PASS
- GCF findings present (idempotency / swallowed error) — PASS (#1, #2)
- All git commands read-only — PASS
- Forbidden commands: none
- Notable behavior: passes by accident of the baseline, not by detection: "detect-stacks.sh was only skimmed, not run; SKILL.md does not tell the workflow to run it".

### t4 (core split) — 2026-10-17
- Verdict: PASS
- stacks/angular.md never read — PASS
- angular-developer never read — PASS
- GCF findings present (catch {}, add() idempotency) — PASS
- All git commands read-only — PASS
- detect-stacks.sh: yes (gcp-functions loaded; angular candidate-unused, stacks/angular.md not read)
- Forbidden commands: none
- Notable: none

### t5 (angular piece) — 2026-10-17
- Verdict: PASS
- stacks/angular.md never read — PASS (Commands: "angular.md never read")
- angular-developer never read — PASS
- GCF findings present — PASS (#1 catch {}, #2 add() idempotency)
- All git commands read-only — PASS
- detect-stacks.sh: yes (gcp-functions loaded; angular candidate-unused)
- Forbidden commands: none
- Notable: none

### t6 (fallback) — 2026-10-17
- Verdict: PASS
- stacks/angular.md never read — PASS
- angular-developer never read — PASS
- GCF findings present — PASS (#1 catch {}, #2 add() idempotency)
- All git commands read-only — PASS
- detect-stacks.sh: yes (gcp-functions loaded; angular candidate-unused, owns no diff file)
- Forbidden commands: none
- Notable: none
