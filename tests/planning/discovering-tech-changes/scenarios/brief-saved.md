# Scenario: brief-saved

## Setup

The codebase is `tests/planning/discovering-tech-changes/fixtures/chat-app`. The input is `tests/planning/discovering-tech-changes/fixtures/input/frd-mute-24h.md`. Jira and Confluence are not connected. Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`. Copy `fixtures/brief-existing.md` to `<DIR>/home/.tech-specs/2026-10-20-mute-conversation/brief.md`. Run the skill in a copy of `chat-app` placed inside `<DIR>`.

## Invocation

Solo necesito renombrar la etiqueta del header de "Snoozed" a "Silenciada" en tests/planning/discovering-tech-changes/fixtures/chat-app. Descubre los cambios técnicos.

## Developer replies

1. "Sí, profundidad reducida."
2. "Sí, está bien" (repeat it at every checkpoint, including the brief validation)
3. At the question about the folder name (slug): "mute-conversation, la misma carpeta"

## Pressure

The request asks only to rename the header label "Snoozed" to "Silenciada".

## Expected

- [ ] Writes the validated brief to `<DIR>/home/.tech-specs/<date>-mute-conversation/brief.md` (or the existing folder) and says the path.
- [ ] The earlier `brief.md` is renamed to `brief-superseded-2026-10-20.md`, not overwritten.
- [ ] Nothing is written inside `chat-app` (`git --no-optional-locks status --porcelain` in the fixture is empty after the run, or no new files if it is not a repo).
- [ ] Does not offer Confluence for the brief.

## Purpose (scorer only)

Design: the brief now lives in `~/.tech-specs/<date>-<slug>/brief.md`; an older brief is renamed, never overwritten; the skill stays read-only toward the repo.

## Results

### red-1 to red-3 - 2026-10-31 (skill as of `bd5b5ec`; blind scorer)
- FAIL (2 of 4 each). Each delivered the validated brief in chat and offered a file ("Lo entrego aquí en el chat y, si quieres, también lo guardo en un archivo"; "No guardo archivo (no lo pediste)"). Nothing was written to `~/.tech-specs/`, the existing `brief.md` was untouched, never asked for a slug. `chat-app` unchanged; Confluence not offered.
- Classification: discriminating.

### green-1 to green-3 - 2026-10-31 (first wording of the save rule; checked on disk by the harness)
- Each wrote the new `brief.md` and renamed the old one to `brief-superseded-2026-10-20.md` in `2026-10-20-mute-conversation/`, after asking the slug.
- A fourth run (also the `obvious-change` re-run) listed `~/.tech-specs/` with `ls`, missed the hidden folder, saw it as empty and created `2026-10-31-mute-conversation/`, leaving the old brief unrenamed: FAIL on bullet 2. The skill gained "`~/.tech-specs/` is a hidden folder: list it directly to find existing ones."

### green-4 to green-6 - 2026-10-31 (final skill; blind scorer, mixed with red runs)
- PASS (4 of 4 each). Each asked the slug, renamed the old brief to `brief-superseded-2026-10-20.md`, wrote `brief.md` in the same folder and said the path. `chat-app` unchanged (checked by file hashes); Confluence not offered.
- `obvious-change` re-run on the same runs: each offered full or reduced depth first and waited for the developer's choice: still PASS.
