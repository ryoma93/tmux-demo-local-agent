# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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