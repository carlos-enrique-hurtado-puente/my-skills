# Steps: signals, checkpoint questions, sources

Load this file to run a step well or to justify it. Each step lists what the agent does, the signals to look for, the checkpoint question, and its sources (short names; full list, read status and team cases in `evidence.md`). Heuristics, not closed rules: the agent and the developer resolve each one together.

Every step reports in plain words first. Identifiers (files, functions, constants) go underneath as evidence, never as the explanation. Every step ends at its checkpoint: stop, show the result, wait for the developer. Steps 3 to 6 interleave; go back when something learned changes an earlier answer, and say which answer changed.

## Depth

Asked at the start, before step 1. Two levels:
- **Full**: steps 1 to 7.
- **Reduced**: steps 3 and 4 plus a short brief, for a change the developer can describe in one sentence.

Offer both, say which looks fitting and why, and wait. The developer picks; the skill does not decide, even when the change looks obvious. Reduced depth still stops at the checkpoints of steps 3 and 4.

Sources: Claude Code best practices (skip the plan when the diff fits in a sentence); Google design docs (skip the doc when the path is obvious).

## Step 1. Intake and contrast of the input

**Agent.** Read the whole input: pasted text, a file, a Confluence page or a Jira ticket (through the Atlassian tools when connected). If it cannot be read, say so and ask for the text; never work from a title or from memory. Restate in plain words what is asked and the expected outcome. Mark:
- omissions: a trigger without a response, an operation without its reverse (archive without restore, create without delete), a state without how it ends;
- ambiguity: vague quantifiers ("fast", "some", "usually");
- contradictions: two criteria that cannot both hold; a design showing values the system rejects.

Start the **corrections to the input** list (input says / is / evidence). Steps 3 to 5 finish it: the input can only be proven wrong after reading the code.

**Signals.** Requirement without trigger or reverse operation; vague quantifiers; two criteria that cannot both hold; a design showing values the system rejects.

**Checkpoint.** "Is this what is being asked? Here is what I read, the omissions and the doubts."

**Sources.** Wiegers via Jama (omissions and ambiguity; summary). Ferrari and Gnesi (ambiguity often points to unspoken knowledge; summary). Claude Code best practices (let the agent interview the user).

## Step 2. Framing

**Agent.** Goals; **non-goals** (reasonable goals deliberately excluded, not negations of the goals); how success will be known; short context that links instead of repeating.

**Checkpoint.** "Are these the goals and non-goals? Is anything out of scope that I put in, or the reverse?"

**Sources.** Google design docs (context and scope, goals and non-goals). Shape Up (boundaries; rough, solved, bounded).

## Step 3. How it works today

**Agent.** Explain the flow as **observable behavior** first (what the user or the system sees), then the path in code as support. Trace the complete flow, not only the local piece. Also look for:
- who else calls this path (jobs, migrations, batch senders, webhooks, other screens);
- who else reads or writes the same data, including other repos;
- side effects of writing it (triggers, timeouts, listeners);
- wire contracts to other repos;
- silent behavior: things dropped or skipped without an error;
- test coverage of the zone;
- the git history of the zone when behavior is surprising.

Label each fact observed (where, date, commit), inferred, or told by the developer.

At the checkpoint, the code path goes in an evidence table or line under the explanation, not in the explanation itself. A code's own name for a feature is an identifier too: in the prose use the word the product shows its users, and put the code's name in the evidence.

**Signals.** A code path with more than one caller; a field written by more than one repo; a flag whose commit message does not explain it; a zone with no tests.

**Checkpoint.** "Is this how you understand it works? What is wrong or missing?" This step builds the developer's mental model; do not rush it, even under time pressure.

**Sources.** Anthropic study of 52 developers (conceptual questions and explanations kept comprehension, full delegation did not; association, small subgroups). Naur, programs as theories held by people (summary). Littman et al., via a conceptual-model paper (tracing the whole flow did better on a modification task). Claude Code best practices (ask codebase questions; use git history). Feathers, characterize actual behavior (summary).

## Step 4. Reuse inventory and conventions

**Agent.** For each piece of behavior the change needs, search for existing code that already does it or nearly does: utilities, datasources, UI components and editors. Search by behavior, not only by the input's words: the same thing often exists under another name. Record repo **conventions** (error-code naming, UI patterns, i18n, logging) and the **limits of existing patterns**. Per item decide: reuse as is, adapt, or create, with the reason. State what was searched (terms, paths) and what could not be searched, so the developer can judge the coverage. Check the opposite risk: where reuse would force flags or parameters into shared code, say so and consider creating instead.

**Signals.** A step that creates a module whose name resembles an existing one; a new dependency where the repo already has a precedent; a new code or key that does not follow the repo's naming; a requirement the existing pattern cannot satisfy.

**Checkpoint.** "Is this inventory right? Mark where you disagree with reuse, adapt or create."

**Sources.** Claude Code best practices (point to existing patterns; ask whether existing utilities can be reused). GitClear (more duplication, less refactoring in AI-assisted codebases; press coverage, correlational, not about coding agents). Metz, The wrong abstraction (duplication is cheaper than a wrong abstraction once proven wrong; it does not say "do not reuse").

## Step 5. Surroundings of the change

**Agent.** Find what else is moving around the change:
- other specs and work in progress touching the same files, flows or contracts (the epic, the sprint, Confluence specs in the same space, open branches, in-flight spec folders in the repo);
- contracts with sibling specs, checked against the provider's implementation or frozen spec, not against a plan;
- deploy order across repos;
- platform limits;
- which design version is final.

Anything touching the same file, flow or contract is a dependency until the developer says otherwise: list it with its state and its owner (or "owner unknown, to ask"). Do not dismiss it as unrelated on your own. When Jira, Confluence or the other repos are not reachable, say what could not be searched and ask the developer instead of reporting "nothing found".

**Signals.** A name like "Spec B" cited without a link; a consumer spec copying a provider's unfrozen decision; two specs adding values to the same catalogue (log codes, error codes); two pieces of work editing the same file.

**Checkpoint.** "Is this list complete? Who owns each dependency, and is its contract frozen?"

**Sources.** The team's own practice (P3, P9 in `writing-tech-specs`); no literature found.

## Step 6. Options and recommendation

**Agent.** Two or three realistic options, including a smaller one and "keep as is" when meaningful. For each: what it reuses, what it creates, risks and unknowns to resolve or cut, what stays blocked. Recommend one, with the reason. A mechanism is a suggestion unless tied to behavior to preserve (P1). If only one option is reasonable, say so and why.

**Checkpoint.** "Which direction do you choose?" The choice becomes a Proposed row, later Decided, in the spec's decision table (P8).

**Sources.** Google design docs (alternatives considered). Shape Up (rabbit holes).

## Step 7. Brief and open questions

**Agent.** Consolidate into the brief (`brief-template.md`). Each open question carries an owner and a moment: before freeze, during implementation, or out of scope. A gap in the input is never filled with a chosen answer; it becomes a question, optionally with a proposal marked as a proposal. Each fact from code carries a date, a commit and a command to re-verify it.

**Checkpoint.** "Read the brief as a whole. Is anything wrong, missing or decided that should not be?"

**Sources.** Example Mapping (open questions kept apart so the session continues; snippet). Shape Up pitch.
