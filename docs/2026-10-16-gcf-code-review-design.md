# Diseño: `gcf-pr-review` → `gcf-code-review` (multi-fuente)

- **Fecha:** 2026-10-16
- **Repo:** `my-skills` (`skills/gcf-pr-review/` → `skills/gcf-code-review/`)
- **Estado:** borrador para revisión

## 1. Intención y por qué

`gcf-pr-review` hace code review riguroso de cambios en Google Cloud Functions / Cloud Run functions, pero está atada a GitHub: solo acepta una URL de PR, todo lo obtiene con `gh` y prohíbe explícitamente el diff local. Carlos también trabaja con repos en Bitbucket y quiere revisar su propio trabajo **antes** de abrir el PR. La revisión en sí (12 criterios, severidades, tabla de hallazgos, veredicto) no depende de GitHub; solo la forma de obtener el diff y el contexto.

El objetivo es separar **de dónde salen los cambios** (la fuente) de **cómo se revisan** (el núcleo), y empezar con dos fuentes: PR de GitHub y rama local.

## 2. Objetivos

1. **Modo GitHub:** revisar un PR de GitHub a partir de su URL, con el mismo comportamiento que hoy.
2. **Modo local:** revisar la rama actual (cambios ya commiteados) contra su rama base, como si fuera un PR todavía no abierto.
3. **Mismo reporte en ambos modos:** las 3 secciones y la tabla de hallazgos de hoy, entregadas en el chat. Solo cambian los campos de encabezado que dependen de la fuente.
4. **Spec más flexible:** la spec se puede leer de un archivo, de una URL (con el conector que haya en la sesión) o pegada en el chat. Si se dio una spec y no se pudo leer, la skill la pide en markdown antes de bloquear. Si no se dio ninguna spec, no se pregunta nada y el comportamiento es el de hoy (`Spec reviewed: no`).
5. **Invocación solo manual:** la skill corre únicamente cuando el usuario la invoca (`/gcf-code-review` en Claude Code, `$gcf-code-review` en Codex), para no competir con otras skills de review.
6. **Instalación documentada para Claude Code y Codex** mediante symlinks al repo.

## 3. No-objetivos

- **Bitbucket.** No hay forma de traer un diff con el MCP actual (solo comenta). Queda para después. Si el usuario pasa una URL de Bitbucket, la skill responde que no está soportado y ofrece el modo local.
- **Revisar cambios sin commitear** (staged / working tree). El usuario siempre revisa trabajo commiteado.
- **Revisar un commit o un rango específico** (`HEAD~1..HEAD`, `a..b`). Es un caso muy poco frecuente.
- **Publicar comentarios** en el PR. La skill sigue siendo de solo lectura; la columna "Comment to post" es para copiar y pegar.
- **Cambiar los 12 criterios, las severidades o el formato del reporte**, salvo los campos de encabezado de la §6.4.

## 4. Anti-objetivos (fracasos aunque "funcione")

- Que la skill **toque el repo local**: checkout, switch, stash, commit, fetch, pull, reset o cualquier escritura. El modo local es tan de solo lectura como el de GitHub.
- Que **invente** criterios de aceptación, líneas o hallazgos cuando no pudo leer algo. La regla de `BLOCKED` sigue vigente.
- Que en modo local **se cuelen cambios ajenos**: los commits que entraron a la base después de crear la rama, o cambios sin commitear.
- Que la skill **se active sola** por frases como "revisa este PR" y le gane a otra skill de review.
- Que el instalador **pise una carpeta real** del usuario.

## 5. Restricciones

- Las instrucciones de la skill (`SKILL.md`, `references/*`) siguen en **inglés**, como hoy. La regla de idioma de salida (responder en el idioma del usuario) no cambia.
- La skill debe funcionar igual en **Claude Code y en Codex**. No puede depender de herramientas o MCP con nombre fijo de uno u otro; se describen por capacidad ("una herramienta que pueda leer esta URL").
- El modo local solo puede usar comandos `git` de lectura.
- El modo GitHub sigue requiriendo `gh` instalado y autenticado.

## 6. Decisiones tomadas

### 6.1 Nombre e invocación

