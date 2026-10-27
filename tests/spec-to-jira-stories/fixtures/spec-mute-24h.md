<!-- Test fixture file (spec-to-jira-stories scenarios). A made-up spec in the writing-tech-specs format. -->
# Spec: Mute a conversation for 24 hours

Ticket: CHAT-120. Brief: discovery brief of 2026-10-20 (commit `a1b2c3d`).

## What we are building
Users can silence one conversation for 24 hours on the web app. While it is silenced, no notification of any kind reaches them for it, and the header shows the time left. Today the same behavior exists as "snooze", capped at twelve hours, and the daily digest ignores it.

## Out of scope
- Muting on the mobile app (separate release).
- Quiet hours by time of day (another team's spec).

## Fixed and free
- Fixed: the snooze state is the one used for muting, because the live message path already respects it and two concepts would drift.
- Free: how the header renders the time left.

## Assumptions
| # | Assumption | Verified |
|---|---|---|
| A1 | Snooze is capped at twelve hours | 2026-10-20, `a1b2c3d` |
| A2 | The webhook and the digest job notify without checking snooze | 2026-10-20, `a1b2c3d` |
| A3 | The quiet hours spec changes the same dispatcher step; it is in refinement | 2026-10-20 |

## Acceptance criteria
- **AC-01** Given a conversation, when the user mutes it, then it stays muted for 24 hours and the header shows the time left.
- **AC-02** Given a muted conversation, when a new message arrives live, then no notification is sent.
- **AC-03** Given a muted conversation, when a message arrives through the inbound webhook, then no notification is sent.
- **AC-04** Given a muted conversation, when the daily digest runs, then the conversation is left out of the digest.
- **AC-05** Given a muted conversation, when 24 hours pass, then notifications resume without any action.
- **AC-06** Given saving the mute fails, when the user mutes, then the user sees an error and the conversation stays unmuted.
- **AC-07** Given the mobile app, when the user opens a muted conversation, then it shows as muted. Out of scope: the mobile release is separate; noted for that story.

## Deployment tasks
- **T-01** Add a composite index on conversations by owner and mute end time to the Firestore indexes file of the functions project, so the digest can skip muted conversations efficiently. Lives in the repo.
- **T-02** Configure a TTL policy in the Firestore console that removes expired mute records after 7 days. Lives in the console, not the repo. Evidence: a screenshot of the policy pasted in the ticket.
- **T-03** Run the backfill script that converts existing snoozes to the new end-time field, first with a dry run, then for real. Evidence: count before and after, pasted in the ticket.

## Decisions and open questions
| Item | Status | Who | When it is resolved |
|---|---|---|---|
| Reuse snooze instead of a new mute concept | Decided | Dev and LT | n.a. |
| Header says "Muted" instead of "Snoozed" | Proposed | Design | Before freeze |
| Snooze check placed in the dispatcher, shared with quiet hours | Proposed | Ana's team | Before freeze |
| Discarded: a separate mute feature | Discarded | LT | Reason: two concepts for one behavior |

## Delivery order
Backend and web deploy together. The index (T-01) is deployed before the code.

## Self-check
- P1 yes Fixed and free
- P2 yes What we are building, Out of scope
- P3 yes Assumptions A1 to A3
- P4 yes one sitting
- P5 yes AC-01 to AC-07, T-01 to T-03
- P6 yes AC-02 to AC-04
- P7 yes AC-05, AC-06
- P8 no -> two Proposed rows resolved before freeze (Design; Ana's team)
- P9 yes Delivery order

Blocking the freeze: the header wording (Design) and the shared dispatcher step (Ana's team).
