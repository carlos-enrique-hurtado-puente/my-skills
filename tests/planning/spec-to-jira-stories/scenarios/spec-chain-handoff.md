# Scenario: spec-chain-handoff

## Setup
Copy `fixtures/spec-mute-24h.md` into a scratch directory `<DIR>` (outside this repo). The runner works only inside `<DIR>`.
No reference ticket: the team has none. Jira and Confluence are not reachable in this test; say so if you would search them.
Jira write tools are off limits in this test; if you would create a ticket, write the exact call you would make as text and stop.
Do not write any file.

## Invocation
Convierte esta spec en stories y sub-tasks de Jira: `<DIR>/spec-mute-24h.md`. No tenemos ticket de referencia. El epic es CHAT-100.

## Pressure
La spec ya está lista, sácame el borrador de los tickets ya, que mañana arranca el sprint. Asume "Sí, sigue" a cualquier pregunta de opciones y muestra el borrador completo.

## Expected
- [ ] Says, before or with the draft, that the spec still has decisions marked Proposed that block its freeze (header wording, shared dispatcher step), and asks whether to go on or resolve them first; it does not refuse to draft.
- [ ] Each deployment task (index, TTL policy, backfill) appears inside a development sub-task, as part of its work; no deployment task becomes a ticket of its own.
- [ ] The TTL policy (outside the repo) says it is configured in the console and what evidence QA gets (the screenshot); the backfill says what evidence is attached.
- [ ] The story criteria and the certification rows keep the spec's criterion IDs (AC-01 and so on).
- [ ] AC-07 is not ticketed, and the answer says it stays out of scope with the spec's reason (or shows a coverage line that says so).

## Purpose (scorer only)
The handoff from `writing-tech-specs` to `spec-to-jira-stories`: the spec carries a decisions table with before-freeze rows, a self-check, criteria with stable IDs, one criterion out of scope, and a deployment task list. Bullets 2 and 3 encode the user's rule: operational work goes inside the development sub-task, not a ticket of its own; only work outside the repo needs a note of where it lives and what evidence counts.

## Results

### baseline — 2026-10-26 (skill as of `4c7c307`)
- Verdict: PASS (5 of 5 bullets). No skill change was made for this scenario.
- Blocking Proposed rows flagged, still drafts — PASS ("Dos filas siguen en 'Proposed' y bloquean el freeze"; closing asks whether to wait or start the sprint with them open)
- Deployment tasks inside a development sub-task — PASS (T-01 to T-03 sit in the `[BACKEND]` notes; it asks whether the user prefers a separate sub-task, but creates none)
- Outside-repo task with place and evidence — PASS ("T-02 (in the Firestore console, not in the repo) ... Evidence: screenshot of the policy pasted in this ticket")
- Criterion IDs kept — PASS (story criteria end in "(AC-01)" and so on; QA rows read "AC-01 Mute for 24 hours")
- AC-07 out of scope — PASS ("El spec lo marca como fuera de alcance (la app móvil es otro release)")
- Classification: **guard**. The skill already handles a spec written with `writing-tech-specs`.
