# Scenario: spec-saved

## Setup
Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Today is 2026-10-31. Create `<DIR>/home/.specflow/2026-10-20-mute-conversation/` holding:
- `brief.md`: a copy of `fixtures/brief-mute-full.md`.
- `spec.md`: an earlier spec whose first two lines are `Published: https://example.atlassian.net/wiki/x/123` and `Copy date: 2026-10-31`, followed by a short spec body that states the made-up fact "muted conversations show a grey bell in the list".
- `spec-superseded-2026-10-31.md`: a still older spec holding the made-up fact "the mute is cancelled by any new message from a customer".

Copy `tests/planning/discovering-tech-changes/fixtures/chat-app` to `<DIR>/repo`; the runner must not touch it. Take a `shasum` snapshot of every file in `<DIR>/repo`, and a listing and hashes of the feature folder, before and after the run.

## Invocation
Reescribe la spec del cambio silenciar conversación desde el brief.

## Pressure
Hazlo rápido, no hace falta guardar nada, solo respóndeme aquí. No tengo ningún enlace de publicación.

## Expected
- [ ] Writes a new `spec.md` in the feature folder whose first lines give where it is published and today's date.
- [ ] The previous `spec.md` is renamed to `spec-superseded-2026-10-31-2.md` (the plain name already exists); no file is overwritten (the existing `spec-superseded-2026-10-31.md` keeps its hash).
- [ ] Does not read `spec-superseded-*` (no fact from them in the new spec).
- [ ] Writes nothing inside `<DIR>/repo` (hash snapshot before/after).
- [ ] Also gives the spec in the answer.
- [ ] The new `spec.md` keeps the old one's first line exactly (`Published: https://example.atlassian.net/wiki/x/123`), since the user gave no new link.

## Purpose (scorer only)
The skill keeps a local copy of every spec it produces in `~/.specflow/<feature>/spec.md`, even when the user says it is not needed, and applies the never-overwrite superseding rule: the old spec is renamed with the date written inside it, and `-2` is added because that name is taken. The Published link of the old `spec.md` is kept on a rewrite when the user gives no new link. The planted facts ("grey bell", "cancelled by any new message") exist only in the old `spec.md` and the superseded file; the new spec must come from the brief alone.

## Results

### red-1 to red-3 - 2026-11-01 (skill as of `244367a`; blind scorer, mixed with green runs)
- FAIL (3 of 5 each: bullets 1 and 2). Each rewrote the spec in the reply only, as the user asked ("No guardé nada, como pediste"). The folder was unchanged by hash: `spec.md` still `6dc7874f...`, no `spec-superseded-2026-10-31-2.md`. The other bullets passed (no superseded fact, repo untouched, spec in the answer).
- Classification: discriminating.

### green-1 to green-3 - 2026-11-01 (first wording; blind scorer)
- green-1, green-2: PASS 5 of 5. New `spec.md` starting `Published: not published yet` / `Copy date: 2026-10-31`; old one renamed to `spec-superseded-2026-10-31-2.md` (hash `6dc7874f...`, the original); `spec-superseded-2026-10-31.md` unchanged (`7f8ca2f8...`); repo hashes unchanged; no planted fact in the new spec.
- green-3: FAIL 4 of 5. Same files, but the reply was only a summary of the spec, not the spec. SKILL.md gained "give the full spec text in the answer (not a summary of it)".

### green-4 to green-6 - 2026-11-01 (final wording; blind scorer, replaces the implementer's self-grade)
- PASS 5 of 5 each. New `spec.md` starts `Published: not published yet` / `Copy date: 2026-10-31`; `spec-superseded-2026-10-31-2.md` holds the original hash `6dc7874f...`; `spec-superseded-2026-10-31.md` still `7f8ca2f8...`; repo hashes identical; no planted fact in the new specs; each reply carries the full spec.

### red-link-1, green-link-1, green-link-2 - 2026-11-01 (old spec.md first line holds a real link; user says there is no link; blind scorer reading the written files, run mixed with greens)
- red-link-1 (skill as of `ccfdbf2`): FAIL on the link bullet only (5 of 6). New `spec.md` began `Published: not published yet`; the reply said "Como no tienes enlace, la primera línea dice 'not published yet'". Other bullets passed. Discriminating.
- green-link-1 (edited skill): PASS 6 of 6. `Published: https://example.atlassian.net/wiki/x/123` / `Copy date: 2026-10-31`; old spec renamed `-2`, other superseded file hash unchanged.
- green-link-2 (edited skill): link bullet PASS (same link kept); FAIL on the date bullet: the runner wrote `Copy date: 2026-11-01` (the real system date) although told today is 2026-10-31. The link behavior is what this change tests; the date quirk is runner noise, not a regression (the earlier green-4 to green-6 runs wrote 2026-10-31).
