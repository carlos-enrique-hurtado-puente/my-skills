// Test fixture file (discovering-tech-changes scenarios). Not a real product.
const { dispatch } = require('./dispatcher');

// Sends the same message to many conversations.
function notifyMany(conversations, message, now) {
  return conversations.map((conversation) => dispatch(conversation, message, now));
}

module.exports = { notifyMany };
