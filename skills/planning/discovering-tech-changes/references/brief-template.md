# The discovery brief

Written in the developer's language. Delivered where the developer says (chat, a file, or a Confluence page only on request); default: chat, offering a file. Short: a long document nobody reads is a failure.

## Sections

| # | Section | Content |
|---|---|---|
| 0 | Header | Input by title and kind, with an Evidence line for its path or link; date; branch and commit examined; depth (full or reduced); what the developer validated at each checkpoint and when |
| 1 | In plain words | The problem, the expected outcome, how it works today, the proposed solution. One page at most; no identifiers: anything the reader must find goes on an Evidence line |
| 2 | Corrections to the input | Table: input says / is / evidence |
| 3 | Goals and non-goals | From step 2 |
| 4 | How it works today | Flow in plain words, then evidence rows: fact / where / date and commit / how it is known / command to re-verify |
| 5 | Reuse inventory and conventions | Table: need / existing / reuse, adapt or create / reason / what was searched / evidence |
| 6 | Surroundings | Table: item / what it touches / state / owner / evidence. Covers other specs and work in progress, contracts, deploy order, platform limits, design version; what could not be searched |
| 7 | Options and recommendation | From step 6 |
| 8 | Open questions | Table: item / owner / moment / evidence |

A reduced-depth brief keeps sections 0, 1, 4, 5 and 8.

## How to fill each section

**Claims in plain words, identifiers only as evidence.** Outside the evidence rows of section 4, every section (corrections, reuse inventory, surroundings, options, open questions) states each item in plain words. Identifiers (file paths, function names, constants, error codes, naming patterns) go only in the Evidence column or in the evidence rows, never in the sentence that states the claim. This holds for what the input itself names too: the claim paraphrases it ("the flag name the requirement proposes"), and the exact quoted string goes only in Evidence.

Example, corrections table:

| Input says | Is | Evidence |
|---|---|---|
| Exports have no size limit | The system stops at ten thousand rows and cuts the file without a warning | Input: "export all records". Code: `MAX_EXPORT_ROWS = 10000` in `src/reports/export.js`; section 4, row 2 |
| A new switch to turn the feature on, set where it is used | The repo keeps every feature switch in one registry; the proposal adds one inline | Input: `enableBulkExport`. Convention: `config/flags.yaml` |

- **0 Header.** Name the input in plain words by its title and kind ("the requirement for X, an FRD"); its path or link goes on an Evidence line. Name the commit with `git --no-optional-locks rev-parse --short HEAD`. List each checkpoint and the developer's answer in one line.
- **1 In plain words.** Write it so the developer understands it without opening the code: what the user or the system sees, in everyday words. No identifiers here; if a sentence only makes sense with a file name or a constant in it, rewrite it and move the name to an Evidence line. Say when the asked behavior already exists under another name.
- **2 Corrections.** One row per claim of the input that the code, the design or the developer contradicts. "Says" and "is" are plain words; the Evidence column holds the identifiers and points to the section 4 row.
- **3 Goals and non-goals.** Non-goals are reasonable goals deliberately excluded, not negations.
- **4 How it works today.** Plain-words flow first, including every caller of the path and silent behavior. Then the evidence rows (below).
- **5 Reuse inventory.** One row per needed behavior; "existing" names what the code does in plain words, the Evidence column names where. "What was searched" gives plain concepts and words ("the words export, download, report; anything that writes files"); the exact search strings, function names and patterns go in Evidence; "not searched" is stated, never implied by an empty row. Conventions get their own rows (error codes, UI patterns, i18n), each with an example from the repo.
- **6 Surroundings.** One row per item: what it is and what it touches in plain words, its state (in flight, frozen, merged), its owner or "owner unknown", and in Evidence its link or path. Sources that could not be reached are listed with what was asked of the developer instead.
- **7 Options.** In plain words. Two or three, with reuse, creation, risks, what stays blocked; one recommended with the reason. Nothing here is decided.
- **8 Open questions.** Every gap: the question in plain words (identifiers and quoted input only in Evidence), an owner (a role or a person the developer names; "to assign" only if the developer does not know), and a moment: before freeze, during implementation, or out of scope. A proposal may sit beside a question, marked as a proposal. Evidence holds what the question rests on.

## Facts from code

Every code fact carries:
- **how it is known**: observed (read in code), inferred (concluded from what was read), or told (said by the developer);
- **date** examined and **commit**;
- **a command to re-verify** it on implementation day, read-only, for example `git --no-optional-locks grep -n "MAX_EXPORT_ROWS" -- src/`.

Inferred facts say what they were inferred from. Nothing is invented: a fact without a source is an open question.

## How `writing-tech-specs` consumes it

| Brief section | Spec use |
|---|---|
| 1 | "What we are building" (P2) |
| 2 | "Spec says / is" table (P2) |
| 4 | Assumptions with date and commit (P3) |
| 5 | Reasons beside each fixed mechanism (P1) |
| 6 | Contracts and sibling specs (P9), work in flight (P3) |
| 7 | Decisions as Proposed rows (P8) |
| 8 | Open questions table (P8) |
