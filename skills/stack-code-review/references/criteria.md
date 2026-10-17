# Evaluation criteria (12)

Every finding must be specific, actionable, traceable to a file/line/function, state its risk and, when applicable, offer a concrete alternative.

## 1. Spec compliance
Coverage of acceptance criteria; success and failure paths; edge cases; business validations; compatibility with existing consumers; unrequested changes; required migrations and config; impact on other services, topics, queues, tables or collections.
Guiding questions: what does the spec require? What does the code implement? What is missing? What was added beyond the spec? What could fail in production?

## 2. Clean Architecture (Dependency Rule)
Dependencies point toward business rules, never from the domain toward frameworks, SDKs, databases or delivery mechanisms.

- **Domain:** pure rules. No `firebase-functions`, `@google-cloud/*`, Express, Firestore snapshots, Pub/Sub messages, env vars, `Request`/`Response`. Models independent of tables/documents/external payloads.
- **Use cases:** one business operation each; orchestrate entities and ports; own DTOs; no knowledge of HTTP/Pub/Sub/Eventarc/Firestore/Cloud SQL.
- **Ports and adapters:** interfaces defined inward; repositories/gateways in outer layers (persistence, messaging, Secret Manager, external services, HTTP APIs, Storage); explicit mapping external DTO ↔ internal model.
- **Handlers/triggers = thin adapters:** receive → validate external format → authenticate/authorize → transform to command/DTO → run use case → translate result/finish event → classify and propagate errors.
- **Composition root:** one clear place wiring implementations, repos, gateways, use cases, config and handlers. Not scattered or hidden in business logic.

Report: complex business logic in a handler; direct Firestore/Pub/Sub/Cloud SQL access from the domain; GCP types in entities/use cases; env vars inside business rules; infrastructure instantiated in inner layers; circular dependencies; hidden Service Locator; `UtilsService`/`CommonService`/`Helper` classes mixing unrelated responsibilities.
Do not demand abstractions on trivial functions.

### Diagnosis 0–7 (one point per criterion met)
1. Business rules testable without Google Cloud.
2. Dependencies point inward.
3. Use cases independent of the delivery mechanism.
4. Ports defined by inner layers.
5. Persistence and external formats do not contaminate the domain.
6. Module graph has no cycles.
7. Composition root wires the concrete implementations.

`6-7` Solid · `4-5` Acceptable with debt · `2-3` Relevant coupling · `0-1` Strongly framework-oriented.
Explain which criteria fail and what dependency inversion would be needed.

## 3. Clean Code
Descriptive names; small cohesive functions; one responsibility per module; low nesting; reasonable complexity; strict typing; no unjustified `any` or dangerous casts; no dead/commented-out code or temporary `console.log`; no significant duplication; no magic strings/numbers; expressive and consistent errors; no premature abstractions; no functions mixing validation + persistence + business + logging + HTTP response. Personal style preferences are never blocking.

## 4. HTTP handlers
- **Input:** method, `Content-Type`, body, route/query params, payload size limit, unexpected fields, types/formats/ranges, `null`/`undefined`.
- **AuthN/AuthZ:** real token verification (issuer, audience, expiry, signature); authorization by identity and permissions; do not trust client headers; no public access unless the spec requires it; IAM Invoker or other perimeter controls.
- **Responses:** correct status codes; consistent contract; no stack traces or sensitive data; client/business/infra errors distinguished; restricted CORS; CSRF when browser + cookies.
- **Async:** promises awaited/returned; no background work after responding; async errors not ignored; do not end before critical writes/publishes/calls complete.

## 5. Event-driven triggers (Pub/Sub, Eventarc, Storage, Firestore, Scheduler, Tasks)
- **Contract:** validate the envelope (`eventId`, `source`, `type`, `subject`, timestamp, payload); versioning; backward compatibility; malformed events; do not assume fields the producer does not guarantee.
- **Idempotency:** treat events as duplicates unless a guarantee is verifiable; idempotency key; dedupe; conditional writes/transactions; no repeated emails, charges, resources or publishes; **never local memory as persistent dedupe**.
- **Retries:** distinguish transient vs permanent errors; propagate the error when a retry should fire; do not swallow retryable errors; do not retry unrecoverable errors forever; dead-letter or equivalent; backoff; retry-storm prevention; explicit poison-pill handling.
- **Order and concurrency:** do not assume global order; race conditions; read/write consistency; transactions; per-instance and multi-instance concurrency.

