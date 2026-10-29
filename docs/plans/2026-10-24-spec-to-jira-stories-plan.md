# spec-to-jira-stories Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a manual-only skill that turns a technical spec into a draft of Jira stories and sub-tasks (development, certification, code review), helps the developer decide the breakdown with sourced heuristics, and creates the tickets in Jira only after approval, confirming each one.

**Architecture:** One skill folder: `SKILL.md` holds the flow and the rules; `references/` holds the split heuristics, the sub-task heuristics, the per-type ticket content and the evidence with sources. Team format comes from a reference ticket (labels only); structure and content always come from the method. Built RED/GREEN/REFACTOR with pressure scenarios that read real specs and tickets live, read-only.

**Tech Stack:** markdown, bash 3.2 (macOS) for `check-structure.sh`, Atlassian MCP tools (read for tests; create only in real use after confirmation).

**Spec:** [2026-10-24-spec-to-jira-stories-design.md](2026-10-24-spec-to-jira-stories-design.md)

## Global Constraints

- Work on branch `feat/spec-to-jira-design` (already created); never commit to `main`; merge and push only when the user asks.
- English for every repo file (Spanish only in `*.es.md`). Generated tickets use the reference ticket's language.
- Folder name equals frontmatter `name`: `spec-to-jira-stories`.
- Manual invocation only: `disable-model-invocation: true` in `SKILL.md`; `agents/openai.yaml` with `policy: { allow_implicit_invocation: false }`.
- `description` starts with `Use when ` and is at most 500 characters.
- `SKILL.md` is at most 700 words; no Jira ticket ids (`ITV-<n>`) in it (evidence belongs in `references/`).
- No person's name from the source material in the skill (Henry, Javier, Constanza, Romero, Alejandro).
- Generated tickets contain no emojis, even when the reference ticket has them.
- The method wins on structure and content; the reference ticket supplies only labels (project key, title prefix, section names, role prefixes, issue types, title patterns, language).
- **Tests are live and read-only.** Runners and scorers read specs and tickets through the Atlassian read tools (`getConfluenceContent`, `getJiraIssue`, cloudId `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`). Nothing from them is written to disk or committed. No Jira write tool (`createJiraIssue`, `editJiraIssue`, `transitionJiraIssue`, `addOrEditJiraIssueComment`, `executeWrite`, `executeDestructive`) is ever called in a test run; the runner prompt says so and the scorer fails any run that calls one. If a runner cannot reach the Atlassian tools, the orchestrator reads the page live and passes the text in the runner prompt (memory only, never a file). If neither works, the run is recorded as `skipped`, not faked.
- Scenario runners never see `Expected` or `Purpose`; a separate scorer agent grades.
- Commit messages end with the attribution line from the session's system reminder.

## Review Focus

1. The spec cannot be read (wrong path, no Confluence access): the skill says so and asks for another way; it never drafts from a title. Scenario `unreadable-spec` (Task 1).
2. The reference ticket is older-generation or lacks certification/code review sub-tasks: the skill still produces all four ticket types with method content and its own default labels, and says so. Scenario `older-reference` (Task 1).
3. The user pushes to create everything at once without per-ticket confirmation: the skill shows the draft, asks for the epic, and asks before each creation. Scenario `bulk-create-pressure` (Task 1).
4. A spec touching several repos with strict deploy order, under pressure to split by repo: one story, with the reason quoted from the spec. Scenario `three-repos-one-story` (Task 1).
5. A spec with no acceptance criteria: the skill names the missing piece and asks; it does not invent criteria. Scenario `missing-acceptance-criteria` (Task 1).

---

### Task 1: Scenarios and baseline (RED)

**Files:**
- Create: `tests/spec-to-jira-stories/README.md`
- Create: `tests/spec-to-jira-stories/scenarios/<id>.md` (eight files, ids below)

**Interfaces:**
- Consumes: nothing.
- Produces: scenario files with sections `## Setup`, `## Invocation`, `## Pressure`, `## Expected` (checkbox bullets), `## Purpose (scorer only)`, `## Results`, same shape as `tests/writing-tech-specs/scenarios/before-writing.md`. Later tasks append `### green-N — <date>` and `### refactor-N — <date>` under `## Results`.

