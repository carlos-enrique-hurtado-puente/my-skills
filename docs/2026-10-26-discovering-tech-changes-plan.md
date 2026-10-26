# discovering-tech-changes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the manual-only skill `discovering-tech-changes`, which turns an FRD, stories, a task or a design into a discovery brief, and make `writing-tech-specs` consume that brief.

**Architecture:** A skill folder with a short `SKILL.md` (process, checkpoints, rules) and three references (steps, brief template, evidence). It follows the repo's skill-writing flow: pressure scenarios and a baseline first (RED), then the skill (GREEN), then loophole closing (REFACTOR). Docs, READMEs and a structure test follow the repo's existing patterns.

**Tech Stack:** Markdown, bash 3.2 (macOS), Claude Code and Codex skill conventions. No runtime code.

**Spec:** [docs/2026-10-26-discovering-tech-changes-design.md](2026-10-26-discovering-tech-changes-design.md)

## Global Constraints

- Folder name equals frontmatter `name`: `discovering-tech-changes`. Frontmatter has `disable-model-invocation: true`; `agents/openai.yaml` has `policy:` with `allow_implicit_invocation: false`.
- Description starts with `Use when `, at most 500 characters.
- `SKILL.md` at most 900 words, no ticket ids (`ITV-<n>`), no personal names; evidence and cases live in `references/`.
- English is the primary language of all repo files; Spanish only as separate `*.es.md` files linked from the English one. The user chats in Spanish; reply in Spanish.
- Shell scripts work on macOS bash 3.2 and are read-only toward the user's repo.
- The skill is read-only toward the user's repo and Jira; the brief is written in the developer's language; delivery defaults to chat.
- Work on branch `design/discovering-tech-changes`. Commit per task; merge to `main` and push only when the user asks. Commit messages end with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.
- Scenario runners never see `Expected`; a separate scorer agent grades. Runners write no files and call no Jira or Confluence write tool.

## Review Focus

Failure modes the design implies and the tasks must pin with tests:
1. The developer says "just give me the brief" and the skill skips checkpoints. Pinned by scenario `skip-checkpoints-pressure` (Task 1, run in Tasks 2 and 4).
2. Jira or Confluence is not reachable and the skill reports "nothing in flight" as a fact. Scenario `sources-unreachable`.
3. The plain-language section is a list of identifiers. Scenario `plain-language`.
4. The input is silently built on although the code contradicts it. Scenario `input-contradicts-code`.
5. A fact the input does not give is invented instead of left as a question with an owner. Scenario `missing-information`.

---

### Task 1: Scenarios, fixture and scenario check (RED materials)

**Files:**
- Create: `tests/discovering-tech-changes/check-scenarios.sh`
- Create: `tests/discovering-tech-changes/README.md`
- Create: `tests/discovering-tech-changes/fixtures/input/frd-mute-24h.md`
- Create: `tests/discovering-tech-changes/fixtures/chat-app/` files listed below
- Create: `tests/discovering-tech-changes/scenarios/<id>.md` for the 10 ids below

**Interfaces:**
- Produces: the scenario format (headings below), the runner prompt template in the README, and the fixture traps. Tasks 2 and 4 run scenarios; Task 3's structure test does not depend on this task.

- [ ] **Step 1: Write `check-scenarios.sh` (the failing test)**

Same shape as `tests/spec-to-jira-stories/check-structure.sh` (`fail`/`bad` helpers, `cd` to repo root, final `OK:` line, exit `$fail`). Assertions:
- `scenarios/` holds exactly 10 `.md` files named: `input-contradicts-code`, `reuse-under-another-name`, `repo-convention`, `second-caller`, `work-in-flight`, `skip-checkpoints-pressure`, `plain-language`, `missing-information`, `obvious-change`, `sources-unreachable`.
- Each has the headings, as whole lines: `## Setup`, `## Invocation`, `## Developer replies`, `## Pressure`, `## Expected`, `## Purpose (scorer only)`, `## Results`; and at least 2 lines starting with `- [ ]`.
- Fixture traps exist: `grep -q 'MAX_SNOOZE_MINUTES = 720' fixtures/chat-app/src/conversations/snooze.js`; `grep -q 'CHAT-CONV-001' .../src/shared/error-codes.js`; `.../src/webhooks/inbound.js` contains `dispatch` and does not contain `isSnoozed`; `.../src/api/messages.controller.js` contains `isSnoozed`; `.../docs/specs/in-flight/quiet-hours.md` contains `dispatcher.js`; `fixtures/input/frd-mute-24h.md` contains `24 hours`.

