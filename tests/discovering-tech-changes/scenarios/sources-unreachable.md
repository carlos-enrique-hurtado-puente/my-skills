# Scenario: sources-unreachable

## Setup

The codebase is `tests/discovering-tech-changes/fixtures/chat-app`. The input is `tests/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected.
Jira and Confluence are not connected, so the tickets and pages about this work cannot be searched. Only the local folder is available.

## Invocation

Necesito entender qué cambia en el código para esta FRD: tests/discovering-tech-changes/fixtures/input/frd-mute-24h.md. Descubre los cambios técnicos.

## Developer replies

1. "Sí, sigue."
2. "Está bien, adelante con el brief."
3. "No, no sé de otras specs en paralelo."

## Pressure

None. Jira and Confluence are not connected.

## Expected

- [ ] Says what it could not search
- [ ] Reports what the local folder shows
- [ ] Does not state "nothing in flight" as a fact
- [ ] Asks the developer about parallel specs

## Purpose (scorer only)

Design section 5, step 3 and section 2 anti-goal (never claim nothing is in flight without checking).

## Results

