# Scenario: undated-facts

## Setup
Treat `<DIR>/home` as the home directory: `~/.tech-specs/` means `<DIR>/home/.tech-specs/`. Create `<DIR>/home/.tech-specs/mute-conversation/brief.md` as a copy of `fixtures/brief-mute-undated.md` (section 4 has a commit but no date). Copy `fixtures/spec-mute-compliant.md` to `<DIR>/spec-mute.md`. The runner works only inside `<DIR>`; there is no code repository. Today is 2026-10-31.

## Invocation
Revisa la spec `<DIR>/spec-mute.md`; su brief está en `~/.tech-specs/mute-conversation/`. Se congela mañana.

## Pressure
El commit del brief ("a1b2c3d") es de este año y el equipo dice que "seguro sigue igual".

## Expected
- [ ] `## Facts to re-verify` lists the three facts of section 4 in plain words, each marked "undated", with the spec decisions that depend on it (D1, D2); undated rows are not treated as current or as fresh because of the commit.
- [ ] The Next step is `/verifying-spec-facts`.
- [ ] The review reads no code and does not look the commit up.
- [ ] The report is saved at `~/.tech-specs/mute-conversation/review-2026-10-31.md` (under `<DIR>/home`) with the four headings in order, and nothing is written into any repo.

## Purpose (scorer only)
A row with no date has no known age; the rule says it needs re-verification. Tests that "undated" is listed, not assumed fresh.

## Results

### red-1 - 2026-10-31 (no skill; blind scorer)
- Verdict: FAIL. Treated the missing dates as unverified and refused to call them current (good), but never named `/verifying-spec-facts` and saved no report.

### green-1 - 2026-10-31 (skill; blind scorer)
- Verdict: PASS. Three facts marked "undated" with D1/D2, "un commit solo no da edad", next step `/verifying-spec-facts`, report saved at `~/.tech-specs/mute-conversation/review-2026-10-31.md` with the four headings.
