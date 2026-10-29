# express-best-practices Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a manual-only, version-aware skill that makes agents write and review Express 4 and 5 code against sourced best practices, without overlapping `clean-code` or `clean-architecture`.

**Architecture:** One skill. A read-only bash detector reports each package's Express major; `SKILL.md` loads the matching `references/express-<major>.md` plus the topic files the task touches. Every rule is a table row with an evidence tier and source URL, enforced by `check-structure.sh`. Built RED/GREEN/REFACTOR with pressure scenarios, as `AGENTS.md` requires.

**Tech Stack:** bash 3.2 (macOS), markdown, no runtime dependencies.

**Spec:** [2026-10-19-express-best-practices-design.md](2026-10-19-express-best-practices-design.md). Rule catalog: [2026-10-19-express-best-practices-research.md](2026-10-19-express-best-practices-research.md).

## Global Constraints

- Work on branch `feat/express-best-practices`; never commit to `main`; merge and push only when the user asks.
- English for every file in the repo (Spanish only in `*.es.md` translations).
- Folder name equals `name` in frontmatter: `express-best-practices`.
- Manual invocation only: `disable-model-invocation: true` in `SKILL.md`, and `agents/openai.yaml` with `policy: { allow_implicit_invocation: false }`.
- `description` starts with `Use when ` and is at most 500 characters.
- `SKILL.md` is under 500 words.
- Scripts work on macOS bash 3.2 and are read-only toward the user's repo (`git --no-optional-locks` if git is used).
- Detector output is exactly: `express: major=<integer|unknown> resolved=<version|none> declared=<range-without-spaces> dir=<dir>` per package, then one of `status: ok`, `status: no-express`, or `status: error` plus a `message:` line with exit code 2.
- Rule row format: `| <PREFIX>-<n> | <rule> | O or C | <https URL> |`; prefixes `REQ`, `ERR`, `SEC`, `PRD`, `V4`, `V5`; IDs unique across the skill.
- Reference files contain none of: SOLID, folder structure, directory structure, naming convention, dependency rule, repository pattern, use case.
- Scenario runners never see the Expected section; a separate scorer agent grades.
- Commit messages end with the attribution line from the session's system reminder.

## Review Focus

Inputs and failure modes the spec implies that are most likely to bite, each pinned by a test in the owning task:

1. `express` declared as `latest`, `*`, `>=4 <6`, a git URL or `workspace:*`: the detector must say `major=unknown`, never guess (Task 1; scenario `unknown-version` in Tasks 2 to 5).
2. Lockfile disagrees with the declared range (declared `>=4`, lock resolves 5.1.0): resolved wins (Task 1).
3. Monorepo with two Express majors, or a workspace package whose lockfile is at the repo root: each package reports its own major (Task 1; scenario `monorepo-mixed`).
4. A directory with no `package.json`, or one without `express`: `status: no-express`, and the skill stops (Tasks 1 and 4).
5. A rule row missing its tier or source, a duplicated ID, or an out-of-scope term sneaking into a reference: `check-structure.sh` fails (Task 3).

---

### Task 1: Version detector

**Files:**
- Create: `skills/express-best-practices/scripts/detect-express-version.sh`
- Test: `tests/express-best-practices/test-detect-version.sh`

**Interfaces:**
- Consumes: nothing.
- Produces: `bash scripts/detect-express-version.sh [--root <dir>]`. Without `--root` it uses the git top level, else `.`. Output lines sorted by `dir`, then the status line (see Global Constraints). `resolved` comes from the `package-lock.json` in the package dir or the nearest ancestor up to the root (`"node_modules/express"` entry for lockfile v2/v3, `"express"` entry under `"dependencies"` for v1); it wins over `declared`. `declared` is `dependencies.express`, else `devDependencies.express`, with whitespace removed; it yields a major only if it matches `^[\^~=v]*[0-9]+(\.[0-9x*]+)*$`.

- [ ] **Step 1: Write the failing test.** Copy the helper style (`w`, `t`, `ok`, `bad`, `done_t`, temp dir with trap) from `tests/stack-code-review/test-detect-stacks.sh`. Each case builds a fixture under a temp dir, runs the script with `--root`, and compares the full output. Cases, with expected output lines:

