/**
 * LINE Message Builder Utility
 * Helper functions for building various LINE message types
 */

/**
 * Creates a text message
 * @param {string} text - Message text (max 5000 characters)
 * @param {Array} emojis - Optional emoji array
 * @returns {object} - Text message object
 */
function createTextMessage(text, emojis = null) {
  const message = {
    type: 'text',
    text: text
  };

  if (emojis && Array.isArray(emojis)) {
    message.emojis = emojis;
  }

  return message;
}

/**
 * Creates a sticker message
 * @param {string} packageId - Sticker package ID
 * @param {string} stickerId - Sticker ID
 * @returns {object} - Sticker message object
 */
function createStickerMessage(packageId, stickerId) {
  return {
    type: 'sticker',
    packageId: packageId,
    stickerId: stickerId
  };
}

/**
 * Creates an image message
 * @param {string} originalContentUrl - Image URL (HTTPS, max 10MB)
 * @param {string} previewImageUrl - Preview image URL (HTTPS, max 1MB)
 * @returns {object} - Image message object
 */
function createImageMessage(originalContentUrl, previewImageUrl = null) {
  return {
    type: 'image',
    originalContentUrl: originalContentUrl,
    previewImageUrl: previewImageUrl || originalContentUrl
  };
}

/**
 * Creates a video message
 * @param {string} originalContentUrl - Video URL (HTTPS, max 200MB)
 * @param {string} previewImageUrl - Preview image URL (HTTPS)
 * @returns {object} - Video message object
 */
function createVideoMessage(originalContentUrl, previewImageUrl) {
  return {
    type: 'video',
    originalContentUrl: originalContentUrl,
    previewImageUrl: previewImageUrl
  };
}

/**
 * Creates an audio message
 * @param {string} originalContentUrl - Audio URL (HTTPS, m4a format)
 * @param {number} duration - Duration in milliseconds
 * @returns {object} - Audio message object
 */
function createAudioMessage(originalContentUrl, duration) {
  return {
    type: 'audio',
    originalContentUrl: originalContentUrl,
    duration: duration
  };
}

/**
 * Creates a location message
 * @param {string} title - Location title
 * @param {string} address - Location address
 * @param {number} latitude - Latitude
 * @param {number} longitude - Longitude
 * @returns {object} - Location message object
 */
function createLocationMessage(title, address, latitude, longitude) {
  return {
    type: 'location',
    title: title,
    address: address,
    latitude: latitude,
    longitude: longitude
  };
}

/**
 * Creates a template message
 * @param {string} altText - Alternative text
 * @param {object} template - Template object
 * @returns {object} - Template message object
 */
function createTemplateMessage(altText, template) {
  return {
    type: 'template',
    altText: altText,
    template: template
  };
}

/**
 * Creates a buttons template
 * @param {object} options - Template options
 * @returns {object} - Buttons template object
 */
function createButtonsTemplate(options) {
  const {
    thumbnailImageUrl,
    imageAspectRatio = 'rectangle',
    imageSize = 'cover',
    imageBackgroundColor = '#FFFFFF',
    title,
    text,
    defaultAction,
    actions
  } = options;

  const template = {
    type: 'buttons',
    actions: actions
  };

  if (thumbnailImageUrl) template.thumbnailImageUrl = thumbnailImageUrl;
  if (imageAspectRatio) template.imageAspectRatio = imageAspectRatio;
  if (imageSize) template.imageSize = imageSize;
  if (imageBackgroundColor) template.imageBackgroundColor = imageBackgroundColor;
  if (title) template.title = title;
  if (text) template.text = text;
  if (defaultAction) template.defaultAction = defaultAction;

  return template;
}

/**
 * Creates a confirm template
 * @param {string} text - Confirmation text
 * @param {object} confirmAction - Confirm action
 * @param {object} cancelAction - Cancel action
 * @returns {object} - Confirm template object
 */
function createConfirmTemplate(text, confirmAction, cancelAction) {
  return {
    type: 'confirm',
    text: text,
    actions: [confirmAction, cancelAction]
  };
}

/**
 * Creates a carousel template
 * @param {Array} columns - Array of column objects
 * @param {string} imageAspectRatio - Image aspect ratio
 * @param {string} imageSize - Image size
 * @returns {object} - Carousel template object
 */
function createCarouselTemplate(columns, imageAspectRatio = 'rectangle', imageSize = 'cover') {
  return {
    type: 'carousel',
    columns: columns,
    imageAspectRatio: imageAspectRatio,
    imageSize: imageSize
  };
}

/**
 * Creates an image carousel template
 * @param {Array} columns - Array of image column objects
 * @returns {object} - Image carousel template object
 */
function createImageCarouselTemplate(columns) {
  return {
    type: 'image_carousel',
    columns: columns
  };
}

/**
 * Creates a postback action
 * @param {string} label - Action label
 * @param {string} data - Postback data
 * @param {string} displayText - Optional display text
 * @returns {object} - Postback action object
 */
function createPostbackAction(label, data, displayText = null) {
  const action = {
    type: 'postback',
    label: label,
    data: data
  };

  if (displayText) {
    action.displayText = displayText;
  }

  return action;
}

/**
 * Creates a message action
 * @param {string} label - Action label
 * @param {string} text - Message text
 * @returns {object} - Message action object
 */
function createMessageAction(label, text) {
  return {
    type: 'message',
    label: label,
    text: text
  };
}

/**
 * Creates a URI action
 * @param {string} label - Action label
 * @param {string} uri - URI to open
 * @returns {object} - URI action object
 */
function createUriAction(label, uri) {
  return {
    type: 'uri',
    label: label,
    uri: uri
  };
}

