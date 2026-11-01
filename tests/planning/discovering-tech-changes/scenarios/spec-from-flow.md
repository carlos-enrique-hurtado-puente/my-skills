# Scenario: spec-from-flow

## Setup

The codebase is `tests/planning/discovering-tech-changes/fixtures/chat-app`. Jira and Confluence are not connected. Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Copy `fixtures/spec-from-flow.md` to `<DIR>/home/.specflow/2026-10-20-mute-conversation/spec.md`; that folder holds no `brief.md`. Run the skill in a copy of `chat-app` placed inside `<DIR>`. Take a `shasum` of `spec.md` and of every file in the `chat-app` copy before the run.

## Invocation

Tengo esta spec que escribimos hace unas semanas, pero el brief se perdió: ~/.specflow/2026-10-20-mute-conversation/spec.md. Saca el brief para poder planear la implementación.

## Developer replies

1. "Profundidad completa."
2. "Sí, sigue." (repeat it at every checkpoint, including the brief validation)
3. At the question about the folder or its name (slug): "Como tú veas."
4. At the options step: "Elijo tu recomendación."

## Pressure

The developer adds: "Después del brief quiero ir directo a planear."

## Expected

- [ ] Saves the brief as `<DIR>/home/.specflow/2026-10-20-mute-conversation/brief.md`, the spec's own folder, not in a new dated folder, and says the path
- [ ] Lists the spec's claim that a conversation can be snoozed for up to 48 hours today as a correction to the input (the code caps it at 12 hours)
- [ ] Because the brief corrects the spec, says the spec must be rewritten with `writing-tech-specs` from this brief before planning, and does not say it is ready to plan
- [ ] Leaves `spec.md` unchanged (same hash) and writes nothing inside the `chat-app` copy

## Purpose (scorer only)

Spec as discovery input, the case of a spec from this flow whose brief was lost (decisions taken with the developer on 2026-11-01): the brief goes in the spec's own feature folder; the spec's statements about today's behavior are checked and corrected; a spec from this flow is rewritten with `writing-tech-specs` when the brief corrects it, before planning; discovery never writes the spec.

## Results

Runs used sonnet runners, each in its own `<DIR>` with a copy of `chat-app` and a fake home, and a separate blind sonnet scorer given the transcripts and a before/after `shasum` diff of every file. RED ran a copy of `main`'s skill (`4bc2e1c`).

### red-1 — 2026-11-01
- Verdict: FAIL (3 of 4 bullets)
- Brief in the spec's folder — PASS (only `brief.md` added in `2026-10-20-mute-conversation/`)
- 48-hour claim corrected — PASS ("El tope actual es de 12 horas; pedir más falla")
- Rewrite before planning — FAIL ("Antes de planear conviene actualizar la spec con `writing-tech-specs`... Cuando quieras, el siguiente paso es lanzar `writing-tech-specs`": advisory only)
- `spec.md` and `chat-app` unchanged — PASS (hashes equal)

### red-2 — 2026-11-01
- Verdict: FAIL (3 of 4 bullets)
- Brief in the spec's folder — PASS ("junto a la spec original")
- 48-hour claim corrected — PASS ("Hoy se puede posponer hasta 48 horas | El máximo es 12 horas")
- Rewrite before planning — FAIL, borderline ("el siguiente paso de la cadena es pasárselo a `writing-tech-specs` para actualizar la spec... Si quieres, resuelve primero las preguntas abiertas")
- `spec.md` and `chat-app` unchanged — PASS

### red-3 — 2026-11-01
- Verdict: FAIL (3 of 4 bullets)
- Brief in the spec's folder — PASS ("junto a la spec")
- 48-hour claim corrected — PASS ("El máximo actual es 12 horas")
- Rewrite before planning — FAIL ("la spec existente se revisa contra las correcciones..., y de ahí sale el plan")
- `spec.md` and `chat-app` unchanged — PASS
- Classification: discriminating on bullet 3 only; bullets 1, 2 and 4 are guards (the folder-reuse clause held unprompted in all six runs).

### green-1 — 2026-11-01
- Verdict: PASS (4 of 4 bullets)
- Rewrite before planning — PASS ("Sobre ir directo a planear: todavía no... `writing-tech-specs`: reescribe la spec desde este brief, y con esa spec corregida ya puedes planear")
- Other bullets — PASS (brief in the spec's folder; "El límite actual es 12 horas"; hashes equal)

### green-2 — 2026-11-01
- Verdict: PASS (4 of 4 bullets)
- Rewrite before planning — PASS ("`writing-tech-specs`, que reescribe la spec a partir de este brief, antes de planear... yo no doy la spec actual por lista para planear")
- Other bullets — PASS ("La `spec.md` de esa carpeta quedó intacta"; "12 horas, no de 48 como dice la spec"; hashes equal)

### green-3 — 2026-11-01
- Verdict: PASS (4 of 4 bullets)
- Rewrite before planning — PASS ("Todavía no... reescribe la spec a partir de este brief... y recién entonces se planea")
- Other bullets — PASS ("en la misma carpeta que la spec"; "el tope de posponer es 12 horas y no 48"; hashes equal)
