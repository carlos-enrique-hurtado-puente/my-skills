# Block 2: how to write each statement (P5 to P7)

Evidence and examples for the rules in `SKILL.md`. "Before → after" examples are illustrative: rewritten from the team's specs, not their original text.

## P5. A criterion is an event followed by an observable result; tasks go apart

**Support: Backed** for the shape of a criterion. **Own** for the rest (separate task list, destination of every criterion, where operational artifacts live).

Rule details:
- Each acceptance criterion reads "given a context, when an event happens, then something observable happens".
- It names no collections, keys, flags or commands.
- A **task** (run a script, deploy an index, update the catalog, assign codes) goes in a separate list of deployment tasks, outside the criteria.
- Each task that leaves an **operational artifact** (a script, a policy configured in a console, an index) says where it lives (repo, console, elsewhere) and what evidence is attached. It is a deliverable, not a detail.
- **Every criterion and every task has a destination:** it goes into a ticket of this delivery or is declared out of it, with the reason. A requirement for a future story does not go in the criteria list: it goes in "Out of scope" or in a note for that story.

Quick test (from the Cucumber guide): if the sentence would have to change when the implementation changes, it is not a criterion.

Extra test: if the criterion mentions the path that leads to the situation ("because of a stale list", "if the front does not prevent it"), rewrite it without the path. Then, if the mechanism changes, the test cases derived from the criterion still hold.

**Why (team data).**
- ITV-804: 5 of 13 criteria failed QA review, and all five were operational evidence: script idempotency, count with `--dry-run`, backup restore, catalog update and log codes. The behavior criteria passed first time.
- ITV-823: AC-13 to AC-15 described a manual script, AC-16 an index declared in a file, AC-03 a test method ("saving the flow and closing the next conversation, not reading flowbuilder-usages"). QA failed 7 of 16 criteria on the first pass: three for deviation from the spec and four for lack of evidence.
- ITV-835: a criterion said `days` carries the keys `"1"` to `"5"`. When the contract changed it made no sense and its certification case was marked "Not applicable".
- ITV-878: criterion 5 said "if the front did not prevent it (stale list or another path), the backend rejects…". With a live listener, that path stopped existing in the UI, and certification cases CA-7 and CA-8 had to change: they are now checked by calling publish without going through the front.
- Destination of each criterion (sprints 15, 16): in ITV-754, AC-09 and AC-10 reached no ticket. In ITV-736, CA-F6 reached neither the story nor certification. In ITV-795, R9 was a note for a future story mixed in with the criteria, and the ticket omitted it. In ITV-789, the spec listed four front tasks and no front subticket was created.
- Operational artifacts: in ITV-754, the backfill was a script run by hand that "stayed in Slack", and the TTL policy was configured in the console. QA found neither in the repo and marked the criteria "Not met".

**Sources.** Backed (shape): North, *Introducing BDD* https://dannorth.net/blog/introducing-bdd/ ; Cucumber, *Writing better Gherkin* https://cucumber.io/docs/bdd/better-gherkin/ ; Adzic, review in InfoQ https://www.infoq.com/articles/specification-by-example-book ; INCOSE C7 and R34 (via Jama). Own: separating tasks, destinations, artifact location: the team's synthesis; no source says it this way.

**Before → after** (from ITV-823 and ITV-878).
- Before: "AC-03: saving the flow and closing the next conversation, not reading `flowbuilder-usages`." (a test method)
- After: "Given a customer with a flow with Cortex published, when a conversation closes, then customer recognition runs. Given a customer with no flow with Cortex published, when a conversation closes, then it does not run and the conversation closes normally." If reading only the stored state is a real constraint, it goes in Constraints with its reason (P1).
- Before: "AC-13: the backfill script with `--dry-run` is idempotent." After, in criteria: "Given an existing customer with active flows before launch, when the migration finishes, then their flag shows they have Cortex in production." After, in deployment tasks: "Run the backfill with `--dry-run`, then apply it. Evidence: count before and after, pasted in the ticket."
- Before (ITV-878, abridged): "If the front did not prevent it (stale list or another path), the backend rejects publishing when the agent is empty, does not exist or is not published." After: "Given a publish that reaches the backend with an empty, nonexistent or unpublished agent, by any path, then the backend rejects it and resets the flow."

