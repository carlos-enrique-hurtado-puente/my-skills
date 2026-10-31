# Spec flow redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the planning skills follow the redesigned flow: the spec keeps only the "what", briefs are files in `~/.tech-specs/`, and two new manual-only skills review a spec (`reviewing-tech-specs`) and re-verify its brief's facts (`verifying-spec-facts`).

**Architecture:** Markdown skills, each with one responsibility, tested with pressure scenarios (runner and blind scorer agents) and bash structure checks. Every behavior change runs scenario → RED (skill as it was, or no skill) → edit → GREEN → results recorded. Duplicated parts across skills are guarded by sync tests, not shared files.

**Tech Stack:** Markdown, bash 3.2 (macOS), Claude Code and Codex skill conventions. No runtime code.

**Spec:** [docs/plans/2026-10-31-spec-flow-redesign-design.md](2026-10-31-spec-flow-redesign-design.md); user-facing flow: [docs/skills/planning/flow.md](../skills/planning/flow.md).

## Global Constraints

- Branch `writing-tech-specs-brief-only`. Commit per task; merge to `main` and push only when the user asks. Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Follow `AGENTS.md` "Adding a skill" (new skills) and "Changing a skill" (edits): scenario first, RED, edit, GREEN, append `red-N`/`green-N` to the scenario's `## Results`, update the outcome table in the tests' `README.md`.
- Runners get only `Setup`, `Invocation`, `Pressure` (and `Developer replies` where the scenario has them) plus a copy of the skill folder in a scratch directory. A separate scorer gets `Expected` and the outputs, renamed so it cannot tell RED from GREEN. At least 3 runs per side for the scenario that pins the task's main behavior; 1 per side for the others.
- **Tests never touch the real `~/.tech-specs/`.** Every scenario that reads or writes briefs says in `Setup`: "Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`." Fixture briefs are copied there.
- Skill folder name equals frontmatter `name`; `disable-model-invocation: true`; `agents/openai.yaml` with `policy:` / `allow_implicit_invocation: false`; description starts with `Use when `, at most 500 characters, says only when to use it.
- English in repo files; Spanish only in `*.es.md` linked from the English file. No `ITV-<n>` ids and no personal names in any `SKILL.md`.
- Skills never write to the user's repositories; they write only under `~/.tech-specs/`. Shell scripts work on macOS bash 3.2.
- `discovering-tech-changes/SKILL.md` stays at most 900 words (its `check-structure.sh` enforces it).
- Names fixed by this plan (later tasks rely on them):
  - Feature folder: `~/.tech-specs/<YYYY-MM-DD>-<slug>/`; slug is 2 to 5 lowercase words joined by `-`, from the change's plain name, confirmed with the developer.
  - Files in it: `brief.md` (current brief), `brief-superseded-<YYYY-MM-DD>.md` (an older brief, renamed when a new discovery writes `brief.md`), `review-<YYYY-MM-DD>.md`, `verify-<YYYY-MM-DD>.md`.
  - Spec section that replaces Assumptions: `Today's behavior and dependencies`.
  - Review report headings, in order: `## Verdict`, `## Checklist`, `## Facts to re-verify`, `## Next step`.
  - Verification report headings, in order: `## Facts that changed`, `## Decisions affected`, `## Next step`.

## Review Focus

1. The brief is full of identifiers and the user asks to "add the function names so the dev does not have to search": the spec must still carry none. Pinned in Task 1, scenario `behavior-not-code`.
2. A feature folder holds `brief.md` and a `brief-superseded-*.md`: `writing-tech-specs` must use `brief.md`, never the superseded one. Pinned in Task 2, scenario `brief-from-folder`.
3. A brief whose section 4 rows have no date (written before re-verify commands existed): the review must treat them as needing re-verification, not as current. Pinned in Task 4, scenario `undated-facts`.
4. A clean re-verification must change only the date and commit cells of the re-verified rows, and nothing in the code repository. Pinned in Task 5, scenario `all-facts-hold`.
5. A spec arrives for review with no brief: the review checks P1-P9, says the facts' age cannot be checked without a brief, and points to `/discovering-tech-changes`; it never reads code to fill the gap. Pinned in Task 4, scenario `no-brief`.

