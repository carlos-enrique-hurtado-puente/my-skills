# Scenario: one-story-two-layers

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`.
Inputs: spec = Confluence page 4858511386 (HU-05 Validación previa a publicar); reference ticket = ITV-878.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira. Spec: 4858511386. Ticket de referencia: ITV-878.

## Pressure
Toca flow-builder y cloudfunctions, eso son dos stories, ¿no?

## Expected
- [ ] Proposes one story, not two.
- [ ] Gives a reason for one story that is not "it is one repo" and does not split only because two repos are touched.
- [ ] Dev sub-tasks are `[BACKEND]` and `[FRONTEND]`.
- [ ] Has exactly one `[CERTIFICACIÓN]` and one `[REVISIÓN]` sub-task.
- [ ] The story has problem, solution, out of scope, spec link, sub-task list and checkbox acceptance criteria.
- [ ] Dev sub-tasks describe "what to do" in prose, with no `file:line` references.
- [ ] The certification sub-task has a Preparation section and a table covering every acceptance criterion of the story.
- [ ] The code review sub-task lists one PR line per dev sub-task and a "pay attention to" block drawn from the spec decisions and risks.
- [ ] Asks which epic the story belongs to.
- [ ] No emojis; no hours or dates.

## Purpose (scorer only)
Design sections 6.1 and 6.2 (one story per observable outcome, sub-task layout and ticket content), against the pull to split by repo.

## Results

### baseline — 2026-10-25
- Verdict: FAIL (6 of 10 bullets).
- One story — PASS ("No, es una sola story con dos sub-tasks de desarrollo").
- Reason not repo-based — PASS ("Una story es un resultado de usuario entregable y verificable, y no un repo o una capa").
- BACKEND/FRONTEND dev sub-tasks — PASS (`[BACKEND] Segunda barrera...` and `[FRONTEND] Error en el nodo de agente...`).
- One CERTIFICACIÓN and one REVISIÓN — PASS (one of each is listed as sub-tasks 3 and 4).
- Story content — FAIL (the description is only a placeholder, "<mismo formato que ITV-878...>". No problem or solution text is written, and the sections are only named).
- Dev sub-tasks in prose, no file:line — PASS (they list classes and file names such as `agent-node.shape.ts`, with no line numbers).
- Certification Preparation and criteria table — FAIL (only the title is given, with no Preparation section or table).
- Code review PR lines and "pay attention to" block — FAIL (only the title is given, with no PR lines or attention block).
- Asks which epic — FAIL (it assumes "parent ITV-49" and asks about estimation, sprint, assignee and dates, but not the epic).
- No emojis, hours or dates in the tickets — PASS (the "5h" and "Sprint 17" appear only in the confirmation questions, not in the proposed ticket content).
- Notable phrase: "Una story es un resultado de usuario entregable y verificable, y no un repo"
- Classification: **discriminating**
