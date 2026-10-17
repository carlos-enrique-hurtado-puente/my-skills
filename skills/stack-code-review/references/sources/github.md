# Source: GitHub PR

Read only when the target is a GitHub PR URL (`https://github.com/<owner>/<repo>/pull/<number>`).

## Rules for this source

1. **Read-only.** Never `gh pr checkout`, never switch branches, never touch the worktree, never use a local diff.
2. **The base is the PR's `baseRefName`.** Never compare against `main`/`master` by default.
3. **Read the PR comments before analyzing code.**

## Prerequisites

`gh` installed and authenticated (`gh --version`, `gh auth status`). Derive `owner/repo/number` from the URL.

## Commands (all read-only)

```bash
# 1. Metadata (baseRefName, headRefName and headRefOid come from here; do not ask the user)
gh pr view <pull_request_url> --json \
  number,title,body,state,isDraft,author,baseRefName,headRefName,\
headRefOid,headRepository,headRepositoryOwner,mergeable,additions,deletions,changedFiles,labels,files,commits,url

# 2. Full diff — source of the changes to review
gh pr diff <pull_request_url>

# 3. Full file without checkout. Ref = headRefOid (commit SHA); for fork PRs use the head repo
#    (headRepositoryOwner/headRepository) instead of the base repo
gh api "repos/<owner>/<repo>/contents/<path>?ref=<headRefOid>" --jq '.content' | base64 -d

# 4. Comments and reviews
gh pr view <pull_request_url> --json comments,reviews
gh api "repos/<owner>/<repo>/pulls/<number>/comments" --paginate   # inline
gh api "repos/<owner>/<repo>/issues/<number>/comments" --paginate  # conversation

# 5. (Optional) CI
gh pr checks <pull_request_url>
```

Use the PR description and `gh pr checks` for change intent and PR hygiene (criterion 8): distinguish "no CI configured" from "CI did not run". For greps across many files, download the head tarball into an empty temp dir and only read or grep it; never run its scripts. `gh api search/code` is unreliable: if it fails, say so instead of concluding anything. File contents for stack selection are fetched as `references/stack-selection.md` describes.

When present in the diff, review: config, `package.json`/lockfiles, runtime config, IaC/Terraform, tests, CI/CD and deployment docs.

## Header fields (section 1)

`Source: GitHub PR`, then: PR, PR URL, Head branch, Base branch, Author, PR comments reviewed.

## BLOCKED when

- `gh` is missing or has no session.
- The PR cannot be fetched with `gh` (if the user pasted snippets, analyze only those and say so).
- The PR comments cannot be read (`require_pr_comments_access: true` by default), unless the user says they are not needed.
