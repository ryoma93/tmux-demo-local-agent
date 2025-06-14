#!/bin/bash

# LINE Bot Project Initialization Script
# This script helps initialize a new LINE Bot project with necessary files and dependencies

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project name from argument or prompt
PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${BLUE}LINE Bot Project Initializer${NC}"
    echo -e "${YELLOW}Enter project name:${NC}"
    read PROJECT_NAME
fi

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Project name is required${NC}"
    exit 1
fi

# Create project directory
echo -e "${GREEN}Creating project directory: $PROJECT_NAME${NC}"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create directory structure
echo -e "${GREEN}Creating project structure...${NC}"
mkdir -p src/{handlers,utils,messages,config}
mkdir -p tests
mkdir -p assets/{images,audio}
mkdir -p logs

# Create package.json
echo -e "${GREEN}Initializing package.json...${NC}"
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "LINE Bot application",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "lint": "eslint src/",
    "deploy": "echo 'Add your deployment script here'"
  },
  "keywords": ["line", "bot", "webhook"],
  "author": "",
  "license": "MIT",
  "dependencies": {
    "@line/bot-sdk": "^7.5.2",
    "express": "^4.18.2",
    "dotenv": "^16.0.3",
    "axios": "^1.3.4",
    "body-parser": "^1.20.2",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.20",
    "eslint": "^8.35.0",
    "jest": "^29.4.3",
    "supertest": "^6.3.3"
  }
}
EOF

# Create .env.example
echo -e "${GREEN}Creating environment configuration...${NC}"
cat > .env.example << EOF
# LINE Bot Configuration
LINE_CHANNEL_ACCESS_TOKEN=your_channel_access_token_here
LINE_CHANNEL_SECRET=your_channel_secret_here

# Server Configuration
PORT=3000
NODE_ENV=development

# Database Configuration (if needed)
# DATABASE_URL=your_database_url_here

# API Keys (if needed)
# EXTERNAL_API_KEY=your_api_key_here

# Logging
LOG_LEVEL=info
EOF

# Copy .env.example to .env
cp .env.example .env

# Create .gitignore
echo -e "${GREEN}Creating .gitignore...${NC}"
cat > .gitignore << EOF
# Dependencies
node_modules/

# Environment variables
.env

# Logs
logs/
*.log
npm-debug.log*

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Build output
dist/
build/

# Test coverage
coverage/
.nyc_output/

# Temporary files
tmp/
temp/
EOF

# Create main application file
echo -e "${GREEN}Creating main application file...${NC}"
cat > src/index.js << EOF
require('dotenv').config();
const express = require('express');
const line = require('@line/bot-sdk');
const morgan = require('morgan');
const { webhookHandler } = require('./handlers/webhook');

