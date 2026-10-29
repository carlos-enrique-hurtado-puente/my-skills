<!-- Test fixture file (spec-to-jira-stories scenarios). A made-up plain spec, not written with writing-tech-specs. -->
# Export conversations to CSV

## Problem
Support leads copy conversations by hand into spreadsheets to review them every week. It takes hours.

## Solution
Add an "Export CSV" button to the conversations list. It downloads the conversations currently filtered, one row per conversation: date, customer, agent, status and number of messages. The export is built in the backend and streamed to the browser.

## Technical changes
- Backend: a new endpoint that takes the current filters and streams a CSV.
- Frontend: the button in the list toolbar, disabled while an export is running.

## Acceptance criteria
- The button downloads a CSV with the filtered conversations.
- Exports of up to 10,000 conversations finish in under 30 seconds.
- While an export runs, the button is disabled.
- If the export fails, the user sees an error message.

## Risks
- Large exports could time out the request.
