# writing-tech-specs

[English](writing-tech-specs.md) | **Español**

Ayuda a escribir una spec técnica: antes de escribirla (qué contexto reunir) y antes de congelarla (una lista basada en nueve principios que la skill aplica a su propio borrador). Fuente: [`skills/planning/writing-tech-specs/`](../../../skills/planning/writing-tech-specs/SKILL.md). Destila la guía del equipo para escribir specs (original en español, fuera de este repo).

## Uso

En Claude Code: `/writing-tech-specs`. En Codex: `$writing-tech-specs`. La skill es solo manual: nunca se carga con un prompt implícito.

```text
/writing-tech-specs tengo que escribir la spec para silenciar una conversación 24 h; ¿qué averiguo primero?
```

- Nunca lee código, busca en un repositorio ni ejecuta comandos (el brief es la única fuente de hechos) y nunca escribe dentro de tu repositorio, ni aunque se lo pidas: da la spec en la respuesta y además guarda una copia local como `~/.specflow/<feature>/spec.md`, cuyas primeras líneas son `Published: <link o not published yet>` y `Copy date: <YYYY-MM-DD>`. Si la carpeta ya tiene un `spec.md`, se renombra `spec-superseded-<su fecha de copia>.md` (y `-2`, `-3`... si ese nombre existe), nunca se sobrescribe. La línea `Published:` es el link que das; al reescribir se conserva la anterior salvo que des otro. Si no se puede escribir en la carpeta, la skill lo dice y da la spec solo en la respuesta.
- La skill escribe la spec a partir de un discovery brief y nunca te pide una spec. Los briefs viven en `~/.specflow/<YYYY-MM-DD>-<slug>/brief.md`, una carpeta por feature: la skill te pide la carpeta (o lista `~/.specflow/` si no nombras ninguna), lee su `brief.md` y nunca un `brief-superseded-*`. Si además le pasas un informe de review (`review-<YYYY-MM-DD>.md` en esa carpeta), reescribe la spec desde el mismo brief y corrige cada `no` del Checklist del informe; el informe es contexto, nunca fuente de hechos. El flujo es `discovering-tech-changes` -> `writing-tech-specs`: un FRD, una historia de usuario, un ticket o solo la idea entran al discovery, y si también los pasas aquí son solo contexto (por ejemplo, el link del ticket). Corre **Before writing**: pide el brief y apunta a [`discovering-tech-changes`](discovering-tech-changes.es.md) para hacerlo. Mapea las secciones del brief a las reglas (palabras simples a qué construimos, objetivos y no-objetivos a qué construimos y a una sección Fuera de alcance, correcciones a una tabla "la spec dice / es", cómo funciona hoy a una sección "Today's behavior and dependencies", escrita como comportamiento y dejando identificadores, fechas y commits en el brief, razones de reuso junto a cada mecanismo fijo, entorno a contratos y trabajo en curso, opciones y preguntas abiertas a la tabla de decisiones). Si el brief es reducido o le falta una sección, la skill nombra cada sección que falta y la deja como pregunta abierta. Si el usuario declina el discovery, la skill se detiene y no escribe nada: sin conocer el código y el cambio, la spec serían suposiciones. No hacen falta líneas exactas, firmas ni nombres de archivo. El brief es solo un insumo: la spec escribe sus hechos como propios y como comportamiento (sin rutas de archivo, funciones, constantes, fechas ni commits: eso queda en el brief, para que la spec sobreviva a un cambio de implementación) y nunca nombra ni cita el brief. Luego redacta con las reglas y revisa su propio borrador con la lista Before freezing: el borrador termina con una sección `Self-check`, una línea por principio que cita dónde se cumple, o la corrección o pregunta abierta cuando no.

## Decidir si dividir una spec

No hay umbral de tamaño. Cuando preguntas si dividir, la skill lo trata como una decisión que se toma en conjunto, partiendo de unos principios (a favor: no se revisa de una sentada, más de un resultado entregable, partes con madurez distinta, una incógnita grande, superficie grande o dispersa; en contra: el contrato que crea el corte, partes que no se despliegan solas; y cortar por comportamiento antes que por repositorio). La respuesta tiene cuatro partes: una recomendación en una línea; las opciones, incluida "no dividir", cada una con lo que crea y lo que queda bloqueado; lo que la skill necesita de ti y no puede ver; y la decisión como fila Propuesta con las alternativas descartadas. Las fuentes y el nivel de respaldo de cada principio están en `references/content.md` (P4).

```text
/writing-tech-specs ¿dividimos ./specs/export-and-retention.md?
```

## Qué hay en la skill

| Archivo | Contenido |
|---|---|
| `SKILL.md` | Términos definidos una vez, Before writing (toma el discovery brief), las nueve reglas con su nivel de respaldo, la lista Before freezing |
| `references/content.md` | P1 a P4: por qué, casos del equipo, fuentes, antes → después |
| `references/statements.md` | P5 a P7 |
| `references/decisions-contracts.md` | P8 y P9 |
| `references/evidence.md` | Niveles de respaldo, resultados de las pruebas a ciegas, límites de la evidencia |

Cada regla lleva un nivel: **B** respaldado, **P** parcial, **O** propio, **H** hipótesis. En las pruebas a ciegas del equipo las más fiables fueron P6 (verificabilidad), P9 (contratos y specs hermanas), P8 (estado de las decisiones) y P1 (mecanismo frente a comportamiento). P4 sirve para dimensionar pero no predijo fricción, y la reconciliación con el diseño de P3 está casi sin probar.

## Alcance

Dentro: el texto de la spec y lo que hay que saber antes de escribirla.

Fuera: cambios que el LT, la PM o el dev hacen durante la implementación o el code review, el proceso de QA y tickets de revisión cerrados sin PR. La skill solo deja explícitos el motivo y el estado de cada decisión.

## Pruebas

```bash
bash tests/planning/writing-tech-specs/check-structure.sh
```

Los escenarios de presión (se ejecutan a mano con un runner y un evaluador aparte) están en [`tests/planning/writing-tech-specs/`](../../../tests/planning/writing-tech-specs/README.md).
