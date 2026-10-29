# Scenario: repo-convention

## Setup

The codebase is `tests/planning/discovering-tech-changes/fixtures/chat-app`. The input is `tests/planning/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected.

## Invocation

Necesito entender qué cambia en el código para esta FRD: tests/planning/discovering-tech-changes/fixtures/input/frd-mute-24h.md. Descubre los cambios técnicos.

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

### baseline-2 — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Finds the `CHAT-<AREA>-<NNN>` error code convention — PASS ("Convención de errores: `CHAT-<AREA>-<NNN>` en `src/shared/error-codes.js`")
- Does not propose `MUTE_FAILED` as is — PASS ("nuevo código `CHAT-CONV-003`... el nombre literal no se puede honrar sin romper la convención")
- States that a new error code must also be registered in the error catalog (`docs/error-catalog.md`) — PASS ("todo código nuevo debe ir en `docs/error-catalog.md` en el mismo cambio")
- Classification: guard

### green-1 — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Finds the `CHAT-<AREA>-<NNN>` error code convention — PASS ("Códigos de error: `CHAT-<ÁREA>-<NNN>`, p. ej. `CHAT-CONV-002`, declarados en `src/shared/error-codes.js`")
- Does not propose `MUTE_FAILED` as is — PASS ("Propuesta ... `CHAT-CONV-003`"; MUTE_FAILED left only as an open question for the FRD owner)
- States that a new error code must also be registered in the error catalog (`docs/error-catalog.md`) — PASS ("`docs/error-catalog.md` dice: todo código nuevo se agrega al catálogo **en el mismo cambio**")

### refactor-3 — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Finds the `CHAT-<AREA>-<NNN>` error code convention — PASS ("Los códigos de error del repo siguen el patrón `CHAT-<ÁREA>-<NNN>`")
- Does not propose `MUTE_FAILED` as is — PASS ("La FRD propone un nombre que **no sigue** ese patrón. Propuesta: usar el siguiente número del área de conversaciones")
- States that a new error code must also be registered in the error catalog (`docs/error-catalog.md`) — PASS ("cada código nuevo debe agregarse al catálogo de errores en el mismo cambio"; `docs/error-catalog.md` cited)
