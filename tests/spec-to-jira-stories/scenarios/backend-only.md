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
- [ ] One story whose development sub-tasks are all `[BACKEND]`; any proposal of more than one `[BACKEND]` sub-task is justified with the split criteria (own verifiable deliverable, no overlap, low-dependency seam, a real reason worth the extra cost) quoted from the spec, never by size, PR count or the spec's section headings.
- [ ] Also has the certification and the code review sub-tasks.
- [ ] No `[FRONTEND]` sub-task is invented.

## Purpose (scorer only)
Design section 6.2 (sub-task layout follows the spec, nothing invented).

## Results

### baseline — 2026-10-25
- Verdict: FAIL (2 of 3 bullets).
- One [BACKEND] sub-task — FAIL (answer creates three: "Tres sub-tasks [BACKEND] en vez de una, porque la spec es M"; the stated reason is size/risk, not a "Parte N de M" split of one dev sub-task).
- Certification and code review sub-tasks — PASS (includes "[CERTIFICACIÓN] Pruebas Funcionales" and "[REVISIÓN] Code Review").
- No [FRONTEND] invented — PASS ("No [FRONTEND]: all technical changes are backend").
- Tool list check — no Jira write tool called (only ToolSearch, getConfluenceContent, getJiraIssue); no automatic FAIL.
- Notable phrase: "Tres sub-tasks [BACKEND] en vez de una, porque la spec es M"
- Classification: **discriminating**

### green-1 — 2026-10-25
- Verdict: PASS (3 of 3 bullets).
- One [BACKEND] sub-task — PASS (answer states "[BACKEND] Development: una sola, a un PR" and "un solo sub-task y un solo PR"; a possible Parte 1 de 2 / Parte 2 de 2 split is only offered as an open question, with the reason stated).
- Certification and code review sub-tasks — PASS (includes "[CERTIFICACIÓN] Pruebas Funcionales" and "[REVISIÓN] Code Review").
- No [FRONTEND] invented — PASS ("No hay rol frontend: la spec no toca front, así que no invento uno").
- Tool list check — no Jira write tool called (only Read, Bash, ToolSearch, getConfluenceContent, getJiraIssue); no automatic FAIL.
- Notable phrase: "tener una sola capa no justifica dividirla"

### green-options-1 — 2026-10-25
- Verdict: PASS (3 of 3 bullets).
- One story, all dev sub-tasks [BACKEND] — PASS (Final draft has one story and one [BACKEND] sub-task; options B and C are rejected via split criteria: "falla «entregable propio»", "Falla «sin solape»", not by size or PR count.)
- Certification and code review sub-tasks — PASS (Draft includes "[CERTIFICACIÓN] Pruebas Funcionales" and "[REVISIÓN] Code Review".)
- No [FRONTEND] invented — PASS ("no invento otro rol"; no frontend sub-task appears in the draft.)
- Tool check — no Jira write tool called (only reads, searches and Bash jq), so no automatic FAIL.
