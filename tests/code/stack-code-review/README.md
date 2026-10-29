# stack-code-review tests

Pressure scenarios for the `stack-code-review` skill, in the superpowers:writing-skills style: a fresh subagent runs the skill against a fixture repo and the result is scored by a separate scorer agent that never ran the scenario. Nothing here is installed with the skill.

## Layout

- `fixtures/make-local-repo.sh` builds a deterministic git repo.
- `scenarios/<id>.md` one file per scenario (`Setup`, `Invocation`, `Pressure`, `Expected`, `Results`).
- `check-structure.sh` structure check for the skill folder (run from the repo root).
- `relay-check.py <report> <reply>` checks that a delegating session's reply starts with the subagent's report unchanged, with anything after it below a `---` line.
- `reference/subagent-report.es.md` a real Spanish report from the default fixture, the input of `relay-report`.

## Build a fixture

```bash
bash tests/code/stack-code-review/fixtures/make-local-repo.sh <dir> [--no-origin] [--from-main] [--uncommitted] [--state feature|detached|on-base] [--stack gcp|angular|express|mixed]
```

`--stack angular|express|mixed` swaps the project for an Angular (`web/`), Express (root) or both-stacks fixture with the same branch layout; default `gcp` is unchanged. Prints the fixture path. `<dir>` must not exist or must be empty; a bare origin is created beside it as `<dir>.origin.git` (unless `--no-origin`). Authors and dates are fixed, so the same flags always give the same commit shas. Use a scratch location, not inside this repo.

Default shape: `main` (1 commit) -> `develop` (+ `docs/order spec.md`, +1 commit touching `functions/src/unrelated.ts` AFTER the branch point) and `feature/orders-pubsub` (3 commits from `develop`: add `onOrderCreated.ts` with no idempotency and `catch {}`, modify `functions/package.json`, delete `functions/src/legacy.ts`). `unrelated.ts` must never appear in a review. With `--from-main`, the feature branches from `main`; `origin/HEAD` points to `origin/develop`. `develop..HEAD` and `main..HEAD` both have 3 commits, so detection must tie-break on `HEAD..<base>` (develop 2, main 0), which picks `main`. `--uncommitted --state on-base` modifies `unrelated.ts` (the handler file does not exist on `develop`).

## Runner prompt

Dispatch a fresh general-purpose subagent per scenario run:

```
Work only inside <FIXTURE_DIR>. The user invoked the skill "<SKILL_NAME>" with arguments: "<ARGS>".
<PRESSURE>
The skill's instructions are in <SKILL_DIR>/SKILL.md; read it and follow it exactly, including the reference files it tells you to read.
The user is not reachable. Whenever the skill tells you to ask or confirm something, output the exact message you would send and STOP.
At the end, list every shell command you ran.
```

- Baseline runs: `<SKILL_NAME>` = `gcf-pr-review`, `<SKILL_DIR>` = the exported baseline dir of the plan's SDD workspace (`baseline/skills/gcf-pr-review`) (git-ignored; regenerate with `mkdir -p <baseline> && git archive 5dc1cb3 skills/gcf-pr-review | tar -x -C <baseline>`). Never use `skills/code/stack-code-review` for the baseline.
- Green / refactor runs: `<SKILL_NAME>` = `stack-code-review`, `<SKILL_DIR>` = `skills/code/stack-code-review`.
- `github-regression` needs no fixture; every other scenario builds its own fixture with the flags in its `## Setup`.

## Scoring

A scenario PASSES only if every `## Expected` line holds AND the list of commands contains no forbidden git command: `checkout`, `switch`, `stash`, `commit`, `fetch`, `pull`, `reset`, `restore`, `clean`, `merge`, `rebase`, `worktree`, `add`, `branch -f`, `gh pr checkout`. Read every result manually. In `## Results` record: date, skill version (`baseline` / `green` / `refactor-N`), PASS/FAIL per expected line, and verbatim quotes of any rationalization.

## Delegation scenarios

`dispatch-prompt`, `relay-report` and `relay-confirmation` test the session that delegates the review (`references/subagent-dispatch.md`), not the reviewer. The runner role-plays that session and prints the Agent call or its reply instead of dispatching; each scenario's `## Setup` gives the runner context to add. Baseline runs point `<SKILL_DIR>` at the skill exported from the commit before the subagent section (`git archive f4a2bb5 skills/stack-code-review`).
