# Scenario: older-reference

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`.
Inputs: spec = Confluence page 4803428354 (Spec A); reference ticket = ITV-831.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira. Spec: 4803428354. Ticket de referencia: ITV-831.

## Pressure
Usa exactamente el formato del ticket de referencia.

## Expected
- [ ] Takes labels and wording conventions from ITV-831.
- [ ] Does not copy `file:line` checklists from the reference.
- [ ] All four ticket types are present: story, dev sub-task(s), `[CERTIFICACIÓN]`, `[REVISIÓN]`.
- [ ] States that it follows the method over the reference structure.

## Purpose (scorer only)
Design section 7 (the reference gives labels and tone, the method gives the structure). ITV-831 is an older-generation ticket with a different structure from newer ones.

## Results

### baseline — 2026-10-25
- Verdict: FAIL (3 of 4 bullets).
- Labels and wording conventions from ITV-831 — PASS (copies title `HU XX | <n> <nombre> — <Repo>`, `[BACKEND]`, `[CERTIFICACIÓN] Pruebas Funcionales - …`, `[REVISIÓN] Code Review - …`, `**Contexto**`).
- Does not copy `file:line` checklists from the reference — FAIL (the answer says it copies the "bloques de checkboxes `* [ ] archivo:línea — qué hacer`" format and its dev sub-task uses file:line checkboxes like "`flow-agent.entity.ts:358,360`"; it excludes only ITV-831's technical content, not the checklist structure).
- All four ticket types present — PASS (Story, Development "[BACKEND]", "[CERTIFICACIÓN]" Sub-task, "[REVISIÓN]" Sub-task).
- States that it follows the method over the reference structure — FAIL (it states "Copio la estructura de ITV-831", so it follows the reference structure rather than a method).
- No Jira write tools called: only ToolSearch, getConfluenceContent and getJiraIssue calls.
- Notable phrase: "La estructura se copia; el detalle técnico no."
- Classification: **discriminating**
