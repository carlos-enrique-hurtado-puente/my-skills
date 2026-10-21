## Análisis del cambio

- **Estado de la revisión:** `COMPLETED`
- **Fuente:** `Rama local`
- **Fuente de la spec:** `ninguna`
- **Repo:** `fx-gen`
- **Rama head:** `feature/orders-pubsub`
- **HEAD:** `aac920d`
- **Ref base:** `origin/develop` (último commit de la base: 2026-01-06; candidatos: `origin/develop`: 3 por delante, 1 por detrás (elegido))
- **Merge-base:** `1ab735e`
- **Commits revisados:** `3`
- **Stack(s):** `GCP Cloud Functions — pieza; skills: ninguna declarada`
- **Generation:** `Gen 2` (import de `firebase-functions/v2/pubsub`)
- **Runtime:** `Indeterminado` (sin `engines.node` en `functions/package.json`, sin `firebase.json`, `.nvmrc` ni IaC)
- **Trigger(s):** `Pub/Sub, topic "orders" (onMessagePublished)`
- **Archivos relevantes:** `functions/src/onOrderCreated.ts` (nuevo), `functions/package.json` (modificado), `functions/src/legacy.ts` (eliminado)
- **Resumen funcional:** Se añade el handler Gen 2 `onOrderCreated`, que recibe mensajes del topic `orders` y persiste el payload JSON en la colección Firestore `orders` con un campo `receivedAt`. Se añade la dependencia `zod` (sin uso) y se elimina el helper `legacyTotal`, que ya no tiene referencias en `HEAD`.
- **Spec revisada:** `no`
- **Comentarios de PR revisados:** `N/A`
- **Limitaciones:** No se proporcionó spec (existe `docs/order spec.md` en el repo, pero no se pasó como `spec` y no se evaluó). Runtime indeterminado. No hay lockfile en el repo, por lo que no se puede verificar la resolución de `zod`. Modo local: no se revisó CI. Los comportamientos dependientes de la generación (política de reintentos por defecto de `onMessagePublished`) no se verificaron en documentación oficial. No hay cambios sin commitear.

## Hallazgos

