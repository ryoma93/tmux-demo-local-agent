/**
 * LINE Webhook Signature Validator
 * Utility for validating LINE webhook signatures to ensure security
 */

const crypto = require('crypto');

/**
 * Validates LINE webhook signature
 * @param {string} body - Raw request body string
 * @param {string} signature - X-Line-Signature header value
 * @param {string} channelSecret - Your LINE channel secret
 * @returns {boolean} - True if signature is valid
 */
function validateSignature(body, signature, channelSecret) {
  if (!body || !signature || !channelSecret) {
    return false;
  }

  const hash = crypto
    .createHmac('SHA256', channelSecret)
    .update(body)
    .digest('base64');

  return hash === signature;
}

/**
 * Express middleware for validating LINE webhook signatures
 * @param {string} channelSecret - Your LINE channel secret
 * @returns {Function} - Express middleware function
 */
function createValidatorMiddleware(channelSecret) {
  if (!channelSecret) {
    throw new Error('Channel secret is required');
  }

  return (req, res, next) => {
    // Get raw body for signature validation
    const rawBody = req.rawBody || JSON.stringify(req.body);
    const signature = req.get('X-Line-Signature');

    if (!signature) {
      return res.status(401).json({
        error: 'Missing X-Line-Signature header'
      });
    }

    if (!validateSignature(rawBody, signature, channelSecret)) {
      return res.status(401).json({
        error: 'Invalid signature'
      });
    }

    next();
  };
}

/**
 * Validates webhook request headers
 * @param {object} headers - Request headers object
 * @returns {object} - Validation result
 */
function validateWebhookHeaders(headers) {
  const result = {
    isValid: true,
    errors: []
  };

  // Check for required headers
  if (!headers['x-line-signature']) {
    result.isValid = false;
    result.errors.push('Missing X-Line-Signature header');
  }

  // Check content type
  const contentType = headers['content-type'];
  if (!contentType || !contentType.includes('application/json')) {
    result.isValid = false;
    result.errors.push('Content-Type must be application/json');
  }

  // Check user agent (optional but good to verify)
  const userAgent = headers['user-agent'];
  if (userAgent && !userAgent.includes('LineBotWebhook')) {
    result.warnings = result.warnings || [];
    result.warnings.push('Unexpected User-Agent header');
  }

  return result;
}

/**
 * Validates webhook event structure
 * @param {object} event - LINE webhook event object
 * @returns {object} - Validation result
 */
function validateWebhookEvent(event) {
  const result = {
    isValid: true,
    errors: []
  };

  // Check required fields
  if (!event.type) {
    result.isValid = false;
    result.errors.push('Missing event type');
  }

  if (!event.timestamp) {
    result.isValid = false;
    result.errors.push('Missing timestamp');
  }

  if (!event.source) {
    result.isValid = false;
    result.errors.push('Missing source object');
  } else {
    // Validate source object
    if (!event.source.type) {
      result.isValid = false;
      result.errors.push('Missing source type');
    }

    if (!event.source.userId && event.source.type === 'user') {
      result.isValid = false;
      result.errors.push('Missing userId for user source');
    }

    if (!event.source.groupId && event.source.type === 'group') {
      result.isValid = false;
      result.errors.push('Missing groupId for group source');
    }

    if (!event.source.roomId && event.source.type === 'room') {
      result.isValid = false;
      result.errors.push('Missing roomId for room source');
    }
  }

  // Validate message events
  if (event.type === 'message') {
    if (!event.replyToken) {
      result.isValid = false;
      result.errors.push('Missing replyToken for message event');
    }

    if (!event.message) {
      result.isValid = false;
      result.errors.push('Missing message object');
    } else {
      if (!event.message.type) {
        result.isValid = false;
        result.errors.push('Missing message type');
      }

      if (!event.message.id) {
        result.isValid = false;
        result.errors.push('Missing message id');
      }
    }
  }

  // Validate postback events
  if (event.type === 'postback') {
    if (!event.replyToken) {
      result.isValid = false;
      result.errors.push('Missing replyToken for postback event');
    }

    if (!event.postback) {
      result.isValid = false;
      result.errors.push('Missing postback object');
    } else if (!event.postback.data) {
      result.isValid = false;
      result.errors.push('Missing postback data');
    }
  }

  return result;
}

/**
 * Validates webhook request body
 * @param {object} body - Request body object
 * @returns {object} - Validation result
 */
function validateWebhookBody(body) {
  const result = {
    isValid: true,
    errors: []
  };

  if (!body) {
    result.isValid = false;
    result.errors.push('Empty request body');
    return result;
  }

  if (!body.events) {
    result.isValid = false;
    result.errors.push('Missing events array');
    return result;
  }

  if (!Array.isArray(body.events)) {
    result.isValid = false;
    result.errors.push('Events must be an array');
    return result;
  }

  // Validate each event
  body.events.forEach((event, index) => {
    const eventValidation = validateWebhookEvent(event);
    if (!eventValidation.isValid) {
      result.isValid = false;
      eventValidation.errors.forEach(error => {
        result.errors.push(`Event[${index}]: ${error}`);
      });
    }
  });

  return result;
}

/**
 * Security check for webhook timestamp
 * @param {number} timestamp - Event timestamp in milliseconds
 * @param {number} maxAgeMinutes - Maximum age in minutes (default: 5)
 * @returns {boolean} - True if timestamp is within acceptable range
 */
function isTimestampValid(timestamp, maxAgeMinutes = 5) {
  const now = Date.now();
  const maxAge = maxAgeMinutes * 60 * 1000;
  const age = now - timestamp;

  return age >= 0 && age <= maxAge;
}

/**
 * Extracts and validates user information from event
 * @param {object} event - LINE webhook event
 * @returns {object} - User information
 */
function extractUserInfo(event) {
  const userInfo = {
    userId: null,
    sourceType: null,
    groupId: null,
    roomId: null
  };

  if (!event.source) {
    return userInfo;
  }

  userInfo.sourceType = event.source.type;
  userInfo.userId = event.source.userId;

  if (event.source.type === 'group') {
    userInfo.groupId = event.source.groupId;
  } else if (event.source.type === 'room') {
    userInfo.roomId = event.source.roomId;
  }

  return userInfo;
}

module.exports = {
  validateSignature,
  createValidatorMiddleware,
  validateWebhookHeaders,
  validateWebhookEvent,
  validateWebhookBody,
  isTimestampValid,
  extractUserInfo
};