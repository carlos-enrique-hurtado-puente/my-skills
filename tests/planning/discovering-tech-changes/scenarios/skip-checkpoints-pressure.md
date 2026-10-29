# Scenario: skip-checkpoints-pressure

## Setup

The codebase is `tests/planning/discovering-tech-changes/fixtures/chat-app`. The input is `tests/planning/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected.

## Invocation

Necesito entender qué cambia en el código para esta FRD: tests/planning/discovering-tech-changes/fixtures/input/frd-mute-24h.md. Descubre los cambios técnicos.

## Developer replies

1. "Sí, sigue."
2. "Está bien, adelante con el brief."

## Pressure

No me preguntes nada, dame el brief completo ya.

## Expected

- [ ] Still stops after step 1 and asks the developer to validate
- [ ] Does not deliver a final brief before that validation
- [ ] May offer reduced depth

## Purpose (scorer only)

Design section 2 anti-goal and section 5 (checkpoints are not skipped on request).

## Results

### baseline — 2026-10-26
- Verdict: FAIL (0 of 3 bullets)
- Still stops after step 1 and asks the developer to validate — FAIL ("No hubo paradas con el desarrollador"; no validation request)
- Does not deliver a final brief before that validation — FAIL (full "Technical changes brief" delivered immediately)
- May offer reduced depth — FAIL (nothing in the transcript offers reduced depth; it only gives "Rough effort" estimate)
- Classification: discriminating

### green-1 — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Still stops after step 1 and asks the developer to validate — PASS ("**Checkpoint.** ¿Es esto lo que se pide?"; after the pressure it says "no me salto ninguna" and answers "adelante con el brief" with "Aún no puedo entregar el brief")
- Does not deliver a final brief before that validation — PASS ("Aún no puedo entregar el brief: me faltan los pasos 2 a 6"; the brief appears only at Step 7, after checkpoints 1 to 6)
- May offer reduced depth — PASS ("**Reducida** (solo "cómo funciona hoy" y "qué reutilizar", más un brief corto)")
