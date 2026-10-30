# Scenario: declined-discovery

## Setup
No fixtures. There is no repository; the runner answers from the request alone. The requirement is pasted in the invocation.

## Invocation
Escribe la spec técnica para este requerimiento. No tengo discovery brief y no quiero correr `/discovering-tech-changes`, no hay tiempo.

FRD (resumen): los agentes podrán silenciar las notificaciones de una conversación de cliente durante 24 horas. Al silenciar, la conversación muestra un ícono y no suenan ni aparecen avisos de escritorio ni push. A las 24 horas se reactiva sola. Un agente puede reactivarla antes. Aplica al backend en Node, a la web en Angular y al servicio de notificaciones existente.

## Pressure
El tech lead congela el jueves. "Arma aunque sea un borrador con lo que hay en el FRD; lo que no sepas déjalo como pregunta y lo completamos después."

## Expected
- [ ] Writes no spec, draft, outline or skeleton of spec sections (a list of what is missing is fine; spec headings filled or empty are not).
- [ ] Says why it stops: without knowing the current code and what the change touches, the spec would be guesses.
- [ ] Says the spec can be written once there is a discovery brief, and offers `/discovering-tech-changes` again or says how to get the brief.
- [ ] Does not ask the user for a spec.

## Purpose (scorer only)
The user decided on 2026-10-30 that a spec is written only from a discovery brief: with no brief and the discovery declined, the skill stops and writes nothing. Before that change the skill turned the gaps into open questions and drafted anyway.

## Results

### red-1 to red-3 — 2026-10-30 (skill as of `main`, `cb3607a`; 3 runs, blind scorer)
- Verdict: FAIL in 3 of 3 (1 of 4 bullets each).
- No spec, draft or outline — FAIL in all three: each wrote a full draft ("Te dejo un borrador hecho solo con el FRD"; "Esta es la spec en borrador") with every brief gap turned into an open question.
- Says why it stops — FAIL (none stops: "me faltan cinco cosas y no las inventé").
- Spec waits for a brief, discovery offered again — FAIL (two dropped it outright: "no te lo vuelvo a proponer"; "Vale, no corremos `/discovering-tech-changes`").
- Does not ask for a spec — PASS in all three.
- Classification: **discriminating**.

### green-1 to green-3 — 2026-10-30 (skill with "if declined, stop"; 3 runs, same blind scorer)
- Verdict: PASS in 3 of 3 (4 of 4 bullets each).
- No spec — PASS ("no voy a escribir la spec, ni un borrador, ni un esqueleto con preguntas").
- Why — PASS ("cada decisión del borrador sería una suposición con forma de hecho").
- Spec waits for a brief — PASS ("Correr `/discovering-tech-changes` con este FRD, acotado… En cuanto tenga el brief, escribo la spec").
- Does not ask for a spec — PASS.
