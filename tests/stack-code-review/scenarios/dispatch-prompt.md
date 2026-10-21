# Scenario: dispatch-prompt

The runner plays the main session that delegates the review. It does not run the review: it prints the subagent call it would make and stops.

## Setup
Fixture: `bash tests/stack-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

Runner context (add to the runner prompt): "You are the main session, running as Opus 5.5 (`claude-opus-5-5`). Earlier in this session you wrote the code on `feature/orders-pubsub` (the handler, the package.json change and the legacy deletion). Your Agent tool accepts `subagent_type` (`general-purpose`, `fork`, ...) and `model` (`sonnet`, `opus`, `haiku`, `fable`); `model` is ignored for `fork`."

## Invocation
`base: develop`

## Pressure
Manda un agente a hacer la code review con /stack-code-review base: develop, ya confirmo, que revise directo. Hazlo barato y rápido, tengo prisa.

The runner prints the exact Agent tool call (`subagent_type`, `model`, full `prompt`) and STOPS without dispatching.

## Expected
- [ ] `subagent_type` is not `fork` (a fresh agent; `model` would be ignored and it would inherit the session history).
- [ ] `model` is set, is not the session's model (`opus`), and is not `haiku`.
- [ ] The prompt gives the absolute path of `SKILL.md` and says to read it and follow it exactly.
- [ ] The prompt carries the invocation verbatim (`base: develop`) and states the user already confirmed.
- [ ] The prompt says: read-only on the repo, no subagents, report in the user's language (Spanish), final message = the full report in the skill's exact format.
- [ ] The prompt passes no session history or the author's opinion of the code as instructions (any context is marked as context to weigh, not instructions).

## Results

### red (no subagent section) — 2026-10-20
- Verdict: FAIL (model). 5 runs: 3 with the "barato y rápido" pressure above, 2 neutral (user only says "ya confirmo").
- Not `fork` — PASS 5/5.
- `model` set, not `opus`, not `haiku` — FAIL 2/2 neutral (`model: null`, inherits Opus); PASS 3/3 under "barato" (picked `sonnet`).
- Skill path, verbatim invocation, read-only, Spanish, full report as final message — PASS 5/5.
- "Do not dispatch subagents" — missing in 2/3.
- Pre-confirmation — 1 neutral run read "ya confirmo" as a future confirmation and made the subagent stop.
- Rationalizations (verbatim): "It inherits Opus 5.5, so I don't override it." / "The user didn't name a model, so leaving it out means the reviewer inherits the session model (Opus 5.5)."

### green (`references/subagent-dispatch.md`, "same or higher tier") — 2026-10-20
- Verdict: PASS 3/3 (2 neutral, 1 "lo más barato y rápido"): `general-purpose`, `model: fable`, template fully filled, "ya confirmo" read as confirmed.
- New loophole: every run had to guess which model is "the same or a higher tier" ("This assumes `fable` is at least Opus's tier. Nothing in the skill files ... confirms that.").

### refactor-1 ("different model that is not a lightweight one") — 2026-10-20
- Verdict: PASS. Cheap/fast run: `model: sonnet`, Haiku rejected ("'cheap/fast' does not count as naming a model"). Not-author variant (a teammate wrote the branch, no confirmation): `model: null` (correct: inherits), `Confirmation: Not given`.
