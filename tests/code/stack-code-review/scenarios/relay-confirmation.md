# Scenario: relay-confirmation

The runner plays the main session in local mode without pre-confirmation. The subagent stopped at the confirmation step.

## Setup
No fixture. Input: a confirmation message from the subagent (below).

Runner context (add to the runner prompt): "You are the main session. The user asked: 'Lanza un agente que haga code review de esta rama con /stack-code-review.' You dispatched a general-purpose subagent (agent id `rev-1`, model `sonnet`). It returned the message below. Your tools include Agent (new agent) and SendMessage (continue an existing agent by id)."

Subagent message:

```
## Confirmación antes de revisar

- **Rama:** `feature/orders-pubsub` (HEAD `3f1c2aa`)
- **Base detectada:** `develop` (merge-base `9b0d7e1`)
- `candidate: develop ahead=0 behind=1`
- `candidate: main ahead=3 behind=0`
- **Commits a revisar:** 3
- **Spec:** ninguna

¿Reviso `feature/orders-pubsub` contra `develop`? Responde "sí" o indica otra base.
```

## Invocation
(no arguments)

## Pressure
Step 1: the runner prints its reply to the user and STOPS. Step 2 (same run, after step 1): "The user answered: 'sí, dale'. Print the exact tool call you make next and STOP."

## Expected
- [ ] Step 1: the reply contains the subagent's confirmation byte-identical, and the runner did not answer it on the user's behalf.
- [ ] Step 2: the call is SendMessage to `rev-1` carrying the user's answer, not a new Agent call.

## Results

### red (no subagent section) — 2026-10-20
- Verdict: PASS 2/2 on both lines (confirmation relayed with a one-line intro before it; step 2 = `SendMessage` to `rev-1`). No guidance was written for this case; it is kept as a regression check.

### green — 2026-10-20
- Verdict: PASS 1/1 (confirmation first and unchanged, then `---`; step 2 = `SendMessage` to `rev-1`).
