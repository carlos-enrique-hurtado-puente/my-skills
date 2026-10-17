# Diseño: `gcf-code-review` → `stack-code-review` (núcleo + piezas por stack)

- **Fecha:** 2026-10-17
- **Repo:** `my-skills` (`skills/gcf-code-review/` → `skills/stack-code-review/`)
- **Antecedente:** `docs/2026-10-16-gcf-code-review-design.md` (fuentes GitHub/local, spec opción B, invocación manual). Todo lo de ese diseño sigue vigente salvo lo que este documento cambia.
- **Estado:** borrador para revisión

## 1. Intención y por qué

Carlos revisa código de varios stacks: Cloud Functions (backend), Angular (frontend), y a futuro React, Express u otros. Hoy hay dos skills separadas que repiten el mismo método de revisión con formatos distintos (`gcf-code-review` y `reviewing-angular-prs`). Quiere **una sola skill de revisión** con un núcleo estable al que se le **enchufan piezas por stack**. Agregar un stack nuevo tiene que ser agregar una pieza, sin tocar el resto. Además, el agente solo tiene que cargar las piezas que aplican al cambio, para que las reglas de un stack no se mezclen con las de otro ni lo confundan.

También quiere que la revisión aproveche las skills de buenas prácticas que ya tenga instaladas (por ejemplo `angular-developer`) y que siempre evalúe Clean Architecture y Clean Code.

## 2. Objetivos

1. **Un núcleo agnóstico de stack:**
   - el método de revisión;
   - las fuentes (PR de GitHub, rama local);
   - la lectura de la spec;
   - el formato único del reporte;
   - la severidad;
   - la rúbrica propia de Clean Architecture y Clean Code;
   - los criterios generales.
2. **Piezas por stack** en `stacks/<id>.md`. Cada una declara cómo detectar que aplica, qué skills externas consultar y su checklist propio.
3. **Agregar un stack = crear un archivo en `stacks/`.** El núcleo no tiene una lista fija de stacks.
4. **Uso de skills externas** para profundizar:
   - las que declara cada pieza;
   - `clean-architecture` y `clean-code` (wondelai) desde el núcleo, cuando estén instaladas.
5. **Stack sin pieza:**
   - se aplican los criterios generales más el conocimiento del modelo sobre ese framework, marcado como de menor confianza;
   - se busca una skill de ese framework entre las disponibles y, si aparece, se consulta y se anota;
   - si no hay ninguna, el reporte recomienda instalar una.
6. **Formato único del reporte para todos los stacks:** el de `gcf-code-review` (análisis del cambio, tabla de hallazgos, resumen ejecutivo con veredicto).
7. **Primeras piezas:** `gcp-functions` (lo actual) y `angular` (lo de `reviewing-angular-prs`).
8. **Retirar `reviewing-angular-prs`** cuando la pieza de Angular pase sus escenarios.

## 3. No-objetivos

- Bitbucket (sigue fuera; está como tarea aparte).
- Escribir piezas para React o Express ahora. Se prueban como "stack sin pieza".
- Escribir skills propias de Clean Code o Clean Architecture.
- Cambiar las fuentes (GitHub/local), la detección de base, la spec o la invocación manual del diseño anterior.

## 4. Anti-objetivos

- **Que se mezclen stacks.** Por ejemplo, que en un PR de Angular aparezcan hallazgos de idempotencia de Pub/Sub, o que se carguen piezas que no aplican.
- **Que el puntaje dependa de una skill externa.** Su ausencia o un cambio de versión no puede cambiar el puntaje ni la estructura del reporte.
- **Que agregar un stack obligue a editar el núcleo**, o que sacar uno lo rompa.
- **Que se presente conocimiento del modelo como si viniera de una pieza o skill.** Sin la marca de menor confianza, eso no se puede hacer.
- **Que se pierda alguna regla** de las 14 que hoy pasan en los escenarios de `gcf-code-review`.

## 5. Restricciones