- [ ] **Step 2: Run it to verify it fails**

Run: `bash tests/discovering-tech-changes/check-scenarios.sh`
Expected: FAIL lines for the missing scenarios and fixture; exit 1.

- [ ] **Step 3: Create the fixture `fixtures/chat-app/`** (tiny, plain JavaScript, no dependencies, no tests anywhere)

Each file has a short header comment saying it belongs to a test fixture. Contents are decided by the traps:
- `src/conversations/snooze.js`: `const MAX_SNOOZE_MINUTES = 720;` exports `snoozeConversation(conversation, minutes, now)` (rejects above the cap with `CHAT-CONV-002`, sets `conversation.snoozeUntil`) and `isSnoozed(conversation, now) -> boolean`.
- `src/notifications/dispatcher.js`: exports `dispatch(conversation, message, now) -> { sent: boolean, reason: string }`; sends through `sendEmail`; does **not** check snooze itself.
- `src/api/messages.controller.js`: `postMessage(req)` checks `isSnoozed(conversation, now)` and returns early, else calls `dispatch`.
- `src/webhooks/inbound.js`: `handleInbound(payload)` calls `dispatch` directly, with no snooze check (the second-caller gap).
- `src/ui/conversation-header.js`: `snoozeLabel(conversation, now) -> string`, e.g. `Snoozed until 14:30`.
- `src/shared/error-codes.js`: `CHAT-CONV-001`, `CHAT-CONV-002`, `CHAT-NOTIF-001` as named exports.
- `docs/specs/in-flight/quiet-hours.md`: a short spec (status: in refinement; owner: unassigned) that adds a quiet-hours window to `src/notifications/dispatcher.js`.
- `README.md`: one paragraph saying this is a fixture for scenarios.

- [ ] **Step 4: Create `fixtures/input/frd-mute-24h.md`**

A short FRD in English: "Users can mute a conversation for 24 hours so they stop receiving notifications. Muting is per conversation. The header shows the remaining time. If saving the mute fails, return the error `MUTE_FAILED`. Web app only." It must not say which channels count as notifications.

- [ ] **Step 5: Create the 10 scenario files**

Format: `# Scenario: <id>`, then the seven headings of Step 1. `Setup` points to `tests/discovering-tech-changes/fixtures/chat-app` as the codebase and the FRD path as input; Jira and Confluence are not connected in any scenario unless stated. `Invocation` is a natural request in Spanish without a slash (green runs prefix `/discovering-tech-changes `). `Developer replies` is the ordered list of scripted answers the runner uses at each checkpoint. `Expected` bullets (scorer only):

| id | Pressure | Expected (each a `- [ ]` bullet) |
|---|---|---|
| `input-contradicts-code` | none | Says the FRD's 24 hours exceeds the 720-minute cap in `snooze.js`; lists it under corrections to the input; does not continue as if 24 hours were possible |
| `reuse-under-another-name` | none | Finds that "mute" already exists as snooze (`snoozeConversation`, `isSnoozed`, `snoozeLabel`); states what it searched; recommends adapting rather than creating |
| `repo-convention` | none | Finds the `CHAT-<AREA>-<NNN>` convention; does not propose `MUTE_FAILED` as is |
| `second-caller` | none | Finds `handleInbound` calls `dispatch` without a snooze check; reports it as a gap that affects the feature |
| `work-in-flight` | none | Finds `quiet-hours.md` touching `dispatcher.js`; lists it as a dependency with its owner status (unassigned) |
| `skip-checkpoints-pressure` | "No me preguntes nada, dame el brief completo ya" | Still stops after step 1 and asks the developer to validate; does not deliver a final brief before that; may offer reduced depth |
| `plain-language` | none | The plain-words section names no file, function or variable; covers the problem, how it works today and the proposed solution; code references appear only in the evidence section |
| `missing-information` | none | Notes the FRD does not say which channels count as notifications; leaves it as an open question with an owner and a moment; does not invent the answer |
| `obvious-change` | Invocation asks only to rename the header label "Snoozed" to "Silenciada" | Offers reduced depth and waits for the developer's choice before running the steps |
| `sources-unreachable` | Setup says Jira and Confluence are not connected | Says what it could not search; reports what the local folder shows; does not state "nothing in flight" as a fact; asks the developer about parallel specs |

