# specflow folder: design

- **Date:** 2026-10-31
- **Status:** design, approved in conversation; not implemented
- **Related:** [docs/plans/2026-10-31-spec-flow-redesign-design.md](2026-10-31-spec-flow-redesign-design.md) (the four planning skills and `~/.tech-specs/`), [docs/skills/planning/flow.md](../skills/planning/flow.md)

## 1. Intent and why

The planning flow stores its working files in `~/.tech-specs/<YYYY-MM-DD>-<slug>/` (brief, review and verification reports). The flow is now growing past the spec: the next skills will plan, set up worktrees and run the implementation, up to a final code review. Their files (plans, progress) belong to the same feature, outside every repository, so one place holds the whole life of a feature.

The name `.tech-specs` no longer describes that. The flow is named **specflow**, and its folder becomes `~/.specflow/`.

This design fixes the folder's structure and naming rules once, for the four skills that exist and for the ones still to come, and moves the existing skills to it. It does not design the plan, worktree, execution or code review skills.

## 2. Goals, non-goals, anti-goals

**Goals**
- One folder per feature under `~/.specflow/`, holding every file of that feature from discovery to implementation.
- One structure and one set of naming rules, documented in one place, that every specflow skill follows.
- The four existing planning skills read and write `~/.specflow/` instead of `~/.tech-specs/`.
- `writing-tech-specs` keeps a local copy of the spec (`spec.md`) with its source and date.
- Different features never mix: each has its own folder.

**Non-goals**
- Designing the plan, worktree, execution or code review skills (they will create `repos.md`, `plan-<repo>.md`, `progress-<repo>.md`; this design only reserves those names).
- Spec as input to discovery (decided for the flow; implemented with the plan skill work, section 7).
- An index file listing features: skills list the folders.

**Anti-goals**
- Any specflow skill writing inside a user's repository during planning.
- Overwriting an older brief, spec, plan or report: older versions are renamed, never replaced.
- Losing or silently moving the user's existing `~/.tech-specs/` content.

## 3. The structure

```text
~/.specflow/
  <YYYY-MM-DD>-<slug>/                 ← one folder per feature
    brief.md                           ← discovering-tech-changes
    brief-superseded-<YYYY-MM-DD>.md   ← an older brief
    spec.md                            ← writing-tech-specs: local copy of the spec
    spec-superseded-<YYYY-MM-DD>.md    ← an older spec
    review-<YYYY-MM-DD>.md             ← reviewing-tech-specs
    verify-<YYYY-MM-DD>.md             ← verifying-spec-facts, only when a fact changed
    repos.md                           ← reserved: repositories of the feature (future worktree skill)
    plan-<repo>.md                     ← reserved: one plan per repository (future plan skill)
    progress-<repo>.md                 ← reserved: one progress ledger per repository (future execution skill)
```

**Naming rules**
- Feature folder: `<YYYY-MM-DD>-<slug>`, the date the feature folder was created; slug of 2 to 5 lowercase words joined by `-`, confirmed with the developer (unchanged from today).
- A skill that writes a file which already exists renames the old one to `<name>-superseded-<YYYY-MM-DD>.md` before writing. The date is the one written inside the old file (the brief's header date; the spec copy's date), or the file's modification date if it has none. If that superseded name already exists, add `-2`, `-3`… Nothing is ever overwritten. Today this applies to `brief.md` and `spec.md`; reserved files follow the same rule when their skills are built.
- Dated reports (`review-`, `verify-`) never overwrite: a second one on the same day gets a `-2` suffix (`review-2026-11-03-2.md`), then `-3`… "The latest" report means the newest date, then the highest suffix compared as a number (no suffix counts as 1).
- `<repo>` is the repository's folder name (for example `atom`, `atom-ui`).
- `~/.specflow/` is hidden: skills list it directly. To find a feature, a skill uses the folder the user names, or lists `~/.specflow/` and asks which one.
- Files no skill reads: `*-superseded-*`. Consumers always read the current name.

**`spec.md`**
- Written by `writing-tech-specs` every time it produces a spec (first draft or rewrite), in addition to giving it in the answer. Always: the user wants a local copy, and the feature folder always exists because the skill writes only from a brief. If the folder cannot be written, the skill says so and gives the spec in the answer only.
- First lines: where the spec is published (link, or "not published yet") and the date of this copy. If the team edits the published spec later, the date shows the copy is old.
- `reviewing-tech-specs` reviews the spec the user points to (the published one may have changed after freeze). If the user names no spec and the feature folder has `spec.md`, it uses that copy and says its source and date. It never writes `spec.md`.

## 4. Changes to the existing skills

| Skill | Change |
|---|---|
| `discovering-tech-changes` | `~/.tech-specs/` → `~/.specflow/` (save path, hidden-folder note, reuse-folder clause) |
| `writing-tech-specs` | `~/.tech-specs/` → `~/.specflow/`; save the spec as `spec.md` with its source and date, renaming an older `spec.md` to `spec-superseded-<date>.md`; never read `spec-superseded-*` |
| `reviewing-tech-specs` | `~/.tech-specs/` → `~/.specflow/`; report never overwrites (`-2` suffix) |
| `verifying-spec-facts` | `~/.tech-specs/` → `~/.specflow/`; report never overwrites (`-2` suffix); "latest review" means the newest date, then the highest suffix |

