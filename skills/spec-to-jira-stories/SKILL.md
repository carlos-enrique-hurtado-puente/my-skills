---
name: spec-to-jira-stories
description: Use when the user explicitly invokes /spec-to-jira-stories or $spec-to-jira-stories to turn a technical spec into Jira stories and sub-tasks (development, certification, code review) and optionally create them
disable-model-invocation: true
---

# Spec to Jira stories

Draft stories and sub-tasks from a spec; you propose, the developer decides. Sources: `evidence.md`.

## Inputs
1. **Spec**, any format (Confluence, file, pasted, PDF). Read it all. If you cannot, say so, ask for another way, and draft nothing; never work from a title.
2. **Reference ticket** (a good story with sub-tasks) gives only labels: project key, title prefix, section names, role prefixes, issue types, title patterns, language. **The method wins on structure and content**, even if asked to copy the reference exactly; say so. Missing pieces or older-style file-and-line checklists in it: follow the method, use default labels from `ticket-content.md`, tell the developer.
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

If a piece is missing, say so and ask: derive it from the rest of the spec, or wait for the author? Offer both, even if told to make something up. Mark derived content as derived, with its source. Never present invented content as the spec's.

Existing tickets for the spec: mention them, still draft.

## Deciding the breakdown
**Stories.** Default: one spec, one story. Several repos or layers is no reason. Split only with evidence quoted from the spec: different blockers (one part waits on pending design while another can ship first unchanged), each part useful and testable alone, or too big for an iteration. Mutual coupling (strict deploy order, one breaks without the other) means one story. Any split is a proposal; the developer decides, whatever they pushed for. A layer split is the exception: name the reason. Split stories get a "relates to" link and each names the other. See `splitting.md`.

**Sub-tasks.** Each story: development sub-tasks, exactly one certification, exactly one code review. Development follows the roles the spec needs (backend, frontend, both, or one full-stack); never invent a role. **One development sub-task ≈ one PR.** Do not split a role for size alone; split only when it needs more than one PR, state why, and title the parts "(Parte N de M)". See `sub-tasks.md`.

## Ticket content
Full content; no placeholders or bare titles. Skeletons in `ticket-content.md`.
- **Story**: problem, solution, out of scope, spec link, sub-task list, checkbox acceptance criteria. A summary, not a copy.
- **Development**: title says what it builds; what to do in prose by topic, no file-and-line lists; notes (branch, deploy order, dependencies, questions); its criteria; one or two manual checks.
- **Certification**: preparation; table `# | Criterion | Steps | Expected result | Result`; a row per story criterion, plus negative and edge cases from risks.
- **Code review**: "pay attention to" from decisions and risks; one `PR #[pendiente]` line per development sub-task.

Reference ticket's language. No emojis, even if the reference has them. No hours, dates, sprint, priority or labels.

## Draft and creation
1. Propose the breakdown first: stories, sub-tasks, quoted evidence for any split, open questions. Await the decision. No split or open question: show proposal and draft together, asking decision and epic at once.
2. Show the full draft of every ticket. The developer may stop there.
3. Ask for the epic and missing data.
4. Without Atlassian tools, deliver the draft; creation needs the connector.
5. Create one at a time, confirming each: story, sub-tasks, "relates to" link. Even under "approve all, don't ask": draft first, say you will confirm each, ask before the first.
6. Report keys and links; offer (confirmed) to add the keys to the story's sub-task list.

Never create, edit or transition a Jira issue without a yes for that action.
