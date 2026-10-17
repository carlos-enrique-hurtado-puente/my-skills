# my-skills

Skills personales para agentes de código (Claude Code, Codex).

## Skills

| Skill | Descripción | Invocación (manual) |
|---|---|---|
| [`gcf-code-review`](skills/gcf-code-review/SKILL.md) | Code review de cambios en Google Cloud Functions / Cloud Run functions, desde la URL de un PR de GitHub o desde la rama local actual contra su base. | `/gcf-code-review` (Claude Code), `$gcf-code-review` (Codex) |

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
ln -s "$(pwd)/skills/gcf-code-review" ~/.claude/skills/gcf-code-review

# Codex
mkdir -p ~/.agents/skills
ln -s "$(pwd)/skills/gcf-code-review" ~/.agents/skills/gcf-code-review
```

## Uso

En Claude Code: `/gcf-code-review`. En Codex: `$gcf-code-review`.

Con una URL de PR se revisa ese PR; sin argumentos se revisa la rama local actual contra su base (el modo local se detiene primero para pedir una confirmación). El modo GitHub requiere `gh` instalado y autenticado.

```text
/gcf-code-review https://github.com/org/repo/pull/123
/gcf-code-review
/gcf-code-review base: main
/gcf-code-review spec: ./docs/ruta.md
/gcf-code-review https://github.com/org/repo/pull/123 spec: https://miempresa.atlassian.net/browse/PROJ-456
```

- `base:` (solo modo local) indica la rama base y omite la detección automática.
- `spec:` acepta una ruta local, una URL (por ejemplo un ticket de Jira) o texto pegado.

## Conectores

Leer la spec desde una URL depende de los MCP/herramientas configurados en cada herramienta. Claude Code y Codex se configuran por separado, así que un conector disponible en una no lo está necesariamente en la otra. Si no hay forma de leer la URL, la skill pide la spec en markdown.

## Migración desde gcf-pr-review

`gcf-code-review` reemplaza a `gcf-pr-review`. Si tienes la carpeta antigua en `~/.claude/skills/gcf-pr-review`, muévela a un respaldo y luego instala:

```bash
mv ~/.claude/skills/gcf-pr-review ~/.claude/gcf-pr-review.bak
bash install.sh
```

`install.sh` no toca la carpeta antigua; solo avisa si la encuentra.

## Desarrollo

Desde la raíz del repo:

```bash
bash tests/gcf-code-review/check-structure.sh    # estructura de la skill
bash tests/gcf-code-review/test-detect-base.sh   # scripts/detect-base.sh contra repos de prueba
bash tests/install/test-install.sh               # install.sh con un HOME temporal
```

Los escenarios de presión de la skill (ejecutados por un subagente y puntuados por un agente evaluador aparte que nunca ejecutó el escenario) están descritos en [`tests/gcf-code-review/README.md`](tests/gcf-code-review/README.md).
