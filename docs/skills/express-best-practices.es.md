# express-best-practices

[English](express-best-practices.md) | **Español**

> La versión principal es la [inglesa](express-best-practices.md); este archivo es una traducción.

Reglas para escribir, cambiar y revisar código Express.js (middleware, rutas, errores, sesiones, seguridad, producción) en Express 4 o 5. Código: [`skills/express-best-practices/`](../../skills/express-best-practices/SKILL.md).

## Uso

En Claude Code: `/express-best-practices`. En Codex: `$express-best-practices`. La skill es solo manual: nunca se carga con un prompt implícito.

```text
/express-best-practices añade una ruta POST /login con sesiones
/express-best-practices revisa src/ para producción
/express-best-practices añade una ruta async que lea un usuario de la base de datos
```

Al escribir código, la skill implementa todas las reglas oficiales (`O`) que aplican, valida la entrada en el borde HTTP y termina su respuesta con una sección `Rules applied`: una línea por regla, ya sea `ID: path/to/file.js:LINE` o `ID: NOT MET: "<tus palabras>"` cuando descartaste explícitamente lo que la regla necesita (por ejemplo una dependencia). Al revisar, reporta cada violación como ID de regla, `file:line` y corrección, con el formato de reporte de `stack-code-review` si esa skill está instalada.

## Cómo se detecta la versión de Express

La skill ejecuta `scripts/detect-express-version.sh` desde la raíz del proyecto. Imprime una línea por cada paquete que declara `express` y luego una línea de estado:

```text
express: major=5 resolved=5.1.0 declared=^5.0.0 dir=.
status: ok
```

- `status: no-express` o `status: error`: la skill lo reporta y se detiene.
- Cada archivo sigue la línea `express:` cuyo `dir` es su ancestro más cercano, así que un monorepo con paquetes en Express 4 y Express 5 recibe las reglas correctas por paquete. Los handlers nunca se copian entre versiones mayores sin cambios.
- `major=unknown` (o una versión mayor distinta de 4 o 5): la skill indica "Express major could not be determined" con el rango `declared`, no carga ningún archivo de versión y no afirma una versión única.
- `resolved` sale de `package-lock.json` y prevalece sobre `declared`. Solo se lee `package-lock.json`: con lockfiles de yarn o pnpm no hay `resolved` y la versión mayor sale del rango declarado (`unknown` si el rango no da una versión mayor, como `latest`).
- En un workspace con un único `package-lock.json` en la raíz, todos los paquetes reciben la versión `resolved` elevada (hoisted) de la raíz. Eso puede sobrescribir la versión mayor que un paquete declara por su cuenta.

## Alcance

Dentro del alcance: la mecánica de Express y HTTP, como el orden del middleware, el middleware de errores, el manejo de errores async, el parseo del body, la validación de entrada en el borde HTTP, sesiones y cookies, headers, proxies, redirecciones, rate limiting, logging, apagado ordenado y health checks.

Fuera del alcance: estructura, capas, nombres y dónde va el código. Eso corresponde a las skills `clean-architecture` y `clean-code`. La skill mantiene los handlers de ruta delgados, no da consejos de organización y reporta los conflictos entre las reglas de Express y la estructura del proyecto en lugar de elegir en silencio.

## Niveles de evidencia

Cada regla es una fila de tabla en `skills/express-best-practices/references/` con un ID, la regla, un nivel y una fuente:

- `O`: documentación oficial de Express (expressjs.com). La skill las implementa en código.
- `C`: referencia de la comunidad, [nodebestpractices](https://github.com/goldbergyoni/nodebestpractices).

Las fuentes y el razonamiento están en [`docs/2026-10-19-express-best-practices-research.md`](../2026-10-19-express-best-practices-research.md); el diseño, en [`docs/2026-10-19-express-best-practices-design.md`](../2026-10-19-express-best-practices-design.md).

## Añadir o cambiar una regla

Añade o edita una fila de tabla (ID, regla, nivel, fuente) en el archivo correspondiente de `skills/express-best-practices/references/` (`express-4.md`, `express-5.md`, `request-handling.md`, `errors.md`, `security.md`, `production.md`). Después ejecuta:

```bash
bash tests/express-best-practices/check-structure.sh
```

## Evidencia de pruebas

La skill se probó en 9 escenarios de presión, cada uno ejecutado por un agente que nunca ve el resultado esperado y puntuado por un agente evaluador aparte. 4 escenarios discriminan (el modelo falla sin la skill y pasa con ella): `login-v5`, `async-v4`, `with-clean-architecture` y `login-v5-no-deps`. Los otros 5 son guardas: comprueban que la skill no se comporta mal (sin consejos de estructura, sin adivinar la versión, sin imponer hábitos de Express 4 a Express 5) y también pasan sin la skill, así que no son evidencia de que la skill ayude.

Los modelos ya escriben correctamente la sintaxis de rutas de Express 5 y detectan la mayoría de los puntos en una revisión de producción sin la skill. La mejora medida está en el endurecimiento de sesiones y cookies, el rate limiting, la validación en el borde HTTP bajo una skill de arquitectura, la completitud del middleware de errores y el reporte de lo que no se pudo hacer. Cada escenario que discrimina pasó en 3 de 3 repeticiones con la skill. Detalles y salvedades: [`tests/express-best-practices/README.md`](../../tests/express-best-practices/README.md).

```bash
bash tests/express-best-practices/check-structure.sh
bash tests/express-best-practices/test-detect-version.sh
```
