# my-skills

**English** | [Español](README.es.md)

Personal skills for coding agents (Claude Code, Codex). One repo, many skills, installed by symlink.

## Skills

| Skill | Description | Invocation (manual) | Docs |
|---|---|---|---|
| `stack-code-review` | Code review of changes in any stack, from a GitHub PR URL or the current local branch against its base. | `/stack-code-review` (Claude Code), `$stack-code-review` (Codex) | [docs/skills/stack-code-review.md](docs/skills/stack-code-review.md) |
| `express-best-practices` | Rules for writing, changing and reviewing Express.js code on Express 4 or 5: middleware, routes, errors, sessions, security, production. | `/express-best-practices` (Claude Code), `$express-best-practices` (Codex) | [docs/skills/express-best-practices.md](docs/skills/express-best-practices.md) |
| `writing-tech-specs` | Prepare, write and review technical specs: what to gather before writing and a nine-principle checklist before freezing. | `/writing-tech-specs` (Claude Code), `$writing-tech-specs` (Codex) | [docs/skills/writing-tech-specs.md](docs/skills/writing-tech-specs.md) |
| `spec-to-jira-stories` | Turn a technical spec into Jira stories and sub-tasks (development, certification, code review) and create them after confirmation. | `/spec-to-jira-stories` (Claude Code), `$spec-to-jira-stories` (Codex) | [docs/skills/spec-to-jira-stories.md](docs/skills/spec-to-jira-stories.md) |

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

The full process (manual-only invocation, test-driven writing with `superpowers:writing-skills`, tests, docs) is in [AGENTS.md](AGENTS.md), which coding agents read automatically. In short: create `skills/<name>/SKILL.md`, add its tests under `tests/<name>/`, its page under `docs/skills/<name>.md` and a row in the table above, then run `bash install.sh`.

## Conventions

- English is the primary language of everything in the repo. Spanish is only a translation, as a separate `*.es.md` file linked from the English one.
- Each skill is self-contained inside its folder; shared pieces are not factored out across skills.

## Development

From the repo root:

```bash
bash tests/install/test-install.sh   # install.sh with a temporary HOME
bash tests/spec-to-jira-stories/check-structure.sh
```

Each skill's own tests are listed on its docs page.

## License

[MIT](LICENSE)
