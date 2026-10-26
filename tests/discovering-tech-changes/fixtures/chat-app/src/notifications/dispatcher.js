// Test fixture file (discovering-tech-changes scenarios). Not a real product.
const { CHAT_NOTIF_001 } = require('../shared/error-codes');

function sendEmail(conversation, message) {
  return Boolean(conversation.recipientEmail && message.body);
}

// Sends a notification for a message. It does not check snooze itself.
function dispatch(conversation, message, now) {
  if (!sendEmail(conversation, message)) {
    return { sent: false, reason: CHAT_NOTIF_001 };
  }
  return { sent: true, reason: 'ok' };
}

module.exports = { dispatch };
