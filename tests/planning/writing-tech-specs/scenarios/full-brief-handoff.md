# Scenario: full-brief-handoff

## Setup
Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`. Copy `fixtures/brief-mute-full.md` to `<DIR>/home/.tech-specs/2026-10-20-mute-conversation/brief.md`. The runner works only inside `<DIR>`. There is no repository to read; the brief is the only source. The spec is written in the runner's answer; no files are required.

## Invocation
Escribe la spec técnica de este cambio a partir del discovery brief que ya validé, en la carpeta `~/.tech-specs/2026-10-20-mute-conversation/`.

## Pressure
Hazlo corto, solo lo esencial para que el tech lead lo congele el jueves.

## Expected
- [ ] The spec has an out-of-scope section (or equivalent) built from the brief's non-goals: mobile, mute all, quiet hours.
- [ ] Today's facts are written as behavior, without identifiers or dates.
- [ ] The spec does not reference the brief: it does not name it, cite it as its source or basis, link it, or send the reader to it (for commands or details). Facts written as behavior in the spec's today's-behavior section are not a reference to the brief. Text outside the spec (a chat preface or closing note) does not count.

## Purpose (scorer only)
The handoff from `discovering-tech-changes` into `writing-tech-specs`: the brief's non-goals must reach the spec, and its code facts reach it as behavior, without identifiers, dates or commits (those stay in the brief). The brief is only an input: the spec need not name it or copy its re-verify commands, which embed paths and identifiers.

## Results

### baseline — 2026-10-26 (skill as of `4c7c307`)
- Verdict: FAIL (3 of 4 bullets).
- Out of scope from the non-goals — PASS ("Fuera de alcance: app móvil (otro release), silenciar todas las conversaciones a la vez, y horas silenciosas")
- Assumptions keep date, commit and re-verify command — PASS (a "Cómo re-verificar" column with the brief's commands)
- Names the brief — PASS ("Base: discovery brief validado el 2026-10-20 (rama `main`, commit `a1b2c3d`)")
- Offers `/spec-to-jira-stories` as the next step — FAIL (never mentioned)
- Classification: **discriminating** on bullet 4 only.

### green-1 — 2026-10-26
- Verdict: PASS (4 of 4 bullets).
- Out of scope from the non-goals — PASS ("3. Fuera de alcance": mobile, mute all, quiet hours)
- Assumptions keep date, commit and re-verify command — PASS ("Supuestos (fecha 2026-10-20, commit `a1b2c3d`)"; A1 to A3 each with "Verificar con `git --no-optional-locks grep ...`")
- Names the brief — PASS ("Base: discovery brief validado el 2026-10-20 (rama `main`, commit `a1b2c3d`)")
- Offers `/spec-to-jira-stories` — PASS (after the self-check: "Cuando la spec esté congelada, puedes usar `/spec-to-jira-stories` ... No lo he ejecutado.")

### green-3 (handoff removed) — 2026-10-29
- Verdict: FAIL (2 of 3 bullets).
- Out-of-scope section from the non-goals — PASS ("## Out of scope": mobile app, "Muting all conversations at once", quiet hours)
- Assumptions keep date, commit and re-verify command — FAIL (header "Assumptions (dated 2026-10-20, commit `a1b2c3d`)" keeps date and commit, but A1 to A5 carry no re-verify command and the spec never says where the brief's commands are; only "Revalidate if implementation starts after about 2026-11-10")
- Names the brief — PASS ("Based on the discovery brief of 2026-10-20 (`main`, commit `a1b2c3d`)")
- No mention of spec-to-jira-stories — PASS (not named; no ticket skill offered)

### green-4 (handoff removed, second run) — 2026-10-29
- Verdict: FAIL (2 of 3 bullets)
- Out-of-scope section from the non-goals — PASS ("## 2. Out of scope": "Mobile app (separate release).", "Muting all conversations at once.", "Quiet hours by time of day")
- Assumptions keep date, commit and re-verify command — PASS ("## 4. Assumptions (verified 2026-10-20, commit `a1b2c3d` ...)"; A1 to A3 each "Re-verify: `git --no-optional-locks grep ...`", A4 "Re-verify: `docs/error-catalog.md`")
- Names the brief — FAIL (the spec body never says it was written from the discovery brief; the date and commit appear only as the Assumptions' verification stamp, and "validado el 2026-10-20" is only in the chat preface before the spec)
- No mention of spec-to-jira-stories — PASS (not named anywhere in the output)
- Note: a control run on the `main` version (with the offer) kept the re-verify commands too, so the green-3 miss on that bullet is run-to-run variance, not caused by removing the offer.

### Re-graded — 2026-10-30
- The "re-verify command" and "names the brief" bullets were removed: the brief is only an input to write the spec, and the spec does not reference it. Re-verify commands stay in the brief; date and commit are enough to revalidate.
- Against the two remaining bullets, green-3 and green-4 both PASS 2 of 2 on their recorded evidence above (out of scope from the non-goals; date and commit on the Assumptions). No new run.

### red-1 to red-3 (bullet "does not reference the brief" added, skill unchanged) — 2026-10-30
- red-1: PASS (3 of 3). No mention of the brief inside the spec; Q3 reads "Platform limits ... were not documented".
- red-2: FAIL (2 of 3). "Brief de origen: validado por el dev el 2026-10-20"; Q3 and Q4 "el brief no trae esa sección".
- red-3: FAIL (2 of 3). Q3 "platform limits (the brief has none ...)".
- Out of scope and dated assumptions passed in all three. Classification: **discriminating** on the new bullet; the missing-section rule pushed runners to write "the brief lacks X" inside the spec.

### green-5 to green-7 (rule "the brief is an input the spec never cites" in Before writing) — 2026-10-30
- green-5, green-6, green-7: PASS (3 of 3 each). The brief appears only in the note to the user before the spec; missing sections became topic questions ("Platform limits for a 24 h snooze: unknown"; "Límites de plataforma para la ventana de 24 h ...: desconocidos").
- Note: green-6 still put file paths beside its assumptions; no bullet here grades that.


### red-4 and green-4 (bullet "Today's facts are written as behavior" replaces dated Assumptions) - 2026-10-31
- red-4 (skill as of `74540b6`): FAIL (1 of 2 bullets run here). Out of scope PASS; "## 4. Supuestos (verificados 2026-10-20, commit `a1b2c3d` ...)" carries a date and commit.
- green-4: PASS (2 of 2). Out of scope lists mobile, mute all and quiet hours; "## 3. Comportamiento de hoy y dependencias" is pure behavior. The "does not reference the brief" bullet was not re-graded in this run.
- Classification: **discriminating** on the new bullet.

### re-run with `~/.tech-specs/` and the Expected bullet 3 reworded - 2026-10-31
- green A (skill before the "does not settle" sentence): FAIL (2 of 3). Out of scope PASS; today's facts as behavior PASS; "does not reference the brief" FAIL: the spec body said "Ticket: pendiente de enlazar (el brief no trae enlace; ...)". Blind scorer.
- green B (final skill): PASS (3 of 3), graded by me. Out of scope lists mobile, mute all and quiet hours; today's facts as behavior with no identifiers or dates; the word "brief" appears only in the preface to the user, and the missing ticket link is the spec's own line "Link del ticket de esta entrega".
- Note: this bullet fails in 1 of 2 runs after the folder change; variance, not caused by the new rule.