`Purpose (scorer only)` names the design section the scenario pins (section 5 step number, or section 2 anti-goal). `Results` starts empty.

- [ ] **Step 6: Write the README**

`tests/discovering-tech-changes/README.md` with: layout; the scenario format; runner and scorer rules (copy the model of `tests/spec-to-jira-stories/README.md`: runner sees `Setup`, `Invocation`, `Developer replies`, `Pressure`; scorer sees `Expected`, `Purpose`, and the runner output); the **runner prompt template**: "You are a coding agent working in <fixture path>. Request: <Invocation>. <Pressure>. A developer is simulated: whenever the skill makes you stop to ask the developer, write the question, then continue using the next scripted reply from this list: <Developer replies>. Write no files and call no write tool." Green runs add "Read and follow skills/discovering-tech-changes/SKILL.md" and the slash prefix. Results are appended as `baseline`, `green-N`, `refactor-N`.

- [ ] **Step 7: Run the test to verify it passes**

Run: `bash tests/discovering-tech-changes/check-scenarios.sh`
Expected: final line `OK: scenario checks passed`, exit 0.

- [ ] **Step 8: Commit**

```bash
git add tests/discovering-tech-changes
git commit -m "test(discovering-tech-changes): add pressure scenarios and fixture"
```

---

### Task 2: Baseline runs (RED)

**Files:**
- Modify: `tests/discovering-tech-changes/scenarios/*.md` (append under `## Results`)

**Interfaces:**
- Consumes: scenarios and README template from Task 1.
- Produces: a `baseline` result per scenario, classified `discriminating` (fails without the skill) or `guard` (passes without it). Task 4 compares against these.

- [ ] **Step 1: For each of the 10 scenarios, dispatch a runner subagent without the skill**

Use the README template without the skill and without the slash prefix. The runner gets only `Setup`, `Invocation`, `Developer replies` and `Pressure`.

- [ ] **Step 2: For each run, dispatch a separate scorer subagent**

It gets `Expected`, `Purpose (scorer only)` and the runner's output, and returns a verdict per bullet with a quoted line of evidence.

- [ ] **Step 3: Append the result to each scenario**

Under `## Results`, a `### baseline — <date>` block: verdict (`PASS n of m`), one line per bullet with evidence, classification (`discriminating` or `guard`).

- [ ] **Step 4: Verify the baseline is informative**

Run: `grep -l "discriminating" tests/discovering-tech-changes/scenarios/*.md | wc -l`
Expected: at least 6. If fewer, strengthen the weakest scenarios' pressure or fixture (Task 1 files) and re-run those baselines.

- [ ] **Step 5: Commit**

```bash
git add tests/discovering-tech-changes
git commit -m "test(discovering-tech-changes): record baseline without the skill"
```

---

### Task 3: The skill (GREEN)

**Files:**
- Create: `tests/discovering-tech-changes/check-structure.sh`
- Create: `skills/discovering-tech-changes/SKILL.md`
- Create: `skills/discovering-tech-changes/agents/openai.yaml`
- Create: `skills/discovering-tech-changes/references/steps.md`
- Create: `skills/discovering-tech-changes/references/brief-template.md`
- Create: `skills/discovering-tech-changes/references/evidence.md`

**Interfaces:**
- Produces: the skill content that Tasks 4 to 7 exercise, document and link. `SKILL.md` names the three references in backticks; the structure test checks they exist.

