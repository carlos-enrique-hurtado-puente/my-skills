# discovering-tech-changes

[English](discovering-tech-changes.md) | **Español**

Te ayuda a entender un requerimiento (FRD, historias de usuario, una tarea o un diseño) y el código que toca, y prepara un brief de descubrimiento antes de escribir la spec técnica. Trabaja paso a paso: cada paso termina en un punto de control donde validas o corriges antes de seguir. Explica primero en lenguaje llano y deja los identificadores de código como evidencia debajo. Fuente: [`skills/discovering-tech-changes/`](../../skills/discovering-tech-changes/SKILL.md). Cada paso se apoya en fuentes citadas y en evidencia real de Jira, como heurísticas abiertas y no como reglas cerradas.

## Uso

En Claude Code: `/discovering-tech-changes`. En Codex: `$discovering-tech-changes`. La skill es solo manual: nunca se carga con un prompt implícito.

```text
/discovering-tech-changes ayúdame a entender este FRD antes de escribir la spec: https://<sitio>.atlassian.net/wiki/spaces/ENG/pages/12345
/discovering-tech-changes ABC-123: ¿qué hace el código hoy y qué puedo reutilizar?
/discovering-tech-changes ./docs/frd-export-limits.md, profundidad reducida, es un cambio pequeño
```

- **Entrada:** texto pegado, un archivo local, una página de Confluence, un ticket de Jira (con las herramientas de Atlassian) o un diseño. La skill lo lee completo; si no puede, lo dice y pide el texto. Nunca trabaja a partir de un título ni de memoria.
- **Profundidad:** antes del paso 1 te pide elegir **completa** (pasos 1 a 7) o **reducida** (pasos 3 y 4 más un brief corto, para un cambio que puedes describir en una frase). Dice cuál encaja y por qué; tú eliges.
- **Idioma:** el brief se escribe en tu idioma.

## Los siete pasos

Cada paso termina en un punto de control: se detiene, muestra el resultado en lenguaje llano y espera tu respuesta, aunque le pidas que se apure. Los pasos 3 a 6 se revisan cuando algo aprendido cambia una respuesta anterior.

| # | Paso | Qué hace | Punto de control |
|---|---|---|---|
| 1 | Entrada | Reformula lo que se pide y el resultado; marca omisiones, ambigüedades y contradicciones; abre la lista de correcciones a la entrada | ¿Es esto lo que se pide? |
| 2 | Encuadre | Objetivos, no objetivos y cómo se sabrá que se logró | ¿Confirmas objetivos y no objetivos? |
| 3 | Cómo funciona hoy | Primero el comportamiento observable, luego el flujo completo: cada llamador, otros lectores y escritores del dato, efectos secundarios, contratos, descartes silenciosos, tests, historial | Corrige la explicación |
| 4 | Reutilización y convenciones | Para cada comportamiento necesario, busca por comportamiento (puede existir con otro nombre); registra convenciones; reutilizar, adaptar o crear, con la razón | ¿Confirmas el inventario? |
| 5 | Entorno | Otras specs, ramas y trabajo en curso que tocan los mismos archivos, flujos o contratos; contratos verificados contra el proveedor; orden de despliegue; límites | ¿Confirmas la lista y el responsable de cada uno? |
| 6 | Opciones | Dos o tres, incluida una más pequeña y "dejarlo como está" cuando tenga sentido; recomienda una con la razón | ¿Qué dirección eliges? |
| 7 | Brief | Consolida todo | ¿Validas el brief completo? |

## El brief

Se entrega por defecto en el chat, con la oferta de guardarlo en un archivo; Confluence solo si lo pides. Secciones:

0. Encabezado: entrada, fecha, commit, profundidad, qué se validó.
1. En palabras llanas: problema, resultado, hoy y propuesta, en una página y sin identificadores.
2. Correcciones a la entrada.
3. Objetivos y no objetivos.
4. Cómo funciona hoy: cada hecho con cómo se sabe, fecha, commit y un comando para reverificarlo.
5. Inventario de reutilización y convenciones, con lo que se buscó.
6. Entorno: el estado y el responsable de cada elemento.
7. Opciones y recomendación.
8. Preguntas abiertas: elemento, responsable, momento.

Cada hecho se etiqueta como observado en el código, inferido o dicho por ti. Un vacío en la entrada o en el código se vuelve una pregunta abierta con responsable; la skill nunca inventa una respuesta. El trabajo cercano cuenta como dependencia hasta que digas lo contrario.

## Qué hay en la skill

| Archivo | Contenido |
|---|---|
| `SKILL.md` | Inicio (entrada, profundidad, solo lectura), los siete pasos con sus puntos de control, el brief, las reglas |
| `references/steps.md` | Por paso: señales a buscar, pregunta del punto de control, fuentes |
| `references/brief-template.md` | Plantilla del brief sección por sección |
| `references/evidence.md` | Fuentes y nivel de respaldo detrás de cada paso, y los casos de Jira |
| `agents/openai.yaml` | Política de solo manual para Codex |

## Límites

- Solo lectura sobre tu repo, Jira y Confluence: no escribe nada ahí.
- No decide. Propone y recomienda; tú decides y la decisión queda en la spec.
- No es un plan de implementación ni la spec: sin pasos de código ni criterios de aceptación. Entrega el brief validado a [`writing-tech-specs`](writing-tech-specs.es.md).
- La evidencia de Jira detrás de las heurísticas viene de un solo equipo.
- No se probó en bases de código reales grandes, ni leyendo Jira o Confluence reales, ni en Codex. Ver [lo que no cubre](../../tests/discovering-tech-changes/README.md#not-covered).

## Pruebas

```bash
bash tests/discovering-tech-changes/check-structure.sh
bash tests/discovering-tech-changes/check-scenarios.sh
```

Diez escenarios de presión (se ejecutan a mano con un runner y un evaluador aparte) y su resultado están en [`tests/discovering-tech-changes/`](../../tests/discovering-tech-changes/README.md). Resultado: 9 de 10 escenarios pasan con la skill (ejecuciones sobre commits mixtos de la skill; ver «No cubierto» en el README de tests); 5 de 10 discriminan frente a la línea base (los demás son guardas que un modelo fuerte también pasa sin la skill). El escenario `plain-language` aún pierde un punto: queda una ruta de directorio fuera de las columnas de evidencia, en una celda de "qué se buscó".
