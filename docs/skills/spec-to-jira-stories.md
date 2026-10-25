# spec-to-jira-stories

**English** | [Español](spec-to-jira-stories.es.md)

Turns a technical spec into Jira stories and sub-tasks (development, certification, code review), shows the full draft, and creates the tickets only after you confirm each one. Source: [`skills/spec-to-jira-stories/`](../../skills/spec-to-jira-stories/SKILL.md). It was calibrated on the AtomChat team's tickets and is grounded in cited sources on story splitting, small PRs and test design.

## Usage

In Claude Code: `/spec-to-jira-stories`. In Codex: `$spec-to-jira-stories`. The skill is manual-only: it never loads from an implicit prompt.

```text
/spec-to-jira-stories turn this spec into tickets: https://<site>.atlassian.net/wiki/spaces/ENG/pages/12345, reference ABC-123
/spec-to-jira-stories draft the stories for ./specs/digest.md, use ABC-123 as the reference ticket
/spec-to-jira-stories split this spec only if the spec itself gives a reason: <pasted text>
```

- **Inputs:** the spec (Confluence page, local file, pasted text, PDF; if it cannot be read in full, the skill says so and drafts nothing) and a reference ticket, a good story with sub-tasks. The reference gives only labels: project key, title prefix, section names, role prefixes, language. The method decides structure and content, even if you ask to copy the reference exactly. You also give the epic; the skill never guesses it.
- **Split options first:** before any draft it offers you 2 or 3 breakdown options (stories and development sub-tasks), each with its tickets, the criteria it meets with quotes from the spec, and its cost, and marks one as recommended; you choose. One spec is one story by default. It proposes a split only with evidence quoted from the spec (different blockers, parts useful and testable alone, too big for an iteration) and you decide. Each story gets development sub-tasks, one certification and one code review. A development role is split only when each part is its own verifiable deliverable, the parts do not overlap, they meet at a stable interface, and a real reason outweighs the extra ticket; never by the spec's section headings or PR size.
- **Draft:** every ticket in full, with no placeholders: story (problem, solution, out of scope, criteria), development (what to build, notes, checks), certification (a table with a row per criterion plus at most 5 negative or edge cases tied to the spec's risks), code review (the 3 to 5 most critical points to pay attention to, one line per expected PR). Before drafting it searches Jira read-only for tickets already made from the spec and tells you. You may stop here.
- **Creation:** needs the Atlassian connector; without it you get the draft. The skill never creates, edits or transitions a Jira issue without a yes for that action: it asks before the first creation and confirms each one (story, sub-tasks, "relates to" link), even if you say "approve all". It then reports keys and links.

## What is in the skill

| File | Content |
|---|---|
| `SKILL.md` | Inputs, how to read the spec, how to decide the breakdown, ticket content, draft and creation steps |
| `references/splitting.md` | When to split a spec into several stories |
| `references/sub-tasks.md` | Development, certification and code review sub-tasks; split criteria for development and the split options phase |
| `references/ticket-content.md` | Skeletons for each ticket, default labels, PR line format |
| `references/evidence.md` | Sources behind each rule |
| `agents/openai.yaml` | Codex manual-only policy |

## Limits

- Nothing is written to Jira without a yes per action.
- It never reads a codebase or Git; the spec is the only input.
- No hours, dates, sprint, priority or the Jira labels field, and no emojis.
- Tested live and read-only, with one sonnet run per scenario and condition. Jira creation itself was never exercised, so the real create calls are untested. See [what is not covered](../../tests/spec-to-jira-stories/README.md#not-covered).

## Tests

```bash
bash tests/spec-to-jira-stories/check-structure.sh
```

Pressure scenarios (run by hand with a runner and a separate scorer) and their outcome are in [`tests/spec-to-jira-stories/`](../../tests/spec-to-jira-stories/README.md).