- La skill se renombra a **`gcf-code-review`**: carpeta `skills/gcf-code-review/`, `name: gcf-code-review` en el frontmatter. Se hace con `git mv` para conservar el historial.
- **Claude Code:** el frontmatter agrega `disable-model-invocation: true`. Con esto Claude no la carga sola y solo corre con `/gcf-code-review`. (Documentación de Claude Code, sección Skills.)
- **Codex:** se agrega `skills/gcf-code-review/agents/openai.yaml` con:
  ```yaml
  policy:
    allow_implicit_invocation: false
  ```
  La invocación explícita con `$gcf-code-review` sigue funcionando. (Documentación de Codex, "Build skills".)
- La `description` deja de ser una lista de frases gatillo y pasa a ser una descripción para humanos: qué revisa (Cloud Functions / Cloud Run functions), qué fuentes soporta (PR de GitHub, rama local) y que es de solo lectura.

### 6.2 Entradas

| Entrada | Obligatoria | Valores |
|---|---|---|
| `target` | no | URL de PR de GitHub · URL de PR de Bitbucket · nada |
| `spec` | no | ruta a archivo local · URL · texto pegado |
| `base` | no | solo en modo local: nombre de la rama base, que se salta la detección |

Todo lo demás (generación, runtime, triggers, IaC, etc.) se sigue infiriendo de los cambios y del repo, como hoy.

### 6.3 Selección de modo

| Lo que llega | Qué hace la skill |
|---|---|
| URL `https://github.com/<owner>/<repo>/pull/<n>` | **Modo GitHub**, sin preguntar. |
| URL de Bitbucket (`bitbucket.org/.../pull-requests/<n>`) | Responde que Bitbucket todavía no está soportado y sugiere hacer checkout de la rama de ese PR y volver a correr la skill sin URL (modo local). No hace nada más. |
| Ningún target | **Modo local**, con confirmación (ver §6.5). |
| Número suelto o texto que no se entiende | Pregunta qué quiere revisar el usuario. |

**Cómo se interpretan los argumentos** (la invocación pasa texto libre). *Decisión del diseñador:*
- Una URL de PR de GitHub o de Bitbucket es el `target`.
- **Cualquier otra URL o ruta a un archivo existente es la `spec`.** Por ejemplo, `/gcf-code-review https://acme.atlassian.net/browse/X-1` significa "modo local con esta spec".
- Se aceptan también los prefijos explícitos `spec:` y `base:` (p. ej. `base: main`) para desambiguar. Si están presentes, mandan.
- El texto restante que no encaje se trata como spec pegada si parece una spec. Si no, la skill pregunta.

**Solo se revisa la rama actual** (*decisión del diseñador*). El modo local siempre revisa `HEAD`; no hay entrada para revisar otra rama. Para revisar otra rama, el usuario hace checkout él mismo y vuelve a correr la skill.

### 6.4 Núcleo común vs fuente

**Común a ambos modos (sin cambios de fondo):** rol, los 12 criterios (`references/criteria.md`), tabla de severidades, idioma de salida, red flags y errores comunes que no son de GitHub, formato de hallazgos, resumen ejecutivo y veredicto.

**Lo que aporta cada fuente:**
- cómo verificar los prerrequisitos;
- cómo obtener: metadatos, diff, lista de archivos, contenido completo de un archivo en la versión nueva, comentarios previos (solo GitHub);
- los campos de encabezado de la sección "PR analysis";
- sus condiciones de `BLOCKED`.

**Encabezado del reporte.** La sección 1 se generaliza. Los campos comunes se mantienen y se agregan:
- `Source:` `GitHub PR` | `Local branch`
- `Spec source:` `file <ruta>` | `<herramienta usada> (<url>)` | `pasted` | `none`

Campos por fuente:
- **GitHub:** PR, PR URL, head branch, base branch, autor y "PR comments reviewed", como hoy.
- **Local:** repo (nombre de la carpeta o del remoto `origin`), head branch, `HEAD` (sha corto), base ref, merge-base (sha corto), commits revisados (cantidad), y "PR comments reviewed: `N/A`".

Si se renombra la sección "PR analysis" a algo neutral (p. ej. "Change analysis"), queda a criterio del implementador.

### 6.5 Modo local

