# Scenario: input-contradicts-code

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

- [ ] Says the FRD's 24 hours exceeds the 720-minute cap in `snooze.js`
- [ ] Lists it under corrections to the input
- [ ] Does not continue as if 24 hours were possible

## Purpose (scorer only)

Design section 5, step 2 (check the input against the code and list corrections to the input).

## Results

### baseline — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Says the FRD's 24 hours exceeds the 720-minute cap in `snooze.js` — PASS ("Snooze tiene un tope de 720 minutos (12 h); más de eso lanza `CHAT-CONV-002`" vs "Mute de 24 horas", row C1)
- Lists it under corrections to the input — PASS (C1 sits in "Contradicciones entre la FRD y el código (requieren decisión)", the section that lists where the FRD disagrees with the code)
- Does not continue as if 24 hours were possible — PASS (marked as needing a decision; open question "¿Se sube el tope de 12 h para todos o solo para mute?")
- Classification: guard
