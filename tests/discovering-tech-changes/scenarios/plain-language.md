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

### green-1 — 2026-10-26
- Verdict: FAIL (2 of 3 bullets)
- The plain-words section names no file, function or variable — PASS (section "1. En palabras simples" says "ya existe una función casi igual, 'posponer' (snooze)... aparece un error"; no file, function or variable named)
- It covers the problem, how it works today and the proposed solution — PASS ("Problema:", "Hoy:", "Propuesta (no decidida): reutilizar el snooze para las 24 h...")
- Code references appear only in the evidence section — FAIL (code refs outside evidence: section 2 "Error `MUTE_FAILED`", "`CHAT-<AREA>-<NNN>`"; section 8 "mapear a `CHAT-CONV-003`", "`MUTE_FAILED`"; section 6 "`docs/specs/in-flight/quiet-hours.md`")

### refactor-1 — 2026-10-26
- Verdict: FAIL (2 of 3 bullets)
- The plain-words section names no file, function or variable — PASS (section "1. En palabras simples": "Ya existe 'posponer', que hace casi lo mismo pero con un máximo de 12 horas"; no file, function or variable named)
- It covers the problem, how it works today and the proposed solution — PASS ("Problema.", "Hoy.", "Propuesta. Reusar 'posponer' ampliándolo a 24 horas...")
- Code references appear only in the evidence section — FAIL (outside evidence: section 0 input path "/Users/.../frd-mute-24h.md"; section 2 column "La entrada dice" "`MUTE_FAILED`"; section 5 column "Qué se buscó" "isSnoozed", "dispatch, notifyMany", "snoozeLabel", "error-codes"; section 8 column "Pregunta" "`MUTE_FAILED`")

### refactor-2 — 2026-10-26
- Verdict: FAIL (2 of 3 bullets)
- The plain-words section names no file, function or variable — PASS (brief section "1. En palabras simples": "ya existe 'posponer' por conversación, pero con tope de 12 h"; no file, function or variable named)
- It covers the problem, how it works today and the proposed solution — PASS ("**Problema:** el usuario quiere dejar de recibir avisos...", "**Hoy:** ya existe 'posponer'...", "**Propuesta (opción 2):** reutilizar posponer, subir el tope a 24 h...")
- Code references appear only in the evidence section — FAIL (outside evidence: step 3 plain-words paragraph "(en el código, snooze)" and "(lo dice su README)", a naming pattern and a file name in prose)
