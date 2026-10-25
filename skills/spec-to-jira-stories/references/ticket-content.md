# Ticket content by type

Load this when writing the draft. The content rules here are the method; the labels come from the reference ticket.

The model is the source team's newer generation of tickets (ITV-878 and ITV-883 with their sub-tasks), not the older one (ITV-813, ITV-831), which copied file-and-line checklists from the spec. When the reference ticket is of the older kind, keep its labels and follow these structures, and tell the developer.

## Labels from the reference ticket

The reference ticket supplies only labels. Read them in one pass and keep them in one list, so this step can later be replaced (for example by a saved team profile):

- project key (confirm it with the developer before creating);
- story title prefix (`<story-prefix>`, source team: `HU | <name>`);
- section names and language;
- sub-task role prefixes (`<role-prefix>`) and the issue type of each;
- sub-task title patterns.

Read the reference's sub-tasks by key through the Atlassian tools, or ask the developer to paste them.

If the reference lacks a piece, use the default label and say which ones you used:

| Piece | Spanish default | English default |
|---|---|---|
| Backend development | `[BACKEND]` | `[BACKEND]` |
| Frontend development | `[FRONTEND]` | `[FRONTEND]` |
| Full-stack development | `[FULL]` | `[FULL]` |
| Certification | `[CERTIFICACIÓN]` | `[QA]` |
| Code review | `[REVISIÓN]` | `[CODE REVIEW]` |

Never copy from the reference: emojis (drop them from headings), file-and-line checklists, hours, dates, sprint, priority or labels.

## Story

Basis: Jeffries' 3 Cs. The card holds just enough to identify and remind; the detail lives in the conversation (here, the spec); confirmation is the acceptance tests.

```
Title: <story-prefix> <name>

<What we will build>
<Current problem: two to four sentences.>
<Solution: what changes for the user or the system, in prose.>
<Out of scope>: <what this story does not do, from the spec.>

<Links>
- Spec: <link>
- <If split: related story <key or title>, and why they are separate.>

<Sub-tasks>
- <role-prefix> <title>
- <certification prefix> <title>
- <code review prefix> <title>

<Acceptance criteria>
- [ ] <observable by a user or QA, taken from the spec>
- [ ] ...
```

A summary, not a copy of the spec. Acceptance criteria come from the spec; if the spec has none, ask whether to derive them or wait for the author, and mark derived ones as derived (for example "(derived from <section>)").

## Development sub-task

Basis: Google small CLs and CL descriptions (what plus why); Wake SMART (specific, measurable).

```
Type: <development issue type from the reference>
Title: <role-prefix> <what it builds, as a short statement> [(Parte N de M)]

<Links>
- Spec: <link>
- Story: <parent>

<What to do>
<Topic 1>: <behavior and decisions in prose.>
<Topic 2>: ...

<Notes>
- <target branch, deploy order, dependencies, open questions for the tech lead, if the spec has them>
- <if split: why, and the order between parts>

<Acceptance criteria>
- [ ] <the story criteria this part covers>

<Verification>
- <one or two manual checks a developer can run>
```

Example title: "Segunda barrera: validar que el agente exista y esté publicado al publicar el flujo". No `file.ts:123` lists; name a module or concept only when the spec fixes it.

## Certification sub-task

Basis: ISTQB test case components (preconditions, steps, observable expected result, traceability to the requirement).

```
Type: <certification issue type from the reference>
Title: <certification prefix> Pruebas Funcionales — <story-prefix> <name>
Parent: <story>

<Preparation>
- <data and environment QA needs before starting>

| # | Criterion | Steps | Expected result | Result (Cumple / No cumple / No aplica) |
|---|---|---|---|---|
| 1 | <story criterion> | <steps> | <observable result> | |
| 2 | <negative case: what must not happen> | ... | ... | |
| 3 | <edge case from the spec's risks> | ... | ... | |
```

Every acceptance criterion of the story gives at least one row; no row without a criterion. Add negative cases and edge cases from the spec's risks, tied to the criterion they protect. English result values: Pass / Fail / N/A.

## Code review sub-task

Basis: Google, what to look for in a code review (design and functionality first).

```
Type: <code review issue type from the reference>
Title: <code review prefix> Code Review — <story-prefix> <name>
Parent: <story>

<Pay attention to>
- <a key decision or risk from the spec the reviewer must check>
- ...

<PRs>
- PR #[pendiente] — [<repo>] <what changes>   (one line per development sub-task)
```

Example "pay attention to" item: "que `normalizeRecoveryConfig` quede completamente eliminado".
