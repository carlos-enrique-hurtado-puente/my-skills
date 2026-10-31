# Flujo de planning: de la idea a la spec, y de vuelta

[English](flow.md) | **Español**

Cómo trabajan juntas las skills de planning. Diseño y razones: [docs/plans/2026-10-31-spec-flow-redesign-design.md](../../plans/2026-10-31-spec-flow-redesign-design.md).

```mermaid
flowchart TD
    subgraph F1["Flujo 1: de la idea a la spec"]
      Q0{"¿Hay brief?"} -- "No, y declina el discovery" --> STOP["Se detiene, no escribe nada"]
      Q0 -- "No, acepta" --> DISC
      Q0 -- "Sí" --> WRITE
      IN["FRD, HU, ticket o solo la idea"] --> DISC["/discovering-tech-changes<br/>única skill que produce briefs<br/>lee código"]
      DISC --> BRIEF["~/.tech-specs/&lt;fecha&gt;-&lt;feature&gt;/brief.md<br/>el 'cómo': archivos, funciones, commits,<br/>fechas, comandos de re-verificación"]
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
| `discovering-tech-changes` | Produce el brief | Sí | El brief en `~/.tech-specs/` |
| `writing-tech-specs` | Escribe la spec desde un brief | No | La spec |
| `reviewing-tech-specs` | Revisa la spec contra P1–P9 y la antigüedad del brief | No | Informe de la review |
| `verifying-spec-facts` | Comprueba los hechos del brief en el código de hoy | Sí | Las fechas del brief, o un informe de qué cambió |

## Reglas que atraviesan el flujo

- Siempre hay un brief, y solo `discovering-tech-changes` lo crea.
- El "qué" va en la spec; el "cómo" y sus fechas, en el brief. La spec sobrevive a un cambio de lenguaje o de implementación.
- Las skills nunca escriben en tus repos. Solo escriben en `~/.tech-specs/`, una carpeta por feature, así un cambio que toca backend y front tiene un solo brief.
- Las reglas P1–P9 están copiadas en `writing-tech-specs` y `reviewing-tech-specs`; un test falla si las copias difieren.
- Cada skill la inicias tú; ninguna se ejecuta sola.
