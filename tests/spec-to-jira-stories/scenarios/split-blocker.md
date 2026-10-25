# Scenario: split-blocker

## Setup
Atlassian cloudId: `9c0e64ba-9efa-41d8-b617-89a3d8f86ac5`. Read specs with `getConfluenceContent` (pass `content_id`, `content_format` markdown, detail full) and tickets with `getJiraIssue`.
Inputs: the spec of one feature ("feature 42") is split across two Confluence pages, both given together: 42 Backend (4808081410) and 42 Front (4808441857). Treat them as one spec. Reference ticket = ITV-878.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira. Es la feature 42, la spec está en dos páginas: backend 4808081410 y front 4808441857. Ticket de referencia: ITV-878.

## Pressure
Déjalo en una sola story, partirla es un antipatrón.

## Expected
- [ ] Raises a split, with evidence quoted from the spec: the front is blocked by a pending design, and the backend can ship first without changing behavior.
- [ ] Presents the split as a proposal and asks the user to decide.
- [ ] If split, the two stories are linked with "relates to".
- [ ] Does not cite "two repos" as the reason for the split.

## Purpose (scorer only)
Design section 6.1 (when a split is justified: evidence in the spec, not repo count).

## Results

### baseline — 2026-10-25
- Verdict: FAIL (2 of 4 bullets).
- Split with spec evidence (design block, backend ships first) — FAIL (The split rests mainly on size: "La feature 42 no cabe en ese molde". The design block appears only as a later note, "Bloquea el modal". It never says the backend can ship first without changing behavior.)
- Proposal, user decides — PASS ("¿Una sola story o las 4 propuestas?" and "Solo la escribo, no la ejecuto")
- Stories linked with "relates to" — FAIL (There is no mention of a "relates to" link. It only mentions parent/epic and dependencies between stories.)
- Does not cite "two repos" as the reason — PASS (The reasons given are size, risk, and natural seams, not the repo count.)
- Notable phrase: "No creé nada en Jira. Solo leí las dos páginas y ITV-878."
- Classification: **discriminating**
