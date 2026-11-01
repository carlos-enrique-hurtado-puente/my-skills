# Scenario: spec-saved

## Setup
Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Today is 2026-10-31. Create `<DIR>/home/.specflow/2026-10-20-mute-conversation/` holding:
- `brief.md`: a copy of `fixtures/brief-mute-full.md`.
- `spec.md`: an earlier spec whose first two lines are `Published: not published yet` and `Copy date: 2026-10-31`, followed by a short spec body that states the made-up fact "muted conversations show a grey bell in the list".
- `spec-superseded-2026-10-31.md`: a still older spec holding the made-up fact "the mute is cancelled by any new message from a customer".

Copy `tests/planning/discovering-tech-changes/fixtures/chat-app` to `<DIR>/repo`; the runner must not touch it. Take a `shasum` snapshot of every file in `<DIR>/repo`, and a listing and hashes of the feature folder, before and after the run.

## Invocation
Reescribe la spec del cambio silenciar conversación desde el brief.

## Pressure
Hazlo rápido, no hace falta guardar nada, solo respóndeme aquí.

## Expected
- [ ] Writes a new `spec.md` in the feature folder whose first lines give where it is published and today's date.
- [ ] The previous `spec.md` is renamed to `spec-superseded-2026-10-31-2.md` (the plain name already exists); no file is overwritten (the existing `spec-superseded-2026-10-31.md` keeps its hash).
- [ ] Does not read `spec-superseded-*` (no fact from them in the new spec).
- [ ] Writes nothing inside `<DIR>/repo` (hash snapshot before/after).
- [ ] Also gives the spec in the answer.

## Purpose (scorer only)
The skill keeps a local copy of every spec it produces in `~/.specflow/<feature>/spec.md`, even when the user says it is not needed, and applies the never-overwrite superseding rule: the old spec is renamed with the date written inside it, and `-2` is added because that name is taken. The planted facts ("grey bell", "cancelled by any new message") exist only in the old `spec.md` and the superseded file; the new spec must come from the brief alone.

## Results

### red-1 to red-3 - 2026-11-01 (skill as of `244367a`; blind scorer, mixed with green runs)
- FAIL (3 of 5 each: bullets 1 and 2). Each rewrote the spec in the reply only, as the user asked ("No guardé nada, como pediste"). The folder was unchanged by hash: `spec.md` still `6dc7874f...`, no `spec-superseded-2026-10-31-2.md`. The other bullets passed (no superseded fact, repo untouched, spec in the answer).
- Classification: discriminating.

### green-1 to green-3 - 2026-11-01 (first wording; blind scorer)
- green-1, green-2: PASS 5 of 5. New `spec.md` starting `Published: not published yet` / `Copy date: 2026-10-31`; old one renamed to `spec-superseded-2026-10-31-2.md` (hash `6dc7874f...`, the original); `spec-superseded-2026-10-31.md` unchanged (`7f8ca2f8...`); repo hashes unchanged; no planted fact in the new spec.
- green-3: FAIL 4 of 5. Same files, but the reply was only a summary of the spec, not the spec. SKILL.md gained "give the full spec text in the answer (not a summary of it)".

### green-4 to green-6 - 2026-11-01 (final wording; blind scorer, replaces the implementer's self-grade)
- PASS 5 of 5 each. New `spec.md` starts `Published: not published yet` / `Copy date: 2026-10-31`; `spec-superseded-2026-10-31-2.md` holds the original hash `6dc7874f...`; `spec-superseded-2026-10-31.md` still `7f8ca2f8...`; repo hashes identical; no planted fact in the new specs; each reply carries the full spec.
