# Scenario: code-answers-intake-doubts

## Setup

The codebase is `tests/planning/discovering-tech-changes/fixtures/chat-app`. The input is `tests/planning/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected. The run stops right after the step 1 checkpoint question is written; nothing past it is needed.

## Invocation

Para chat-app necesitamos silenciar conversaciones. El FRD es tests/planning/discovering-tech-changes/fixtures/input/frd-mute-24h.md, de ahí partimos. Vamos a verificar los requisitos uno por uno, pero de antemano te digo que capaz algo parecido ya existe en el código; igual lo analizamos al leerlo. Descubre los cambios técnicos.

## Developer replies

1. "Completo."

## Pressure

None.

## Expected

- [ ] No question at the step 1 checkpoint asks the developer something the fixture code answers: whether a similar feature already exists, the maximum mute duration allowed today, whether a way to undo a mute exists today, what the conversation header shows today, or how error codes are named. Asking whether the product wants a behavior is allowed.
- [ ] The step 1 result states, as observed in code, at least two of: muting already exists as snooze; snooze is capped at 720 minutes (12 h), below the FRD's 24 hours; there is no way to end a snooze early today; the header shows the end time ("until HH:MM"), not the remaining time; error codes follow `CHAT-<AREA>-<NNN>`, so `MUTE_FAILED` does not fit.
- [ ] The questions left for the developer are ones the code cannot answer (product or scope decisions, such as which channels a mute silences or whether an unmute is wanted).

## Purpose (scorer only)

SKILL.md rule "Ask only what the code cannot answer", applied at step 1: before the intake checkpoint, doubts the code can settle are checked in the code and reported as observed, not asked. Reproduces a real run where the step 1 checkpoint asked about filters, deactivation and states, and a code-reading subagent answered them minutes later.

## Results

### red-1 (current skill, 3 runs, runner is a subagent without the Agent tool) — 2026-10-29
- Verdict: did not reproduce (3 of 3 runs pass all bullets, graded by the author, no separate scorer).
- All three runners read the whole fixture (11 small files) in one pass before the step 1 checkpoint, reported the snooze, the 12 h cap, the header's end time, the missing early unsnooze and the error-code convention as observed, and asked only product questions (mute vs snooze, per user or per conversation, which notifications, what "web only" means).
- Difference from the real run: there the main session delegated the code reading to a background subagent (SKILL.md "Protect context") and posted the step 1 checkpoint before that subagent reported. A runner without the Agent tool, on a fixture small enough to read at once, never meets that situation.
- Two headless `claude -p` replays of the real prompt in the real repo did not reproduce it either: both read the code themselves before the checkpoint. The failure is the decision point "a delegated search is still running", tested in the README's decision micro-test.

### green-1 (after the step 1 and "Protect context" wording change) — 2026-10-29
- Verdict: PASS (3 of 3 bullets), separate scorer.
- No code-answerable question — PASS (questions ask product intent: "¿"Silenciar" es el mismo "posponer" de hoy, ampliado a 24 h, o producto quiere una función distinta…?")
- At least two facts observed in code — PASS (all five: snooze exists, 12 h cap, no early unsnooze, header shows end time, `MUTE_FAILED` breaks the convention)
- Remaining questions are product decisions — PASS ("¿incluye las de mensajes de canales externos y el resumen diario…?")
