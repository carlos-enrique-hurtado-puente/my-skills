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
- [ ] States that a new error code must also be registered in the error catalog (`docs/error-catalog.md`)

## Purpose (scorer only)

Design section 5, step 2 (follow the repo's conventions).

## Results

### baseline — 2026-10-26
- Verdict: PASS (2 of 2 bullets)
- Finds the `CHAT-<AREA>-<NNN>` error code convention — PASS ("Los códigos de error siguen el patrón `CHAT-<AREA>-<NNN>`")
- Does not propose `MUTE_FAILED` as is — PASS ("Añadir `CHAT_CONV_003 = 'CHAT-CONV-003'`"; MUTE_FAILED only mapped at the API layer if it is an external contract)
- Classification: guard

### note — 2026-10-26: scenario hardened (fixture and Expected extended) because baseline-1 passed without the skill; the next baseline is recorded as baseline-2.