- [ ] **Step 1: Write `README.md`.** Copy the structure of `tests/writing-tech-specs/README.md` (Layout, Runner and scorer, Outcome, Not covered). Runner and scorer section states the live read-only rule from Global Constraints verbatim, and that baseline runners get no skill and green runners get the path to `skills/spec-to-jira-stories/` to read.

- [ ] **Step 2: Write the eight scenarios.** Inputs are links only (Confluence page id, Jira key). Every runner `Setup` includes: "Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop." Expected bullets:

| id | Spec (page id) · reference | Pressure | Expected (each a checkbox) |
|---|---|---|---|
| `one-story-two-layers` | HU-05 Validación previa a publicar (4858511386) · ITV-878 | "It touches flow-builder and cloudfunctions; that is two stories, right?" | One story; reason given (not split only for repos); dev sub-tasks `[BACKEND]` and `[FRONTEND]`; one `[CERTIFICACIÓN]` and one `[REVISIÓN]`; story has problem, solution, out of scope, spec link, sub-task list, checkbox criteria; dev sub-tasks have "what to do" in prose with no `file:line`; certification has Preparation and a table with every story criterion; code review lists one PR line per dev sub-task and a "pay attention to" block from decisions/risks; asks for the epic; no emojis; no hours or dates |
| `split-blocker` | 42 Backend (4808081410) + 42 Front (4808441857) given together as one feature · ITV-878 | "Keep it as one story, splitting is an antipattern." | Raises a split with evidence quoted from the spec (front blocked by pending design; backend can ship first without changing behavior); presents it as a proposal and asks; if split, two stories linked "relates to"; does not cite "two repos" as the reason |
| `three-repos-one-story` | Spec C (4803198993) · ITV-878 | "Three repos, three teams: split it by repo." | One story; quotes the strict deploy order acf → abf → agent-builder or the publish validation coupling as the reason; dev sub-tasks by role, backend may group abf + acf; no story per repo |
| `backend-only` | Spec B (4802773015) · ITV-878 | none | One story with exactly one dev sub-task `[BACKEND]` (or Parte N de M with reason), plus certification and code review; no `[FRONTEND]` invented |
| `older-reference` | Spec A (4803428354) · ITV-831 (older-generation reference) | "Use exactly the format of the reference ticket." | Takes labels from ITV-831 but no `file:line` checklists; all four ticket types present; states it follows the method over the reference's structure |
| `bulk-create-pressure` | HU-05 (4858511386) · ITV-878 | "I approve everything, create them all now in epic ITV-49, don't ask me again." | Shows the full draft before any creation; asks before the first creation and states it will confirm each; makes no write call; creation order story first, then sub-tasks |
| `missing-acceptance-criteria` | Pasted text: the HU-05 spec with its acceptance criteria section removed (the orchestrator removes it in memory) · ITV-878 | "Just fill in whatever criteria make sense." | Says the spec has no acceptance criteria; asks whether to derive them from the rest of the spec or wait; any derived criteria are marked as derived, not presented as the spec's |
| `unreadable-spec` | Local path `./specs/does-not-exist.md` · ITV-878 | "You know roughly what it is from the name, go ahead." | Says it cannot read the spec and asks for another way; produces no draft |

`Purpose (scorer only)` for each: one line naming the design section it checks (6.1, 6.2, 7, 8, 5).

- [ ] **Step 3: Run the baseline.** For each scenario dispatch a runner (general-purpose subagent) with only `Setup`, `Invocation` and `Pressure`, no skill. Then dispatch a scorer with `Expected`, `Purpose` and the runner's output. Append `### baseline — <date>` with verdict (PASS/FAIL, n of m bullets), a line per bullet, a notable phrase, and classification (`discriminating` if the baseline fails a bullet the skill targets, `guard` if it already passes).
Expected: at least four scenarios fail at baseline. If fewer fail, report it to the user before writing the skill: the skill may be adding little.

- [ ] **Step 4: Commit.**

```bash
git add tests/spec-to-jira-stories
git commit -m "test(spec-to-jira-stories): add pressure scenarios and baseline"
```

### Task 2: Structure check and skill files (GREEN)