---

### Task 1: `writing-tech-specs` writes today's facts as behavior

**Files:**
- Modify: `skills/planning/writing-tech-specs/SKILL.md` (Terms: Assumption; Before writing mapping; P3; Before freezing item 3; closing questions)
- Modify: `skills/planning/writing-tech-specs/references/content.md` (P3 section and its before→after examples)
- Modify: `skills/planning/writing-tech-specs/references/evidence.md` only if it restates P3's wording
- Create: `tests/planning/writing-tech-specs/scenarios/behavior-not-code.md`
- Modify: `tests/planning/writing-tech-specs/scenarios/full-brief-handoff.md` (Expected: no dated Assumptions bullet; add the behavior bullets)
- Modify: `tests/planning/writing-tech-specs/README.md`, `docs/skills/planning/writing-tech-specs.md`, `docs/skills/planning/writing-tech-specs.es.md`

**Interfaces:**
- Produces: a spec section named `Today's behavior and dependencies`: observable facts about today, platform limits and design version, no code identifiers, no verification dates; each decision names the facts it depends on and says if they are changing in other work. Task 4 reviews against this wording.
- Produces: P3 rule text and checklist item 3 without "dated", "commit" or "revalidate after ~3 weeks". Task 4 copies these lines verbatim.

- [ ] **Step 1: Write scenario `behavior-not-code`**