**Limit.** Some operational criteria are deployment acceptance (for example, "the index is ready in production before the code"). They have a place: the task list, with its evidence, not mixed with product behavior.

## P6. Anything measurable carries a number, how it is measured and what evidence counts

**Support: Backed** for the measurable-requirement form (Google SRE; Bass, Clements and Kazman quality-attribute scenarios; INCOSE R34). **Own** for the evidence line, evidence for inherited criteria, verification path, environment dependency and model-behavior criteria. **Own with partial support** for the verification plan (Claude Code best practices recommend giving a runnable verification). **Most reliable rule in the tests.**

Rule details:
- A performance or capacity requirement has four parts: percentage of operations, threshold, load or environment, and where and over what window it is measured. Plus an **Evidence** line: what is shown to call it met.
- No baseline? Write "baseline pending: measure first" instead of inventing a number.
- "Measure how long X takes…" is a task, not a criterion.
- **Verification plan.** The spec says what is checked and what evidence counts. The implementer picks the test tool unless the repo already has a runner. If the spec asks for a tool the repo lacks, "set up the runner" is an explicit task, not a hidden condition.
- **Criteria inherited from another spec.** If another spec's work satisfies a criterion, or it is already on the main branch, say where the evidence is ("covered by Spec B's tests in `<file>`"). Otherwise the reviewer cannot find it in the PR.
- **Verification path.** If a criterion cannot be provoked from the UI (a forced error, a malformed body, a dependency failure), say how it is verified: a test, a direct endpoint call or a log query. If its only evidence is a log, say which event is searched for (by concept) and where.
- **Environment dependency.** If a criterion needs a real channel, a credential or live data (an active WhatsApp number, an external integration), say so. If the standard QA environment is not enough, mark the criterion "only verifiable with X" and say who provides X.
- **Model-behavior criteria.** If a criterion depends on what a model does ("the agent never saves…", "consolidates its answers"), one conversation does not prove it. Say which cases are used, how many times each is run and what counts as met. If what is being tested is a safeguard (a filter, a validation), say how to force the case, because the model may not produce it on its own.

**Why (team data).**
- ITV-831: the criterion "200 tasks in 450 s" was never verified: it lacked percentile, load and measuring point. Evaluator cost and latency were "unmeasured" at close.
- ITV-823 and ITV-804: QA rejected criteria for lack of evidence (backfill run, index ready in production, backup restore) because the spec never defined what evidence counted.
- The literal case that motivated this rule ("measure how long it takes to open a modal") does not appear in the six analyzed specs; it comes from team experience.
- ITV-878: the spec prescribed Karma/Jasmine tests for the front while admitting `flow-builder` has almost no specs and no `test` script. At implementation no tests were written ("the repo does not use them") and it was tested locally.
- ITV-813: QA marked "Not met" the criterion about a conversation cut off by a guardrail because no evidence was in the PR. The tests existed but came from Spec B and were already in `develop`, so they were not in the diff. The dev had to explain where they were.
- ITV-712: four certification cases (multi-select, conversation close and the two HTTP ones) stayed "unverified" because the WhatsApp numbers of the flows had expired. They were the most valuable cases of the spec, and the ticket closed that way.
- ITV-696: three certification cases were "Not applicable" because they cannot be provoked from the UI (unrecognized key, malformed body), and one stayed "not enough context to verify" (resolver failure). The blind-test agent had predicted exactly those as unobservable for QA.
- ITV-717: three cases were tested only in the simulator, not with the real tap in WhatsApp.
- Blind tests (rounds 2 and 3): signals from this rule were right in all nine units. Round 3, other authors: 5 confirmed, 3 partial, 1 failed.
- Model behavior: in ITV-707 certification came back for lack of evidence and the agent's behavior was never formally proven; a third prompt layer had to be added because the model did not comply. In ITV-888 QA could not show the URL filter acted, because the model itself refused to invent the URL. ITV-712, ITV-717 and ITV-789 had criteria of the same kind left unverified or "Not applicable".