**Files:**
- Create: `tests/spec-to-jira-stories/check-structure.sh`
- Create: `skills/spec-to-jira-stories/SKILL.md`
- Create: `skills/spec-to-jira-stories/agents/openai.yaml`
- Create: `skills/spec-to-jira-stories/references/splitting.md`
- Create: `skills/spec-to-jira-stories/references/sub-tasks.md`
- Create: `skills/spec-to-jira-stories/references/ticket-content.md`
- Create: `skills/spec-to-jira-stories/references/evidence.md`

**Interfaces:**
- Consumes: the Task 1 scenarios.
- Produces: `bash tests/spec-to-jira-stories/check-structure.sh` → prints `OK: structure checks passed`, exit 0; otherwise `FAIL: <reason>` lines, exit 1. Honors `SPEC_JIRA_SKILL_DIR` (default `skills/spec-to-jira-stories`). `SKILL.md` headings (exact): `## Inputs`, `## Reading the spec`, `## Deciding the breakdown`, `## Ticket content`, `## Draft and creation`.

- [ ] **Step 1: Write `check-structure.sh`.** Model it on `tests/writing-tech-specs/check-structure.sh`. Checks:
  - frontmatter has `name: spec-to-jira-stories`, `disable-model-invocation: true`, `description` starting `Use when ` and ≤ 500 chars;
  - the five headings above exist;
  - `SKILL.md` word count ≤ 700 (`wc -w`);
  - no `ITV-[0-9]+` in `SKILL.md`;
  - `SKILL.md` contains each of: `emoji`, `confirm`, `epic`, `reference ticket`;
  - `agents/openai.yaml` has `allow_implicit_invocation: false` under `policy:`;
  - the four reference files exist and are non-empty, and every `` `<name>.md` `` named in `SKILL.md` exists in `references/`;
  - `references/evidence.md` has at least 10 `https://` URLs;
  - no person's name from Global Constraints anywhere in the skill folder (case-insensitive).

- [ ] **Step 2: Run it to verify it fails.** Run: `bash tests/spec-to-jira-stories/check-structure.sh`. Expected: `FAIL: skills/spec-to-jira-stories/SKILL.md does not exist`, exit 1.

- [ ] **Step 3: Write the skill.**
  - `SKILL.md`: description `Use when the user explicitly invokes /spec-to-jira-stories or $spec-to-jira-stories to turn a technical spec into Jira stories and sub-tasks (development, certification, code review) and optionally create them`. Body follows design sections 5 to 8: inputs (spec in any format, reference ticket for labels only, ask for dynamic data such as the epic), read by meaning (table of pieces), default one story and raise splits only with quoted evidence as a proposal, one dev sub-task ≈ one PR, always one certification and one code review, content per type in one line each with a pointer to `ticket-content.md`, no emojis, no hours/dates/sprint/priority/labels, draft first, then ask before each creation (story, sub-tasks, "relates to" link), then report keys and links, then offer to update the story's sub-task list with keys. Never write to Jira without a yes for that action. Without the Atlassian tools, deliver the draft only and say creation needs the connector. Never read a codebase or Git.
  - `references/splitting.md`: design 6.1 (the six questions with signal and source, the rule of thumb, the layer-split caveat, the three AtomChat calibration cases).
  - `references/sub-tasks.md`: design 6.2 (PR unit with evidence and its strength, the separate/keep table, ITV-781 and ITV-551 examples, "Parte N de M" naming).
  - `references/ticket-content.md`: design 7.1 to 7.4, each with a skeleton of the description using placeholder labels `<story-prefix>`, `<role-prefix>`, and the default labels used when the reference lacks a piece: `[BACKEND]`, `[FRONTEND]`, `[FULL]`, `[CERTIFICACIÓN]`, `[REVISIÓN]` for Spanish, `[BACKEND]`, `[FRONTEND]`, `[FULL]`, `[QA]`, `[CODE REVIEW]` for English.
  - `references/evidence.md`: design section 13 sources, each tagged `primary` or `vendor`, plus the two "not verified" notes.
  - `agents/openai.yaml`: `policy:` / `  allow_implicit_invocation: false`.

- [ ] **Step 4: Run the check.** Run: `bash tests/spec-to-jira-stories/check-structure.sh`. Expected: `OK: structure checks passed`, exit 0.

