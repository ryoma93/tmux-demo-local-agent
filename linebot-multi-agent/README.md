# LINE Bot Multi-Agent Development System

A tmux-based multi-agent system designed specifically for collaborative LINE Bot development. This system enables multiple specialized agents to work together on different aspects of LINE Bot creation.

## System Architecture

The system consists of four specialized agents:

- **ARCHITECT**: Designs system architecture, API specifications, and database schemas
- **BACKEND**: Implements webhook handlers, business logic, and server-side functionality
- **FRONTEND**: Designs LINE messaging UI including Rich Menus, Flex Messages, and Quick Replies
- **TESTER**: Handles testing strategies, writes tests, and ensures quality assurance

## Quick Start

1. **Setup the multi-agent environment:**
   ```bash
   cd linebot-multi-agent
   ./scripts/setup.sh
   ```

2. **Send messages between agents:**
   ```bash
   # Send a message from ARCHITECT to BACKEND
   ./scripts/agent-send.sh -f ARCHITECT -t BACKEND -m "Please implement the webhook endpoint"

   # Broadcast to all agents
   ./scripts/agent-send.sh -f BACKEND -t ALL -m "Webhook implementation complete" -p HIGH
   ```

3. **Initialize a new LINE Bot project:**
   ```bash
   ./utils/project-init.sh
   ```

## Directory Structure

```
linebot-multi-agent/
├── scripts/              # Automation scripts
│   ├── setup.sh         # Multi-agent tmux setup
│   └── agent-send.sh    # Inter-agent communication
├── instructions/        # Agent role definitions
│   ├── architect/      # ARCHITECT agent instructions
│   ├── backend/        # BACKEND agent instructions
│   ├── frontend/       # FRONTEND agent instructions
│   └── tester/         # TESTER agent instructions
├── templates/          # LINE Bot code templates
│   ├── webhook-handler.js
│   ├── flex-message-template.json
│   ├── rich-menu-template.json
│   └── quick-reply-template.json
├── utils/              # Development utilities
│   ├── line-validator.js
│   ├── message-builder.js
│   └── project-init.sh
└── logs/               # Communication logs
```

## Agent Communication

### Message Priority Levels
- **HIGH**: Critical updates, blockers, or urgent requests
- **MEDIUM**: Standard development communication (default)
- **LOW**: Informational messages, suggestions

### Communication Examples

```bash
# Architecture decision
./scripts/agent-send.sh -f ARCHITECT -t ALL -m "Using Node.js with Express for webhook server" -p HIGH

# Implementation request
./scripts/agent-send.sh -f FRONTEND -t BACKEND -m "Need API endpoint for user preferences"

# Testing notification
./scripts/agent-send.sh -f TESTER -t FRONTEND -m "Found UI issue in Flex Message rendering" -p HIGH
```

## Tmux Navigation

- Switch between agents: `Ctrl-b + [0-4]`
- View agent list: `Ctrl-b + w`
- Detach from session: `Ctrl-b + d`
- Reattach to session: `tmux attach -t linebot-dev`

## Development Workflow

1. **ARCHITECT** designs the system and creates specifications
2. **BACKEND** and **FRONTEND** implement based on specifications
3. **TESTER** continuously tests and provides feedback
4. All agents communicate through the messaging system
5. **MONITOR** window logs all communications

## Templates and Utilities

### Available Templates
- **webhook-handler.js**: Complete webhook handler with all event types
- **flex-message-template.json**: Product card Flex Message example
- **rich-menu-template.json**: 6-tile rich menu configuration
- **quick-reply-template.json**: Various quick reply examples

### Utility Functions
- **line-validator.js**: Webhook signature validation and security
- **message-builder.js**: Helper functions for building LINE messages
- **project-init.sh**: Interactive LINE Bot project generator

## Best Practices

1. Always validate webhook signatures in production
2. Use the message builder utilities for consistent message formatting
3. Test with LINE's messaging API simulator
4. Monitor rate limits and implement appropriate throttling
5. Keep sensitive data (channel secret, access token) in environment variables

## Resources

- [LINE Developers Documentation](https://developers.line.biz/en/docs/)
- [LINE Bot Designer](https://developers.line.biz/en/services/bot-designer/)
- [Messaging API Reference](https://developers.line.biz/en/reference/messaging-api/)