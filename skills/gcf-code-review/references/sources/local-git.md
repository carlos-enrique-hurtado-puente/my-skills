# Source: Local branch

Read only when no PR URL was given: the target is the current git branch (`HEAD`).

## Rules for this source

1. **Read-only.** Run only read-only commands, such as `rev-parse`, `symbolic-ref`, `status`, `log`, `rev-list`, `merge-base`, `diff`, `show`, `for-each-ref`, `remote`, `grep`, `ls-tree`, `cat-file`. The binding rule is this: a command that writes to the repo, the index, the worktree or a ref is out of scope: `checkout`, `switch`, `stash`, `commit`, `fetch`, `pull`, `reset`, `restore`, `clean`, `merge`, `rebase`, `worktree`, `add`, `branch -f`.
2. **Only `HEAD` is reviewed.** Another branch is reviewed after the user checks it out and reruns the skill.
3. **Full files come from git objects:** `git show HEAD:<path>`; for a file deleted on the branch, `git show <merge-base>:<path>`. The working tree is never read, so local edits cannot leak into the review.
4. **Missing context is read with `git show`**, never by switching branches.

## Prerequisites

The script checks them (repository, commits, attached `HEAD`, uncommitted changes) and reports them in `status:` and `uncommitted:` (see Base).

## Base

Run `bash <skill-dir>/scripts/detect-base.sh [base]` from inside the repo (`<skill-dir>` is the folder containing SKILL.md; pass `base` only when the user gave one). The script is the only way to pick a base: never compute candidates, counts or the base by hand, and never replace it with `origin/HEAD`. It prints `key: value` lines.

What it decides, for humans: candidates are `develop`, `main`, `master` and the `origin/HEAD` target, each as `origin/<x>` if that remote ref exists, else local `<x>`; the base is the one with the fewest commits ahead of it, then fewest behind, then the `origin/HEAD` target, then the order `develop`, `main`, `master`. A user `base` containing `/` or starting with `refs/` is used as-is; a bare name tries `origin/<name>` then `<name>`. No `git fetch`.

| `status:` | Action |
|---|---|
| `ok` | Build the confirmation from the fields. |
| `nothing-to-review` | Say there is nothing to review against `base`. No report, no confirmation. |
| `detached` | Tell the user `HEAD` is detached; ask them to check out the branch and rerun. No report. |
| `base-unresolved` | Say the given base does not resolve and ask for another. |
| `no-candidate` | Ask for the base; with no answer, `BLOCKED`. |
| `not-a-repo`, `unborn`, `unrelated` | `BLOCKED` with the script's `message:`. |

Rerun the script with the user's base when they name a different one.

## Data

```bash
git log --reverse --format='%h %s%n%b' <base>..HEAD     # commit messages = context, like a PR description
git diff --stat <base>...HEAD
git diff <base>...HEAD                                  # source of the changes
git show HEAD:<path>                                    # full file, new version
git show <merge-base>:<path>                            # deleted file, old version
```

Review prior context in the commit messages. Files in the diff are the only files reviewed: a file changed on the base after the merge-base never appears in `<base>...HEAD`.

## Confirmation

Taken from the script output (status `ok`), as **one** message with these parts in this order, then stop and wait:

1. `` `<branch>` against `<base>` ``.
2. Every `candidate:` line as `<ref>: <ahead> ahead, <behind> behind`, the `chosen` one marked (`candidate: origin/develop 3 1 chosen` becomes `origin/develop: 3 ahead, 1 behind (chosen)`).
3. `merge_base`, `commits` commits, `files` files of which `deleted` deleted.
4. Only if `base_is_remote: yes`: `base_date` as the date of the base's last commit.
5. Only when a spec was given: its outcome, read before this message. Read from `<source>`, or could not be read (say why) and ask for it as markdown (path or pasted) or for confirmation to review without it (Spec step of the workflow).
6. Only if `uncommitted: yes`: a warning that uncommitted or untracked changes are not part of the review. The report's `Limitations` repeats it, also when this confirmation is skipped.
7. The closing choice: confirm, change the base, or did you mean to review a PR?

If the invocation message already confirms (for example "confirm, review now"), skip the wait and proceed; the facts still go in the report header. Exception: when a given spec could not be read, stop and ask. If the user names a different base, rerun the script with it and confirm again.

## Header fields (section 1)

`Source: Local branch`, then: Repo, Head branch, HEAD, Base ref, Merge-base, Commits reviewed. `PR comments reviewed: N/A`.

## BLOCKED when

- Not a git repository.
- No base can be determined and the user does not give one.
- `git merge-base <base> HEAD` exits non-zero (unrelated histories), or `HEAD` is unborn.
- A spec rule from SKILL.md applies.