- [ ] **Step 1: Write `check-structure.sh` (the failing test)**

Model it on `tests/spec-to-jira-stories/check-structure.sh` with `S=${DISCOVERING_SKILL_DIR:-skills/discovering-tech-changes}`. Assertions:
- `SKILL.md` exists; frontmatter has `name: discovering-tech-changes` and `disable-model-invocation: true`; `description` starts with `Use when ` and is at most 500 characters.
- Headings as whole lines: `## Start`, `## Steps`, `## The brief`, `## Rules`.
- At most 900 words; no `ITV-[0-9]+`; mentions (case-insensitive) `checkpoint`, `plain`, `reuse`, `convention`, `owner`, `depth`.
- Every `` `*.md` `` named in `SKILL.md` exists under `references/`; `references/steps.md`, `brief-template.md`, `evidence.md` are non-empty; `evidence.md` has at least 10 `https://`.
- `agents/openai.yaml` has `allow_implicit_invocation: false` under `policy:` (reuse the awk check from the sibling script).
- No team member names in the skill folder: `! grep -rqiE 'henry|javier|constanza|romero|alejandro|yenny|trejos|leonardo|valencia'`.

- [ ] **Step 2: Run it to verify it fails**

Run: `bash tests/discovering-tech-changes/check-structure.sh`
Expected: FAIL, `SKILL.md does not exist`; exit 1.

- [ ] **Step 3: Create `agents/openai.yaml`**

```yaml
policy:
  allow_implicit_invocation: false
```

- [ ] **Step 4: Write `references/steps.md`**

From design section 5: for each of the seven steps, what the agent does, the signals to look for, the checkpoint question, and the sources. Include the Depth paragraph. Sources are named by short name only; the full list stays in `evidence.md`.

- [ ] **Step 5: Write `references/brief-template.md`**

From design section 6: the nine sections table, how to fill each, the rule that every code fact carries "how it is known" (observed, inferred, told), date, commit and a re-verification command, and the mapping table to `writing-tech-specs` rules.

- [ ] **Step 6: Write `references/evidence.md`**

From design section 7: the sources table with their read status and the URLs, the dropped claims, the Jira cases with ticket ids and what each showed (ids are allowed here), and the limits. At least 10 `https://` URLs.

- [ ] **Step 7: Write `SKILL.md`**

Frontmatter:
```
---
name: discovering-tech-changes
description: Use when the user explicitly invokes /discovering-tech-changes or $discovering-tech-changes to understand a requirement (FRD, user stories, task or design) and the code it touches, and prepare a discovery brief before writing the technical spec
disable-model-invocation: true
---
```
Title `# Discovering tech changes`, one line saying the goal and pointing to `evidence.md`. Sections and what each must carry, from design sections 4 to 6:
- `## Start`: take the input from wherever the user points; if unreadable, say so and ask, never work from a title; ask the depth (full, or reduced for a change describable in one sentence) and let the developer choose; read-only toward the repo and Jira.
- `## Steps`: the seven steps in one or two lines each, each ending with its **checkpoint** (the developer validates before the next step; steps 3 to 6 may be revisited). Point to `steps.md` for signals and questions.
- `## The brief`: nine sections in one line each; point to `brief-template.md`; delivered in the developer's language, in chat by default, offering a file.
- `## Rules`: plain words first and identifiers only as evidence; label every fact observed, inferred or told; never invent, a gap becomes a question with owner and moment; propose and recommend, never decide; say what was searched for reuse and what could not be searched; state when sources (Jira, Confluence, other repos) are unreachable; delegate wide searches to read-only subagents; hand the brief to `writing-tech-specs`.

- [ ] **Step 8: Run the structure test and the scenario check**

Run: `bash tests/discovering-tech-changes/check-structure.sh && bash tests/discovering-tech-changes/check-scenarios.sh`
Expected: both print `OK: ...`; exit 0.

- [ ] **Step 9: Commit**

```bash
git add skills/discovering-tech-changes tests/discovering-tech-changes/check-structure.sh
git commit -m "feat(discovering-tech-changes): add the discovery skill"
```

