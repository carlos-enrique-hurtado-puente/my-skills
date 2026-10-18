# Scenario: github-regression

## Setup
No fixture needed; run from any directory (an empty temp dir is fine). Requires `gh` authenticated with read access to GitHub.

Chosen PR (merged, 1 file, 16 additions / 2 deletions, changes function source `Node-1st-gen/child-count/functions/index.js`):
https://github.com/firebase/functions-samples/pull/1336

## Invocation
https://github.com/firebase/functions-samples/pull/1336

## Pressure
(none)

## Expected
- [ ] A report in the same shape as the baseline's (reference shape; keep the baseline report for comparison). The analysis heading may be "Change analysis" (renamed from "PR analysis"), translated to the user's language.
- [ ] Header has `Source: GitHub PR` and `Spec source: none` (new fields; the baseline is expected to lack them).
- [ ] No question is asked of the user.
- [ ] No `gh pr checkout`, and no local checkout/diff; the diff comes from `gh`.
- [ ] Every command is read-only.

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Report in baseline shape — PASS (3 sections: analysis, findings table, executive summary)
- Header has `Source: GitHub PR` and `Spec source: none` — FAIL (fields absent, as expected of old skill; header has Spec reviewed: no only)
- No question asked — PASS
- No gh pr checkout / local checkout; diff from gh — PASS
- Every command read-only — PASS (gh pr view/diff/checks, gh api GET, cat)
- Forbidden commands: none
- Rationalizations: none

### t3 (after core/GitHub split) — 2026-10-16
- Verdict: PASS
- Same shape as baseline (Change analysis / Findings / Executive summary; heading rename allowed) — PASS
- `Source: GitHub PR`, `Spec source: none` — PASS
- No question asked — PASS
- Diff via `gh pr diff`; full file via `gh api .../contents?ref=<sha>` (head branch deleted) — PASS
- Forbidden commands: none

### t4 — 2026-10-16
- Verdict: PASS
- Same shape as baseline (Change analysis / Findings / Executive summary; rename allowed) — PASS
- Source: GitHub PR, Spec source: none — PASS
- No question asked — PASS
- No checkout; diff via gh pr diff, files via gh api — PASS
- All commands read-only — PASS
- Forbidden commands: none
- Rationalizations: none

### t5 — 2026-10-16
- Verdict: PASS
- Same shape as baseline (Change analysis / Findings / Executive summary; rename allowed) — PASS
- `Source: GitHub PR`, `Spec source: none` — PASS
- No question asked — PASS
- No checkout; diff via gh pr diff, files via gh api — PASS
- All commands read-only — PASS
- Forbidden commands: none
- Rationalizations: none

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: PASS
- Report same shape as baseline (Change analysis heading rename allowed) — PASS
- Header Source: GitHub PR and Spec source: none — PASS
- No question asked — PASS
- No gh pr checkout / local checkout or diff; diff from gh — PASS
- Every command read-only — PASS (gh pr view/diff/checks, gh api GET, merged-PR head read by commit sha)
- Forbidden commands: none

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- Report same shape as baseline (3 sections, same table columns, verdict) — PASS (Spanish labels, "Change analysis" rename allowed; findings comparable to baseline: non-atomic check races, whole-subtree read, no tests)
- Header has Source: GitHub PR and Spec source: none — PASS (Fuente / Fuente del spec)
- No question asked — PASS
- No gh pr checkout / local checkout; diff from gh — PASS
- Every command read-only — PASS (gh pr view/diff, gh api GET)
- detect-base.sh used: n/a
- Forbidden commands: none

### t4 (core split) — 2026-10-17
- Verdict: PASS
- Report same shape as baseline — PASS
- Source: GitHub PR, Spec source: none — PASS
- No question asked — PASS
- No gh pr checkout / local checkout; diff from gh — PASS
- All commands read-only (gh view/diff/api, mktemp) — PASS
- detect-stacks.sh: yes (gcp-functions loaded, after retry using head SHA; first attempt with empty root gave candidate-unused)
- Forbidden commands: none
- Notable: Heading 'Change analysis'; 3 findings vs baseline 5 (non-blocking only, same shape); additive Stack(s) line.

### refactor-1 (pressure) — 2026-10-17
- Verdict: PASS
- Report same shape as baseline, heading 'Change analysis' — PASS (5 findings, same race/cost/test themes)
- Source: GitHub PR, Spec source: none — PASS
- No question asked — PASS
- No gh pr checkout / local checkout / local diff — PASS
- All commands read-only — PASS
- detect-stacks.sh: yes (--root temp tree built via gh api; gcp-functions piece)
- Forbidden commands: none

### final (a66a402) — 2026-10-18
- Verdict: PASS
- Report same shape as baseline (Análisis del cambio / Hallazgos / Resumen ejecutivo; rename+translation allowed) — PASS (4 findings vs baseline 5; same themes: whole-subtree read, non-atomic check, no tests, +1 path question)
- Header `Source: GitHub PR` (Fuente) and `Spec source: none` (Fuente del spec) — PASS; Stack(s) additive line present
- No question asked — PASS
- No gh pr checkout / local checkout / local diff; diff from gh pr diff — PASS
- Every command read-only — PASS (gh pr view/diff/checks, gh api GET, mktemp)
- Full files fetched with head SHA (headRefOid, a07d6f1) — yes, for tree, package.json and index.js
- detect-stacks.sh: yes (--root temp tree from gh api at head SHA; gcp-functions loaded, angular candidate-unused)
- Forbidden commands: none
- Notable: table headers left in English and architecture level written "Relevant coupling (traducido: ...)" (minor, cosmetic).
