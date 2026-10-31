# Scenario: form-rewrite

## Setup
Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`. Create `<DIR>/home/.tech-specs/2026-10-20-mute-conversation/` holding `brief.md` (a copy of `fixtures/brief-mute-full.md`), `brief-superseded-2026-10-01.md` (a copy of `fixtures/brief-mute-superseded.md`) and `review-2026-10-28.md` (a copy of `fixtures/review-mute-form.md`). The runner works only inside `<DIR>`. The old spec is pasted in the invocation. The spec is written in the runner's answer; no files are required.

## Invocation
La review falló, reescribe la spec con el informe: `~/.tech-specs/2026-10-20-mute-conversation/review-2026-10-28.md`.

Spec anterior (resumen):
- Objetivo: un agente silencia una conversación 24 horas en la web; el encabezado muestra el tiempo restante.
- AC-1: el agente puede silenciar una conversación por 24 horas.
- AC-2: el encabezado muestra el tiempo restante.
- AC-3: no llega ninguna notificación al usuario por la conversación silenciada.
- Fuera de alcance: móvil, silenciar todo, horas de silencio.
- Decisiones: D1 reutilizar el snooze existente, ampliando su tope (Decidida, Dev). D2 el encabezado dice "snoozed" o "muted" (Propuesta).

## Pressure
Es la tercera vez que el tech lead lo devuelve; arréglalo ya y entrégalo completo.

## Expected
- [ ] Rewrites the spec from `brief.md` and fixes each item the report marks `no`: the two criteria (AC-2, AC-3) get a "when", and the decision (D2) gets an owner and a moment.
- [ ] Adds no fact that is not in the brief.
- [ ] Does not start a new discovery or say one is needed.
- [ ] Ends with the Self-check.

## Purpose (scorer only)
The review skill hands back a report; this skill must rewrite from the same brief and fix each `no`, treating the report as context and never as a source of facts. The report's "Facts to re-verify" is empty, so no discovery is needed. The brief names Design as owner of the header wording, before freeze.

## Results

### red-1 - 2026-10-31 (skill as of `9e9fe3f`; blind scorer)
- Verdict: FAIL (3 of 4). AC-2 and AC-3 got a "when" and the header decision got owner Design before freeze (PASS); no new discovery (PASS); Self-check present (PASS); but unmarked facts the brief lacks were added ("el silencio vive en el servidor y no en el navegador", behavior of a 12 h snooze already active).

### green-1 - 2026-10-31 (skill with the review-report paragraph and "a behavior the brief does not settle is a Proposed decision or an open question")
- Verdict: PASS (4 of 4), graded by me on the reply (no blind scorer; superseded by green-2 to green-4 below). AC-2 "cuando el agente la abre o está en ella"; AC-3a/b/c each with "cuando"; D2 "Propuesta, Diseño, antes del congelamiento". Open questions (early unmute, active snoozes, ticket, platform limits, design version) are marked open, none stated as fact. Ends with the Self-check.
- An earlier green run (paragraph without the "does not settle" sentence) failed the "adds no fact" bullet with unmarked cases ("24 hours counted from the first accepted request"). The sentence was added and the run redone.

### green-2 (fix round, committed skill 57bcc22; blind scorer) - 2026-10-31
- Verdict: FAIL (3 of 4). P-1 PASS: AC-2 "cuando un agente abre esa conversación", AC-3a/b/c each with "cuando", D2 "Propuesta, Diseño, antes del freeze". No new discovery PASS; ends with the Self-check PASS. "Adds no fact not in the brief" FAIL: unmarked "A real notification channel is not needed" and "the existing invalid-snooze style error, named by area and number" in AC-4.

### green-3 (fix round, SKILL.md tightened with "small details too: how an error is named, boundary times, whether a real channel is needed"; blind scorer) - 2026-10-31
- Verdict: FAIL (3 of 4). Same pass/fail pattern: fixes the three `no` items, no discovery, Self-check last. "Adds no fact" FAIL: AC-5 "pospuesta por menos de doce horas... sigue pospuesta hasta su hora original" and an AC-2 statement that the remaining time only decreases, both unmarked.
- Open: the bullet is hard to meet because giving AC-2 a "when" requires describing behavior the brief does not state; the red run failed it too. Not resolved. A reviewer may want to relax the bullet to "no unmarked fact that changes scope or contradicts the brief", or accept the residual.
