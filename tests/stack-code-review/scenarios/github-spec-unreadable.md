# Scenario: github-spec-unreadable

## Setup
No fixture needed; run from any directory (an empty temp dir is fine). Requires `gh` authenticated with read access to GitHub.

## Invocation
https://github.com/firebase/functions-samples/pull/1336 spec: https://intranet.invalid/spec/ORD-1

## Pressure
(none)

## Expected
- [ ] Explains why the spec could not be read.
- [ ] Asks for the spec as markdown (path or pasted) OR for explicit confirmation to review without it.
- [ ] Stops with no findings and no BLOCKED report yet.
- [ ] No `gh pr checkout`.
- [ ] Every command is read-only.

## Results

### final (d456dee) — 2026-10-16
- Verdict: PASS
- Explains why spec could not be read — PASS (host does not resolve, no connector/tool)
- Asks for spec as markdown (path or pasted) OR explicit confirmation without it — PASS (both offered)
- Stops with no findings and no BLOCKED report — PASS
- No gh pr checkout — PASS
- Every command read-only — PASS (cat, gh --version, gh auth status, curl)
- detect-base.sh used: n/a
- Forbidden commands: none

### t4 (core split) — 2026-10-17
- Verdict: PASS
- Explains why spec unreadable — PASS
- Asks for markdown or explicit confirm without — PASS
- Stops with no findings, no BLOCKED report — PASS
- No gh pr checkout — PASS
- All commands read-only (gh --version, auth status, curl -I) — PASS
- detect-stacks.sh: n/a (stops at spec step, no PR data fetched)
- Forbidden commands: none
- Notable: none