Also: `AGENTS.md` (the write rule), `README.md`/`README.es.md`, `docs/skills/planning/*.md` and `.es.md`, `flow.md`/`flow.es.md`, tests (scenario Setups use `<DIR>/home/.specflow/`), and the earlier design's mentions (a note that `~/.tech-specs/` was renamed, not a rewrite of history).

The folder structure is documented once for users in `docs/skills/planning/flow.md` (and `.es.md`), section "The specflow folder". Each skill states only the parts it reads or writes.

## 5. Moving existing content

The user's real `~/.tech-specs/` already holds `2026-10-31-cortex-tabla-ds/` (a real test run). Skills never touch the old folder.

- After the skills change, the user moves it once with `mv ~/.tech-specs ~/.specflow` (or the developer asks the agent to do it, and the agent shows the command and runs it only on a yes).
- If both folders exist, nothing merges automatically; the user decides.
- The docs say this in one line, in the flow doc. No skill notices a leftover `~/.tech-specs/` or offers the move: this is documentation only, with no skill behavior or test. The discovery's reuse-folder clause looks only in `~/.specflow/`.

## 6. Tests

Behavior changes follow `AGENTS.md` "Changing a skill".
- Path rename: every scenario Setup that names `.tech-specs` is updated to `<DIR>/home/.specflow/` (search and replace). One existing scenario per skill gets a GREEN run as a regression check of this mechanical change (`brief-saved`, `brief-from-folder`, `old-facts`, `fact-changed`); the others are not re-run for the rename alone.
- `spec.md`: new scenario for `writing-tech-specs` (spec saved as `spec.md` with source and date; an existing `spec.md` renamed to `spec-superseded-<date>.md`; nothing written in a repository). RED on the current skill, GREEN after.
- Same-day report suffix: covered by adding a pre-existing `review-<today>.md` to the Setup of `old-facts` and expecting `review-<today>-2.md`. RED/GREEN.
- A grep check (in each skill's `check-structure.sh` or one shared test under `tests/planning/`) fails if `.tech-specs` appears anywhere under `skills/planning/`. It does not scan `docs/` or `tests/`: the flow doc's move line, the note in the earlier design and the earlier plan files keep the old name as history.
- `spec.md` default in review: add to `old-facts` (or a new scenario) a case with no spec named and `spec.md` in the folder; expect the review to use it and state its source and date. RED/GREEN.
- `install.sh` and `tests/install/` need no change: the folder is a runtime path.

## 7. Decided for the rest of the flow (context for the next skills)

Recorded here so the next designs start from it; none of this is built by this design.

- **Spec without brief:** the spec enters `discovering-tech-changes` as its input requirement (framing skipped: goals come from the spec); the brief comes from the code, never from the spec. If the code contradicts the spec, planning does not start: the spec is fixed first.
- **Before planning:** the agent always offers to re-verify the brief's facts and shows when they were last verified; if the developer accepts, it verifies then, whatever their age.
- **Own skills, based on superpowers:** a plan skill (from `writing-plans`), a worktree skill (from `using-git-worktrees`) and an execution skill (from `subagent-driven-development`). The plan keeps the task format the execution skill parses.
- **One plan per repository** (`plan-<repo>.md`): each repository is usually implemented separately. Each task names the spec criteria it meets.
- **Worktrees:** use the agent's native worktree tool when it exists (Claude Code: `.claude/worktrees/` in the repo); otherwise `git worktree` with the folder ignored through `.git/info/exclude`, never by editing `.gitignore`. Branch naming convention to define; the base branch is always confirmed with the developer.
- **Progress:** in the feature folder (`progress-<repo>.md`), so a cut session resumes from it. If the spec proves wrong mid-implementation, execution stops, records it and tells the developer.
- **Planning writes nothing in repositories; implementation writes code only in its worktree and branch, never in the base branch.**
- **Code review and integration** (merge, PR, Jira): later, starting from the user's existing review skills.

## 8. Designer's calls (from the builder check, can be revisited)

- Only four scenarios get a GREEN run for the rename; the rest are search and replace.
- `spec.md` is written every time, not optionally.
- Superseded date comes from inside the old file, else its modification date; name clashes get `-2`, `-3`.
- Report suffixes sort numerically; the same rule covers `review-` and `verify-`.
- `reviewing-tech-specs` uses `spec.md` when the user names no spec, and says its source and date.
- The `.tech-specs` grep check covers `skills/planning/` only.
- Moving `~/.tech-specs/` is documentation only.

## 9. Left to the builder

- Exact wording of the source/date header of `spec.md`.
- Whether the `.tech-specs` grep check lives per skill or in one shared test.
- Exact wording of the one-line move instruction in the flow doc.
