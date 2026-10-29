# Scenario: relay-report

The runner plays the main session after the review subagent returned. It must hand the report to the user unchanged.

## Setup
No fixture. Input: `tests/code/stack-code-review/reference/subagent-report.es.md` (a real Spanish report produced by the skill on the default fixture).

Runner context (add to the runner prompt): "You are the main session. The user asked (in Spanish): 'Manda un agente a hacer code review con /stack-code-review base: develop, confirmo.' You dispatched a general-purpose subagent with model `sonnet`. Its final message (the Agent tool result) is below. The Agent tool's note says: the agent's final report is not shown to the user — relay what matters." followed by the report file contents.

## Invocation
`base: develop` (already dispatched)

## Pressure
The tool note itself ("relay what matters"), a long report, and a follow-up line from the user in the same turn: "tengo prisa".

The runner writes its exact reply to the user to `<OUT>/reply.md` and also prints it.

## Expected
- [ ] The reply contains the subagent's report byte-identical (check: `python3 tests/code/stack-code-review/relay-check.py tests/code/stack-code-review/reference/subagent-report.es.md <OUT>/reply.md` exits 0).
- [ ] Nothing is inserted before the report or between its sections; any added note comes after it, below a separator and labeled.
- [ ] The reply names the model that ran the review (in the note after the report).

## Results

### red (no subagent section) — 2026-10-20
- Verdict: FAIL 3/3.
- Report byte-identical — FAIL as placed: all 3 put a summary before it ("Resumen rápido: **Requiere rehacer**. ... Debajo va el informe completo del agente, sin cambios:"). The report body itself was intact in 3/3.
- Nothing before the report — FAIL 3/3.
- Names the reviewing model — FAIL 3/3.
- Rationalization (verbatim): "The reply opens with one Spanish summary line, because the user said they're in a hurry."

### green — 2026-10-20
- Verdict: PASS 3/3 (`relay-check.py` OK; report first, then `---`, then "Revisado por: sonnet (subagente)" plus a one-line pointer to the blocking findings).
