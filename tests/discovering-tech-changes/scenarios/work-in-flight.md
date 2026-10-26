# Scenario: work-in-flight

## Setup

The codebase is `tests/discovering-tech-changes/fixtures/chat-app`. The input is `tests/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected.

## Invocation

Necesito entender qué cambia en el código para esta FRD: tests/discovering-tech-changes/fixtures/input/frd-mute-24h.md. Descubre los cambios técnicos.

## Developer replies

1. "Sí, sigue."
2. "Está bien, adelante con el brief."

## Pressure

None.

## Expected

- [ ] Finds `quiet-hours.md` touching `dispatcher.js`
- [ ] Lists it as a dependency with its owner status (unassigned)

## Purpose (scorer only)

Design section 5, step 3 (find work in flight that touches the same code).

## Results

### baseline — 2026-10-26
- Verdict: FAIL (1 of 2 bullets)
- Finds `quiet-hours.md` touching `dispatcher.js` — PASS ("`docs/specs/in-flight/quiet-hours.md` is a different feature (daily window), also touching the dispatcher")
- Lists it as a dependency with its owner status (unassigned) — FAIL (it is put under "Out of scope / notes" with "I did not treat it as related"; no dependency listing and no owner status anywhere in the transcript)
- Classification: discriminating

### green-1 — 2026-10-26
- Verdict: PASS (2 of 2 bullets)
- Finds `quiet-hours.md` touching `dispatcher.js` — PASS ("`docs/specs/in-flight/quiet-hours.md`: ... Propone añadir una verificación de horas de silencio en `src/notifications/dispatcher.js`")
- Lists it as a dependency with its owner status (unassigned) — PASS ("**dueño: sin asignar** ... **Es una dependencia** hasta que digas lo contrario"; brief table row "spec quiet-hours | ... | sin asignar")

### refactor-1 — 2026-10-26
- Verdict: PASS (2 of 2 bullets)
- Finds `quiet-hours.md` touching `dispatcher.js` — PASS ("Quiere añadir una revisión de \"no molestar\" **en el mismo módulo de envío** ... `docs/specs/in-flight/quiet-hours.md`")
- Lists it as a dependency with its owner status (unassigned) — PASS ("se trata como dependencia hasta que digas otra cosa"; owner column "**Sin asignar** (owner unknown, to ask)")
