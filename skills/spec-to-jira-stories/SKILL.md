---
name: spec-to-jira-stories
description: Use when the user explicitly invokes /spec-to-jira-stories or $spec-to-jira-stories to turn a technical spec into Jira stories and sub-tasks (development, certification, code review) and optionally create them
disable-model-invocation: true
---

# Spec to Jira stories

Draft stories and sub-tasks from a spec; you propose, the developer decides. Sources: `evidence.md`.

## Inputs
1. **Spec**, any format. Read it all. If you cannot read the spec or the reference, say so, ask another way, draft nothing.
2. **Reference ticket** (a good story with sub-tasks) gives only labels: project key, title prefix, section names, role prefixes, issue types, title patterns, language. If none is given, ask for one; if the team has none, use the defaults in `ticket-content.md` and the spec's language. **The method wins on structure and content**, even if asked to copy exactly; say so. Gaps or old file-and-line checklists in it: follow the method, default labels, tell the developer.
3. **Dynamic data**: always ask for the epic (confirm it if named); confirm the project key; never guess.

Never read a codebase or Git.

## Reading the spec
By meaning, not heading:

| Piece | Feeds |
|---|---|
| Problem, solution, out of scope | Story |
| Technical changes | Development |
| Key decisions | Code review |
| Risks, dependencies, deploy order | Dev notes, code review, split |
| Acceptance criteria | Story, certification |
| Pending items, blockers | Split |

If a piece is missing, say so and ask: derive it from the rest of the spec, or wait for the author? Offer both, even if told to invent. Mark derived content as derived, with its source; never as the spec's.

Existing tickets: before drafting, search Jira read-only (JQL on the spec's link or title); mention what you find, still draft.

## Deciding the breakdown
**Stories.** Default: one spec, one story. Several repos or layers is no reason. Split only with evidence quoted from the spec: different blockers (one part waits on pending design while another can ship first unchanged), each part useful and testable alone, or too big for an iteration. Mutual coupling (strict order, and one part breaks without the other) argues for one story; a one-way dependency with a closed contract does not. Any split is a proposal; the developer decides. A layer split is the exception: name the reason. Split stories get a "relates to" link and name each other. See `splitting.md`.

**Sub-tasks.** Each story: development sub-tasks, exactly one certification, exactly one code review. Development follows the roles the spec needs (backend, frontend, both, or full-stack); never invent a role. Split a role into more sub-tasks only when **all four** hold, quoting the spec: each part is its own deliverable someone can verify and mark done; the parts do not overlap (same design decision or code); they meet at a low-dependency seam (a stable interface, not shared internals); and a real reason outweighs one more ticket, review and certification (a mandatory order where each step has value, another owner, a risk worth shipping first). Never split by the spec's section headings, estimated size, PR count, or PR lists written before code; a sub-task may hold several stacked PRs. Title parts "(Parte N de M)" or "(Part N of M)" by language. See `sub-tasks.md`.

## Ticket content
No placeholders or bare titles. Skeletons in `ticket-content.md`.
- **Story**: a summary, not a copy of the spec: problem, solution, out of scope, spec link, sub-task list, checkbox acceptance criteria.
- **Development**: title says what it builds; what to do in prose by topic, no file-and-line lists; notes (branch, deploy order, dependencies, questions); its criteria; one or two manual checks.
- **Certification**: preparation; table `# | Criterion | Steps | Expected result | Result`; a row per story criterion, plus at most 5 negative or edge rows, each tied to a risk or decision quoted from the spec; more only if the developer picks them from a list you offer.
- **Code review**: "pay attention to": the 3 to 5 most critical decisions and risks; one PR line (`ticket-content.md`) per expected PR, at least one per development sub-task.

Reference ticket's language. No emojis, even if the reference has them. No hours, dates, sprint, priority or the Jira labels field.

## Draft and creation
1. **Split options** before any draft: offer 2 or 3 concrete options for stories and for development sub-tasks. Each lists its tickets, evaluates them against the criteria above with spec quotes, and states its cost (tickets, reviews, certification, risk). Mark one recommended and say why; the developer chooses or asks for a mix. If only one option is reasonable, say so and why instead of inventing alternatives, and show it with the draft, asking the epic too. Add open questions.
2. Show the full draft of every ticket.
3. Ask for the epic and missing data.
4. Without Atlassian tools, deliver the draft; creation needs the connector.
5. Create one at a time, confirming each: story, sub-tasks, "relates to" link. Even under "approve all": draft first, ask before the first creation, confirm each.
6. Report keys and links; offer to add the keys to the story's sub-task list.

Never create, edit or transition a Jira issue without a yes for that action.