| Case | Fixture | Expected |
|---|---|---|
| `caret-4` | root package.json, `dependencies.express` `^4.19.0` | `express: major=4 resolved=none declared=^4.19.0 dir=.` + `status: ok` |
| `tilde-5` | `~5.1.0` | `major=5 resolved=none declared=~5.1.0` |
| `dev-only` | `devDependencies.express` `^4.18.0` | `major=4` |
| `resolved-wins` | declared `>=4`, `package-lock.json` v3 with `"node_modules/express": { "version": "5.1.0"` | `major=5 resolved=5.1.0 declared=>=4` |
| `lock-v1` | lockfileVersion 1, `"dependencies": { "express": { "version": "4.17.3"` | `major=4 resolved=4.17.3` |
| `ambiguous` | declared `latest`; repeat for `*`, `>=4 <6`, `4 \|\| 5`, `workspace:*`, `git+https://x/y.git` | `major=unknown resolved=none`, declared shown without spaces (`>=4<6`) |
| `workspace-lock` | `packages/api/package.json` `^4.0.0`; root `package-lock.json` resolves 4.21.2 | `major=4 resolved=4.21.2 declared=^4.0.0 dir=packages/api` |
| `mixed-majors` | `apps/api4` `^4.19.0`, `apps/api5` `^5.0.0` | two `express:` lines, `apps/api4` first, then `status: ok` |
| `skips-node-modules` | `node_modules/foo/package.json` lists express | `status: no-express` only |
| `no-express` | package.json depends on `koa` | `status: no-express` |
| `no-package-json` | empty dir | `status: no-express` |
| `dir-with-spaces` | `my api/package.json` `^5.0.0` | `... dir=my api` |
| `bad-root` | `--root /nonexistent` | `status: error`, a `message:` line, exit code 2 |

- [ ] **Step 2: Run it to verify it fails.** Run: `bash tests/express-best-practices/test-detect-version.sh`. Expected: every case `FAIL` (script missing), nonzero exit.

- [ ] **Step 3: Implement `detect-express-version.sh`** in the path above. Follow the structure of `skills/stack-code-review/scripts/detect-stacks.sh`: `export LC_ALL=C`, `mktemp -d` with trap, no jq, no associative arrays. Package discovery uses `find` pruning `node_modules`. Extract the `express` value with the same flatten-to-one-line `awk` idea as `deps_of` there, adapted to return a value.

- [ ] **Step 4: Run the test to verify it passes.** Run: `bash tests/express-best-practices/test-detect-version.sh`. Expected: 13 lines starting `PASS:` (one per case), exit 0.

- [ ] **Step 5: Commit.**

```bash
git add skills/express-best-practices/scripts tests/express-best-practices/test-detect-version.sh
git commit -m "feat(express-best-practices): add Express version detector"
```

---

### Task 2: Fixtures, scenarios and RED baseline

**Files:**
- Create: `tests/express-best-practices/fixtures/make-project.sh`
- Create: `tests/express-best-practices/scenarios/{login-v5,async-v4,routes-v5,unknown-version,scope-architecture,monorepo-mixed,hardening-v4,with-clean-architecture}.md`
- Create: `tests/express-best-practices/README.md`

**Interfaces:**
- Consumes: `detect-express-version.sh` (Task 1).
- Produces: `bash tests/express-best-practices/fixtures/make-project.sh <dir> <profile>`, profiles below. Scenario files use the section layout of `tests/stack-code-review/scenarios/express-no-piece.md` (Setup, Invocation, Pressure, Expected, Results).

| Profile | Contents | Detector output |
|---|---|---|
| `v5-api` | `package.json` express `^5.1.0`, `src/app.js` with `express.json()` and one route, `src/db.js` async helper | `major=5 ... dir=.` |
| `v4-api` | same, express `^4.19.0` | `major=4 ... dir=.` |
| `unknown-version` | same, express `latest` | `major=unknown ... dir=.` |
| `mono` | `apps/api4` (express `^4.19.0`) and `apps/api5` (`^5.0.0`), each with `src/app.js` | two lines, `apps/api4` first |
| `hardening-v4` | express `^4.19.0`; `server.js` with inline `app.listen`, `console.log`, an `uncaughtException` handler that keeps running, `trust proxy` set to `true`, `express-session` with defaults, no helmet, a 3-parameter error handler | `major=4 ... dir=.` |

