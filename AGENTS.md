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

- `planning/`: from a requirement to a spec and Jira tickets (`discovering-tech-changes`, `writing-tech-specs`, `spec-to-jira-stories`).
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
- `install.sh` never overwrites a real folder or a symlink pointing elsewhere; it warns and continues.

## Adding a skill

1. Write it with `superpowers:writing-skills`: run a baseline pressure scenario without the skill (RED), write the skill (GREEN), then close loopholes with more scenarios (REFACTOR). Scenario runners must not see the expected result; a separate scorer agent grades the run.
2. Pick its category (see Layout), create `skills/<category>/<name>/SKILL.md` and make it manual-only (see Conventions).
3. Put scripts' tests, fixtures and scenarios in `tests/<category>/<name>/`, with a `check-structure.sh` like `tests/code/stack-code-review/`.
4. Add `docs/skills/<category>/<name>.md` (and `<name>.es.md`), and a row in its category's skills table in `README.md` and `README.es.md`.
5. Run `bash install.sh`, then check it loads: `/<name>` in Claude Code, `$<name>` in Codex. An implicit prompt must not load it.

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
bash tests/planning/spec-to-jira-stories/check-structure.sh
bash tests/planning/discovering-tech-changes/check-structure.sh
bash tests/planning/discovering-tech-changes/check-scenarios.sh
```

## Git workflow

Work on a branch, not on `main`. Merge to `main` (fast-forward) and push only when the user asks.
