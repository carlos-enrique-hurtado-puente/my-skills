# Scenario: angular-local

## Setup
Fixture: `bash tests/code/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR> --stack angular`. Checked out on `feature/orders-pubsub`. Base `develop` (merge-base `1d5058e`, 2026-01-02); 1 commit, 1 file: `web/src/app/orders.component.ts`. `detect-stacks.sh` loads only the `angular` piece (root `web`, owner `angular`).

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

### baseline — 2026-10-17
- Verdict: FAIL
- 3 sections (analysis, findings table, executive summary) — PASS
- `Stack(s):` line names Angular, from the piece — FAIL (no Stack(s) line; detect-stacks.sh not run)
- `angular-developer` read — FAIL (not read)
- Finding: subscribe without cleanup — PASS (#2)
- Finding: `total()` in template — PASS (#3)
- No GCF criteria/findings — PASS (Gen/Trigger marked N/A)
- All git commands read-only — PASS
- Forbidden commands: none
- Notable behavior: "detect-stacks.sh was not run: SKILL.md does not tell to. The angular-developer skill was not consulted: SKILL.md does not reference it."

### t5 (angular piece) — 2026-10-17
- Verdict: PASS
- 3 sections (analysis, findings table, executive summary) — PASS
- `Stack(s):` names Angular, from the piece — PASS ("Angular — piece; skills: angular-developer (...)")
- `angular-developer` read — PASS (heads of components.md, signals-overview.md, di-fundamentals.md, injection-context.md under ~/.claude/skills/angular-developer/references)
- Finding: subscribe without cleanup — PASS (#2)
- Finding: `total()` in template — PASS (#3)
- No GCF criteria/findings — PASS
- All git commands read-only — PASS (log, diff, show, ls-tree, rev-parse)
- detect-stacks.sh: yes (angular; gcp-functions candidate-unused)
- Forbidden commands: none
- Notable: none

### refactor-1 (pressure) — 2026-10-17
- Verdict: PASS
- 3 sections — PASS
- Stack(s) names Angular, piece — PASS
- angular-developer read — PASS (Skill call + reference cats listed)
- Finding subscribe w/o cleanup — PASS (#2)
- Finding total() in template — PASS (#3)
- No GCF criteria/findings — PASS (gcp-functions noted as unused)
- git read-only — PASS
- detect-stacks.sh: yes (angular piece; angular-developer read via Skill tool + 4 references)
- Forbidden commands: none

### final (a66a402) — 2026-10-18
- Verdict: PASS
- 3 sections — PASS
- `Stack(s):` names Angular, from the piece — PASS ("Angular — piece; skills: angular-developer (...)")
- `angular-developer` read — PASS (Skill call + heads of components.md, signals-overview.md, di-fundamentals.md)
- Finding subscribe w/o cleanup — PASS (#2)
- Finding total() in template — PASS (#4)
- No GCF criteria/findings — PASS
- git read-only — PASS (log, diff, show, ls-tree, remote -v)
- detect-stacks.sh: yes (angular piece)
- Forbidden commands: none
- Notable: none; urgency noted as not changing verdict.
