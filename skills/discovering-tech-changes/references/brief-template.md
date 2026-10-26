# The discovery brief

Written in the developer's language. Delivered where the developer says (chat, a file, or a Confluence page only on request); default: chat, offering a file. Short: a long document nobody reads is a failure.

## Sections

| # | Section | Content |
|---|---|---|
| 0 | Header | Input and its link; date; branch and commit examined; depth (full or reduced); what the developer validated at each checkpoint and when |
| 1 | In plain words | The problem, the expected outcome, how it works today, the proposed solution. One page at most; no identifiers unless the reader must find something |
| 2 | Corrections to the input | Table: input says / is / evidence |
| 3 | Goals and non-goals | From step 2 |
| 4 | How it works today | Flow in plain words, then evidence rows: fact / where / date and commit / how it is known / command to re-verify |
| 5 | Reuse inventory and conventions | Table: need / existing / reuse, adapt or create / reason / what was searched |
| 6 | Surroundings | Other specs and work in progress (state, owner), contracts and their state, deploy order, platform limits, design version; what could not be searched |
| 7 | Options and recommendation | From step 6 |
| 8 | Open questions | Table: item / owner / moment |

A reduced-depth brief keeps sections 0, 1, 4, 5 and 8.

## How to fill each section

- **0 Header.** Name the commit with `git --no-optional-locks rev-parse --short HEAD`. List each checkpoint and the developer's answer in one line.
- **1 In plain words.** Write it so the developer understands it without opening the code: what the user or the system sees, in everyday words. If a sentence only makes sense with a file name or a constant in it, rewrite it. Say when the asked behavior already exists under another name.
- **2 Corrections.** One row per claim of the input that the code, the design or the developer contradicts. "Is" cites its evidence row.
- **3 Goals and non-goals.** Non-goals are reasonable goals deliberately excluded, not negations.
- **4 How it works today.** Plain-words flow first, including every caller of the path and silent behavior. Then the evidence rows (below).
- **5 Reuse inventory.** One row per needed behavior. "What was searched" lists terms and paths; "not searched" is stated, never implied by an empty row. Conventions get their own rows (error codes, UI patterns, i18n), each with an example from the repo.
- **6 Surroundings.** One row per item: what it is, what it touches, its state (in flight, frozen, merged), its owner or "owner unknown". Sources that could not be reached are listed with what was asked of the developer instead.
- **7 Options.** Two or three, with reuse, creation, risks, what stays blocked; one recommended with the reason. Nothing here is decided.
- **8 Open questions.** Every gap: an item, an owner (a role or a person the developer names; "to assign" only if the developer does not know), and a moment: before freeze, during implementation, or out of scope. A proposal may sit beside a question, marked as a proposal.

## Facts from code

Every code fact carries:
- **how it is known**: observed (read in code), inferred (concluded from what was read), or told (said by the developer);
- **date** examined and **commit**;
- **a command to re-verify** it on implementation day, read-only, for example `git --no-optional-locks grep -n "RETRY_LIMIT" -- src/`.

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
