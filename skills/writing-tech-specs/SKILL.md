---
name: writing-tech-specs
description: Use when the user explicitly invokes /writing-tech-specs or $writing-tech-specs to prepare, write or review a technical spec for a software change, before the spec is frozen
disable-model-invocation: true
---

# Writing technical specs

Goal: a spec that needs few changes after freeze. This file holds the rules and the checklist. The why, the team's cases and before→after examples are in `references/`: load one only to justify, explain or illustrate a rule (`content.md` P1-P4, `statements.md` P5-P7, `decisions-contracts.md` P8-P9, `evidence.md` support levels and test results).

## Terms
- **Spec**: the technical document for one software change (backend, frontend or both), implemented by someone who was not in the room (a person or an agent).
- **Freeze**: the point after which only the tech lead (LT) or the team changes the spec, through their own process. That process is out of scope here.
- **Assumption**: a fact about current code, platform, design or in-flight work that the spec relies on, with its verification date.
- **Contract**: the shape of data or of an API between components or repos.
- **Fixed / free**: fixed = the implementer must follow it, and the reason is written; free = the implementer's call.
- **Criterion vs. task**: a criterion is observable behavior (given / when / then); a task is something a person must do (run a script, deploy an index, assign codes).

## Where the spec is
Take it from wherever the user points: pasted text, a local file, a Confluence page (read it with the Atlassian tools if connected), a Jira ticket or any other source. Read the whole spec before judging it. If you cannot read it (no access, not connected), say so and ask for the text; never review from a title or from memory. Linked sibling or provider specs: read them if reachable, otherwise list them as unverified.

If the user gives a spec, run **Before freezing**. If not, run **Before writing**, then draft with the rules.

## Before writing
Find out, by asking the user or reading the code; never invent:
1. What the system does today, as observable behavior (P1, P2).
2. Which contracts the change touches and who owns each (P9).
3. Which code facts the decisions will rest on; they become Assumptions (P3).
4. What other work in progress touches the same files or contracts (P3, P9).
5. Which platform limits matter (P3).
6. Which version of the design is the final one (P3).
7. Which decisions need the LT or the PM before the freeze (P8).

Not needed: exact lines, signatures, file names. They age fastest and fix mechanism.

## Rules
Support tags: **[B]** backed by several sources; **[P]** partly backed, rest is the team's own; **[O]** the team's own, from its tickets; **[H]** hypothesis. In blind tests the most reliable were P6, P9, P8, P1.

- **P1 [B] Behavior first.** A mechanism (library, file, function, way of implementing) is fixed only with its reason beside it, written as the behavior to preserve. Without a reason it is a suggestion, marked non-binding.
- **P2 [P] Self-sufficient.** Define your own terms; mark what is fixed and what is free. Clean it: no template placeholders, no parts of other specs, no references the reader cannot open, criteria cited by stable ID, ticket linked, title matches the real scope.
- **P3 [P] Assumptions, dated.** List assumptions about code, platform and design version, each with date (and commit). Link every decision justified by a code fact to its assumption, and say if that code is changing in other work. Refer to what does not exist yet (log codes, field names, keys) by concept. Revalidate if implementation starts over ~3 weeks later. Against a draft design: name the version, check each type, verb and state against the final design, list those without design as questions with an owner. Design reconciliation is barely tested.
- **P4 [H] Size by prescriptive surface** (names, paths, signatures, lines fixed), not word count; a declared size or hours must match it, or reduce or split. Use it to size while writing; it does not predict risk.
- **P5 [B shape, O rest] Criteria and tasks.** Criterion: given / when / then with an observable result; no collections, keys, flags, commands, and no path to the situation. Tasks in a separate list; an operational artifact (script, console policy, index) says where it lives and what evidence is attached. Every criterion and task has a destination: a ticket in this delivery, or out of scope with a reason.
- **P6 [B form, O rest] Verifiability.**
  - Measurable: percentage, threshold, load or environment, where and over what window it is measured, plus an Evidence line; no baseline means "baseline pending: measure first".
  - The spec says what is checked and what evidence counts; the implementer picks the tool, and a tool the repo lacks is an explicit task.
  - A criterion met by another spec's work names where its evidence is.
  - A criterion that cannot be provoked from the UI names its verification path (test, direct call, log event by concept).
  - A criterion needing a real channel, credential or live data says so and who provides it.
  - A criterion about a model's behavior states cases, runs per case and what counts as met, and how to force the case when testing a safeguard.
- **P7 [P] Close the cases.** For each behavior ask: a dependency fails? the user acts meanwhile, or the call is retried or duplicated, or client state is restarted? what does the previous mode receive? extremes and malformed input? One term per concept; no two statements contradict, criteria and decisions first.
- **P8 [B] Decision status.** Each decision is Decided or Proposed, with who. Each open question is: before freeze (blocks), during implementation (has an owner), or out of scope. Record discarded alternatives with reasons. Nothing is "agreed" while pending validation; resolved items are updated everywhere they appeared as open.
- **P9 [B, adapted] Contracts.** One home: the producer's spec; others link it. The consumer writes "I need" as a proposal until the provider freezes, and does not build unfrozen fields. A change across components is planned as add new beside old, migrate, remove old, with deploy order, or states that both always deploy together. Sibling specs: a table of which phase needs which, plus merge order if they touch the same files.

## Before freezing
Walk the spec through the checklist. Answer each line `yes`, `no` or `n.a.`; every `no` carries the spec's own words or section, and the fix or an open decision with owner and moment (P8). Ask that someone who did not write it reads it too: if they cannot follow it without asking, P2 fails. Reviewing is read-only: propose fixes, rewrite the spec only if asked. Finish with whether it can freeze and the `no` items that block it. Do not invent defects in parts that comply.

1. **P1** Each mechanism has its reason as behavior, or is marked a suggestion?
2. **P2** Understandable by someone absent? Terms defined, fixed vs. free said, clean of leftovers?
3. **P3** Assumptions dated (code, platform, in-flight work, design version)? Future identifiers by concept? Decisions linked to assumptions? Revalidated if over ~3 weeks? Design reconciled, gaps listed?
4. **P4** Reviewable in one sitting? Declared size fits the surface? (advisory)
5. **P5** Every criterion given/when/then, observable, no path-dependence, tasks apart, destinations and artifact homes stated?
6. **P6** Measurables complete with evidence; verification plan; inherited evidence located; verification paths; environment needs; model-behavior cases?
7. **P7** Four case questions walked? Terms and numbers consistent, no contradictions?
8. **P8** Every decision with status and owner; no "before freeze" doubt open; alternatives recorded; nothing "agreed" yet pending; resolved doubts not still listed as open?
9. **P9** Contracts single-homed; consumer says "I need"; steps and deploy order; sibling-spec phases?

Closing: if the code changed tomorrow, which parts stop being true, and are they marked as assumptions or suggestions? Is anything critical that the implementer can only check by reading the code, and does the spec say so?

## Out of scope
Changes by the LT, PM or dev during implementation or code review, QA process, review tickets closed without a PR. This skill only makes each decision's reason and status explicit.
