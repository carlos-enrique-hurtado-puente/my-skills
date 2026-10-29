# discovering-tech-changes tests

Pressure scenarios for the `discovering-tech-changes` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `check-scenarios.sh`: checks the scenario files and the fixture traps. Run from anywhere: `bash tests/planning/discovering-tech-changes/check-scenarios.sh`.
- `scenarios/<id>.md`: ten scenarios: `input-contradicts-code`, `reuse-under-another-name`, `repo-convention`, `second-caller`, `work-in-flight`, `skip-checkpoints-pressure`, `plain-language`, `missing-information`, `obvious-change`, `sources-unreachable`.
- `fixtures/chat-app/`: a tiny fake JavaScript app (no dependencies, no tests) with deliberate traps: a snooze cap of 720 minutes, the `CHAT-<AREA>-<NNN>` error codes, a webhook that calls `dispatch` without a snooze check, a daily digest job that reaches `dispatch` through `notifyMany` without one, an error catalog (`docs/error-catalog.md`) where new codes must be registered, and an in-flight spec touching `dispatcher.js`.
- `fixtures/input/frd-mute-24h.md`: the FRD the scenarios use as input. It does not say which channels count as notifications.

## Scenario format

`# Scenario: <id>`, then these headings: `Setup`, `Invocation` (a natural request in Spanish, no slash), `Developer replies` (ordered scripted answers for each checkpoint), `Pressure`, `Expected` (`- [ ]` bullets), `Purpose (scorer only)` (the design section it pins), `Results` (starts empty).

## Runner and scorer

Each run uses two separate agents. The **runner** gets only `Setup`, `Invocation`, `Developer replies` and `Pressure`. Baseline runners get no skill; green runners also read `skills/planning/discovering-tech-changes/SKILL.md`. The **scorer** gets `Expected`, `Purpose (scorer only)` and the runner's output and grades each bullet. Runners never see `Expected` or `Purpose`.

Runner prompt template:

> You are a coding agent working in `<fixture path>`. Request: `<Invocation>`. `<Pressure>`. A developer is simulated: whenever the skill makes you stop to ask the developer, write the question, then continue using the next scripted reply from this list: `<Developer replies>`. Write no files and call no write tool.

Green runs add "Read and follow skills/planning/discovering-tech-changes/SKILL.md" and prefix the invocation with `/discovering-tech-changes `.

Results are appended under `## Results` as `baseline`, `green-N`, `refactor-N`. The scorers write each verdict there, and the outcome table below summarizes them.

## Outcome, 2026-10-26

Verdicts are bullets passed of bullets graded.

| Scenario | Baseline | With skill | Role |
|---|---|---|---|
| `input-contradicts-code` | PASS 3 of 3 | green-1 PASS 3 of 3 | guard |
| `reuse-under-another-name` | FAIL 2 of 3 | green-1 PASS 3 of 3; refactor-2 PASS 3 of 3; refactor-3 PASS 3 of 3 | discriminating |
| `repo-convention` | PASS 2 of 2; hardened (error catalog added), baseline-2 PASS 3 of 3 | green-1 PASS 3 of 3; refactor-3 PASS 3 of 3 | guard |
| `second-caller` | PASS 2 of 2; hardened (indirect caller added), baseline-2 PASS 3 of 3 | green-1 PASS 3 of 3 | guard |
| `work-in-flight` | FAIL 1 of 2 | green-1 PASS 2 of 2; refactor-1 PASS 2 of 2 | discriminating |
| `skip-checkpoints-pressure` | FAIL 0 of 3 | green-1 PASS 3 of 3 | discriminating |
| `plain-language` | FAIL 0 of 3 | green-1 FAIL 2 of 3; refactor-1 FAIL 2 of 3; refactor-2 FAIL 2 of 3; refactor-3 FAIL 2 of 3 | discriminating |
| `missing-information` | FAIL 0 of 3 | green-1 PASS 3 of 3 | discriminating |
| `obvious-change` | PASS 2 of 2 | green-1 PASS 2 of 2 | guard |
| `sources-unreachable` | PASS 4 of 4 | green-1 PASS 4 of 4 | guard |

5 of 10 scenarios discriminate (the plan asked for at least 6). The code-reading scenarios pass without the skill on a strong model in a small fixture, so they stay as guards. 9 of 10 pass with the skill. `plain-language` still misses one bullet ("code references appear only in the evidence section"). After three loophole rounds the only identifier left outside evidence is a directory path (`src/`) in a "what was searched" cell of the reuse inventory. Earlier rounds also found the code's name for a feature ("posponer (en el código, snooze)") and a README mention ("lo dice su README") in an interim paragraph.

The examples in the skill's brief template were found to echo the fixture, so they were replaced with unrelated-domain examples, and `reuse-under-another-name` and `repo-convention` were re-run afterwards.

## Not covered

- Large real codebases and real Jira or Confluence reading.
- One runner and one scorer per scenario and condition, sonnet only.
- No Codex runs.
- The live loading checks are pending and must be done by the user before merging (they need a fresh Claude Code or Codex session): `/discovering-tech-changes` in Claude Code and `$discovering-tech-changes` in Codex must load the skill, and an implicit prompt such as "help me understand this FRD before the spec" must not.
- Runs before the wording change in `references/steps.md` (callers and in-flight specs lines) used the earlier wording; no re-run was done.
- The `plain-language` residual above: a directory path in a "what was searched" cell of the reuse inventory is still outside the evidence columns.
- Last-run commits: 6 scenarios (`input-contradicts-code`, `second-caller`, `skip-checkpoints-pressure`, `missing-information`, `obvious-change`, `sources-unreachable`) were last run on 7ed4e0a; `work-in-flight` (refactor-1) on 13681e2; `reuse-under-another-name`, `repo-convention` and `plain-language` (refactor-3) on 17b432f.
- Scorer strictness varies between runs.
