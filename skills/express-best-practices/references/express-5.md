# Express 5

Rules that apply only to Express 5 apps.

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
