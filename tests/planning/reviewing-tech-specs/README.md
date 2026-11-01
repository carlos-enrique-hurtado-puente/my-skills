# reviewing-tech-specs tests

Pressure scenarios and checks for the `reviewing-tech-specs` skill, in the superpowers:writing-skills style. Nothing here is installed with the skill.

## Layout

- `check-structure.sh`: frontmatter, manual-only invocation, the nine rule lines, the headings `## Terms`, `## Rules`, `## Review`, `## Report`, the four report headings, the nine checklist lines, the "never read code" rule, the references, no ticket id, no personal names.
- `test-rules-sync.sh`: the P1-P9 lines, the numbered checklist and the four reference files must be identical to `writing-tech-specs`. Prints `OK: rules in sync` or one `FAIL:` line per difference.
- `scenarios/spec-from-folder.md` builds its folder with a `spec.md` whose first two lines are `Published:` and `Copy date:`. `old-facts` also checks that an existing same-day review is never overwritten (2026-11-01: passes on the old text too; the rule is written down anyway).
- `fixtures/seeded-spec.md`: a spec with twelve seeded defects (restored from history). `fixtures/spec-mute-compliant.md`: a made-up spec that complies with P1-P9. `fixtures/brief-mute-old.md` and `fixtures/brief-mute-undated.md`: briefs whose section 4 is dated 2026-09-01, or has no date.
- `scenarios/<id>.md`: `Setup`, `Invocation`, `Pressure`, `Expected`, `Purpose (scorer only)`, `Results`.

## Runner and scorer

Runners get `Setup`, `Invocation` and `Pressure` (fixtures in a scratch directory, home folder redirected; never the repo or the real `~/.specflow/`). Baseline runs get no skill; green runs get a copy of the skill. A separate scorer gets `Expected` and the replies renamed neutrally. Files a runner wrote are checked by the implementer.

## Outcome, 2026-10-31

| Scenario | Baseline (no skill) | With skill | Role |
|---|---|---|---|
| `old-facts` | FAIL 3 of 3 (age mentioned in prose; no checklist, no `/verifying-spec-facts`, no report file; invented form findings) | PASS 3 of 3 (report saved, four headings, facts with date and dependent decisions, next step `/verifying-spec-facts`). Caveat: the 3/3 GREEN relied on the implementer checking the saved files where the scorer saw only chat replies. 2026-10-31: new bullet "verdict does not say it can freeze while facts are stale" passes red and green (1 run each), so it does not discriminate here | discriminating |
| `spec-from-folder` | FAIL 3 of 3 on the strict bullet (link not stated; folder and date found) | PASS 3 of 3 | discriminating (link bullet) |
| `undated-facts` | FAIL 1 of 1 (facts not trusted, but no hand-off, no report) | PASS 1 of 1 | discriminating |
| `no-brief` | FAIL 1 of 1 (no checklist, no age statement, no pointer); 2026-10-31 bullet "no freeze on unchecked facts": FAIL 1 of 1 ("el texto puede congelarse") | PASS 1 of 1; new bullet PASS 1 of 1 | discriminating |
| `review-seeded-spec` | FAIL 1 of 1 on report shape only (finds the defects without the skill) | PASS 1 of 1 (12 of 12, guard held) | guard |

## Not covered

- One run per cell except `old-facts` (3 per side); variance elsewhere is unmeasured.
- Runners were told the date; the 21-day limit was never tested near its edge (for example a row 20 or 22 days old).
- The reference files were not exercised.
- A first round of `old-facts`, `undated-facts` and `no-brief` was discarded because the compliant fixture had open before-freeze questions that the reviewers rightly flagged; the fixture was fixed and every run redone.
- Manual-only loading was not checked interactively: that `/reviewing-tech-specs` loads in Claude Code (and `$reviewing-tech-specs` in Codex) and that an implicit prompt does not load it. Only the install symlinks were verified.
