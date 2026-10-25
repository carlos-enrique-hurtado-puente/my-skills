# my-skills

[English](README.md) | **Español**

> La versión principal de esta documentación es la [inglesa](README.md); este archivo es una traducción.

Skills personales para agentes de código (Claude Code, Codex). Un repo, muchas skills, instaladas por symlink.

## Skills

| Skill | Descripción | Invocación (manual) | Docs |
|---|---|---|---|
| `stack-code-review` | Code review de cambios de cualquier stack, desde la URL de un PR de GitHub o la rama local actual contra su base. | `/stack-code-review` (Claude Code), `$stack-code-review` (Codex) | [docs/skills/stack-code-review.es.md](docs/skills/stack-code-review.es.md) |
| `express-best-practices` | Reglas para escribir, cambiar y revisar código Express.js en Express 4 o 5: middleware, rutas, errores, sesiones, seguridad, producción. | `/express-best-practices` (Claude Code), `$express-best-practices` (Codex) | [docs/skills/express-best-practices.es.md](docs/skills/express-best-practices.es.md) |
| `writing-tech-specs` | Preparar, escribir y revisar specs técnicas: qué reunir antes de escribir y una lista de nueve principios antes de congelar. | `/writing-tech-specs` (Claude Code), `$writing-tech-specs` (Codex) | [docs/skills/writing-tech-specs.es.md](docs/skills/writing-tech-specs.es.md) |
| `spec-to-jira-stories` | Convertir una spec técnica en historias y sub-tareas de Jira (desarrollo, certificación, code review) y crearlas tras confirmación. | `/spec-to-jira-stories` (Claude Code), `$spec-to-jira-stories` (Codex) | [docs/skills/spec-to-jira-stories.es.md](docs/skills/spec-to-jira-stories.es.md) |

Las skills solo se ejecutan cuando las invocas de forma explícita.

## Estructura

```
skills/<nombre>/       ← una carpeta por skill (SKILL.md, agents/, references/, scripts/); es lo que se instala
docs/skills/<nombre>.md ← documentación de uso de cada skill
docs/                  ← documentos de diseño y plan
tests/<nombre>/        ← tests y escenarios de cada skill (no se instalan)
tests/install/         ← tests de install.sh
install.sh             ← instalador
```

## Instalación

```bash
bash install.sh              # Claude Code y Codex
bash install.sh --claude     # solo Claude Code (~/.claude/skills)
bash install.sh --codex      # solo Codex (~/.agents/skills)
```

El script crea un symlink por cada carpeta de `skills/*/`. Es idempotente, crea los directorios padre si faltan y nunca sobrescribe una carpeta real ni un symlink que apunte a otro lugar (avisa por stderr y continúa). Si no puede crear un enlace, avisa y termina con código 1.

Equivalente manual para una skill (desde la raíz del repo):

```bash
mkdir -p ~/.claude/skills ~/.agents/skills
ln -s "$(pwd)/skills/<nombre>" ~/.claude/skills/<nombre>   # Claude Code
ln -s "$(pwd)/skills/<nombre>" ~/.agents/skills/<nombre>   # Codex
```

## Añadir una skill

El proceso completo (invocación solo manual, escritura con TDD usando `superpowers:writing-skills`, tests, docs) está en [AGENTS.md](AGENTS.md), que los agentes leen automáticamente. En corto: crea `skills/<nombre>/SKILL.md`, sus tests en `tests/<nombre>/`, su página en `docs/skills/<nombre>.md` y una fila en la tabla de arriba, y ejecuta `bash install.sh`.

## Convenciones

- El inglés es el idioma principal de todo el repo. El español es solo una traducción, en un archivo `*.es.md` aparte enlazado desde el inglés.
- Cada skill es autocontenida dentro de su carpeta; no se factorizan piezas compartidas entre skills.

## Desarrollo

Desde la raíz del repo:

```bash
bash tests/install/test-install.sh   # install.sh con un HOME temporal
bash tests/spec-to-jira-stories/check-structure.sh
```

Los tests de cada skill están en su página de docs.