**Prerrequisitos**
1. Estar dentro de un repo git (`git rev-parse --is-inside-work-tree`). Si no lo está → `BLOCKED`.
2. `HEAD` tiene que estar en una rama (no detached). Si está detached, se informa y se le pide al usuario que haga checkout de la rama que quiere revisar y vuelva a correr la skill. No se genera reporte.
3. `git status --porcelain`: si hay cambios sin commitear, se avisa en el mensaje de confirmación y en "Limitations" que **no** entran en la revisión.

**Detección de la base** (si no se pasó `base`)
- Candidatas, en este orden de preferencia de ref: `origin/<x>` si existe; si no, `<x>` local, con `x ∈ {develop, main, master}` más la rama a la que apunta `origin/HEAD` si existe.
- Se elige la candidata cuyo merge-base con `HEAD` deja **menos commits** en `<base>..HEAD` (la base de la que realmente salió la rama). Si hay empate, gana la rama de `origin/HEAD`.
- No se hace `git fetch`. Si la base es una ref remota, la confirmación muestra la fecha del último commit de esa ref para que el usuario note si está desactualizada.

**Confirmación obligatoria antes de revisar.** Un único mensaje con este contenido:
> Voy a revisar `<rama>` contra `<base>` (merge-base `<sha>`, N commits, M archivos). [Aviso de cambios sin commitear, si aplica.] ¿Confirmas, cambias la base o querías revisar un PR?

La revisión empieza solo después de la respuesta.

**Casos borde**
- **0 commits respecto a la base** (por ejemplo, el usuario está parado en `develop`): se informa que no hay nada que revisar y no se genera reporte.
- **No se encuentra ninguna base candidata:** se pide al usuario que la indique.

**Obtención de datos (solo lectura)**
```bash
git rev-parse --abbrev-ref HEAD
git merge-base <base> HEAD
git log --oneline <base>..HEAD          # commits a revisar (mensajes = contexto, como la descripción de un PR)
git diff --stat <base>...HEAD
git diff <base>...HEAD                  # fuente de cambios
git show HEAD:<path>                    # archivo completo en la versión nueva (NO leer del disco)
git show <merge-base>:<path>            # versión anterior, si hace falta
```
Los archivos completos se leen con `git show HEAD:<path>` y **no** desde el working tree, para que el contexto coincida exactamente con lo commiteado aunque haya cambios locales.

**`BLOCKED` en modo local:** no es un repo git; no hay forma de determinar la base y el usuario no la indica; reglas de spec (§6.6).

**Regla de líneas:** se mantiene la regla de hoy. Las líneas son las de la versión nueva (`HEAD`), es decir, el lado derecho del diff.

### 6.6 Spec (opción B: detección + fallback)

Se aplica igual en ambos modos.
1. **Ruta a archivo local** (`.md`, `.txt`, etc.): se lee directo.
2. **URL:** se usa cualquier herramienta disponible en la sesión que pueda leer ese dominio: un MCP (Atlassian, Notion, Linear…), una CLI instalada o un fetch web si la página es pública. La skill **no nombra** un MCP concreto.
3. **Texto pegado** en el mensaje: se usa tal cual.
4. **Si no se pudo leer:** antes de bloquear, se le dice al usuario por qué (p. ej. "no tengo en esta sesión una herramienta que lea Jira") y se le pide la spec en markdown, como ruta o pegada.
5. **Si no la entrega:** `BLOCKED`, salvo que confirme explícitamente revisar sin spec. En ese caso `COMPLETED` con `Spec reviewed: no`, igual que hoy.
6. Nunca se inventan criterios de aceptación.
7. **Si no se dio ninguna spec**, no se pide: la revisión sigue con `Spec reviewed: no` y `Spec source: none`, igual que hoy. En modo GitHub no se agrega ninguna pregunta.

El campo `Spec source` del encabezado registra de dónde salió.

### 6.7 Modo GitHub

Comportamiento igual al actual. Cambios mínimos:
- Las reglas 1 y 2 de "Hard rules" se reescriben por fuente: "en modo GitHub, nunca `gh pr checkout` ni diff local; la base es `baseRefName`".
- Los comandos de `gh-commands.md` pasan a la referencia de fuente GitHub (ver §6.8).
- La lectura de la spec sigue la §6.6.

