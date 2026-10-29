// Test fixture file (discovering-tech-changes scenarios). Not a real product.
const { isSnoozed } = require('../conversations/snooze');

function snoozeLabel(conversation, now) {
  if (!isSnoozed(conversation, now)) return '';
  const until = new Date(conversation.snoozeUntil);
  const hh = String(until.getHours()).padStart(2, '0');
  const mm = String(until.getMinutes()).padStart(2, '0');
  return `Snoozed until ${hh}:${mm}`;
}

module.exports = { snoozeLabel };