/**
 * Creates a datetime picker action
 * @param {string} label - Action label
 * @param {string} data - Postback data
 * @param {string} mode - Picker mode (date, time, datetime)
 * @param {object} options - Optional settings (initial, max, min)
 * @returns {object} - Datetime picker action object
 */
function createDatetimePickerAction(label, data, mode, options = {}) {
  const action = {
    type: 'datetimepicker',
    label: label,
    data: data,
    mode: mode
  };

  if (options.initial) action.initial = options.initial;
  if (options.max) action.max = options.max;
  if (options.min) action.min = options.min;

  return action;
}

/**
 * Creates a camera action
 * @param {string} label - Action label
 * @returns {object} - Camera action object
 */
function createCameraAction(label) {
  return {
    type: 'camera',
    label: label
  };
}

/**
 * Creates a camera roll action
 * @param {string} label - Action label
 * @returns {object} - Camera roll action object
 */
function createCameraRollAction(label) {
  return {
    type: 'cameraRoll',
    label: label
  };
}

/**
 * Creates a location action
 * @param {string} label - Action label
 * @returns {object} - Location action object
 */
function createLocationAction(label) {
  return {
    type: 'location',
    label: label
  };
}

/**
 * Creates a quick reply
 * @param {Array} items - Array of quick reply items
 * @returns {object} - Quick reply object
 */
function createQuickReply(items) {
  return {
    items: items
  };
}

/**
 * Creates a quick reply item
 * @param {object} action - Action object
 * @param {string} imageUrl - Optional image URL
 * @returns {object} - Quick reply item object
 */
function createQuickReplyItem(action, imageUrl = null) {
  const item = {
    type: 'action',
    action: action
  };

  if (imageUrl) {
    item.imageUrl = imageUrl;
  }

  return item;
}

/**
 * Creates a flex message
 * @param {string} altText - Alternative text
 * @param {object} contents - Flex message contents
 * @returns {object} - Flex message object
 */
function createFlexMessage(altText, contents) {
  return {
    type: 'flex',
    altText: altText,
    contents: contents
  };
}

/**
 * Creates a simple flex bubble
 * @param {object} options - Bubble options
 * @returns {object} - Flex bubble object
 */
function createFlexBubble(options = {}) {
  const bubble = {
    type: 'bubble'
  };

  if (options.size) bubble.size = options.size;
  if (options.header) bubble.header = options.header;
  if (options.hero) bubble.hero = options.hero;
  if (options.body) bubble.body = options.body;
  if (options.footer) bubble.footer = options.footer;
  if (options.styles) bubble.styles = options.styles;

  return bubble;
}

/**
 * Creates a flex carousel
 * @param {Array} bubbles - Array of bubble objects
 * @returns {object} - Flex carousel object
 */
function createFlexCarousel(bubbles) {
  return {
    type: 'carousel',
    contents: bubbles
  };
}

/**
 * Creates a sender for push/multicast messages
 * @param {string} name - Sender name
 * @param {string} iconUrl - Sender icon URL
 * @returns {object} - Sender object
 */
function createSender(name, iconUrl = null) {
  const sender = {
    name: name
  };

  if (iconUrl) {
    sender.iconUrl = iconUrl;
  }

  return sender;
}

/**
 * Validates message object
 * @param {object} message - Message object to validate
 * @returns {object} - Validation result
 */
function validateMessage(message) {
  const result = {
    isValid: true,
    errors: []
  };

  if (!message.type) {
    result.isValid = false;
    result.errors.push('Message type is required');
    return result;
  }

  switch (message.type) {
    case 'text':
      if (!message.text) {
        result.isValid = false;
        result.errors.push('Text is required for text messages');
      } else if (message.text.length > 5000) {
        result.isValid = false;
        result.errors.push('Text exceeds 5000 character limit');
      }
      break;

    case 'sticker':
      if (!message.packageId || !message.stickerId) {
        result.isValid = false;
        result.errors.push('PackageId and stickerId are required for sticker messages');
      }
      break;

    case 'image':
    case 'video':
      if (!message.originalContentUrl) {
        result.isValid = false;
        result.errors.push('OriginalContentUrl is required');
      }
      if (message.type === 'video' && !message.previewImageUrl) {
        result.isValid = false;
        result.errors.push('PreviewImageUrl is required for video messages');
      }
      break;

    case 'audio':
      if (!message.originalContentUrl || !message.duration) {
        result.isValid = false;
        result.errors.push('OriginalContentUrl and duration are required for audio messages');
      }
      break;

    case 'location':
      if (!message.title || !message.address || 
          message.latitude === undefined || message.longitude === undefined) {
        result.isValid = false;
        result.errors.push('Title, address, latitude, and longitude are required for location messages');
      }
      break;

    case 'template':
      if (!message.altText || !message.template) {
        result.isValid = false;
        result.errors.push('AltText and template are required for template messages');
      }
      break;

    case 'flex':
      if (!message.altText || !message.contents) {
        result.isValid = false;
        result.errors.push('AltText and contents are required for flex messages');
      }
      break;

    default:
      result.isValid = false;
      result.errors.push(`Unknown message type: ${message.type}`);
  }

  return result;
}

module.exports = {
  createTextMessage,
  createStickerMessage,
  createImageMessage,
  createVideoMessage,
  createAudioMessage,
  createLocationMessage,
  createTemplateMessage,
  createButtonsTemplate,
  createConfirmTemplate,
  createCarouselTemplate,
  createImageCarouselTemplate,
  createPostbackAction,
  createMessageAction,
  createUriAction,
  createDatetimePickerAction,
  createCameraAction,
  createCameraRollAction,
  createLocationAction,
  createQuickReply,
  createQuickReplyItem,
  createFlexMessage,
  createFlexBubble,
  createFlexCarousel,
  createSender,
  validateMessage
};