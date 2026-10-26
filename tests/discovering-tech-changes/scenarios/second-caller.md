# Scenario: second-caller

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

- [ ] Finds that `handleInbound` calls `dispatch` without a snooze check
- [ ] Reports it as a gap that affects the feature
- [ ] Finds the daily digest path (`runDigest` -> `notifyMany` -> `dispatch`) as well as `handleInbound`, and reports both as paths that ignore the snooze

## Purpose (scorer only)

Design section 5, step 2 (find other callers affected by the change).

## Results

### baseline — 2026-10-26
- Verdict: PASS (2 of 2 bullets)
- Finds that `handleInbound` calls `dispatch` without a snooze check — PASS ("`src/webhooks/inbound.js` llama a `dispatch` directamente sin comprobar snooze")
- Reports it as a gap that affects the feature — PASS ("Mensajes entrantes por webhook seguirían notificando a una conversación silenciada")
- Classification: guard

### note — 2026-10-26: scenario hardened (fixture and Expected extended) because baseline-1 passed without the skill; the next baseline is recorded as baseline-2.

### baseline-2 — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Finds that `handleInbound` calls `dispatch` without a snooze check — PASS ("`src/webhooks/inbound.js` (mensajes de canales externos) llama a `dispatch` directo")
- Reports it as a gap that affects the feature — PASS ("Caminos que ignoran el snooze (el mute no silenciaría todo)")
- Finds the daily digest path (`runDigest` -> `notifyMany` -> `dispatch`) as well as `handleInbound`, and reports both as paths that ignore the snooze — PASS ("`src/jobs/daily-digest.js` -> `src/notifications/batch.js` -> `dispatch` para todas las conversaciones", listed under "Por eso siguen notificando" with the inbound webhook)
- Classification: guard

### green-1 — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Finds that `handleInbound` calls `dispatch` without a snooze check — PASS ("El webhook de mensajes que llegan de canales externos (`handleInbound`): **no** lo revisa; llama directo al despachador")
- Reports it as a gap that affects the feature — PASS ("hoy un snooze no frena el webhook ni el resumen diario"; option A risk: "siguen notificando (incumple la FRD)")
- Finds the daily digest path (`runDigest` -> `notifyMany` -> `dispatch`) as well as `handleInbound`, and reports both as paths that ignore the snooze — PASS ("El resumen diario (`runDigest`, vía `notifyMany`): **no** lo revisa"; E5: "Webhook y resumen diario llaman a `dispatch` sin revisar snooze")
