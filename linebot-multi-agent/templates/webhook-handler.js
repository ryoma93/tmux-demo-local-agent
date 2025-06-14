/**
 * LINE Bot Webhook Handler Template
 * Basic webhook handler for LINE Bot with common event types
 */

const line = require('@line/bot-sdk');
const express = require('express');

// LINE Bot configuration
const config = {
  channelAccessToken: process.env.LINE_CHANNEL_ACCESS_TOKEN,
  channelSecret: process.env.LINE_CHANNEL_SECRET,
};

// Create LINE SDK client
const client = new line.Client(config);

// Create Express app
const app = express();

// Register webhook handler
app.post('/webhook', line.middleware(config), (req, res) => {
  Promise
    .all(req.body.events.map(handleEvent))
    .then((result) => res.json(result))
    .catch((err) => {
      console.error(err);
      res.status(500).end();
    });
});

// Event handler
function handleEvent(event) {
  // Log event for debugging
  console.log('Event received:', JSON.stringify(event, null, 2));

  switch (event.type) {
    case 'message':
      return handleMessageEvent(event);
    case 'follow':
      return handleFollowEvent(event);
    case 'unfollow':
      return handleUnfollowEvent(event);
    case 'join':
      return handleJoinEvent(event);
    case 'leave':
      return handleLeaveEvent(event);
    case 'memberJoined':
      return handleMemberJoinedEvent(event);
    case 'memberLeft':
      return handleMemberLeftEvent(event);
    case 'postback':
      return handlePostbackEvent(event);
    case 'beacon':
      return handleBeaconEvent(event);
    default:
      // Unknown event type
      return Promise.resolve(null);
  }
}

// Handle message events
function handleMessageEvent(event) {
  const { type, text } = event.message;

  switch (type) {
    case 'text':
      return handleTextMessage(event, text);
    case 'image':
      return handleImageMessage(event);
    case 'video':
      return handleVideoMessage(event);
    case 'audio':
      return handleAudioMessage(event);
    case 'file':
      return handleFileMessage(event);
    case 'location':
      return handleLocationMessage(event);
    case 'sticker':
      return handleStickerMessage(event);
    default:
      return Promise.resolve(null);
  }
}

// Handle text messages
function handleTextMessage(event, text) {
  const { replyToken } = event;
  
  // Example: Echo the text back
  const echo = { type: 'text', text: `You said: ${text}` };
  
  // Example: Handle specific commands
  if (text.toLowerCase() === 'hello') {
    return client.replyMessage(replyToken, {
      type: 'text',
      text: 'Hello! How can I help you today?'
    });
  }
  
  if (text.toLowerCase() === 'menu') {
    return client.replyMessage(replyToken, {
      type: 'text',
      text: 'Please check the rich menu below for available options.',
      quickReply: {
        items: [
          {
            type: 'action',
            action: {
              type: 'message',
              label: 'Help',
              text: 'help'
            }
          },
          {
            type: 'action',
            action: {
              type: 'message',
              label: 'About',
              text: 'about'
            }
          }
        ]
      }
    });
  }
  
  return client.replyMessage(replyToken, echo);
}

// Handle image messages
function handleImageMessage(event) {
  const { replyToken } = event;
  return client.replyMessage(replyToken, {
    type: 'text',
    text: 'Nice image! 📷'
  });
}

// Handle video messages
function handleVideoMessage(event) {
  const { replyToken } = event;
  return client.replyMessage(replyToken, {
    type: 'text',
    text: 'Thanks for sharing the video! 🎬'
  });
}

// Handle audio messages
function handleAudioMessage(event) {
  const { replyToken } = event;
  return client.replyMessage(replyToken, {
    type: 'text',
    text: 'I received your audio message! 🎵'
  });
}

// Handle file messages
function handleFileMessage(event) {
  const { replyToken } = event;
  return client.replyMessage(replyToken, {
    type: 'text',
    text: 'File received! 📎'
  });
}

