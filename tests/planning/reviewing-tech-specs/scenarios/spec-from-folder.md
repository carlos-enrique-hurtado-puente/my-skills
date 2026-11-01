# Scenario: spec-from-folder

## Setup
Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Create `<DIR>/home/.specflow/2026-10-20-mute-conversation/` with `brief.md` (a copy of `fixtures/brief-mute-old.md` with every section 4 date changed to 2026-10-25, so the dates are current) and `spec.md` (a copy of `fixtures/spec-mute-compliant.md` with two lines inserted at the very top: `Published: https://confluence.example.test/wiki/spaces/CHAT/pages/412/mute-conversation` and `Copy date: 2026-10-28`). No other spec file exists anywhere. The runner works only inside `<DIR>`; there is no code repository. Today is 2026-10-31.

## Invocation
Revisa la spec del cambio silenciar conversación antes del freeze.

## Pressure
Tengo prisa y no tengo el texto de la spec a la mano; lo que haya en la carpeta del cambio es lo que hay.

## Expected
- [ ] Reviews `spec.md` from the folder without asking for the spec text.
- [ ] States the spec's source as the link itself (`https://confluence.example.test/wiki/spaces/CHAT/pages/412/mute-conversation`, in the saved report) and its copy date (2026-10-28), and that the published version may have changed since.
- [ ] Saves `review-2026-10-31.md` in the folder with the four headings `## Verdict`, `## Checklist`, `## Facts to re-verify`, `## Next step` in that order.

## Purpose (scorer only)
The feature folder now holds a local `spec.md`. A review with no spec named should use it, and say where it came from and how old the copy is, instead of asking the tech lead to paste the spec.

## Results

### red-1 to red-3 (skill as of `62e9b3a`; blind scorer, files read) - 2026-11-01
- C-1 and C-3 PASS in 3 of 3 (the runners listed the folder and found `spec.md`). C-2 FAIL in 3 of 3 under the strict reading (the link itself in the saved report): C1 wrote "Confluence ... CHAT-412", C2 "CHAT/412", C3 "the Confluence page named in its header". All gave the copy date and the caveat.

### green-1 to green-3 (edited skill; blind scorer, files read) - 2026-11-01
- PASS in 3 of 3, all bullets: each report contains the full URL, copy date 2026-10-28, the caveat that the published version may have changed, and the four headings in order.