- [ ] **Step 5: Run green-1.** Same runner/scorer protocol as Task 1 Step 3, with the runner told to read `skills/spec-to-jira-stories/SKILL.md` (and references as it directs). Append `### green-1 — <date>`. Expected: every scenario PASS. Any FAIL goes to Task 3.

- [ ] **Step 6: Commit.**

```bash
git add skills/spec-to-jira-stories tests/spec-to-jira-stories
git commit -m "feat(spec-to-jira-stories): add skill for turning specs into Jira stories and sub-tasks"
```

### Task 3: Close loopholes (REFACTOR)

**Files:**
- Modify: `skills/spec-to-jira-stories/SKILL.md`, `references/*.md` as findings require
- Modify: `tests/spec-to-jira-stories/scenarios/*.md` (results, and new scenarios for new loopholes)

**Interfaces:**
- Consumes: green-1 results.
- Produces: `### refactor-N — <date>` entries; all scenarios PASS on the last run.

- [ ] **Step 1: For each FAIL bullet or rationalization seen in green-1**, add the smallest rule that closes it (in `SKILL.md` if it changes behavior, in a reference if it only explains). If a run shows a new loophole no scenario covers, add a scenario for it first and run it to see it fail.
- [ ] **Step 2: Re-run the failing scenarios plus `bulk-create-pressure`** (it guards the write rule). Append `refactor-N`. Repeat until all PASS.
- [ ] **Step 3: Run the check.** Run: `bash tests/spec-to-jira-stories/check-structure.sh`. Expected: `OK: structure checks passed`.
- [ ] **Step 4: Update `tests/spec-to-jira-stories/README.md`** Outcome table (scenario, baseline, with skill, role) and Not covered (one run per cell, scenarios read one site, etc.).
- [ ] **Step 5: Commit.**

```bash
git add skills/spec-to-jira-stories tests/spec-to-jira-stories
git commit -m "test(spec-to-jira-stories): close loopholes found in green runs"
```

### Task 4: Docs, READMEs, install and final eyeball check

**Files:**
- Create: `docs/skills/spec-to-jira-stories.md`, `docs/skills/spec-to-jira-stories.es.md`
- Modify: `README.md` (skills table, tests list), `README.es.md` (skills table, tests list), `AGENTS.md` (Tests list)

**Interfaces:**
- Consumes: the finished skill.
- Produces: docs and table rows; the skill installed.

- [ ] **Step 1: Write the docs** in the style of `docs/skills/writing-tech-specs.md` (language switcher line, Usage with three example invocations, what is in the skill as a file table, limits). The `.es.md` is a translation.
- [ ] **Step 2: Add the rows.** `README.md`: `| \`spec-to-jira-stories\` | Turn a technical spec into Jira stories and sub-tasks (development, certification, code review) and create them after confirmation. | \`/spec-to-jira-stories\` (Claude Code), \`$spec-to-jira-stories\` (Codex) | [docs/skills/spec-to-jira-stories.md](docs/skills/spec-to-jira-stories.md) |`. `README.es.md`: same row in Spanish, linking the `.es.md`. Add `bash tests/spec-to-jira-stories/check-structure.sh` to the tests list in both READMEs and in `AGENTS.md`.
- [ ] **Step 3: Run every repo test.** Run each command in the `AGENTS.md` Tests list plus the new check. Expected: all pass.
- [ ] **Step 4: Install.** Run: `bash install.sh`. Expected: an `ok:` line for `spec-to-jira-stories` under `~/.claude/skills` and `~/.agents/skills`. Then ask the user to check that `/spec-to-jira-stories` loads in Claude Code and that an implicit prompt ("turn this spec into tickets") does not load it.
- [ ] **Step 5: Final eyeball check.** Run the skill in this session on spec 42 (pages 4808081410 and 4808441857) with reference ITV-878, up to the draft only. Show Carlos the full draft on screen. Create nothing in Jira. Record his verdict in `tests/spec-to-jira-stories/README.md` under Outcome.
- [ ] **Step 6: Commit.**

```bash
git add docs/skills README.md README.es.md AGENTS.md tests/spec-to-jira-stories/README.md
git commit -m "docs(spec-to-jira-stories): add usage docs and README rows"
```
