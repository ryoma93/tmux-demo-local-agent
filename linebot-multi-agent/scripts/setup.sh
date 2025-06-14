#!/bin/bash

# LINEBot Multi-Agent System Setup Script

SESSION_NAME="linebot-dev"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Kill existing session if it exists
tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? == 0 ]; then
    echo "Killing existing session: $SESSION_NAME"
    tmux kill-session -t $SESSION_NAME
fi

# Create new session with ARCHITECT window
echo "Creating new tmux session: $SESSION_NAME"
tmux new-session -d -s $SESSION_NAME -n ARCHITECT

# Create BACKEND window
tmux new-window -t $SESSION_NAME:1 -n BACKEND

# Create FRONTEND window
tmux new-window -t $SESSION_NAME:2 -n FRONTEND

# Create TESTER window
tmux new-window -t $SESSION_NAME:3 -n TESTER

# Create MONITOR window for observing inter-agent communication
tmux new-window -t $SESSION_NAME:4 -n MONITOR

# Set up each window with appropriate working directory and initial message
# ARCHITECT - System architecture and design decisions
tmux send-keys -t $SESSION_NAME:ARCHITECT "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:ARCHITECT "echo '=== ARCHITECT Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:ARCHITECT "echo 'Role: Design system architecture, API specifications, and database schema'" C-m
tmux send-keys -t $SESSION_NAME:ARCHITECT "echo 'Ready to receive instructions...'" C-m

# BACKEND - Server-side development
tmux send-keys -t $SESSION_NAME:BACKEND "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:BACKEND "echo '=== BACKEND Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:BACKEND "echo 'Role: Implement LINE Bot webhook, business logic, and database operations'" C-m
tmux send-keys -t $SESSION_NAME:BACKEND "echo 'Ready to receive instructions...'" C-m

# FRONTEND - Client-side and LINE messaging
tmux send-keys -t $SESSION_NAME:FRONTEND "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:FRONTEND "echo '=== FRONTEND Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:FRONTEND "echo 'Role: Design LINE messages, Rich menus, Flex messages, and user interactions'" C-m
tmux send-keys -t $SESSION_NAME:FRONTEND "echo 'Ready to receive instructions...'" C-m

# TESTER - Quality assurance
tmux send-keys -t $SESSION_NAME:TESTER "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:TESTER "echo '=== TESTER Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:TESTER "echo 'Role: Write tests, perform integration testing, and validate LINE Bot functionality'" C-m
tmux send-keys -t $SESSION_NAME:TESTER "echo 'Ready to receive instructions...'" C-m

# MONITOR - Communication observer
tmux send-keys -t $SESSION_NAME:MONITOR "cd $BASE_DIR/logs" C-m
tmux send-keys -t $SESSION_NAME:MONITOR "echo '=== MONITOR ===' " C-m
tmux send-keys -t $SESSION_NAME:MONITOR "echo 'Monitoring inter-agent communication...'" C-m
tmux send-keys -t $SESSION_NAME:MONITOR "touch communication.log && tail -f communication.log" C-m

# Select the ARCHITECT window
tmux select-window -t $SESSION_NAME:ARCHITECT

# Attach to the session
echo "Setup complete! Attaching to session..."
echo ""
echo "Agent roles:"
echo "- ARCHITECT: System design and architecture"
echo "- BACKEND: Server implementation and APIs"
echo "- FRONTEND: LINE messaging and UX"
echo "- TESTER: Testing and quality assurance"
echo "- MONITOR: Communication log viewer"
echo ""
echo "Use 'Ctrl-b + window_number' to switch between agents"
echo "Use './scripts/agent-send.sh' to send messages between agents"

tmux attach-session -t $SESSION_NAME