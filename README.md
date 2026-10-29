# my-skills

**English** | [Español](README.es.md)

Personal skills for coding agents (Claude Code, Codex). One repo, many skills, installed by symlink.

## Skills

Skills run only when you invoke them explicitly.

### Planning: from requirement to tickets

| Skill | Description | Invocation (manual) | Docs |
|---|---|---|---|
| `discovering-tech-changes` | Understand a requirement and the code it touches and prepare a discovery brief before writing the tech spec. | `/discovering-tech-changes` (Claude Code), `$discovering-tech-changes` (Codex) | [docs/skills/planning/discovering-tech-changes.md](docs/skills/planning/discovering-tech-changes.md) |
| `writing-tech-specs` | Prepare, write and review technical specs: write from a discovery brief (see `discovering-tech-changes`) and check a nine-principle checklist before freezing. | `/writing-tech-specs` (Claude Code), `$writing-tech-specs` (Codex) | [docs/skills/planning/writing-tech-specs.md](docs/skills/planning/writing-tech-specs.md) |
| `spec-to-jira-stories` | Turn a technical spec into Jira stories and sub-tasks (development, certification, code review) and create them after confirmation. | `/spec-to-jira-stories` (Claude Code), `$spec-to-jira-stories` (Codex) | [docs/skills/planning/spec-to-jira-stories.md](docs/skills/planning/spec-to-jira-stories.md) |

These three skills form a chain, and each also works alone:

1. `discovering-tech-changes` turns a requirement and the code it touches into a discovery brief.
2. `writing-tech-specs` writes the spec from that brief (or without one, listing the gaps as open questions) and checks it before the freeze. It then offers `/spec-to-jira-stories`.
3. `spec-to-jira-stories` turns any spec into Jira stories and sub-tasks. When the spec has a decisions table, it warns about rows that still block the freeze.

Each skill reads the previous one's document if you give it, and never needs the previous skill to have run. You start the next one yourself.

### Code: writing and reviewing code

| Skill | Description | Invocation (manual) | Docs |
|---|---|---|---|
| `stack-code-review` | Code review of changes in any stack, from a GitHub PR URL or the current local branch against its base. | `/stack-code-review` (Claude Code), `$stack-code-review` (Codex) | [docs/skills/code/stack-code-review.md](docs/skills/code/stack-code-review.md) |
| `express-best-practices` | Rules for writing, changing and reviewing Express.js code on Express 4 or 5: middleware, routes, errors, sessions, security, production. | `/express-best-practices` (Claude Code), `$express-best-practices` (Codex) | [docs/skills/code/express-best-practices.md](docs/skills/code/express-best-practices.md) |

## Layout

```
skills/<category>/<name>/        ← one folder per skill (SKILL.md, agents/, references/, scripts/); this is what gets installed
docs/skills/<category>/<name>.md ← usage docs for each skill
docs/plans/                      ← design and plan documents
tests/<category>/<name>/         ← tests and scenarios for each skill (not installed)
tests/install/                   ← tests for install.sh
install.sh                       ← installer
```

Categories are `planning` and `code`, the same in `skills/`, `docs/skills/` and `tests/`. They exist only in the repo: installed skills are flat, by name.

## Installation

```bash
bash install.sh              # Claude Code and Codex
bash install.sh --claude     # Claude Code only (~/.claude/skills)
bash install.sh --codex      # Codex only (~/.agents/skills)
```

The script creates one symlink per folder in `skills/*/*/`, named after the skill (`~/.claude/skills/<name>`, no category). It is idempotent, creates missing parent directories, and never overwrites a real folder or a symlink that points elsewhere (it warns on stderr and continues). The one exception is a link to the same skill's old path from before categories (`skills/<name>`), which it replaces. If a link cannot be created it warns and exits with code 1.

Manual equivalent for one skill (from the repo root):

```bash
mkdir -p ~/.claude/skills ~/.agents/skills
ln -s "$(pwd)/skills/<category>/<name>" ~/.claude/skills/<name>   # Claude Code
ln -s "$(pwd)/skills/<category>/<name>" ~/.agents/skills/<name>   # Codex
```

## Adding a skill

The full process (manual-only invocation, test-driven writing with `superpowers:writing-skills`, tests, docs) is in [AGENTS.md](AGENTS.md), which coding agents read automatically. In short: pick a category, create `skills/<category>/<name>/SKILL.md`, add its tests under `tests/<category>/<name>/`, its page under `docs/skills/<category>/<name>.md` and a row in its category's table above, then run `bash install.sh`.

## Conventions

- English is the primary language of everything in the repo. Spanish is only a translation, as a separate `*.es.md` file linked from the English one.
- Each skill is self-contained inside its folder; shared pieces are not factored out across skills.

## Development

From the repo root:

```bash
bash tests/install/test-install.sh   # install.sh with a temporary HOME
bash tests/code/stack-code-review/check-structure.sh
bash tests/code/express-best-practices/check-structure.sh
bash tests/planning/writing-tech-specs/check-structure.sh
bash tests/planning/spec-to-jira-stories/check-structure.sh
bash tests/planning/discovering-tech-changes/check-structure.sh
bash tests/planning/discovering-tech-changes/check-scenarios.sh
```

Each skill's own tests are listed on its docs page.

## License

[MIT](LICENSE)