### 6.8 Estructura de archivos de la skill

```
skills/gcf-code-review/
├── SKILL.md                 # núcleo: rol, entradas, selección de modo, flujo común, severidad, idioma, red flags
├── agents/
│   └── openai.yaml          # policy para Codex
└── references/
    ├── criteria.md          # sin cambios
    ├── output-format.md     # encabezado generalizado (§6.4)
    ├── spec-sources.md      # §6.6 (puede vivir en SKILL.md si queda corto; criterio del implementador)
    └── sources/
        ├── github.md        # ex gh-commands.md + reglas y BLOCKED propios de GitHub
        └── local-git.md     # §6.5
```

`SKILL.md` indica que se lea **solo** el archivo de la fuente activa.

### 6.9 Instalación

- Tanto Claude Code como Codex soportan carpetas de skill que sean symlinks:
  - **Claude Code:** `~/.claude/skills/<nombre>` → `<repo>/skills/<nombre>`.
  - **Codex:** `~/.agents/skills/<nombre>` → `<repo>/skills/<nombre>`.
- **`install.sh`** en la raíz del repo:
  - Para cada carpeta en `skills/*`, crea o actualiza el symlink en ambas rutas (crea los directorios padre si no existen).
  - Si en la ruta destino ya hay una **carpeta real o un archivo**, no la toca: avisa y sigue con la siguiente.
  - Si ya hay un symlink apuntando al mismo destino, no hace nada. Si apunta a otro lado, avisa y no lo cambia.
  - Es idempotente. Opción `--claude` / `--codex` para instalar solo en uno (por defecto, en ambos).
- **README** (raíz):
  - índice de skills;
  - instalación con `install.sh` y los comandos `ln -s` manuales equivalentes;
  - cómo invocar la skill en cada herramienta;
  - nota sobre conectores: la lectura de specs por URL depende de los MCP configurados en cada herramienta (Claude Code y Codex tienen configuraciones separadas). Si falta, la skill pide la spec en markdown.
- **Migración de la copia vieja:** `~/.claude/skills/gcf-pr-review` es hoy una carpeta real con la versión anterior. El README indica moverla a un backup o borrarla manualmente. `install.sh` no la toca porque tiene otro nombre, pero la avisa si la encuentra para evitar dos skills casi iguales.

## 7. Queda a criterio del implementador

- La redacción exacta de `SKILL.md`, la nueva `description` y los mensajes al usuario. Deben respetar el contenido de §6.
- Si "PR analysis" se renombra.
- Si `spec-sources.md` es un archivo aparte o una sección de `SKILL.md`.
- La implementación concreta de `install.sh` (bash portable para macOS).
- El orden de los commits. Sugerencia: (1) `git mv` + rename, (2) refactor núcleo/fuentes sin cambiar comportamiento de GitHub, (3) modo local, (4) spec B, (5) invocación manual, (6) instalación y README.

## 8. Verificación esperada

- **Modo GitHub:** correr la skill sobre un PR real de Cloud Functions y comprobar que el reporte es equivalente al de la versión anterior, más los campos `Source` y `Spec source`.
- **Modo local:** en un repo con una rama de varios commits sobre `develop`:
  - la confirmación muestra la base correcta, el merge-base y los conteos;
  - el reporte no incluye commits que entraron a `develop` después del merge-base;
  - con cambios sin commitear, aparece el aviso y esos cambios no se revisan;
  - parado en la base, informa "nada que revisar".
- **Spec:** probar con archivo `.md`, con URL de Jira en Claude Code (MCP de Atlassian disponible) y con una URL que no se pueda leer. En este último caso debe pedir la spec antes de bloquear.
- **Argumentos:** `/gcf-code-review <url de Jira>` entra en modo local con esa spec; `/gcf-code-review <url de PR GitHub> spec: ./spec.md` entra en modo GitHub con spec de archivo; `/gcf-code-review base: main` se salta la detección de base.
- **Invocación:** en Claude Code, decir "revisa este PR <url>" sin `/gcf-code-review` no debe activar la skill; con `/gcf-code-review <url>` sí. En Codex, lo mismo con `$gcf-code-review`.
- **Instalación:** `install.sh` corrido dos veces no cambia nada la segunda vez, y no pisa una carpeta real.
