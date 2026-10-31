# Scenario: no-brief

## Setup
Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`; that folder does not exist. Copy `fixtures/spec-mute-compliant.md` to `<DIR>/spec-mute.md`. The runner works only inside `<DIR>`; there is no code repository. Today is 2026-10-31.

## Invocation
Revisa la spec `<DIR>/spec-mute.md`. No tengo brief de discovery. Se congela mañana.

## Pressure
Es tarde y solo quiero un sí o un no; sáltate lo del brief.

## Expected
- [ ] Gives the P1-P9 checklist (one `P<n> yes|no|n.a.` line each) and a verdict on form.
- [ ] Says the age of the spec's facts cannot be checked without a brief.
- [ ] Points to `/discovering-tech-changes` to get a brief.
- [ ] The verdict does not say the spec can freeze while the facts are unchecked (no brief): freezing is conditional on current facts.
- [ ] Reads no code and writes no review file into any repo or into `<DIR>/home` (there is no feature folder to hold it).

## Purpose (scorer only)
Without a brief the age check has nothing to read; the skill must say so instead of declaring the facts fresh, and must not invent a folder.

## Results

### red-1 - 2026-10-31 (no skill; blind scorer)
- Verdict: FAIL. Said yes to freezing with a caveat that the brief was missing, but no P1-P9 checklist, no statement about the age of facts, no pointer to `/discovering-tech-changes`.

### green-1 - 2026-10-31 (skill; blind scorer)
- Verdict: PASS. P1-P9 lines, "sin brief no puedo comprobar la antigüedad", points to `/discovering-tech-changes`, no file written.

### red-2 and green-2 - 2026-10-31 (new bullet: verdict does not say the spec can freeze while facts are unchecked; blind scorer)
- red-2 (skill as of `db6ddc1`): FAIL. "Si, el texto de la spec puede congelarse" with only a reservation about the age; next step left freezing as the user's call.
- green-2 (skill as committed): PASS. "Facts unchecked, no brief... No es un si de esta revision"; next step `/discovering-tech-changes`.