- Los archivos de instrucciones siguen en **inglés**. La salida, en el idioma del usuario.
- Funciona igual en Claude Code y Codex. Las skills externas se nombran por su `name` exacto, y su ausencia se tolera.
- Las skills que se consultan tienen que ser de invocación normal. Una skill con `disable-model-invocation: true` no la puede cargar el agente.
- Siguen vigentes todo el modo de solo lectura y las reglas de `BLOCKED` del diseño anterior.
- `SKILL.md` del núcleo no debería crecer más de ~15 % sobre las 1390 palabras actuales. Lo nuevo va a las referencias.

## 6. Decisiones tomadas

### 6.1 Nombre e invocación

- Se renombra a **`stack-code-review`**, para evitar el choque con el `/code-review` integrado de Claude Code. Se hace con `git mv`.
- La invocación sigue siendo manual (`disable-model-invocation: true` y `agents/openai.yaml`).
- `install.sh` reemplaza los symlinks. El viejo `~/.claude/skills/gcf-code-review` y su par en `~/.agents/skills` son symlinks, así que se pueden borrar sin pérdida. El instalador avisa si existen.
- La `description` cambia a revisión de código de cualquier stack, con piezas para Cloud Functions y Angular, desde un PR de GitHub o la rama local.

### 6.2 Estructura de archivos

```
skills/stack-code-review/
├── SKILL.md                    # núcleo
├── agents/openai.yaml
├── references/
│   ├── criteria.md             # criterios GENERALES + rúbrica CA/CC (ver 6.4)
│   ├── output-format.md        # formato único, encabezado generalizado (ver 6.6)
│   ├── spec-sources.md         # sin cambios
│   ├── stack-selection.md      # cómo se detectan y cargan piezas; fallback (ver 6.5)
│   └── sources/{github.md,local-git.md}   # sin cambios de fondo
├── stacks/
│   ├── gcp-functions.md
│   └── angular.md
└── scripts/detect-base.sh      # sin cambios
```

### 6.3 Contrato de una pieza (`stacks/<id>.md`)

Cada pieza empieza con un bloque de frontmatter YAML y sigue con el cuerpo en markdown:

```yaml
---
id: angular
name: Angular
detect:                 # aplica si se cumple AL MENOS una señal
  dependencies: ["@angular/core"]          # en cualquier package.json del repo (versión nueva)
  files: ["**/*.component.ts", "angular.json"]   # globs sobre los archivos del diff o del repo
  imports: ["@angular/"]                   # texto importado en archivos del diff
skills: [angular-developer]                # nombres exactos; opcionales
context_fields: [Angular version, Test framework]   # campos que la pieza agrega al encabezado
---
```

El cuerpo tiene estas secciones, en este orden:
1. **Context detection.** Cómo llenar los `context_fields` (por ejemplo, la versión de Angular desde `package.json`).
2. **Checklist.** Tabla área → qué buscar.
3. **How to use the skills.** Qué referencia de la skill externa abrir según el área que toca el diff.
4. **Clean Architecture in this stack.** Cómo se ve cada uno de los 7 puntos de la rúbrica del núcleo en este stack (ejemplos, no reglas nuevas).
5. **Severity notes.** Casos de `blocking` propios del stack que se suman a los del núcleo.
6. **Common mistakes.**

Cosas que una pieza **no** puede redefinir: el formato del reporte, la escala de severidad, el veredicto ni la rúbrica. Solo los ejemplifica o suma casos.

### 6.4 Núcleo: criterios generales y rúbrica

`criteria.md` queda con los criterios **que aplican a cualquier stack**:
- 1. Spec compliance
- 2. Clean Architecture, con la rúbrica 0–7 reescrita en términos generales
- 3. Clean Code, con una rúbrica propia de 10–15 líneas basada en la de la skill de Angular y la sección 3 actual
- 7. Security (general)
- 8. Observability
- 10. Testing (general)
- 11. Compatibility and regressions

Los criterios 4 (HTTP handlers), 5 (event triggers), 6 (persistence), 9 (performance/costs) y 12 (config/deploy) pasan a `stacks/gcp-functions.md`. La parte de IAM/runtime de Security también.

**Rúbrica de Clean Architecture (0–7).** Son los mismos 7 puntos con redacción general. Por ejemplo, el 1 pasa a ser "las reglas de negocio se pueden testear sin el framework ni la infraestructura". La escala sigue igual: `Solid | Acceptable with debt | Relevant coupling | Strongly coupled`.

