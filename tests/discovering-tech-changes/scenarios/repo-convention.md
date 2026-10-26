# Scenario: repo-convention

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

- [ ] Finds the `CHAT-<AREA>-<NNN>` error code convention
- [ ] Does not propose `MUTE_FAILED` as is

## Purpose (scorer only)

Design section 5, step 2 (follow the repo's conventions).

## Results

