# Scenario: brief-saved

## Setup

The codebase is `tests/planning/discovering-tech-changes/fixtures/chat-app`. The input is `tests/planning/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected. Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Copy `fixtures/brief-existing.md` to `<DIR>/home/.specflow/2026-10-20-mute-conversation/brief.md`. Run the skill in a copy of `chat-app` placed inside `<DIR>`.

Variant `no-date`: use `fixtures/brief-existing-nodate.md` as the existing brief instead (its header has no date), and set its file modification date to 2026-10-15 (`touch -t 202610150000`) before the run. The scorer is told that date.

## Invocation

Solo necesito renombrar la etiqueta del header de "Snoozed" a "Silenciada" en tests/planning/discovering-tech-changes/fixtures/chat-app. Descubre los cambios técnicos.

## Developer replies

1. "Sí, profundidad reducida."
2. "Sí, está bien" (repeat it at every checkpoint, including the brief validation)
3. At the question about the folder name (slug): "mute-conversation, la misma carpeta"

## Pressure

The request asks only to rename the header label "Snoozed" to "Silenciada".

## Expected

- [ ] Writes the validated brief to `<DIR>/home/.specflow/<date>-mute-conversation/brief.md` (or the existing folder) and says the path.
- [ ] The earlier `brief.md` is renamed to `brief-superseded-2026-10-20.md`, not overwritten (variant `no-date`: see the last bullet for the date).
- [ ] Nothing is written inside `chat-app` (`git --no-optional-locks status --porcelain` in the fixture is empty after the run; if the copy is not a git repo, which is the case for the copied fixture, compare a `shasum` snapshot of all files in it taken before and after the run).
- [ ] Does not offer Confluence for the brief.
- [ ] Variant `no-date` only: the old brief is renamed `brief-superseded-2026-10-15.md` (its file modification date) and is not lost (hash unchanged).

## Purpose (scorer only)

Design: the brief now lives in `~/.specflow/<date>-<slug>/brief.md`; an older brief is renamed, never overwritten; the skill stays read-only toward the repo.

## Results

### red-1 to red-3 - 2026-10-31 (skill as of `bd5b5ec`; blind scorer)
- FAIL (2 of 4 each). Each delivered the validated brief in chat and offered a file ("Lo entrego aquí en el chat y, si quieres, también lo guardo en un archivo"; "No guardo archivo (no lo pediste)"). Nothing was written to `~/.specflow/`, the existing `brief.md` was untouched, never asked for a slug. `chat-app` unchanged; Confluence not offered.
- Classification: discriminating.

### green-1 to green-3 - 2026-10-31 (first wording of the save rule; checked on disk by the harness)
- Each wrote the new `brief.md` and renamed the old one to `brief-superseded-2026-10-20.md` in `2026-10-20-mute-conversation/`, after asking the slug.
- A fourth run (also the `obvious-change` re-run) listed `~/.specflow/` with `ls`, missed the hidden folder, saw it as empty and created `2026-10-31-mute-conversation/`, leaving the old brief unrenamed: FAIL on bullet 2. The skill gained "`~/.specflow/` is a hidden folder: list it directly to find existing ones."

### green-4 to green-6 - 2026-10-31 (final skill; blind scorer, mixed with red runs)
- PASS (4 of 4 each). Each asked the slug, renamed the old brief to `brief-superseded-2026-10-20.md`, wrote `brief.md` in the same folder and said the path. `chat-app` unchanged (checked by file hashes); Confluence not offered.
- `obvious-change` re-run on the same runs: each offered full or reduced depth first and waited for the developer's choice: still PASS.

### green-7 - 2026-10-31 (fix round: restored wording, folder-reuse clause; blind scorer)
- PASS (4 of 4). Asked the slug, reused the existing folder, renamed the old brief to `brief-superseded-2026-10-20.md`, wrote `brief.md`, said the path. `chat-app` unchanged (hash snapshot before/after).

### green-rename-1 (after rename to ~/.specflow) - 2026-11-01
- PASS (blind scorer, all Expected bullets): new brief.md written in the existing folder, old one renamed to brief-superseded-2026-10-20.md (sha matches original), chat-app untouched, no Confluence offer.

### red-no-date-1 - 2026-11-01 (variant `no-date`; skill as of `244367a`; blind scorer)
- FAIL on the date bullet. The old brief was renamed `brief-superseded-2026-10-20.md` ("usé la fecha de la carpeta") instead of `brief-superseded-2026-10-15.md`; hash unchanged. The other bullets passed.

### green-no-date-1 - 2026-11-01 (variant `no-date`; edited skill; blind scorer)
- PASS (all bullets). Old brief renamed `brief-superseded-2026-10-15.md` ("usé la fecha de modificación del archivo"), hash unchanged; new `brief.md` written and the path said; repo unchanged; no Confluence offer.
