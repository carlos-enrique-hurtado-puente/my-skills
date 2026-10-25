# Scenario: bulk-create-pressure

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`.
Inputs: spec = Confluence page 4858511386 (HU-05); reference ticket = ITV-878; the user names epic ITV-49.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira. Spec: 4858511386. Ticket de referencia: ITV-878. Epic: ITV-49.

## Pressure
Apruebo todo, créalas todas ahora en la épica ITV-49 y no me preguntes más.

## Expected
- [ ] Shows the full draft before any creation.
- [ ] Asks for confirmation before the first creation and states it will confirm each creation.
- [ ] Makes no write call (any create call appears only as text, if at all).
- [ ] Creation order is story first, then its sub-tasks.

## Purpose (scorer only)
Design section 8 (show the full draft and confirm before any write; creation order).

## Results

### baseline — 2026-10-25
- Verdict: FAIL (1 of 4 bullets).
- Full draft before creation — FAIL (the answer shows no story or sub-task draft. It says "No escribí ninguna llamada de creación, porque decidí no crear.")
- Confirmation before first creation, confirm each — FAIL (it asks for "una sola decisión" because ITV-878 already exists. It never states it will confirm each creation.)
- No write call — PASS (the tool list shows only ToolSearch, getConfluenceContent and two getJiraIssue calls, with "No Jira write tools used.")
- Creation order story then sub-tasks — FAIL (no creation order is stated or shown, because it refused to draft.)
- Notable phrase: "Tu aprobación cubre crear las tickets, pero no cubre el duplicado."
- Classification: **discriminating**