**Skills de consulta del núcleo.** `clean-architecture` y `clean-code` se abren solo si están instaladas y solo para profundizar en un hallazgo. Su puntaje propio se ignora.

### 6.5 Selección de piezas (`references/stack-selection.md`)

1. **Listar las piezas.** El agente lista `<skill-dir>/stacks/*.md` y lee solo su frontmatter.
2. **Evaluar señales.** Las evalúa contra el repo y el diff:
   - en modo local, con `git show HEAD:<path>` y la lista de archivos del diff;
   - en modo GitHub, con `gh api .../contents?ref=<headRefName>` y `gh pr diff --name-only`.
3. **Cargar las piezas que aplican, y solo esas.** Cada una se lee entera. Si una pieza declara skills y están disponibles en la sesión, se cargan. Si no, se anota su ausencia y se sigue solo con el checklist de la pieza.
4. **PR con varios stacks.** Se cargan todas las piezas que detectaron algo. Cada hallazgo usa los criterios de la pieza dueña del archivo comentado, que es la pieza cuyas señales de `files`/`imports` matchean ese archivo; si ninguna, se usan solo los criterios generales. El resultado es un solo reporte.
5. **Sin pieza para el código del diff:**
   - Se identifica el framework con lo que haya (`package.json`, imports, extensiones).
   - Se aplican los criterios generales y el conocimiento del modelo sobre ese framework. Cada hallazgo que dependa de conocimiento del framework, y no de los criterios generales, se marca con el prefijo `question` o con la etiqueta `(model knowledge)` dentro del comentario. **A decidir por el implementador**, pero tiene que ser visible en la fila.
   - Se buscan entre las skills disponibles las que tengan en su descripción el nombre del framework. Si hay una, se consulta y se anota; si hay varias, se usa la más específica y se anotan las otras.
   - Si no hay ninguna, el reporte recomienda instalar una skill de ese framework.

### 6.6 Reporte

Se mantiene el formato de tres secciones. Cambios en el encabezado:
- **Nuevo `Stack(s):`** una línea por stack. Cada línea dice el nombre, de dónde salieron sus criterios (`piece` | `model knowledge (lower confidence)`) y las skills consultadas o faltantes.
- **Los campos `Generation`, `Runtime` y `Trigger(s)`** dejan de ser fijos. Ahora son los `context_fields` de cada pieza cargada.
- **`Limitations`** suma:
  - las skills declaradas que faltan;
  - los stacks sin pieza;
  - la recomendación de instalar una skill;
  - las skills elegidas por búsqueda.
- **"Validations performed"** (el caso sin hallazgos) lista los criterios generales más los del checklist de cada pieza cargada.
- **Veredicto.** Los textos que nombran a GCP (por ejemplo "business logic strongly coupled to GCP") pasan a "al framework o la infraestructura".

### 6.7 Pieza `gcp-functions`

- **Señales:**
  - `firebase-functions`, `@google-cloud/functions-framework` o `@google-cloud/pubsub` en dependencias;
  - `firebase.json`;
  - imports de `firebase-functions`.
- **Skills:** ninguna obligatoria. Se pueden declarar `firebase-basics` y `gcloud` como opcionales para flags y CLI.
- **Contenido:** los criterios 4, 5, 6, 9 y 12 actuales, IAM/runtime, los campos Generation / Runtime / Trigger(s), los casos de `blocking` propios (reintentos infinitos, costos descontrolados, invocación no autorizada) y los red flags actuales que son de GCF.
- **Requisito:** los 14 escenarios actuales tienen que pasar sin cambiar sus Expected. Solo cambia el nombre de la skill que se invoca.

### 6.8 Pieza `angular`

- **Señales:** `@angular/core`, `angular.json`, `*.component.ts`.
- **Skills:** `angular-developer`.
- **Contenido** (de `~/.claude/skills/reviewing-angular-prs`):
  - el checklist de `checklist.md`;
  - detectar la versión de Angular y el framework de tests (`input()` necesita 17.1+, `linkedSignal`/`resource` 19+);
  - distinguir "no hay CI" de "CI no corrió";
  - abrir la referencia de `angular-developer` según el área;
  - las severidades propias (fugas de suscripción, `fit`/`fdescribe`).
