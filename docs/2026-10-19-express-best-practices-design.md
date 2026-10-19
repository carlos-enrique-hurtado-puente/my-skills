# Design: `express-best-practices`

- **Date:** 2026-10-19
- **Repo:** `my-skills` (`skills/express-best-practices/`)
- **Evidence:** [research](2026-10-19-express-best-practices-research.md) (rule catalog, tiers, sources)
- **Plan:** [plan](2026-10-19-express-best-practices-plan.md)
- **Status:** implemented

## 1. Intent

Carlos works on Express projects on different major versions (one on 4, one on 5). He wants a skill that makes an agent write and review Express code following practices backed by real evidence, without contradicting the `clean-code` and `clean-architecture` skills he already uses.

## 2. Goals

1. **One skill, version-aware.** Common rules apply to Express 4 and 5; the few version-specific rules live in one file per major, chosen from the project's detected Express version.
2. **Evidence on every rule.** Each rule carries a tier (`O` official, `C` community) and a source URL that was read.
3. **No overlap with `clean-code` / `clean-architecture`.** The skill covers Express and HTTP mechanics only (see 6).
4. **Manual invocation only**, per `AGENTS.md`: `/express-best-practices` (Claude Code), `$express-best-practices` (Codex).
5. **Proven by scenarios**, not only by reading: baseline without the skill, then with it (writing-skills RED/GREEN/REFACTOR).

## 3. Non-goals

- Folder structure, layering, naming, function size, SOLID, domain modeling (owned by the two clean-* skills).
- Docker, CI/CD and deployment tooling.
- Express 2.x, 3.x, or versions above 5.
- Claims about Express 4 end of life or support windows.
- Replacing `stack-code-review`. That skill's "Express with no piece" case stays as is; turning this skill into a stack piece is a separate, later decision.

## 4. Anti-goals

- A rule without an `O` or `C` source.
- Express 5 syntax suggested in an Express 4 project, or the reverse.
- Guessing a version. If the version cannot be determined, say so and apply only the common rules.
- Advice that tells the agent to restructure a project's architecture.

## 5. Structure

```
skills/express-best-practices/
  SKILL.md
  agents/openai.yaml
  references/
    request-handling.md   REQ-*   middleware order, input validation, body limits, sync APIs
    errors.md             ERR-*   error middleware, async/callback errors, crash policy
    security.md           SEC-*   helmet, cookies/sessions, redirects, rate limiting, trust proxy
    production.md         PRD-*   NODE_ENV, logging, process, clustering, shutdown
    express-4.md          V4-*    Express 4 only
    express-5.md          V5-*    Express 5 only
  scripts/detect-express-version.sh
```

Docs live outside the skill: `docs/skills/express-best-practices.md` (+ `.es.md`). Tests in `tests/express-best-practices/`.

### Rule format

Every rule is one row in a reference file:

`| <PREFIX>-<n> | <rule text, with the reason> | O or C | <https URL> |`

`PREFIX` equals the file's prefix (`REQ`, `ERR`, `SEC`, `PRD`, `V4`, `V5`). IDs are unique across the skill. The agent cites the ID when a rule drives a choice or a finding.

## 6. Scope boundary with clean-code and clean-architecture

| Concern | Owner |
|---|---|
| Middleware order, error middleware contract, async error forwarding, HTTP security headers, cookies and sessions, `trust proxy`, process and `NODE_ENV` behavior | this skill |
| Folder layout, layers, dependency direction, naming, function size, SOLID, where business logic lives | `clean-architecture`, `clean-code` |

Rules:

- Reference files contain none of: SOLID, folder or directory structure, naming conventions, dependency rule, repository pattern, use case. `check-structure.sh` greps for them.
- `SKILL.md` may say one thing about structure: keep route handlers thin and put the real logic outside them, and defer detail to the architecture skill if installed.
- If a project already has an architecture, the skill adapts to it.
- If an Express rule seems to conflict with how the project is structured, the agent reports the conflict instead of silently choosing.

## 7. Version handling

`scripts/detect-express-version.sh [--root <dir>]` is read-only and works on macOS bash 3.2. It walks `<dir>` (default: git top level, else `.`) skipping `node_modules`, and for each `package.json` that lists `express` in `dependencies` or `devDependencies` prints:

```
express: major=<integer|unknown> resolved=<version|none> declared=<range-without-spaces> dir=<dir relative to root, '.' for root>
status: ok            (at least one express package found)
status: no-express    (none found)
status: error         (+ message: line, exit code 2)
```

- **`resolved`** comes from the `package-lock.json` in the package's directory, or in an ancestor up to the root (workspaces). It wins over `declared`. In that lock the lookup order is `<package dir relative to the lock's dir>/node_modules/express`, then the hoisted `node_modules/express`, then the lockfile v1 `dependencies.express`.
- **`declared`** gives a major only when it matches `^[\^~=v]*[0-9]+(\.[0-9x*]+)*$`. Anything else (`latest`, `*`, `>=4 <6`, `||` ranges, git, file, `workspace:`, `npm:` specifiers, empty) is ambiguous and yields `major=unknown` unless `resolved` exists.
- Only `package-lock.json` is read. With yarn or pnpm locks the result is `resolved=none`, and the major comes from `declared`.

In a monorepo the skill uses the entry whose `dir` is the nearest ancestor of the file being worked on.

## 8. Skill behavior (`SKILL.md`)

1. Run the detector. `no-express`: say this is not an Express project and stop.
2. Pick the major for the files at hand. `unknown` or a major other than 4 or 5: say so, apply common rules only, and make no version-specific claims.
3. Load `references/express-<major>.md` plus only the topic files the task touches.
4. Write or review code following the rules, citing rule IDs. In review, report violations as rule ID + location + the fix; the full report format belongs to `stack-code-review`.
5. Structure and naming questions: defer (see 6).

`SKILL.md` stays under 500 words. Detail lives in `references/`.

## 9. Testing

- `tests/express-best-practices/test-detect-version.sh`: the detector against small fixture projects.
- `tests/express-best-practices/check-structure.sh`: frontmatter, manual-only, `openai.yaml`, word budget, rule-row format (tier and source required, unique IDs, prefix matches file), scope-guard grep, every reference linked from `SKILL.md`.
- `tests/express-best-practices/scenarios/*.md`: pressure scenarios in the repo's existing format (Setup / Invocation / Pressure / Expected / Results). Runner agents never see Expected; a separate scorer agent grades. Baseline runs (no skill) are recorded before the skill is written.

## 10. Open questions

1. **Express 4 rules:** resolved. V4-1, V4-3 and V4-4 are sourced from the `/en/4x/` pages; V4-2 was dropped (see the research doc).
2. **sameSite** is not a rule until sourced.
3. Whether to later register this skill as a `stack-code-review` piece is deferred.
