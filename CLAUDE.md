# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## **最重要ルール・・・新しいルールの追加プロセス**
ユーザーから今回限りではなく常に対応が必要だと思われる指示を受けた場合： 

1. 「これを標準のルールにしますか？」と質問する 
2. YESの回答を得た場合、CLAUDE.mdに追加ルールとして記載する 
3. 以降は標準ルールとして常に適用する 

このプロセスにより、プロジェクトのルールを継続的に改善していきます。

## Commands

### Multi-Agent System Management
```bash
# Start the multi-agent tmux session
cd linebot-multi-agent && ./scripts/setup.sh

# Send messages between agents
./scripts/agent-send.sh -f FROM_AGENT -t TO_AGENT -m "message" [-p PRIORITY]

# Examples:
./scripts/agent-send.sh -f ARCHITECT -t BACKEND -m "Please implement webhook endpoint"
./scripts/agent-send.sh -f BACKEND -t ALL -m "Webhook implementation complete" -p HIGH

# Initialize a new LINE Bot project
./utils/project-init.sh
```

### Cloudflare Deployment with Wrangler
```bash
# Install Wrangler CLI globally
npm install -g wrangler

# Login to Cloudflare
wrangler login

# Initialize Cloudflare Worker project
wrangler init my-linebot-worker

# Deploy to Cloudflare
wrangler deploy

# View deployment logs
wrangler tail

# Manage secrets
wrangler secret put SECRET_NAME
wrangler secret list
```

### Tmux Session Control
```bash
# Attach to existing session
tmux attach -t linebot-dev

# Kill session
tmux kill-session -t linebot-dev

# Navigation within tmux
# Ctrl-b + [0-4] - Switch between agent windows
# Ctrl-b + d     - Detach from session
# Ctrl-b + w     - List all windows
```

## Architecture

This is a tmux-based multi-agent system for LINE Bot development. The architecture consists of:

### Agent Hierarchy
- **ARCHITECT** (Window 0): System design, API specifications, database schemas
- **BACKEND** (Window 1): Webhook implementation, business logic, server-side code
- **FRONTEND** (Window 2): LINE messaging UI (Rich Menus, Flex Messages, Quick Replies)
- **TESTER** (Window 3): Testing strategies, quality assurance
- **MONITOR** (Window 4): Communication logger (watches logs/communication.log)

### Inter-Agent Communication Protocol
- Messages are sent via `agent-send.sh` with priority levels (HIGH, MEDIUM, LOW)
- All communications are logged to `logs/communication.log`
- Agents can broadcast to ALL or send targeted messages
- Messages appear in tmux windows with timestamps and formatting

### Key Components
- **scripts/setup.sh**: Creates tmux session with 5 windows, initializes each agent
- **scripts/agent-send.sh**: Handles message routing and logging between agents
- **instructions/[agent]/*.md**: Role definitions for each agent type
- **templates/**: LINE Bot code templates (webhook handlers, message formats)
- **utils/**: Development utilities (validators, message builders, project init)

### LINE Bot Development Focus
The system is specifically designed for LINE Bot development with:
- Pre-built templates for Flex Messages, Rich Menus, Quick Replies
- Webhook signature validation utilities
- Message builder helper functions
- Project initialization script that creates a complete LINE Bot structure

When working on LINE Bot features, reference the templates in `templates/` and utilities in `utils/` for LINE-specific implementations.

## Deployment Standards

### Cloudflare Workers Deployment
All multi-agent developed applications must be designed for Cloudflare Workers deployment:

- **ARCHITECT**: Design APIs compatible with Cloudflare Workers runtime
- **BACKEND**: Implement webhook handlers using Cloudflare Workers patterns
- **FRONTEND**: Ensure LINE messaging components work with Workers environment
- **TESTER**: Include Cloudflare Workers-specific testing strategies

### Required Configuration
Each project must include:
- `wrangler.toml` configuration file
- Environment variables setup for LINE Bot credentials
- Proper routing configuration for webhook endpoints
- TypeScript support for Workers runtime APIs

### Development Workflow
1. Initialize projects with `wrangler init`
2. Configure `wrangler.toml` for LINE Bot requirements
3. Use `wrangler dev` for local development
4. Deploy with `wrangler deploy`
5. Monitor with `wrangler tail`

Reference: https://developers.cloudflare.com/workers/get-started/guide/