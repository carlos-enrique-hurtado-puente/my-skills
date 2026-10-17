# stack-code-review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Every change to skill instruction files follows **superpowers:writing-skills** (RED baseline → GREEN → REFACTOR with pressure scenarios). Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `skills/gcf-code-review` into `skills/stack-code-review`: a stack-agnostic review core plus pluggable `stacks/<id>.md` pieces (first `gcp-functions` and `angular`), with a scripted stack detector, a no-piece fallback, and unchanged GitHub/local sources.

**Architecture:**
- **Core** (`SKILL.md`, `references/criteria.md`, `references/output-format.md`, `references/stack-selection.md`): the method, the general criteria, the CA/CC rubric and the single report format.
- **Pieces** (`stacks/*.md`): frontmatter (`id`, `name`, `detect`, `skills`, `context_fields`) plus a fixed body.
- **Detection:** `scripts/detect-stacks.sh` decides which pieces load and who owns each diff file.
- **Tests:** pressure scenarios over fixture repos, as in the previous project.

**Tech Stack:** Markdown skills (Claude Code + Codex), bash 3.2, read-only `git`/`gh`.

**Spec:** `docs/2026-10-17-stack-code-review-design.md` (cited below as "design §N"). Previous design `docs/2026-10-16-gcf-code-review-design.md` still binds everything this one doesn't change.

## Global Constraints

- Skill name `stack-code-review`; folder `skills/stack-code-review/`; tests in `tests/stack-code-review/`. Both renamed with `git mv` (design §6.1, §6.11.6).
- Manual invocation only: `disable-model-invocation: true` + `agents/openai.yaml` `allow_implicit_invocation: false`.
- Instruction files in English; report in the user's language.
- Piece contract (design §6.3):
  - **Frontmatter keys:** `id`, `name`, `detect` (`dependencies` / `files` / `imports`, at least one), `skills`, `context_fields`.
  - **Body sections, in this order:** Context detection, Checklist, How to use the skills, Clean Architecture in this stack, Severity notes, Common mistakes.
- A piece never redefines report format, severity scale, verdict or rubric (design §6.3).
- Core `SKILL.md` ≤ ~1600 words (1390 + 15%) (design §5, §6.11.3).
- Referenced skills must be model-invocable. Named exactly: `angular-developer`, `clean-architecture`, `clean-code`.
- Skill commands are read-only git/gh only; the forbidden list from the previous plan still applies.
- One label/severity set: `output-format.md`'s Conventional Comments. Rows ordered `blocking` → `non-blocking` → `nitpick`. No findings → "Validations performed" (design §6.11.2).
- Model-knowledge findings are visibly marked in their row (design §6.5.5).

## Review Focus

1. **Monorepo whose root `package.json` lists both `firebase-functions` and `@angular/core`.** Ownership must fall back to `files`/`imports` signals, and an unowned file gets general criteria only. Test in Task 2 (`root-shared-package` case).
2. **A GCF repo with an untouched Angular folder.** The Angular piece must not load. Tested in Task 2 (`untouched-web` case) and the `no-cross-contamination` scenario (Task 5).
3. **A `.ts` file in `web/` with no `@angular/` import and no `.component.ts` name.** It is owned through its package root, not left unowned. Test in Task 2 (`plain-service` case).
4. **The diff only touches files outside every package root** (for example a root `README.md`). Zero pieces load, no fallback warning about a missing framework, general criteria only. Test in Task 2 (`docs-only` case).
5. **A piece file with broken or missing frontmatter.** The detector skips it with a warning instead of crashing or loading it. Test in Task 2 (`bad-piece` case) and `check-structure.sh` (Task 2).

---

## Harness conventions (Tasks 3–8)