// Validate environment variables
const requiredEnvVars = ['LINE_CHANNEL_ACCESS_TOKEN', 'LINE_CHANNEL_SECRET'];
for (const envVar of requiredEnvVars) {
  if (!process.env[envVar]) {
    console.error(\`Error: \${envVar} is not set in environment variables\`);
    process.exit(1);
  }
}

// LINE Bot configuration
const config = {
  channelAccessToken: process.env.LINE_CHANNEL_ACCESS_TOKEN,
  channelSecret: process.env.LINE_CHANNEL_SECRET,
};

// Create Express app
const app = express();

// Middleware
app.use(morgan('combined'));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Webhook endpoint
app.post('/webhook', line.middleware(config), webhookHandler);

// Error handling middleware
app.use((err, req, res, next) => {
  if (err instanceof line.SignatureValidationFailed) {
    res.status(401).send(err.signature);
    return;
  } else if (err instanceof line.JSONParseError) {
    res.status(400).send(err.raw);
    return;
  }
  next(err);
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(\`LINE Bot server is running on port \${PORT}\`);
  console.log(\`Webhook URL: https://your-domain.com/webhook\`);
});
EOF

# Create webhook handler
echo -e "${GREEN}Creating webhook handler...${NC}"
cat > src/handlers/webhook.js << EOF
const line = require('@line/bot-sdk');
const { handleTextMessage } = require('./message');
const { handlePostback } = require('./postback');

// Create LINE SDK client
const client = new line.Client({
  channelAccessToken: process.env.LINE_CHANNEL_ACCESS_TOKEN,
});

/**
 * Main webhook handler
 * @param {object} req - Express request object
 * @param {object} res - Express response object
 */
async function webhookHandler(req, res) {
  try {
    const results = await Promise.all(
      req.body.events.map(handleEvent)
    );
    
    res.json(results);
  } catch (err) {
    console.error('Webhook handler error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * Handle individual events
 * @param {object} event - LINE webhook event
 */
async function handleEvent(event) {
  console.log('Event:', JSON.stringify(event, null, 2));

  switch (event.type) {
    case 'message':
      if (event.message.type === 'text') {
        return handleTextMessage(event, client);
      }
      break;
    
    case 'postback':
      return handlePostback(event, client);
    
    case 'follow':
      return client.replyMessage(event.replyToken, {
        type: 'text',
        text: 'Welcome! Thanks for adding me as a friend. Type "help" to get started!'
      });
    
    default:
      console.log(\`Unhandled event type: \${event.type}\`);
      return Promise.resolve(null);
  }
}

module.exports = { webhookHandler, handleEvent };
EOF

# Create message handler
echo -e "${GREEN}Creating message handler...${NC}"
cat > src/handlers/message.js << EOF
/**
 * Handle text message events
 * @param {object} event - LINE webhook event
 * @param {object} client - LINE SDK client
 */
async function handleTextMessage(event, client) {
  const { text } = event.message;
  const { replyToken } = event;
  
  // Convert to lowercase for easier matching
  const command = text.toLowerCase().trim();
  
  let replyMessage;
  
  switch (command) {
    case 'help':
      replyMessage = {
        type: 'text',
        text: 'Available commands:\\n' +
              '• help - Show this help message\\n' +
              '• menu - Show quick reply menu\\n' +
              '• about - About this bot\\n' +
              '• echo <text> - Echo your message'
      };
      break;
    
    case 'menu':
      replyMessage = {
        type: 'text',
        text: 'Please select an option:',
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
            },
            {
              type: 'action',
              action: {
                type: 'postback',
                label: 'Settings',
                data: 'action=settings',
                displayText: 'Open settings'
              }
            }
          ]
        }
      };
      break;
    
    case 'about':
      replyMessage = {
        type: 'text',
        text: 'This is a LINE Bot created with Node.js.\\n' +
              'Version: 1.0.0'
      };
      break;
    
    default:
      if (text.startsWith('echo ')) {
        const echoText = text.substring(5);
        replyMessage = {
          type: 'text',
          text: \`Echo: \${echoText}\`
        };
      } else {
        replyMessage = {
          type: 'text',
          text: \`You said: "\${text}"\\n\\nType "help" to see available commands.\`
        };
      }
  }
  
  return client.replyMessage(replyToken, replyMessage);
}

module.exports = { handleTextMessage };
EOF

# Create postback handler
echo -e "${GREEN}Creating postback handler...${NC}"
cat > src/handlers/postback.js << EOF
/**
 * Handle postback events
 * @param {object} event - LINE webhook event
 * @param {object} client - LINE SDK client
 */
async function handlePostback(event, client) {
  const { data } = event.postback;
  const { replyToken } = event;
  
  // Parse postback data
  const params = new URLSearchParams(data);
  const action = params.get('action');
  
  let replyMessage;
  
  switch (action) {
    case 'settings':
      replyMessage = {
        type: 'text',
        text: 'Settings menu (not implemented yet)'
      };
      break;
    
    default:
      replyMessage = {
        type: 'text',
        text: \`Received postback: \${data}\`
      };
  }
  
  return client.replyMessage(replyToken, replyMessage);
}

module.exports = { handlePostback };
EOF

# Create README.md
echo -e "${GREEN}Creating README.md...${NC}"
cat > README.md << EOF
# $PROJECT_NAME

LINE Bot application built with Node.js and Express.

## Setup

1. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

2. Configure environment variables:
   - Copy \`.env.example\` to \`.env\`
   - Add your LINE channel access token and secret

3. Start the development server:
   \`\`\`bash
   npm run dev
   \`\`\`

## Project Structure

\`\`\`
$PROJECT_NAME/
├── src/
│   ├── index.js          # Main application entry point
│   ├── handlers/         # Event handlers
│   │   ├── webhook.js    # Main webhook handler
│   │   ├── message.js    # Message event handlers
│   │   └── postback.js   # Postback event handlers
│   ├── utils/            # Utility functions
│   ├── messages/         # Message templates
│   └── config/           # Configuration files
├── tests/                # Test files
├── assets/               # Static assets
├── logs/                 # Log files
├── .env                  # Environment variables (not in git)
├── .env.example          # Environment variables example
├── .gitignore            # Git ignore file
├── package.json          # NPM package configuration
└── README.md             # This file
\`\`\`

## Available Scripts

- \`npm start\` - Start the production server
- \`npm run dev\` - Start the development server with auto-reload
- \`npm test\` - Run tests
- \`npm run lint\` - Run ESLint

## Webhook URL

After deploying your bot, set the webhook URL in LINE Developers Console:
\`\`\`
https://your-domain.com/webhook
\`\`\`

## Features

- Basic message handling
- Quick reply support
- Postback handling
- Health check endpoint
- Error handling
- Logging

## License

MIT
EOF

# Create a simple test file
echo -e "${GREEN}Creating test file...${NC}"
cat > tests/webhook.test.js << EOF
const request = require('supertest');
const { app } = require('../src');

describe('Webhook Tests', () => {
  test('Health check should return 200', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('ok');
  });

  test('Webhook without signature should return 401', async () => {
    const response = await request(app)
      .post('/webhook')
      .send({ events: [] });
    expect(response.status).toBe(401);
  });
});
EOF

# Create ESLint configuration
echo -e "${GREEN}Creating ESLint configuration...${NC}"
cat > .eslintrc.json << EOF
{
  "env": {
    "node": true,
    "es2021": true,
    "jest": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "rules": {
    "indent": ["error", 2],
    "quotes": ["error", "single"],
    "semi": ["error", "always"],
    "no-unused-vars": ["warn"],
    "no-console": ["off"]
  }
}
EOF

# Install dependencies
echo -e "${GREEN}Installing dependencies...${NC}"
npm install

# Success message
echo -e "${GREEN}✅ LINE Bot project '$PROJECT_NAME' has been initialized successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Navigate to the project: ${BLUE}cd $PROJECT_NAME${NC}"
echo -e "2. Update ${BLUE}.env${NC} with your LINE channel credentials"
echo -e "3. Start development: ${BLUE}npm run dev${NC}"
echo -e "4. Deploy to your hosting service"
echo -e "5. Set webhook URL in LINE Developers Console"
echo ""
echo -e "${GREEN}Happy coding! 🤖${NC}"