<!-- Test fixture file (writing-tech-specs scenarios). A made-up review report in the format of the review skill. -->
# Review: mute a conversation for 24 hours

## Verdict
Not ready to freeze. 3 items fail: two on P5 and one on P8.

## Checklist
| Item | Answer | Evidence |
|---|---|---|
| P1 | yes | Each fixed mechanism has its reason in "Decisions" |
| P2 | yes | Terms defined; fixed and free marked |
| P3 | yes | "Today's behavior and dependencies" has no identifiers or dates |
| P4 | yes | Reviewable in one sitting |
| P5 | no | AC-2 ("the header shows the time left") and AC-3 ("no notification reaches the user") have no "when": nothing says at which moment or after which action each is true |
| P6 | yes | Evidence line on every measurable |
| P7 | yes | The four case questions are walked |
| P8 | no | Decision D2 ("header says snoozed or muted") has status Proposed but no owner and no moment of resolution |
| P9 | n.a. | No contract crosses components |

## Facts to re-verify

## Next step
Rewrite the spec from the same brief to fix P5 (AC-2, AC-3) and P8 (D2), then review again.
