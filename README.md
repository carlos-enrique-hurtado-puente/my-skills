# my-skills

Skills personales para agentes de código (Claude Code, Codex).

## Skills

| Skill | Descripción | Invocación (manual) |
|---|---|---|
| [`stack-code-review`](skills/stack-code-review/SKILL.md) | Code review de cambios de cualquier stack (piezas de stack enchufables, p. ej. Cloud Functions y Angular), desde la URL de un PR de GitHub o desde la rama local actual contra su base. | `/stack-code-review` (Claude Code), `$stack-code-review` (Codex) |

Las skills solo se ejecutan cuando las invocas de forma explícita.

## Estructura

```
skills/<nombre>/   ← una carpeta por skill (SKILL.md, agents/, references/, scripts/)
tests/             ← tests y escenarios (no se instalan)
docs/              ← documentos de diseño
install.sh         ← instalador
```

## Instalación

```bash
bash install.sh              # Claude Code y Codex
bash install.sh --claude     # solo Claude Code (~/.claude/skills)
bash install.sh --codex      # solo Codex (~/.agents/skills)
```

El script crea un symlink por cada skill de `skills/*/`. Es idempotente, crea los directorios padre si faltan y nunca sobrescribe una carpeta real ni un symlink que apunte a otro lugar (avisa por stderr y continúa).

Equivalente manual (desde la raíz del repo):

```bash
# Claude Code
mkdir -p ~/.claude/skills
ln -s "$(pwd)/skills/stack-code-review" ~/.claude/skills/stack-code-review

# Codex
mkdir -p ~/.agents/skills
ln -s "$(pwd)/skills/stack-code-review" ~/.agents/skills/stack-code-review
```

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
  dependencies: [express]        # también files: [...] e imports: [...]; al menos uno
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

Las seis secciones del cuerpo van en ese orden. Una pieza nunca redefine el formato, la escala de severidad ni el veredicto. Después ejecuta `bash tests/stack-code-review/check-structure.sh` y `bash tests/stack-code-review/test-detect-stacks.sh`.

### Fallback: archivos sin pieza

Si ninguna pieza es dueña de un archivo (`owner: ... none`), se aplican solo los criterios generales más el conocimiento del modelo sobre su framework. Cada hallazgo de ese archivo lleva la etiqueta `[model knowledge]`, el encabezado `Stack(s):` lo marca como "model knowledge (lower confidence)" y `Limitations` indica la skill encontrada por búsqueda o recomienda instalar una para ese framework.

### Skills recomendadas

Las piezas y los criterios generales las consultan si están instaladas (si faltan, se anota en `Limitations` y la revisión continúa):

- `clean-architecture` y `clean-code` (de wondelai).
- `angular-developer` (pieza Angular).

## Migración desde gcf-code-review y reviewing-angular-prs

`stack-code-review` reemplaza a `gcf-pr-review`, `gcf-code-review` y `reviewing-angular-prs` (su contenido pasó a las piezas `gcp-functions` y `angular`). `install.sh` no toca carpetas antiguas; solo avisa si las encuentra.

- `gcf-code-review` (symlinks antiguos en `~/.claude/skills/` o `~/.agents/skills/`): elimínalos o muévelos a mano.
- `reviewing-angular-prs`: muévela a un respaldo.
- `gcf-pr-review`: muévela a un respaldo.

```bash
mv ~/.claude/skills/reviewing-angular-prs ~/.claude/reviewing-angular-prs.bak
mv ~/.claude/skills/gcf-pr-review ~/.claude/gcf-pr-review.bak
rm ~/.claude/skills/gcf-code-review ~/.agents/skills/gcf-code-review   # si son symlinks
bash install.sh
```

## Desarrollo

Desde la raíz del repo:

```bash
bash tests/stack-code-review/check-structure.sh    # estructura de la skill
bash tests/stack-code-review/test-detect-base.sh   # scripts/detect-base.sh contra repos de prueba
bash tests/stack-code-review/test-detect-stacks.sh # scripts/detect-stacks.sh contra repos de prueba
bash tests/install/test-install.sh               # install.sh con un HOME temporal
```

Los escenarios de presión de la skill (ejecutados por un subagente y puntuados por un agente evaluador aparte que nunca ejecutó el escenario) están descritos en [`tests/stack-code-review/README.md`](tests/stack-code-review/README.md).
