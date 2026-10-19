# express-best-practices

**English** | [Español](express-best-practices.es.md)

Rules for writing, changing and reviewing Express.js code (middleware, routes, errors, sessions, security, production) on Express 4 or 5. Source: [`skills/express-best-practices/`](../../skills/express-best-practices/SKILL.md).

## Usage

In Claude Code: `/express-best-practices`. In Codex: `$express-best-practices`. The skill is manual-only: it never loads from an implicit prompt.

```text
/express-best-practices add a POST /login route with sessions
/express-best-practices review src/ for production readiness
/express-best-practices add an async route that reads a user from the database
```

When writing code, the skill implements every official (`O`) rule that applies, validates input at the HTTP boundary, and ends its answer with a `Rules applied` section: one line per rule, either `ID: path/to/file.js:LINE` or `ID: NOT MET: "<your words>"` when you explicitly ruled out what the rule needs (for example a dependency). When reviewing, it reports each violation as rule ID, `file:line` and fix, using the `stack-code-review` report format if that skill is installed.

## How the Express version is detected

The skill runs `scripts/detect-express-version.sh` from the project root. It prints one line per package that declares `express`, then a status line:

```text
express: major=5 resolved=5.1.0 declared=^5.0.0 dir=.
status: ok
```

- `status: no-express` or `status: error`: the skill reports it and stops.
- Each file follows the `express:` line whose `dir` is its nearest ancestor, so a monorepo with Express 4 and Express 5 packages gets the right rules per package. Handlers are never copied between majors unchanged.
- `major=unknown` (or a major other than 4 or 5): the skill states "Express major could not be determined" with the `declared` range, loads no version file and makes no single-major claim.
- `resolved` comes from `package-lock.json` and wins over `declared`. Only `package-lock.json` is read: with yarn or pnpm lockfiles there is no `resolved`, and the major comes from the declared range (`unknown` if the range gives no major, such as `latest`).
- Each package uses the nearest `package-lock.json` in its dir or an ancestor. In that lock the detector looks up `<package dir>/node_modules/express` first (the package dir relative to the lock's dir), then the hoisted `node_modules/express`, then the lockfile v1 `dependencies.express`. So in a workspace with one root lock, a package with its own nested Express keeps its own version, and a package without one gets the hoisted version. Caveat: the detector cannot see how npm hoisted packages beyond these entries, so a package with no nested entry always gets the hoisted version, even when it declares another major.

## Scope

In scope: Express and HTTP mechanics, such as middleware order, error middleware, async error handling, body parsing, input validation at the HTTP boundary, sessions and cookies, headers, proxies, redirects, rate limiting, logging, shutdown and health checks.

Out of scope: structure, layers, naming and where code goes. Those belong to the `clean-architecture` and `clean-code` skills. The skill keeps route handlers thin, gives no layout advice, and reports conflicts between Express rules and the project structure instead of choosing silently.

## Evidence tiers

Every rule is a table row in `skills/express-best-practices/references/` with an ID, the rule, a tier and a source:

- `O`: official Express documentation (expressjs.com). The skill implements these in code.
- `C`: community reference, [nodebestpractices](https://github.com/goldbergyoni/nodebestpractices).

The sources and the reasoning are in [`docs/2026-10-19-express-best-practices-research.md`](../2026-10-19-express-best-practices-research.md); the design is in [`docs/2026-10-19-express-best-practices-design.md`](../2026-10-19-express-best-practices-design.md).

## Adding or changing a rule

Add or edit one table row (ID, rule, tier, source) in the matching file under `skills/express-best-practices/references/` (`express-4.md`, `express-5.md`, `request-handling.md`, `errors.md`, `security.md`, `production.md`). Then run:

```bash
bash tests/express-best-practices/check-structure.sh
```

## Test evidence

The skill was tested on 9 pressure scenarios, each run by a runner agent that never sees the expected result and scored by a separate scorer agent. 4 scenarios discriminate (the model fails without the skill and passes with it): `login-v5`, `async-v4`, `with-clean-architecture` and `login-v5-no-deps`. The other 5 are guards: they check the skill does not misbehave (no structural advice, no version guess, no Express 4 habits forced onto Express 5) and pass without the skill too, so they are not evidence that the skill helps.

Models already write correct Express 5 route syntax and catch most items in a production review without the skill. The measured gain is in session and cookie hardening, rate limiting, HTTP-boundary validation under an architecture skill, error-middleware completeness, and reporting what could not be done. Each discriminating scenario passed in 3 of 3 repetitions with the skill. Details and caveats: [`tests/express-best-practices/README.md`](../../tests/express-best-practices/README.md).

```bash
bash tests/express-best-practices/check-structure.sh
bash tests/express-best-practices/test-detect-version.sh
```
