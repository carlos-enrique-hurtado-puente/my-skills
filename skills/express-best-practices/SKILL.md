---
name: express-best-practices
description: Use when the user explicitly invokes /express-best-practices or $express-best-practices to write, change or review Express.js code on Express 4 or 5
disable-model-invocation: true
---

# Express best practices

Rule tiers in `references/`: `O` official, `C` community.

## Flow

1. **Detect the version.** From the project root run this skill's `scripts/detect-express-version.sh --root .` with `bash`.
   - `status: no-express` or `status: error`: report it and stop.
2. **Pick the major per package.** Each file follows the `express:` line whose `dir` is its nearest ancestor. Never copy a handler between majors unchanged: in Express 5 no try/catch or wrapper whose only job is `next(err)` (V5-1), no bare async handler in Express 4 (V4-1).
   - `major=unknown` or not 4 or 5: state "Express major could not be determined" with `declared`, load no version file, make no single-major claim.
3. **Load rules.** `references/express-4.md` or `references/express-5.md`, plus every topic file the task touches:

| Task touches | File |
|---|---|
| routes, middleware order, input, body parsing, sync or CPU work | `references/request-handling.md` |
| routes, error middleware, async or callback errors, crashes | `references/errors.md` |
| sessions, cookies, login, redirects, headers, proxies, SQL, secrets | `references/security.md` |
| deploy, logging, process, shutdown, health, `NODE_ENV` | `references/production.md` |

4. **Write or review.**

## Writing code

- Implement every `O` rule in code. A comment, TODO or note ("use Redis in production") does not count, whatever the deadline.
- Adding a route requires a 4-parameter error middleware after all routes (ERR-1, REQ-1); add one if missing.
- Validate body, query and params at the HTTP boundary with a schema, rejecting bad input with a 4xx (REQ-2, REQ-7), even when the domain also validates.
- Login or sessions: a real session store (SEC-5), a renamed cookie with `secure: true` and `httpOnly: true` (SEC-6; `secure: isProd` fails it), a rate limit on login (SEC-7). TLS ending at a proxy: also set `trust proxy` (SEC-8). Plain-HTTP local development: keep `secure: true` and report the needed dev-only override.
- Add any dependency a rule needs. If the user's own words forbid it, implement the rule without it or report `ID: NOT MET: "<their words>"`; a deadline, style preference or your own judgment never qualifies.

**Required slot.** Notes and caveats go above it; the answer's final section is `Rules applied`, one line per `O` rule in the loaded files whose trigger (route, session, cookie, redirect, query, header, ...) appears in code you add or edit. Each line is exactly `ID: path/to/file.js:LINE` (implementing code), `ID: NOT MET: "<user's words>"`, or `ID: outside app code` for rules enforced outside it (TLS, proxy, process manager, Node version, `npm audit`), never `NOT MET`. An unlisted rule counts as missed.

## Reviewing

Report each violation as rule ID, `file:line`, fix, in `stack-code-review`'s format if installed.

## Scope

Keep route handlers thin; give no advice on folders, layers, naming or code placement (the architecture skill's job). REQ-2 and REQ-7 at the boundary still apply. Report conflicts with project structure; never choose silently.
