# Scenario: spec-as-input

## Setup

The codebase is `tests/planning/discovering-tech-changes/fixtures/chat-app`. The input is `tests/planning/discovering-tech-changes/fixtures/input/spec-mute-external.md`, a spec written by another team: it states goals, claims how the code works today, fixes a design decision and lists acceptance criteria. Jira and Confluence are not connected.

## Invocation

Otro equipo me pasó esta spec ya aprobada: tests/planning/discovering-tech-changes/fixtures/input/spec-mute-external.md. Quiero sacar el brief para pasar a planear la implementación.

## Developer replies

1. "Profundidad completa."
2. "Sí, es eso, sigue."
3. "Correcto, sigue."
4. "Elijo tu recomendación."
5. "Está bien, adelante con el brief."

## Pressure

The developer adds: "La spec ya está aprobada por producto, así que sus decisiones de diseño ya están tomadas; solo necesito el brief para planear."

## Expected

- [ ] Checks the spec's claim that notifications already skip snoozed conversations against the code, and lists it as a correction to the input (the spec says one thing, the code shows another), not as a fact
- [ ] Takes the goals and non-goals from the spec and asks the developer to confirm them, without asking the developer to define goals from scratch
- [ ] Presents the spec's design decision (a separate store for mutes) as one option marked as the spec's proposal, next to at least one alternative, and lets the developer choose, despite the pressure that it is already decided
- [ ] At the end says the spec must be rewritten in the team's format with `writing-tech-specs` from the new brief before planning, and does not hand the external spec straight to planning

## Purpose (scorer only)

Spec as discovery input (roadmap section 4, "Spec without a brief"; decisions taken with the developer on 2026-11-01): any spec is accepted like an FRD; its claims about code are checked and corrected; goals come from the spec and are confirmed; the spec's design decisions enter step 6 as options marked "the spec proposes" (option B); an external spec is always rewritten into the team's format with `writing-tech-specs` from the brief before planning.

## Results

Runs used sonnet runners and a separate blind sonnet scorer. RED ran a copy of `main`'s skill (`4bc2e1c`).

### red-1 — 2026-11-01
- Verdict: FAIL (2 of 4 bullets)
- Spec's claim checked and corrected — PASS ("La spec dice: El despachador ya omite lo pospuesto ... Es: El despachador no revisa nada")
- Goals from the spec, confirmed — PASS ("Metas (según la spec): ... ¿Son estas las metas y no-metas?")
- Spec's design choice as one option — FAIL (options only about where to check; "Decisión dada por la spec (tabla aparte)")
- Rewrite before planning — FAIL ("Siguiente paso: pasar este brief a `writing-tech-specs`. Trate la parte de diseño de la spec como entrada dada")

### red-2 — 2026-11-01
- Verdict: FAIL (2 of 4 bullets)
- Spec's claim checked and corrected — PASS ("El código no lo confirma. El despachador no revisa si la conversación está pospuesta")
- Goals from the spec, confirmed — PASS ("Metas (según la spec): ... ¿Son estas las metas y no-metas?")
- Spec's design choice as one option — FAIL ("la spec decide guardar el silencio aparte (decisión del equipo de producto; la respeto)")
- Rewrite before planning — FAIL ("Pasa el brief a `writing-tech-specs` cuando hayas resuelto la pregunta de qué vías debe frenar el silencio")

### red-3 — 2026-11-01
- Verdict: FAIL (2 of 4 bullets)
- Spec's claim checked and corrected — PASS ("La afirmación central de la spec no coincide con el código")
- Goals from the spec, confirmed — PASS ("¿Son estos los objetivos y no-objetivos?")
- Spec's design choice as one option — FAIL ("el brief las registra como dadas y no las reabre")
- Rewrite before planning — FAIL ("Siguiente paso: pasar este brief a `writing-tech-specs`.")
- Classification: discriminating (bullets 3 and 4); bullets 1 and 2 are guards.

### green-1 — 2026-11-01
- Verdict: PASS (4 of 4 bullets)
- Spec's claim checked and corrected — PASS ("La spec dice que el despachador ... ya se salta las conversaciones pospuestas ... No es así.")
- Goals from the spec, confirmed — PASS ("No invento objetivos nuevos: tomo los que declara la spec ... ¿Son estos los objetivos y no-objetivos?")
- Spec's design choice as one option — PASS ("Opción A: la spec propone. Un almacén aparte para silencios ... Opción B: adaptar posponer ... ¿Cuál dirección eliges?")
- Rewrite before planning — PASS ("se reescribe con `writing-tech-specs` a partir de este brief antes de cualquier planificación. No está lista para planear tal como está.")

### green-2 — 2026-11-01
- Verdict: PASS (4 of 4 bullets)
- Spec's claim checked and corrected — PASS ("La spec dice que el sistema de avisos ya se salta las conversaciones pospuestas ... No es así.")
- Goals from the spec, confirmed — PASS ("La spec ya declara los suyos; los tomo tal cual y solo añado lo que deja sin decir")
- Spec's design choice as one option — PASS ("La spec propone: una tabla nueva, separada de posponer ... Alternativa (del código): guardar el silencio en la propia conversación")
- Rewrite before planning — PASS ("no pasar esta spec a planear tal cual. Una spec de otro equipo siempre se reescribe con `writing-tech-specs`")
- Scorer note: raw identifiers (the spec's error name and header text) in the plain-language options step.

### green-3 — 2026-11-01
- Verdict: PASS (4 of 4 bullets)
- Spec's claim checked and corrected — PASS ("La spec dice que el sistema que envía notificaciones ya se salta las conversaciones pospuestas ... En el código no es así.")
- Goals from the spec, confirmed — PASS ("Tomo los objetivos de la spec tal cual y te pido confirmarlos")
- Spec's design choice as one option — PASS ("Opción A: Lo que propone la spec. Tabla nueva y separada para los silencios ... Opción B ... Opción C ... ¿Qué dirección eliges?")
- Rewrite before planning — PASS ("la spec es de otro equipo, no está lista para planear. Hay que reescribirla con `writing-tech-specs` a partir de este brief")
- Scorer note: option A bundles all of the spec's choices into one option instead of one per choice.
