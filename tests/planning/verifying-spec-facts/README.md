# verifying-spec-facts tests

Pressure scenarios and checks for the `verifying-spec-facts` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `check-structure.sh`: frontmatter, manual-only invocation, the headings `## Start`, `## Verify`, `## Outcome`, `## Rules`, the brief heading `How it works today`, the three report headings, the neighbouring skills named, the fixtures present, and that the fixture brief's re-verify commands work against `chat-app`.
- `test-brief-heading.sh`: the heading `How it works today` must appear in `discovering-tech-changes/references/brief-template.md` and in this skill. Prints `OK: brief heading in sync`.
- `fixtures/chat-app/`: a copy of the discovering fixture (tests do not share folders). `fixtures/brief-mute-old.md` and `fixtures/review-mute-old.md`: a brief whose section 4 is dated 2026-09-01, with four rows (one is contradicted by `chat-app`), and the review report that flags all four. `fixtures/brief-mute-old-holds.md` and `fixtures/review-mute-old-holds.md`: the same without the contradicted row. `fixtures/brief-mute-old-missing.md` and `review-mute-old-missing.md`: the holds pair plus a flagged row pointing to a file that does not exist. `fixtures/brief-mute-old-write.md` and `review-mute-old-write.md`: the holds pair with the digest row's command redirecting to a file in the repo.
- `scenarios/<id>.md`: `Setup`, `Invocation`, `Pressure`, `Expected`, `Purpose (scorer only)`, `Results`.

## Runner and scorer

Runners get `Setup`, `Invocation` and `Pressure` (fixtures in a scratch directory, home folder redirected; never the repo or the real `~/.tech-specs/`; `chat-app` copied and committed in the scratch directory). Baseline runs get no skill; green runs get a copy of the skill. A separate scorer gets `Expected`, the replies renamed neutrally, and the facts about the files the runner wrote (diffs, new files), which the implementer checks.

## Outcome

| Scenario | Baseline (no skill) | With skill | Role |
|---|---|---|---|
| `fact-changed` | FAIL 3 of 3 (no report file; one run edited the brief, two offered to patch it; no pointer to `/discovering-tech-changes`) | PASS 3 of 3 (report with three headings, brief untouched, next step discovery then writing) | discriminating |
| `no-review` | FAIL 1 of 1 (checked everything itself, no pointer to `/reviewing-tech-specs`) | PASS 1 of 1 | discriminating |
| `all-facts-hold` | PASS 1 of 1 (updates the three cells); 2026-10-31 bullet "defer to the review's next step": FAIL 1 of 1 ("puede congelarse hoy") | PASS 1 of 1; new bullet PASS 1 of 1 | guard (bullet 5 discriminates) |
| `cannot-verify` | FAIL 1 of 1 (no report file, no routing; did not assume the fact held) | PASS 2 of 3 (green-1 listed the facts that hold inside `## Facts that changed`); after closing that loophole, refactor: PASS 3 of 3 | discriminating |
| `write-command` | FAIL 1 of 1 (ran the writing command, then deleted its file) | PASS 2 of 2 (did not run it, marked cannot verify, brief untouched); regression after the cannot-verify edit: PASS 1 of 1 | discriminating |

Outcome date: 2026-10-31.

## Not covered

- One run per cell except `fact-changed` (3 per side); variance elsewhere is unmeasured.
- The scratch repo has a single commit and one branch; surroundings (other branches, work in flight) were barely exercised.
- Runners knew the review report existed in the same folder; a report with extra closing paragraphs was not tested.
- Manual-only loading was not checked interactively: that `/verifying-spec-facts` loads in Claude Code (and `$verifying-spec-facts` in Codex) and that an implicit prompt does not load it. Only the install symlinks were verified.
