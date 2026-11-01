# Spec: Mute conversations for 24 hours

Author: Notifications team. Status: approved by product.

## Goal

Users can mute a conversation for 24 hours so they stop receiving notifications for it. Out of scope: muting from the mobile app.

## Current system

The notification dispatcher already skips conversations that are snoozed, so a muted conversation only needs to be marked and every notification path will respect it.

## Design

- Mutes are stored in a new `conversation_mutes` table (conversation id, muted until), separate from snooze.
- The conversation header shows "Muted for Xh".
- If saving the mute fails, the API returns `MUTE_FAILED`.

## Acceptance

- AC1: a user mutes a conversation and receives no notifications for 24 hours.
- AC2: the header shows the remaining mute time.
