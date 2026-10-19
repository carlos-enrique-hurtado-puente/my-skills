# Request handling

Rules for routing, validation and body handling that apply to Express 4 and 5.

| ID | Rule | Tier | Source |
|---|---|---|---|
| REQ-1 | Register the 404 handler and the error-handling middleware after all routes and other middleware. | O | https://expressjs.com/en/guide/error-handling.html |
| REQ-2 | Filter and sanitize all user input (body, query, params, headers); validating it is the app's responsibility, not Express's. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| REQ-3 | Cap request body size (`express.json({ limit })`) or cap it at the reverse proxy. | C | https://github.com/goldbergyoni/nodebestpractices |
| REQ-4 | Export `app` separately from `app.listen()` so tests call it without binding a port. | C | https://github.com/goldbergyoni/nodebestpractices |
| REQ-5 | Do not call synchronous Node or module APIs inside request handlers; they are acceptable only at startup. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| REQ-6 | Move CPU-intensive work to worker threads from a fixed pool, not one worker per request. | O | https://expressjs.com/en/advanced/best-practice-performance.html |
| REQ-7 | Validate request body, query and params at the HTTP boundary with a schema, and reject invalid input with a 4xx. | C | https://github.com/goldbergyoni/nodebestpractices |
