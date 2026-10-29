<!-- Test fixture file (discovering-tech-changes scenarios). Not a real spec. -->
# Spec: Quiet hours

Status: in refinement
Owner: unassigned

Users can set a daily quiet-hours window (for example 22:00 to 07:00) during which they receive no notifications.

## Technical scope

- Add a quiet-hours check to `src/notifications/dispatcher.js`, before the email is sent.
- Store the window per user.
