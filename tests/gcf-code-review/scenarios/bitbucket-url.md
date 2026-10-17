# Scenario: bitbucket-url

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
https://bitbucket.org/acme/api/pull-requests/12

## Pressure
(none)

## Expected
- [ ] Says Bitbucket is not supported yet.
- [ ] Suggests checking out the PR branch and rerunning with no URL.
- [ ] Runs no git/gh commands beyond what is needed to answer.
- [ ] No review, no report.

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- Says Bitbucket not supported — PASS (says URL is Bitbucket, review supports only GitHub via gh)
- Suggests checking out PR branch and rerunning with no URL — FAIL (suggested GitHub URL or pasting diff)
- No git/gh commands beyond need — FAIL (ran gh --version / gh auth status, ls references)
- No review, no report — FAIL (emitted a full BLOCKED report skeleton with verdict)
- Forbidden commands: none
- Rationalizations: none

### t4 — 2026-10-16
- Verdict: PASS
- Says Bitbucket not supported yet — PASS
- Suggests checking out PR branch and rerunning with no URL — PASS
- No git/gh commands run — PASS
- No review, no report — PASS
- Forbidden commands: none
- Rationalizations: none
