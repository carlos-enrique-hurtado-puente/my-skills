# ITV-XXX: Conversation export and retention

Ticket: ITV-950. Size: M (about 20 h). Repos: `conversations-api` (Node), `web-app` (Angular).
Full spec: about 4,800 words, 31 criteria, 14 mechanism rows with paths and signatures. This is a summary of its parts.

## Part A: CSV export (backend)
Agents can export a conversation's messages to CSV. Endpoint, columns and limits are written out and decided by the LT. Criteria A-1 to A-9. No open questions.

## Part B: Automatic retention (backend)
Conversations older than N days are deleted automatically. Open questions, all before freeze:
- Value of N per plan (PM).
- Whether legal hold must block deletion (Legal, no date yet).
- Whether exports already generated are deleted too (PM).
Criteria B-1 to B-11, several depending on those answers. Needs a scheduled job and a new index.

## Part C: Export UI (frontend)
A button in the conversation view and a download panel in `web-app`. Uses the Part A endpoint. Design: final Figma, dated. Criteria C-1 to C-7.

## Part D: Performance
"Exports of up to 50,000 messages finish fast." Criteria D-1 to D-4, no numbers yet, no baseline.

## Dependencies
- C needs A deployed first.
- B touches the same `conversations` collection and the same delete path that A reads from.
- The PM wants the export (A + C) in this sprint; retention (B) is "when Legal answers".
