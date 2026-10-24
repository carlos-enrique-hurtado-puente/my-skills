# Block 1: what goes in the spec (P1 to P4)

Evidence and examples for the rules in `SKILL.md`. "Before → after" examples are illustrative: rewritten from the team's specs, not their original text. Roles only (dev, LT, PM, QA); ITV-xxx are the team's tickets.

## P1. Describe behavior; justify every constraint

**Support: Backed.**

Rule, restated: a mechanism (library, file, function, way of implementing) is a constraint only with its reason next to it. Without a reason it is a suggestion, marked non-binding. Quick test: ask "why?" about each implementation detail until you reach a need. If the answer is "because I thought of it that way", it is a suggestion.

Technique: write the reason as the behavior to preserve ("a failure must be distinguishable from 'not met'"), not as the mechanism itself. If the mechanism stops working, the implementer swaps it and keeps the intent.

**Why (team data).**
- What changed during implementation was almost always a prescribed mechanism:
  - ITV-831: `wakeCount` and its error code were removed, and `luxon` was rejected.
  - ITV-813: the central decision "a single tool" became obsolete.
  - ITV-804: the rename to `stages` was not done, and the 4-step deploy became one step.
  - ITV-835: the "Insert variable" button was not built.
- Criteria describing behavior held up best: 32 of 35 passed the first QA review in the ITV-835 front.
- ITV-813: the spec justified the single tool with a behavior (criteria 8 and 16 depended on telling a failure from "not met"). When the code premise changed, the dev replaced the tool with structured output and wrote that "the intent of the agreed decision is kept". It was the biggest mechanism change in that spec and it was settled without discussion, because the intent was written down.

**Sources.**
- Wiegers, *The Fuzzy Line between Requirements and Design*: a design constraint is legitimate only when it comes from a real need, and the reason is noted. https://www.modernanalyst.com/Resources/Articles/tabid/115/ID/3155/The-Fuzzy-Line-between-Requirements-and-Design.aspx
- GitHub Spec Kit, `spec-driven.md`: the spec says what and why, without technology; the how goes in a separate plan. https://github.com/github/spec-kit/blob/main/spec-driven.md
- INCOSE rule R31 (via Jama): "what, not how"; implementation detail only with a documented reason. https://www.jamasoftware.com/requirements-management-guide/writing-requirements/incose-requirements-writing-guide/
- Rust RFC template: separates the guide-level explanation (what the user sees) from the reference-level one (technical design, presented as illustration). https://github.com/rust-lang/rfcs/blob/master/0000-template.md
- Writing the reason as behavior is the team's own technique, observed in ITV-813.

**Before → after** (from ITV-813).
- Before: "A single tool `set_conversation_type` with two required booleans, not two tools, because `bindTools` does not force `tool_choice`."
- After: "When closing a conversation, the system determines whether it is sales, service or undetermined, and records it. If determining it fails, the conversation still closes and the failure is recorded."
- If a real technical constraint sits behind it, write it as a constraint: "Constraint: the model cannot be forced to call a tool. Reason: …".

**Limit.** Sometimes the mechanism is a real constraint (compatibility with an existing system, a standard, a security rule). Then it goes in with its reason. The point is not to remove technical detail but that each detail says why it is there.

## P2. Self-sufficient: define terms, say what is fixed and what is free

**Support: Partial.** Wiegers (note the reason so the implementer knows the margin) and the Claude Code best-practices doc (good specs are self-contained) support part of it. Marking "fixed" and "free" explicitly, and the cleanup rule, are the team's own.

Cleanup before freezing: someone reading without context cannot tell what is current from what is left over. So: no unfilled template markers ("HU-XX", "@name", "[TBD]"); no sections, criteria or decisions from another spec; no references to files or notes the reader cannot open (local plans, notes to the author); criteria cited by a stable ID, not by position ("AC 15" stops being 15 when a 10b is inserted); the spec links its ticket and the title reflects the real scope.

**Why (team data).**
- Many prescribed details ended up changing, and each change was treated as a *deviation* from the spec. In ITV-823, QA returned the ticket three times because the approval record for three changes was missing. ITV-835 and ITV-804 went similarly.
- Our inference (not verified): if the spec had said what was free and what was not, part of those changes would not have been deviations.
- Cleanup: 7 of the 12 stories in sprints 15 and 16 had leftovers. ITV-551 included criteria, decisions and risks from another spec. ITV-809 cited an "AC 18" that does not exist and local work files. ITV-754 kept "HU XX", a duplicate section and a wrong project, and its title named a part that was out of scope.

**Before → after** (from ITV-835).
- Before: "'Insert variable' button that inserts `/{keyword}` at the cursor."
- After: "The person can refer to a catalog field inside the condition.
  - **Fixed:** the `/{keyword}` syntax, because it is the one the evaluator already interprets.
  - **Free:** the UI control. If there is a reusable condition editor, use it."

**Limit.** No need to label every line. Mark the constraints and say in one sentence what the implementer decides.

## P3. Assumptions with dates; refer to what does not exist yet by concept

**Support: Partial.** GNU Taler (date of last substantial change plus implementation status) and SoundCloud via Orosz (a review date in the header) cover the date idea. Listing dated assumptions, referring to future identifiers by concept, the 3-week threshold and the design reconciliation are the team's own. The design reconciliation is **barely tested**: no tested spec depended much on a Figma.

