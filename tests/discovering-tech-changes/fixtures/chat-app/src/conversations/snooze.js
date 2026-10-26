// Test fixture file (discovering-tech-changes scenarios). Not a real product.
const { CHAT_CONV_002 } = require('../shared/error-codes');

const MAX_SNOOZE_MINUTES = 720;

function snoozeConversation(conversation, minutes, now) {
  if (minutes > MAX_SNOOZE_MINUTES) {
    throw new Error(CHAT_CONV_002);
  }
  conversation.snoozeUntil = now + minutes * 60 * 1000;
  return conversation;
}

function isSnoozed(conversation, now) {
  return Boolean(conversation.snoozeUntil) && conversation.snoozeUntil > now;
}

module.exports = { MAX_SNOOZE_MINUTES, snoozeConversation, isSnoozed };