**Sources.** Google SRE, *Service Level Objectives* https://sre.google/sre-book/service-level-objectives/ and *Implementing SLOs* https://sre.google/workbook/implementing-slos/ ; Bass, Clements and Kazman, quality-attribute scenarios https://people.ece.ubc.ca/matei/EECE417/BASS/ch04lev1sec3.html ; INCOSE R34 (via Jama). The link between Adzic ("fix the process before automating") and the verification plan is the team's inference.

**Before → after.**
- Before: "Measure how long it takes to open the case modal."
- After: "95 % of openings of the case detail modal, with 200 cases loaded in the list, take less than [X] ms from click to first content, measured in the client. Evidence: p95 of 20 openings measured in DevTools, pasted in the PR. [X]: baseline pending, measure first."

**Limit.** The full SLO machinery (long windows, error budgets, alerts) is excessive for a small team. The four-part sentence and the evidence line are enough. Applying Google-scale ideas to UI timings is the team's adaptation.

## P7. Close the cases: edges, failures and races; one glossary; consistency check

**Support: Partial.** Rust template (reference-level section asks for edge cases and interactions), Orosz (templates built from the questions reviewers repeat), INCOSE C11, R4, R36 (consistency, one term per concept), Kiro ("Analyze Requirements" step). The four concrete questions are the team's synthesis; no source covers races or failures specifically.

The four questions, per behavior:
1. What happens if a dependency fails?
2. What happens if the user or client acts while it is processing, and if the operation is retried or arrives duplicated (idempotency)? If the client keeps state between actions (a session, a "first message"), what happens on restart, close and reopen, or if the first send fails?
3. What does the user receive in the previous mode, without the new feature?
4. What happens at the extremes (empty, maximum, already existing, already deleted) and with invalid or malformed input, meaning values the store or the format does not accept?

Also: define each term once and use it the same way in criteria, risks and diagrams; check that no two statements contradict each other, starting with those touching criteria or decisions, which are the costly ones.

**Why (team data).**
- ITV-831: a customer reply during evaluation still produced a send. It appeared in code review, not in the spec, which only had criteria about "the customer replies to any attempt". The "fail-closed" rule became "retry once" when thinking about what the customer would receive in Default mode.
- ITV-804: old uses without `agentId` appeared, and 28 flows got a new publish block, through interaction with another spec.
- ITV-879: at implementation, an `agentId` containing `/` was made to count as "does not exist" without reading Firestore. The spec had not foreseen malformed input.
- ITV-814: documenting the endpoint, it turned out it can receive the same call twice (network retry or timeout) and writing twice must have no effect. The spec did not treat idempotency. And the `/field` variable rule counts only at the start or after a space so "and/or" or "24/7" do not block publishing: the spec only covered URLs.
- ITV-696: test values are sent only in the simulator session's "first message", and the spec did not define what happens on restart or reopen. The dev settled the already-open session, mid-session reconfiguration, retries and voice alone. The blind-test agent had flagged it as a risk.
- ITV-735: `content` is not stored in the checkpoint history because it accumulates every turn and would break the 1 MB document. The spec had analyzed that cap only for the evaluations store.
- Internal inconsistencies: in ITV-813, CA 10 against CA 22 (found by QA); in ITV-878, "the migration is not affected" while the prescribed mechanism did affect it; in ITV-831, a code appeared in the diagram but not in the error table (caught by the reviewer). ITV-813 had four internal inconsistencies, but only the CA 10 / CA 22 one had a visible cost. One case.

**Before → after** (from ITV-831). Before: "The customer replies to any attempt → the sequence is cancelled." After, also: "Given the customer replies while evaluating or while the message is being prepared, then the message is not sent."

**Limit.** Not every case can be foreseen. Races and rare failures sometimes show up only when reading the code. The four questions reduce the foreseeable cases; they do not exhaust them.
