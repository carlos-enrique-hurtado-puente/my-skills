# Scenario: before-writing

## Setup
No fixtures. There is no repository; the runner answers from the request alone.

## Invocation
I have to write the technical spec for this change: agents should be able to mute notifications for a customer conversation for 24 hours. It touches the Node backend, the Angular web app and an existing notifications service. The tech lead freezes specs on Thursday. Before I start writing, what exactly should I find out? Give me the list I should work through.

## Pressure
The user is new to the codebase and wants to be thorough: "I'll copy the exact lines, function signatures and file names so there is no ambiguity."

## Expected
- [ ] Says to find out what the system does today as observable behavior (what agents/customers experience now), not as code.
- [ ] Says to identify which contracts (API or data shapes between the backend, web app and notifications service) the change touches and who owns each.
- [ ] Says the code facts the decisions will rest on go into an Assumptions section (with verification date).
- [ ] Says to find other in-progress work that touches the same files or contracts.
- [ ] Says to check platform limits that matter (limits or behavior of the services/platform in use).
- [ ] Says to confirm which version of the design is the final one.
- [ ] Says to list decisions needing the tech lead or the PM before the freeze.
- [ ] Tells the user they do NOT need to collect exact lines, signatures or file names (and why: they go stale or prescribe mechanism).

## Purpose (scorer only)
Checks the "Before writing" list and its explicit "not needed" item against the user's own pressure to over-collect.

## Results

### baseline — 2026-10-24
- Verdict: FAIL (4 of 8 bullets).
- Observable behavior today — PASS (section 1 asks what "mute" means, channels, scope).
- Contracts and owners — PASS (section 2: who owns the notifications service, request/event shape).
- Assumptions section with dates — FAIL (never proposes recording code facts as assumptions).
- In-flight work on the same files or contracts — FAIL.
- Platform limits — FAIL.
- Final design version — PARTIAL (asks "is there a design or mockup", not which version is final); counted FAIL.
- Decisions for the tech lead or PM before the freeze — PASS (section 8: open questions with owner and answer-by date).
- Do not collect exact lines, signatures, file names — FAIL: step 4 of "How to gather" says to collect "the exact lines, signatures and file names for the places you'll change".
- Notable phrase: "Quoting lines, signatures and file names is fine".
- Classification: **discriminating**.

### green-1 — 2026-10-24
- Verdict: PASS (8 of 8 bullets).
- Observable behavior, contracts and owners, dated Assumptions, work in flight, platform limits, final design version (asks for version/link/date and checks each state against it), LT/PM decisions with owner and blocking flag — all PASS.
- Not collecting exact lines/signatures/file names — PASS: "Skip exact lines, function signatures and file names. They go stale fastest, and they lock in a mechanism without saying why."
- The runner also resisted the user's stated plan to copy exact lines.
