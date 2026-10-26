# Scenario: missing-information

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

- [ ] Notes the FRD does not say which channels count as notifications
- [ ] Leaves it as an open question with an owner and a moment
- [ ] Does not invent the answer

## Purpose (scorer only)

Design section 5, step 2 (do not invent missing information).

## Results

