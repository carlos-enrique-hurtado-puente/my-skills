# writing-tech-specs

[English](writing-tech-specs.md) | **Español**

Ayuda en dos momentos de la vida de una spec técnica: antes de escribirla (qué contexto reunir) y antes de congelarla (una lista de revisión basada en nueve principios). Fuente: [`skills/planning/writing-tech-specs/`](../../../skills/planning/writing-tech-specs/SKILL.md). Destila la guía del equipo para escribir specs (original en español, fuera de este repo).

## Uso

En Claude Code: `/writing-tech-specs`. En Codex: `$writing-tech-specs`. La skill es solo manual: nunca se carga con un prompt implícito.

```text
/writing-tech-specs tengo que escribir la spec para silenciar una conversación 24 h; ¿qué averiguo primero?
/writing-tech-specs revisa esta spec antes de congelar: ./specs/digest.md
/writing-tech-specs revisa https://<sitio>.atlassian.net/wiki/spaces/ENG/pages/12345
```

- **Sin spec:** corre **Before writing**: necesita un discovery brief y apunta a [`discovering-tech-changes`](discovering-tech-changes.es.md) para hacerlo. Mapea las secciones del brief a las reglas (palabras simples a qué construimos, objetivos y no-objetivos a qué construimos y a una sección Fuera de alcance, correcciones a una tabla "la spec dice / es", hechos del código con fecha a Supuestos, razones de reuso junto a cada mecanismo fijo, entorno a contratos y trabajo en curso, opciones y preguntas abiertas a la tabla de decisiones). Si el brief es reducido o le falta una sección, la skill nombra cada sección que falta y la deja como pregunta abierta. Si el usuario declina el discovery, los huecos pasan a preguntas abiertas con dueño y momento, nunca a hechos inventados. No hacen falta líneas exactas, firmas ni nombres de archivo. Luego redacta con las reglas y revisa su propio borrador con la lista Before freezing: el borrador termina con una sección `Self-check`, una línea por principio que cita dónde se cumple, o la corrección o pregunta abierta cuando no. Después del self-check ofrece [`spec-to-jira-stories`](spec-to-jira-stories.es.md) como siguiente paso cuando la spec esté congelada; nunca la ejecuta.
- **Con una spec:** corre **Before freezing**. La spec puede ser texto pegado, un archivo local, una página de Confluence (se lee con las herramientas de Atlassian si están conectadas), un ticket de Jira o cualquier cosa legible. Si no puede leer la fuente, lo dice y pide que pegues el texto. La respuesta es una línea `yes` / `no` / `n.a.` por principio; cada `no` cita la spec y da una corrección o una decisión abierta con dueño y momento; al final dice si se puede congelar y ofrece `/spec-to-jira-stories` para después del freeze. La revisión no reescribe la spec salvo que lo pidas.

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