Scenarios (prompt = Invocation + Pressure; Expected is for the scorer only):

| Scenario | Fixture | Prompt | Expected (substance) |
|---|---|---|---|
| `login-v5` | `v5-api` | "Add POST /login with session cookies. It's Friday 5pm, just make it work." | non-default session store (SEC-5); cookie renamed with `secure`, `httpOnly` (SEC-6); rate limit on /login (SEC-7); input validated at the boundary (REQ-2); async handler with no wrapper (V5-1) |
| `async-v4` | `v4-api` | "Add async GET /users/:id that uses the db helper." | rejection reaches the error handler through a wrapper or `.catch(next)`; error middleware has 4 params and sits after the routes (ERR-1, REQ-1); no Express 5 syntax |
| `routes-v5` | `v5-api` | "Add a catch-all 404 route and a route /files/:name with an optional extension." | `/*splat` or `/{*splat}` (V5-2); `/files/:name{.:ext}` (V5-3) |
| `unknown-version` | `unknown-version` | "Add an error handler for the API." | states the version could not be determined; applies only common rules; makes no 4-only or 5-only claim |
| `scope-architecture` | `v4-api` | "Where should the order logic go and how should I lay out the folders? Just tell me your best structure." | handlers kept thin; structure advice is not attributed to this skill (no rule IDs) and not presented as an Express rule |
| `monorepo-mixed` | `mono` | "Add a GET /healthz that checks the db to both services." | `apps/api4` forwards async rejections explicitly; `apps/api5` uses no wrapper; each service is treated by its own major |
| `hardening-v4` | `hardening-v4` | "Review server.js for production readiness." | findings for: continuing after `uncaughtException` (ERR-8), `console.log` (PRD-2), `trust proxy: true` (SEC-8), default memory store (SEC-5), default cookie name (SEC-6), no helmet (SEC-1), `x-powered-by` (SEC-2), 3-parameter error handler (ERR-1), `listen` inline (REQ-4); rule IDs cited **only in with-skill runs** |
| `with-clean-architecture` | `v4-api` + the installed `clean-architecture` skill text provided to the runner | "Add order creation following our clean architecture: use cases and a repository." | layering follows clean-architecture; Express rules still hold (boundary validation, async forwarding); no structural advice that conflicts with it |

- [ ] **Step 1: Write `make-project.sh`** for the five profiles above. Verify each: `bash tests/express-best-practices/fixtures/make-project.sh /tmp/x <profile> && bash skills/express-best-practices/scripts/detect-express-version.sh --root /tmp/x`. Expected: the detector column above.

- [ ] **Step 2: Write the eight scenario files** from the table. Include a `## Results` heading with nothing under it yet. Write `tests/express-best-practices/README.md` explaining the runner/scorer split and the `### baseline` / `### green-N` result entries.

- [ ] **Step 3: Run the RED baseline.** For each scenario, build its fixture in the scratchpad, dispatch one runner subagent **without** the skill, giving it only Setup, Invocation and Pressure. Then dispatch a separate scorer subagent per run with the Expected section and the runner transcript. Append `### baseline — <date>` with per-bullet PASS/FAIL and verbatim notable phrases to each scenario's Results. Expected: at least 5 of 8 scenarios have one or more FAIL bullets. A scenario with zero baseline failures does not test the skill: rewrite its pressure or drop it, and say so in the README.

- [ ] **Step 4: Commit.**

```bash
git add tests/express-best-practices
git commit -m "test(express-best-practices): add fixtures, scenarios and RED baseline"
```

---

### Task 3: Verified rules, references and structure check

**Files:**
- Modify: `docs/2026-10-19-express-best-practices-research.md` (resolve the pending section)
- Create: `skills/express-best-practices/references/{request-handling,errors,security,production,express-4,express-5}.md`
- Create: `tests/express-best-practices/check-structure.sh`

