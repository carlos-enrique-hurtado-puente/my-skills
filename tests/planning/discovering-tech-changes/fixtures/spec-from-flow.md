Published: not published yet
Copy date: 2026-10-20

<!-- Test fixture file (discovering-tech-changes scenarios). A made-up spec written by writing-tech-specs; its brief was lost. -->
# Spec: mute a conversation for 24 hours

## What we are building
A user can mute one conversation for 24 hours and stops receiving notifications for it. The conversation header shows the time left.

## Out of scope
Muting from the mobile app.

## Today's behavior and dependencies
- Today a user can snooze a conversation for up to 48 hours.
- While a conversation is snoozed, no notification of any kind is sent for it.

## Criteria
- CA-1: given a muted conversation, when a new message arrives within 24 hours, then no notification is sent.
- CA-2: given a muted conversation, when the user opens it, then the header shows the time left.

## Decisions and open questions
| Item | Status | Who | When it is resolved |
|---|---|---|---|
| Mute reuses snooze | Proposed | developer | before freeze |
