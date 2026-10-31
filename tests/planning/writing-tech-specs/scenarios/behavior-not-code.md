# Scenario: behavior-not-code

## Setup
Copy `fixtures/brief-mute-full.md` into a scratch directory `<DIR>` (outside this repo). The runner works only inside `<DIR>`. There is no repository to read; the brief is the only source. The spec is written in the runner's answer; no files are required.

## Invocation
Escribe la spec técnica desde mi discovery brief: `<DIR>/brief-mute-full.md`.

## Pressure
Pon los nombres de funciones y archivos del brief en la spec, así el dev no tiene que buscarlos.

## Expected
- [ ] The spec has a section about today's behavior and dependencies, and no section called Assumptions.
- [ ] The spec contains no file path, function, constant, key or commit from the brief (grep the output for each identifier in the brief's section 4 evidence rows).
- [ ] The spec contains no verification date or commit for today's facts.
- [ ] Each decision that rests on a fact about today names that fact in plain words.
- [ ] It answers the pressure: says identifiers stay in the brief and why (the spec must survive a change of implementation).

## Purpose (scorer only)
The spec keeps the "what" (behavior); the brief keeps the "how" (identifiers, dates, commits). Under pressure to copy identifiers into the spec, the skill must hold the line and explain why.

## Results

### red-1 to red-3 (skill as of `74540b6`) - 2026-10-31
- Blind scorer, bullets 1-5. All three FAIL (bullets 1, 2, 3 and 5 each).
- red-1: "## 7. Assumptions" with `MAX_SNOOZE_MINUTES`, `src/webhooks/inbound.js`, `CHAT-CONV-002`; "verificadas el 2026-10-20, rama main, commit a1b2c3d"; names kept "as location hints".
- red-2: "## 4. Supuestos" with the same identifiers, date and commit.
- red-3: "## Assumptions" table with a "Suggested location (non-binding)" column holding paths and function names; "Code verified: 2026-10-20, commit `a1b2c3d`".
- Classification: **discriminating** (FAIL 3 of 3; the old P3 asks for dated code assumptions).

### green-1 to green-3 (P3 rewritten: today's behavior and dependencies) - 2026-10-31
- Blind scorer. All three PASS (5 of 5).
- Sections "Today's behavior and dependencies" / "Comportamiento de hoy y dependencias"; no identifier, date or commit in the spec body.
- Pressure answered in the note to the user: "los archivos, funciones, constantes y códigos de error envejecen rápido... fijan el mecanismo sin razón"; "Those data stay in the brief".
