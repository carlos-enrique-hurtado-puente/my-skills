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

### Baseline outcome, 2026-10-19

Eight scenarios were baselined without the skill, and `login-v5-no-deps` was added during REFACTOR (nine in total). Three of the first eight **discriminate** (the runner fails at least one bullet on the current prompt) and five are **guards**; `login-v5-no-deps` also discriminates.

| Scenario | Baseline | Role |
|---|---|---|
| `login-v5` | FAIL (3 bullets) | discriminating |
| `monorepo-mixed` | FAIL (3 bullets) on the `/healthz` prompt, which was retired because a health check should answer 503 itself; PASS on the replacement (`GET /users/:id`) | guard |
| `with-clean-architecture` | FAIL (1 bullet) | discriminating |
| `async-v4` | FAIL (1 bullet) on the second prompt; the first prompt passed and was retired (`baseline v1`) | discriminating |
| `routes-v5` | PASS on both prompts (`baseline v1`, `baseline v2`) | guard |
| `scope-architecture` | PASS | guard |
| `unknown-version` | PASS | guard |
| `hardening-v4` | PASS | guard |

`login-v5-no-deps`: added during REFACTOR to test the `NOT MET` exit; classification recorded in its Results.

A guard checks that the skill does not misbehave: no structural advice, no version guess, rule IDs cited in reviews, no Express 4 habits forced onto Express 5. Passing without the skill is expected, so guards are not evidence that the skill helps; their value shows only in with-skill runs.

The plan asked for at least 5 of 8 scenarios to fail at baseline. Three do (`login-v5`, `async-v4`, `with-clean-architecture`). `routes-v5` was hardened once and still passed, so it became a guard instead of being rewritten again. The honest reading: the runner model already writes correct Express 5 route syntax and catches most items in a production review; its gaps are session and cookie hardening, rate limiting, per-version consistency across services, HTTP-boundary validation under an architecture skill, and error-middleware completeness.

### GREEN outcome, 2026-10-19 (`green-1`, plus `green-2` for the replaced `monorepo-mixed` prompt)

With the skill, all eight scenarios pass. On the three discriminating scenarios the result moved from FAIL to PASS (`login-v5` 3 failing bullets to 0, `async-v4` 1 to 0, `with-clean-architecture` 1 to 0). The evidence that the skill helps rests on those three single runs; the `refactor-N` entries repeat them to check variance. The five guards passing means the skill did not break behavior the model already got right.

### REFACTOR outcome, 2026-10-19 (`refactor-1` to `refactor-3`, run on SKILL.md after the wording was tightened)

| Scenario | Baseline | With skill, 3 repetitions |
|---|---|---|
| `login-v5` | FAIL (3 bullets) | 3 of 3 PASS |
| `async-v4` | FAIL (1 bullet) | 3 of 3 PASS |
| `with-clean-architecture` | FAIL (1 bullet) | 3 of 3 PASS |
| `login-v5-no-deps` | FAIL (4 bullets) | 2 of 3 PASS; the failure was the shape of the `Rules applied` section. After making that section the final one with line numbers (`refactor-4` to `refactor-6`): 3 of 3 PASS |

`login-v5-no-deps` is discriminating (it fails at baseline) and is the check on the `NOT MET` exit. In `refactor-2` and `refactor-3` of `login-v5-no-deps` (its two passing runs before the wording fix), the runner reported `SEC-5: NOT MET` quoting the user's dependency instruction, although a hand-written store was possible; the scenario allows it. Scorers flagged `SEC-5: NOT MET` as avoidable in three of the six with-skill runs; the skill's wording ("implement the rule without it or report NOT MET") permits both.
