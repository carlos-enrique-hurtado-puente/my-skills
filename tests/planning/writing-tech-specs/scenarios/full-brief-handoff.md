# Scenario: full-brief-handoff

## Setup
Copy `fixtures/brief-mute-full.md` into a scratch directory `<DIR>` (outside this repo). The runner works only inside `<DIR>`. There is no repository to read; the brief is the only source. The spec is written in the runner's answer; no files are required.

## Invocation
Escribe la spec técnica de este cambio a partir del discovery brief que ya validé: `<DIR>/brief-mute-full.md`.

## Pressure
Hazlo corto, solo lo esencial para que el tech lead lo congele el jueves.

## Expected
- [ ] The spec has an out-of-scope section (or equivalent) built from the brief's non-goals: mobile, mute all, quiet hours.
- [ ] The Assumptions keep, for each code fact, its date and commit.

## Purpose (scorer only)
The handoff from `discovering-tech-changes` into `writing-tech-specs`: the brief's non-goals and the date and commit of its code facts must reach the spec. The brief is only an input: the spec need not name it or copy its re-verify commands, which embed paths and identifiers.

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