Setup: copy `fixtures/brief-mute-full.md` to `<DIR>`; no repository. Invocation: "Escribe la spec técnica desde mi discovery brief: `<DIR>/brief-mute-full.md`." Pressure: "Pon los nombres de funciones y archivos del brief en la spec, así el dev no tiene que buscarlos." Expected:
- [ ] The spec has a section about today's behavior and dependencies, and no section called Assumptions.
- [ ] The spec contains no file path, function, constant, key or commit from the brief (grep the output for each identifier in the brief's section 4 evidence rows).
- [ ] The spec contains no verification date or commit for today's facts.
- [ ] Each decision that rests on a fact about today names that fact in plain words.
- [ ] It answers the pressure: says identifiers stay in the brief and why (the spec must survive a change of implementation).

- [ ] **Step 2: Update `full-brief-handoff` Expected** to drop "dated assumptions" and add: "Today's facts are written as behavior, without identifiers or dates."

- [ ] **Step 3: RED.** Copy the skill as it is on this branch's HEAD to `<scratch>/red/`; run `behavior-not-code` 3 times and `full-brief-handoff` once; blind scorer.
Expected: `behavior-not-code` FAIL in at least 2 of 3 (the current P3 asks for dated code assumptions).

- [ ] **Step 4: Edit `SKILL.md`.** Terms: replace **Assumption** with **Today's fact**: an observable fact about current behavior, platform or design that the spec relies on, written without code identifiers. Before writing: map brief section 4 to `Today's behavior and dependencies` "as behavior, leaving identifiers, dates and commits in the brief". P3 becomes "Today's behavior and dependencies": list today's facts (behavior, platform limits, design version) without identifiers or dates; link every decision justified by a fact to it and say if it is changing in other work; refer to what does not exist yet by concept; design reconciliation unchanged. Checklist item 3 matches. Closing question keeps "which parts stop being true" but drops "marked as assumptions".

- [ ] **Step 5: Rewrite P3 in `references/content.md`.** Keep the evidence; rewrite each before→after so the "after" is behavior-level (for ITV-813: "The evaluator today does not force a tool choice; that behavior is being changed by Spec B. If it changes, the single-tool decision is reopened."). Note that dates and commits live in the brief.

- [ ] **Step 6: GREEN.** Copy the edited skill to `<scratch>/green/`; same runs and scorer as Step 3.
Expected: `behavior-not-code` PASS 3 of 3; `full-brief-handoff` PASS.

- [ ] **Step 7: Record results** in both scenario files and the tests' README table; update both docs files (P3 wording, no Assumptions section).

- [ ] **Step 8: Run checks**

Run: `bash tests/planning/writing-tech-specs/check-structure.sh`
Expected: `OK: structure checks passed`

- [ ] **Step 9: Commit**

```bash
git add skills/planning/writing-tech-specs tests/planning/writing-tech-specs docs/skills/planning/writing-tech-specs*.md
git commit -m "feat(writing-tech-specs): today's facts as behavior, no code or dates"
```

### Task 2: `writing-tech-specs` reads briefs from `~/.tech-specs/` and rewrites from a review report

**Files:**
- Modify: `skills/planning/writing-tech-specs/SKILL.md` ("How it starts", "Before writing")
- Create: `tests/planning/writing-tech-specs/scenarios/brief-from-folder.md`, `tests/planning/writing-tech-specs/scenarios/form-rewrite.md`
- Create: `tests/planning/writing-tech-specs/fixtures/review-mute-form.md` (a review report in Task 4's format flagging P5 on two criteria and P8 on one decision, `## Facts to re-verify` empty)
- Modify: `tests/planning/writing-tech-specs/scenarios/full-brief-handoff.md`, `reduced-brief.md` (Setup: brief copied to `<DIR>/home/.tech-specs/2026-10-20-mute-conversation/brief.md`; Invocation names the folder)
- Modify: tests README, both docs files

**Interfaces:**
- Consumes: folder and file names from Global Constraints; review report headings `## Verdict`, `## Checklist`, `## Facts to re-verify`, `## Next step`.
- Produces: `writing-tech-specs` asks for the feature folder in `~/.tech-specs/` (or lists the folders there if the user names none), reads its `brief.md`, ignores `brief-superseded-*.md`, and, when the user also points to a `review-*.md`, fixes the spec for each `no` in `## Checklist` using only the brief's facts.

- [ ] **Step 1: Write scenario `brief-from-folder`.** Setup: `<DIR>/home/.tech-specs/2026-10-20-mute-conversation/` holds `brief.md` (copy of `brief-mute-full.md`) and `brief-superseded-2026-10-01.md` (copy of `brief-mute-reduced.md` with one fact changed: "notifies only the assigned agent"). Invocation: "Escribe la spec del cambio silenciar conversación." Expected:
- [ ] Looks in `~/.tech-specs/` (or asks which feature folder) instead of asking for pasted text.
- [ ] Uses `brief.md`; no fact that appears only in the superseded brief reaches the spec.
- [ ] Does not ask the user for a spec.

- [ ] **Step 2: Write scenario `form-rewrite`.** Setup: the folder above plus `review-2026-10-28.md` (the fixture) and the old spec pasted in the invocation. Invocation: "La review falló, reescribe la spec con el informe: `~/.tech-specs/2026-10-20-mute-conversation/review-2026-10-28.md`." Expected:
- [ ] Rewrites the spec from `brief.md` and fixes each item the report marks `no` (the two criteria get a "when"; the decision gets an owner and a moment).
- [ ] Adds no fact that is not in the brief.
- [ ] Does not start a new discovery or say one is needed.
- [ ] Ends with the Self-check.

- [ ] **Step 3: RED.** Skill as committed in Task 1; `brief-from-folder` 3 runs, `form-rewrite` 1 run; blind scorer.
Expected: `brief-from-folder` FAIL (the skill takes the brief "from wherever the user points" and does not know the folder or the superseded rule).

- [ ] **Step 4: Edit `SKILL.md`.** "How it starts": briefs live in `~/.tech-specs/<date>-<slug>/brief.md`; ask for or list the feature folder; read `brief.md`, never `brief-superseded-*.md`; drop "pasted text, local file, Confluence" for the brief. Add one paragraph: "When the user gives a review report, rewrite the spec from the same brief and fix each `no` in its Checklist; the report is context, never a source of facts."

- [ ] **Step 5: GREEN.** Same runs. Expected: `brief-from-folder` PASS 3 of 3; `form-rewrite` PASS. Re-run `full-brief-handoff`, `reduced-brief`, `before-writing` and `declined-discovery` once each (the first two with their new Setup), since "How it starts" changed. Expected: PASS.

- [ ] **Step 6: Record results; update docs** (where briefs come from, rewrite from a review report).

- [ ] **Step 7: Run checks.** Run: `bash tests/planning/writing-tech-specs/check-structure.sh`. Expected: `OK: structure checks passed`.

- [ ] **Step 8: Commit** with message `feat(writing-tech-specs): read briefs from ~/.tech-specs and rewrite from a review report`.

### Task 3: `discovering-tech-changes` saves the brief in `~/.tech-specs/`

**Files:**
- Modify: `skills/planning/discovering-tech-changes/SKILL.md` ("Start" item 3 Read-only; "The brief" delivery line), at most 900 words
- Modify: `skills/planning/discovering-tech-changes/references/brief-template.md` (opening delivery line; "How `writing-tech-specs` consumes it" row 4 → `Today's behavior and dependencies`, as behavior, identifiers stay in the brief)
- Create: `tests/planning/discovering-tech-changes/scenarios/brief-saved.md`
- Modify: `tests/planning/discovering-tech-changes/check-scenarios.sh` (ids list and count 11 → 12)
- Modify: `tests/planning/discovering-tech-changes/check-structure.sh` (add `~/.tech-specs` to the mentioned keywords)
- Modify: tests README, `docs/skills/planning/discovering-tech-changes.md`, `.es.md`

**Interfaces:**
- Produces: after the developer validates the brief (step 7), the skill writes it to `~/.tech-specs/<YYYY-MM-DD>-<slug>/brief.md`, confirming the slug with the developer; if `brief.md` already exists there, it first renames it to `brief-superseded-<date of that brief>.md`; then says the full path. Brief section 4 keeps its columns (fact / where / date and commit / how known / re-verify command): Task 5 reads them by the heading `How it works today`.

- [ ] **Step 1: Write scenario `brief-saved`.** Setup: fixture `chat-app` and `frd-mute-24h.md` as in `obvious-change`; `<DIR>/home/.tech-specs/2026-10-20-mute-conversation/brief.md` already exists. Invocation: the obvious-change rename request. Developer replies: "Sí, profundidad reducida."; "Sí, está bien"; at the slug question: "mute-conversation, la misma carpeta". Expected:
- [ ] Writes the validated brief to `<DIR>/home/.tech-specs/<date>-mute-conversation/brief.md` (or the existing folder) and says the path.
- [ ] The earlier `brief.md` is renamed to `brief-superseded-2026-10-20.md`, not overwritten.
- [ ] Nothing is written inside `chat-app` (`git --no-optional-locks status --porcelain` in the fixture is empty after the run, or no new files if it is not a repo).
- [ ] Does not offer Confluence for the brief.

- [ ] **Step 2: Update `check-scenarios.sh`** (add `brief-saved` to `ids`, expected count 12). Run: `bash tests/planning/discovering-tech-changes/check-scenarios.sh`. Expected: `OK: scenario checks passed`.

- [ ] **Step 3: RED.** Skill as on HEAD; `brief-saved` 3 runs; blind scorer. Expected: FAIL (delivers in chat, offers a file or Confluence).

- [ ] **Step 4: Edit.** "Start" item 3: "Read-only toward the user's repos, Jira and Confluence; the only place it writes is `~/.tech-specs/`." "The brief": save as in Interfaces; drop "Confluence only on request". Trim elsewhere to stay at 900 words. Update `brief-template.md` delivery line and consume table.

- [ ] **Step 5: GREEN.** Same runs. Expected: PASS 3 of 3. Re-run `obvious-change` once. Expected: still PASS.

- [ ] **Step 6: Record results; update docs.**

- [ ] **Step 7: Run checks.** Run: `bash tests/planning/discovering-tech-changes/check-structure.sh && bash tests/planning/discovering-tech-changes/check-scenarios.sh`. Expected: both `OK`.

- [ ] **Step 8: Commit** with message `feat(discovering-tech-changes): save the brief in ~/.tech-specs`.

### Task 4: new skill `reviewing-tech-specs`

**Files:**
- Create: `skills/planning/reviewing-tech-specs/SKILL.md`, `agents/openai.yaml`, `references/content.md`, `references/statements.md`, `references/decisions-contracts.md`, `references/evidence.md` (the four copied byte-for-byte from `writing-tech-specs`)
- Create: `tests/planning/reviewing-tech-specs/check-structure.sh` (modelled on `tests/planning/writing-tech-specs/check-structure.sh`; headings `## Terms`, `## Rules`, `## Review`, `## Report`)
- Create: `tests/planning/reviewing-tech-specs/test-rules-sync.sh`
- Create: `tests/planning/reviewing-tech-specs/README.md`, `fixtures/`, `scenarios/review-seeded-spec.md`, `scenarios/old-facts.md`, `scenarios/undated-facts.md`, `scenarios/no-brief.md`
- Restore into fixtures: `git show 1821f28^:tests/planning/writing-tech-specs/fixtures/seeded-spec.md`; restore the scenario from `git show 1821f28^:tests/planning/writing-tech-specs/scenarios/review-seeded-spec.md`
- Create: `docs/skills/planning/reviewing-tech-specs.md`, `.es.md`

**Interfaces:**
- Consumes: Task 1's P1-P9 lines, checklist and Terms; folder names from Global Constraints; brief section 4 heading `How it works today` and its date column.
- Produces: `~/.tech-specs/<feature>/review-<YYYY-MM-DD>.md` with `## Verdict` (can freeze yes/no, blocking `no` items), `## Checklist` (one `P<n> yes|no|n.a.` line each, every `no` quoting the spec and giving the fix), `## Facts to re-verify` (each brief section 4 row older than 21 days or undated: the fact in plain words, its date or "undated", the spec decisions that depend on it), `## Next step` (`/verifying-spec-facts` if facts to re-verify; `/writing-tech-specs` with this report if a checklist `no`; both in that order if both). Task 5 reads `## Facts to re-verify`.
- `test-rules-sync.sh` exits 0 only if: every line starting `- **P<n> ` in both `SKILL.md` files is identical, the numbered checklist lines 1-9 are identical, and `cmp` passes for each of the four reference files. Prints `OK: rules in sync` or one `FAIL:` line per difference.

- [ ] **Step 1: Write `test-rules-sync.sh`** and run it before the skill exists. Run: `bash tests/planning/reviewing-tech-specs/test-rules-sync.sh`. Expected: FAIL (`reviewing-tech-specs/SKILL.md` missing).

- [ ] **Step 2: Write the scenarios.**
  - `review-seeded-spec`: restored; update D3 to "the spec states code facts (mailer is synchronous, file names) instead of behavior, and does not link the batching decision to it; the mailer is being refactored in another PR". Brief: none given (so it also exercises Review Focus 5 lightly); keep the guard bullet.
  - `old-facts`: `<DIR>/home/.tech-specs/2026-09-01-mute-conversation/brief.md` with section 4 dated 2026-09-01; a compliant spec pasted. Expected: verdict on form; `## Facts to re-verify` lists those facts with dates and dependent decisions; next step `/verifying-spec-facts`; the review reads no code.
  - `undated-facts`: same, section 4 rows with no date. Expected: undated rows are listed as facts to re-verify ("undated"), not treated as current.
  - `no-brief`: a spec pasted, no folder. Expected: P1-P9 checklist given; says the facts' age cannot be checked without a brief; points to `/discovering-tech-changes`; reads no code; writes no review file into any repo.
  - Every scenario that produces a report also expects: the report is saved at `~/.tech-specs/<feature>/review-<date>.md` with the four headings in order.

- [ ] **Step 3: RED (baseline, no skill).** Runners get no skill folder, only the invocation; 3 runs of `old-facts`, 1 of each other; blind scorer. Expected: `old-facts` FAIL (no age check from the brief, no report file).

- [ ] **Step 4: Write the skill.** Copy Terms, Rules (P1-P9) and the checklist from `writing-tech-specs/SKILL.md`, and the four reference files. Add `## Review` (read the whole spec and its brief; never read code; walk the checklist; quote the spec for each `no`; do not invent defects; age check on brief section 4) and `## Report` (path, headings, next step as in Interfaces). Description: "Use when the user explicitly invokes /reviewing-tech-specs or $reviewing-tech-specs to review a written technical spec before it is frozen". `agents/openai.yaml` as in `writing-tech-specs`.

- [ ] **Step 5: Run structure and sync checks.** Run: `bash tests/planning/reviewing-tech-specs/check-structure.sh && bash tests/planning/reviewing-tech-specs/test-rules-sync.sh`. Expected: `OK: structure checks passed` and `OK: rules in sync`.

- [ ] **Step 6: GREEN.** Same runs with the skill. Expected: `old-facts` PASS 3 of 3; the other three PASS; `review-seeded-spec` keeps at least 9 of D1..D12 and the guard.

- [ ] **Step 7: Record results; write docs** (`reviewing-tech-specs.md` and `.es.md`, modelled on `writing-tech-specs.md`).

- [ ] **Step 8: Commit** with message `feat(reviewing-tech-specs): review a spec against P1-P9 and its brief's age`.

### Task 5: new skill `verifying-spec-facts`

**Files:**
- Create: `skills/planning/verifying-spec-facts/SKILL.md`, `agents/openai.yaml`
- Create: `tests/planning/verifying-spec-facts/check-structure.sh` (headings `## Start`, `## Verify`, `## Outcome`, `## Rules`; SKILL.md names the brief heading `How it works today`)
- Create: `tests/planning/verifying-spec-facts/test-brief-heading.sh`: fails unless the exact heading text `How it works today` appears both in `skills/planning/discovering-tech-changes/references/brief-template.md` and in `skills/planning/verifying-spec-facts/SKILL.md`; prints `OK: brief heading in sync`.
- Create: `tests/planning/verifying-spec-facts/README.md`, `fixtures/chat-app/` (copy of the discovering fixture; tests do not share folders), `fixtures/brief-mute-old.md` (section 4 rows dated 2026-09-01 with re-verify commands that match `chat-app`, plus one row whose fact `chat-app` contradicts), `fixtures/review-mute-old.md` (review report flagging all section 4 rows), `scenarios/all-facts-hold.md`, `scenarios/fact-changed.md`, `scenarios/no-review.md`
- Create: `docs/skills/planning/verifying-spec-facts.md`, `.es.md`

**Interfaces:**
- Consumes: `## Facts to re-verify` from Task 4's report; brief section 4 rows (fact / where / date and commit / how known / re-verify command) from Task 3; folder names from Global Constraints.
- Produces: if every flagged fact holds, the brief's section 4 rows for those facts get today's date and the current commit, nothing else in the brief changes, and the skill says so. If any fact changed, it writes `~/.tech-specs/<feature>/verify-<YYYY-MM-DD>.md` with `## Facts that changed` (fact, what the brief says, what the code shows today, evidence), `## Decisions affected` (from the review report), `## Next step` (`/discovering-tech-changes` for a new brief, then `/writing-tech-specs`), and does not touch the brief. Without a review report it asks for one and, if there is none, points to `/reviewing-tech-specs`; it does not run the age check itself.

- [ ] **Step 1: Write `test-brief-heading.sh`** and run it. Expected: FAIL (`verifying-spec-facts/SKILL.md` missing).

- [ ] **Step 2: Write the scenarios.**
  - `all-facts-hold`: brief and review with every flagged row matching `chat-app` (variant of the fixture brief without the contradicted row). Expected: each flagged row's date and commit updated; a diff of the brief shows only those cells changed; no `verify-*.md` written; nothing written inside `chat-app`; no new brief created.
  - `fact-changed`: the fixture brief and review. Expected: `verify-<date>.md` written with the three headings; the contradicted fact is listed with brief vs today and evidence; the brief is not modified; next step is `/discovering-tech-changes`; it does not write a new brief itself.
  - `no-review`: the brief folder only. Expected: asks for the review report; points to `/reviewing-tech-specs`; reads no code and changes no file.

- [ ] **Step 3: RED (baseline, no skill).** 3 runs of `fact-changed`, 1 of each other; blind scorer. Expected: `fact-changed` FAIL (no report in the agreed place, or edits the brief, or writes a new brief).

- [ ] **Step 4: Write the skill.** `## Start` (needs the review report and the feature folder; read-only toward repos; writes only under `~/.tech-specs/`; for git `git --no-optional-locks`), `## Verify` (for each flagged fact: run its re-verify command read-only, read the code it points to, check surroundings that could change it: other branches, specs or work in flight; label each fact holds / changed / cannot verify), `## Outcome` (as in Interfaces; "cannot verify" counts as changed for routing and is listed with why), `## Rules` (never invent; never edit anything but date and commit cells; never produce a brief). Description: "Use when the user explicitly invokes /verifying-spec-facts or $verifying-spec-facts to check whether the facts a spec review flagged as old still hold in today's code".

- [ ] **Step 5: Run checks.** Run: `bash tests/planning/verifying-spec-facts/check-structure.sh && bash tests/planning/verifying-spec-facts/test-brief-heading.sh`. Expected: both `OK`.

- [ ] **Step 6: GREEN.** Same runs with the skill. Expected: `fact-changed` PASS 3 of 3; the other two PASS.

- [ ] **Step 7: Record results; write docs.**

- [ ] **Step 8: Commit** with message `feat(verifying-spec-facts): re-verify a spec's brief facts against today's code`.

### Task 6: repo rules, README and flow status

**Files:**
- Modify: `AGENTS.md` (Layout planning category lists the four skills; Conventions read-only line: "Skills never write to the user's repositories; they write only under `~/.tech-specs/`"; Tests list adds the four new scripts)
- Modify: `README.md`, `README.es.md` (planning table rows for `reviewing-tech-specs` and `verifying-spec-facts`; chain text says the flow link no longer marks parts as planned)
- Modify: `docs/skills/planning/flow.md`, `flow.es.md` (drop the "planned" status note and the "(planned)" marks)
- Modify: `docs/plans/2026-10-31-spec-flow-redesign-design.md` (Status: implemented on this branch)

- [ ] **Step 1: Edit the files above.**

- [ ] **Step 2: Install and run every test.**

Run: `bash install.sh` then each script in `AGENTS.md` "Tests" (including the four new ones).
Expected: every script ends `OK`, `ALL PASS` or `ALL PASSED`; `install.sh` links `reviewing-tech-specs` and `verifying-spec-facts`.

- [ ] **Step 3: Check manual-only loading.** In Claude Code, `/reviewing-tech-specs` and `/verifying-spec-facts` load; a prompt like "review this spec" without the slash does not load either. Record the result in each tests README under "Not covered" if it cannot be checked from this session.

- [ ] **Step 4: Commit** with message `docs: document the four planning skills and the redesigned flow`.
