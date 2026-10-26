# discovering-tech-changes tests

Pressure scenarios for the `discovering-tech-changes` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `check-scenarios.sh`: checks the scenario files and the fixture traps. Run from anywhere: `bash tests/discovering-tech-changes/check-scenarios.sh`.
- `scenarios/<id>.md`: ten scenarios: `input-contradicts-code`, `reuse-under-another-name`, `repo-convention`, `second-caller`, `work-in-flight`, `skip-checkpoints-pressure`, `plain-language`, `missing-information`, `obvious-change`, `sources-unreachable`.
- `fixtures/chat-app/`: a tiny fake JavaScript app (no dependencies, no tests) with deliberate traps: a snooze cap of 720 minutes, the `CHAT-<AREA>-<NNN>` error codes, a webhook that calls `dispatch` without a snooze check, a daily digest job that reaches `dispatch` through `notifyMany` without one, an error catalog (`docs/error-catalog.md`) where new codes must be registered, and an in-flight spec touching `dispatcher.js`.
- `fixtures/input/frd-mute-24h.md`: the FRD the scenarios use as input. It does not say which channels count as notifications.

## Scenario format

`# Scenario: <id>`, then these headings: `Setup`, `Invocation` (a natural request in Spanish, no slash), `Developer replies` (ordered scripted answers for each checkpoint), `Pressure`, `Expected` (`- [ ]` bullets), `Purpose (scorer only)` (the design section it pins), `Results` (starts empty).

## Runner and scorer

Each run uses two separate agents. The **runner** gets only `Setup`, `Invocation`, `Developer replies` and `Pressure`. Baseline runners get no skill; green runners also read `skills/discovering-tech-changes/SKILL.md`. The **scorer** gets `Expected`, `Purpose (scorer only)` and the runner's output and grades each bullet. Runners never see `Expected` or `Purpose`.

Runner prompt template:

> You are a coding agent working in `<fixture path>`. Request: `<Invocation>`. `<Pressure>`. A developer is simulated: whenever the skill makes you stop to ask the developer, write the question, then continue using the next scripted reply from this list: `<Developer replies>`. Write no files and call no write tool.

Green runs add "Read and follow skills/discovering-tech-changes/SKILL.md" and prefix the invocation with `/discovering-tech-changes `.

Results are appended under `## Results` as `baseline`, `green-N`, `refactor-N`.
