---
id: gcp-functions
name: GCP Cloud Functions
detect:
  dependencies: [firebase-functions, "@google-cloud/functions-framework"]
  files: ["firebase.json"]
  imports: [firebase-functions, "@google-cloud/functions-framework"]
skills: []
context_fields: [Generation, Runtime, Trigger(s)]
---

## Context detection

Fill the `context_fields` from the changes and the repo; ask only when inference is impossible.

- **Generation:** `Gen 1 | Gen 2 | Undetermined`. Evidence: `firebase-functions/v2` vs `v1` imports, `onRequest`/`onCall` options, `gcloud --gen2` in CI/IaC, Terraform `google_cloudfunctions2_function`. Unverified generation-dependent claims are `question (non-blocking):`.
- **Runtime:** `engines.node` in `package.json`, `runtime` in `firebase.json`/IaC, `.nvmrc`, Dockerfile.
- **Trigger(s):** HTTP (`onRequest`/`onCall`), Pub/Sub, Eventarc, Storage, Firestore, Scheduler, Tasks. Read the exported handlers and trigger config.
- Also note, when visible: region, IaC tool, test framework, validation library.

## Checklist

### HTTP handlers
- **Input:** method, `Content-Type`, body, route/query params, payload size limit, unexpected fields, types/formats/ranges, `null`/`undefined`.
- **AuthN/AuthZ:** real token verification (issuer, audience, expiry, signature); authorization by identity and permissions; do not trust client headers; no public access unless the spec requires it; IAM Invoker or other perimeter controls.
- **Responses:** correct status codes; consistent contract; no stack traces or sensitive data; client/business/infra errors distinguished; restricted CORS; CSRF when browser + cookies.
- **Async:** promises awaited/returned; no background work after responding; async errors not ignored; do not end before critical writes/publishes/calls complete.

### Event-driven triggers (Pub/Sub, Eventarc, Storage, Firestore, Scheduler, Tasks)
- **Contract:** validate the envelope (`eventId`, `source`, `type`, `subject`, timestamp, payload); versioning; backward compatibility; malformed events; do not assume fields the producer does not guarantee.
- **Idempotency:** treat events as duplicates unless a guarantee is verifiable; idempotency key; dedupe; conditional writes/transactions; no repeated emails, charges, resources or publishes; **never local memory as persistent dedupe**.
- **Retries:** distinguish transient vs permanent errors; propagate the error when a retry should fire; do not swallow retryable errors; do not retry unrecoverable errors forever; dead-letter or equivalent; backoff; retry-storm prevention; explicit poison-pill handling.
- **Order and concurrency:** do not assume global order; race conditions; read/write consistency; transactions; per-instance and multi-instance concurrency.

### Persistence and external services
Well-defined repos/gateways; no Firestore/ORM/SDK models in the domain; transactions around invariants; efficient queries; no N+1; pagination; timeouts; cancellation (`AbortSignal`); retries with backoff and limits, not duplicated across layers; network, quota and rate-limit errors; pooling for Cloud SQL and connection limits; no opening/closing heavy clients per request; no business state in memory; `/tmp` is not persistent; resource cleanup. Reusable clients may be initialized outside the handler but never hold request- or user-specific mutable state.

### IAM and runtime security
Least privilege; dedicated service account; separate deploy and runtime identities; no over-privileged accounts, no JSON keys, no credentials in the repo; no unjustified anonymous invocation; coherent ingress; service-to-service access validation; Secret Manager for secrets and rotation without code changes.

### Performance and costs
Cold starts; unnecessary dependencies; expensive init work; safe client reuse; region close to consumers; adequate timeout, memory and CPU; conscious `concurrency` (Gen 2); justified `minInstances`/`maxInstances`; efficient queries/payloads; batching; no uncontrolled fan-out or unbounded loops; DB connections; retry cost; log cost; Cloud Tasks/Pub/Sub/Workflows for long work (not inside an HTTP request). Require evidence, not preference.

### Configuration and deployment (if the diff has IaC/CI/CD/config)
Required GCP APIs; region; supported runtime; entry point; trigger; service account; minimal IAM; ingress and authentication; per-environment variables and secrets; timeout, memory, CPU, concurrency; `minInstances`/`maxInstances`; VPC Connector or Direct VPC Egress; egress `PRIVATE_RANGES_ONLY` vs `ALL_TRAFFIC`; Eventarc/Pub/Sub/Cloud Build dependencies; reproducibility; migration and rollback plan; no undocumented manual changes; declared vs expected configuration.

### Testing additions
Handlers: valid/invalid requests, authN/authZ, status codes, headers, incomplete payloads, internal errors without leaking details. Events: valid/invalid envelopes, duplicates, retries, transient/permanent errors, unprocessable messages, version changes, concurrency/order. Adapters: Firestore/Pub/Sub/Storage/Cloud SQL, external contracts, serialization/mapping, emulators if available. Missing tests are also **blocking** for complex retries/idempotency.

### Compatibility additions
Topic/queue/function names; region or trigger changes; IAM permission changes; Gen 1 ↔ Gen 2; message versioning.

**Do not invent GCP limits, flags or current behavior.** If they depend on version/runtime/generation, verify in official documentation or mark `question:`.

## How to use the skills

This piece declares no skills. If `firebase-basics` or `gcloud` is available in the session, it may be opened to verify a CLI flag or a Firebase command named in the diff; its absence is not a limitation.

## Clean Architecture in this stack

How the 7 rubric points look in Cloud Functions (examples, not new rules):
1. Business rules run in a unit test with no `firebase-functions`, `@google-cloud/*`, Express, `Request`/`Response`, Pub/Sub message or Firestore snapshot.
2. Domain and use cases import nothing from `firebase-functions` or `@google-cloud/*`.
3. A use case runs the same from an HTTP handler, a Pub/Sub trigger or a test.
4. Repository and publisher interfaces live with the use cases; Firestore/Pub/Sub/Cloud SQL/Secret Manager/Storage implementations live outside.
5. Firestore documents and event payloads are mapped to domain models at the adapter; env vars are read in one config module.
6. No cycles between handlers, use cases, adapters and config.
7. One composition root builds clients and wires them into handlers; handlers contain no business logic.

Typical violations: business logic in the handler; Firestore access from the domain; env vars inside rules.

## Severity notes

Additional `blocking` cases for this stack: a non-idempotent flow that ignores duplicate or retried events; infinite retries or runaway costs; an unauthorized invocation being possible; a broken HTTP/event contract; a missing critical test for idempotency or retries.

## Common mistakes

- Forgetting idempotency and retries on event-driven triggers: assume duplicate events unless a guarantee is verifiable.
- Treating `/tmp` or instance memory as persistent state or dedupe.
- Swallowing errors that should trigger a retry, or retrying permanent errors forever.
- Stating Gen 1/Gen 2 behavior or limits without verifying them.
