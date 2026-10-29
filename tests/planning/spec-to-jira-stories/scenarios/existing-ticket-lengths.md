# Scenario: existing-ticket-lengths

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`. Read-only Jira searches are allowed.
Inputs: spec = Confluence page 4857626627 (HU-04 Descarga masiva de las conversaciones generadas); reference ticket = ITV-878.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira. Spec: 4857626627. Ticket de referencia: ITV-878.

## Pressure
Quiero que la certificación sea exhaustiva, que no se escape nada.

## Expected
- [ ] Searches Jira read-only (JQL or search) for tickets already linked to this spec, finds ITV-866 (or its sub-tasks) and mentions it, and still drafts.
- [ ] Certification has one row per story acceptance criterion plus at most 5 negative or edge rows, each tied to a risk or decision quoted from the spec (not invented edge cases).
- [ ] Code review "pay attention to" has 3 to 5 points, each from a decision or risk of the spec.
- [ ] Explains to the developer, under the pressure for exhaustive certification, that extra cases beyond the spec's risks are not added, or offers them as optional for the developer to choose.
- [ ] Keeps one story with `[BACKEND]` and `[FRONTEND]` development sub-tasks, one certification and one code review, and asks for the epic.

## Purpose (scorer only)
Design sections 5 and 7 as revised on 2026-10-25: read-only search for existing tickets; certification bounded to criteria plus up to 5 risk-tied negative or edge rows; code review "pay attention to" limited to 3 to 5 points. Calibration: the real ticket ITV-866 has 10 certification rows and only a PR list in its code review.

## Results

### red-current-skill — 2026-10-25
- Verdict: FAIL (1 of 5 bullets). Graded by the controller from the HU-04 run made earlier on the same skill version (not a separate runner/scorer pair).
- Searches for existing tickets — FAIL ("no busqué ninguno"; ITV-866 exists).
- Certification bounded — FAIL (11 criterion rows plus 12 negative or edge rows).
- Code review 3 to 5 points — FAIL (11 points).
- Explains bounded certification under pressure — FAIL (no pressure in that run; no explanation of bounds).
- Structure and epic — PASS (one story, `[BACKEND]` + `[FRONTEND]`, certification, code review; asked for the epic).

### green-1 — 2026-10-25
- Verdict: PASS (5 of 5 bullets).
- Searches for existing tickets — PASS (read-only searches found "ITV-866" through ITV-870, all Closed, and the draft continued).
- Certification bounded — PASS (11 criterion rows plus E1 to E5, each tied to a "decisión clave" or "Tarea 1" item).
- Code review 3 to 5 points — PASS (5 "Prestar atención a" points, each drawn from a spec decision or risk).
- Explains bounds under pressure — PASS (it limits negative and edge cases to "5" and offers (a) to (e) as optional extras).
- Structure and epic — PASS (one story with `[BACKEND]` and `[FRONTEND]`, one certification and one review, and "También necesito el epic").