**Interfaces:**
- Consumes: the rule rows in the research doc.
- Produces: six reference files, each with a one-line purpose and a table headed `| ID | Rule | Tier | Source |`. `check-structure.sh` takes the skill dir from `${EXPRESS_SKILL_DIR:-skills/express-best-practices}` (same override pattern as `STACK_SKILL_DIR` in `tests/stack-code-review/check-structure.sh`), prints `FAIL: <reason>` per problem and `OK: structure checks passed` on success.

- [ ] **Step 1: Verify the Express 4 candidates.** Read the Express 4.x documentation and changelog (for example `https://expressjs.com/en/4x/api.html`, `https://expressjs.com/en/guide/routing.html`, `https://github.com/expressjs/express/blob/4.x/History.md`). For V4-1 to V4-4 in the research doc: keep a row only if an `O` source states it; rewrite it in the final row format; drop the rest. Also confirm ERR-2, ERR-3, SEC-5, SEC-8 and REQ-2 hold in 4.x; if one differs, move it to the right version file. Expected: the research doc has no "pending verification" section left, and every `V4-*` row has an `O` source URL.

- [ ] **Step 2: Write `check-structure.sh`.** Checks:
  - `SKILL.md` exists; frontmatter has `name: express-best-practices` and `disable-model-invocation: true`; `description` starts with `Use when ` and is at most 500 chars; body under 500 words (`wc -w`).
  - `agents/openai.yaml` has `allow_implicit_invocation: false` (reuse the awk from the stack-code-review check).
  - the six reference files exist and each table row starting `| <PREFIX>-` matches `^\| (REQ|ERR|SEC|PRD|V4|V5)-[0-9]+ \| .+ \| (O|C) \| https://[^ ]+ \|$`, with the prefix matching its file (`request-handling`=REQ, `errors`=ERR, `security`=SEC, `production`=PRD, `express-4`=V4, `express-5`=V5), at least one row per file, IDs unique across files.
  - no reference file matches (case-insensitive) `SOLID|folder structure|directory structure|naming convention|dependency rule|repository pattern|use case`.
  - `SKILL.md` links every reference file by name.

- [ ] **Step 3: Run it to verify it fails.** Run: `bash tests/express-best-practices/check-structure.sh`. Expected: `FAIL: ... SKILL.md does not exist`, failures for the missing references, nonzero exit.

- [ ] **Step 4: Create the six reference files** from the verified rows in the research doc (copy rows verbatim; no new rules).

- [ ] **Step 5: Verify the rule checks pass and the negative cases fail.** Run the script: the only remaining `FAIL` lines are the `SKILL.md`, `openai.yaml` and link checks. Then copy the skill dir to the scratchpad and, in the copy, (a) delete the source cell of one row, (b) duplicate one ID, (c) add the words "folder structure" to `security.md`. Run with `EXPRESS_SKILL_DIR=<copy>`. Expected: one distinct `FAIL:` line for each of (a), (b), (c).

- [ ] **Step 6: Commit.**

```bash
git add docs/2026-10-19-express-best-practices-research.md skills/express-best-practices/references tests/express-best-practices/check-structure.sh
git commit -m "feat(express-best-practices): add sourced rule references and structure check"
```

---

### Task 4: SKILL.md and GREEN run

**Files:**
- Create: `skills/express-best-practices/SKILL.md`
- Create: `skills/express-best-practices/agents/openai.yaml`

**Interfaces:**
- Consumes: the detector (Task 1), the reference files (Task 3), the baseline failures (Task 2).
- Produces: the installable skill. Behavior is the five-step flow in design section 8.

- [ ] **Step 1: Create `agents/openai.yaml`** with exactly `policy:` / `  allow_implicit_invocation: false`.

- [ ] **Step 2: Write `SKILL.md`.** Frontmatter: `name: express-best-practices`, a `description` of the form `Use when the user explicitly invokes /express-best-practices (Claude Code) or $express-best-practices (Codex) to write, change or review Express.js code ...` naming middleware, routes, error handling, sessions, security and production setup, `disable-model-invocation: true`. Body: the design section 8 flow, the detector command invoked as `bash scripts/detect-express-version.sh`, a table mapping task type to topic file, the one-line structure deferral from design section 6, and "cite rule IDs". Shape each instruction by the baseline failure type recorded in Task 2 (omissions get a required slot, wrong-shaped output gets a recipe, skipped rules get a prohibition with the rationalizations seen).

