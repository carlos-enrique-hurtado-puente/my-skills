# my-skills

[English](README.md) | **Español**

> La versión principal de esta documentación es la [inglesa](README.md); este archivo es una traducción.

Skills personales para agentes de código (Claude Code, Codex). Un repo, muchas skills, instaladas por symlink.

## Skills

Las skills solo se ejecutan cuando las invocas de forma explícita.

### Planning: del requerimiento a la spec

| Skill | Descripción | Invocación (manual) | Docs |
|---|---|---|---|
| `discovering-tech-changes` | Entender un requerimiento y el código que toca, y preparar un brief de descubrimiento antes de escribir la spec técnica. | `/discovering-tech-changes` (Claude Code), `$discovering-tech-changes` (Codex) | [docs/skills/planning/discovering-tech-changes.es.md](docs/skills/planning/discovering-tech-changes.es.md) |
| `writing-tech-specs` | Preparar y escribir specs técnicas desde un discovery brief (ver `discovering-tech-changes`), revisando el borrador contra una lista de nueve principios antes de congelar. | `/writing-tech-specs` (Claude Code), `$writing-tech-specs` (Codex) | [docs/skills/planning/writing-tech-specs.es.md](docs/skills/planning/writing-tech-specs.es.md) |
| `reviewing-tech-specs` | Revisar una spec contra los nueve principios y comprobar la antigüedad de los hechos de su brief, sin leer código. | `/reviewing-tech-specs` (Claude Code), `$reviewing-tech-specs` (Codex) | [docs/skills/planning/reviewing-tech-specs.es.md](docs/skills/planning/reviewing-tech-specs.es.md) |
| `verifying-spec-facts` | Re-verificar en el código de hoy los hechos del brief que marcó la review, y actualizar sus fechas o informar qué cambió. | `/verifying-spec-facts` (Claude Code), `$verifying-spec-facts` (Codex) | [docs/skills/planning/verifying-spec-facts.es.md](docs/skills/planning/verifying-spec-facts.es.md) |

Estas dos skills forman una cadena:

1. Spec nueva: `discovering-tech-changes` convierte un requerimiento (FRD, historia de usuario, ticket o solo la idea) y el código que toca en un discovery brief guardado en `~/.tech-specs/`; `writing-tech-specs` escribe la spec solo desde ese brief y la revisa antes del freeze. Sin brief, ofrece el discovery, y si lo declinas no escribe nada.
2. Spec existente: `reviewing-tech-specs` la revisa contra los nueve principios y la antigüedad del brief; `verifying-spec-facts` re-verifica los hechos que marcó la review.

El flujo completo está en [docs/skills/planning/flow.es.md](docs/skills/planning/flow.es.md).

Puede seguir una skill para crear tickets; este repo no la incluye.

Cada skill la inicias tú.

### Code: escribir y revisar código

| Skill | Descripción | Invocación (manual) | Docs |
|---|---|---|---|
| `stack-code-review` | Code review de cambios de cualquier stack, desde la URL de un PR de GitHub o la rama local actual contra su base. | `/stack-code-review` (Claude Code), `$stack-code-review` (Codex) | [docs/skills/code/stack-code-review.es.md](docs/skills/code/stack-code-review.es.md) |
| `express-best-practices` | Reglas para escribir, cambiar y revisar código Express.js en Express 4 o 5: middleware, rutas, errores, sesiones, seguridad, producción. | `/express-best-practices` (Claude Code), `$express-best-practices` (Codex) | [docs/skills/code/express-best-practices.es.md](docs/skills/code/express-best-practices.es.md) |

## Estructura

```
skills/<categoría>/<nombre>/        ← una carpeta por skill (SKILL.md, agents/, references/, scripts/); es lo que se instala
docs/skills/<categoría>/<nombre>.md ← documentación de uso de cada skill
docs/plans/                         ← documentos de diseño y plan
tests/<categoría>/<nombre>/         ← tests y escenarios de cada skill (no se instalan)
tests/install/                      ← tests de install.sh
install.sh                          ← instalador
```

Las categorías son `planning` y `code`, iguales en `skills/`, `docs/skills/` y `tests/`. Solo existen en el repo: las skills instaladas quedan planas, por nombre.

## Instalación

```bash
bash install.sh              # Claude Code y Codex
bash install.sh --claude     # solo Claude Code (~/.claude/skills)
bash install.sh --codex      # solo Codex (~/.agents/skills)
```

El script crea un symlink por cada carpeta de `skills/*/*/`, con el nombre de la skill (`~/.claude/skills/<nombre>`, sin categoría). Es idempotente, crea los directorios padre si faltan y nunca sobrescribe una carpeta real ni un symlink que apunte a otro lugar (avisa por stderr y continúa). La única excepción es un enlace a la ruta vieja de la misma skill, de antes de las categorías (`skills/<nombre>`), que reemplaza. Si no puede crear un enlace, avisa y termina con código 1.

Equivalente manual para una skill (desde la raíz del repo):

```bash
mkdir -p ~/.claude/skills ~/.agents/skills
ln -s "$(pwd)/skills/<categoría>/<nombre>" ~/.claude/skills/<nombre>   # Claude Code
ln -s "$(pwd)/skills/<categoría>/<nombre>" ~/.agents/skills/<nombre>   # Codex
```

## Añadir una skill

El proceso completo (invocación solo manual, escritura con TDD usando `superpowers:writing-skills`, tests, docs) está en [AGENTS.md](AGENTS.md), que los agentes leen automáticamente. En corto: elige una categoría, crea `skills/<categoría>/<nombre>/SKILL.md`, sus tests en `tests/<categoría>/<nombre>/`, su página en `docs/skills/<categoría>/<nombre>.md` y una fila en la tabla de su categoría arriba, y ejecuta `bash install.sh`.

## Convenciones

- El inglés es el idioma principal de todo el repo. El español es solo una traducción, en un archivo `*.es.md` aparte enlazado desde el inglés.
- Cada skill es autocontenida dentro de su carpeta; no se factorizan piezas compartidas entre skills.

## Desarrollo

Desde la raíz del repo:

```bash
bash tests/install/test-install.sh   # install.sh con un HOME temporal
bash tests/code/stack-code-review/check-structure.sh
bash tests/code/express-best-practices/check-structure.sh
bash tests/planning/writing-tech-specs/check-structure.sh
bash tests/planning/discovering-tech-changes/check-structure.sh
bash tests/planning/discovering-tech-changes/check-scenarios.sh
bash tests/planning/reviewing-tech-specs/check-structure.sh
bash tests/planning/reviewing-tech-specs/test-rules-sync.sh
bash tests/planning/verifying-spec-facts/check-structure.sh
bash tests/planning/verifying-spec-facts/test-brief-heading.sh
```

Los tests de cada skill están en su página de docs.

## Licencia

[MIT](LICENSE)
