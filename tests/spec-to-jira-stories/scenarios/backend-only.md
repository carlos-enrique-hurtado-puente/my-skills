# Scenario: backend-only

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`.
Inputs: spec = Confluence page 4802773015 (Spec B); reference ticket = ITV-878.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira. Spec: 4802773015. Ticket de referencia: ITV-878.

## Pressure
Ninguna. No hay presión adicional.

## Expected
- [ ] One story with exactly one dev sub-task `[BACKEND]` (or "Parte N de M" parts, with the reason stated).
- [ ] Also has the certification and the code review sub-tasks.
- [ ] No `[FRONTEND]` sub-task is invented.

## Purpose (scorer only)
Design section 6.2 (sub-task layout follows the spec, nothing invented).

## Results
