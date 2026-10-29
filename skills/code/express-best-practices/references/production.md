# Production

Rules for running an Express app in production, for Express 4 and 5.

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