- **Lo que se pierde a propósito:** el formato de tabla de dos columnas de la skill vieja.

### 6.9 Retiro de `reviewing-angular-prs`

Una vez que los escenarios de Angular pasen, se mueve `~/.claude/skills/reviewing-angular-prs` a `~/.claude/skills-backup/reviewing-angular-prs-<fecha>`, como se hizo con `gcf-pr-review`. Requiere el OK del usuario. Hoy es una carpeta real fuera del repo.

### 6.10 Pruebas

- **Escenarios actuales (14):** se renombran a la skill nueva y deben seguir pasando. Son la red de seguridad de GCF.
- **Fixtures nuevos** (`make-local-repo.sh` gana una opción `--stack <gcp|angular|express|mixed>`, o un script hermano; a decidir por el implementador):
  - **`angular`:** un componente con una suscripción sin limpieza y un método llamado en el template. Son dos hallazgos garantizados.
  - **`express`:** una ruta con validación ausente y un error tragado. No hay pieza.
  - **`mixed`:** `functions/` con el bug actual y `web/` con el bug de Angular.
- **Escenarios nuevos:**
  - `angular-local`: la pieza Angular se carga, `angular-developer` se consulta, aparecen los hallazgos de Angular, ninguno de GCF, y el encabezado trae `Stack: Angular`.
  - `angular-skill-missing`: como el anterior, pero la sesión no tiene `angular-developer`. Se puede simular indicándole al runner que no está disponible. `Limitations` anota la ausencia y se usa el checklist de la pieza.
  - `express-no-piece`: criterios generales, hallazgos marcados como conocimiento del modelo, y recomendación de instalar una skill o skill encontrada por búsqueda. Ninguna regla de GCF ni de Angular.
  - `mixed-stack`: se cargan las dos piezas, cada hallazgo usa la pieza de su archivo, y el resultado es un solo reporte.
  - `no-cross-contamination`: en un repo GCF puro, la pieza de Angular no se lee. Se verifica en la lista de comandos y lecturas.
- **Tests de estructura.** `check-structure.sh` valida que cada `stacks/*.md` tenga frontmatter con `id`, `name`, `detect` (al menos una señal) y las secciones del cuerpo en orden.

### 6.11 Decisiones del diseñador (tras la revisión del builder)

Estas decisiones las tomó el diseñador, no el usuario, y se pueden revisar.

1. **Intención del PR e higiene van al núcleo, no a la pieza de Angular.** Valen para cualquier stack:
   - si el diff coincide con su propósito;
   - si mezcla cambios no relacionados;
   - si los riesgos están documentados;
   - los contratos con otros repos, planteados como `question`;
   - tamaño, secretos y descripción faltante;
   - distinguir "no hay CI" de "CI no corrió".

   En modo GitHub se usan la descripción del PR y `gh pr checks`; en modo local, los mensajes de commit, y lo de CI se omite. Lo detallado va a `criteria.md` y a `sources/github.md`. En `SKILL.md` queda una línea.
2. **Un solo juego de etiquetas y severidades.**
   - Se usa el de `output-format.md`, que ya incluye `praise`, `todo`, `chore`, `thought` y el resto de Conventional Comments.
   - El caso sin hallazgos usa "Validations performed".
   - Las filas se ordenan `blocking` → `non-blocking` → `nitpick`.
   - La fila `blocking` del núcleo queda en términos generales: bug, incumplimiento de spec, contrato roto, seguridad, pérdida o duplicación de datos, regresión mayor, test crítico faltante.
   - Cada pieza suma sus casos en "Severity notes". GCF: flujo no idempotente, reintentos infinitos, costos descontrolados, invocación no autorizada. Angular: fuga de suscripción evidente, `fit`/`fdescribe`.
   - La regla de Angular "nunca `blocking` por preferencias de arquitectura o Clean Code sin impacto funcional" pasa al núcleo, porque es general.
