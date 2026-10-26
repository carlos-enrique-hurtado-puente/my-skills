# discovering-tech-changes: design

- **Date:** 2026-10-26
- **Status:** draft for review; nothing built yet
- **Related:** [writing-tech-specs](skills/writing-tech-specs.md) (consumes this skill's output), [spec-to-jira-stories](skills/spec-to-jira-stories.md) (runs after the spec)

## 1. Intent and why

`writing-tech-specs` has a "Before writing" section: seven questions to answer "by asking the user or reading the code". It is vague, and it asks a spec-writing skill to also do the discovery. This design moves that work into its own skill that runs **before** the spec and ends with a document the spec is written from.

Two problems the developer lives with when working with coding agents:

1. **No mental model of the code.** An agent that names variables and methods in dense technical language does not help the developer understand what is happening. What helps is an explanation, in plain words, of the problem, of how the flow works today, and of the proposed solution.
2. **Wrong reuse decisions, in both directions.** Lacking context, agents skip existing code that already solves part of the problem, and sometimes do not propose something new when it is needed.

The goal: when the developer reaches the spec, they already know what is asked, how the system behaves today, what exists to reuse, what else is moving around it, and which options there are. The spec then only has to document decisions rigorously.

## 2. Goals, non-goals, anti-goals

**Goals**
- Take an input (FRD, user stories, a task, or a design) and produce a **discovery brief**: context of what exists, what is asked, and the possible things to do to achieve it.
- Do it **iteratively with the developer**: every step ends with a point where the developer validates or corrects before the next step.
- Explain in plain language first; code identifiers are evidence underneath, never the explanation.
- Make the reuse decision explicit and evidenced, in both directions (reuse what exists; create what is missing).
- Ground each step in cited sources and in the team's real Jira evidence, as **open heuristics** the agent and developer resolve together, not closed rules.

**Non-goals**
- Not an implementation plan. `superpowers:writing-plans` produces exact code steps; this brief does not.
- Not the spec: no acceptance criteria, contract definitions or decision tables beyond what the brief proposes. Those stay in `writing-tech-specs`.
- Does not decide. It proposes and recommends; the developer decides, and the decision is recorded in the spec (P8).
- Does not modify the user's repository or Jira (read-only).
- Does not run implicitly: manual invocation only (`disable-model-invocation: true`, `allow_implicit_invocation: false`).

**Anti-goals** (a failure even if it "works")
- An interrogation that asks the developer things the code already answers.
- A dense dump of file names, line numbers and identifiers that the developer cannot follow.
- A long document nobody reads.
- Claiming "nothing to reuse" without saying what was searched.
- Deciding on the developer's behalf.

## 3. Where it sits

```
FRD / user stories / task / design
        |
        v
  discovering-tech-changes  --->  discovery brief   (this design)
        |
        v
  writing-tech-specs        --->  spec              (frozen by the LT)
        |
        v
  spec-to-jira-stories      --->  Jira tickets
        |
        v
  superpowers:writing-plans --->  step-by-step code plan (per ticket)
```

Tickets derive from the spec, so they are not inputs. A small change can be run with reduced depth (section 5, "Depth").

## 4. Principles

1. **The developer is in the loop at every step.** The agent never runs the whole process and hands over a result. Steps can be revisited when something learned changes an earlier answer (steps 3 to 6 interleave in practice).
2. **Plain words first.** Each step reports in language the developer can follow without opening the code. Code references support claims; they are not the claims.
3. **Observed, inferred, asked.** Every fact in the brief is labelled by how it is known: observed in code (where, date, commit), inferred, or told by the developer. Nothing is invented; a gap becomes a question with an owner.
4. **Propose and recommend, never decide.** Options carry a recommendation with its reason; the developer chooses.
5. **Scope the exploration.** Codebase exploration fills the agent's context fast. The skill may delegate searches to read-only subagents and report conclusions (Claude Code best practices).
6. **Depth is the developer's call.** The skill asks at the start how deep to go.

## 5. The process

Seven steps. Each lists what the agent does, signals to look for, the developer checkpoint, and the evidence behind it. "Jira evidence" counts the seven reviewed cases (ITV-831, 835, 813, 804, 823, 888, 878) where the signal appeared.

### Depth
Asked at the start. Two levels: **full** (steps 1 to 7) or **reduced** (steps 3 and 4 plus a short brief) for a change the developer can describe in one sentence. The developer picks; the skill does not decide. Source: Claude Code best practices (skip the plan when the diff fits in a sentence); Google design docs (skip the doc when the path is obvious).

### Step 1. Intake and contrast of the input
- **Agent:** read the whole input (Confluence and Jira through the Atlassian tools when connected; if unreadable, say so and ask). Restate in plain words what is asked and the expected outcome. Mark omissions (a trigger without a response), ambiguity, and contradictions between criteria. Start the **corrections to the input** list ("input says / is"); steps 3 to 5 finish it, because the input can only be proven wrong after reading the code.
- **Signals:** requirement without trigger or reverse operation; vague quantifiers; two criteria that cannot both hold; a design showing values the system rejects.
- **Checkpoint:** "Is this what is being asked?"
- **Evidence:** Wiegers via Jama (omissions and ambiguity, secondary); Ferrari and Gnesi (ambiguity often points to unspoken knowledge, secondary); Claude Code best practices (let the agent interview the user). Jira: 5 of 7 specs carry "FRD says / is" or "design shows / is" corrections (831, 835, 813, 823, 878).

### Step 2. Framing
- **Agent:** goals, **non-goals** (reasonable goals deliberately excluded, not negations), how success will be known, short context that links instead of repeating.
- **Checkpoint:** developer confirms goals and non-goals.
- **Evidence:** Google design docs (read: context and scope, goals and non-goals); Shape Up (read: boundaries, rough, solved, bounded). Jira: all 7 specs have an out-of-scope list. No Jira signal of gaps here.

### Step 3. How it works today
- **Agent:** explain the flow as **observable behavior** first (what the user or the system sees), then the path in code as support. Trace the complete flow, not only the local piece. Also look for: who else calls this path; who else reads or writes the same data; side effects triggered by writing it (triggers, timeouts); wire contracts to other repos; silent behavior (things dropped without error); test coverage of the zone; the git history of the zone when behavior is surprising.
- **Signals:** a code path with more than one caller; a field written by more than one repo; a flag whose commit message does not explain it; a zone with no tests.
- **Checkpoint:** developer corrects the explanation. This is the step that builds the mental model; do not rush it.
- **Evidence:** Anthropic study, 52 developers (read): participants who asked conceptual questions or asked for code with explanations kept their comprehension, those who delegated everything did not; association, small subgroups, not causal. Naur, programs as theories held by people (summaries only; essay not read directly). Littman et al., via a conceptual-model paper (read): developers who traced the whole flow did better on a modification task. Claude Code best practices (ask codebase questions; use git history). Feathers: tests that record actual behavior (summary only). Jira: 804 (silent discard, wire contract `isLeadPipeline`, front and wizard writing the old form), 813 (trigger on every write, default timeout), 823 (flag coupled by a hotfix), 879 (migration also uses the publish path).

### Step 4. Reuse inventory and conventions
- **Agent:** for each piece of behavior the change needs, search for existing code that already does it or nearly does (utilities, datasources, UI components and editors). Also record repo **conventions** (error-code naming, UI patterns, i18n) and the **limits of existing patterns**. Decide per item: reuse as is, adapt, or create, with the reason. State what was searched (terms, paths) so the developer can judge the coverage. Check the opposite risk: where reuse would force flags or parameters to bend shared code, say so.
- **Signals:** a spec step that creates a module whose name resembles an existing one; a new dependency where the repo already has a precedent; a requirement the existing pattern cannot satisfy.
- **Checkpoint:** developer confirms the inventory and marks disagreements.
- **Evidence:** Claude Code best practices (read: point to existing patterns; "whether we have existing utilities I should reuse"). GitClear (press coverage only, correlational: more duplicated code, less refactoring in AI-assisted codebases; no study measured coding agents specifically). Metz "The wrong abstraction" (read: duplication is cheaper than a wrong abstraction once an abstraction has been proven wrong; it does not say "do not reuse"). Jira: 832 (`readFlowState()` reused instead of a new reader), 836 (`FieldConditionEditor` reused instead of a new button), 832 (`AGE-ENG24x` codes instead of invented `RECOVERY_*`), 836 (existing modal pattern has no focus trap).

### Step 5. Surroundings of the change
- **Agent:** other specs and work in progress touching the same files, flows or contracts (search the epic, the sprint, Confluence specs in the same space, open branches); contracts with sibling specs, **checked against the provider's implementation or frozen spec, not against a plan**; deploy order across repos; platform limits; which design version is final. When Jira, Confluence or the other repos are not reachable, say what could not be searched and ask the developer instead of reporting "nothing found".
- **Signals:** a name like "Spec B" or "spec 37" cited without a link; a consumer spec copying a provider's unfrozen decision; two specs adding values to the same catalogue (log codes).
- **Checkpoint:** developer confirms the list and who owns each dependency.
- **Evidence:** the team's own (P3, P9 in `writing-tech-specs`); no literature found. Jira: undocumented or unowned dependencies in 5 of 7 (831, 813, 804, 888, 823); contract drift between sibling specs in 835 against 831 (days format); deploy order in 804, 813, 823.

### Step 6. Options and recommendation
- **Agent:** two or three realistic options, including a smaller one and "keep as is" when meaningful. For each: what it reuses, what it creates, risks and unknowns to resolve or cut, and what stays blocked. One recommended, with the reason. A mechanism is a suggestion unless tied to behavior to preserve (P1).
- **Checkpoint:** developer chooses the direction. It becomes a Proposed row, later Decided, in the spec's decision table (P8).
- **Evidence:** Google design docs (read: alternatives considered). Shape Up (read: rabbit holes). Jira: weak; the 832 design was simplified at implementation (no `wakeCount`, no `sequenceStartedAt`), which suggests options were thin, but one case is not a pattern.

### Step 7. Brief and open questions
- **Agent:** consolidate into the brief (section 6). Each open question carries an owner and a moment: before freeze, during implementation, or out of scope. Each fact from code carries a date, a commit and a command to re-verify it. The developer reads the brief as a whole.
- **Checkpoint:** developer validates the brief.
- **Evidence:** Example Mapping (open questions kept apart so the session continues; snippet only). Shape Up pitch (read). Jira: "por asignar" owners in 813, 804, 888; spec 804's "Verificación previa" (a `grep` per block run on implementation day) is the model for re-verification commands.

## 6. The discovery brief

Written in the language the developer uses. Delivered where the developer says (a file, Confluence, or chat); default: chat, offering a file.

| # | Section | Content |
|---|---|---|
| 0 | Header | Input and its link; date; branch and commit examined; what the developer validated and when |
| 1 | In plain words | The problem, the expected outcome, how it works today, the proposed solution. One page at most; no identifiers; anything the reader must find goes on an Evidence line |
| 2 | Corrections to the input | Table: input says / is / evidence |
| 3 | Goals and non-goals | From step 2 |
| 4 | How it works today | Flow in plain words, then evidence rows: fact, where, date and commit, how it is known (observed / inferred / told), command to re-verify |
| 5 | Reuse inventory and conventions | Table: need / existing / reuse, adapt or create / reason / what was searched |
| 6 | Surroundings | Other specs and work in progress, contracts and their state, deploy order, platform limits, design version |
| 7 | Options and recommendation | From step 6 |
| 8 | Open questions | Table: item / owner / moment |

**How `writing-tech-specs` consumes it** (to be changed in the plan, not now):

| Brief section | Spec use |
|---|---|
| 1 | "What we are building" (P2) |
| 2 | "Spec says / is" table (P2) |
| 4 | Assumptions with date and commit (P3) |
| 5 | Reasons beside each fixed mechanism (P1) |
| 6 | Contracts and sibling specs (P9), work in flight (P3) |
| 7 | Decisions as Proposed rows (P8) |
| 8 | Open questions table (P8) |

The "Before writing" section of `writing-tech-specs` is replaced by: ask for the brief; if there is none, offer to run `/discovering-tech-changes`; if the developer declines, list the gaps as open questions, never fill them with invented facts.

## 7. Evidence base

Read means the page or paper was read in this work; summary means only secondary descriptions were seen.

| Source | Status | Used for |
|---|---|---|
| [Claude Code best practices](https://code.claude.com/docs/en/best-practices) | read | Explore before planning; interview the user; scope exploration; reference existing patterns; skip planning for one-sentence diffs |
| [Google design docs](https://www.industrialempathy.com/posts/design-docs-at-google/) | read | When not to write; context and scope; goals and non-goals; alternatives |
| [Shape Up, chapter 2](https://basecamp.com/shapeup/1.1-chapter-02) | read | Boundaries, rough and solved, rabbit holes, pitch |
| [Anthropic, AI assistance and coding skills](https://www.anthropic.com/research/AI-assistance-coding-skills) | read (page; paper abstract) | Explanation and conceptual inquiry preserved comprehension; delegation did not |
| [Osmani, comprehension debt](https://addyosmani.com/blog/comprehension-debt/) | read | Framing only; the trial above is its only evidence, the rest is opinion |
| [Metz, The wrong abstraction](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction) | read | Reuse is not always right |
| [Conceptual model of code comprehension](https://arxiv.org/html/2310.11301) | read | Letovsky's mental model; Littman's systematic strategy |
| Naur, Programming as Theory Building | summary | Plain-language mental model as the goal |
| Feathers, Working Effectively with Legacy Code | summary | Characterize actual behavior |
| Wiegers, via Jama; Ferrari and Gnesi | summary | Omissions and ambiguity |
| Example Mapping | snippet | Open questions kept apart |
| GitClear | press coverage | Duplication trend; correlational |

**Dropped:** the claim that comprehension runs on "inquiry episodes" (question, conjecture, search): not found in anything read. Storey 1998 and the original Letovsky paper could not be opened.

**Jira cases:** seven specs and their tickets, plus the comments of four subtasks (832, 836, 879, 889). Subtasks 805, 814, 815, 833 and 837 were not read, so "no comments" is not read as "no rework".

**Limits:** one team; several tickets are the developer's own; a late comment shows what changed, not always why. The plain-language step (3) is supported by literature and the developer's experience, not by Jira: the tickets do not show whether an explanation was validated before the spec.

## 8. Skill layout

```
skills/discovering-tech-changes/
  SKILL.md                    process, checkpoints, rules; manual only
  agents/openai.yaml          allow_implicit_invocation: false
  references/
    steps.md                  per step: signals, questions, evidence
    brief-template.md         the brief and how to fill each section
    evidence.md               sources, support levels, Jira cases, limits
docs/skills/discovering-tech-changes.md   (+ .es.md)
tests/discovering-tech-changes/
  check-structure.sh
  scenarios/                  pressure scenarios (section 9)
```

`SKILL.md` stays short: the process and the rules. Evidence and examples live in `references/`, loaded only to justify a step. A row for the skill is added to `README.md` and `README.es.md`.

## 9. How it will be tested

Per `superpowers:writing-skills`: run each scenario **without** the skill (baseline), write the skill, then close loopholes. Runners do not see the expected result; a separate scorer agent grades.

Pressure scenarios, each built from the real cases:
1. **Input contradicts the code** (like 831 and 835): does the agent surface the correction instead of building on the input?
2. **A reusable utility exists under a different name** (like `readFlowState()`): does the agent find it and say what it searched?
3. **A convention exists** (error-code naming): does the agent follow it instead of inventing?
4. **A second caller of the path** (like the migration in 879): does the agent find who else uses it?
5. **Another spec in flight** (like Spec B): does the agent ask or search, not ignore?
6. **Pressure to skip checkpoints** ("just give me the brief"): does the agent still stop at each step?
7. **Identifier-dense answer**: is the plain-language section understandable without opening code?
8. **Missing information**: does the agent leave a question with an owner instead of inventing a fact?
9. **Obvious change**: does the agent offer reduced depth and wait for the developer?

An implicit prompt must not load the skill; `$discovering-tech-changes` and `/discovering-tech-changes` must.

## 10. Calls made without the developer (check these)

- **Name:** `discovering-tech-changes`, and the term "discovery brief". Avoids "plan", which collides with `writing-plans`.
- **Depth:** two levels, chosen by the developer at the start.
- **Output language:** the developer's language; repo files stay in English.
- **Delivery:** chat by default, offering a file or a Confluence page.
- **Subagents:** the skill may delegate read-only codebase searches to protect context.
- **Read-only:** no writes to the user's repo or Jira.
- **`writing-tech-specs` is not edited in this work item** beyond the plan; its change is a follow-up step (section 6).

## 11. Open for the developer

1. Should the brief for a reduced-depth run still list reuse and conventions (step 4), or only the plain-language explanation (step 3)? This design keeps both.
2. Should the skill publish the brief to Confluence when connected, or only on request? This design: only on request.

## 12. Left to the builder

Exact wording of `SKILL.md`; how the questions of each step are phrased; whether `steps.md` is split further; the fixtures for the scenarios; and the `check-structure.sh` checks, modeled on `tests/stack-code-review/`.
