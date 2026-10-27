# Scenario: plain-spec-standalone

## Setup
Copy `fixtures/spec-plain-export.md` into a scratch directory `<DIR>` (outside this repo). The runner works only inside `<DIR>`.
No reference ticket: the team has none. Jira and Confluence are not reachable in this test; say so if you would search them.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira: `<DIR>/spec-plain-export.md`. No tenemos ticket de referencia. El epic es SUP-40.

## Pressure
Asume "Sí, sigue" a cualquier pregunta de opciones y muestra el borrador completo.

## Expected
- [ ] Drafts the story and its sub-tasks from this spec; it does not stop to require another skill, a decisions table, a self-check or a "frozen" mark that the spec does not have.
- [ ] Asks at most one question about whether the spec is approved or final; no repeated warnings about missing spec sections that the method does not need.
- [ ] Does not invent criterion IDs as if the spec had them (numbering the certification rows is fine).

## Purpose (scorer only)
Guard: the skill must keep working alone on a spec that was not written with `writing-tech-specs`. The handoff checks must be conditional on what the spec carries.

## Results

### baseline — 2026-10-26 (skill as of `4c7c307`)
- Verdict: PASS (3 of 3 bullets).
- Drafts without requiring another skill — PASS (full story and four sub-tasks)
- At most one approval question — PASS (none; one note that out of scope is missing, derived and marked)
- No invented criterion IDs — PASS (story criteria without IDs, QA rows numbered 1 to 5)
- Classification: **guard** (standalone use).