3. **Qué sale de `SKILL.md` hacia `stacks/gcp-functions.md`:**
   - la regla dura "GCP limits or flags", que en el núcleo queda como "framework/platform limits or flags";
   - el paso de workflow "Infer the cloud context", que pasa a ser "llenar los `context_fields` de cada pieza cargada";
   - "evaluate all 12 criteria", que pasa a ser "criterios generales + checklist de cada pieza cargada";
   - el error común de idempotencia;
   - los casos de `blocking` propios de GCF.

   El rol pasa a "Staff/Senior Engineer". El presupuesto de palabras de `SKILL.md` sube a ~15 % sobre 1390.
4. **Escenarios existentes.** Hay 15: los 14 originales más `github-spec-unreadable`.
   - Sus Expected se pueden editar solo donde nombran campos del encabezado que cambian (Generation, Runtime, Trigger, los 12 criterios). Ningún Expected de comportamiento cambia.
   - La línea `Stack(s):` es aditiva.
   - En los escenarios de GCF, `Generation`, `Runtime` y `Trigger(s)` siguen apareciendo, ahora como `context_fields` de la pieza.
5. **Detección y pertenencia de archivos.** Se hace con un script desde el inicio, `scripts/detect-stacks.sh`, con su test, por lo aprendido con `detect-base.sh`.
   - **Candidatas:** las piezas cuyas señales `dependencies` matchean algún `package.json` del repo (versión nueva).
   - **Raíz de una pieza:** el directorio de ese `package.json`.
   - **Dueño de un archivo del diff:** la pieza cuya raíz es el prefijo más largo de su ruta. Si el `package.json` es la raíz del repo y lo declaran varias piezas, deciden las señales `files`/`imports`. Si nada decide, el archivo queda sin dueño y aplican solo los criterios generales.
   - **Se carga solo una pieza que es dueña de al menos un archivo del diff.** Un `web/` sin tocar no carga Angular.
   - **Salida del script:** la lista de piezas cargadas y, por archivo del diff, su dueño, más los indicios de framework de los archivos sin dueño (`package.json` más cercano, imports).
6. **Tests y documentación renombrados.** `tests/gcf-code-review/` pasa a `tests/stack-code-review/` con `git mv`. `check-structure.sh`, `tests/.../README.md` y el `README.md` raíz se actualizan con el nombre nuevo y los symlinks viejos.
7. **Determinismo de los escenarios de skills.**
   - `express-no-piece` acepta cualquiera de las dos ramas: skill encontrada por búsqueda y anotada, o recomendación de instalar una. Lo que se exige siempre es la marca de menor confianza y ninguna regla de GCF ni de Angular.
   - `angular-skill-missing` simula la ausencia indicándole al runner que `angular-developer` no está instalada. Es una aproximación y queda documentada como tal en el escenario.
8. **Retirar `reviewing-angular-prs` cambia un comportamiento visible.** Hoy esa skill se activa sola con "revisa este PR" en un PR de Angular. Después del retiro, la revisión de Angular solo corre con `/stack-code-review`. Es coherente con la decisión del usuario de que las skills de review sean de invocación manual para no competir entre sí.

## 7. Queda a criterio del implementador

- La redacción de la rúbrica de Clean Code y de los 7 puntos generales de Clean Architecture.
- Cómo se marca un hallazgo de conocimiento del modelo (§6.5.5), siempre que sea visible en la fila.
- La forma de los fixtures nuevos.
- La forma exacta de la salida de `detect-stacks.sh` (ver §6.11.5).
- El orden de los commits.

## 8. Verificación esperada

- Los 14 escenarios actuales pasan con la skill renombrada.
- Los 5 escenarios nuevos de §6.10 pasan, con la presión combinada.
- `check-structure.sh` valida las piezas.
- Agregar una pieza de prueba (por ejemplo, `stacks/express.md` mínima) no requiere editar ningún otro archivo. Se comprueba con un escenario o un test de estructura, y después la pieza se borra.
- `install.sh` instala `stack-code-review` y avisa por los symlinks viejos de `gcf-code-review`.
- Prueba en vivo en Claude Code y Codex como la anterior, con el nombre nuevo.
