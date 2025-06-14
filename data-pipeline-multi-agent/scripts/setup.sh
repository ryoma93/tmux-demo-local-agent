#!/bin/bash

# Data Pipeline Multi-Agent System Setup Script

SESSION_NAME="data-pipeline-dev"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Kill existing session if it exists
tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? == 0 ]; then
    echo "Killing existing session: $SESSION_NAME"
    tmux kill-session -t $SESSION_NAME
fi

# Create new session with COLLECTOR window
echo "Creating new tmux session: $SESSION_NAME"
tmux new-session -d -s $SESSION_NAME -n COLLECTOR

# Create PROCESSOR window
tmux new-window -t $SESSION_NAME:1 -n PROCESSOR

# Create ANALYZER window
tmux new-window -t $SESSION_NAME:2 -n ANALYZER

# Create STORAGE window
tmux new-window -t $SESSION_NAME:3 -n STORAGE

# Create MONITOR window for observing inter-agent communication
tmux new-window -t $SESSION_NAME:4 -n MONITOR

# Set up each window with appropriate working directory and initial message
# COLLECTOR - Data collection from various sources
tmux send-keys -t $SESSION_NAME:COLLECTOR "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:COLLECTOR "echo '=== COLLECTOR Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:COLLECTOR "echo 'Role: Collect data from APIs, files, databases, and streaming sources'" C-m
tmux send-keys -t $SESSION_NAME:COLLECTOR "echo 'Ready to receive instructions...'" C-m

# PROCESSOR - Data cleaning and transformation
tmux send-keys -t $SESSION_NAME:PROCESSOR "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:PROCESSOR "echo '=== PROCESSOR Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:PROCESSOR "echo 'Role: Clean, transform, and standardize raw data for analysis'" C-m
tmux send-keys -t $SESSION_NAME:PROCESSOR "echo 'Ready to receive instructions...'" C-m

# ANALYZER - Data analysis and insights
tmux send-keys -t $SESSION_NAME:ANALYZER "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:ANALYZER "echo '=== ANALYZER Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:ANALYZER "echo 'Role: Perform statistical analysis, quality assessment, and anomaly detection'" C-m
tmux send-keys -t $SESSION_NAME:ANALYZER "echo 'Ready to receive instructions...'" C-m

# STORAGE - Data storage and optimization
tmux send-keys -t $SESSION_NAME:STORAGE "cd $BASE_DIR" C-m
tmux send-keys -t $SESSION_NAME:STORAGE "echo '=== STORAGE Agent ===' " C-m
tmux send-keys -t $SESSION_NAME:STORAGE "echo 'Role: Design and manage optimal data storage solutions'" C-m
tmux send-keys -t $SESSION_NAME:STORAGE "echo 'Ready to receive instructions...'" C-m

# MONITOR - Communication observer
tmux send-keys -t $SESSION_NAME:MONITOR "cd $BASE_DIR/logs" C-m
tmux send-keys -t $SESSION_NAME:MONITOR "echo '=== MONITOR ===' " C-m
tmux send-keys -t $SESSION_NAME:MONITOR "echo 'Monitoring inter-agent communication...'" C-m
tmux send-keys -t $SESSION_NAME:MONITOR "touch communication.log && tail -f communication.log" C-m

# Select the COLLECTOR window
tmux select-window -t $SESSION_NAME:COLLECTOR

# Attach to the session
echo "Setup complete! Attaching to session..."
echo ""
echo "Agent roles:"
echo "- COLLECTOR: Data collection from various sources"
echo "- PROCESSOR: Data cleaning and transformation"
echo "- ANALYZER: Statistical analysis and quality assessment"
echo "- STORAGE: Data storage and optimization"
echo "- MONITOR: Communication log viewer"
echo ""
echo "Use 'Ctrl-b + window_number' to switch between agents"
echo "Use './scripts/agent-send.sh' to send messages between agents"

tmux attach-session -t $SESSION_NAME