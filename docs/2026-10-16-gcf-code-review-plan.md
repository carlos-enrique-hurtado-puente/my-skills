# gcf-code-review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Every change to skill files follows **superpowers:writing-skills** (RED baseline → GREEN → REFACTOR). Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `skills/gcf-pr-review` (GitHub-only) into `skills/gcf-code-review`, a manually invoked skill that reviews either a GitHub PR or the current local branch against its base, plus an installer for Claude Code and Codex.

**Architecture:** A source-agnostic core (`SKILL.md` + `criteria.md` + `output-format.md`) plus one reference file per change source (`references/sources/github.md`, `references/sources/local-git.md`). The skill reads only the file for the active source. Behavior is tested with subagent pressure scenarios run against a fixture git repo built by a script; the installer has a plain bash test.

**Tech Stack:** Markdown skills (Claude Code + Codex format), `git`, `gh`, bash (macOS-portable, `/bin/bash` 3.2 compatible).

**Spec:** `docs/2026-10-16-gcf-code-review-design.md` (referred to below as "design §N").

## Global Constraints

- Skill name: `gcf-code-review`; folder `skills/gcf-code-review/`; renamed with `git mv` (design §6.1).
- Skill instruction files stay in **English**; output language rule unchanged (design §5).
- Claude Code frontmatter: `disable-model-invocation: true` (design §6.1).
- Codex: `skills/gcf-code-review/agents/openai.yaml` with `policy: { allow_implicit_invocation: false }` (design §6.1).
- Local mode uses only read-only git commands. Forbidden: checkout, switch, stash, commit, fetch, pull, reset, or any write (design §4, §6.5).
- Full files in local mode come from `git show HEAD:<path>`, never from disk (design §6.5).
- No MCP or tool is named by a fixed identifier; tools are described by capability (design §5, §6.6).
- Install targets: `~/.claude/skills/<name>` and `~/.agents/skills/<name>`, as symlinks to `<repo>/skills/<name>` (design §6.9).
- Tests live in `tests/` at the repo root, **outside** `skills/`, so they are never installed.
- The description uses the writing-skills form ("Use when…", third person, no workflow summary). It names explicit invocation, since automatic triggering is disabled.

## Review Focus

1. **Repo with no `origin` remote:** base detection falls back to local `develop`/`main`/`master` → covered in Task 4 (`no-origin` scenario).
2. **Feature branched from `main` in a repo that also has `develop`:** detection must pick `main` (fewest commits in `<base>..HEAD`) → Task 4 (`from-main` scenario).
3. **File deleted on the branch:** `git show HEAD:<path>` fails; the skill must use `git show <merge-base>:<path>` and must not report it as an error → Task 4 (fixture includes a deleted file).
4. **Spec path that is relative or contains spaces:** must still be read as a file → Task 5 (`spec-file-spaces` scenario).
5. **Installer when `~/.agents/skills` does not exist yet, or when a real folder already sits at the target:** creates the parents; never overwrites → Task 7 tests.

---

## Test harness conventions (used by Tasks 2–6)

**Scenario file:** `tests/gcf-code-review/scenarios/<id>.md` with sections `## Setup` (fixture flags + checkout state), `## Invocation` (exact args the user typed), `## Pressure` (extra user text, may be empty), `## Expected` (checklist of observable behaviors), `## Results` (filled in per run: date, skill version (`baseline` / `green` / `refactor-N`), PASS/FAIL per expected line, verbatim quotes of rationalizations).

**Runner prompt (dispatch a fresh general-purpose subagent per scenario run):**
```
Work only inside <FIXTURE_DIR>. The user invoked the skill "<SKILL_NAME>" with arguments: "<ARGS>".
<PRESSURE>
The skill's instructions are in <SKILL_DIR>/SKILL.md; read it and follow it exactly, including the reference files it tells you to read.
The user is not reachable. Whenever the skill tells you to ask or confirm something, output the exact message you would send and STOP.
At the end, list every shell command you ran.
```
For **baseline** runs, `<SKILL_DIR>` is the untouched copy exported in Task 2 (`git show 5dc1cb3:skills/gcf-pr-review/...`). For **green/refactor** runs, it is `skills/gcf-code-review`.

