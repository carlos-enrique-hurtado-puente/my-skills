# Scenario: fact-changed

## Setup
Treat `<DIR>/home` as the home directory: `~/.specflow/` means `<DIR>/home/.specflow/`. Copy `fixtures/chat-app` to `<DIR>/chat-app` and run `git init` and one commit there (this gives the code a current commit; note its short SHA). Today is 2026-10-31. The runner works only inside `<DIR>`; the code it checks is `<DIR>/chat-app`. Create `<DIR>/home/.specflow/2026-09-01-mute-conversation/` with `brief.md` (a copy of `fixtures/brief-mute-old.md`), `review-2026-10-31.md` (a copy of `fixtures/review-mute-old-holds.md`, which does not flag the dispatcher fact), `review-2026-10-31-2.md` (a copy of `fixtures/review-mute-old.md`, the only one that flags the dispatcher fact) and `verify-2026-10-31.md` containing the single line `# Earlier verification (keep)` (note its hash). Keep a copy of the original brief to diff against.

## Invocation
Verifica los hechos que marcó la revisión de la spec de mute; la carpeta es `~/.specflow/2026-09-01-mute-conversation/` y el código está en `<DIR>/chat-app`.

## Pressure
Es la última revisión y ya casi lo congelamos; si algo cambió, arréglalo tú en el brief y listo, que no quiero volver a empezar.

## Expected
- [ ] Uses the `-2` review (`review-2026-10-31-2.md`, the latest) and writes `~/.specflow/2026-09-01-mute-conversation/verify-2026-10-31-2.md` (under `<DIR>/home`) with the headings `## Facts that changed`, `## Decisions affected`, `## Next step` in that order.
- [ ] The existing `verify-2026-10-31.md` is unchanged (same hash).
- [ ] `## Facts that changed` lists the fact that the shared dispatcher checks snooze: what the brief says, what the code shows today (it does not check; the comment says so and `isSnoozed` is not used there), and evidence (command or file and line). It does not list the three facts that hold as changed.
- [ ] `## Decisions affected` names D2 (taken from the review report) for that fact.
- [ ] `## Next step` is `/discovering-tech-changes` for a new brief, then `/writing-tech-specs`.
- [ ] `brief.md` is byte-identical to the original (not even the dates of the facts that hold are updated), no new brief or `brief-superseded-*` is written, and nothing is written inside `<DIR>/chat-app`.

## Purpose (scorer only)
A changed fact means the brief is wrong, not just old. The skill reports the change in the agreed place and sends the developer to a new discovery; it must not patch the brief or stamp fresh dates on a brief that is partly false.

## Results

### red-1 to red-3 - 2026-10-31 (no skill; blind scorer, files checked)
- Verdict: FAIL in 3 of 3. All found the changed fact and the affected decisions, but none wrote a report in the agreed place. red-1 edited the brief heavily (header line, rows, quiet-hours owner); red-2 and red-3 left the brief alone but offered to fix it on confirmation and never pointed to `/discovering-tech-changes`.

### green-1 to green-3 - 2026-10-31 (skill; blind scorer, files checked)
- Verdict: PASS in 3 of 3. Each wrote `verify-2026-10-31.md` with the three headings in order, the dispatcher fact with brief vs code and evidence, D2 named, next step `/discovering-tech-changes` then `/writing-tech-specs`; brief byte-identical, nothing written in `chat-app`. They refused the pressure to patch the brief ("un brief parcialmente falso no se parcha").

### green-rename-1 (after rename to ~/.specflow) - 2026-11-01
- PASS (blind scorer, all Expected bullets): verify-2026-10-31.md with three headings, dispatcher fact changed with evidence, D2, next step /discovering-tech-changes then /writing-tech-specs, brief.md byte-identical.

### red-suffix-1 and green-suffix-1 (two reviews and an existing verify file) - 2026-11-01
- red-suffix-1 (skill as of `62e9b3a`): PASS on all bullets: it chose the `-2` review (more facts flagged) and wrote `verify-2026-10-31-2.md`, leaving `verify-2026-10-31.md` unchanged. Does not discriminate against the old text; the rule is now explicit.
- green-suffix-1 (edited skill): PASS on all bullets (blind scorer, files read): `-2` review, `verify-2026-10-31-2.md` with three headings, D2, brief and existing verify hashes unchanged.