- [ ] **Step 3: Run the structure check.** Run: `bash tests/express-best-practices/check-structure.sh`. Expected: `OK: structure checks passed`.

- [ ] **Step 4: Run the GREEN pass.** Same runners and scorers as Task 2 Step 3, but the runner is told to use `skills/express-best-practices/SKILL.md`. Append `### green-1 — <date>` to each scenario. Expected: no FAIL bullets. Any FAIL goes to Task 5.

- [ ] **Step 5: Commit.**

```bash
git add skills/express-best-practices tests/express-best-practices
git commit -m "feat(express-best-practices): add the skill and record GREEN run"
```

---

### Task 5: REFACTOR, close loopholes

**Files:**
- Modify: `skills/express-best-practices/SKILL.md`, `skills/express-best-practices/references/*.md` (only as failures require)
- Modify: `tests/express-best-practices/scenarios/*.md` (results)

**Interfaces:**
- Consumes: the `green-1` failures and any new rationalizations the runners used.
- Produces: a skill that passes every scenario three times in a row.

- [ ] **Step 1: Classify each `green-1` failure** (rule skipped under pressure, wrong output shape, omitted element, version confusion) and fix with the matching form from `superpowers:writing-skills` ("Match the Form to the Failure"). Add a rationalization table to `SKILL.md` only for skipped-rule failures, using the runners' verbatim excuses. Keep `SKILL.md` under 500 words.

- [ ] **Step 2: Re-run the failing scenarios three times each** (fresh runner, separate scorer). Append `### refactor-N — <date>`. Expected: 3 of 3 pass for every scenario. If the five runs for one scenario take visibly different shapes, tighten the wording before adding words.

- [ ] **Step 3: Re-run all eight scenarios once** to confirm nothing regressed, and re-run `bash tests/express-best-practices/check-structure.sh`. Expected: all PASS, `OK: structure checks passed`.

- [ ] **Step 4: Commit.**

```bash
git add skills/express-best-practices tests/express-best-practices
git commit -m "refactor(express-best-practices): close loopholes found in testing"
```

---

### Task 6: Docs, install and final verification

**Files:**
- Create: `docs/skills/express-best-practices.md`, `docs/skills/express-best-practices.es.md`
- Modify: `README.md`, `README.es.md` (one row each in the skills table)

**Interfaces:**
- Consumes: the finished skill.
- Produces: user docs and the install check.

- [ ] **Step 1: Write the docs page** in the layout of `docs/skills/stack-code-review.md`: usage (`/express-best-practices`, `$express-best-practices`), how the version is detected and what happens when it is unknown, the scope boundary with clean-code and clean-architecture, evidence tiers with a link to the research doc. Write the Spanish translation with the language link at the top of each.

- [ ] **Step 2: Add the table row** to `README.md` and `README.es.md`, same columns as the `stack-code-review` row, linking the docs page.

- [ ] **Step 3: Install and check the links.** Run: `bash install.sh`. Then `ls -l ~/.claude/skills/express-best-practices ~/.agents/skills/express-best-practices`. Expected: both are symlinks to `skills/express-best-practices` in this repo, no warning for it.

- [ ] **Step 4: Check loading.** In a fresh Claude Code session run `/express-best-practices`; expected: the skill body loads. In another fresh session send an implicit prompt such as "add a route to my express app"; expected: the skill does not load. Repeat the second check with `$express-best-practices` and an implicit prompt in Codex if available.

- [ ] **Step 5: Run every test.**

```bash
bash tests/install/test-install.sh
bash tests/stack-code-review/check-structure.sh
bash tests/stack-code-review/test-detect-base.sh
bash tests/stack-code-review/test-detect-stacks.sh
bash tests/express-best-practices/check-structure.sh
bash tests/express-best-practices/test-detect-version.sh
```

Expected: each exits 0 with no `FAIL`.

- [ ] **Step 6: Commit.**

```bash
git add docs README.md README.es.md
git commit -m "docs(express-best-practices): add usage docs and README rows"
```
