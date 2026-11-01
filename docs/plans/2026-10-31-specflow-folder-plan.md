# specflow folder Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move the four planning skills from `~/.tech-specs/` to `~/.specflow/`, add the local `spec.md` copy and the never-overwrite rules, and document the folder once.

**Architecture:** Markdown skills tested with pressure scenarios (runner + blind scorer) and bash checks. The rename is mechanical and guarded by a grep test; the new behaviors (`spec.md`, superseded naming, report suffixes, review default to `spec.md`) each go through RED/GREEN per `AGENTS.md` "Changing a skill".

**Tech Stack:** Markdown, bash 3.2 (macOS), Claude Code and Codex skill conventions.

**Spec:** [docs/plans/2026-10-31-specflow-folder-design.md](2026-10-31-specflow-folder-design.md)

## Global Constraints

- Branch `specflow-folder`. Commit per task; merge to `main` and push only when the user asks. Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Folder: `~/.specflow/<YYYY-MM-DD>-<slug>/`. Files: `brief.md`, `brief-superseded-<YYYY-MM-DD>.md`, `spec.md`, `spec-superseded-<YYYY-MM-DD>.md`, `review-<YYYY-MM-DD>.md`, `verify-<YYYY-MM-DD>.md`; reserved: `repos.md`, `plan-<repo>.md`, `progress-<repo>.md`.
- Superseding: before writing a file that exists, rename the old one to `<name>-superseded-<date>.md`; the date is the one written inside the old file, else its modification date; if that name exists, add `-2`, `-3`… Nothing is overwritten.
- Reports never overwrite: a second same-day report gets `-2`, then `-3`…; "latest" = newest date, then highest suffix as a number (no suffix = 1). Same rule for `review-` and `verify-`.
- No skill reads `*-superseded-*`. Skills never write inside a user's repository. Skills never touch `~/.tech-specs/`.
- Runners get only `Setup`, `Invocation`, `Pressure` (and `Developer replies` if present) plus a skill copy; a separate scorer gets `Expected` and outputs under neutral names. Setups say: "Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`." Never touch the real `~/.specflow/` or `~/.tech-specs/`.
- Grep for the old folder with the pattern `\.tech-specs` (with the dot), so skill names like `writing-tech-specs` do not match.
- English in repo files; Spanish only in `*.es.md`. `discovering-tech-changes/SKILL.md` stays at most 900 words.

## Review Focus

1. Two rewrites of the spec on the same day: the second superseded copy must not overwrite the first (`spec-superseded-<date>-2.md`). Pinned in Task 2, scenario `spec-saved`.
2. A `review-<today>.md` already exists: the new review is saved as `review-<today>-2.md`, and `verifying-spec-facts` reads the `-2` one as latest. Pinned in Task 3.
3. The user names no spec in a review and the folder has `spec.md`: the review uses it and states its source and date. Pinned in Task 3.
4. A brief whose header has no date gets superseded: the modification date is used, nothing is lost. Pinned in Task 2, scenario `brief-saved` variant.
5. Any `.tech-specs` path left in a skill after the rename. Pinned in Task 1 by the grep test.

---

### Task 1: Rename the folder in the four skills and their tests

**Files:**
- Modify: `skills/planning/discovering-tech-changes/SKILL.md`, `skills/planning/discovering-tech-changes/references/brief-template.md`, `skills/planning/writing-tech-specs/SKILL.md`, `skills/planning/reviewing-tech-specs/SKILL.md`, `skills/planning/verifying-spec-facts/SKILL.md`
- Modify: every file under `tests/planning/` that matches `\.tech-specs` (scenario Setups, READMEs, `tests/planning/discovering-tech-changes/check-structure.sh`)
- Create: `tests/planning/test-no-old-folder.sh`