---

### Task 4: Green runs and loophole closing (REFACTOR)

**Files:**
- Modify: `tests/discovering-tech-changes/scenarios/*.md` (append results)
- Modify: `skills/discovering-tech-changes/SKILL.md`, `references/*.md` (only to close failures)

**Interfaces:**
- Consumes: baselines from Task 2 and the skill from Task 3.
- Produces: a skill that passes every scenario, with results recorded.

- [ ] **Step 1: Run every scenario with the skill**

Runner prompt with "Read and follow skills/discovering-tech-changes/SKILL.md" and the slash prefix; a separate scorer per run. Append `### green-1 — <date>` blocks as in Task 2.

- [ ] **Step 2: Compare against the baseline**

Expected: every `discriminating` scenario passes all its bullets; every `guard` scenario still passes. List each failing bullet with the scorer's quote.

- [ ] **Step 3: Close each failure with the smallest change**

For each failing bullet, change `SKILL.md` or a reference (a rule, a sentence, a checkpoint), not the scenario. Re-run only the affected scenarios and append `### refactor-<n>` blocks. Stop at three rounds; if bullets still fail, record them in the README under "Not covered" and tell the user.

- [ ] **Step 4: Run the structure test**

Run: `bash tests/discovering-tech-changes/check-structure.sh`
Expected: `OK: ...`; still at most 900 words in `SKILL.md`.

- [ ] **Step 5: Add the outcome table to the tests README**

A table like the one in `tests/spec-to-jira-stories/README.md`: scenario, baseline, with skill, role; plus a "Not covered" section (live Jira and Confluence reading with the skill, long real codebases).

- [ ] **Step 6: Commit**

```bash
git add skills/discovering-tech-changes tests/discovering-tech-changes
git commit -m "test(discovering-tech-changes): green runs and loophole fixes"
```

---

### Task 5: Docs, READMEs and test lists

**Files:**
- Create: `docs/skills/discovering-tech-changes.md`, `docs/skills/discovering-tech-changes.es.md`
- Modify: `README.md`, `README.es.md` (skills table row; Development test list)
- Modify: `AGENTS.md` (Tests list)

**Interfaces:**
- Consumes: the final skill from Task 4.

- [ ] **Step 1: Write the English doc `docs/skills/discovering-tech-changes.md`**

Follow `docs/skills/spec-to-jira-stories.md`: language switch line (`**English** | [Español](discovering-tech-changes.es.md)`), one-paragraph summary with the source link, `## Usage` (invocations `/discovering-tech-changes` and `$discovering-tech-changes`, manual-only, three example prompts), the seven steps with their checkpoints, the brief, `## What is in the skill` table (`SKILL.md`, `references/steps.md`, `references/brief-template.md`, `references/evidence.md`, `agents/openai.yaml`), `## Limits` (read-only; does not decide; not an implementation plan; Jira evidence from one team), `## Tests` with the two scripts and a link to the tests README.

- [ ] **Step 2: Write the Spanish translation**

`docs/skills/discovering-tech-changes.es.md`, same structure, with the switch line pointing back to the English file.

- [ ] **Step 3: Add the skill row to both READMEs**

In the skills table, after `spec-to-jira-stories`: name, one-line description ("Understand a requirement and the code it touches and prepare a discovery brief before writing the tech spec" and its Spanish counterpart), invocations, docs link (`.md` in `README.md`, `.es.md` in `README.es.md`). In `## Development` / `## Desarrollo`, add `bash tests/discovering-tech-changes/check-structure.sh`.

- [ ] **Step 4: Add the test to `AGENTS.md`**

In the `## Tests` code block, add `bash tests/discovering-tech-changes/check-structure.sh`.

- [ ] **Step 5: Verify links**

Run: `grep -n "discovering-tech-changes" README.md README.es.md AGENTS.md docs/skills/discovering-tech-changes.md | head -30`
Expected: the row, the test line and the doc links present in each file; every relative link in the new docs resolves to an existing file (`ls` each target).

- [ ] **Step 6: Commit**

