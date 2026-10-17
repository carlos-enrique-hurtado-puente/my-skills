# General evaluation criteria (8)

These apply to every stack. Stack pieces (`stacks/<id>.md`, selected via `references/stack-selection.md`) add their own checklist on top, only for the files they own. A piece never changes the report format, the severity scale, the verdict or the rubrics below.

Every finding must be specific, actionable, traceable to a file/line/function, state its risk and, when applicable, offer a concrete alternative.

**Core rule: never `blocking` for architecture or Clean Code preferences without functional impact.** Ask for evidence (load, spec, project convention) before raising any preference above `nitpick`.

## 1. Spec compliance
Coverage of acceptance criteria; success and failure paths; edge cases; business validations; compatibility with existing consumers; unrequested changes; required migrations and config; impact on other services, topics, queues, tables or collections.
Guiding questions: what does the spec require? What does the code implement? What is missing? What was added beyond the spec? What could fail in production?

## 2. Clean Architecture (Dependency Rule)
Dependencies point toward business rules, never from the domain toward frameworks, SDKs, databases or delivery mechanisms.

- **Domain:** pure rules. No framework, SDK, transport or runtime types (requests, responses, event envelopes, DB snapshots), no env vars. Models independent of tables, documents or external payloads.
- **Use cases:** one business operation each; orchestrate entities and ports; own their DTOs; no knowledge of the delivery mechanism or the persistence technology.
- **Ports and adapters:** interfaces defined inward; repositories and gateways in outer layers; explicit mapping between external DTOs and internal models.
- **Entry points = thin adapters:** receive, validate the external format, authenticate/authorize, transform to a command/DTO, run the use case, translate the result, classify and propagate errors.
- **Composition root:** one clear place wiring implementations, config and entry points. Not scattered or hidden in business logic.

Report: complex business logic in an entry point; direct infrastructure access from the domain; framework or SDK types in entities/use cases; env vars inside business rules; infrastructure instantiated in inner layers; circular dependencies; hidden Service Locator; `UtilsService`/`CommonService`/`Helper` classes mixing unrelated responsibilities.
Do not demand abstractions on trivial functions: flag only real coupling, testing difficulty or change risk.

### Diagnosis 0–7 (one point per criterion met)
1. Business rules are testable without the framework or the infrastructure.
2. Dependencies point inward.
3. Use cases are independent of the delivery mechanism.
4. Ports are defined by inner layers.
5. Persistence and external formats do not contaminate the domain.
6. The module graph has no cycles.
7. A composition root wires the concrete implementations.

`6-7` Solid · `4-5` Acceptable with debt · `2-3` Relevant coupling · `0-1` Strongly coupled.
Explain which criteria fail and what dependency inversion would be needed. Each loaded piece shows what the 7 points look like in its stack.

## 3. Clean Code
Rubric (a miss is a finding only when it hurts readability, testing or change risk in the changed code):
- Descriptive names that reveal intent; no misleading or abbreviated names.
- Small cohesive functions, one level of abstraction each.
- One responsibility per module; no function mixing validation, persistence, business rules, logging and transport.
- Low nesting and reasonable complexity; guard clauses over deep `if` pyramids.
- Strict typing; no unjustified `any` or dangerous casts.
- No dead or commented-out code; no leftover debug output.
- No significant duplication; no magic strings or numbers.
- Expressive, consistent errors; no swallowed errors.
- No premature abstractions or speculative generality.
- Boundary conditions and side effects are explicit, not hidden in helpers.
- Comments explain why, not what.

Personal style preferences are never blocking.

## 4. Security (general)
- **Secrets/config:** no secrets in the repo, logs, URLs, errors or responses; per-environment config; validate required variables at startup; no insecure defaults.
- **Inputs/data:** injection (query, command, template), SSRF, external URL validation, path traversal, output encoding/sanitization, PII minimization; never log tokens, passwords, cookies or full sensitive payloads.
- **Authentication and authorization:** verified rather than assumed; no trust in client-supplied identity; least privilege.
- **Supply chain:** updated lockfile; necessary and controlled dependencies; relevant vulnerabilities; suspicious install scripts.

## 5. Observability
Structured logs with correct severity; enough context to diagnose failures (correlation/trace ID, operation, environment); no secrets or PII in logs; distinguish expected from unexpected errors; error reporting or equivalent; metrics and alerts for critical paths when the project has the tooling.

## 6. Testing (general)
- Tests cover the changed behavior: success, invalid input, limits, invariants, expected errors, and each critical branch.
- Quality: test behavior, not internals; maintainable mocks without mocking everything; no arbitrary timing dependence; deterministic; expressive names.
- Missing tests are **blocking** when there is: critical business logic; money, permissions or sensitive data; a contract change; a high-regression-risk bugfix. The loaded pieces add their own cases.

## 7. Compatibility and regressions
Public APIs and contracts; events and schemas; names other code or consumers depend on; configuration and environment variables; runtime or framework version changes; data migrations; safe rollback; versioning; incompatible changes to responses or behavior.

## 8. Change intent and PR hygiene
- Does the diff match its stated purpose (PR description in GitHub mode, commit messages in local mode)? Is a description missing?
- Does it mix unrelated changes? Is the size reviewable?
- Are the risks documented? Are contracts with other repos or teams assumed? Raise those as `question (non-blocking):`.
- Secrets or credentials committed.
- GitHub mode only: use `gh pr checks`. Distinguish "no CI configured" from "CI did not run". Local mode: skip CI.

## Consulting other skills
Open `clean-architecture` or `clean-code` only to deepen a finding, and only when they are available in the session. Ignore their own scoring: the rubric above is the only one.

**Do not invent limits, flags or current behavior of any framework or platform.** If they depend on version or runtime, verify in official documentation or mark `question:`.
