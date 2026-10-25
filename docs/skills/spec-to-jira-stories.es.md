# spec-to-jira-stories

[English](spec-to-jira-stories.md) | **Español**

Convierte una spec técnica en historias y sub-tareas de Jira (desarrollo, certificación, code review), muestra el borrador completo y crea los tickets solo después de que confirmes cada uno. Fuente: [`skills/spec-to-jira-stories/`](../../skills/spec-to-jira-stories/SKILL.md). Se calibró con los tickets del equipo de AtomChat y se apoya en fuentes citadas sobre división de historias, PRs pequeños y diseño de pruebas.

## Uso

En Claude Code: `/spec-to-jira-stories`. En Codex: `$spec-to-jira-stories`. La skill es solo manual: nunca se carga con un prompt implícito.

```text
/spec-to-jira-stories convierte esta spec en tickets: https://<sitio>.atlassian.net/wiki/spaces/ENG/pages/12345, referencia ABC-123
/spec-to-jira-stories redacta las historias de ./specs/digest.md, usa ABC-123 como ticket de referencia
/spec-to-jira-stories divide esta spec solo si la propia spec da una razón: <texto pegado>
```

- **Entradas:** la spec (página de Confluence, archivo local, texto pegado, PDF; si no se puede leer completa, la skill lo dice y no redacta nada) y un ticket de referencia, una buena historia con sub-tareas. La referencia solo aporta etiquetas: clave del proyecto, prefijo de título, nombres de sección, prefijos de rol, idioma. El método decide la estructura y el contenido, aunque pidas copiar la referencia tal cual. Tú das también la épica; la skill nunca la adivina.
- **Primero las opciones de corte:** antes de cualquier borrador te ofrece 2 o 3 opciones de desglose (historias y sub-tareas de desarrollo), cada una con sus tickets, los criterios que cumple con citas de la spec y su costo, y marca una como recomendada; tú eliges. Por defecto una spec es una historia. Propone dividir solo con evidencia citada de la spec (bloqueos distintos, partes útiles y probables por separado, demasiado grande para una iteración) y tú decides. Cada historia lleva sub-tareas de desarrollo, una de certificación y una de code review. Un rol de desarrollo se divide solo si cada parte es un entregable verificable por sí mismo, las partes no se solapan, se unen por una interfaz estable y una razón real compensa el ticket extra; nunca por las secciones de la spec ni por el tamaño del PR.
- **Borrador:** cada ticket completo, sin marcadores de posición: historia (problema, solución, fuera de alcance, criterios), desarrollo (qué construir, notas, comprobaciones), certificación (una tabla con una fila por criterio más hasta 5 casos negativos o límite ligados a los riesgos de la spec), code review (los 3 a 5 puntos más críticos a los que prestar atención, una línea por PR esperado). Antes del borrador busca en Jira, solo en lectura, tickets ya creados a partir de la spec y te avisa. Puedes detenerte aquí.
- **Creación:** requiere el conector de Atlassian; sin él recibes el borrador. La skill nunca crea, edita ni transiciona un issue de Jira sin un sí para esa acción: pregunta antes de la primera creación y confirma cada una (historia, sub-tareas, enlace "relates to"), aunque digas "aprueba todo". Después informa claves y enlaces.

## Qué hay en la skill

| Archivo | Contenido |
|---|---|
| `SKILL.md` | Entradas, cómo leer la spec, cómo decidir el desglose, contenido de los tickets, pasos de borrador y creación |
| `references/splitting.md` | Cuándo dividir una spec en varias historias |
| `references/sub-tasks.md` | Sub-tareas de desarrollo, certificación y code review; criterios para dividir el desarrollo y fase de opciones |
| `references/ticket-content.md` | Esqueletos de cada ticket, etiquetas por defecto, formato de la línea de PR |
| `references/evidence.md` | Fuentes detrás de cada regla |
| `agents/openai.yaml` | Política de solo manual para Codex |

## Límites

- No se escribe nada en Jira sin un sí por acción.
- Nunca lee un código base ni Git; la spec es la única entrada.
- Sin horas, fechas, sprint, prioridad ni el campo de etiquetas de Jira, y sin emojis.
- Probada en vivo y solo lectura, con una ejecución de sonnet por escenario y condición. La creación en Jira nunca se ejercitó, así que las llamadas reales de creación no están probadas. Ver [lo que no cubre](../../tests/spec-to-jira-stories/README.md#not-covered).

## Pruebas

```bash
bash tests/spec-to-jira-stories/check-structure.sh
```

Los escenarios de presión (se ejecutan a mano con un runner y un evaluador aparte) y su resultado están en [`tests/spec-to-jira-stories/`](../../tests/spec-to-jira-stories/README.md).
