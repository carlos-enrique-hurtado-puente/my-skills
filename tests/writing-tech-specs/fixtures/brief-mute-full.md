<!-- Test fixture file (writing-tech-specs scenarios). A made-up discovery brief, full depth. -->
# Discovery brief: mute a conversation for 24 hours

## 0. Header
- Input: the requirement to mute a conversation for 24 hours, an FRD. Evidence: `docs/frd-mute-24h.md`
- Date: 2026-10-20. Branch `main`, commit `a1b2c3d`.
- Depth: full.
- Validated: intake (2026-10-20, "yes"), framing (2026-10-20, "yes, mobile stays out"), today (2026-10-20, corrected the digest caller), reuse (2026-10-20, "reuse snooze"), surroundings (2026-10-20, "quiet hours is Ana's team"), options (2026-10-20, "option B"), brief (2026-10-20, "ok").

## 1. In plain words
Users want to silence one conversation for a day. Today the product already lets a user "snooze" a conversation, but only for up to twelve hours, and only the live message path respects it: the daily email digest still notifies snoozed conversations. The proposal is to raise the snooze limit to a day, show the remaining time in the header, and make every notification path respect it.

## 2. Corrections to the input
| Input says | Is | Evidence |
|---|---|---|
| A new mute feature | The same behavior exists as "snooze", capped at twelve hours | `MAX_SNOOZE_MINUTES = 720` in `src/conversations/snooze.js` |
| A new error for a failed save | The repo names errors by area and number; there is already one for an invalid snooze | `CHAT-CONV-002` in `src/shared/error-codes.js` |

## 3. Goals and non-goals
- Goals: a user silences one conversation for 24 hours on the web app; no notification of any kind reaches them for it during that time; the header shows the time left.
- Non-goals: muting on the mobile app (separate release); muting all conversations at once; quiet hours by time of day (another team's work).
- Success: no notification for a muted conversation in the 24 hours, checked on the three notification paths.

## 4. How it works today
A user snoozes a conversation; new messages then skip the email while the snooze lasts. Three things send notifications: the live message handler (checks snooze), the inbound webhook (does not check), and the daily digest job, which batches messages and sends them without checking.

| Fact | Where | Date and commit | How it is known | Re-verify |
|---|---|---|---|---|
| Snooze is capped at 720 minutes | `src/conversations/snooze.js` | 2026-10-20, `a1b2c3d` | observed | `git --no-optional-locks grep -n "MAX_SNOOZE_MINUTES" -- src/` |
| The webhook dispatches without a snooze check | `src/webhooks/inbound.js` | 2026-10-20, `a1b2c3d` | observed | `git --no-optional-locks grep -n "isSnoozed" -- src/webhooks/` |
| The digest job batches and dispatches without a snooze check | `src/jobs/daily-digest.js`, `src/notifications/batch.js` | 2026-10-20, `a1b2c3d` | observed | `git --no-optional-locks grep -n "isSnoozed" -- src/jobs/ src/notifications/` |

## 5. Reuse inventory and conventions
| Need | Existing | Reuse, adapt or create | Reason | Searched | Evidence |
|---|---|---|---|---|---|
| Silence a conversation for a time | Snooze | Adapt: raise the cap | Same behavior, other name | the words mute, silence, snooze, notification | `snoozeConversation` |
| Error on failed save | Area-and-number error codes | Follow the convention | Repo convention | error codes catalog | `docs/error-catalog.md` |

## 6. Surroundings
| Item | What it touches | State | Owner | Evidence |
|---|---|---|---|---|
| Quiet hours spec | The notification dispatcher, same function | In refinement | Ana's team | `docs/specs/in-flight/quiet-hours.md` |

## 7. Options and recommendation
- A: new mute feature beside snooze. Creates a second concept. Not recommended.
- B (recommended, chosen by the developer at the checkpoint): adapt snooze to 24 hours and add the check on the two missing paths, in the dispatcher.
- Keep as is: not meaningful; the digest leak is a bug today.

## 8. Open questions
| Item | Owner | Moment | Evidence |
|---|---|---|---|
| Should the header say "snoozed" or "muted"? | Design | Before freeze | FRD says "mute"; the UI says "Snoozed" |
| Does quiet hours put its check in the same place in the dispatcher? | Ana's team | Before freeze | `src/notifications/dispatcher.js` |
