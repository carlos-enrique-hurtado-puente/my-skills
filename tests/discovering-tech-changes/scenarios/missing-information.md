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

### baseline — 2026-10-26
- Verdict: FAIL (0 of 3 bullets)
- Notes the FRD does not say which channels count as notifications — FAIL (the missing-information list covers persistence, unmute, MUTE_FAILED, "web only", snooze relation and time format; nothing says the FRD leaves open which channels count as notifications)
- Leaves it as an open question with an owner and a moment — FAIL (the "Información faltante" items have no owner and no moment, and none is about channels)
- Does not invent the answer — FAIL ("Los mensajes de canales externos seguirían notificando aunque la conversación esté muteada. Hay que mover la comprobación al dispatcher" treats external channels as in scope without flagging it as undefined)
- Classification: discriminating
