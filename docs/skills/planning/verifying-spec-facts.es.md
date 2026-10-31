# verifying-spec-facts

[English](verifying-spec-facts.md) | **Español**

Comprueba si los hechos que una revisión de spec marcó como viejos siguen siendo ciertos en el código de hoy. Si todos se mantienen, actualiza sus fechas en el brief; si alguno cambió, escribe un reporte y envía al desarrollador a un nuevo discovery. Fuente: [`skills/planning/verifying-spec-facts/`](../../../skills/planning/verifying-spec-facts/SKILL.md).

## Uso

En Claude Code: `/verifying-spec-facts`. En Codex: `$verifying-spec-facts`. Solo manual: nunca se carga con un prompt implícito.

```text
/verifying-spec-facts la carpeta es ~/.tech-specs/2026-09-01-mute-conversation/ y el código está en ./chat-app
```

- Entrada: la carpeta de la feature con `brief.md` y el reporte de revisión `review-<fecha>.md`, y el repositorio. Toma solo los hechos de `## Facts to re-verify` del reporte, cada uno con su fila en la sección `How it works today` del brief, corre el comando de re-verificación de la fila en solo lectura, lee el código y marca el hecho como se mantiene, cambió o no se puede verificar.
- Todos se mantienen: solo cambia la celda "Date and commit" de cada fila marcada, a la fecha de hoy y el commit actual. Sin reporte ni brief nuevo.
- Algún hecho cambió o no se puede verificar: escribe `~/.tech-specs/<feature>/verify-<AAAA-MM-DD>.md` con `## Facts that changed`, `## Decisions affected`, `## Next step`. El brief no se toca, ni siquiera las fechas de los hechos que se mantienen. Siguiente paso: `/discovering-tech-changes` para un brief nuevo y luego `/writing-tech-specs`.
- Sin reporte de revisión: lo pide y, si no existe, apunta a `/reviewing-tech-specs`. No hace la revisión de antigüedad por su cuenta.
- Es de solo lectura sobre los repositorios (git con `--no-optional-locks`) y solo escribe bajo `~/.tech-specs/`.

## Alcance

Dentro: volver a comprobar los hechos marcados. Fuera: decidir qué hechos son viejos (`/reviewing-tech-specs`), escribir briefs (`/discovering-tech-changes`), reescribir specs (`/writing-tech-specs`). Pruebas: [`tests/planning/verifying-spec-facts/`](../../../tests/planning/verifying-spec-facts/README.md).