## 6. Persistence and external services
Well-defined repos/gateways; no Firestore/ORM/SDK models in the domain; transactions around invariants; efficient queries; no N+1; pagination; timeouts; cancellation (`AbortSignal`); retries with backoff and limits, not duplicated across layers; network, quota and rate-limit errors; pooling for Cloud SQL and connection limits; no opening/closing heavy clients per request; no business state in memory; `/tmp` is not persistent; resource cleanup. Reusable clients may be initialized outside the handler but never hold request- or user-specific mutable state.

## 7. Security
- **IAM/runtime:** least privilege; dedicated service account; separate deploy and runtime identities; no over-privileged accounts, no JSON keys, no credentials in the repo; no unjustified anonymous invocation; coherent ingress; service-to-service access validation.
- **Secrets/config:** Secret Manager; no secrets in logs/URLs/errors/responses; per-environment config; validate required variables at startup; no insecure defaults; rotation without code changes.
- **Inputs/data:** query injection, SSRF, external URL validation, path traversal, sanitization, PII minimization, never log tokens/passwords/cookies/full sensitive payloads; encryption and access control.
- **Supply chain:** updated lockfile; controlled and necessary dependencies; relevant vulnerabilities; suspicious install scripts; artifact integrity.

## 8. Observability
Structured logs; correct severity; correlation/trace ID; identify function, version, environment and operation; enough logs to diagnose failures; no secrets/PII; Error Reporting or equivalent; business, latency, error, retry and throughput metrics; alerts for critical errors; distinguish expected from unexpected errors; correlation with downstream calls.

## 9. Performance and costs
Cold starts; unnecessary dependencies; expensive init work; safe client reuse; region close to consumers; adequate timeout, memory and CPU; conscious `concurrency` (Gen 2); justified `minInstances`/`maxInstances`; efficient queries/payloads; batching; no uncontrolled fan-out or unbounded loops; DB connections; retry cost; log cost; Cloud Tasks/Pub/Sub/Workflows for long work (not inside an HTTP request). Require evidence, not preference.

## 10. Testing
- **Domain:** rules, success, invalid input, limits, invariants, expected errors.
- **Use cases:** orchestration, port interactions, dependency errors, transactionality, no duplicated effects.
- **Handlers:** valid/invalid requests, authN/authZ, status codes, headers, incomplete payloads, internal errors without leaking details.
- **Events:** valid/invalid envelopes, duplicates, retries, transient/permanent errors, unprocessable messages, version changes, concurrency/order.
- **Adapters:** Firestore/Pub/Sub/Storage/Cloud SQL, external contracts, serialization/mapping, emulators if available.
- **Quality:** test behavior, not internals; maintainable mocks without mocking everything; no arbitrary timing dependence; deterministic; expressive names; critical branches covered.

Missing tests are **blocking** when there is: critical business logic; money, permissions or sensitive data; complex retries/idempotency; a contract change; a high-regression-risk bugfix.

## 11. Compatibility and regressions
HTTP APIs; events; topic/queue/function names; schemas; region or trigger changes; IAM permission changes; environment variables; runtime; Gen 1 ↔ Gen 2; data migrations; safe rollback; message versioning; existing consumers; incompatible status-code or response changes.

## 12. Configuration and deployment (if the diff has IaC/CI/CD/config)
Required GCP APIs; region; supported runtime; entry point; trigger; service account; minimal IAM; ingress and authentication; per-environment variables and secrets; timeout, memory, CPU, concurrency; `minInstances`/`maxInstances`; VPC Connector or Direct VPC Egress; egress `PRIVATE_RANGES_ONLY` vs `ALL_TRAFFIC`; Eventarc/Pub/Sub/Cloud Build dependencies; reproducibility; migration and rollback plan; no undocumented manual changes; declared vs expected configuration.

**Do not invent GCP limits, flags or current behavior.** If they depend on version/runtime/generation, verify in official documentation or mark `question:`.
