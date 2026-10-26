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

