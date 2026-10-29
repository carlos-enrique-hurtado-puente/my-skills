# HU-XX: Daily digest email for support agents

Ticket: [TBD]
Written: 2026-09-18. Implementation planned for early November.
Size: S (about 6 h)

## Context
Support agents want one email per day with the cases assigned to them that are still open. Today agents only see this in the web app.

## Agreed
- The digest goes out at 08:00 in the agent's timezone.
- Agents can opt out. (Pending validation with the PM.)
- The digest lists at most 20 cases, oldest first.

## Design
Use the `node-cron` library and put everything in a new file `src/jobs/digestWorker.ts`. The worker calls `mailer.send()` once per agent, synchronously, so we batch agents in groups of 50. Reserve log codes `DIG-120` and `DIG-121` for "digest built" and "digest failed".

The summary line for each case is written by the LLM. Example: "Customer cannot log in since Monday".

## Contract (already decided, copied from the Preferences spec)
`GET /agents/:id/digest-preferences` returns `{ "days": { "1": {"from": "08:00", "to": "18:00"}, ... "5": {...} }, "optOut": false }`. Keys are the strings "1" to "5".

## Acceptance criteria
- AC-1: Given an agent with open cases, when 08:00 arrives in their timezone, then they receive one email listing their open cases.
- AC-2: Given an agent who opted out, when 08:00 arrives, then no email is sent.
- AC-3: The digest shows at most 25 cases.
- AC-4: When the job runs, a row is written to the `digest_jobs` collection with `status = 'sent'` and `sentAt` set.
- AC-5: If the front does not prevent it (stale agent list or another path), the backend rejects a preference update that has `from` later than `to`.
- AC-6: The digest is generated quickly.
- AC-7: Run the backfill script `scripts/backfill-optout.ts` against production.
- AC-8: The LLM summary never includes the private internal notes of a case.
- AC-9: The email arrives in the agent's real inbox with the correct layout.
- AC-10: Pass QA review in the staging environment.

## Open questions
- Should agents with zero open cases receive an email? (PM)
- What text goes in the email footer?

## Risks
- The mailer module is being refactored in another PR and may stop being synchronous.
- If the digest is built twice (see AC-1), agents could get duplicates.
- Max cases in the digest: 20.

## Out of scope
- Weekly digests.
