---
name: reviewing-tech-specs
description: Use when the user explicitly invokes /reviewing-tech-specs or $reviewing-tech-specs to review a written technical spec before it is frozen
disable-model-invocation: true
---

# Reviewing technical specs

Goal: tell the tech lead whether a spec can freeze, and why not when it cannot. This file holds the rules, the checklist and how to report. The why, the team's cases and before→after examples are in `references/`: load one only to justify, explain or illustrate a rule (`content.md` P1-P4, `statements.md` P5-P7, `decisions-contracts.md` P8-P9, `evidence.md` support levels and test results).

## Terms
- **Spec**: the technical document for one software change (backend, frontend or both), implemented by someone who was not in the room (a person or an agent).
- **Freeze**: the point after which only the tech lead (LT) or the team changes the spec, through their own process. That process is out of scope here.
- **Today's fact**: an observable fact about current behavior, platform or design that the spec relies on, written without code identifiers.
- **Contract**: the shape of data or of an API between components or repos.
- **Fixed / free**: fixed = the implementer must follow it, and the reason is written; free = the implementer's call.
- **Criterion vs. task**: a criterion is observable behavior (given / when / then); a task is something a person must do (run a script, deploy an index, assign codes).

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

## Review
Input: a spec (a file or pasted text) and, when there is one, its feature folder in `~/.specflow/<YYYY-MM-DD>-<slug>/` (`~/.specflow/` is a hidden folder: list it directly). Ask for the feature folder first; ask for the spec only if none is named and the folder has no spec.md. If they name no folder, list `~/.specflow/` and ask which one, or whether there is none.
- No spec named and the folder has a `spec.md`: review that file; do not ask for the spec text. Its first two lines are `Published: <link, or "not published yet">` and `Copy date: <YYYY-MM-DD>`. In `## Verdict` write the link exactly as it appears, and the copy date, and say the published version may have changed since that date, so the review covers the copy only. Never read a `spec-superseded-*.md`.
- Read the whole spec, and the folder's `brief.md` whole. Never read a `brief-superseded-*.md` (its facts are not current).
- Never read code, search a repository or run commands: a review judges the spec's text. Re-checking facts against the code is `/verifying-spec-facts`.
- Walk the checklist below, one line per item. Every `no` quotes the spec's own words or section and gives the fix, or an open decision with owner and moment (P8). Do not invent defects in parts that comply, and do not rewrite the spec.
- Age check, only with a brief: read the table under `How it works today` (section 4). A row whose date is older than 21 days from today, or that has no date, needs re-verification; an undated row is never treated as current, and a commit alone does not give an age. Without a brief, say the age of the facts cannot be checked and point to `/discovering-tech-changes`; never call the facts current.
- P4 is advisory: report a size mismatch, but whether to split is decided with the dev, not by this review.
- Finish with whether the spec can freeze and the `no` items that block it.

Checklist, answer each line yes, no or n.a.:

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

## Report
Write the report to `~/.specflow/<feature>/review-<YYYY-MM-DD>.md` (today's date) in the folder of the brief. Never overwrite a report: if that name exists, write `review-<YYYY-MM-DD>-2.md`, then `-3`, and so on, and leave the existing files untouched. It never goes into the user's repository. With no feature folder, give the report in the answer and write no file. Headings, in this order:
- `## Verdict`: can freeze yes or no, and the blocking `no` items. When `## Facts to re-verify` is not empty, or there is no brief, never write plain yes: write "can freeze once the facts are re-verified" (or "facts unchecked, no brief"); freezing is conditional on current facts.
- `## Checklist`: one line per item, `P<n> yes`, `P<n> no` or `P<n> n.a.`; every `no` quotes the spec and gives the fix.
- `## Facts to re-verify`: each row of the brief's section 4 older than 21 days or undated: the fact in plain words, its date or "undated", and the spec decisions that depend on it. Empty when none, or when there is no brief (then say why).
- `## Next step`: `/verifying-spec-facts` when there are facts to re-verify; `/writing-tech-specs` with this report when a checklist item is `no`; both, in that order, when both apply. When neither, and there was a brief, the spec can freeze. With no brief: `/discovering-tech-changes` (to get a brief, then re-verify); never say the spec can freeze on its facts.

## Out of scope
Rewriting the spec, checking facts against the code, changes by the LT, PM or dev during implementation or code review, QA process.
