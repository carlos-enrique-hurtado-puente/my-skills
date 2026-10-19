# express-best-practices tests

Pressure scenarios for the `express-best-practices` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `fixtures/make-project.sh <dir> <profile>` builds a small Express project. Profiles: `v5-api`, `v4-api`, `unknown-version`, `mono`, `hardening-v4`. `<dir>` must not exist or be empty; use a scratch location, not this repo. Prints the fixture path.
- `scenarios/<id>.md` one file per scenario: `Setup`, `Invocation`, `Pressure`, `Expected`, `Results`.
- `test-detect-version.sh` tests the version detector.

## Runner and scorer

Each run uses two separate agents.

- **Runner**: a fresh agent that receives only `Setup`, `Invocation` and `Pressure` (the prompt is `Invocation` plus `Pressure`). It builds the fixture from `Setup` and works inside it. It never sees `Expected` or `Purpose (scorer only)`; the runner prompt is built from Setup + Invocation + Pressure only. Baseline runs get no skill; green and refactor runs get the skill.
- **Scorer**: a different agent that receives `Expected` and the runner's transcript and the files it produced. It grades each bullet independently.

Runners must not see the expected result, and the scorer must not be the runner.

## Results format

Append one entry per run under `## Results` in the scenario file:

- `### baseline — <date>`: run without the skill (RED).
- `### green-N — <date>`: run with the skill (GREEN), N counts runs.
- `### refactor-N — <date>`: run after closing a loophole (REFACTOR).

Each entry has: per-bullet PASS or FAIL (N/A where the bullet says so) with a short reason, a verdict line (PASS only if no bullet is FAIL), and verbatim notable phrases from the runner, especially rationalizations.

## Control rule

A scenario with zero baseline failures does not test the skill. Rewrite its pressure or drop it, and record that here.
