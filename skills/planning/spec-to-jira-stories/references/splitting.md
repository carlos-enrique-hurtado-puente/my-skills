# One story or several

Load this when deciding whether a spec gives one story or more, or when the developer asks why.

## Default

One spec gives one story. In every case reviewed on the source team, each spec produced exactly one story; when the team wanted two stories, they wrote two specs (or one spec in two pages for one feature, see case 42 below).

Raise a split only when the spec gives reasons. Ask the questions below, quote the spec for each signal you find, and let the developer decide. Touching several repositories is not a reason by itself.

## Questions to ask

| # | Question | Signal in the spec | Source |
|---|---|---|---|
| 1 | Does each part give something useful on its own (to a user, another team, QA)? | Solution, acceptance criteria | INVEST "Valuable" (Wake 2003); Lawrence, step 1 |
| 2 | Can each part be tested separately, or does certification only make sense with everything? | Acceptance criteria grouped by layer vs mixed | Visual Paradigm, stories across teams |
| 3 | Do the parts have different blockers or rhythms (pending design, another team, another date)? | Pending items, dependencies | LeSS (feature vs component teams); DORA loosely coupled teams |
| 4 | Is there a mandatory deploy order, or a contract one part requires and another provides? | "deploy order", "precondition" | DORA loosely coupled teams |
| 5 | Does it fit one iteration, or should it be split by path or rule rather than by layer? | Pre-estimate (S/M/L), size of the technical changes | SPIDR (Cohn); Lawrence patterns |
| 6 | If several splits are possible, which exposes what can be deferred or dropped, and which gives similar sizes? | Decisions, out of scope | Lawrence, step 3 |

Sources with links: `evidence.md`.

## Rule of thumb (a heuristic, not a gate)

Keep one story unless:

- there is a reason to split (a different blocker, rhythm or team, or too big for one iteration), **and**
- each part can be deployed and tested alone without leaving the system broken.

A one-way dependency with a closed contract (backend first, front consumes it later) is acceptable for a split. Mutual coupling (strict deploy order, one part breaks the system without the other) argues for one story.

## Layer splits are the exception

The literature's default (Lawrence, Cohn) is that layer-only stories fail INVEST "Independent" and "Valuable". When you propose a backend story and a frontend story, say so explicitly and name which question above justifies the exception, with the quote from the spec.

## How to present a split

- As a proposal, not a verdict: "I propose two stories because ...", with the quotes, then ask.
- Also when the developer pushes the other way ("keep it as one, splitting is an antipattern", or "it touches two repos, so two stories"): give the evidence either way and let them decide.
- If split: each story's description names the other, and the stories are linked with "relates to" (a separate creation step that needs its own confirmation).

## Calibration cases (source team, project ITV)

- **Spec 42, Recuperaciones personalizadas** (two pages, Backend and Front): split into two stories, backend ITV-831 and front ITV-835. Reason: the front was blocked by pending design rework, and the backend could ship first without changing behavior ("el modo Por defecto sigue funcionando igual"). Questions 3 and 4: different blocker, one-way dependency with a closed contract.
- **Spec C, Tipo de conversación** (ITV-813): touches three repos and stayed one story. Strict deploy order acf, abf, agent-builder, and publish validation requires a field only the front can configure. Question 4: mutual coupling.
- **Spec A, Colapso del funnel** (ITV-804): stayed one story; the front deploy is a precondition of the data script. Question 4.
