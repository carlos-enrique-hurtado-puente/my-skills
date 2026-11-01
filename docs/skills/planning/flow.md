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
      DISC --> BRIEF["~/.specflow/&lt;date&gt;-&lt;feature&gt;/brief.md<br/>the how: files, functions, commits,<br/>dates, re-verify commands"]
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
| `discovering-tech-changes` | Produces the brief | Yes | The brief in `~/.specflow/` |
| `writing-tech-specs` | Writes the spec from a brief | No | The spec, and a local copy `spec.md` |
| `reviewing-tech-specs` | Checks the spec against P1-P9 and the brief's age | No | A review report |
| `verifying-spec-facts` | Checks the brief's facts against today's code | Yes | The brief's dates, or a report of what changed |

## The specflow folder

Everything the skills write lives in `~/.specflow/` (hidden), one folder per feature:

```text
~/.specflow/
  <YYYY-MM-DD>-<slug>/                 one folder per feature
    brief.md                           discovering-tech-changes
    brief-superseded-<YYYY-MM-DD>.md   an older brief
    spec.md                            writing-tech-specs: local copy of the spec
    spec-superseded-<YYYY-MM-DD>.md    an older spec
    review-<YYYY-MM-DD>.md             reviewing-tech-specs
    verify-<YYYY-MM-DD>.md             verifying-spec-facts, only when a fact changed
    repos.md                           reserved: repositories of the feature
    plan-<repo>.md                     reserved: one plan per repository
    progress-<repo>.md                 reserved: one progress ledger per repository
```

- Feature folder: `<YYYY-MM-DD>-<slug>`, the date it was created; a slug of 2 to 5 lowercase words joined by `-`, confirmed with you. `<repo>` is the repository's folder name (for example `atom`, `atom-ui`).
- Nothing is overwritten. A skill that writes a file which already exists first renames the old one to `<name>-superseded-<YYYY-MM-DD>.md` (the date written inside the old file, else its modification date; `-2`, `-3`... if that name exists). Today this applies to `brief.md` and `spec.md`.
- Reports never overwrite either: a second one on the same day is `review-<YYYY-MM-DD>-2.md`, then `-3`... "The latest" report is the newest date, then the highest suffix as a number (no suffix counts as 1).
- `spec.md` starts with `Published: <link or not published yet>` and `Copy date: <YYYY-MM-DD>`. `reviewing-tech-specs` reviews the spec you point to; if you name none, it uses the folder's `spec.md` and says its source and date. It never writes it.
- No skill reads `*-superseded-*`.
- Coming from the old folder name? Run once: `mv ~/.tech-specs ~/.specflow`. If both folders exist, nothing is merged for you.

## Rules across the flow

- There is always a brief, and only `discovering-tech-changes` creates one.
- The "what" goes in the spec; the "how" and its dates go in the brief. A spec survives a change of language or implementation.
- Skills never write to your repositories. They write only under `~/.specflow/`, one folder per feature, so a change across backend and front has one brief.
- Rules P1-P9 are copied in `writing-tech-specs` and `reviewing-tech-specs`; a test fails if the copies differ.
- You start each skill yourself; none runs implicitly.
