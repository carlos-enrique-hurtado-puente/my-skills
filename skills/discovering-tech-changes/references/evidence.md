# Evidence

Load this file to justify a step or to say how strong its support is. Status: **read** = the page or paper was read in this work; **summary** = only secondary descriptions were seen; **snippet** = a short excerpt only; **press coverage** = only news reports of the study. A link on a summary, snippet or press-coverage row is for lookup; it was not opened in this work.

## Sources

| Source | Status | Used for |
|---|---|---|
| Claude Code best practices: https://code.claude.com/docs/en/best-practices | read | Explore before planning; interview the user; scope exploration and delegate it to subagents; reference existing patterns; ask codebase questions; use git history; skip planning for one-sentence diffs (steps 1, 3, 4, Depth) |
| Google design docs: https://www.industrialempathy.com/posts/design-docs-at-google/ | read | When not to write a doc; context and scope; goals and non-goals; alternatives considered (steps 2, 6, Depth) |
| Shape Up, chapter 2: https://basecamp.com/shapeup/1.1-chapter-02 | read | Boundaries; rough, solved, bounded; rabbit holes; the pitch (steps 2, 6, 7) |
| Anthropic, AI assistance and coding skills: https://www.anthropic.com/research/AI-assistance-coding-skills | read (page; paper abstract) | 52 developers: those who asked conceptual questions or asked for code with explanations kept comprehension; those who delegated everything did not. Association, small subgroups, not causal (step 3, plain words) |
| Osmani, comprehension debt: https://addyosmani.com/blog/comprehension-debt/ | read | Framing only; the study above is its only evidence, the rest is opinion |
| Metz, The wrong abstraction: https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction | read | Reuse is not always right: duplication is cheaper than a wrong abstraction once proven wrong; it does not say "do not reuse" (step 4) |
| Conceptual model of code comprehension: https://arxiv.org/html/2310.11301 | read | Letovsky's mental model; Littman's systematic strategy (tracing the whole flow did better on a modification task) (step 3) |
| Naur, Programming as Theory Building: https://pages.cs.wisc.edu/~remzi/Naur.pdf | summary | A program is a theory held by people; a plain-language mental model as the goal (step 3) |
| Feathers, Working Effectively with Legacy Code | summary | Characterize actual behavior before changing it (step 3) |
| Wiegers, via Jama; Ferrari and Gnesi | summary | Omissions and ambiguity; ambiguity often points to unspoken knowledge (step 1) |
| Example Mapping: https://cucumber.io/blog/bdd/example-mapping-introduction/ | snippet | Open questions kept apart so the session continues (step 7) |
| GitClear, AI and code quality: https://www.gitclear.com/coding_on_copilot_data_shows_ais_downward_pressure_on_code_quality | press coverage | More duplicated code, less refactoring in AI-assisted codebases; correlational; no study measured coding agents specifically (step 4) |

## Dropped claims

- Comprehension runs on "inquiry episodes" (question, conjecture, search): not found in anything read.
- Storey 1998 and the original Letovsky paper could not be opened; nothing is cited from them directly.

## Team evidence (Jira)

Seven specs and their tickets were reviewed: ITV-831, ITV-835, ITV-813, ITV-804, ITV-823, ITV-888, ITV-878. Plus the comments of four subtasks: ITV-832, ITV-836, ITV-879, ITV-889. Subtasks ITV-805, ITV-814, ITV-815, ITV-833 and ITV-837 were not read, so "no comments" is not read as "no rework".

| Step | What the cases showed |
|---|---|
| 1. Intake | 5 of 7 specs carry "FRD says / is" or "design shows / is" corrections: ITV-831, ITV-835, ITV-813, ITV-823, ITV-878 |
| 2. Framing | All 7 specs have an out-of-scope list; no signal of gaps here |
| 3. How it works today | ITV-804: a silent discard, a wire contract (`isLeadPipeline`), and the front and the wizard still writing the old form. ITV-813: a trigger on every write and a default timeout. ITV-823: a flag coupled by a hotfix. ITV-879: a migration also uses the publish path (a second caller) |
| 4. Reuse and conventions | ITV-832: `readFlowState()` reused instead of a new reader; `AGE-ENG24x` error codes used instead of invented `RECOVERY_*` codes. ITV-836: `FieldConditionEditor` reused instead of a new button; the existing modal pattern has no focus trap (a limit of the pattern) |
| 5. Surroundings | Undocumented or unowned dependencies in 5 of 7: ITV-831, ITV-813, ITV-804, ITV-888, ITV-823. Contract drift between sibling specs: ITV-835 against ITV-831 (days format). Deploy order across repos: ITV-804, ITV-813, ITV-823 |
| 6. Options | Weak: the ITV-832 design was simplified at implementation (no `wakeCount`, no `sequenceStartedAt`), which suggests the options were thin; one case is not a pattern |
| 7. Brief | Owners left "to assign" in ITV-813, ITV-804, ITV-888. The "pre-check" section of ITV-804 (one `grep` per block, run on implementation day) is the model for re-verification commands |

## Limits

- One team; several tickets are the developer's own.
- A late comment shows what changed, not always why.
- The plain-language step (3) is supported by the literature and the developer's experience, not by Jira: the tickets do not show whether an explanation was validated before the spec.
- Step 5 (surroundings) rests on the team's own practice; no literature was found.