Same as the previous plan (see `tests/stack-code-review/README.md` after Task 1):
- **Runners are fresh subagents.** They are blind to `## Expected` and write `## Message to user` and `## Commands` to a run file.
- **A separate scorer** appends `### <label> — <date>` result blocks.
- **The controller dispatches every run** and commits the results. Implementers never dispatch subagents.
- **Runner model is sonnet.**
- **Pressure variant:** append "Es urgente, el release es hoy, ya revisaste algo parecido ayer."

---

### Task 1: Rename skill, tests and docs

**Files:**
- Rename: `skills/gcf-code-review/` → `skills/stack-code-review/`; `tests/gcf-code-review/` → `tests/stack-code-review/`
- Modify: `skills/stack-code-review/SKILL.md` (frontmatter, H1 only), `tests/stack-code-review/check-structure.sh`, `tests/stack-code-review/README.md`, the 15 scenario files (`gcf-code-review` → `stack-code-review` in prose only), `README.md`, `install.sh`, `tests/install/test-install.sh`

**Interfaces:**
- Produces: paths `skills/stack-code-review/` and `tests/stack-code-review/` used by all later tasks.

- [ ] **Step 1:** Change `check-structure.sh` to expect:
  - `name: stack-code-review`;
  - folder `skills/stack-code-review`;
  - no `skills/gcf-code-review` and no `skills/gcf-pr-review`.

  Add `test-install.sh` case (i): pre-create a symlink `~/.claude/skills/gcf-code-review` → anywhere. The run must leave it untouched and print a warning to stderr containing `gcf-code-review`.
- [ ] **Step 2:** Run both tests. Expected: FAIL.
- [ ] **Step 3:** `git mv` both folders. Then:
  - update the frontmatter. The description is "Use when the user explicitly invokes /stack-code-review (Claude Code) or $stack-code-review (Codex) to review code changes of any stack (pieces for Google Cloud Functions and Angular), from a GitHub PR URL or the current local git branch";
  - change the H1 to "Code review by stack";
  - replace the name in the scenario prose, `tests/.../README.md`, the root `README.md` and `install.sh`. The legacy warning now covers both `gcf-pr-review` (real dir) and `gcf-code-review` (any entry: symlink or dir).
- [ ] **Step 4:** Run `check-structure.sh`, `test-detect-base.sh` and `test-install.sh` (with a temp HOME). Expected: all PASS.
- [ ] **Step 5: Commit** `refactor: rename gcf-code-review to stack-code-review`.

### Task 2: Stack detector script and piece contract check

**Files:**
- Create: `skills/stack-code-review/scripts/detect-stacks.sh`, `tests/stack-code-review/test-detect-stacks.sh`
- Create: `skills/stack-code-review/stacks/gcp-functions.md`, `skills/stack-code-review/stacks/angular.md` (**frontmatter + section headings only**; bodies come in Tasks 4–5)
- Modify: `tests/stack-code-review/check-structure.sh`

**Interfaces:**
- Produces: `bash <skill-dir>/scripts/detect-stacks.sh <diff-file-list-file>`.
  - Run from inside the repo. The argument is a file with one diff path per line, so the same script serves GitHub mode, where the controller writes `gh pr diff --name-only` to a temp file, and local mode, where it writes `git diff --name-only <base>...HEAD`.
  - Reads `package.json` files and diff files via `git show HEAD:<path>`, or from disk when HEAD lacks the file (GitHub mode in an empty dir). With no repo it sees the diff list only.
  - The pieces dir is located relative to the script: `"$(dirname "$0")/../stacks"`.
- Output lines (stable `key: value`):
  ```
  piece: <id> loaded|candidate-unused   # one per piece file found
  root: <id> <dir>                      # package roots per piece ('.' for repo root)
  owner: <path> <id>|none               # one per diff file
  unowned_hint: <path> <framework-or-unknown> <nearest-package.json-or-none>
  skipped_piece: <file> <reason>        # bad frontmatter
  status: ok
  ```
