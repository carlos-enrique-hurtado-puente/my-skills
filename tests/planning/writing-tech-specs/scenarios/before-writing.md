# Scenario: before-writing

## Setup
No fixtures. There is no repository; the runner answers from the request alone.

## Invocation
I have to write the technical spec for this change: agents should be able to mute notifications for a customer conversation for 24 hours. It touches the Node backend, the Angular web app and an existing notifications service. The tech lead freezes specs on Thursday. Before I start writing, what exactly should I find out? Give me the list I should work through.

## Pressure
The user is new to the codebase and wants to be thorough: "I'll copy the exact lines, function signatures and file names so there is no ambiguity."

## Expected
- [ ] Asks the user for a discovery brief (what is asked, how the system works today, what exists to reuse, what else is in progress, options) as the input the spec is written from.
- [ ] If the user has no brief, offers to run the `/discovering-tech-changes` skill to produce one.
- [ ] Does not ask the user for a spec, and says that if the user declines the discovery it stops and writes nothing (no spec, draft or outline), because without the brief the spec would be guesses.
- [ ] Says the code facts the decisions will rest on go into an Assumptions section with a verification date.
- [ ] Tells the user they do NOT need to collect exact lines, signatures or file names (and why: they go stale or prescribe mechanism).

## Purpose (scorer only)
Checks that "Before writing" now asks for the discovery brief and offers the discovery skill, and still resists the user's pressure to over-collect.

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

### red-2 — 2026-10-26 (skill before the change, new Expected)
- Verdict: FAIL (2 of 5 bullets)
- Asks the user for a discovery brief as the input the spec is written from — FAIL (no brief is requested; it only lists items to find out: "Find each item out by asking people or reading the code")
- If the user has no brief, offers to run the `/discovering-tech-changes` skill — FAIL (the skill is never mentioned)
- If the user declines the discovery, gaps are listed as open questions with an owner and a moment, no invented facts — FAIL (no decline path; open questions with owner appear only for undesigned states and LT/PM decisions, not tied to declining discovery)
- Code facts go into an Assumptions section with a verification date — PASS ("These become dated assumptions (with the date and the commit)")
- Tells the user they do NOT need to collect exact lines, signatures or file names, and why — PASS ("I would not do that... Exact lines, signatures and file names go out of date fastest, and they fix the way something is built")

### green-2 — 2026-10-26 (skill after the change, new Expected)
- Verdict: FAIL (4 of 5 bullets)
- Asks the user for a discovery brief as the input the spec is written from — FAIL (it assumes none exists: "you don't have a discovery brief yet"; it never asks the user to provide one)
- If the user has no brief, offers to run `/discovering-tech-changes` — PASS ("I recommend running `/discovering-tech-changes` first"; closing: "do you want me to run `/discovering-tech-changes` for this change")
- If the user declines the discovery, gaps become open questions with owner and moment, no invented facts — PASS ("If you prefer not to... Whatever you cannot find out becomes an open question with an owner and a moment... Never fill a gap with an invented fact.")
- Code facts go into an Assumptions section with a verification date — PASS ("Facts about the current code, each with today's date and commit... Mark those as assumptions"; "write it as an assumption with its date and commit")
- Tells the user they do NOT need exact lines, signatures or file names, and why — PASS ("you do not need exact lines, function signatures or file names. They are the first things to go stale, and writing them makes the spec say HOW")

### green-3 — 2026-10-26 (skill after the fix, new Expected)
- Verdict: PASS (5 of 5 bullets)
- Asks the user for a discovery brief as the input the spec is written from — PASS ("do you already have a discovery brief for this change... If you have one, paste it or point me to it and I will map it into the spec")
- If the user has no brief, offers to run the `/discovering-tech-changes` skill — PASS ("If you don't, I can offer `/discovering-tech-changes` to produce one"; closing: "say if you want me to run `/discovering-tech-changes` first")
- If the user declines the discovery, gaps are open questions with owner and moment, no invented facts — PASS ("If you'd rather not, I will list the gaps below as open questions with an owner and a moment, and I will not fill them with invented facts")
- Code facts go into an Assumptions section with a verification date — PASS ("dated facts, each with the date and commit you checked, as Assumptions")
- Tells the user they do NOT need exact lines, signatures or file names, and why — PASS ("I'd skip that. Those are the facts that go stale fastest, and writing them down fixes a mechanism the implementer then has to follow")

### red-3 — 2026-10-30 (skill as of `main`, `cb3607a`; Expected rewritten for "if declined, stop"; blind scorer)
- Verdict: FAIL (3 of 5 bullets)
- Asks for a discovery brief — PASS ("do you already have a discovery brief for this change?")
- Offers `/discovering-tech-changes` — PASS
- Does not ask for a spec; stops if the discovery is declined — FAIL (no stop: "Once you've worked through this, or sent me the brief, I'll draft the spec")
- Code facts into an Assumptions section with a date — FAIL ("with the date you checked it and the commit", but no Assumptions section)
- Not collecting exact lines, signatures or file names — PASS

### green-4 — 2026-10-30 (skill with "if declined, stop"; same blind scorer)
- Verdict: PASS (5 of 5 bullets)
- Brief — PASS ("I write the spec from that brief, so it's the first thing I need")
- Discovery offer — PASS
- Stops if declined — PASS ("Without knowing the current code, the change and what it touches, the spec would be guesses… If you'd rather skip it, I won't write a draft or an outline")
- Dated assumptions — PASS, borderline ("code facts written as dated assumptions (date plus commit)")
- Lines, signatures, file names — PASS

### re-run - 2026-10-31 (skill asks for the feature folder in `~/.tech-specs/`)
- green: PASS on the four bullets that still apply (brief asked for, `/discovering-tech-changes` offered, stops if declined, no exact lines needed). Blind scorer. The Assumptions bullet is retired since 2026-10-31 (P3 is today's behavior). The reply asked for the brief "in a folder like ~/.tech-specs/<date>-<slug>/brief.md".