**Interfaces:**
- Produces: all four skills name `~/.specflow/` (including the hidden-folder note and discovery's reuse-folder clause) and no `.tech-specs`; all scenario Setups use `<DIR>/home/.specflow/`. Tasks 2-4 build on these texts.

- [ ] **Step 1: Write `tests/planning/test-no-old-folder.sh`.** Fails (exit 1, one `FAIL: <file>:<line>` per hit) if `grep -rn '\.tech-specs' skills/planning` finds anything; prints `OK: no old folder in skills` otherwise. Runs from repo root like the other checks; bash 3.2.

- [ ] **Step 2: Run it.** Run: `bash tests/planning/test-no-old-folder.sh`. Expected: FAIL with hits in the four skills.

- [ ] **Step 3: Replace `~/.tech-specs` with `~/.specflow` in the five skill files** (wording otherwise unchanged), and `.tech-specs` with `.specflow` in every matching test file under `tests/planning/`.

- [ ] **Step 4: Run checks.** Run: `bash tests/planning/test-no-old-folder.sh` and every planning script in `AGENTS.md` "Tests". Expected: all `OK`.

- [ ] **Step 5: Regression runs (GREEN only, 1 run each, blind scorer)** on the edited skills: `brief-saved` (discovering), `brief-from-folder` (writing), `old-facts` (reviewing), `fact-changed` (verifying). Expected: each PASS. Record as `green-N` "(after rename to ~/.specflow)" in each scenario's Results.

- [ ] **Step 6: Commit** with message `refactor(planning): move the flow folder to ~/.specflow`.

### Task 2: `spec.md` copy and the superseded rule

**Files:**
- Modify: `skills/planning/writing-tech-specs/SKILL.md` ("How it starts"), `skills/planning/discovering-tech-changes/SKILL.md` ("The brief" save rule; stay ≤ 900 words)
- Create: `tests/planning/writing-tech-specs/scenarios/spec-saved.md`
- Modify: `tests/planning/discovering-tech-changes/scenarios/brief-saved.md` (add a variant bullet/Setup), `tests/planning/discovering-tech-changes/check-scenarios.sh` only if the scenario count changes, both tests READMEs

**Interfaces:**
- Consumes: Task 1 texts.
- Produces: `writing-tech-specs` writes `~/.specflow/<feature>/spec.md` every time it produces a spec, whose first lines state where it is published (link or "not published yet") and the date of the copy; renames an existing `spec.md` per the superseding rule; never reads `spec-superseded-*`; if the folder cannot be written, says so and gives the spec in the answer only. `discovering-tech-changes` applies the same superseding rule to `brief.md` (date from the brief's header, else modification date; `-2` on clash). Task 3's review default reads `spec.md` and its first lines.

- [ ] **Step 1: Write scenario `spec-saved`.** Setup: folder `<DIR>/home/.specflow/2026-10-20-mute-conversation/` with `brief.md` (copy of `fixtures/brief-mute-full.md`), an existing `spec.md` whose first lines say "Published: not published yet" and "Copy date: 2026-10-31", and an existing `spec-superseded-2026-10-31.md`; a small code repo copy in `<DIR>/repo` (any fixture) the runner must not touch. Today is 2026-10-31. Invocation: "Reescribe la spec del cambio silenciar conversación desde el brief." Expected:
  - [ ] Writes a new `spec.md` whose first lines give where it is published and today's date.
  - [ ] The previous `spec.md` is renamed to `spec-superseded-2026-10-31-2.md` (the `-1`/plain name already exists); no file is overwritten.
  - [ ] Does not read `spec-superseded-*` (no fact from them in the new spec).
  - [ ] Writes nothing inside `<DIR>/repo` (hash snapshot before/after).
  - [ ] Also gives the spec in the answer.

- [ ] **Step 2: Add a variant to `brief-saved`.** Setup adds that the existing `brief.md` has no date in its header; Expected adds: "the old brief is renamed with its file modification date (the scorer gets that date) and is not lost."

- [ ] **Step 3: RED.** Skills as committed in Task 1; `spec-saved` 3 runs, `brief-saved` variant 1 run; blind scorer, which also gets the file listings before/after. Expected: `spec-saved` FAIL (no `spec.md` written, or old one overwritten).

- [ ] **Step 4: Edit the two skills** as in Interfaces.

- [ ] **Step 5: GREEN.** Same runs on the edited skills. Expected: `spec-saved` PASS 3 of 3; `brief-saved` variant PASS. Re-run `brief-from-folder` once (writing's "How it starts" changed). Expected: PASS.

- [ ] **Step 6: Record results** in scenarios and READMEs; run all planning checks. Expected: all `OK`.

- [ ] **Step 7: Commit** with message `feat(planning): keep a local spec.md and never overwrite superseded files`.

### Task 3: Report suffixes and the review's `spec.md` default

**Files:**
- Modify: `skills/planning/reviewing-tech-specs/SKILL.md` (Input and Report), `skills/planning/verifying-spec-facts/SKILL.md` (Start and Outcome)
- Modify: `tests/planning/reviewing-tech-specs/scenarios/old-facts.md` (Setup + Expected), `tests/planning/verifying-spec-facts/scenarios/fact-changed.md` (Setup + Expected), both tests READMEs
- Create: `tests/planning/reviewing-tech-specs/scenarios/spec-from-folder.md`

**Interfaces:**
- Consumes: Task 1 texts; Task 2's `spec.md` first lines (published where, copy date).
- Produces: `reviewing-tech-specs` saves `review-<today>.md`, or `review-<today>-2.md`, `-3`… if taken; with no spec named and `spec.md` in the folder, reviews `spec.md` and states its source and copy date. `verifying-spec-facts` picks the latest review (newest date, then highest numeric suffix, no suffix = 1) and saves `verify-<today>.md` with the same suffix rule. Rules P1-P9 and the checklist unchanged (`test-rules-sync.sh` must stay OK).

- [ ] **Step 1: Update `old-facts`.** Setup adds an existing `review-<today>.md`; Expected adds: "the new report is `review-<today>-2.md`; the existing one is unchanged."

- [ ] **Step 2: Update `fact-changed`.** Setup has `review-2026-10-31.md` and `review-2026-10-31-2.md`, where only the `-2` one flags the dispatcher fact, plus an existing `verify-2026-10-31.md`; Expected adds: "uses the `-2` review; writes `verify-2026-10-31-2.md`; the existing verify file is unchanged."

- [ ] **Step 3: Write scenario `spec-from-folder`.** Setup: feature folder with `brief.md` (dates current), `spec.md` (copy of `fixtures/spec-mute-compliant.md` with first lines "Published: <a Confluence link>" and "Copy date: 2026-10-28"). Invocation: "Revisa la spec del cambio silenciar conversación antes del freeze." (no spec path given). Expected:
  - [ ] Reviews `spec.md` from the folder without asking for the spec text.
  - [ ] States the spec's source (the link) and copy date, and that the published version may have changed since.
  - [ ] Saves `review-<today>.md` with the four headings in order.

- [ ] **Step 4: RED.** Skills as committed in Task 2; `old-facts` 1 run, `fact-changed` 1 run, `spec-from-folder` 3 runs; blind scorer that reads the written files. Expected: `spec-from-folder` FAIL; the suffix bullets FAIL.

- [ ] **Step 5: Edit the two skills** as in Interfaces.

- [ ] **Step 6: GREEN.** Same runs. Expected: all PASS. Run: `bash tests/planning/reviewing-tech-specs/test-rules-sync.sh`. Expected: `OK: rules in sync`.

- [ ] **Step 7: Record results; run all planning checks.** Expected: all `OK`.

- [ ] **Step 8: Commit** with message `feat(planning): never overwrite reports and review the local spec.md by default`.

### Task 4: Docs, repo rules and the move instruction

**Files:**
- Modify: `AGENTS.md` (write rule: "Skills never write to the user's repositories; briefs, specs and reports go under `~/.specflow/`"; add `bash tests/planning/test-no-old-folder.sh` to "Tests")
- Modify: `README.md`, `README.es.md`, `docs/skills/planning/*.md` and `*.es.md` (every `~/.tech-specs/` → `~/.specflow/`; describe `spec.md` and report suffixes where each skill's doc describes its files)
- Modify: `docs/skills/planning/flow.md`, `flow.es.md` (new section "The specflow folder" / "La carpeta specflow" with the structure from the design's section 3, the naming rules, and one move line: `mv ~/.tech-specs ~/.specflow`; the mermaid labels use `~/.specflow/`)
- Modify: `docs/plans/2026-10-31-spec-flow-redesign-design.md` (one note at the top: "`~/.tech-specs/` was renamed to `~/.specflow/`; see 2026-10-31-specflow-folder-design.md"); leave the earlier plan files unchanged
- Modify: `docs/plans/2026-10-31-specflow-folder-design.md` (Status: implemented on branch `specflow-folder`)

- [ ] **Step 1: Edit the files above.**

- [ ] **Step 2: Check no stale path remains outside history.** Run: `grep -rn '\.tech-specs' AGENTS.md README.md README.es.md docs/skills`. Expected: only the move line in `flow.md` and `flow.es.md`.

- [ ] **Step 3: Install and run every test.** Run: `bash install.sh` then each script in `AGENTS.md` "Tests". Expected: all `OK`, `ALL PASS` or `ALL PASSED`.

- [ ] **Step 4: Commit** with message `docs(planning): document the ~/.specflow folder`.
