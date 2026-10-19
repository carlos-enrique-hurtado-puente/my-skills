---
name: express-best-practices
description: Use when the user explicitly invokes /express-best-practices (Claude Code) or $express-best-practices (Codex) to write, change or review Express.js code (middleware, routes, error handling, sessions and cookies, security, production setup) on Express 4 or 5
disable-model-invocation: true
---

# Express best practices

Rules live in `references/`, one row each: ID, rule, tier (`O` official, `C` community), source. Cite the rule ID whenever a rule drives a choice or a finding.

## Flow

1. **Detect the version.** From the project root run `bash scripts/detect-express-version.sh` (path relative to this skill's directory).
   - `status: no-express`: say this is not an Express project and stop. `status: error`: report the message and stop.
2. **Pick the major per package.** For each file, use the `express:` line whose `dir` is its nearest ancestor. Across several packages, treat each by its own major with its own version file. Never copy a handler between majors unchanged: no Express 4 try/catch or wrapper in Express 5 (V5-1), no bare async handler in Express 4 (V4-1).
   - `major=unknown` or a major other than 4 or 5: state "Express major could not be determined" with the `declared` value, load no version file, and make no claim true for only one major.
3. **Load rules.** `references/express-4.md` or `references/express-5.md`, plus every topic file the task touches:

| Task touches | File |
|---|---|
| routes, middleware order, input, body parsing, sync or CPU work | `references/request-handling.md` |
| routes, error middleware, async or callback errors, crashes | `references/errors.md` |
| sessions, cookies, login, redirects, headers, proxies, SQL, secrets | `references/security.md` |
| deploy, logging, process, shutdown, health, `NODE_ENV` | `references/production.md` |

4. **Write or review** (below).
5. **Structure and naming:** see Scope.

## Writing code

- An `O` rule is implemented in code. A comment, TODO or sentence in your answer ("use Redis in production") does not implement it, whatever the deadline.
- Any route you add needs a 4-parameter error-handling middleware registered after all routes (ERR-1, REQ-1). If the app has none, add it.
- Validate the request at the HTTP boundary with a schema, rejecting bad input with a 4xx (REQ-2), even when the domain also validates.
- Login or sessions: a real session store (SEC-5), a renamed cookie with `secure: true` and `httpOnly: true` (SEC-6; `secure: isProd` fails it), a rate limit on the login route (SEC-7).
- A rule needing a new dependency: add it. If the user forbade new dependencies, mark the rule `NOT MET` with that reason.

**Required slot.** End your answer with `Rules applied`: every `O` rule from the loaded files that the change touches, as `ID: file:line` where code implements it, or `ID: NOT MET: reason`. A rule missing from the list counts as missed.

## Reviewing

Report each violation as rule ID, `file:line`, and the fix. The full report format belongs to `stack-code-review`.

## Scope

Keep route handlers thin and put the real logic outside them; for folders, layers and naming, defer to the architecture skill if installed. Give no layout advice. An active architecture skill decides where code goes; this skill still decides Express and HTTP mechanics, including REQ-2 at the boundary. If an Express rule conflicts with the project's structure, report the conflict instead of choosing silently.
