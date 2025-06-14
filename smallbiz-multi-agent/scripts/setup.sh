#!/bin/bash

# Small Business Planning Multi-Agent System Setup Script

SESSION_NAME="smallbiz-dev"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Kill existing session if it exists
tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? == 0 ]; then
    echo "Killing existing session: $SESSION_NAME"
    tmux kill-session -t $SESSION_NAME
fi

# Create new session with STRATEGIST window
echo "Creating new tmux session: $SESSION_NAME"
tmux new-session -d -s $SESSION_NAME -n STRATEGIST

# Create RESEARCHER window
tmux new-window -t $SESSION_NAME:1 -n RESEARCHER

# Create MARKETER window
tmux new-window -t $SESSION_NAME:2 -n MARKETER

# Create ENGINEER window
tmux new-window -t $SESSION_NAME:3 -n ENGINEER

# Create FINANCIER window
tmux new-window -t $SESSION_NAME:4 -n FINANCIER

# Create MONITOR window for observing inter-agent communication
tmux new-window -t $SESSION_NAME:5 -n MONITOR

# Set up each window with appropriate working directory and initial message
# STRATEGIST - Business strategy and vision
tmux send-keys -t $SESSION_NAME:STRATEGIST "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:STRATEGIST "echo '=== STRATEGIST Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:STRATEGIST "echo 'Role: Define business vision, strategy, and action plans'" C-m
tmux send-keys -t $SESSION_NAME:STRATEGIST "echo 'Ready to receive instructions...'" C-m

# RESEARCHER - Market research and user needs analysis
tmux send-keys -t $SESSION_NAME:RESEARCHER "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:RESEARCHER "echo '=== RESEARCHER Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:RESEARCHER "echo 'Role: Conduct market research, analyze user needs, and validate assumptions'" C-m
tmux send-keys -t $SESSION_NAME:RESEARCHER "echo 'Ready to receive instructions...'" C-m

# MARKETER - Persona design and marketing strategy
tmux send-keys -t $SESSION_NAME:MARKETER "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:MARKETER "echo '=== MARKETER Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:MARKETER "echo 'Role: Create personas, design marketing strategy, and plan SNS campaigns'" C-m
tmux send-keys -t $SESSION_NAME:MARKETER "echo 'Ready to receive instructions...'" C-m

# ENGINEER - Technical feasibility and implementation planning
tmux send-keys -t $SESSION_NAME:ENGINEER "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:ENGINEER "echo '=== ENGINEER Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:ENGINEER "echo 'Role: Assess technical feasibility, design software architecture, and estimate development effort'" C-m
tmux send-keys -t $SESSION_NAME:ENGINEER "echo 'Ready to receive instructions...'" C-m

# FINANCIER - Business model and financial planning
tmux send-keys -t $SESSION_NAME:FINANCIER "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:FINANCIER "echo '=== FINANCIER Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:FINANCIER "echo 'Role: Design business model, calculate financials, and plan revenue streams'" C-m
tmux send-keys -t $SESSION_NAME:FINANCIER "echo 'Ready to receive instructions...'" C-m

# MONITOR - Communication observer
tmux send-keys -t $SESSION_NAME:MONITOR "cd $BASE_DIR/logs" C-m
tmux send-keys -t $SESSION_NAME:MONITOR "echo '=== MONITOR ===' " C-m
tmux send-keys -t $SESSION_NAME:MONITOR "echo 'Monitoring inter-agent communication...'" C-m
tmux send-keys -t $SESSION_NAME:MONITOR "touch communication.log && tail -f communication.log" C-m

# Select the STRATEGIST window
tmux select-window -t $SESSION_NAME:STRATEGIST

# Attach to the session
echo "Setup complete! Attaching to session..."
echo ""
echo "Agent roles:"
echo "- STRATEGIST: Business vision and strategy"
echo "- RESEARCHER: Market research and user analysis" 
echo "- MARKETER: Persona design and marketing strategy"
echo "- ENGINEER: Technical feasibility and architecture"
echo "- FINANCIER: Business model and financial planning"
echo "- MONITOR: Communication log viewer"
echo ""
echo "Use 'Ctrl-b + window_number' to switch between agents"
echo "Use './scripts/agent-send.sh' to send messages between agents"

tmux attach-session -t $SESSION_NAME