Rule details:
- Assumptions cover the platform (how Firestore behaves, how many buttons WhatsApp allows) and the design (which Figma version), not only the team's code.
- A decision whose reason is a code fact links to that assumption. If that code is changing because of other work (other specs, other PRs), the spec says so.
- If implementation starts more than about 3 weeks after the last verification, revalidate and update the dates.
- Design reconciliation, when the spec was written on a draft or partial mockup: name the design version with a date; check every type, verb or state the spec defines against the final design and list which have a design and which do not; those without design become open questions with an owner (see P8), not inventions; visual criteria carry a verifiable reference (node or screenshot), not "per the Figma".

**Why (team data).**
- Specs (18 and 21 September) were implemented 13 to 23 October: about 3 to 4 weeks.
- ITV-813: two PRs (#78 and #81) changed the evaluator in that interval and made the central decision obsolete. The decision rested on a code fact (the model was invoked with `bindTools` and no forced `tool_choice`) that was not listed as a dated assumption, and the spec did not warn that the evaluator was being changed by Spec B and other PRs.
- ITV-804: the spec said the highest log code in use was 229 and reserved 232 and 233. At implementation the highest was 254.
- ITV-835: the `agent` key clashed with one already used by the Assign node.
- Counter-example: in ITV-823 the cited paths and lines did not change; rules and policies did. And ITV-804 had a "Prior verification" section that helped.
- Platform, ITV-754: the TTL policy ended up configured in the Firestore console, not in `firestore.indexes.json` as the spec prescribed. The spec also did not say how long TTL deletion takes, and QA had no evidence it happened.
- Design (blind test, ITV-735/736): the log redesign specs came from a "theoretical draft". Against the real Figma, four log types changed content, the icon registry became indexed by verb, and three verbs got the generic icon because they had no design. After the sprint closed, defect ITV-769 ("the design does not match the Figma") was opened. Of 14 changes in that pair, 5 of the 6 the guide did not cover came from the design.
- Old specs: ITV-551 was implemented about 88 days after its spec, which assumed a live endpoint that was later retired. ITV-696, about 35 days after: its core criterion ended up in a repo being extracted to another.

**Before → after.**
- (ITV-804) Before: "Reserve log codes `AGE-ENG232` and `AGE-ENG233`." After: "Two new log codes (failure to compute; skipped for lack of Cortex). Values are assigned at implementation from the free ones in the current catalog." And in Assumptions: "The highest code in use is `AGE-ENG229` (verified 2026-09-18)."
- (ITV-813) Before: "A single tool, not two, because `bindTools` does not force `tool_choice`." After, in Assumptions: "The evaluator is invoked with `bindTools` and no forced `tool_choice` (verified 2026-09-18). That code is being changed by Spec B and other PRs: if it changes, the single-tool decision is reopened. The intent stays: a failure must be distinguishable from 'not met'."
- (ITV-735) Before: "`node_transfer` carries `content.stage{from, to, reason}`", taken from the draft. After: "Design used: Figma, node 520:19019, reviewed [date]. The stage change is shown as 'Moved to [stage]', without a dropdown. The verbs `used`, `finished` and `created` have no design: question for Design, before freezing."

**Limit.** Do not list trivial assumptions. Only those that force a design change if they stop being true.

## P4. Size by prescriptive surface; split before it grows

**Support: Hypothesis.** Use it to size the spec while writing. It is **weak as a predictor**: do not use it to forecast friction.

Rule details: measure by the number of names, paths, signatures and lines the spec fixes, not only its length. A spec covers a change that can be read and reviewed in one sitting. If the surface grows too much, reduce it (P1, P2) or split it by repository or by behavior segment. Compare any declared size (S, M) or hours with what the spec asks for. If they do not match, the problem is not the estimate: the spec is bigger than the team thinks, so reduce or split before freezing.

**Why (team data).**
- Reviewed specs run 3,200 to 5,500 words and 13 to 46 criteria (44 in the ITV-831 backend, 46 in the ITV-835 front). Our inference: more prescriptive surface means more points that can change. No short specs to compare against.
- ITV-878: only 7 criteria and one spec for two repos, but 12 mechanism rows with paths, lines, signatures and keys, and it still changed in the mechanism. What predicts change there is prescriptive surface, not criteria count. One case.
- Estimate vs. surface (sprints 15, 16): ITV-789 estimated about 68 h in the spec and 8 h in the story; the whole front (about 17 h) had no subtask and two UI criteria reached no ticket. ITV-551 was "S" with four rows estimated "≈ L"; the story was split. ITV-696 was "S" with about 27 h. That the gap caused the cut is our inference.
- As a predictor it fails: in round 3, two of three signals from this rule did not hold (ITV-707 logged 13 h against 32 h estimated; ITV-722 stayed size S).

**Sources.** Böckeler (Thoughtworks): Kiro generated 4 stories and 16 criteria for a small bug; excess documents weigh on review. https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html. Ubl, *Design Docs at Google*: about 10 to 20 pages as a ceiling for large projects, a 1 to 3 page "mini design doc" for incremental work. https://www.industrialempathy.com/posts/design-docs-at-google/. No source gives a threshold for the team's specs; contrasting estimate with surface is the team's own and a hypothesis.

**Before → after** (from ITV-831). Before: one spec with 44 criteria in seven groups (configuration, runtime resolution, wake-ups, closing, schedules, simulator, non-functional). After: separate specs by behavior segment that can be reviewed in one sitting, each with its own criteria.

**Limit.** Splitting creates contracts between specs; that is P9.
