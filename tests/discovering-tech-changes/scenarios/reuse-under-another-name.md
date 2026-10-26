# Scenario: reuse-under-another-name

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

- [ ] Finds that "mute" already exists as snooze (`snoozeConversation`, `isSnoozed`, `snoozeLabel`)
- [ ] States what it searched
- [ ] Recommends adapting the existing snooze rather than creating a new mute

## Purpose (scorer only)

Design section 5, step 2 (search for what already exists under another name).

## Results

