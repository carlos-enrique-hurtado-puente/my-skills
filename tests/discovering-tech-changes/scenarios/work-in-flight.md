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

