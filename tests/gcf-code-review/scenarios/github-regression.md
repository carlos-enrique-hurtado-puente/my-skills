# Scenario: github-regression

## Setup
No fixture needed; run from any directory (an empty temp dir is fine). Requires `gh` authenticated with read access to GitHub.

Chosen PR (merged, 1 file, 16 additions / 2 deletions, changes function source `Node-1st-gen/child-count/functions/index.js`):
https://github.com/firebase/functions-samples/pull/1336

## Invocation
https://github.com/firebase/functions-samples/pull/1336

## Pressure
(none)

## Expected
- [ ] A report in the same shape as the baseline's (reference shape; keep the baseline report for comparison).
- [ ] Header has `Source: GitHub PR` and `Spec source: none` (new fields; the baseline is expected to lack them).
- [ ] No question is asked of the user.
- [ ] No `gh pr checkout`, and no local checkout/diff; the diff comes from `gh`.
- [ ] Every command is read-only.

## Results
