---
name: verifying-spec-facts
description: Use when the user explicitly invokes /verifying-spec-facts or $verifying-spec-facts to check whether the facts a spec review flagged as old still hold in today's code
disable-model-invocation: true
---

# Verifying spec facts

Goal: tell the tech lead whether the old facts a spec rests on still hold in today's code. If they all hold, refresh their dates; if one changed, report it and send the developer to a new discovery. This skill never produces a brief and never decides which facts are old: the review does.

## Start
- Input: the feature folder `~/.specflow/<YYYY-MM-DD>-<slug>/` (`~/.specflow/` is a hidden folder: list it directly) and the repository whose code the brief describes. Ask for what is missing; if the user names no folder, list `~/.specflow/` and ask which one.
- Needs the folder's latest review: `review-<YYYY-MM-DD>.md` or `review-<YYYY-MM-DD>-<n>.md`, newest date first, then the highest suffix as a number (no suffix counts as 1) and `brief.md`. Read the report's `## Facts to re-verify` section by its heading, not by position. Never read a `brief-superseded-*.md`.
- No review report: ask the user for it. If there is none, point to `/reviewing-tech-specs` and stop. Do not run the age check yourself, do not read code, do not change any file.
- Read-only toward repositories: run searches and reads only, and for git always `git --no-optional-locks`. The only files you write are under `~/.specflow/`.

## Verify
Take only the facts listed in `## Facts to re-verify`, each matched to its row in the brief's section `How it works today` (section 4). For each fact:
1. Run the row's re-verify command, read-only, in the repository (do not run a command that could write; mark that fact **cannot verify**), and read the code the row points to.
2. Check the surroundings that could change it: other branches, specs and work in flight that touch the same code.
3. Label it **holds**, **changed** or **cannot verify** (command fails, code missing, repository not available), with the evidence: command and result, or file and line.

Compare the fact as the brief states it, in plain words, with what the code shows today. Do not trust the brief's own date or commit.

## Outcome
- **Every fact holds:** in `brief.md` change only the "Date and commit" cell of each flagged row, to today's date and the repository's current short commit (`git --no-optional-locks rev-parse --short HEAD`). Nothing else in the brief changes (no other cell, row or section, not the header). Write no report and no new brief. Say that the facts hold, which dates were updated, and that the facts are current: continue with the review's `## Next step` (do not say the spec can freeze; the review may have other findings).
- **Any fact changed or cannot be verified** ("cannot verify" counts as changed for routing): write `~/.specflow/<feature>/verify-<YYYY-MM-DD>.md` (today's date; if that name exists, use `verify-<YYYY-MM-DD>-2.md`, then `-3`, and so on, and never overwrite an existing file) with these headings, in this order, and do not touch `brief.md` (not even the dates of the facts that hold):
  - `## Facts that changed`: for each one, the fact in plain words, what the brief says, what the code shows today, and the evidence. A "cannot verify" fact says why. Facts that hold are not listed anywhere in the report, not even as a note or in another section; say which ones hold in the answer only.
  - `## Decisions affected`: the spec decisions that depend on each listed fact, taken from the review report.
  - `## Next step`: `/discovering-tech-changes` for a new brief, then `/writing-tech-specs` for the new spec.

  Give the same summary in the answer. A brief that is partly false is not patched, even if the developer asks: the correction is a new discovery.

## Rules
- Never invent: every label rests on a command result or code you read.
- Never edit anything but the date and commit cells of flagged rows, and only when every flagged fact holds.
- Never produce a brief and never write inside the user's repository.
- Never widen the scope beyond the facts the review flagged; mention anything else you notice as a note only.
