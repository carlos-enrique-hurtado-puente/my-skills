# Express best practices: research and evidence

- **Date:** 2026-10-19
- **Used by:** [design](2026-10-19-express-best-practices-design.md), [plan](2026-10-19-express-best-practices-plan.md)
- **Purpose:** the rule catalog the `express-best-practices` skill is built from, each rule with its evidence tier and source.

## Evidence tiers

| Tier | Meaning |
|---|---|
| `O` | Official Express documentation (expressjs.com). |
| `C` | Community reference, not official: [goldbergyoni/nodebestpractices](https://github.com/goldbergyoni/nodebestpractices). |

Blog posts (DEV, LogRocket, Medium) were read only to cross-check and are **not** sources. A rule enters the skill only with an `O` or `C` source that was actually read.

## Sources read

| Short name | URL |
|---|---|
| perf | https://expressjs.com/en/advanced/best-practice-performance.html |
| security | https://expressjs.com/en/advanced/best-practice-security.html |
| errors | https://expressjs.com/en/guide/error-handling.html |
| migrating-5 | https://expressjs.com/en/guide/migrating-5.html |
| proxies | https://expressjs.com/en/guide/behind-proxies.html |
| nbp | https://github.com/goldbergyoni/nodebestpractices (index only; the last 26,570 characters of the page were not read) |

## Common rules (Express 4 and 5)

Rows are already in the final reference-file format. Prefix = file: `REQ` request-handling, `ERR` errors, `SEC` security, `PRD` production.

### request-handling.md

| ID | Rule | Tier | Source |
|---|---|---|---|
| REQ-1 | Register the 404 handler and the error-handling middleware after all routes and other middleware. | O | https://expressjs.com/en/guide/error-handling.html |
| REQ-2 | Filter and sanitize all user input (body, query, params, headers); validating it is the app's responsibility, not Express's. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| REQ-3 | Cap request body size (`express.json({ limit })`) or cap it at the reverse proxy. | C | https://github.com/goldbergyoni/nodebestpractices |
| REQ-4 | Export `app` separately from `app.listen()` so tests call it without binding a port. | C | https://github.com/goldbergyoni/nodebestpractices |
| REQ-5 | Do not call synchronous Node or module APIs inside request handlers; they are acceptable only at startup. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| REQ-6 | Move CPU-intensive work to worker threads from a fixed pool, not one worker per request. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| REQ-7 | Validate request body, query and params at the HTTP boundary with a schema, and reject invalid input with a 4xx. | C | https://github.com/goldbergyoni/nodebestpractices |

### errors.md

| ID | Rule | Tier | Source |
|---|---|---|---|
| ERR-1 | Error-handling middleware takes exactly four parameters `(err, req, res, next)`; Express identifies it by arity. | O | https://expressjs.com/en/guide/error-handling.html |
| ERR-2 | In callback-based or timer code, catch the error and call `next(err)`; Express never sees errors it is not handed. | O | https://expressjs.com/en/guide/error-handling.html |
| ERR-3 | In a custom error handler, if `res.headersSent` is true, delegate with `next(err)` instead of writing a response. | O | https://expressjs.com/en/guide/error-handling.html |
| ERR-4 | An error handler that does not call `next` must end the response, or the request hangs. | O | https://expressjs.com/en/guide/error-handling.html |
| ERR-5 | Keep error handling in one central place invoked from the error middleware, not repeated in each route. | C | https://github.com/goldbergyoni/nodebestpractices |
| ERR-6 | Distinguish operational errors (bad input, upstream down) from programmer errors; carry `status` or `statusCode` on errors, which the default handler reads. | C | https://github.com/goldbergyoni/nodebestpractices |
| ERR-7 | In production, never send stack traces or internal error details to the client. | O | https://expressjs.com/en/guide/error-handling.html |
| ERR-8 | Do not listen for `uncaughtException` to keep running; let the process crash and be restarted by a supervisor. | O | https://expressjs.com/en/advanced/best-practice-performance.html |

### security.md

| ID | Rule | Tier | Source |
|---|---|---|---|
| SEC-1 | Use `helmet()` and keep its defaults unless there is a specific reason to change a header. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-2 | Call `app.disable('x-powered-by')`. This reduces fingerprinting; it is not a defense on its own. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-3 | Use TLS for anything sensitive; terminating it at a reverse proxy is the usual setup. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-4 | Check the host of a user-supplied URL before passing it to `res.redirect()` or `res.location()`. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-5 | Do not use `express-session`'s default in-memory store in production; configure a real session store. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-6 | Do not keep the default session cookie name; set `secure: true`, `httpOnly: true`, and restrict `domain`, `path` and `expires`. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-7 | Rate-limit login endpoints: block repeated failures per username+IP pair and, separately, per IP over a longer window. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-8 | Set `trust proxy` to the known proxy addresses, subnets or a hop count, preferred over `true`, and make the last trusted proxy overwrite `X-Forwarded-*`. | O | https://expressjs.com/en/guide/behind-proxies.html |
| SEC-9 | Run `npm audit` regularly and keep dependencies updated. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-10 | Use parameterized queries or prepared statements; never build SQL by string concatenation. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-11 | Check regular expressions for catastrophic backtracking (ReDoS), for example with `safe-regex`. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-12 | Keep secrets out of source and committed config; read them from the environment or a secret manager. | C | https://github.com/goldbergyoni/nodebestpractices |
| SEC-13 | Run the Node process as a non-root user. | C | https://github.com/goldbergyoni/nodebestpractices |

### production.md

| ID | Rule | Tier | Source |
|---|---|---|---|
| PRD-1 | Set `NODE_ENV=production`, through the init system rather than an interactive shell, and do not read it in hot paths. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| PRD-2 | Do not use `console.log` for production logging; use a logger such as pino, writing to stdout. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| PRD-3 | Do not run `node server.js` bare in production; a process manager or the init system restarts it after a crash. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| PRD-4 | Keep the app stateless (sessions and shared state in Redis or similar) so one instance per CPU core, or several behind a load balancer, is safe. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| PRD-5 | Run behind a reverse proxy that handles compression, TLS, static files and caching. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| PRD-6 | Run the latest Node.js LTS. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| PRD-7 | Shut down gracefully on SIGTERM: stop accepting connections, drain in-flight requests, close resources, then exit. | C | https://github.com/goldbergyoni/nodebestpractices |
| PRD-8 | Lock dependencies and install with `npm ci` in CI and production. | C | https://github.com/goldbergyoni/nodebestpractices |
| PRD-9 | Expose a health endpoint for the supervisor or load balancer. | C | https://github.com/goldbergyoni/nodebestpractices |
| PRD-10 | Put a request or transaction ID on every log line. | C | https://github.com/goldbergyoni/nodebestpractices |

## Express 5 rules

### express-5.md

| ID | Rule | Tier | Source |
|---|---|---|---|
| V5-1 | Do not wrap async handlers in `express-async-handler` or `.catch(next)`; rejected promises are forwarded to the error handlers. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-2 | Wildcards must be named: `/*splat`, and `/{*splat}` to also match the root. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-3 | Optional segments use braces (`/:file{.:ext}`); regex characters are not supported in path strings, so use an array of paths. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-4 | `req.body` is `undefined`, not `{}`, when no body parser ran; never read its fields unguarded. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-5 | `express.urlencoded` defaults to `extended: false`; set `extended: true` only if nested form fields are needed. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-6 | `req.query` is a read-only getter; do not assign to it. The default query parser is now `simple`: no nested objects unless the `query parser` setting is changed. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-7 | Use `res.status(n).json(obj)` and `res.redirect(status, url)`; `res.json(obj, status)` and `res.redirect('back')` are removed. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-8 | `res.status()` accepts only integers from 100 to 999 and throws otherwise. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-9 | `app.listen(port, host, cb)` passes server errors such as `EADDRINUSE` to `cb`; handle them there. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-10 | `express.static` ignores dotfiles by default; serve `/.well-known` with `dotfiles: 'allow'`. | O | https://expressjs.com/en/guide/migrating-5.html |
| V5-11 | Express 5 requires Node.js 18 or higher. | O | https://expressjs.com/en/guide/migrating-5.html |

## Express 4 rules

### express-4.md

Verified against the Express 4.x documentation and changelog. IDs keep the candidate numbering; V4-2 was dropped, so there is no V4-2.

| ID | Rule | Tier | Source |
|---|---|---|---|
| V4-1 | Rejected promises from async handlers are not forwarded to `next`; catch the error with try/catch and call `next(err)`, or return the promise with `.catch(next)`; otherwise the rejection is unhandled and can crash the process. | O | https://expressjs.com/en/4x/guide/error-handling.html |
| V4-3 | `express.json()` and `express.urlencoded()` are built in from 4.16.0; `body-parser` is not needed for them. | O | https://expressjs.com/en/4x/api/express/ |
| V4-4 | Path strings use the Express 4 syntax: unnamed `*` wildcards read as `req.params[0]`, `?` `+` `()` in strings, and regex in parentheses after a param (`/user/:userId(\d+)`). Do not use Express 5 syntax (`/*splat`, `{}`). | O | https://expressjs.com/en/4x/guide/routing.html |

Dropped: **V4-2** (shared async wrapper instead of per-route `try/catch`): no `O` source states it as a rule. The 4.x error-handling page only shows `try/catch` and `.catch(next)`; V4-1 names only those two ways to forward errors.

Also confirmed in 4.x: the 4.x error-handling page states the ERR-2 and ERR-3 behavior (`next(err)` from async callbacks; `res.headersSent` delegation) and that stack traces are omitted in production. The 4.16.0 entry in `History.md` (https://github.com/expressjs/express/blob/4.x/History.md) reads "Add `express.json` and `express.urlencoded` to parse bodies".

## Gaps and cautions

- **sameSite:** `nbp` has a practice titled "Modify session middleware settings", but its detail was not read. `sameSite` is therefore **not** a rule until sourced.
- **nbp coverage:** the last 26,570 characters of the page (the rest of the Docker section and beyond) were not read. Docker is out of scope for the skill.
- **Official pages describe the current release.** The 4.x `errors` page confirms ERR-2, ERR-3 and ERR-7. The `security` page names no version and its content applies to 4. The 4.x application API documents `trust proxy` and warns that `X-Forwarded-*` is easily spoofed, but the advice to prefer known addresses, subnets or a hop count over `true` (SEC-8) is stated in the `proxies` page, which was not re-read for 4.x.
- **Express 4 support status** (end of life, security-fix window) was not researched and the skill makes no claim about it.
