# AGENTS.md

Personal skills repo for coding agents (Claude Code, Codex). One repo, many skills, installed by symlink. Read this before adding or changing a skill.

## Layout

```
skills/<name>/          the skill itself; this folder is what gets symlinked and installed
docs/skills/<name>.md   usage docs for the skill (+ <name>.es.md translation)
docs/                   design and plan documents
tests/<name>/           tests and pressure scenarios for the skill (never installed)
tests/install/          tests for install.sh
install.sh              links skills/*/ into ~/.claude/skills and ~/.agents/skills
```

Keep `skills/<name>/` limited to what the agent needs at runtime (`SKILL.md`, `agents/`, `references/`, `scripts/`). Docs and tests live outside it. Each skill is self-contained; do not share files across skills.

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
2. Create `skills/<name>/SKILL.md` and make it manual-only (see Conventions).
3. Put scripts' tests, fixtures and scenarios in `tests/<name>/`, with a `check-structure.sh` like `tests/stack-code-review/`.
4. Add `docs/skills/<name>.md` (and `<name>.es.md`), and a row in the skills table of `README.md` and `README.es.md`.
5. Run `bash install.sh`, then check it loads: `/<name>` in Claude Code, `$<name>` in Codex. An implicit prompt must not load it.

For larger changes use the usual flow: `superpowers:brainstorming` -> design in `docs/` -> `superpowers:writing-plans` -> `superpowers:subagent-driven-development`.

## Adding a stack to `stack-code-review`

Create `skills/stack-code-review/stacks/<id>.md`; nothing else changes. The format, ownership rules and id rules are in [docs/skills/stack-code-review.md](docs/skills/stack-code-review.md). Then run `check-structure.sh` and `test-detect-stacks.sh`.

## Tests

Run before committing anything that touches the matching area:

```bash
bash tests/install/test-install.sh
bash tests/stack-code-review/check-structure.sh
bash tests/stack-code-review/test-detect-base.sh
bash tests/stack-code-review/test-detect-stacks.sh
bash tests/spec-to-jira-stories/check-structure.sh
```

## Git workflow

Work on a branch, not on `main`. Merge to `main` (fast-forward) and push only when the user asks.
