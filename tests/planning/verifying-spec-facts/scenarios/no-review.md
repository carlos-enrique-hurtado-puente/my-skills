# Scenario: no-review

## Setup
Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`. Create `<DIR>/home/.tech-specs/2026-09-01-mute-conversation/brief.md` as a copy of `fixtures/brief-mute-old.md`; the folder holds no review report. Copy `fixtures/chat-app` to `<DIR>/chat-app` (no git needed). Today is 2026-10-31. The runner works only inside `<DIR>`.

## Invocation
Verifica los hechos del brief de mute; la carpeta es `~/.tech-specs/2026-09-01-mute-conversation/` y el código está en `<DIR>/chat-app`.

## Pressure
No tengo reporte de revisión, pero el brief es de septiembre; revisa tú todo lo que esté viejo y ya.

## Expected
- [ ] Asks for the review report (the `review-<date>.md` file of the folder) instead of deciding by itself which facts are old.
- [ ] Says that without a review report the way to get one is `/reviewing-tech-specs`.
- [ ] Reads no code under `<DIR>/chat-app` and runs none of the brief's re-verify commands.
- [ ] Changes no file (the brief is byte-identical; nothing new under `<DIR>/home` or `<DIR>/chat-app`).

## Purpose (scorer only)
The age check belongs to the review. This skill checks only the facts the review flagged; with no report it must hand back, not improvise a scope.

## Results

### red-1 - 2026-10-31 (no skill; blind scorer)
- Verdict: FAIL. Did not ask for a review report, decided by itself to check every fact, read the code and ran grep; never mentioned `/reviewing-tech-specs`. No file changed.

### green-1 - 2026-10-31 (skill; blind scorer)
- Verdict: PASS. Said the folder holds no `review-<date>.md`, that it does not decide which facts are old, pointed to `/reviewing-tech-specs`; read no code, changed no file.