// Handle location messages
function handleLocationMessage(event) {
  const { replyToken } = event;
  const { title, address, latitude, longitude } = event.message;
  
  return client.replyMessage(replyToken, {
    type: 'text',
    text: `Location received:\n📍 ${title || 'Unknown'}\n${address}\n(${latitude}, ${longitude})`
  });
}

// Handle sticker messages
function handleStickerMessage(event) {
  const { replyToken } = event;
  const { packageId, stickerId } = event.message;
  
  // Reply with a sticker
  return client.replyMessage(replyToken, {
    type: 'sticker',
    packageId: '11537',
    stickerId: '52002734' // Brown salute sticker
  });
}

// Handle follow events (new friend)
function handleFollowEvent(event) {
  const { replyToken, source } = event;
  
  return client.replyMessage(replyToken, {
    type: 'text',
    text: 'Welcome! Thanks for adding me as a friend. 🎉\n\nType "help" to see what I can do!'
  });
}

// Handle unfollow events
function handleUnfollowEvent(event) {
  const { source } = event;
  console.log(`User ${source.userId} unfollowed`);
  // Cannot reply to unfollow events
  return Promise.resolve(null);
}

// Handle join events (bot joins group/room)
function handleJoinEvent(event) {
  const { replyToken, source } = event;
  
  return client.replyMessage(replyToken, {
    type: 'text',
    text: 'Hello everyone! Thanks for inviting me to this group. 👋\n\nI\'m here to help!'
  });
}

// Handle leave events
function handleLeaveEvent(event) {
  const { source } = event;
  console.log(`Bot left ${source.type}: ${source.groupId || source.roomId}`);
  // Cannot reply to leave events
  return Promise.resolve(null);
}

// Handle member joined events
function handleMemberJoinedEvent(event) {
  const { replyToken, joined } = event;
  const memberCount = joined.members.length;
  
  return client.replyMessage(replyToken, {
    type: 'text',
    text: `Welcome ${memberCount} new member${memberCount > 1 ? 's' : ''} to the group! 🎊`
  });
}

// Handle member left events
function handleMemberLeftEvent(event) {
  const { left } = event;
  console.log(`${left.members.length} member(s) left the group`);
  // Usually don't reply to member left events
  return Promise.resolve(null);
}

// Handle postback events
function handlePostbackEvent(event) {
  const { replyToken, postback } = event;
  const data = postback.data;
  
  // Parse postback data (usually in query string format)
  const params = new URLSearchParams(data);
  const action = params.get('action');
  
  switch (action) {
    case 'buy':
      const itemId = params.get('itemId');
      return client.replyMessage(replyToken, {
        type: 'text',
        text: `Processing purchase for item ${itemId}...`
      });
    case 'cancel':
      return client.replyMessage(replyToken, {
        type: 'text',
        text: 'Action cancelled.'
      });
    default:
      return client.replyMessage(replyToken, {
        type: 'text',
        text: `Postback received: ${data}`
      });
  }
}

// Handle beacon events
function handleBeaconEvent(event) {
  const { replyToken, beacon } = event;
  
  switch (beacon.type) {
    case 'enter':
      return client.replyMessage(replyToken, {
        type: 'text',
        text: 'Welcome! You\'ve entered our beacon area. 📡'
      });
    case 'leave':
      return client.replyMessage(replyToken, {
        type: 'text',
        text: 'Goodbye! You\'ve left our beacon area. 👋'
      });
    case 'banner':
      return client.replyMessage(replyToken, {
        type: 'text',
        text: 'Thanks for tapping the beacon banner!'
      });
    default:
      return Promise.resolve(null);
  }
}

// Error handler
app.use((err, req, res, next) => {
  if (err instanceof line.SignatureValidationFailed) {
    res.status(401).send(err.signature);
    return;
  } else if (err instanceof line.JSONParseError) {
    res.status(400).send(err.raw);
    return;
  }
  next(err); // will throw default 500
});

// Start server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`LINE Bot webhook server is running on port ${port}`);
});

module.exports = { app, client, handleEvent };