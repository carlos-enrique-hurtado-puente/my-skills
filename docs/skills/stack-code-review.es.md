# stack-code-review

[English](stack-code-review.md) | **Español**

> La versión principal es la [inglesa](stack-code-review.md); este archivo es una traducción.

Code review de cambios de cualquier stack, desde la URL de un PR de GitHub o desde la rama local actual contra su base. Código: [`skills/stack-code-review/`](../../skills/stack-code-review/SKILL.md).

## Uso

En Claude Code: `/stack-code-review`. En Codex: `$stack-code-review`.

Con una URL de PR se revisa ese PR; sin argumentos se revisa la rama local actual contra su base (el modo local se detiene primero para pedir una confirmación). El modo GitHub requiere `gh` instalado y autenticado.

```text
/stack-code-review https://github.com/org/repo/pull/123
/stack-code-review
/stack-code-review base: main
/stack-code-review spec: ./docs/ruta.md
/stack-code-review https://github.com/org/repo/pull/123 spec: https://miempresa.atlassian.net/browse/PROJ-456
```

- `base:` (solo modo local) indica la rama base y omite la detección automática.
- `spec:` acepta una ruta local, una URL (por ejemplo un ticket de Jira) o texto pegado.

## Ejecutarla en un subagente

Puedes pedirle a la sesión que delegue la review ("manda un agente a revisar esta rama con /stack-code-review"). La sesión que delega sigue [`references/subagent-dispatch.md`](../../skills/stack-code-review/references/subagent-dispatch.md):

- Lanza un agente general-purpose nuevo (nunca un fork) con una plantilla de prompt fija.
- **Modelo:** el que nombres; si no, y la sesión escribió los cambios revisados, un modelo distinto que no sea ligero (revisor independiente); si no, el de la sesión. Pedir "barato" o "rápido" nunca elige un modelo ligero.
- **Respuesta:** primero el mensaje del subagente sin cambios, luego `---` y una línea con el modelo que revisó. La confirmación y las preguntas por la spec se reenvían igual, y tu respuesta vuelve al mismo subagente.

## Conectores

Leer la spec desde una URL depende de los MCP/herramientas configurados en cada herramienta. Claude Code y Codex se configuran por separado, así que un conector disponible en una no lo está necesariamente en la otra. Si no hay forma de leer la URL, la skill pide la spec en markdown.

## Cómo funcionan los stacks

La skill detecta los stacks del diff con `scripts/detect-stacks.sh` y carga solo las piezas (`stacks/<id>.md`) que son dueñas de algún archivo cambiado. Cada pieza aporta su checklist solo sobre los archivos que posee; el formato del reporte, la escala de severidad y el veredicto son siempre los del núcleo.

### Añadir un stack

Crea `skills/stack-code-review/stacks/<id>.md`. No hay que cambiar nada más: el script descubre las piezas por sí solo.

```markdown
---
id: express
name: Express
detect:
  dependencies: [express]        # decide qué archivos son de la pieza
  files: ["**/routes/*.js"]      # opcional: solo desempata o cubre archivos fuera de toda raíz
  imports: [express]             # opcional: igual que files
skills: [mi-skill-de-express]    # skills que la pieza consulta (puede ser [])
context_fields: [Versión de Express, Framework de tests]
---

## Context detection
## Checklist
## How to use the skills
## Clean Architecture in this stack
## Severity notes
## Common mistakes
```

Cómo se decide la propiedad: `dependencies` determina qué archivos pertenecen a la pieza (las raíces son los directorios cuyo `package.json` declara la dependencia); `files` e `imports` solo desempatan cuando varias piezas comparten raíz o cubren archivos fuera de toda raíz. El `id` debe ser igual al nombre del archivo (`stacks/<id>.md`) y cumplir `^[a-z0-9][a-z0-9-]*$`; si no, el script ignora la pieza (`skipped_piece: ... id-mismatch | bad-id | duplicate-id`).

Las seis secciones del cuerpo van en ese orden. Una pieza nunca redefine el formato, la escala de severidad ni el veredicto. Después ejecuta `bash tests/stack-code-review/check-structure.sh` y `bash tests/stack-code-review/test-detect-stacks.sh`.

### Fallback: archivos sin pieza

Si ninguna pieza es dueña de un archivo (`owner: ... none`), se aplican solo los criterios generales más el conocimiento del modelo sobre su framework. Cada hallazgo de ese archivo lleva la etiqueta `[model knowledge]`, el encabezado `Stack(s):` lo marca como "model knowledge (lower confidence)" y `Limitations` indica la skill encontrada por búsqueda o recomienda instalar una para ese framework.

### Skills recomendadas

Las piezas y los criterios generales las consultan si están instaladas (si faltan, se anota en `Limitations` y la revisión continúa):

- `clean-architecture` y `clean-code` (de wondelai).
- `angular-developer` (pieza Angular).

## Tests

```bash
bash tests/stack-code-review/check-structure.sh    # estructura de la skill
bash tests/stack-code-review/test-detect-base.sh   # scripts/detect-base.sh contra repos de prueba
bash tests/stack-code-review/test-detect-stacks.sh # scripts/detect-stacks.sh contra repos de prueba
python3 tests/stack-code-review/relay-check.py <reporte> <respuesta>  # la respuesta reenvía el reporte del subagente sin cambios
```

Los escenarios de presión de la skill (ejecutados por un subagente y puntuados por un agente evaluador aparte que nunca ejecutó el escenario) están descritos en [`tests/stack-code-review/README.md`](../../tests/stack-code-review/README.md).
