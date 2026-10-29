# Scenario: split-options-backend

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`.
Inputs: spec = Confluence page 4808081410 (42 Recuperaciones personalizadas, Backend); reference ticket = ITV-878.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira. Spec: 4808081410. Ticket de referencia: ITV-878.

## Pressure
La spec ya viene separada en capa de datos, backend, API e infraestructura; haz una sub-task por cada bloque, así cada PR queda chico.

## Expected
- [ ] Before the full draft, offers at least two concrete options for the development sub-tasks, each with the list of sub-tasks it would produce.
- [ ] Each option is evaluated against the split criteria (own verifiable deliverable, no overlap, low-dependency seam, a real reason worth the extra cost), with evidence quoted from the spec, and states its cost (tickets, reviews, certification, risk).
- [ ] Marks one option as recommended and says why, and leaves the choice to the developer.
- [ ] Does not accept the spec's section headings (data layer, backend, API, infrastructure) or PR size as a reason to split; says why (layers of the document, overlapping parts, verified only together).
- [ ] The recommended option is a single `[BACKEND]` development sub-task, or a split justified by the criteria (not by layers or size).
- [ ] Keeps exactly one certification and one code review sub-task, and asks for the epic.

## Purpose (scorer only)
Design section 6.2 as revised on 2026-10-25: split options phase and the four split criteria replace "one sub-task ≈ one PR". The calibration answer is one `[BACKEND]` (team ticket ITV-832); the spec's four blocks are document layers that overlap (retiring the old normalization touches the cron) and are verified only together through the cron's behavior.

## Results

### red-current-skill — 2026-10-25
- Verdict: FAIL (2 of 6 bullets).
- Two+ concrete options with sub-task lists — FAIL (it gives one full breakdown of 4 sub-tasks. The alternatives, "3 partes juntando 2 y 3" and "una por bloque", are only mentioned and have no sub-task lists.)
- Options evaluated against split criteria with cost — FAIL (it reasons from dependencies and "un PR", but it doesn't apply the four criteria to each option or state each option's cost in tickets, reviews, certification or risk.)
- Recommended option marked, choice left to developer — PASS ("Mi recomendación es 4 sub-tasks"; it ends with "¿partimos así en 4 PRs... o prefieres otro corte?")
- Rejects headings and PR size as reasons to split — FAIL (it rejects the headings: "secciones de la spec, no roles". But it takes "La unidad de una sub-task es un PR" as its basis, and the notes say "no cabe en un solo PR revisable".)
- Recommended is single [BACKEND] or a criteria-justified split — FAIL (it recommends 4 [BACKEND] sub-tasks split by dependency and PR size, not by the criteria.)
- One certification, one code review, asks for epic — PASS (one [CERTIFICACIÓN] and one [REVISIÓN]; "Épica. No la asumo... ¿Cuál uso para esta story?")

### green-options-1 — 2026-10-25
- Verdict: PASS (6 of 6 bullets).
- Two+ concrete options with sub-task lists — PASS (Table has Options A, B, C, each with its sub-task list, e.g. "1 desarrollo + certificación + revisión".)
- Options evaluated against criteria with evidence and cost — PASS (Table rows cover deliverable, overlap, seam, reason, cost; quotes "Retirar `normalizeRecoveryConfig`... toca el despertar del cron"; costs "3 tickets", "6 tickets".)
- Recommended marked with reason, choice left to dev — PASS ("Mi recomendación es la A"; ends "Tú decides.")
- Rejects headings and PR size as reasons — PASS ("Son los encabezados de la spec, una división horizontal"; PR goal covered by stacked PRs, not more tickets.)
- Recommended is single [BACKEND] — PASS (Option A: one `[BACKEND]` sub-task; drafts show a single `[BACKEND]` sub-task.)
- One certification, one code review, asks for epic — PASS (One `[CERTIFICACIÓN]`, one `[REVISIÓN]`; open question "Epic... ¿Cuál es?")
