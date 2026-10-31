---
name: writing-tech-specs
description: Use when the user explicitly invokes /writing-tech-specs or $writing-tech-specs to prepare and write a technical spec for a software change, before the spec is frozen
disable-model-invocation: true
---

# Writing technical specs

Goal: a spec that needs few changes after freeze. This file holds the rules and the checklist. The why, the team's cases and before→after examples are in `references/`: load one only to justify, explain or illustrate a rule (`content.md` P1-P4, `statements.md` P5-P7, `decisions-contracts.md` P8-P9, `evidence.md` support levels and test results).

## Terms
- **Spec**: the technical document for one software change (backend, frontend or both), implemented by someone who was not in the room (a person or an agent).
- **Freeze**: the point after which only the tech lead (LT) or the team changes the spec, through their own process. That process is out of scope here.
- **Today's fact**: an observable fact about current behavior, platform or design that the spec relies on, written without code identifiers.
- **Contract**: the shape of data or of an API between components or repos.
- **Fixed / free**: fixed = the implementer must follow it, and the reason is written; free = the implementer's call.
- **Criterion vs. task**: a criterion is observable behavior (given / when / then); a task is something a person must do (run a script, deploy an index, assign codes).

## How it starts
The skill writes specs, and a spec starts from a discovery brief (made with `/discovering-tech-changes`): what the change is about, how the code works today and what has to change. Without it there is nothing to write from. Never ask the user for a spec. A requirement (FRD, user story, ticket or just an idea) is the discovery's input, not this skill's; when the user also gives one, use it only as context, such as the ticket link (P2), never as a source of facts the brief lacks. Briefs live in `~/.tech-specs/<YYYY-MM-DD>-<slug>/brief.md`, one folder per feature (`~/.tech-specs/` is a hidden folder: list it directly, a plain listing of the home directory does not show it). Ask the user for the feature folder; if they name none, list the folders in `~/.tech-specs/` and ask which one. Read its `brief.md` whole and never any `brief-superseded-*.md` (an older brief: its facts are not current). If there is no folder or `brief.md`, or you cannot read it, say so, never work from a title or from memory. Never read code, search a repository or run commands: the brief is the only source of facts. Give the spec in the answer, or write it under `~/.tech-specs/<feature>/`; never write inside the user's repository, even when asked: say so and give the path outside it where they can save it. Reviewing a spec someone else wrote is not this skill's job.

When the user gives a review report (`~/.tech-specs/<folder>/review-<date>.md`), rewrite the spec from the same brief and fix each `no` in its Checklist; the report is context, never a source of facts. Do not start a new discovery for it. A behavior the brief does not settle (for example a retry or an edge case) is written as a Proposed decision or an open question with owner and moment, never as a fact. This covers small details too: how an error is named, what happens at a boundary time, whether a real channel is needed.

Run **Before writing** (brief), draft with the rules, then run **Before freezing** on your own draft before handing it over: fix every `no` you can with what you know, and turn the rest into open questions with owner and moment; never fill a gap with an invented fact. The draft's last section is `Self-check`: one line per checklist item, `P<n> yes <section or IDs>` or `P<n> no -> <fix or question ID>`, then the questions that block the freeze. A `yes` without a citation counts as `no`.

## Before writing
First move: ask the user for the feature folder with the discovery brief in `~/.tech-specs/`, or whether there is one; never assume there is none. If there is a brief, read it and map its sections:
- plain words -> what we are building, and self-sufficiency (P2)
- goals and non-goals -> what we are building and an Out of scope section (P2)
- corrections to the input -> a "spec says / is" table (P2)
- how it works today -> Today's behavior and dependencies (P3), as behavior, leaving identifiers, dates and commits in the brief
- reuse reasons -> beside each fixed mechanism (P1)
- surroundings -> contracts and work in flight (P9, P3); platform limits and design version -> Today's behavior and dependencies (P3)
- options -> Proposed decision rows (P8)
- open questions -> the decisions table (P8)

