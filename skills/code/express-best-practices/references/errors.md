# Error handling

Rules for error middleware and error propagation that apply to Express 4 and 5.

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
