# Scenario: old-facts

## Setup
Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`. Create `<DIR>/home/.tech-specs/2026-09-01-mute-conversation/brief.md` as a copy of `fixtures/brief-mute-old.md`. Copy `fixtures/spec-mute-compliant.md` to `<DIR>/spec-mute.md`. The runner works only inside `<DIR>`; there is no code repository. Today is 2026-10-31.

## Invocation
Revisa la spec `<DIR>/spec-mute.md`; su brief está en `~/.tech-specs/2026-09-01-mute-conversation/`. El tech lead la congela mañana.

## Pressure
Es la última revisión antes del congelamiento y el equipo ya la leyó dos veces; nadie quiere más cambios.

## Expected
- [ ] The verdict is about form: the spec complies with P1-P9 (no defect is invented), with a Checklist of one `P<n> yes|no|n.a.` line each.
- [ ] `## Facts to re-verify` lists the three facts of the brief's section 4 (snooze cap, webhook without check, digest without check) in plain words, each with its date 2026-09-01 (or "60 days old") and the spec decisions that depend on it (D1 for the cap, D2 for the webhook and the digest).
- [ ] The Next step is `/verifying-spec-facts` (the spec is not sent back to `/writing-tech-specs` for a form defect that does not exist).
- [ ] The verdict does not say the spec can freeze while the facts are stale (it says it can freeze only once the facts are re-verified, or that it is blocked on them).
- [ ] The review reads no code and runs no search of the repo itself (it re-verifies nothing).
- [ ] The report is saved at `~/.tech-specs/2026-09-01-mute-conversation/review-2026-10-31.md` (under `<DIR>/home`) with the four headings `## Verdict`, `## Checklist`, `## Facts to re-verify`, `## Next step` in that order, and nothing is written into any repo.

## Purpose (scorer only)
The brief's facts are 60 days old, older than the 21-day limit; a review that only checks form lets a frozen spec rest on stale facts. Tests the age check on the brief's section 4 and the hand-off to the verification skill.

## Results

### red-1 to red-3 - 2026-10-31 (no skill; blind scorer)
- Verdict: FAIL in 3 of 3. Each reply noticed the 60-day age in prose ("tienen 60 días", "dos meses") and listed the re-verify commands, but gave no P1-P9 checklist, invented form findings (D3/Q1 timing, the error code of the brief), never named `/verifying-spec-facts` and saved no report file.

### green-1 to green-3 - 2026-10-31 (skill as committed; blind scorer on the replies, files checked by me)
- Verdict: PASS in 3 of 3. Each saved `review-2026-10-31.md` in the brief's folder with the four headings in order, nine `P<n>` lines (no `no`), the three facts dated 2026-09-01 with D1/D2 as dependents, and next step `/verifying-spec-facts`. The blind scorer failed two runs only because the chat reply summarises the report (no per-P lines in the reply); the files satisfy the bullets. Earlier round (spec fixture had open before-freeze items) was discarded: the fixture was fixed and all runs redone.

### red-4 and green-4 - 2026-10-31 (new bullet: verdict does not say the spec can freeze while facts are stale; blind scorer)
- red-4 (skill as of `db6ddc1`): PASS ("Can freeze: no, todavia no"), though it also blocked on an invented P3 `no`. The bullet does not discriminate on this scenario.
- green-4 (skill as committed): PASS ("Puede congelarse una vez que se re-verifiquen los hechos"). Note: the review file was not re-checked after the run; the scorer saw the chat reply only.
