# reviewing-tech-specs

[English](reviewing-tech-specs.md) | **Español**

Revisa una spec técnica escrita antes de congelarla: un repaso de sí/no sobre los nueve principios de [`writing-tech-specs`](writing-tech-specs.es.md) y una revisión de la edad de los hechos de su brief de discovery. Fuente: [`skills/planning/reviewing-tech-specs/`](../../../skills/planning/reviewing-tech-specs/SKILL.md).

## Uso

En Claude Code: `/reviewing-tech-specs`. En Codex: `$reviewing-tech-specs`. Solo manual: nunca se carga con un prompt implícito.

```text
/reviewing-tech-specs revisa ./spec-mute.md; su brief está en ~/.specflow/2026-09-01-mute-conversation/
```

- La revisión lee la spec que indicas. Si no nombras ninguna y la carpeta de la feature tiene `spec.md`, usa esa copia y dice su origen y su fecha (la spec publicada pudo cambiar desde entonces); nunca escribe `spec.md`.
- La revisión lee la spec completa y el `brief.md` de la carpeta de la feature (nunca un `brief-superseded-*`). No lee código ni reescribe la spec.
- Checklist: una línea `P1` a `P9`, `yes`, `no` o `n.a.`; cada `no` cita la spec y da el arreglo. No inventa defectos en lo que cumple.
- Revisión de edad: cada fila de la sección "How it works today" del brief con más de 21 días, o sin fecha, se lista como hecho a re-verificar, con las decisiones de la spec que dependen de él. Un commit solo no da edad. Sin brief, la revisión dice que no puede comprobar la edad y apunta a `/discovering-tech-changes`.
- El veredicto nunca dice "puede congelarse" sin más mientras los hechos estén viejos o no haya brief: congelar depende de hechos vigentes (sin brief, el siguiente paso es `/discovering-tech-changes`).
- Informe: se guarda en `~/.specflow/<feature>/review-<YYYY-MM-DD>.md` (un segundo informe el mismo día es `review-<YYYY-MM-DD>-2.md`, luego `-3`...; nunca se sobrescribe) con `## Verdict`, `## Checklist`, `## Facts to re-verify`, `## Next step`. El siguiente paso es `/verifying-spec-facts` si hay hechos por re-verificar, `/writing-tech-specs` con el informe si algún punto es `no`, y ambos en ese orden si pasan las dos cosas. Sin carpeta de la feature, el informe queda en la respuesta y no se escribe archivo.

## Qué contiene el skill

| Archivo | Contenido |
|---|---|
| `SKILL.md` | Términos, las nueve reglas, cómo revisar, el checklist, el informe |
| `references/*.md` | Los mismos cuatro archivos de referencia de `writing-tech-specs` (idénticos byte a byte) |

Las reglas, el checklist y las referencias se copian de `writing-tech-specs`; `tests/planning/reviewing-tech-specs/test-rules-sync.sh` falla si se desalinean.

## Alcance

Dentro: juzgar el texto de una spec y la edad de los hechos en que se apoya. Fuera: reescribir la spec (`/writing-tech-specs`), comprobar hechos contra el código (`/verifying-spec-facts`) y el proceso de QA.