| # | Archivo | Línea(s) / Referencia | Tipo | Severidad | Comentario a publicar |
|---|------|---------------------|------|----------|-----------------|
| 1 | `functions/src/onOrderCreated.ts` | `11` | `issue` | `blocking` | `issue (blocking): El catch {} vacío se traga cualquier error de la escritura en Firestore (timeout, cuota, UNAVAILABLE, permisos). La función termina con éxito, Pub/Sub da el mensaje por entregado y el pedido se pierde sin rastro. Escenario: Firestore devuelve un error transitorio y el pedido nunca se guarda. Corrección: eliminar el try/catch o relanzar el error (tras loguearlo) para que la invocación falle y, con reintentos activados, el mensaje se reentregue; distinguir errores permanentes (payload inválido: loguear y descartar/enviar a dead-letter) de transitorios (propagar).` |
| 2 | `functions/src/onOrderCreated.ts` | `7-10` | `issue` | `blocking` | `issue (blocking): La escritura no es idempotente: collection("orders").add() crea un documento con ID aleatorio en cada entrega. Pub/Sub entrega al menos una vez, así que un mensaje duplicado o reintentado genera pedidos duplicados. Corrección: usar un ID determinista, p. ej. collection("orders").doc(event.id).create({...}) (o el ID de pedido del payload) y tratar ALREADY_EXISTS como éxito, de modo que reentregas no dupliquen datos.` |
| 3 | `functions/src/onOrderCreated.ts` | `5, 8` | `issue` | `blocking` | `issue (blocking): El payload no se valida: event.data.message.json se esparce tal cual (...order) en el documento. Un mensaje con campos inesperados, tipos erróneos o sin campos obligatorios se persiste igualmente, contaminando la colección y rompiendo el contrato con sus consumidores; si el mensaje no es JSON, el acceso a .json lanza fuera del try y el mensaje se convierte en poison pill si hay reintentos. Corrección: parsear con un esquema explícito (zod ya se añade en package.json, ver hallazgo 6), mapear solo los campos conocidos y rechazar como error permanente (log + ack o dead-letter) lo que no cumpla el esquema.` |
| 4 | `functions/src/onOrderCreated.ts` | `onOrderCreated` | `issue` | `blocking` | `issue (blocking): No hay ningún test para el nuevo handler. Al ser un trigger de eventos que escribe datos, faltan tests críticos de idempotencia y reintentos: entrega duplicada del mismo evento (un solo documento), error transitorio de Firestore (la invocación debe fallar), payload inválido/no JSON (descartado sin reintento infinito). Añadirlos con el emulador de Firestore o un repositorio inyectado.` |
| 5 | `functions/src/onOrderCreated.ts` | `4` | `question` | `non-blocking` | `question (non-blocking): ¿Están activados los reintentos y hay dead-letter topic para esta suscripción? onMessagePublished("orders", ...) no declara retry ni otras opciones, y no hay IaC en el repo que lo configure. Sin reintentos, corregir el hallazgo 1 no evita la pérdida de mensajes; con reintentos y sin dead-letter, un mensaje inválido puede reintentarse indefinidamente. Confirmar la configuración deseada (p. ej. onMessagePublished({ topic: "orders", retry: true }, ...) más un DLQ) contra la documentación de Gen 2.` |
| 6 | `functions/package.json` | `7` | `issue` | `non-blocking` | `issue (non-blocking): Se añade zod como dependencia de producción pero ningún archivo de HEAD lo importa. Es peso muerto en el bundle y en cold starts, y el commit "chore: add zod dependency" sugiere que la validación quedó sin hacer. Usarlo en onOrderCreated.ts para validar el payload (ver hallazgo 3) o eliminarlo de este cambio.` |
| 7 | `functions/src/onOrderCreated.ts` | `6-11` | `issue` | `non-blocking` | `issue (non-blocking): El handler no emite ningún log: ni el éxito, ni el error capturado, ni el ID del evento. Ante un pedido perdido o duplicado no hay forma de diagnosticarlo. Añadir logs estructurados con firebase-functions/logger que incluyan event.id, el topic y el ID de pedido, con severidad error en los fallos.` |
| 8 | `functions/src/onOrderCreated.ts` | `4` | `question` | `non-blocking` | `question (non-blocking): No existe functions/src/index.ts en HEAD, y package.json declara "main": "lib/index.js". ¿Dónde se exporta onOrderCreated para que Firebase lo despliegue? Si no se reexporta desde el entry point, la función no se desplegará. Confirmar o añadir el export en el índice.` |
| 9 | `functions/src/onOrderCreated.ts` | `9` | `nitpick` | `nitpick` | `nitpick (nitpick): receivedAt usa Date.now() (milisegundos numéricos de la instancia). Para ordenar y consultar por fecha en Firestore es más consistente FieldValue.serverTimestamp(), o event.time si se quiere la hora de publicación.` |

## Resumen ejecutivo

- **Total de hallazgos:** 9
- **Blocking:** 4
- **Non-blocking:** 4
- **Nitpick:** 1
- **Diagnóstico de Clean Architecture:** 2/7
- **Nivel de arquitectura:** `Acoplamiento relevante`

### Veredicto

Requiere rehacer

### Justificación

El nuevo trigger Pub/Sub carece de estrategia de integridad de datos y de reintento seguro: se traga los errores (pérdida silenciosa de pedidos, hallazgo 1), escribe con IDs aleatorios (duplicados en reentregas, hallazgo 2) y persiste el payload sin validar (hallazgo 3), todo ello sin tests (hallazgo 4). En arquitectura, el handler mezcla transporte y persistencia y vuelca el payload externo directamente en el documento (solo se cumplen la ausencia de ciclos y que no hay capas internas dependiendo de infraestructura); al ser una función pequeña no se exige una capa de dominio, pero sí validar y mapear en el borde. Debe rehacerse con escritura idempotente keyed por event.id, validación con zod, propagación de errores transitorios, configuración explícita de reintentos/dead-letter y tests de duplicados y fallos. La eliminación de legacy.ts es segura: no quedan referencias.
