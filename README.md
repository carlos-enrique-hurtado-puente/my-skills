# my-skills

**English** | [Español](README.es.md)

Personal skills for coding agents (Claude Code, Codex). One repo, many skills, installed by symlink.

## Skills

| Skill | Description | Invocation (manual) | Docs |
|---|---|---|---|
| `stack-code-review` | Code review of changes in any stack, from a GitHub PR URL or the current local branch against its base. | `/stack-code-review` (Claude Code), `$stack-code-review` (Codex) | [docs/skills/stack-code-review.md](docs/skills/stack-code-review.md) |

Skills run only when you invoke them explicitly.

## Layout

```
skills/<name>/       ← one folder per skill (SKILL.md, agents/, references/, scripts/); this is what gets installed
docs/skills/<name>.md ← usage docs for each skill
docs/                ← design and plan documents
tests/<name>/        ← tests and scenarios for each skill (not installed)
tests/install/       ← tests for install.sh
install.sh           ← installer
```

## Installation

```bash
bash install.sh              # Claude Code and Codex
bash install.sh --claude     # Claude Code only (~/.claude/skills)
bash install.sh --codex      # Codex only (~/.agents/skills)
```

The script creates one symlink per folder in `skills/*/`. It is idempotent, creates missing parent directories, and never overwrites a real folder or a symlink that points elsewhere (it warns on stderr and continues). If a link cannot be created it warns and exits with code 1.

Manual equivalent for one skill (from the repo root):

```bash
mkdir -p ~/.claude/skills ~/.agents/skills
ln -s "$(pwd)/skills/<name>" ~/.claude/skills/<name>   # Claude Code
ln -s "$(pwd)/skills/<name>" ~/.agents/skills/<name>   # Codex
```

## Adding a skill

1. Create `skills/<name>/SKILL.md`. The folder name must equal the `name` in its frontmatter.
2. Make it manual-only:
   - Claude Code: `disable-model-invocation: true` in the `SKILL.md` frontmatter.
   - Codex: `skills/<name>/agents/openai.yaml` with `policy: { allow_implicit_invocation: false }`.
3. Write it with test-driven discipline (`superpowers:writing-skills`): run a baseline scenario without the skill (RED), write the skill (GREEN), then pressure-test it (REFACTOR). Put scenarios and scripts in `tests/<name>/`, as `tests/stack-code-review/` does.
4. Add a row to the table above and a page in `docs/skills/<name>.md` (plus `<name>.es.md` if you want a translation).
5. Run `bash install.sh`.

## Conventions

- English is the primary language of everything in the repo. Spanish is only a translation, as a separate `*.es.md` file linked from the English one.
- Each skill is self-contained inside its folder; shared pieces are not factored out across skills.

## Development

From the repo root:

```bash
bash tests/install/test-install.sh   # install.sh with a temporary HOME
```

Each skill's own tests are listed on its docs page.
