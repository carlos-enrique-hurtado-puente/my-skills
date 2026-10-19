# Security

Security rules that apply to Express 4 and 5.

| ID | Rule | Tier | Source |
|---|---|---|---|
| SEC-1 | Use `helmet()` and keep its defaults unless there is a specific reason to change a header. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-2 | Call `app.disable('x-powered-by')`. This reduces fingerprinting; it is not a defense on its own. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-3 | Use TLS for anything sensitive; terminating it at a reverse proxy is the usual setup. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-4 | Check the host of a user-supplied URL before passing it to `res.redirect()` or `res.location()`. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-5 | Do not use `express-session`'s default in-memory store in production; configure a real session store. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-6 | Do not keep the default session cookie name; set `secure: true`, `httpOnly: true`, and restrict `domain`, `path` and `expires`. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-7 | Rate-limit login endpoints: block repeated failures per username+IP pair and, separately, per IP over a longer window. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-8 | Set `trust proxy` to the known proxy addresses or subnets, not `true`, and make the last trusted proxy overwrite `X-Forwarded-*`. | O | https://expressjs.com/en/guide/behind-proxies.html |
| SEC-9 | Run `npm audit` regularly and keep dependencies updated. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-10 | Use parameterized queries or prepared statements; never build SQL by string concatenation. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-11 | Check regular expressions for catastrophic backtracking (ReDoS), for example with `safe-regex`. | O | https://expressjs.com/en/advanced/best-practice-security.html |
| SEC-12 | Keep secrets out of source and committed config; read them from the environment or a secret manager. | C | https://github.com/goldbergyoni/nodebestpractices |
| SEC-13 | Run the Node process as a non-root user. | C | https://github.com/goldbergyoni/nodebestpractices |