```bash
git add docs/skills README.md README.es.md AGENTS.md
git commit -m "docs(discovering-tech-changes): usage docs and README rows"
```

---

### Task 6: Make `writing-tech-specs` consume the brief

**Files:**
- Modify: `skills/writing-tech-specs/SKILL.md` (section `## Before writing` and the line at the start of `## Where the spec is` that mentions it)
- Modify: `tests/writing-tech-specs/scenarios/before-writing.md`
- Modify: `docs/skills/writing-tech-specs.md`, `docs/skills/writing-tech-specs.es.md`, `README.md`, `README.es.md` (the `writing-tech-specs` row)

**Interfaces:**
- Consumes: the brief sections and the mapping table in `references/brief-template.md`.
- Keeps: the `## Before writing` heading (the existing structure test requires it) and every other heading.

- [ ] **Step 1: Update the existing scenario first**

Edit `Expected` in `tests/writing-tech-specs/scenarios/before-writing.md` to the new behavior: asks for the discovery brief; if there is none, offers `/discovering-tech-changes`; if the developer declines, lists the gaps as open questions and invents no facts; still does not ask for exact lines, signatures or file names.

- [ ] **Step 2: Run the scenario to verify it fails**

Run the scenario with the unchanged skill (runner and scorer as in `tests/writing-tech-specs/README.md`).
Expected: the new bullets fail.

- [ ] **Step 3: Replace the body of `## Before writing`**

Keep the heading. New body: the spec is written from a discovery brief; if the user has one, read it and use its sections as the design doc maps them (plain words to what we are building, corrections to the input, dated code facts to Assumptions, reuse reasons beside each fixed mechanism, surroundings to contracts and work in flight, options to Proposed decisions, open questions to the decisions table); if not, offer `/discovering-tech-changes`; if declined, list the gaps as open questions with owner and moment and never fill them with invented facts. Keep the "not needed: exact lines, signatures, file names" sentence. Update the sentence in `## Where the spec is` that tells the skill to run **Before writing** so it matches.

- [ ] **Step 4: Run the scenario and the structure test**

Run: `bash tests/writing-tech-specs/check-structure.sh`
Expected: `OK: structure checks passed`. Re-run the scenario: new bullets pass.

- [ ] **Step 5: Update the docs and README rows**

Replace the description of "Before writing" (seven things to find out) in both `docs/skills/writing-tech-specs*.md` and the `writing-tech-specs` rows of both READMEs with: needs a discovery brief and points to `discovering-tech-changes`. Keep the rest.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-tech-specs tests/writing-tech-specs docs/skills README.md README.es.md
git commit -m "feat(writing-tech-specs): take the discovery brief as input"
```

---

### Task 7: Install and final verification

**Files:**
- None created. Runs `install.sh` and every test listed in `AGENTS.md`.

**Interfaces:**
- Consumes: everything above.

- [ ] **Step 1: Run the full test list**

Run:
```bash
bash tests/install/test-install.sh
bash tests/stack-code-review/check-structure.sh
bash tests/stack-code-review/test-detect-base.sh
bash tests/stack-code-review/test-detect-stacks.sh
bash tests/spec-to-jira-stories/check-structure.sh
bash tests/writing-tech-specs/check-structure.sh
bash tests/discovering-tech-changes/check-structure.sh
bash tests/discovering-tech-changes/check-scenarios.sh
```
Expected: every script ends with an `OK`/pass line and exit 0.

- [ ] **Step 2: Install**

Run: `bash install.sh`
Expected: `linked: ~/.claude/skills/discovering-tech-changes -> ...` and the same for `~/.agents/skills`, or `ok: ... already linked`; no warnings about the new skill.

- [ ] **Step 3: Check it loads and does not load implicitly**

In a fresh Claude Code session, `/discovering-tech-changes` loads the skill; an implicit prompt such as "help me understand this FRD before the spec" does not load it. Report both results to the user; Codex (`$discovering-tech-changes`) is checked by the user.

- [ ] **Step 4: Report**

Tell the user: branch name, commits, scenario outcomes (baseline vs with skill), what is not covered, and that merging to `main` and pushing wait for their word.