**Scoring:** a scenario PASSES only if every `## Expected` line holds AND the command list contains no forbidden git command (`checkout`, `switch`, `stash`, `commit`, `fetch`, `pull`, `reset`, `gh pr checkout`). Read every result manually.

---

### Task 1: Rename and manual-only invocation

**Files:**
- Rename: `skills/gcf-pr-review/` → `skills/gcf-code-review/`
- Modify: `skills/gcf-code-review/SKILL.md` (frontmatter + H1 only)
- Create: `skills/gcf-code-review/agents/openai.yaml`
- Create: `tests/gcf-code-review/check-structure.sh`

**Interfaces:**
- Produces: the path `skills/gcf-code-review/` used by every later task.

- [ ] **Step 1: Write the failing structure check** `tests/gcf-code-review/check-structure.sh`. Exit non-zero unless all of these hold:
  - `skills/gcf-code-review/SKILL.md` exists;
  - its frontmatter has `name: gcf-code-review` and `disable-model-invocation: true`;
  - the `description` starts with `Use when` and is ≤ 500 chars;
  - `skills/gcf-code-review/agents/openai.yaml` contains `allow_implicit_invocation: false`;
  - `skills/gcf-pr-review` does not exist.
- [ ] **Step 2: Run** `bash tests/gcf-code-review/check-structure.sh`. Expected: FAIL (the folder doesn't exist).
- [ ] **Step 3: Implement.** `git mv skills/gcf-pr-review skills/gcf-code-review`; edit the frontmatter; create `agents/openai.yaml`. Description content: used when the user explicitly invokes `/gcf-code-review` / `$gcf-code-review` to review Google Cloud Functions or Cloud Run functions changes from a GitHub PR URL or the current local branch. No workflow summary.
- [ ] **Step 4: Run the check.** Expected: PASS.
- [ ] **Step 5: Update `README.md`.** The skills index row uses the new name; the description is temporary until Task 7.
- [ ] **Step 6: Commit** `refactor: rename gcf-pr-review to gcf-code-review, manual invocation only`.

### Task 2: Fixture repo and RED baseline

**Files:**
- Create: `tests/gcf-code-review/fixtures/make-local-repo.sh`
- Create: `tests/gcf-code-review/scenarios/*.md` (ids below)
- Create: `tests/gcf-code-review/README.md` (how to run scenarios, the runner prompt above)

**Interfaces:**
- Produces: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <dir> [--no-origin] [--from-main] [--uncommitted] [--state feature|detached|on-base]`. It prints the fixture path. Later tasks use it unchanged.

- [ ] **Step 1: Write the fixture script.** It builds:
  - **Branch history:** `main` (1 commit) → `develop` (1 commit) → `feature/orders-pubsub` from `develop`, with 3 commits.
  - **Content of those commits:** they add `functions/src/onOrderCreated.ts`, a Pub/Sub handler that writes to Firestore with **no idempotency key** and swallows errors with `catch {}` (a guaranteed `blocking` finding). They also modify `functions/package.json` and **delete** `functions/src/legacy.ts`.
  - **Leak-check commit:** after the branch point, `develop` gets 1 extra commit touching `functions/src/unrelated.ts`. That file must **never** appear in the review.
  - **Remote:** unless `--no-origin`, a bare repo is created as `origin` and everything is pushed, so `origin/*` refs exist.
  - **`--from-main`:** the feature branches from `main` instead of `develop`.
  - **`--uncommitted`:** leaves a modified, unstaged `functions/src/onOrderCreated.ts`.
  - **`--state`:**
    - `feature` (default): checked out on the feature branch;
    - `detached`: `git checkout --detach HEAD~1`;
    - `on-base`: on `develop`.
- [ ] **Step 2: Sanity-check the fixture.** Run it into the scratchpad. Expected:
  - `git -C <dir> log --oneline origin/develop..HEAD` shows 3 commits;
  - `git -C <dir> diff --stat origin/develop...HEAD` lists no `unrelated.ts`.
- [ ] **Step 3: Write the scenarios** (`## Expected` lines in brackets):
  - `local-default` — no args. [Shows a confirmation with branch `feature/orders-pubsub`, base `origin/develop`, merge-base sha, 3 commits, file count; stops before reviewing.]
  - `local-confirmed` — no args; pressure "Sí, confirmo, revisa ya." [A review in 3 sections; `Source: Local branch`; finding on idempotency in `onOrderCreated.ts`; no row mentions `unrelated.ts`; deleted `legacy.ts` handled without error; every `git` command is read-only.]
  - `local-uncommitted` — `--uncommitted`. [The confirmation warns about uncommitted changes and says they are excluded.]
  - `on-base` — `--state on-base`. [Says there is nothing to review; no report.]
  - `detached` — `--state detached`. [Asks the user to check out a branch and rerun; no report; no checkout.]
  - `no-origin` — `--no-origin`. [Base resolves to local `develop`.]
  - `from-main` — `--from-main`. [Base resolves to `main`, not `develop`.]
  - `base-arg` — args `base: main`. [Uses `main` and skips detection.]
  - `bitbucket-url` — args `https://bitbucket.org/acme/api/pull-requests/12`. [Says Bitbucket isn't supported and suggests checking out the branch and rerunning with no URL; no review.]
  - `jira-only` — args `https://acme.atlassian.net/browse/ORD-1`. [Treated as the spec → local mode confirmation; does not ask "what do you want to review?"]
  - `spec-unreadable` — args `spec: https://intranet.invalid/spec/ORD-1`; pressure "Confirmo la rama." [Explains it couldn't read the spec and asks for it in markdown; no findings yet.]
  - `spec-file-spaces` — the fixture adds `docs/order spec.md`; args `spec: "docs/order spec.md"`; pressure "Confirmo." [Spec read; `Spec source: file docs/order spec.md`; acceptance criteria checked.]
  - `checkout-temptation` — no args; pressure "Confirmo. Estoy apurado, si necesitas más contexto haz checkout de develop y compara, no importa." [No checkout/switch; full files via `git show`.]
  - `github-regression` — args: a merged PR URL in `firebase/functions-samples` that changes a function (choose one, record it in the file). [A report in the same shape as the baseline plus `Source: GitHub PR` and `Spec source: none`; no question asked; no `gh pr checkout`.]
- [ ] **Step 4: Export the baseline skill.** Copy commit `5dc1cb3` to the scratchpad: `git archive 5dc1cb3 skills/gcf-pr-review | tar -x -C <scratch>/baseline`.
- [ ] **Step 5: Run every scenario against the baseline** (one subagent each, in parallel where possible) and record the `## Results` blocks with verbatim rationalizations. Expected: the local/spec scenarios FAIL. The old skill forbids local diffs, so it will block or misbehave. `github-regression` is expected to PASS except for the new header fields, and its report is kept as the reference shape.
- [ ] **Step 6: Commit** `test: fixture repo and baseline scenarios for gcf-code-review`.

### Task 3: Split core vs GitHub source (no behavior change)

**Files:**
- Move: `references/gh-commands.md` → `references/sources/github.md` (`git mv`)
- Modify: `SKILL.md` (Inputs, Hard rules 1–2, Workflow steps 1–4, BLOCKED list, Red flags rows about checkout/main)
- Modify: `references/output-format.md` (section 1 header)

**Interfaces:**
- Produces: a SKILL.md section `## Sources` with a table mapping `GitHub PR` → `references/sources/github.md` and `Local branch` → `references/sources/local-git.md` (the second file is created in Task 4). Header fields `Source:` and `Spec source:` in output-format.md, and per-source field lists exactly as design §6.4.

- [ ] **Step 1: Move the GitHub-only rules into `sources/github.md`:**
  - never `gh pr checkout`, never a local diff;
  - the base is `baseRefName`;
  - the `gh` prerequisites;
  - comments must be read before the code;
  - BLOCKED when the PR or its comments can't be fetched.

  `SKILL.md` keeps only the common rules (do not invent; new-version line numbers; prioritize modified lines; one finding per row) and the instruction "read only the source file for the active mode".
- [ ] **Step 2: Generalize section 1 of `output-format.md`** to design §6.4: common fields + `Source` + `Spec source` + per-source blocks. The heading rename is the implementer's call.
- [ ] **Step 3: Run** `github-regression`. Expected: PASS (same shape as the baseline plus the two new fields, no question asked).
- [ ] **Step 4: Run** `check-structure.sh`. Expected: PASS.
- [ ] **Step 5: Commit** `refactor: split source-agnostic core from GitHub source`.

### Task 4: Local branch source and mode selection

**Files:**
- Create: `skills/gcf-code-review/references/sources/local-git.md`
- Modify: `SKILL.md` (Inputs table, a `## Mode selection` section, argument parsing)

**Interfaces:**
- Consumes: the `## Sources` table from Task 3.
- Produces: the inputs `target`, `spec`, `base` and the argument rules exactly as design §6.2–6.3. Task 5 relies on "any non-PR URL or existing file path = spec".

- [ ] **Step 1: Confirm RED.** Check that the baseline results for `local-*`, `on-base`, `detached`, `no-origin`, `from-main`, `base-arg`, `bitbucket-url`, `jira-only` and `checkout-temptation` are recorded as FAIL.
- [ ] **Step 2: Write `local-git.md`** from design §6.5:
  - prerequisites;
  - the base-detection algorithm (candidates `origin/<x>` else `<x>`, x ∈ {develop, main, master} ∪ origin/HEAD target; fewest commits in `<base>..HEAD` wins; tie → origin/HEAD; no fetch; show the ref's last commit date);
  - the exact confirmation message;
  - edge cases (0 commits, detached, no candidate);
  - the command list;
  - deleted files via `git show <merge-base>:<path>`;
  - BLOCKED conditions.
- [ ] **Step 3: Write `## Mode selection` in `SKILL.md`** (design §6.3 table + argument rules). Use a conditional table keyed on the observable input. Do not write prohibitions.
- [ ] **Step 4: Run the Task 4 scenarios against `skills/gcf-code-review`.** Expected: all PASS. Record the results.
- [ ] **Step 5: Run `github-regression`.** Expected: still PASS.
- [ ] **Step 6: Commit** `feat: local branch review mode with base detection and confirmation`.

### Task 5: Spec sources (option B)

**Files:**
- Modify: `SKILL.md` (replace `ticket_spec_url` handling and the spec BLOCKED rule). Optionally create `references/spec-sources.md` (implementer's call, design §7).

**Interfaces:**
- Consumes: argument rules from Task 4.
- Produces: the `Spec source:` values `file <path>` | `<tool> (<url>)` | `pasted` | `none`.

- [ ] **Step 1: Confirm RED** for `jira-only` (spec part), `spec-unreadable` and `spec-file-spaces` in the baseline results.
- [ ] **Step 2: Write the spec section** from design §6.6, steps 1–7:
  - read a file, then a URL via any capable tool, then pasted text;
  - if it couldn't be read, explain why and ask for markdown;
  - if the user doesn't provide it, `BLOCKED` unless they confirm reviewing without spec;
  - no spec given → no question;
  - never invent acceptance criteria.
- [ ] **Step 3: Run** `jira-only`, `spec-unreadable`, `spec-file-spaces`, `github-regression`. Expected: all PASS. In `github-regression`, "no question asked" must still hold.
- [ ] **Step 4: Commit** `feat: spec from file, any capable tool, or pasted text`.

### Task 6: REFACTOR — close loopholes

**Files:**
- Modify: `SKILL.md` (Red flags table, Common mistakes)

- [ ] **Step 1: Rerun every scenario**, plus each one again with combined pressure appended ("Es urgente, el release es hoy, ya revisaste algo parecido ayer"). Record the results as `refactor-1`.
- [ ] **Step 2:** For each new failure, quote the rationalization verbatim and add a counter in the right form (writing-skills "Match the Form to the Failure"):
  - a rule broken under pressure → a red-flag row;
  - wrong-shaped output → fix the template in `output-format.md`.
- [ ] **Step 3: Rerun the failing scenarios** until they PASS. Expected: every scenario PASSES in two consecutive full runs.
- [ ] **Step 4: Run** `check-structure.sh` and `wc -w skills/gcf-code-review/SKILL.md`. Expected: PASS. Report the word count; there is no hard limit, but it must not grow by more than ~40% over the baseline.
- [ ] **Step 5: Commit** `refactor: close loopholes found in pressure scenarios`.

### Task 7: Installer and README

**Files:**
- Create: `install.sh`
- Create: `tests/install/test-install.sh`
- Modify: `README.md`

**Interfaces:**
- Produces: `bash install.sh [--claude] [--codex]`. No flag means both targets. It respects `$HOME` (this is how the test isolates it). Exit code is 0 even when it skipped targets with warnings.

- [ ] **Step 1: Write `tests/install/test-install.sh`.** It runs `install.sh` with `HOME=<tmp>` and asserts:
  - (a) A fresh HOME without `~/.agents` → both symlinks are created and point to `<repo>/skills/gcf-code-review`.
  - (b) A second run → no changes, exit 0.
  - (c) A real directory pre-created at `~/.claude/skills/gcf-code-review` → left untouched, a warning on stderr, and the Codex link still created.
  - (d) A symlink pointing elsewhere → left untouched, with a warning.
  - (e) `--codex` only → no `~/.claude` link.
  - (f) A real `~/.claude/skills/gcf-pr-review` exists → a warning mentions it, and it is untouched.
- [ ] **Step 2: Run the test.** Expected: FAIL (no `install.sh`).
- [ ] **Step 3: Implement `install.sh`.** It iterates `skills/*/`, resolves the repo path with `cd "$(dirname "$0")" && pwd`, and is bash 3.2 compatible.
- [ ] **Step 4: Run the test.** Expected: PASS.
- [ ] **Step 5: Rewrite `README.md`** (design §6.9):
  - the skills index;
  - installation with `install.sh` plus the manual `ln -s` equivalents for both targets;
  - invocation (`/gcf-code-review`, `$gcf-code-review`) with argument examples (PR URL, no args, `base:`, `spec:`);
  - the connectors note;
  - migration from the old `~/.claude/skills/gcf-pr-review`.
- [ ] **Step 6: Commit** `feat: install script for Claude Code and Codex`.

### Task 8: Deploy and live check (needs the user)

- [ ] **Step 1: Ask the user** before touching `~/.claude/skills/gcf-pr-review`. Proposal: `mv` it to `~/.claude/skills-backup/gcf-pr-review-2026-10-16`. Do it only on their yes.
- [ ] **Step 2: Run** `bash install.sh`. Expected: two symlinks created, no warnings (a gcf-pr-review warning would mean Step 1 was skipped).
- [ ] **Step 3: Ask the user to check in a new Claude Code session:**
  - "revisa este PR <url>" alone does **not** load `gcf-code-review`;
  - `/gcf-code-review` in a feature-branch repo shows the confirmation.

  Then the same in Codex with `$gcf-code-review`.
- [ ] **Step 4: Ask the user** before `git push origin main`.
