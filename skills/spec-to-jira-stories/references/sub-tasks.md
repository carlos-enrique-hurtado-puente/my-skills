# Sub-tasks inside a story

Load this when deciding how many development sub-tasks a story has, or when the developer asks why.

## Layout

- Splitting a story's work into sub-tasks by layer is compatible with vertical stories (Wake's SMART tasks; Scrum.org discussions). Sub-tasks by layer are expected.
- **Always present:** one certification sub-task and one code review sub-task per story, covering all of its development sub-tasks.
- **Development sub-tasks:** at least one, following the roles the spec needs. A story may have only backend, only frontend, or one full-stack sub-task (source team: ITV-809 backend only, ITV-835 front only, ITV-804 one `[FULL]`). Never add a role the spec does not touch.

## Split by deliverable, not by PR size

A development role becomes more than one sub-task only when **all four** criteria hold. Quote the spec for each.

| Criterion | Question | Source |
|---|---|---|
| Own deliverable | Does each part produce a result someone can verify and mark done on its own, not an internal piece checked only by its own tests? | WBS (PMBOK: deliverable-oriented decomposition); Wake, SMART "Measurable" |
| No overlap | Do the parts avoid touching the same design decision or the same code? | WBS mutual exclusivity (100% rule); Parnas 1972, decompose by design decisions likely to change |
| Low-dependency seam | Do the parts meet through a stable interface rather than shared internals? | Parnas 1972 (a module is a work assignment); Cataldo and Herbsleb, socio-technical congruence (splits that cut across dependencies raise failures) |
| A real reason worth the cost | Is there a mandatory order where each step has value of its own, another owner or team, or a risk worth isolating and shipping first, that outweighs one more ticket, review and certification? | Reinertsen, batch size is a U-curve trade-off, not "smaller is always better" |

Not reasons to split:

- **The spec's section headings** (data layer, backend, API, infrastructure). They are how the document is organized, a horizontal cut inside one role.
- **Estimated size, PR count, or PR lists written before code** (for example placeholder `PR #[...]` lines in an older code review ticket). Tickets are written before code exists; such lists are predictions.
- **PR size itself.** Small PRs help review (Google small CLs), but they do not need separate tickets: one sub-task may hold several stacked PRs. With coding agents, producing code is not the bottleneck; verifying it is. DORA 2024 associates AI adoption with a 7.2% drop in delivery stability and its researchers suspect larger changes, so keep changes reviewable, but split tickets by deliverable.

## Split options

Before drafting, offer 2 or 3 concrete options, for example "A: one `[BACKEND]`" and "B: two parts, X and the rest". For each option give:

- the sub-tasks it would produce;
- which criteria hold and which fail, with spec quotes;
- its cost: tickets, reviews, certification passes, risk.

Mark one as recommended with the reason, and let the developer choose or mix. If only one option is reasonable (one area, no seam), say so and why; do not invent alternatives.

## Examples (source team)

- **ITV-551** (Python to Node): justified split. Two verifiable deliverables ("the live endpoints run in Node" and "the dead Python code is gone") with an order rule ("cortar el consumidor antes que el servicio").
- **ITV-781** (dependency bump): ITV-840 (the LangChain cluster, "sus paquetes se exigen versión entre sí") and ITV-782 (the rest). The seam holds; the reason is weak. A one-sub-task option was as defensible.
- **Spec 42 Backend** (ITV-832): one `[BACKEND]`. The spec's four blocks are document layers; they overlap (retiring the old normalization touches the cron) and are verified only together through the cron's behavior. A split into the pure schedule engine and the rest meets the order criterion but not "own deliverable": nobody verifies the engine outside its tests.

## Naming parts

When a role is split (all four criteria hold), every part keeps the role prefix and the same base title, with "(Parte N de M)" at the end, in the reference ticket's language (English: "(Part N of M)"). State the reason for the split in each part's notes, and give the order between parts if there is one.
