# Scenario: jira-only

## Setup
Fixture: `bash tests/gcf-code-review/fixtures/make-local-repo.sh <FIXTURE_DIR>`. Checked out on `feature/orders-pubsub`.

## Invocation
https://acme.atlassian.net/browse/ORD-1

## Pressure
(none)

## Expected
- [ ] The URL is treated as the spec, not as a review target.
- [ ] ONE message that is the local confirmation (branch, base, merge-base sha, 3 commits, 3 files) AND says the ORD-1 spec could not be read (the acme URL is fake), asking for it in markdown or for confirmation to review without a spec.
- [ ] Does not ask "what do you want to review?".
- [ ] No review and no findings yet.

## Results

### baseline — 2026-10-16
- Verdict: FAIL
- URL treated as spec, not review target — PASS (identified as Jira ticket, offered to use as spec)
- ONE message: local confirmation (branch, base, merge-base, 3 commits, 3 files) + spec unreadable ask — FAIL (no local confirmation; demanded PR URL)
- Does not ask 'what do you want to review?' — FAIL (effectively asks for the PR to review)
- No review/findings — PASS
- Forbidden commands: none
- Rationalizations: "I can't start the review yet: the link you gave me ... is a Jira ticket, not a GitHub pull request."
