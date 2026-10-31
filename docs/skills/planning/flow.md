# Planning flow: from an idea to a spec, and back

**English** | [Español](flow.es.md)

How the planning skills work together. Design and reasons: [docs/plans/2026-10-31-spec-flow-redesign-design.md](../../plans/2026-10-31-spec-flow-redesign-design.md).

```mermaid
flowchart TD
    subgraph F1["Flow 1: from an idea to a spec"]
      Q0{"Is there a brief?"} -- "No, discovery declined" --> STOP["Stop, write nothing"]
      Q0 -- "No, discovery accepted" --> DISC
      Q0 -- "Yes" --> WRITE
      IN["FRD, user story, ticket or idea"] --> DISC["/discovering-tech-changes<br/>the only skill that creates briefs<br/>reads code"]
      DISC --> BRIEF["~/.tech-specs/&lt;date&gt;-&lt;feature&gt;/brief.md<br/>the how: files, functions, commits,<br/>dates, re-verify commands"]
      BRIEF --> WRITE["/writing-tech-specs<br/>does not read code"]
      WRITE --> SPEC["Spec: only the what<br/>today's behavior and what each decision<br/>depends on; no code, no dates"]
    end

    subgraph F2["Flow 2: an existing spec"]
      S2["Existing spec + its brief"] --> REV["/reviewing-tech-specs<br/>does not read code"]
      REV --> FORM{"Does the spec meet P1-P9?"}
      REV --> AGE{"Brief facts older<br/>than ~3 weeks?"}

      AGE -- "No" --> FRESH["Facts current"]
      AGE -- "Yes" --> VER["/verifying-spec-facts<br/>reads code with the brief's<br/>facts and commands"]
      VER -- "All hold" --> DATES["Updates the brief's dates<br/>automatically"]
      VER -- "Something changed" --> REPV["Report: which fact changed<br/>and which decisions it affects"]
      REPV --> DISC2["/discovering-tech-changes<br/>new brief"] --> WRITE2["/writing-tech-specs<br/>new spec"]

      FORM -- "Yes" --> PASS["Can freeze<br/>(if facts are current)"]
      FORM -- "No" --> REPF["Review report:<br/>which rule fails and why"]
      REPF --> WRITE3["/writing-tech-specs<br/>from the same brief,<br/>with the report as context"]
    end

    SPEC -. "weeks later" .-> S2
```

## The four skills

| Skill | Does | Reads code | Writes |
|---|---|---|---|
| `discovering-tech-changes` | Produces the brief | Yes | The brief in `~/.tech-specs/` |
| `writing-tech-specs` | Writes the spec from a brief | No | The spec |
| `reviewing-tech-specs` | Checks the spec against P1-P9 and the brief's age | No | A review report |
| `verifying-spec-facts` | Checks the brief's facts against today's code | Yes | The brief's dates, or a report of what changed |

## Rules across the flow

- There is always a brief, and only `discovering-tech-changes` creates one.
- The "what" goes in the spec; the "how" and its dates go in the brief. A spec survives a change of language or implementation.
- Skills never write to your repositories. They write only under `~/.tech-specs/`, one folder per feature, so a change across backend and front has one brief.
- Rules P1-P9 are copied in `writing-tech-specs` and `reviewing-tech-specs`; a test fails if the copies differ.
- You start each skill yourself; none runs implicitly.
