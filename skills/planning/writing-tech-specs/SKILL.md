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

If the user gives a spec, run **Before freezing**. If not, run **Before writing** (brief), draft with the rules, then run **Before freezing** on your own draft before handing it over: fix every `no` you can with what you know, and turn the rest into open questions with owner and moment; never fill a gap with an invented fact. The draft's last section is `Self-check`: one line per checklist item, `P<n> yes <section or IDs>` or `P<n> no -> <fix or question ID>`, then the questions that block the freeze. A `yes` without a citation counts as `no`.

## Before writing
First move: ask the user for the discovery brief, or whether there is one; never assume there is none. If there is one, read it and map its sections:
- plain words -> what we are building, and self-sufficiency (P2)
- goals and non-goals -> what we are building and an Out of scope section (P2)
- corrections to the input -> a "spec says / is" table (P2)
- dated code facts -> Assumptions (P3)
- reuse reasons -> beside each fixed mechanism (P1)
- surroundings -> contracts and work in flight (P9, P3); platform limits and design version -> Assumptions (P3)
- options -> Proposed decision rows (P8)
- open questions -> the decisions table (P8)

If the brief is reduced or lacks any section above, name each missing section to the user (goals and non-goals, surroundings, options, platform limits, design version) and list it as an open question with owner and moment (P8).

The brief is an input the spec never cites. Write each fact from it as the spec's own statement (code facts with their verification date and commit, without the brief's re-verify commands), and each missing section as a question about the topic itself ("platform limits for the 24 h window: unknown"). Anything about the brief goes to the user outside the spec.

If none, offer `/discovering-tech-changes`. If declined, list the brief sections the user lacks (today's behavior, contracts and owners, work in flight, platform limits, design version) as open questions with owner and moment (P8); never fill them with invented facts.

Not needed: exact lines, signatures, file names (they age fastest and fix mechanism).

## Rules
Support tags: **[B]** backed by several sources; **[P]** partly backed, rest is the team's own; **[O]** the team's own, from its tickets; **[H]** hypothesis. In blind tests the most reliable were P6, P9, P8, P1.

- **P1 [B] Behavior first.** A mechanism (library, file, function, way of implementing) is fixed only with its reason beside it, written as the behavior to preserve. Without a reason it is a suggestion, marked non-binding.
- **P2 [P] Self-sufficient.** Define your own terms; mark what is fixed and what is free. Clean it: no template placeholders, no parts of other specs, no references the reader cannot open, criteria cited by stable ID, ticket linked, title matches the real scope.
- **P3 [P] Assumptions, dated.** List assumptions about code, platform and design version, each with date (and commit). Link every decision justified by a code fact to its assumption, and say if that code is changing in other work. Refer to what does not exist yet (log codes, field names, keys) by concept. Revalidate if implementation starts over ~3 weeks later. Against a draft design: name the version, check each type, verb and state against the final design, list those without design as questions with an owner. Design reconciliation is barely tested.
- **P4 [H] Size by prescriptive surface** (names, paths, signatures, lines fixed), not word count; a declared size or hours must match it, or reduce or split. Use it to size while writing; it does not predict risk. There is no threshold: whether to split is decided with the dev (see Deciding whether to split).
- **P5 [B shape, O rest] Criteria and tasks.** Criterion: given / when / then with an observable result; no collections, keys, flags, commands, and no path to the situation. Tasks in a separate list; an operational artifact (script, console policy, index) says where it lives and what evidence is attached. Every criterion and task has a destination: a ticket in this delivery, or out of scope with a reason.
- **P6 [B form, O rest] Verifiability.**
  - Measurable: percentage, threshold, load or environment, where and over what window it is measured, plus an Evidence line; no baseline means "baseline pending: measure first".
  - The spec says what is checked and what evidence counts; the implementer picks the tool, and a tool the repo lacks is an explicit task.
  - A criterion met by another spec's work names where its evidence is.
  - A criterion that cannot be provoked from the UI names its verification path (test, direct call, log event by concept).
  - A criterion needing a real channel, credential or live data says so and who provides it.
  - A criterion about a model's behavior states cases, runs per case and what counts as met, and how to force the case when testing a safeguard.
- **P7 [P] Close the cases.** For each behavior ask: a dependency fails? the user acts meanwhile, or the call is retried or duplicated, or client state is restarted? what does the previous mode receive? extremes and malformed input? One term per concept; no two statements contradict, criteria and decisions first.
- **P8 [B] Decision status.** Each decision is Decided or Proposed, with who. Each open question is: before freeze (blocks), during implementation (has an owner), or out of scope. Record discarded alternatives with reasons. Nothing is "agreed" while pending validation; resolved items are updated everywhere they appeared as open. Keep decisions and questions in one table: item | status | who | when it is resolved (before freeze, during implementation, out of scope; `n.a.` only for Decided rows).
- **P9 [B, adapted] Contracts.** One home: the producer's spec; others link it. The consumer writes "I need" as a proposal until the provider freezes, and does not build unfrozen fields. A change across components is planned as add new beside old, migrate, remove old, with deploy order, or states that both always deploy together. Sibling specs: a table of which phase needs which, plus merge order if they touch the same files.

## Deciding whether to split
Starting points, not rules; evidence in `content.md` (P4).
- For splitting: not reviewable in one sitting; more than one result that can be delivered and verified alone; parts at different maturity (one blocked by before-freeze questions); a big unknown (make it a spike); large or scattered surface, or an estimate that does not fit.
- Against: the contract a cut creates costs about as much as it saves (P9); a part cannot be deployed or verified without the other.
- Prefer a cut by behavior; cut by repository only for different owners or deployments, then P9 applies.

Answer in this order:
1. Your recommendation, in one line.
2. Options, including "do not split": for each, what it creates (contract, merge order, phases) and what stays blocked.
3. What you need from the dev that you cannot see: who decides each part, what deploys together, deadlines.
4. The decision as a P8 row: Proposed until the dev or LT confirms, who decides, discarded alternatives with reason.

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
