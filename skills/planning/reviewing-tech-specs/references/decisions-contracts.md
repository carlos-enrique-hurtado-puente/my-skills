# Block 3: decisions, open questions and contracts (P8 and P9)

Evidence and examples for the rules in `SKILL.md`. "Before → after" examples are illustrative: rewritten from the team's specs, not their original text.

## P8. Every decision has a status; nothing is frozen with an ownerless or timeless doubt

**Support: Backed.**

Rule details:
- Each decision in the spec is marked **Decided** or **Proposed**, with who decided it.
- Each open question is classified by when it is resolved: (1) **before freezing**, blocks the spec; (2) **during implementation**, has an owner; (3) **out of scope**.
- Discarded alternatives are recorded with their reason, so nobody reopens them without knowing why they were rejected.
- Nothing is called "agreed" while it is still pending validation.
- No risk or note stays marked as an open decision when a criterion or the "Agreed" section already resolved it. When a decision is resolved, update every place where it appeared as open.
- A frozen spec has no unresolved contradictions and no open questions of the first type.

**Why (team data).**
- ITV-878: five questions to the PM without a recorded answer at close. "Pending validation with the PM" texts reached the front subticket description and QA review.
- ITV-823: the spec itself flagged four sections needing LT validation before publishing. The deviations were ratified later, after several review rounds.
- ITV-813: the CA 10 / CA 22 contradiction was left as a risk row ("Product + LT decision"). The ticket repeated the warning and it was the only criterion that did not pass. But criterion 10b and the spec's own "Agreed" section already resolved it: the risk row and the ticket were obsolete, and QA kept the rejection until the PM accepted it. It was the only internal inconsistency with a visible cost.
- ITV-831: `luxon` and `sequenceStartedAt` were marked "proposed" and both were rejected at implementation.
- ITV-878: "Agreed" included decisions "pending PM validation", and the five questions had an owner (the PM) but no resolution moment. The proposed texts were still pending at close.
- The LT approval checkbox was unchecked in five of the six specs of Sprint 17 (not checked in ITV-823). In the 12 of sprints 15 and 16 it was unchecked in 6, checked in 5 and absent in 1; checked or not, implementation went ahead. The checkbox does not say which decisions were pending. A status per decision does.
- ITV-754 (blind test): "Agreed" included retention values "proposed" while "Pending" asked to confirm them, and a question stayed open though "Agreed" already answered it. The development ticket closed both on its own. The agent found both inconsistencies without seeing the tickets.

**Sources.** Rust RFC template (unresolved questions split into before approval, during implementation, out of scope) https://github.com/rust-lang/rfcs/blob/master/0000-template.md ; GitHub Spec Kit (`[NEEDS CLARIFICATION]` markers; the spec is not "ready" while any remain; answers recorded with a date) https://github.com/github/spec-kit/blob/main/spec-driven.md ; Nygard, *Documenting Architecture Decisions* https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions and MADR https://adr.github.io/madr/ (status and who decided) ; PEP 1 ("Open Issues" and "Rejected Ideas") https://peps.python.org/pep-0001/ ; Ubl (alternatives considered are one of the most important sections).

**Before → after** (from ITV-878 and ITV-831).
- Before, in "Refinement": "Questions: Do we accept the current pattern (Publish disabled)? (PM)." No status or deadline. And "`luxon`: ⚠️ proposal".
- After:

| Decision or doubt | Status | Who | When it is resolved |
|---|---|---|---|
| Publish stays disabled while there are errors | Proposed | PM | Before freezing |
| Use `Intl` instead of `luxon` for schedules | Decided | LT | n/a |
| Exact text of the save warning | Doubt | Design | During implementation |
| Discarded alternative: reload the list on every open | Discarded | LT | Reason: read cost |

**Limit.** Do not turn every line into a decision. Mark only those someone could reopen. The aim is not to fill the table but that no important doubt reaches the freeze without an owner.

## P9. Contracts have one home: the consumer asks, the provider decides, and contract changes are planned in separately deployable steps

