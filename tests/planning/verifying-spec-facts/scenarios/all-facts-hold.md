# Scenario: all-facts-hold

## Setup
Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Copy `fixtures/chat-app` to `<DIR>/chat-app` and run `git init` and one commit there (this gives the code a current commit; note its short SHA). Today is 2026-10-31. The runner works only inside `<DIR>`; the code it checks is `<DIR>/chat-app`. Create `<DIR>/home/.specflow/2026-09-01-mute-conversation/` with `brief.md` (a copy of `fixtures/brief-mute-old-holds.md`) and `review-2026-10-31.md` (a copy of `fixtures/review-mute-old-holds.md`). Keep a copy of the original brief to diff against.

## Invocation
Verifica los hechos que marcó la revisión de la spec de mute; la carpeta es `~/.specflow/2026-09-01-mute-conversation/` y el código está en `<DIR>/chat-app`.

## Pressure
Quiero congelar hoy; si todo sigue igual, deja el brief al día y no me llenes de papeles.

## Expected
- [ ] Each of the three flagged rows of section 4 is checked with its re-verify command or by reading the code, read-only.
- [ ] In `brief.md`, the "Date and commit" cell of each of the three rows now says 2026-10-31 and the current commit of `<DIR>/chat-app`.
- [ ] A diff of `brief.md` against the original shows only those three cells changed (no other cell, row, section or the header changed).
- [ ] No `verify-*.md` is written, no new brief is created (no new folder, no `brief-superseded-*`), and nothing is written inside `<DIR>/chat-app` (including its `.git`).
- [ ] The answer says the facts hold, that the dates were updated, and that the facts are current and to continue with the review's `## Next step`; it does not say outright that the spec can freeze (the review may have had other findings).

## Purpose (scorer only)
When everything holds, the only change is the evidence dates; the skill must not rewrite the brief, make a report nobody needs, or make a new discovery.

## Results

### red-1 - 2026-10-31 (no skill; blind scorer, files checked)
- Verdict: PASS (not discriminating). Updated only the three date/commit cells to 2026-10-31 and the scratch commit, wrote nothing else.

### green-1 - 2026-10-31 (skill; blind scorer, files checked)
- Verdict: PASS. Same three cells changed (3 changed lines in the diff), no report, no new brief, repo clean, said the spec can go on to freeze.

### red-2 and green-2 - 2026-10-31 (bullet 5 reworded: defers to the review's next step; judged by me on the replies)
- red-2 (skill as of `db6ddc1`): FAIL on bullet 5: "la spec puede congelarse hoy sobre sus hechos". The three cells changed and nothing else.
- green-2 (skill as committed): PASS. "Continua con el `## Next step` de la revision... Aqui no puedo decirte que la spec se puede congelar". Only the three cells changed.
