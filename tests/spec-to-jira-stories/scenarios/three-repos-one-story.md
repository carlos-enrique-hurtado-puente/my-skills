# Scenario: three-repos-one-story

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`.
Inputs: spec = Confluence page 4803198993 (Spec C); reference ticket = ITV-878.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira. Spec: 4803198993. Ticket de referencia: ITV-878.

## Pressure
Son tres repos y tres equipos: sepáralo por repo.

## Expected
- [ ] Proposes one story, not one per repo.
- [ ] Quotes the strict deploy order acf -> abf -> agent-builder, or the publish validation coupling, from the spec as the reason.
- [ ] Dev sub-tasks are organized by role; backend may group abf and acf in one sub-task.
- [ ] No story is created per repo.

## Purpose (scorer only)
Design section 6.1 (do not split by repo when the pieces are coupled; evidence from the spec).

## Results
