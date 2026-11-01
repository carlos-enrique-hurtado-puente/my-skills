# Scenario: brief-from-folder

## Setup
Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Create `<DIR>/home/.specflow/2026-10-20-mute-conversation/` holding `brief.md` (a copy of `fixtures/brief-mute-full.md`) and `brief-superseded-2026-10-01.md` (a copy of `fixtures/brief-mute-superseded.md`, whose one changed fact is that the digest "notifies only the assigned agent"). The runner works only inside `<DIR>`. There is no repository to read. The spec is written in the runner's answer; no files are required.

## Invocation
Escribe la spec del cambio silenciar conversación.

## Pressure
Hazlo corto, solo lo esencial para que el tech lead lo congele el jueves.

## Expected
- [ ] Looks in `~/.specflow/` (or asks which feature folder) instead of asking for pasted text.
- [ ] Uses `brief.md`; no fact that appears only in the superseded brief reaches the spec.
- [ ] Does not ask the user for a spec.

## Purpose (scorer only)
Briefs now live in `~/.specflow/<date>-<slug>/brief.md`. The skill must find the brief there when the user names no file, and must never use `brief-superseded-*.md`. The planted fact ("notifies only the assigned agent") exists only in the superseded brief.

## Results

### red-1 to red-3 - 2026-10-31 (skill as of `9e9fe3f`; blind scorer)
- red-1: PASS (3 of 3). Found the folder by itself and used `brief.md` ("Ignoré el otro archivo... superseded").
- red-2: PASS (3 of 3). Same.
- red-3: FAIL (2 of 3). Found the folder but wrote no spec: "no voy a suponer cuál es el vigente. Dime cuál uso".
- The planted fact reached no reply. The skill did not know the folder; the runners found it anyway and ignored the superseded file by its name. Classification: weak discriminator (1 of 3 fail).

### green-1 to green-3 - 2026-10-31 (skill with the folder, superseded rule and hidden-folder note; blind scorer)
- PASS (3 of 3 each). Each used the single feature folder and `brief.md`, and did not read the superseded brief ("leí solo su brief.md"). The planted fact reached no spec; none asked for a spec.
- A first green run of the same scenario had one runner list the home directory without the hidden `.specflow` and say it was empty. The skill gained "`~/.specflow/` is a hidden folder: list it directly" and the three runs were redone; the three above are the redo.

### green-rename-1 (after rename to ~/.specflow) - 2026-11-01
- PASS (blind scorer, all Expected bullets): used ~/.specflow/2026-10-20-mute-conversation/brief.md only; superseded fact absent from the spec; no spec requested.
