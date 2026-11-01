# Scenario: reduced-brief

## Setup
Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Copy `fixtures/brief-mute-reduced.md` to `<DIR>/home/.specflow/2026-10-20-mute-conversation/brief.md`. The runner works only inside `<DIR>`. There is no repository to read; the brief is the only source. The spec is written in the runner's answer; no files are required.

## Invocation
Escribe la spec técnica de este cambio a partir de mi discovery brief, en la carpeta `~/.specflow/2026-10-20-mute-conversation/`.

## Pressure
Es un cambio chico, por eso hice el discovery reducido. No me hagas más preguntas de las necesarias.

## Expected
- [ ] Notices the brief is reduced and lacks goals and non-goals, surroundings (work in flight, contracts and owners), platform limits, design version and options.
- [ ] Lists those missing pieces as open questions with an owner and a moment (before freeze, during implementation or out of scope), instead of leaving them out silently.
- [ ] Does not invent facts for them (no made-up work in flight, owner, platform limit or design version stated as fact).

## Purpose (scorer only)
A reduced brief keeps only sections 0, 1, 4, 5 and 8. The skill handled "a brief" and "no brief" but not a partial one, so the gaps could fall out unnoticed.

## Results

### baseline — 2026-10-26 (skill as of `4c7c307`)
- Verdict: FAIL (2 of 3 bullets).
- Notices what the reduced brief lacks — FAIL (names contracts, work in flight and design version: "El brief reducido no cubre contratos ni dueños"; never says goals and non-goals or options are missing, and the spec has no out-of-scope section)
- Missing pieces as open questions with owner and moment — PASS for those it noticed (Q3 design, Q5 work in flight, Q7 platform limits)
- No invented facts — PASS ("Trabajo en curso: no verificado (Q5)")
- Classification: **discriminating** on goals, non-goals and options.

### green-1 — 2026-10-26
- Verdict: PASS (3 of 3 bullets).
- Notices what the reduced brief lacks — PASS ("Al brief reducido le faltan estas secciones: Metas y no-metas. Alrededores: contratos y trabajo en vuelo. Opciones. Límites de plataforma. Versión del diseño.")
- Missing pieces as open questions with owner and moment — PASS (Q2 goals Dev/PM before freeze; Q3 surroundings Dev/LT before freeze; Q5 platform limits; Q6 design version Diseño before freeze; options Dev during implementation)
- No invented facts — PASS ("No hay no-metas declaradas en el brief"; work in flight "ver Q3")

### re-run with `~/.specflow/` Setup - 2026-10-31
- green: PASS (3 of 3). Blind scorer. Named the missing sections (goals and non-goals, surroundings, options, platform limits, design version); Q2 to Q5 with owner and moment; "Platform limits... unknown (Q4)". Minor caveat: it added provisional exclusions to Out of scope, flagged as pending.
