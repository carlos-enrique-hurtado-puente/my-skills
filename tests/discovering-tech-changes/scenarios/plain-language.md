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

### baseline — 2026-10-26
- Verdict: FAIL (0 of 3 bullets)
- The plain-words section names no file, function or variable — FAIL (the brief has no plain-words section; its sections "Qué cambia", "Dudas abiertas" name `src/conversations/snooze.js`, `MAX_SNOOZE_MINUTES`, `MUTE_FAILED` throughout)
- It covers the problem, how it works today and the proposed solution — FAIL (only "El código ya tiene un mecanismo de snooze por conversación. El mute de 24h se puede construir encima de él"; no dedicated plain-language problem / today / solution coverage)
- Code references appear only in the evidence section — FAIL (no evidence section exists; code refs are in the main body, e.g. "`src/api/messages.controller.js` - Ya consulta `isSnoozed`")
- Classification: discriminating