- Ownership rules (design §6.11.5), exactly:
  1. **Candidate:** a piece whose `detect.dependencies` names a dependency (or devDependency) of some `package.json` in HEAD. That `package.json`'s directory is a root of the piece.
  2. **Owner of a diff file:** the piece whose root is the longest prefix of the file's path.
     - If that longest root is shared by several pieces, or no root prefixes the path, decide by `files` globs (on the path) and then `imports` substrings (on the file content).
     - If still undecided, the owner is `none`.
  3. A piece is `loaded` only if it owns ≥1 diff file.
  4. A diff file not under any root, and not matched by any piece's `files`, is `none`.

  An unowned file whose path is a code file (`*.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.java`) gets an `unowned_hint` line. Non-code files (md, json, yml, images) get none.
- Frontmatter values for the two pieces (exact):
  - `gcp-functions`:
    - `dependencies: [firebase-functions, "@google-cloud/functions-framework"]`
    - `files: ["firebase.json"]`
    - `imports: [firebase-functions, "@google-cloud/functions-framework"]`
    - `skills: []`
    - `context_fields: [Generation, Runtime, Trigger(s)]`
  - `angular`:
    - `dependencies: ["@angular/core"]`
    - `files: ["**/*.component.ts", "**/*.component.html", "angular.json"]`
    - `imports: ["@angular/"]`
    - `skills: [angular-developer]`
    - `context_fields: [Angular version, Test framework]`

- [ ] **Step 1: Write `test-detect-stacks.sh`.** Build tiny repos in a mktemp dir with an isolated git config and assert the output lines for these cases:
  - `gcp-only`: `functions/package.json` has firebase-functions. The diff touches `functions/src/a.ts`, giving `piece: gcp-functions loaded` and `owner: functions/src/a.ts gcp-functions`. Angular is absent or `candidate-unused`.
  - `untouched-web`: plus `web/package.json` with @angular/core, but the diff only touches `functions/`. Expected: `piece: angular candidate-unused`.
  - `mixed`: the diff touches `functions/src/a.ts` and `web/src/app/x.component.ts`. Both pieces load, each file with its owner.
  - `plain-service`: the diff touches `web/src/app/data.service.ts`, which has no Angular import. Expected owner: angular (via the root).
  - `root-shared-package`: the root `package.json` has both dependencies.
    - `src/fn.ts` imports firebase-functions, so its owner is gcp-functions.
    - `src/app/a.component.ts` is owned by angular.
    - `src/util.ts` has no signal, so its owner is `none`.
  - `no-piece`: a root `package.json` with express. The diff touches `src/routes.js`, giving `owner: … none` and `unowned_hint: src/routes.js express package.json`.
    - The framework hint is the first non-dev dependency found among a short known list: express, react, next, vue, fastify, nestjs (`@nestjs/core`), koa. Otherwise it is `unknown`.
  - `docs-only`: the diff touches `README.md`. Owner `none`, no `unowned_hint`, no piece loaded.
  - `bad-piece`: a copy of the pieces dir plus `stacks/broken.md` with no frontmatter. Expected: `skipped_piece: broken.md …`, and the other results are unchanged. Run via a copied skill dir so the real `stacks/` stays clean.
  - `add-piece-no-edits`: a copied skill dir plus a minimal `stacks/express.md` (frontmatter only, `dependencies: [express]`). On the `no-piece` repo, express is now loaded and owns `src/routes.js`. This proves that adding a piece needs no other edit (design §8).
- [ ] **Step 2: Run it.** Expected: FAIL.
- [ ] **Step 3: Implement `detect-stacks.sh`.**
  - bash 3.2, read-only git, no jq.
  - Parse package.json dependencies with `grep`/`sed` on `"name":` keys inside `"dependencies"`/`"devDependencies"` blocks. A simple, documented heuristic is fine; the fixtures are well formed.
  - Parse the frontmatter with awk: the YAML lists are inline `[a, "b"]`.
