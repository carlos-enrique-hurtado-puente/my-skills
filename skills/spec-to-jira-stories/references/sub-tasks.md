# Sub-tasks inside a story

Load this when deciding how many development sub-tasks a story has, or when the developer asks why.

## Layout

- Splitting a story's work into sub-tasks by layer is compatible with vertical stories (Wake's SMART tasks; Scrum.org discussions). Sub-tasks by layer are expected.
- **Always present:** one certification sub-task and one code review sub-task per story, covering all of its development sub-tasks.
- **Development sub-tasks:** at least one, following the roles the spec needs. A story may have only backend, only frontend, or one full-stack sub-task (source team: ITV-809 backend only, ITV-835 front only, ITV-804 one `[FULL]`). Never add a role the spec does not touch.

## The unit is one PR

One development sub-task is roughly one pull request. If a sub-task would need more than one PR, that is the signal to split it into "(Parte N de M)". Size alone ("the spec is M", "it is risky") is not a reason to split; the question is whether the work fits one reviewable, self-contained PR.

Evidence:

- **Google engineering practices, small CLs** (primary): a change should be self-contained, address one thing, include its tests, and leave the system working.
- **DORA, working in small batches** (primary): small batches correlate with better delivery performance.
- Supporting, vendor sources (cite as support, not as rules): SmartBear/Cisco study (defect discovery drops past 200 to 400 lines reviewed at once); LinearB benchmarks (elite teams under about 105 changed lines per PR).

Tickets are written before code, so PR size cannot be measured. Estimate from spec signals (how many blocks, areas or files the technical-changes section lists for one sub-task) and turn it into a question for the developer, not a rule: "This backend part lists blocks A and B with an order rule between them; I see two PRs. Split into Parte 1 de 2 and Parte 2 de 2?"

## Separate or keep together (heuristics)

| Separate into another sub-task when | Keep together when |
|---|---|
| It is another role (backend, frontend, full) | The pieces require each other (versions, internal contract) |
| There is a mandatory order between blocks (migrate before delete) | They are verified as one unit (one full test and build run) |
| It would need more than one PR | Splitting would leave tasks that overlap or cannot be marked done alone |
| The spec already names separate blocks (A1/A2, Block A/B) | It is another repo but the same layer and owner |

## Examples (source team)

- **ITV-781**: planned one backend sub-task ("todos entran en un mismo PR, porque se verifica como una sola unidad") and ended as two parts: ITV-840, the LangChain cluster ("sus paquetes se exigen versión entre sí"), and ITV-782, the rest. The cluster that had to move together stayed together; the rest became its own PR.
- **ITV-551**: split by the spec's blocks (A migrate; B+C+D delete, clean, decommission) with an order rule ("cortar el consumidor antes que el servicio").

## Naming parts

When a role is split, every part keeps the role prefix and the same base title, with "(Parte N de M)" at the end, in the reference ticket's language (English: "(Part N of M)"). State the reason for the split in each part's notes, and give the order between parts if there is one.
