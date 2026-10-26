---
name: discovering-tech-changes
description: Use when the user explicitly invokes /discovering-tech-changes or $discovering-tech-changes to understand a requirement (FRD, user stories, task or design) and the code it touches, and prepare a discovery brief before writing the technical spec
disable-model-invocation: true
---

# Discovering tech changes

Goal: before the spec, the developer knows, in plain words, what is asked, how the system behaves today, what to reuse, what else is moving around it, and the options. You explore and propose; the developer validates each step and decides. Sources and support levels: `evidence.md`.

## Start
1. **Input.** Take it from wherever the user points (text, file, Confluence, Jira through the Atlassian tools, a design). Read all of it. If you cannot read it, say so and ask for the text; never work from a title or from memory.
2. **Depth.** Ask before step 1: **full** (steps 1 to 7) or **reduced** (steps 3 and 4 plus a short brief) for a change the developer can describe in one sentence. Say which looks fitting and why, then wait. The developer chooses, even when the change looks obvious.
3. **Read-only.** Never write to the user's repo, Jira or Confluence. For git use `git --no-optional-locks`.

## Steps
Each step ends at its **checkpoint**: stop, show the result in plain words, ask, and wait for the developer's answer. Even when told to hurry or to "just give the brief": keep checkpoints short, never skip them. Revisit steps 3 to 6 when something learned changes an earlier answer. Signals, questions and sources per step: `steps.md`.

1. **Intake.** Restate what is asked and the outcome. Mark omissions (a trigger without a response, an operation without its reverse), ambiguity and contradictions. Start the corrections list (input says / is). Checkpoint: is this what is asked?
2. **Framing.** Goals, non-goals (reasonable goals deliberately excluded), how success will be known. Checkpoint: developer confirms goals and non-goals.
3. **How it works today.** Observable behavior first, then the code path as support. Trace the whole flow: every caller of the path, other readers and writers of the data, side effects, contracts, silent drops, tests, git history. Checkpoint: developer corrects the explanation. This builds the mental model; do not rush it.
4. **Reuse and conventions.** For each needed behavior, search for code that already does it or nearly does, by behavior, not only by the input's words; it may exist under another name. Record conventions (error-code naming, UI patterns, i18n) and where existing patterns fall short. Per item: reuse, adapt or create, with the reason; flag where reuse would bend shared code. Checkpoint: developer confirms the inventory.
5. **Surroundings.** Other specs, branches and work in progress touching the same files, flows or contracts; contracts checked against the provider's code or frozen spec; deploy order; limits; final design. Checkpoint: developer confirms the list and the owner of each dependency.
6. **Options.** Two or three, including a smaller one and "keep as is" when meaningful: what each reuses, creates, risks, blocks. Recommend one with the reason. Checkpoint: developer chooses the direction.
7. **Brief.** Consolidate (below). Checkpoint: developer validates the whole brief.

## The brief
Sections, filled as in `brief-template.md`: 0 header (input, date, commit, depth, what was validated); 1 in plain words (problem, outcome, today, proposal; one page, no identifiers); 2 corrections to the input; 3 goals and non-goals; 4 how it works today (each fact with how it is known, date, commit, re-verify command); 5 reuse inventory and conventions (with what was searched); 6 surroundings (state and owner of each item); 7 options and recommendation; 8 open questions (item / owner / moment).

Write it in the developer's language. Deliver in chat by default and offer a file; Confluence only on request.

## Rules
- **Plain words first.** Explain in everyday words, followable without opening the code. State every claim in every section in plain words; identifiers (paths, functions, constants, error codes) go only in evidence columns or rows. A list of names is not an explanation.
- **Label every fact**: observed in code (where, date, commit), inferred (from what), or told by the developer.
- **Never invent.** A gap in the input or the code becomes an open question with an owner and a moment (before freeze, during implementation, out of scope). Do not pick an answer for it; you may add a proposal, marked as a proposal.
- **Propose and recommend, never decide.** The developer decides; the decision is recorded in the spec.
- **Say what you searched.** For reuse, list the terms and paths searched and what could not be searched. Never claim "nothing to reuse" without it. When the needed behavior already exists under another name, say so plainly.
- **Follow the repo's conventions** over inventing names, codes or patterns; say which.
- **Nearby work is a dependency until the developer says otherwise.** Anything touching the same file, flow or contract is listed with its state and its owner (or "owner unknown, to ask"); never dismiss it as unrelated on your own.
- **Unreachable sources.** When Jira, Confluence or other repos cannot be reached, say what could not be searched and ask the developer; never report "nothing found".
- **Ask only what the code cannot answer.**
- **Protect context.** Delegate wide searches to read-only subagents; report their conclusions.
- **Not a plan, not a spec.** No code steps or acceptance criteria. Hand the validated brief to `writing-tech-specs`.
