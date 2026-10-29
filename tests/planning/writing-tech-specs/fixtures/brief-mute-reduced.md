<!-- Test fixture file (writing-tech-specs scenarios). A made-up discovery brief, reduced depth. -->
# Discovery brief: mute a conversation for 24 hours (reduced)

## 0. Header
- Input: the requirement to mute a conversation for 24 hours, an FRD. Evidence: `docs/frd-mute-24h.md`
- Date: 2026-10-20. Branch `main`, commit `a1b2c3d`.
- Depth: reduced (the developer described it as "raise the snooze limit to a day").
- Validated: today (2026-10-20, "yes"), reuse (2026-10-20, "reuse snooze"), brief (2026-10-20, "ok").

## 1. In plain words
Users want to silence one conversation for a day. The product already lets a user "snooze" a conversation for up to twelve hours. The proposal is to raise that limit to a day and show the time left in the header.

## 4. How it works today
A user snoozes a conversation; new messages then skip the email while the snooze lasts.

| Fact | Where | Date and commit | How it is known | Re-verify |
|---|---|---|---|---|
| Snooze is capped at 720 minutes | `src/conversations/snooze.js` | 2026-10-20, `a1b2c3d` | observed | `git --no-optional-locks grep -n "MAX_SNOOZE_MINUTES" -- src/` |
| The header shows "Snoozed" without time left | `src/ui/conversation-header.js` | 2026-10-20, `a1b2c3d` | observed | `git --no-optional-locks grep -n "Snoozed" -- src/ui/` |

## 5. Reuse inventory and conventions
| Need | Existing | Reuse, adapt or create | Reason | Searched | Evidence |
|---|---|---|---|---|---|
| Silence a conversation for a time | Snooze | Adapt: raise the cap | Same behavior, other name | the words mute, silence, snooze | `snoozeConversation` |

## 8. Open questions
| Item | Owner | Moment | Evidence |
|---|---|---|---|
| Should the header say "snoozed" or "muted"? | Design | Before freeze | FRD says "mute"; the UI says "Snoozed" |