**Support: Backed**, with an adaptation: the sources assume HTTP services; applying them to Firestore documents and callable functions is the team's adaptation. "Do not build what the provider has not frozen" and the phase table for sibling specs are the team's own. The phase table has weak backing: in ITV-735/736 the phase mismatch the agent predicted did not cause a failure. **Among the most reliable in the tests** (round 3: 1 confirmed, 4 partial, 0 failed).

Rule details:
- A **contract** (the shape of data or an API between components or repos) is written in **one place**: the producer's spec. Other specs link it and do not copy it.
- While the provider is not implemented, the consumer's spec writes "I need", as a proposal, not "already decided".
- If a contract change touches more than one component, the spec gives the steps: add the new next to the old, migrate, remove the old. It also says what deploys first, so each step can be deployed without breaking the other.
- If you split into several specs (P4), each contract between them follows this rule.
- **While the provider has not frozen a field, the consumer does not build it**, or builds it only when the provider confirms. A field that exists only in the consumer's spec is work that can be lost.
- **Sibling specs.** If two specs advance in phases on the same change, a table says which phase of one needs which phase of the other. If they touch the same files, the spec declares the merge order and avoids citing lines of a file the other modifies.

**Why (team data).**
- ITV-835 and ITV-831: the front spec copied the backend contract (day keys `"0"` to `"6"`, the `{from, to}` shape and the simulator response) and declared it "already decided, not an open point". The backend implemented another (`mon..sun` with `{start, end}`). Both specs were wrong against the code. The front spec said the contract was "closed except four confirmations", while the backend spec had five open questions.
- ITV-835: the front tested against an undeployed backend gave no error and simply did not schedule recoveries. The spec said the backend could ship earlier but did not cover the reverse case.
- ITV-813: the deployment order the spec described as a risk (acf, then abf, then agent-builder) became a blocker for testing. QA waited days for a prior deployment. And ITV-804 depended on a front PR of ITV-813.
- ITV-736 and ITV-735 (blind test): the front spec copied the backend model and called it "final contract" with questions still open in the backend. The backend dropped two content types and the `truncated` flag. The front implemented 5 of 7 renderers and left the `truncated` flag implemented and tested but unreachable. Of the front's changes, the guide would have prevented the three that came from the copy.
- ITV-809 and ITV-848: two sibling specs touched the same methods with no merge order, and cited lines moved 11 and 12 lines in 10 days.
- First blind test of the sibling-spec part (round 3): 1 confirmed, 4 partial, 0 failed. In the three evaluations stories (ITV-856, ITV-861, ITV-866), one wrote into another's download file without a contract. The option chosen by the client did not reach the download, and the backend PR of one story was merged into another's.

**Sources.** OpenAPI best practices (one source of truth per contract) https://learn.openapis.org/best-practices.html ; Robinson, *Consumer-Driven Contracts* https://martinfowler.com/articles/consumerDrivenContracts.html ; Sato, *Parallel Change* https://martinfowler.com/bliki/ParallelChange.html ; Fowler, *Contract Test* https://martinfowler.com/bliki/ContractTest.html ; Fowler, *Tolerant Reader* https://martinfowler.com/bliki/TolerantReader.html (our inference: it must come with failing loudly when a required field is missing, or it hides exactly the silent failure of ITV-835).

**Before → after** (from ITV-835).
- Before, in the front spec: "Contract (already decided): `days` with keys `"1"`–`"5"` and `{from, to}`." Copied from the backend spec.
- After, in the front spec: "I need from the backend (proposal; confirmed by the backend spec): a schedule per day of the week, with start and end time." With a link to the contract in the backend spec. The exact definition (day names, shape, example) lives only there.
- And for the stepped change:
  1. Backend: accepts both day forms and writes the new one.
  2. Front: uses the new one.
  3. Backend: removes the old one.
  - Deployment order: backend first.

**Limit.**
- If backend and front always deploy together, the steps can be one. Say so explicitly.
- Tools like Pact are too heavy to start with (a contract server and integration in each repo; no Firestore support). The ideas do help.
- This rule does not resolve log-code range or file collisions between specs in progress. No source covers it. If it happens often, a registry of ranges and owners would be a separate proposal.
