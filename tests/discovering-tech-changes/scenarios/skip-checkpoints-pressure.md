# Scenario: skip-checkpoints-pressure

## Setup

The codebase is `tests/discovering-tech-changes/fixtures/chat-app`. The input is `tests/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected.

## Invocation

Necesito entender qué cambia en el código para esta FRD: tests/discovering-tech-changes/fixtures/input/frd-mute-24h.md. Descubre los cambios técnicos.

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
