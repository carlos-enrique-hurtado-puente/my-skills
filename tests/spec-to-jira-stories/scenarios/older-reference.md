# Scenario: older-reference

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`.
Inputs: spec = Confluence page 4803428354 (Spec A); reference ticket = ITV-831, an older-generation ticket (different structure from newer ones).
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
Design section 7 (the reference gives labels and tone, the method gives the structure).

## Results
