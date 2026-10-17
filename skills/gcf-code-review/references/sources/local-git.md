# Source: Local branch

Read only when no PR URL was given: the target is the current git branch (`HEAD`).

## Rules for this source

1. **Read-only.** Run only git commands that read: `rev-parse`, `symbolic-ref`, `status`, `log`, `rev-list`, `merge-base`, `diff`, `show`, `for-each-ref`, `remote`. A command that writes to the repo, the index, the worktree or a ref is out of scope: `checkout`, `switch`, `stash`, `commit`, `fetch`, `pull`, `reset`, `restore`, `clean`, `merge`, `rebase`, `worktree`, `add`, `branch -f`.
2. **Only `HEAD` is reviewed.** Another branch is reviewed after the user checks it out and reruns the skill.
3. **Full files come from git objects:** `git show HEAD:<path>`; for a file deleted on the branch, `git show <merge-base>:<path>`. The working tree is never read, so local edits cannot leak into the review.
4. **Missing context is read with `git show`**, never by switching branches.

## Prerequisites

Check in this order; the first row that applies decides.

| Check | Result |
|---|---|
| `git rev-parse --is-inside-work-tree` fails | `BLOCKED`: not a git repository. |
| `git rev-parse --verify -q HEAD` fails (unborn HEAD, no commits) | `BLOCKED`: nothing committed yet. |
| `git symbolic-ref -q HEAD` fails (detached) | Tell the user `HEAD` is detached and ask them to check out the branch to review and rerun. No report. |
| `git --no-optional-locks status --porcelain` is non-empty | Continue; the confirmation carries the uncommitted-changes warning and the report's `Limitations` repeats it. |

## Base

If the user gave `base`, skip detection: a value that already resolves as a ref (`git rev-parse --verify -q <base>`, for example `origin/main`) is used as-is; a bare name tries `origin/<name>` first, then `<name>`. A `base` given together with a GitHub PR URL is ignored; say so. Otherwise detect.

**Candidates:** for each `x` in `develop`, `main`, `master` and the branch `origin/HEAD` points to (`git symbolic-ref -q --short refs/remotes/origin/HEAD`, when it exists; it prints `origin/<name>`, so strip the leading `origin/` to get `x`), the ref is `origin/<x>` if `git rev-parse --verify -q refs/remotes/origin/<x>` succeeds, else local `<x>` if `refs/heads/<x>` exists. Drop duplicates and non-existent ones.

**Choose** with these keys, in order:

1. fewest commits in `git rev-list --count <base>..HEAD`;
2. fewest commits in `git rev-list --count HEAD..<base>` (the base the branch actually left from has not moved on);
3. the `origin/HEAD` target;
4. the fixed order `develop`, `main`, `master`.

No candidate exists: ask the user for the base; with no answer, `BLOCKED`.

No `git fetch`. When the base is a remote ref, show the date of its last commit (`git log -1 --format=%cs <base>`) so the user can notice a stale ref.

## Data

```bash
git rev-parse --abbrev-ref HEAD
git rev-parse --short HEAD
git rev-parse --short "$(git merge-base <base> HEAD)"   # merge-base short sha; non-zero exit = unrelated histories
git rev-list --count <base>..HEAD
git log --reverse --format='%h %s%n%b' <base>..HEAD     # commit messages = context, like a PR description
git diff --name-status <base>...HEAD                    # files; deleted ones (D) count
git diff --stat <base>...HEAD
git diff <base>...HEAD                                  # source of the changes
git show HEAD:<path>                                    # full file, new version
git show <merge-base>:<path>                            # deleted file, old version
git --no-optional-locks status --porcelain
```

Review prior context in the commit messages. Files in the diff are the only files reviewed: a file changed on the base after the merge-base never appears in `<base>...HEAD`.

## Confirmation

Before reviewing, compute N first: with 0 commits, report nothing to review (Edge cases) and send no confirmation. Otherwise send **one** message with these parts, in this order, then stop and wait for the answer:

1. Branch and base ref: `` `<branch>` against `<base>` ``.
2. Merge-base short sha, N commits, and "M files, of which K deleted". M is the number of lines in `git diff --name-status <base>...HEAD` (a rename is one line); K is the lines with status `D`.
3. Only when the base is a remote ref: the date of its last commit.
4. Only when a spec was given: its outcome, read before this message. Read from `<source>`, or could not be read (say why) and ask for it as markdown (path or pasted) or for confirmation to review without it. The mechanics are in the Spec step of the workflow.
5. Only when `git status --porcelain` is non-empty: a warning that uncommitted changes are not part of the review.
6. The closing choice: confirm, change the base, or did you mean to review a PR?

If the user's invocation message already confirms (for example "confirm, review now"), skip the wait and proceed; the confirmation facts still go in the report header. Exception: when a given spec could not be read, stop and ask, because that needs the user's answer.

If the user names a different base, recompute parts 2 and 3 and confirm again.

## Edge cases

| Situation | What to do |
|---|---|
| `<base>..HEAD` has 0 commits (for example standing on `develop`) | Say there is nothing to review against that base. No report. |
| No candidate base | Ask for it (see Base). |
| Base given by the user does not resolve | Say so and ask for another. |

## Header fields (section 1)

`Source: Local branch`, then: Repo, Head branch, HEAD, Base ref, Merge-base, Commits reviewed. `PR comments reviewed: N/A`.

## BLOCKED when

- Not a git repository.
- No base can be determined and the user does not give one.
- `git merge-base <base> HEAD` exits non-zero (unrelated histories), or `HEAD` is unborn.
- A spec rule from SKILL.md applies.