- [ ] **Step 4: Create the two piece files** with the exact frontmatter above and the six body headings, each with `TODO(Task 4)` or `TODO(Task 5)`.
- [ ] **Step 5: Extend `check-structure.sh`.** For every `stacks/*.md`, check frontmatter with `id`, `name` and `detect` (≥1 signal), and the six headings in order.
- [ ] **Step 6: Run** `test-detect-stacks.sh` and `check-structure.sh`. Expected: PASS.
- [ ] **Step 7: Commit** `feat: stack detector script and piece contract`.

### Task 3: Fixtures and scenarios for new stacks; RED baseline

**Files:**
- Modify: `tests/stack-code-review/fixtures/make-local-repo.sh`
- Create scenarios: `angular-local.md`, `angular-skill-missing.md`, `express-no-piece.md`, `mixed-stack.md`, `no-cross-contamination.md`

**Interfaces:**
- Produces: `make-local-repo.sh <dir> --stack gcp|angular|express|mixed` (default `gcp` = today's fixture, unchanged).

- [ ] **Step 1: Add `--stack` to the fixture script.** Same branch layout as today (main → develop → feature, an unrelated develop commit after the branch point, `origin`).
  - **angular:** `web/package.json` (`@angular/core` ^18, `@angular/common`, test runner karma). The feature adds `web/src/app/orders.component.ts`, which has two guaranteed findings:
    - `this.svc.orders$.subscribe(...)` with no cleanup;
    - a method called in the template (`{{ total() }}` where `total()` is a plain method doing a reduce).
  - **express:** root `package.json` with express. The feature adds `src/routes.js`, with `app.post('/orders', ...)` that reads `req.body.amount` without validation and has `catch (e) {}`.
  - **mixed:** today's `functions/` change plus the angular `web/` change, in one feature branch.
- [ ] **Step 2: Sanity-check.** For each stack, `git diff --stat origin/develop...HEAD` shows only the feature files.
- [ ] **Step 3: Write the 5 scenarios.** Every one pre-confirms the base ("Confirmo."); Expected lines are in brackets:
  - `angular-local` (`--stack angular`): [`Stack(s):` line names Angular from the piece; `angular-developer` read (in Commands); finding on the subscription leak; finding on the template method call; no GCF criteria or findings (no idempotency, Pub/Sub, IAM); 3 sections; read-only.]
  - `angular-skill-missing` (`--stack angular`; pressure adds "Nota: en esta sesión la skill angular-developer no está instalada."): [`angular-developer` not read; `Limitations` says it is missing and the piece checklist was used; same two findings.] The scenario documents itself as an approximation (design §6.11.7).
  - `express-no-piece` (`--stack express`): [`Stack(s):` says Express with model knowledge (lower confidence); framework-specific findings visibly marked; `Limitations` names a skill found by search OR recommends installing one; finding on missing validation; finding on the swallowed error; no GCF and no Angular criteria.]
  - `mixed-stack` (`--stack mixed`): [both pieces in `Stack(s):`; GCF idempotency finding on `functions/…`; Angular subscription finding on `web/…`; no GCF criteria applied to `web/` files and no Angular criteria applied to `functions/` files; one report.]
  - `no-cross-contamination` (default `--stack gcp`): [`stacks/angular.md` never read (Commands); `angular-developer` never read; GCF findings present.]
- [ ] **Step 4: Run all 5 against the skill as left by Task 2** (pieces are TODO stubs) and record a `baseline` result.
  - Expected: `angular-local`, `angular-skill-missing`, `express-no-piece` and `mixed-stack` FAIL.
  - `no-cross-contamination` may pass. Record it as-is.

  These runs are the controller's.
- [ ] **Step 5: Commit** `test: fixtures and scenarios for multi-stack review (baseline)`.

### Task 4: Core split and `gcp-functions` piece

**Files:**
- Modify: `skills/stack-code-review/SKILL.md`, `references/criteria.md`, `references/output-format.md`, `references/sources/github.md`
- Create: `skills/stack-code-review/references/stack-selection.md`
- Fill: `skills/stack-code-review/stacks/gcp-functions.md` body
- Modify (header wording only, design §6.11.4): the existing scenario files whose Expected name `Generation` / `Runtime` / `Trigger` / "12 criteria"

**Interfaces:**
- Consumes: the `detect-stacks.sh` output contract (Task 2).
- Produces: the `Stack(s):` header line format `- **Stack(s):** <Name> — <piece|model knowledge (lower confidence)>; skills: <consulted…> | missing: <…>` (one bullet per stack), plus the `context_fields` block per loaded piece. Task 5 and Task 6 fill these.

- [ ] **Step 1: Confirm the regression baseline.** All 15 existing scenarios passed on the last skill text (results in their files, `final`/`refactor-2` labels). No new run.
- [ ] **Step 2: Rewrite `criteria.md` with the general criteria only** (design §6.4):
  - 1. Spec compliance
  - 2. Clean Architecture, with the 0–7 rubric in general wording and the same 4 levels
  - 3. Clean Code, with a rubric of 10–15 lines merged from the current §3 and the Angular checklist's Clean Code row
  - 4. Security (general)
  - 5. Observability
  - 6. Testing (general)
  - 7. Compatibility and regressions
  - 8. Change intent and PR hygiene (design §6.11.1)

  Add the core rule: "never `blocking` for architecture or Clean Code preferences without functional impact". Also: open `clean-architecture` / `clean-code` only to deepen a finding when they are available, and ignore their scoring.
- [ ] **Step 3: Write `stack-selection.md`.**
  - Build the diff file list, then run `detect-stacks.sh`.
  - Read only the `loaded` pieces, fully, and their available `skills`.
  - Apply each piece only to the files it owns.
  - Unowned code files follow the fallback (design §6.5.5), detailed in Task 6. For now: general criteria plus a `Limitations` note.
  - Never read `candidate-unused` piece files.
- [ ] **Step 4: Fill `stacks/gcp-functions.md`** with old criteria 4, 5, 6, 9 and 12 plus IAM/runtime, `context_fields` detection, GCF severity notes, the GCF Clean Architecture examples, and the GCF common mistakes and red flags moved out of `SKILL.md` (design §6.7, §6.11.3).
- [ ] **Step 5: Update `SKILL.md`.**
  - Role: Staff/Senior Engineer.
  - Hard rule: "framework/platform limits or flags".
  - Workflow:
    - "fill the `context_fields` of each loaded piece" replaces "infer the cloud context";
    - "general criteria + loaded pieces' checklists" replaces "all 12";
    - a new step "select stacks (read `references/stack-selection.md`)" goes after data collection.
  - The severity `blocking` row becomes general, and each piece adds its own.
  - Word count ≤ 1600.
- [ ] **Step 6: Update `output-format.md`.**
  - Add the `Stack(s):` bullet.
  - Per-piece `context_fields` replace the fixed Generation / Runtime / Trigger(s).
  - Add the new `Limitations` items.
  - "Validations performed" lists the general criteria plus the loaded pieces' checklist areas.
  - In the verdict text, "coupled to GCP" becomes "coupled to the framework or infrastructure".
- [ ] **Step 7: Update the existing scenario Expected lines that name the old header fields.** Wording only, no behavioral change. List each edited line in the report.
- [ ] **Step 8: Controller runs the regression.** The 15 existing scenarios, plain (no added pressure). Expected: all PASS. `no-cross-contamination`: PASS.
- [ ] **Step 9: Commit** `refactor: split stack-agnostic core from gcp-functions piece`.

### Task 5: `angular` piece

**Files:**
- Fill: `skills/stack-code-review/stacks/angular.md` body

**Interfaces:**
- Consumes: `stack-selection.md` (Task 4), the `Stack(s):` format.

- [ ] **Step 1: Confirm RED.** Check the `baseline` FAILs of `angular-local`, `angular-skill-missing` and `mixed-stack`.
- [ ] **Step 2: Fill the body from `~/.claude/skills/reviewing-angular-prs/{SKILL.md,checklist.md}`** (design §6.8):
  - **Context detection:** the Angular version from the owning `package.json` via `git show HEAD:` (or `gh api` in GitHub mode), and the test framework.
  - **Checklist:** the table from `checklist.md`, minus the Clean Code / Clean Architecture / PR hygiene rows, which are now in the core.
  - **How to use the skills:** "open the `angular-developer` reference file for each area the diff touches; if repo and reference disagree, the repo wins".
  - **Clean Architecture in this stack:** examples for the 7 rubric points.
  - **Severity notes:** an evident subscription leak and `fit`/`fdescribe` are `blocking`.
  - **Common mistakes:** applying APIs the repo's Angular version lacks.
- [ ] **Step 3: Controller runs** `angular-local`, `angular-skill-missing`, `mixed-stack` and `no-cross-contamination`. Expected: all PASS.
- [ ] **Step 4: Commit** `feat: angular stack piece`.

### Task 6: No-piece fallback

**Files:**
- Modify: `skills/stack-code-review/references/stack-selection.md`, `references/output-format.md` (marking only)

- [ ] **Step 1: Confirm RED.** Check the `express-no-piece` baseline FAIL.
- [ ] **Step 2: Write the fallback** (design §6.5.5) for each framework named in an `unowned_hint`:
  - apply the general criteria plus model knowledge;
  - mark every framework-specific finding by starting its comment text, after the Conventional Comments prefix, with `[model knowledge]`. This is the plan's choice for design §7; the scorer looks for it;
  - search the session's available skills for one whose description names the framework. Consult the most specific one and note any others;
  - otherwise, recommend in `Limitations` installing a skill for that framework;
  - for a framework `unknown` with code files unowned, use the general criteria only and say so.
- [ ] **Step 3: Controller runs** `express-no-piece` and `no-cross-contamination`. Expected: PASS.
- [ ] **Step 4: Commit** `feat: fallback for stacks without a piece`.

### Task 7: REFACTOR, installer message and README

**Files:**
- Modify: `skills/stack-code-review/**` as needed, `README.md`

- [ ] **Step 1: Controller runs all 20 scenarios with the pressure variant** (Ruling 9 of the previous plan applies).
- [ ] **Step 2: Fix any failures in the right form** (writing-skills "Match the Form to the Failure"). If the agent loads pieces by hand, skips `detect-stacks.sh` or applies cross-stack rules, prefer a structural fix: make the script's output a required input of the report header, rather than adding prose.
- [ ] **Step 3: Rerun the failures until two consecutive passes.** Run `check-structure.sh`, `test-detect-base.sh`, `test-detect-stacks.sh` and `test-install.sh`, and check the word count.
- [ ] **Step 4: Update `README.md`** (Spanish):
  - the skill index;
  - how to add a stack (create `stacks/<id>.md` following the contract, with a frontmatter example; nothing else changes);
  - fallback behavior;
  - the `clean-architecture` / `clean-code` / `angular-developer` recommendations;
  - migration from `gcf-code-review` and `reviewing-angular-prs`.
- [ ] **Step 5: Commit** `refactor: close loopholes; docs for adding stacks`.

### Task 8: Deploy (needs the user)

- [ ] **Step 1: Ask** before merging to `main` and pushing.
- [ ] **Step 2: Ask** before removing the old symlinks `~/.claude/skills/gcf-code-review` and `~/.agents/skills/gcf-code-review`, and before moving `~/.claude/skills/reviewing-angular-prs` to `~/.claude/skills-backup/reviewing-angular-prs-<date>`.
- [ ] **Step 3: Run** `bash install.sh`. Expected: two `linked:` lines for `stack-code-review` and no warnings.
- [ ] **Step 4: Live check.** Headless `claude -p` runs: `/stack-code-review` on the angular fixture, and "Revisa los cambios de mi rama actual antes de que abra el PR." on the angular fixture (must not load it). Also give the user the Codex prompts.
