# Backend spec: Agent availability schedule (Spec B)

Status: in review. Author: dev. Not implemented yet. Written 2026-10-02.

## Goal
Each support agent has a weekly availability schedule. The assignment engine only routes new cases to agents who are available at that moment.

## Decisions
| Decision | Status | Who |
|---|---|---|
| Schedules are stored per agent, one entry per weekday | Proposed | LT |
| Times are stored in the agent's timezone | Decided | LT |
| Endpoint returns a schedule for one agent | Decided | LT |

## Open questions
1. Weekday keys: `mon..sun` or numbers `0..6`? (LT, before freeze)
2. Is each day a single range or a list of ranges? (PM, before freeze)
3. Name of the field for the end of the range: `to` or `end`? (dev, during implementation)

## Notes
The endpoint will be `GET /agents/:id/schedule`. A response example will be added once questions 1 and 2 are answered.
