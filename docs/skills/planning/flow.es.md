# Flujo de planning: de la idea a la spec, y de vuelta

[English](flow.md) | **Español**

Cómo trabajan juntas las skills de planning. Diseño y razones: [docs/plans/2026-10-31-spec-flow-redesign-design.md](../../plans/2026-10-31-spec-flow-redesign-design.md).

```mermaid
flowchart TD
    subgraph F1["Flujo 1: de la idea a la spec"]
      Q0{"¿Hay brief?"} -- "No, y declina el discovery" --> STOP["Se detiene, no escribe nada"]
      Q0 -- "No, acepta" --> DISC
      Q0 -- "Sí" --> WRITE
      IN["FRD, HU, ticket, solo la idea<br/>o una spec (nuestra o externa)"] --> DISC["/discovering-tech-changes<br/>única skill que produce briefs<br/>lee código"]
      DISC --> BRIEF["~/.specflow/&lt;fecha&gt;-&lt;feature&gt;/brief.md<br/>el 'qué' y el 'cómo': objetivos, opciones,<br/>archivos, funciones, commits, fechas,<br/>comandos de re-verificación"]
      BRIEF --> WRITE["/writing-tech-specs<br/>no lee código"]
      WRITE --> SPEC["Spec: solo el 'qué'<br/>comportamiento de hoy y de qué depende<br/>cada decisión; sin código ni fechas"]
    end

    subgraph F2["Flujo 2: ya existe una spec"]
      S2["Spec existente + su brief"] --> REV["/reviewing-tech-specs<br/>no lee código"]
      REV --> FORM{"¿La spec cumple P1–P9?"}
      REV --> AGE{"¿Hechos del brief con<br/>más de ~3 semanas?"}

      AGE -- "No" --> FRESH["Hechos al día"]
      AGE -- "Sí" --> VER["/verifying-spec-facts<br/>lee código con los hechos y<br/>comandos del brief"]
      VER -- "Todo vigente" --> DATES["Actualiza las fechas del brief<br/>automáticamente"]
      VER -- "Algo cambió" --> REPV["Informe: qué hecho cambió<br/>y qué decisiones afecta"]
      REPV --> DISC2["/discovering-tech-changes<br/>brief nuevo"] --> WRITE2["/writing-tech-specs<br/>spec nueva"]

      FORM -- "Sí" --> PASS["Puede congelarse<br/>(si los hechos están al día)"]
      FORM -- "No" --> REPF["Informe de la review:<br/>qué regla falla y por qué"]
      REPF --> WRITE3["/writing-tech-specs<br/>desde el mismo brief,<br/>con el informe como contexto"]
    end

    SPEC -. "semanas después" .-> S2
```

## Las cuatro skills

| Skill | Hace | Lee código | Escribe |
|---|---|---|---|
| `discovering-tech-changes` | Produce el brief | Sí | El brief en `~/.specflow/` |
| `writing-tech-specs` | Escribe la spec desde un brief | No | La spec, y una copia local `spec.md` |
| `reviewing-tech-specs` | Revisa la spec contra P1–P9 y la antigüedad del brief | No | Informe de la review |
| `verifying-spec-facts` | Comprueba los hechos del brief en el código de hoy | Sí | Las fechas del brief, o un informe de qué cambió |

## La carpeta specflow

Todo lo que escriben las skills vive en `~/.specflow/` (oculta), una carpeta por feature:

```text
~/.specflow/
  <YYYY-MM-DD>-<slug>/                 una carpeta por feature
    brief.md                           discovering-tech-changes
    brief-superseded-<YYYY-MM-DD>.md   un brief anterior
    spec.md                            writing-tech-specs: copia local de la spec
    spec-superseded-<YYYY-MM-DD>.md    una spec anterior
    review-<YYYY-MM-DD>.md             reviewing-tech-specs
    verify-<YYYY-MM-DD>.md             verifying-spec-facts, solo si un hecho cambió
    repos.md                           reservado: repositorios de la feature
    plan-<repo>.md                     reservado: un plan por repositorio
    progress-<repo>.md                 reservado: un registro de avance por repositorio
```

- Carpeta de la feature: `<YYYY-MM-DD>-<slug>`, la fecha en que se creó; un slug de 2 a 5 palabras en minúsculas unidas por `-`, confirmado contigo. `<repo>` es el nombre de la carpeta del repositorio (por ejemplo `atom`, `atom-ui`).
- Nada se sobrescribe. Una skill que escribe un archivo que ya existe renombra primero el anterior a `<nombre>-superseded-<YYYY-MM-DD>.md` (la fecha escrita dentro del archivo anterior, o si no, su fecha de modificación; `-2`, `-3`... si ese nombre existe). Hoy aplica a `brief.md` y `spec.md`.
- Los informes tampoco se sobrescriben: un segundo informe el mismo día es `review-<YYYY-MM-DD>-2.md`, luego `-3`... "El más reciente" es la fecha más nueva y luego el sufijo más alto como número (sin sufijo cuenta como 1).
- `spec.md` empieza con `Published: <link o not published yet>` y `Copy date: <YYYY-MM-DD>`. `reviewing-tech-specs` revisa la spec que indicas; si no nombras ninguna, usa el `spec.md` de la carpeta y dice su origen y su fecha. Nunca lo escribe.
- Ninguna skill lee `*-superseded-*`.
- ¿Vienes del nombre anterior de la carpeta? Ejecuta una vez: `mv ~/.tech-specs ~/.specflow`. Si existen las dos carpetas, nada se une por ti.

## Reglas que atraviesan el flujo

- Siempre hay un brief, y solo `discovering-tech-changes` lo crea.
- La spec guarda el "qué", para personas, y perdura; el brief guarda el "qué" y el "cómo" con evidencia del código y fechas, para el agente. La spec sobrevive a un cambio de lenguaje o de implementación.
- Una spec puede ser la entrada de discovery. Una spec externa siempre se reescribe con `writing-tech-specs` desde el brief nuevo antes de planear, para que toda spec que llega a planear tenga el formato del equipo; una spec de este flujo se reescribe cuando el brief la corrige.
- Las skills nunca escriben en tus repos. Solo escriben en `~/.specflow/`, una carpeta por feature, así un cambio que toca backend y front tiene un solo brief.
- Las reglas P1–P9 están copiadas en `writing-tech-specs` y `reviewing-tech-specs`; un test falla si las copias difieren.
- Cada skill la inicias tú; ninguna se ejecuta sola.
