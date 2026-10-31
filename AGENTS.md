# AGENTS.md

Personal skills repo for coding agents (Claude Code, Codex). One repo, many skills, installed by symlink. Read this before adding or changing a skill.

## Layout

```
skills/<category>/<name>/          the skill itself; this folder is what gets symlinked and installed
docs/skills/<category>/<name>.md   usage docs for the skill (+ <name>.es.md translation)
docs/plans/                        design and plan documents
tests/<category>/<name>/           tests and pressure scenarios for the skill (never installed)
tests/install/                     tests for install.sh
install.sh                         links skills/*/*/ flat, by skill name, into ~/.claude/skills and ~/.agents/skills
```

Categories group skills by what they do:

- `planning/`: from a requirement to a spec (`discovering-tech-changes`, `writing-tech-specs`, `reviewing-tech-specs`, `verifying-spec-facts`).
- `code/`: writing and reviewing code (`stack-code-review`, `express-best-practices`).

A skill lives in the same category in `skills/`, `docs/skills/` and `tests/`. Categories exist only in the repo; installed skills are flat, so skill names must be unique across categories. Add a new category only when a skill fits neither.

Keep `skills/<category>/<name>/` limited to what the agent needs at runtime (`SKILL.md`, `agents/`, `references/`, `scripts/`). Docs and tests live outside it. Each skill is self-contained; do not share files across skills.

## Conventions

- **English is the primary language** of everything in the repo (skill files, docs, README, comments). Spanish exists only as a separate `*.es.md` translation linked from the English file. The user chats in Spanish; reply in Spanish, write repo content in English.
- **Manual invocation only**, so skills never compete with other review or workflow skills:
  - Claude Code: `disable-model-invocation: true` in the `SKILL.md` frontmatter.
  - Codex: `agents/openai.yaml` with `policy: { allow_implicit_invocation: false }`.
- The folder name must equal the `name` in the `SKILL.md` frontmatter.
- Shell scripts must work on macOS bash 3.2 and be read-only toward the user's repo (for git use `git --no-optional-locks`).
- Skills never write to the user's repositories; they write only under `~/.tech-specs/`.
- `install.sh` never overwrites a real folder or a symlink pointing elsewhere; it warns and continues.

## Adding a skill

1. Write it with `superpowers:writing-skills`: run a baseline pressure scenario without the skill (RED), write the skill (GREEN), then close loopholes with more scenarios (REFACTOR). Scenario runners must not see the expected result; a separate scorer agent grades the run.
2. Pick its category (see Layout), create `skills/<category>/<name>/SKILL.md` and make it manual-only (see Conventions).
3. Put scripts' tests, fixtures and scenarios in `tests/<category>/<name>/`, with a `check-structure.sh` like `tests/code/stack-code-review/`.
4. Add `docs/skills/<category>/<name>.md` (and `<name>.es.md`), and a row in its category's skills table in `README.md` and `README.es.md`.
5. Run `bash install.sh`, then check it loads: `/<name>` in Claude Code, `$<name>` in Codex. An implicit prompt must not load it.

## Changing a skill

Every change to a skill's behavior (`SKILL.md`, `references/`, the description) follows `superpowers:writing-skills` too, the same as a new skill. Edits to docs, README or typos do not.

1. Write or update the scenario in `tests/<category>/<name>/scenarios/` first: the `Expected` bullets state the new behavior.
2. **RED**: run it against the skill as it is on `main` (a copy of the folder in a scratch directory). It must fail; if it already passes, there is nothing to change.
3. Make the edit. If you edited before RED, save the new version aside, restore `main`'s, and run RED before putting it back.
4. **GREEN**: run the same scenario against the edited skill until it passes; then REFACTOR with more runs or scenarios if a runner finds a loophole.
5. Append each run to the scenario's `## Results` (`red-N`, `green-N`, `refactor-N`, date, verdict, quotes) and update the outcome table in the tests' `README.md`.

Runners get only `Setup`, `Invocation` and `Pressure` plus the skill copy; a separate scorer agent gets `Expected` and the output. Structure checks (`check-structure.sh`) prove the files are well formed, not that the skill behaves; never report a behavior change as done on them alone.

For larger changes use the usual flow: `superpowers:brainstorming` -> design in `docs/plans/` -> `superpowers:writing-plans` -> `superpowers:subagent-driven-development`.

## Adding a stack to `stack-code-review`

Create `skills/code/stack-code-review/stacks/<id>.md`; nothing else changes. The format, ownership rules and id rules are in [docs/skills/code/stack-code-review.md](docs/skills/code/stack-code-review.md). Then run `check-structure.sh` and `test-detect-stacks.sh`.

## Tests

Run before committing anything that touches the matching area:

```bash
bash tests/install/test-install.sh
bash tests/code/stack-code-review/check-structure.sh
bash tests/code/stack-code-review/test-detect-base.sh
bash tests/code/stack-code-review/test-detect-stacks.sh
bash tests/code/express-best-practices/check-structure.sh
bash tests/code/express-best-practices/test-detect-version.sh
bash tests/planning/writing-tech-specs/check-structure.sh
bash tests/planning/discovering-tech-changes/check-structure.sh
bash tests/planning/discovering-tech-changes/check-scenarios.sh
bash tests/planning/reviewing-tech-specs/check-structure.sh
bash tests/planning/reviewing-tech-specs/test-rules-sync.sh
bash tests/planning/verifying-spec-facts/check-structure.sh
bash tests/planning/verifying-spec-facts/test-brief-heading.sh
```

## Git workflow

Work on a branch, not on `main`. Merge to `main` (fast-forward) and push only when the user asks.
