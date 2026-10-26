// Test fixture file (discovering-tech-changes scenarios). Not a real product.
const { isSnoozed } = require('../conversations/snooze');
const { dispatch } = require('../notifications/dispatcher');

function postMessage(req) {
  const { conversation, message, now } = req;
  if (isSnoozed(conversation, now)) {
    return { status: 202, notified: false };
  }
  const result = dispatch(conversation, message, now);
  return { status: 201, notified: result.sent };
}

module.exports = { postMessage };
