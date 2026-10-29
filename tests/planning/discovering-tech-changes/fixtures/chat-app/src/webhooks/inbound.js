// Test fixture file (discovering-tech-changes scenarios). Not a real product.
const { dispatch } = require('../notifications/dispatcher');

// Handles a message that arrives from an external channel.
function handleInbound(payload) {
  const { conversation, message, now } = payload;
  return dispatch(conversation, message, now);
}

module.exports = { handleInbound };