If the brief is reduced or lacks any section above, name each missing section to the user (goals and non-goals, surroundings, options, platform limits, design version) and list it as an open question with owner and moment (P8).

The brief is an input the spec never cites. Write each fact from it as the spec's own statement, as behavior (no file paths, functions, constants, keys, dates or commits: those stay in the brief), and each missing section as a question about the topic itself ("platform limits for the 24 h window: unknown"). Anything about the brief goes to the user outside the spec. This holds for every line of the draft, edge cases and Self-check included: write "behavior if the digest runs as the silence ends: undecided (Q5)", never "the brief does not settle it" or "missing from the brief".

If none, offer `/discovering-tech-changes`, whatever the user has in hand (FRD, user story, ticket or an idea). If declined, stop: write no spec, no draft and no outline. Say that without knowing the code, the change and what it touches the spec would be guesses, and that the spec can be written once there is a brief.

Not needed: exact lines, signatures, file names (they age fastest and fix mechanism).

## Rules
Support tags: **[B]** backed by several sources; **[P]** partly backed, rest is the team's own; **[O]** the team's own, from its tickets; **[H]** hypothesis. In blind tests the most reliable were P6, P9, P8, P1.

- **P1 [B] Behavior first.** A mechanism (library, file, function, way of implementing) is fixed only with its reason beside it, written as the behavior to preserve. Without a reason it is a suggestion, marked non-binding.
- **P2 [P] Self-sufficient.** Define your own terms; mark what is fixed and what is free. Clean it: no template placeholders, no parts of other specs, no references the reader cannot open, criteria cited by stable ID, ticket linked, title matches the real scope.
- **P3 [P] Today's behavior and dependencies.** List today's facts (behavior, platform limits, design version) without identifiers or dates. Link every decision justified by a fact to it, and say if it is changing in other work. Refer to what does not exist yet (log codes, field names, keys) by concept. Against a draft design: name the version, check each type, verb and state against the final design, list those without design as questions with an owner. Design reconciliation is barely tested.
- **P4 [H] Size by prescriptive surface** (names, paths, signatures, lines fixed), not word count; a declared size or hours must match it, or reduce or split. Use it to size while writing; it does not predict risk. There is no threshold: whether to split is decided with the dev (see `content.md`, P4).
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
Walk your own draft through the checklist. Answer each line `yes`, `no` or `n.a.`; every `no` carries the spec's own words or section, and the fix or an open decision with owner and moment (P8). Ask that someone who did not write it reads it too: if they cannot follow it without asking, P2 fails. Finish with whether the draft can freeze and the `no` items that block it. Do not invent defects in parts that comply.

1. **P1** Each mechanism has its reason as behavior, or is marked a suggestion?
2. **P2** Understandable by someone absent? Terms defined, fixed vs. free said, clean of leftovers?
3. **P3** Today's facts (behavior, platform, design version) written without identifiers or dates? Future identifiers by concept? Decisions linked to the facts they depend on, and in-flight changes to them said? Design reconciled, gaps listed?
4. **P4** Reviewable in one sitting? Declared size fits the surface? (advisory)
5. **P5** Every criterion given/when/then, observable, no path-dependence, tasks apart, destinations and artifact homes stated?
6. **P6** Measurables complete with evidence; verification plan; inherited evidence located; verification paths; environment needs; model-behavior cases?
7. **P7** Four case questions walked? Terms and numbers consistent, no contradictions?
8. **P8** Every decision with status and owner; no "before freeze" doubt open; alternatives recorded; nothing "agreed" yet pending; resolved doubts not still listed as open?
9. **P9** Contracts single-homed; consumer says "I need"; steps and deploy order; sibling-spec phases?

Closing: if the code changed tomorrow, which parts stop being true, and are they marked as today's facts or suggestions? Is anything critical that the implementer can only check by reading the code, and does the spec say so?

## Out of scope
Changes by the LT, PM or dev during implementation or code review, QA process, review tickets closed without a PR. This skill only makes each decision's reason and status explicit.
