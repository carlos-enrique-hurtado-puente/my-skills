<!-- Test fixture file (reviewing-tech-specs scenarios). A made-up spec written to comply with P1-P9; used by old-facts, undated-facts and no-brief. -->
# Spec: mute a conversation for 24 hours

Ticket: https://tickets.example.test/CHAT-412
Size: M. One result that can be delivered and verified alone; reviewable in one sitting.

## What we are building
A user of the web app silences one conversation for 24 hours. For that time no notification of any kind reaches them for that conversation, and the conversation header shows the time left. Out of scope: muting on the mobile app, muting all conversations at once, quiet hours by time of day (another team's work).

## Terms
- **Mute**: today's "snooze" behavior, extended to last up to 24 hours.
- **Notification path**: any way the product tells a user about a new message in a conversation (the live message flow, the inbound webhook, the daily email digest).
- **Fixed / free**: fixed means the implementer must follow it and the reason is written; free is the implementer's call. Everything not marked fixed is free.

## Today's behavior and dependencies
- T1: A user can snooze a conversation for at most twelve hours.
- T2: While a snooze lasts, the live message flow does not notify the user about new messages in that conversation.
- T3: The inbound webhook notifies the user about new messages without looking at the snooze.
- T4: The daily email digest includes messages from snoozed conversations without looking at the snooze.
- T5: Another team's quiet-hours work, still in refinement, changes the same notification step. Its owner is Ana's team.
- Platform limits: none apply; this is web only. Design version: no design exists yet for the header; see D3.

## Decisions and open questions
| Item | Status | Who | When it is resolved |
|---|---|---|---|
| D1 Reuse snooze and raise its limit to 24 hours (fixed: a user has one concept of silencing, not two; depends on T1) | Decided | Dev | n.a. |
| D2 Check the mute in the single notification step, so the webhook and the digest respect it (fixed: no path may notify a muted conversation; depends on T3, T4) | Decided | Dev | n.a. |
| D3 Header text says "snoozed" or "muted" (free: the wording does not change behavior) | Proposed | Design | during implementation |
| Q1 Does quiet hours put its check in the same place as D2 (T5)? The answer only changes merge order, not behavior | Open | Ana's team | during implementation |
| Alternative discarded: a new mute feature beside snooze | Discarded | Dev | n.a. (creates a second concept for the same behavior) |

## Acceptance criteria
- AC-1: Given a conversation that is not muted, when the user chooses to mute it for 24 hours, then the conversation is muted and its header shows 24 hours left.
- AC-2: Given a muted conversation, when the user opens it, then the header shows the time left.
- AC-3: Given a muted conversation, when a new message arrives through the live message flow, then the user receives no notification.
- AC-4: Given a muted conversation, when a new message arrives through the inbound webhook, then the user receives no notification.
- AC-5: Given a muted conversation, when the daily digest is built, then it contains no message from that conversation.
- AC-6: Given a muted conversation, when the 24 hours end, then new messages notify the user again.
- AC-7: Given a muted conversation, when the user reloads the app, then the header still shows the correct time left.

Destination of every criterion: this delivery.

## Tasks
None.

## Verification plan
- No measurable requirement is declared, so there is no baseline or load to state.
- AC-1 to AC-5 are checked by an automated test and by hand in the web app. AC-6 cannot be provoked from the UI within a reasonable time, so it is checked by a test that moves the clock. AC-7 is checked by hand.
- No criterion needs a real channel, credential or live data. No criterion depends on a model's behavior.

## Cases
- A notification step fails while a conversation is muted: the message is not notified and the failure is recorded; the next message is handled normally.
- The user unmutes while a digest is being built: the digest decides at the moment it reads the conversation; either result is acceptable (free).
- The same webhook call is delivered twice: neither delivery notifies a muted conversation.
- The user restarts the app: AC-7 covers it.
- Malformed or zero duration: the request is rejected and the conversation state does not change.

## Contracts
No contract crosses components. The sibling quiet-hours spec is owned by Ana's team; this spec does not depend on its phases, and if both touch the notification step, merge order is agreed with that team during implementation (Q1).
