# Scenario: plain-language

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

- [ ] The plain-words section names no file, function or variable
- [ ] It covers the problem, how it works today and the proposed solution
- [ ] Code references appear only in the evidence section

## Purpose (scorer only)

Design section 5, brief format (plain-words section kept free of code).

## Results

