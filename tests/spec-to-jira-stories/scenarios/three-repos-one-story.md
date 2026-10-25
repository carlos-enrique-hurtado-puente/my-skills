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

### baseline — 2026-10-25
- Verdict: PASS (4 of 4 bullets).
- Proposes one story — PASS ("Armé una sola story con seis sub-tasks y no tres stories por repo")
- Quotes deploy order as reason — PASS (cites "El spec fija el orden de deploy acf -> abf -> agent-builder" and the CONVERSATION_TYPE_PERSIST_FAILED consequence)
- Dev sub-tasks organized by role — PASS ([BACKEND acf], [BACKEND abf] x2, [FRONTEND agent-builder], [CERTIFICACIÓN], [REVISIÓN]; backend spans acf and abf, which the bullet allows)
- No story per repo — PASS (only one createJiraIssue Story plus 6 sub-tasks; no Jira write tools called)
- Notable phrase: "Ninguna entrega valor sola."
- Classification: **guard**

### green-1 — 2026-10-25
- Verdict: PASS (4 of 4 bullets).
- Proposes one story, not one per repo — PASS ("**No separo por repo. Propongo una sola story.**" with a single STORY and 6 sub-tasks)
- Quotes deploy order / publish validation coupling as reason — PASS (quotes the spec: "**Orden de deploy**: `atom-cloudfunctions` tiene que tener el endpoint y el campo **antes**... acf → abf → agent-builder", plus the front/publish-validation coupling)
- Dev sub-tasks organized by role — PASS ([BACKEND] x3 covering acf and abf, [FRONTEND], [CERTIFICACIÓN], [REVISIÓN]; backend may group acf and abf)
- No story created per repo — PASS (only one story drafted; "No creé nada"; no Jira write tools in the tool list, only getConfluenceContent and getJiraIssue)
- Notable phrase: "tocar varios repos no es motivo para dividir una story"

### green-options-1 — 2026-10-25
- Verdict: PASS (4 of 4 bullets).
- Proposes one story, not one per repo — PASS (Option A "(recomendada)" is "Una story"; the answer rejects the per-repo split.)
- Quotes deploy order / publish coupling as reason — PASS (cites "acf → abf → agent-builder" and the front deployed before publish validation.)
- Dev sub-tasks organized by role; backend may group abf/acf — PASS (Recommends [BACKEND] acf, [BACKEND] abf, [FRONTEND]; the bullet allows grouping, and splitting backend by repo is still role-based.)
- No story created per repo — PASS (A single story is drafted. The Runner tools list shows only reads, with no Jira write tool, and the answer says "No creo nada en Jira".)
