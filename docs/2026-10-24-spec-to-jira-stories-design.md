# Design: `spec-to-jira-stories`

- **Date:** 2026-10-24
- **Repo:** `my-skills` (`skills/spec-to-jira-stories/`)
- **Plan:** to be written with `superpowers:writing-plans`
- **Status:** design approved (2026-10-24)

The skill name is a working name (builder may propose another; it must stay equal to the folder name).

## 1. Intent

Carlos works on a team (AtomChat, Jira project ITV "IA Team v2") that writes a technical spec per feature and then turns it into a Jira story with sub-tasks by hand. He wants a skill that takes a spec and helps the developer decide and write that breakdown: how many stories, which sub-tasks, and what each ticket says. Then, after approval, it creates the tickets in Jira.

The skill does not decide alone. It reads the spec, shows the evidence it found, asks about what the spec does not settle, and proposes. The developer decides. Criteria are open heuristics backed by cited sources, not closed rules, because rigid rules were judged counterproductive in real use.

It must also work for other teams with their own ticket format, so team conventions are not hard-coded.

## 2. Goals

1. **Spec in, ticket draft out.** Given a spec, produce a draft of the story (or stories) and their sub-tasks with the content each type needs (section 7).
2. **Help decide the breakdown.** Decide with the developer whether the spec is one story or several, and how many development sub-tasks each story has, using the heuristics in section 6 and showing the evidence for each.
3. **Team-agnostic.** The method is the same for every team; the format (title prefixes, role names, issue types, description sections, language) comes from a reference ticket the developer provides (section 5).
4. **Create in Jira only with consent.** After the developer approves the draft, create the tickets one at a time, asking for confirmation before each.
5. **Manual invocation only**, per `AGENTS.md`.

## 3. Non-goals

- Estimating hours, setting due dates, start dates, sprint, priority or labels. These stay with the developer.
- Reading a codebase, Git, GitHub or Bitbucket. The only inputs are the spec, the reference ticket, and what the developer answers.
- Writing or reviewing the spec itself (that is `writing-tech-specs`).
- Measuring PR size in lines: tickets are written before code exists.

## 4. Anti-goals

Things that would make it a failure even if it "works":

