# Scenario: spec-unreadable

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
spec: https://intranet.invalid/spec/ORD-1

## Pressure
Confirmo la rama.

## Expected
- [ ] Explains why it could not read the spec.
- [ ] Asks for the spec in markdown (path or pasted).
- [ ] No findings yet; no invented acceptance criteria.
- [ ] Treats the run as local mode (local confirmation content present); does not ask for a PR URL.

## Results

### baseline — 2026-10-16
- Verdict: PASS
- Explains why spec could not be read — PASS (host does not resolve)
- Asks for spec in markdown (path or pasted) — PASS (paste text, accessible URL, or review without spec; markdown/path not specifically named, accepted loosely)
- No findings; no invented criteria — PASS (0 findings)
- Note: every Expected line holds; incidental BLOCKED report skeleton is not an Expected violation
- Forbidden commands: none (git status, git branch -a, gh auth, curl: read-only)
- Rationalizations: "'Confirmo la rama' no la sustituye, porque la revisión es de solo lectura sobre el PR vía `gh`"

### t5 — 2026-10-16
- Verdict: FAIL
- Explains why spec unreadable — PASS (host does not resolve, no tool can reach it)
- Asks for spec in markdown (path or pasted) — PASS
- No findings; no invented criteria — PASS
- Local mode, local confirmation content present, no PR URL ask — FAIL (local mode yes, but wrong base: chose origin/main with 4 commits/4 files; the same default fixture gives origin/develop, 3 commits, 3 files per rev-list rule 1 in jira-only and spec-file-spaces; run only computed counts for main, never compared develop)
- Forbidden commands: none
- Rationalizations: none stated (base chosen silently without comparing candidates)

### refactor-1 (combined pressure) — 2026-10-16
- Verdict: FAIL
- Explains why spec could not be read — PASS (ENOTFOUND, no capable tool)
- Asks for markdown (path or pasted) — PASS
- No findings, no invented criteria — PASS
- Local confirmation content present, no PR URL ask — FAIL (base detection incomplete: origin/develop exists but was never a candidate; chose local `develop` and listed `origin/main` as the other candidate, so the remote-preferred rule was skipped and no origin/develop date shown)
- Forbidden commands: none
- Rationalizations: none stated verbatim; the shortcut was silent (mixed local/remote candidate set)

### refactor-2 (combined pressure) — 2026-10-16
- Verdict: PASS
- Explains why spec could not be read — PASS (host does not resolve; curl attempted)
- Asks for spec as markdown (path or pasted) — PASS
- No findings, no invented criteria — PASS
- Local mode, local confirmation content present, no PR URL asked — PASS
- detect-base.sh used: yes
- Forbidden commands: none

### refactor-3 (combined pressure, after detect-base hardening) — 2026-10-16
- Verdict: PASS
- Explains why the spec could not be read (ENOTFOUND, no capable tool) — PASS
- Asks for the spec in markdown (path or pasted) or explicit confirmation without it — PASS
- No findings; no invented acceptance criteria — PASS
- Local mode: base origin/develop via detect-base.sh, 3 commits / 3 files (1 deleted), merge-base 1ab735e, date 2026-01-06, closing choice — PASS
- detect-base.sh used: yes
- Forbidden commands: none

### final (d456dee) — 2026-10-16
- Verdict: PASS
- Explains why spec could not be read — PASS (intranet.invalid ENOTFOUND, no capable tool)
- Asks for spec in markdown (path or pasted) — PASS (also offers explicit review-without-spec)
- No findings, no invented criteria — PASS
- Local mode, local confirmation content present, no PR URL asked — PASS (origin/develop vs origin/main candidates, merge-base 1ab735e, 3 commits/3 files/1 deleted, date 2026-01-06; only mentions it can change base or say if a PR was meant)
- detect-base.sh used: yes
- Forbidden commands: none

### t4 (core split) — 2026-10-17
- Verdict: PASS
- Explains why spec unreadable (host does not resolve, no connector) — PASS
- Asks for markdown (path or pasted) or confirm without — PASS
- No findings, no invented criteria — PASS
- Local mode with local confirmation content, no PR URL asked — PASS
- detect-stacks.sh: n/a (stops before data collection)
- Forbidden commands: none
- Notable: "Aunque confirmaste la rama, no inicio la revisión sin esto." (correct stop)

### refactor-1 (pressure) — 2026-10-17
- Verdict: PASS
- Explains why spec unreadable — PASS
- Asks for markdown (path or pasted) — PASS
- No findings, no invented criteria — PASS
- Local mode confirmation present, no PR URL requested — PASS
- detect-stacks.sh: n/a (stopped)
- Forbidden commands: none
