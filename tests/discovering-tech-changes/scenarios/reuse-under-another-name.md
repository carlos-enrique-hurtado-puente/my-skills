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

### baseline — 2026-10-26
- Verdict: FAIL (2 of 3 bullets)
- Finds that "mute" already exists as snooze (`snoozeConversation`, `isSnoozed`, `snoozeLabel`) — PASS ("el código no tiene nada llamado mute. Tiene un concepto muy parecido llamado \"snooze\"", and the brief names `snoozeConversation`, `isSnoozed`, `snoozeLabel`)
- States what it searched — FAIL (only "Leí la FRD y el código de chat-app"; no search terms, patterns or locations are stated)
- Recommends adapting the existing snooze rather than creating a new mute — PASS ("lo reutilizo, en vez de crear un concepto nuevo"; "La funcionalidad se puede construir sobre el mecanismo de snooze existente")
- Classification: discriminating

### green-1 — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Finds that "mute" already exists as snooze (`snoozeConversation`, `isSnoozed`, `snoozeLabel`) — PASS ("No hay nada llamado `mute`; el equivalente es el snooze"; table names `snoozeConversation`, `isSnoozed`, `snoozeLabel`)
- States what it searched — PASS ("Términos buscados: `mute`, `silence`, `snooze`, `pause`, `until`, `remaining`, `duration`, `notif`, `dispatch`, `error`, `CHAT-`; en todo `src/` y `docs/`")
- Recommends adapting the existing snooze rather than creating a new mute — PASS ("A. Extender el snooze (recomendada)"; "C. Crear un \"mute\" separado ... No lo recomiendo")

### refactor-2 — 2026-10-26
- Verdict: PASS (3 of 3 bullets)
- Finds that "mute" already exists as snooze (`snoozeConversation`, `isSnoozed`, `snoozeLabel`) — PASS ("Ya existe una función de posponer ("snooze")... lo mismo que pide la FRD con otro nombre"; inventory cites `snoozeConversation`, `isSnoozed`, `snoozeLabel`)
- States what it searched — PASS ("Qué busqué: código que silencie, pause o posponga una conversación... todo lo que decide si se envía un aviso"; also "No pude buscar: otras apps o repositorios... Jira... Confluence")
- Recommends adapting the existing snooze rather than creating a new mute — PASS ("Ampliar posponer (recomendada)"; "Recomiendo la 1"; new separate mechanism option 3 "deja dos mecanismos casi iguales")
