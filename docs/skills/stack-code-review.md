# stack-code-review

**English** | [Español](stack-code-review.es.md)

Code review of changes in any stack, from a GitHub PR URL or from the current local branch against its base. Source: [`skills/stack-code-review/`](../../skills/stack-code-review/SKILL.md).

## Usage

In Claude Code: `/stack-code-review`. In Codex: `$stack-code-review`.

With a PR URL it reviews that PR; with no arguments it reviews the current local branch against its base (local mode first stops to ask for confirmation). GitHub mode requires `gh` installed and authenticated.

```text
/stack-code-review https://github.com/org/repo/pull/123
/stack-code-review
/stack-code-review base: main
/stack-code-review spec: ./docs/path.md
/stack-code-review https://github.com/org/repo/pull/123 spec: https://yourcompany.atlassian.net/browse/PROJ-456
```

- `base:` (local mode only) sets the base branch and skips auto-detection.
- `spec:` accepts a local path, a URL (for example a Jira ticket) or pasted text.

## Running it in a subagent

You can ask the session to delegate the review ("send an agent to review this branch with /stack-code-review"). The delegating session follows [`references/subagent-dispatch.md`](../../skills/stack-code-review/references/subagent-dispatch.md):

- It dispatches a fresh general-purpose agent (never a fork) with a fixed prompt template.
- **Model:** the one you name; otherwise, if the session wrote the changes under review, a different model that is not a lightweight one (an independent reviewer); otherwise the session's own model. Asking for "cheap" or "fast" never selects a lightweight model.
- **Reply:** the subagent's message comes first and unchanged, then `---` and a line saying which model reviewed. Confirmation and spec questions are relayed the same way, and your answer goes back to the same subagent.

## Connectors

Reading a spec from a URL depends on the MCP servers/tools configured in each tool. Claude Code and Codex are configured separately, so a connector available in one is not necessarily available in the other. If the URL cannot be read, the skill asks for the spec as markdown.

## How stacks work

The skill detects the stacks in the diff with `scripts/detect-stacks.sh` and loads only the pieces (`stacks/<id>.md`) that own at least one changed file. Each piece applies its checklist only to the files it owns; the report format, severity scale and verdict always come from the core.

### Adding a stack

Create `skills/stack-code-review/stacks/<id>.md`. Nothing else needs to change: the script discovers pieces on its own.

```markdown
---
id: express
name: Express
detect:
  dependencies: [express]        # decides which files belong to the piece
  files: ["**/routes/*.js"]      # optional: only breaks ties or covers files outside every root
  imports: [express]             # optional: same as files
skills: [my-express-skill]       # skills the piece consults (may be [])
context_fields: [Express version, Test framework]
---

## Context detection
## Checklist
## How to use the skills
## Clean Architecture in this stack
## Severity notes
## Common mistakes
```

How ownership is decided: `dependencies` determines which files belong to the piece (roots are the directories whose `package.json` declares the dependency); `files` and `imports` only break ties when several pieces share a root, or cover files outside every root. The `id` must equal the file name (`stacks/<id>.md`) and match `^[a-z0-9][a-z0-9-]*$`; otherwise the script skips the piece (`skipped_piece: ... id-mismatch | bad-id | duplicate-id`).

The six body sections go in that order. A piece never redefines the report format, severity scale or verdict. Afterwards run `bash tests/stack-code-review/check-structure.sh` and `bash tests/stack-code-review/test-detect-stacks.sh`.

### Fallback: files without a piece

If no piece owns a file (`owner: ... none`), only the general criteria plus the model's knowledge of its framework apply. Every finding on that file carries the `[model knowledge]` tag, the `Stack(s):` header marks it as "model knowledge (lower confidence)", and `Limitations` names the skill found by search or recommends installing one for that framework.

### Recommended skills

The pieces and the general criteria consult these when installed (if missing, it is noted in `Limitations` and the review continues):

- `clean-architecture` and `clean-code` (by wondelai).
- `angular-developer` (Angular piece).

## Tests

```bash
bash tests/stack-code-review/check-structure.sh    # skill structure
bash tests/stack-code-review/test-detect-base.sh   # scripts/detect-base.sh against test repos
bash tests/stack-code-review/test-detect-stacks.sh # scripts/detect-stacks.sh against test repos
python3 tests/stack-code-review/relay-check.py <report> <reply>  # a relayed reply carries the subagent report unchanged
```

The skill's pressure scenarios (run by a subagent and scored by a separate scorer agent that never ran the scenario) are described in [`tests/stack-code-review/README.md`](../../tests/stack-code-review/README.md).
