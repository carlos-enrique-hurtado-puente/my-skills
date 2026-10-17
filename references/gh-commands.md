# `gh` commands (read-only)

Never use `gh pr checkout`. All commands below are read-only.

```bash
# 0. Prerequisites
gh --version
gh auth status

# 1. Metadata (baseRefName and headRefName come from here; do not ask the user)
gh pr view <pull_request_url> --json \
  number,title,body,state,isDraft,author,baseRefName,headRefName,\
headRepositoryOwner,mergeable,additions,deletions,changedFiles,labels,files,commits,url

# 2. Full diff — source of the changes to review
gh pr diff <pull_request_url>

# 3. Full file without checkout (use headRefName)
gh api "repos/<owner>/<repo>/contents/<path>?ref=<headRefName>" --jq '.content' | base64 -d

# 4. Comments and reviews
gh pr view <pull_request_url> --json comments,reviews
gh api "repos/<owner>/<repo>/pulls/<number>/comments" --paginate   # inline
gh api "repos/<owner>/<repo>/issues/<number>/comments" --paginate  # conversation

# 5. (Optional) CI
gh pr checks <pull_request_url>
```

Expected URL: `https://github.com/<owner>/<repo>/pull/<number>`.

When present in the diff, review: config, `package.json`/lockfiles, runtime config, IaC/Terraform, tests, CI/CD and deployment docs.
