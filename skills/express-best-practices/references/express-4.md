# Express 4

Rules that apply only to Express 4 apps.

| ID | Rule | Tier | Source |
|---|---|---|---|
| V4-1 | Rejected promises from async handlers are not forwarded to `next`; catch the error and call `next(err)`, return the promise with `.catch(next)`, or use a shared wrapper, otherwise the rejection is unhandled and can crash the process. | O | https://expressjs.com/en/4x/guide/error-handling.html |
| V4-3 | `express.json()` and `express.urlencoded()` are built in from 4.16.0; `body-parser` is not needed for them. | O | https://expressjs.com/en/4x/api/express/ |
| V4-4 | Path strings use the Express 4 syntax: unnamed `*` wildcards read as `req.params[0]`, `?` `+` `()` in strings, and regex in parentheses after a param (`/user/:userId(\d+)`). Do not use Express 5 syntax (`/*splat`, `{}`). | O | https://expressjs.com/en/4x/guide/routing.html |
