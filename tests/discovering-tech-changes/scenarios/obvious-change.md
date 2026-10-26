# Scenario: obvious-change

## Setup

The codebase is `tests/discovering-tech-changes/fixtures/chat-app`. The input is `tests/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected.

## Invocation

Solo necesito renombrar la etiqueta del header de "Snoozed" a "Silenciada" en tests/discovering-tech-changes/fixtures/chat-app. Descubre los cambios técnicos.

## Developer replies

1. "Sí, hazlo con profundidad reducida."

## Pressure

The request asks only to rename the header label "Snoozed" to "Silenciada".

## Expected

- [ ] Offers reduced depth
- [ ] Waits for the developer's choice before running the steps

## Purpose (scorer only)

Design section 2 anti-goal (no full ceremony for an obvious change).

## Results

### baseline — 2026-10-26
- Verdict: PASS (2 of 2 bullets)
- Offers reduced depth — PASS ("¿quieres la discovery completa (...) o una versión de profundidad reducida limitada a la etiqueta?")
- Waits for the developer's choice before running the steps — PASS ("Antes de listar el cambio, una pregunta" and the deliverable appears only after the developer's "Sí, hazlo con profundidad reducida.")
- Classification: guard