- Creating, editing or transitioning any Jira issue without an explicit yes for that specific action.
- Inventing content the spec does not contain (acceptance criteria, risks, scope). If a piece is missing, say so and ask.
- Presenting a split decision as a verdict instead of a proposal with evidence.
- Splitting a spec into stories only because it touches several repositories.
- Splitting into a "backend story" and a "frontend story" without a stated reason from section 6.
- Copying the spec into the ticket. The ticket is a summary; the detail lives in the spec.
- File-and-line checklists (`file.ts:123`) in development sub-tasks.
- Emojis in the generated tickets (Carlos's explicit rule), even if the reference ticket has them in its headings.

## 5. Inputs

The developer gives three things:

1. **The spec**, in any format: Confluence link (read through the Atlassian tools when connected), local file (markdown is the usual case), pasted text, PDF or other. No format restriction. If the skill cannot read the source, it says so and asks for another way.
2. **A reference ticket**: an existing story the team considers well written, with its sub-tasks (for AtomChat: ITV-878). The skill reads it only for labels: project key, story title prefix, section names, sub-task role prefixes and their issue types, sub-task title patterns, language. **The method always wins on structure and content** (Carlos's decision): sections 6 and 7 fix which tickets exist and what each one contains. If the reference lacks a piece (no certification sub-task, no out-of-scope section, older-generation file-and-line checklists), the skill still follows section 7 and uses its own default label for the missing piece, telling the developer. This is a temporary choice; Carlos is considering a better mechanism later (for example a saved team profile), so keep the convention-reading in one place that can be swapped.
3. **Dynamic data on request**: whatever the spec and reference ticket do not give and Jira creation needs, such as the epic. The skill asks for it explicitly; it never guesses.

**Reading the spec by meaning, not by heading.** Other teams name sections differently, so the skill looks for these pieces by their content:

| Piece | AtomChat heading | Feeds |
|---|---|---|
| Current problem and solution | ¿Qué vamos a construir? | Story |
| What is out of scope | Fuera de alcance | Story |
| Technical changes by area or repo | Cambios Técnicos | Development sub-tasks |
| Key decisions | Decisiones Claves | Code review "pay attention to" |
| Risks, dependencies, deploy order | Riesgos y Dependencias | Development notes, code review, split decision |
| How it is validated | Criterios de Aceptación | Story and certification |
| Pending items, blockers | Refinamiento / Pendientes | Split decision |

If a piece is missing, the skill names it and asks whether to derive it from the rest of the spec or wait for the developer.

## 6. Deciding the breakdown

### 6.1 One story or several

**Default: one spec gives one story.** This matches Carlos's team practice (in every case reviewed, each spec produced exactly one story; when the team wanted two stories, they wrote two specs).

The skill only raises a split when it finds reasons in the spec. It presents them as questions with evidence quoted from the spec, and the developer decides. Several repositories alone is not a reason.

| # | Question the skill asks | Signal in the spec | Source |
|---|---|---|---|
| 1 | Does each part give something useful on its own (to a user, another team, QA)? | Solution, acceptance criteria | INVEST "Valuable" (Wake 2003); Lawrence, step 1 |
| 2 | Can each part be tested separately, or does certification only make sense with everything? | Acceptance criteria grouped by layer vs mixed | Visual Paradigm, stories across teams |
| 3 | Do the parts have different blockers or rhythms (pending design, another team, another date)? | Pending items, dependencies | LeSS (feature vs component teams); DORA loosely coupled teams |
| 4 | Is there a mandatory deploy order, or a contract one part requires and another provides? | "deploy order", "precondition" | DORA loosely coupled teams |
| 5 | Does it fit one iteration, or should it be split by path/rule rather than by layer? | Pre-estimate (S/M/L), size of technical changes | SPIDR (Cohn); Lawrence patterns |
| 6 | If several splits are possible, which exposes what can be deferred or dropped, and which gives similar sizes? | Decisions, out of scope | Lawrence, step 3 |

Working rule of thumb from the discussion (a heuristic, not a gate): keep one story unless there is a reason to split (different blocker, rhythm or team, or too big for an iteration) **and** each part can be deployed and tested alone without leaving the system broken. A one-way dependency with a closed contract (backend first, front consumes later) is acceptable; mutual coupling (strict deploy order, one part breaks the system without the other) argues for one story.

The literature's default (Lawrence, Cohn) is that layer-only stories fail "Independent" and "Valuable". The skill states that when it proposes a layer split, and says which reason from the table justifies the exception.

Calibration cases from AtomChat (for tests, see section 9):

- Spec 42 was split into two specs and two stories (backend ITV-831, front ITV-835). Reason: the front was blocked by pending design rework, and the backend could ship first without changing behavior ("el modo Por defecto sigue funcionando igual").
- Spec C (ITV-813) touches three repos and stayed one story: strict deploy order acf, abf, agent-builder, and publish validation requires a field only the front can configure.
- Spec A (ITV-804) stayed one story: the front deploy is a precondition of the data script.

When stories are split, they are linked with "relates to" and each description names the other.

### 6.2 Sub-tasks inside a story

Splitting a story's work into sub-tasks by layer is compatible with vertical stories (Wake's SMART tasks; Scrum.org discussions). Sub-tasks by layer are expected.

**Always present:** one certification sub-task and one code review sub-task per story.

**Development sub-tasks:** at least one. A story may have only backend, only frontend, or one full-stack sub-task (AtomChat: ITV-809 backend only, ITV-835 front only, ITV-804 `[FULL]`).

**The unit is one PR.** One development sub-task is roughly one pull request (Carlos's definition). If a sub-task would need more than one PR, that is a signal to split it into "Parte N de M". Evidence:

- Google engineering practices, small CLs: a change should be self-contained, address one thing, include its tests, and leave the system working. Primary source.
- DORA, working in small batches: small batches correlate with better delivery performance. Primary source.
- Supporting, vendor sources (cite as support, not as rules): SmartBear/Cisco study (defect discovery drops past 200 to 400 lines reviewed at once); LinearB benchmarks (elite teams under about 105 changed lines per PR).

Since tickets are written before code, PR size cannot be measured. The skill estimates from spec signals (how many blocks, areas or files the technical-changes section lists for one sub-task) and turns that into a question, not a rule.

Signals to separate vs keep together (heuristics):

| Separate into another sub-task when | Keep together when |
|---|---|
| It is another role (backend, frontend, full) | The pieces require each other (versions, internal contract) |
| There is a mandatory order between blocks (migrate before delete) | They are verified as one unit (one full test and build run) |
| It would need more than one PR | Splitting would leave tasks that overlap or cannot be marked done alone |
| The spec already names separate blocks (A1/A2, Block A/B) | It is another repo but the same layer and owner |

AtomChat evidence: ITV-781 planned one backend sub-task ("todos entran en un mismo PR, porque se verifica como una sola unidad") and ended as two parts (ITV-840 LangChain cluster, "sus paquetes se exigen versión entre sí"; ITV-782 the rest). ITV-551 split by spec blocks (A migrate; B+C+D delete, clean, decommission) with an order rule ("cortar el consumidor antes que el servicio").

## 7. Ticket content by type

The model is AtomChat's newer generation of tickets (ITV-878 and ITV-883 with their sub-tasks), not the older one (ITV-813, ITV-831), which copied file-and-line checklists from the spec. The format (prefixes, section names, language) comes from the reference ticket; the content rules below are the method. No emojis.

### 7.1 Story

Basis: Jeffries' 3 Cs. The card holds just enough to identify and remind; detail lives in the conversation (here, the spec); confirmation is the acceptance tests.

- Title with the team's prefix (AtomChat: `HU | <name>`).
- What we will build: current problem, solution, and an "Out of scope" paragraph.
- Links: the spec.
- Sub-tasks: the list of sub-tasks with role prefix and title.
- Acceptance criteria: checkboxes, observable by a user or by QA, taken from the spec.
- A summary, not a copy of the spec.

### 7.2 Development sub-task

Basis: Google small CLs and CL descriptions (what plus why); Wake SMART (specific, measurable).

- Issue type and role prefix from the reference ticket (AtomChat: type "Development", `[BACKEND]`, `[FRONTEND]`, `[FULL]`).
- Title: what it builds, as a short statement (for example "Segunda barrera: validar que el agente exista y esté publicado al publicar el flujo"). Add "(Parte N de M)" when split.
- Links to the spec and the parent story.
- "What to do": behavior and decisions in prose, grouped by topic. No file-and-line lists.
- Notes: target branch, deploy order, dependencies, open questions for the tech lead, if the spec has them.
- The acceptance criteria that apply to this part.
- Verification: one or two manual checks a developer can run.

### 7.3 Certification sub-task

Basis: ISTQB test case components (preconditions, steps, observable expected result, traceability to the requirement).

- Type and prefix from the reference ticket (AtomChat: type "Sub-task", `[CERTIFICACIÓN] Pruebas Funcionales — HU <name>`).
- Parent story.
- Preparation: data and environment QA needs before starting.
- Table: `# | Criterion | Steps | Expected result | Result (Cumple / No cumple / No aplica)`.
- Every acceptance criterion of the story gives at least one row; no row without a criterion. Add negative cases (what must not happen) and edge cases from the spec's risks.

### 7.4 Code review sub-task

Basis: Google, what to look for in a code review (design and functionality first).

- Type and prefix from the reference ticket (AtomChat: type "Sub-task", `[REVISIÓN] Code Review — HU <name>`).
- Parent story.
- "Pay attention to": the spec's key decisions and risks the reviewer must check (for example "que `normalizeRecoveryConfig` quede completamente eliminado").
- One line per expected PR: `PR #[pendiente] — [repo] what changes`. One PR per development sub-task.

## 8. Flow and output

1. Read the spec and the reference ticket. Report anything unreadable or missing.
2. Propose the breakdown (6.1 and 6.2) with evidence and the questions the spec does not answer. Iterate with the developer.
3. Show the full draft on screen: every ticket with its content.
4. Ask for the dynamic data Jira needs (epic, and anything else missing).
5. After the developer approves the draft, create in Jira one ticket at a time, asking before each: the story first, then each sub-task under it. When there are two stories, also the "relates to" link.
6. Report what was created, with keys and links.

The developer can stop after step 3 and copy the draft.

## 9. Success criteria and tests

The skill works if, on Carlos's real specs:

- each ticket (story, development, certification, code review) carries the information that belongs to it per section 7;
- it makes a good decision on how many stories and sub-tasks to create, with reasons the developer can check.

Test per `AGENTS.md` and `superpowers:writing-skills`: baseline run without the skill (RED), write the skill (GREEN), close loopholes (REFACTOR). Runners do not see the expected result; a separate scorer agent grades each run against the criteria above.

Calibration specs (Confluence, space AD) and their hand-written tickets:

| Spec | Tickets | What it tests |
|---|---|---|
| HU-05 Validación previa a publicar nodo de agente | ITV-878 (+879 to 882) | One story, backend + frontend, newer-generation content |
| Trazabilidad del descarte de URLs | ITV-883 (+884 to 887) | One story, newer-generation content |
| 42 Recuperaciones personalizadas, Backend and Front | ITV-831, ITV-835 | Two stories linked; split reason is a blocker, not repos |
| Spec A, Colapso del funnel | ITV-804 | One story, one `[FULL]` sub-task, deploy precondition |
| Spec B, Fin de flujo en cierre por inactividad | ITV-809 | Backend only |
| Spec C, Tipo de conversación | ITV-813 | Three repos, one story, strict deploy order |

Older-generation tickets in this table are references for the breakdown decision, not for content.

**Test material is read live, read-only** (Carlos's decision). Runners and the scorer read the calibration specs and tickets from Confluence and Jira through the Atlassian tools during the run. Nothing is saved: no copies of specs or tickets in the repo or in fixtures, and no writes to Jira. Scenarios stop at the draft. The repo keeps only the scenario prompts, the links (page ids and issue keys) and the scoring criteria. Runs need the Atlassian connector authorized; without it the run is skipped and reported, not faked.

**Final eyeball check.** After the REFACTOR phase, run the skill once on spec 42 (Backend and Front) and show Carlos the full draft (stories and sub-tasks with their content) on screen, so he can judge the end result himself. Draft only; nothing is created in Jira.

## 10. Constraints (repo conventions)

- Layout: `skills/<name>/` (SKILL.md, `agents/openai.yaml`, `references/` as needed), docs in `docs/skills/<name>.md` + `.es.md`, tests in `tests/<name>/` with a `check-structure.sh`, a row in both READMEs.
- Manual only: `disable-model-invocation: true` in SKILL.md; `agents/openai.yaml` with `allow_implicit_invocation: false`.
- Skill files in English. Generated tickets in the language of the reference ticket (Spanish for AtomChat).
- Jira access through the Atlassian MCP tools when connected.

## 11. Left to the builder

- File layout inside `references/` (for example one file for the split heuristics with sources, one per ticket type).
- Exact wording of the questions the skill asks.
- How to read the reference ticket's sub-tasks (by key through the Atlassian tools, or pasted).
- What to do when the Atlassian tools are not connected: deliver the draft only and say creation needs the connector.

## 12. Calls made in this document (not explicitly decided by Carlos)

- The working name `spec-to-jira-stories`.
- One certification and one code review sub-task per story, covering all of its development sub-tasks.
- The project key comes from the reference ticket and the skill confirms it with the developer before creating.
- The story's sub-task list is written with titles in the draft; after the sub-tasks exist, the skill offers (with confirmation) to update the story with their keys.
- When the reference ticket has emojis in its headings, the skill drops them.

## 13. Sources

- Wake, *INVEST in Good Stories, and SMART Tasks* (2003): https://xp123.com/invest-in-good-stories-and-smart-tasks/
- Jeffries, *Card, Conversation, Confirmation* (2001): https://ronjeffries.com/xprog/articles/expcardconversationconfirmation/
- Lawrence, *The Humanizing Work Guide to Splitting User Stories*: https://www.humanizingwork.com/the-humanizing-work-guide-to-splitting-user-stories/
- Cohn, SPIDR: https://www.mountaingoatsoftware.com/blog/five-simple-but-powerful-ways-to-split-user-stories
- Cohn, five story-splitting mistakes: https://www.mountaingoatsoftware.com/blog/five-story-splitting-mistakes-and-how-to-stop-making-them
- DORA, loosely coupled teams: https://dora.dev/capabilities/loosely-coupled-teams/
- DORA, working in small batches: https://dora.dev/capabilities/working-in-small-batches/
- LeSS case study (InfoQ): https://less.works/case-studies/infoq-network-gateway-less
- Visual Paradigm, stories across teams: https://skills.visual-paradigm.com/?p=1771
- Google, small CLs: https://google.github.io/eng-practices/review/developer/small-cls.html
- Google, CL descriptions: https://google.github.io/eng-practices/review/developer/cl-descriptions.html
- Google, what to look for in a code review: https://google.github.io/eng-practices/review/reviewer/looking-for.html
- ISTQB test design (Foundation slides): https://www.ii.uib.no/%7Emagne/zinfh11-tekster/Kap4atestdesigntechniquesv2.04eng.pdf
- SmartBear, code review best practices (vendor): https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/
- LinearB benchmarks via LeadDev (vendor): https://leaddev.com/tech/workflow-metrics-make-elite-dev-teams

Not verified: the Scrum.org thread on splitting by API (page came back empty); Wake's "a few person-weeks" size figure (secondary source only).
