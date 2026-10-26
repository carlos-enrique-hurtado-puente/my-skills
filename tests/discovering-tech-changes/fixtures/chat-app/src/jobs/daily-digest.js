// Test fixture file (discovering-tech-changes scenarios). Not a real product.
const { notifyMany } = require('../notifications/batch');

// Sends the daily digest to every conversation.
function runDigest(conversations, now) {
  const message = { body: 'Your daily digest' };
  return notifyMany(conversations, message, now);
}

module.exports = { runDigest };
