<!-- Test fixture file (verifying-spec-facts scenarios). A made-up review report for fixtures/brief-mute-old-holds.md. -->
# Review: mute a conversation for 24 hours (2026-10-31)

## Verdict
Can freeze on form: yes. No checklist item is `no`. The facts the spec rests on are older than 21 days, so they must be re-verified before the freeze.

## Checklist
- P1 yes
- P2 yes
- P3 yes
- P4 yes
- P5 yes
- P6 yes
- P7 yes
- P8 yes
- P9 yes

## Facts to re-verify
- Snoozing is capped at twelve hours. Dated 2026-09-01. Spec decision that depends on it: D1 (reuse snooze and raise its limit to 24 hours).
- The inbound webhook notifies without looking at the snooze. Dated 2026-09-01. Spec decision that depends on it: D2 (check the mute in the single notification step).
- The daily digest notifies without looking at the snooze. Dated 2026-09-01. Spec decision that depends on it: D2.

## Next step
`/verifying-spec-facts`.
