#!/bin/bash

# Agent Communication Script for Data Pipeline Multi-Agent System

SESSION_NAME="data-pipeline-dev"
LOG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../logs" && pwd)"
LOG_FILE="$LOG_DIR/communication.log"

# Function to display usage
usage() {
    echo "Usage: $0 -f FROM_AGENT -t TO_AGENT -m MESSAGE [-p PRIORITY]"
    echo ""
    echo "Options:"
    echo "  -f FROM_AGENT   The sending agent (COLLECTOR, PROCESSOR, ANALYZER, STORAGE)"
    echo "  -t TO_AGENT     The receiving agent (COLLECTOR, PROCESSOR, ANALYZER, STORAGE, ALL)"
    echo "  -m MESSAGE      The message to send"
    echo "  -p PRIORITY     Message priority (HIGH, MEDIUM, LOW) [default: MEDIUM]"
    echo ""
    echo "Examples:"
    echo "  $0 -f COLLECTOR -t PROCESSOR -m 'Raw data collection complete, ready for processing'"
    echo "  $0 -f PROCESSOR -t ALL -m 'Data cleaning pipeline updated' -p HIGH"
    echo "  $0 -f ANALYZER -t STORAGE -m 'Analysis complete, recommend index optimization'"
    exit 1
}

# Initialize variables
FROM_AGENT=""
TO_AGENT=""
MESSAGE=""
PRIORITY="MEDIUM"

# Parse command line arguments
while getopts "f:t:m:p:h" opt; do
    case $opt in
        f) FROM_AGENT="$OPTARG" ;;
        t) TO_AGENT="$OPTARG" ;;
        m) MESSAGE="$OPTARG" ;;
        p) PRIORITY="$OPTARG" ;;
        h) usage ;;
        \?) echo "Invalid option -$OPTARG" >&2; usage ;;
    esac
done

# Validate required arguments
if [ -z "$FROM_AGENT" ] || [ -z "$TO_AGENT" ] || [ -z "$MESSAGE" ]; then
    echo "Error: Missing required arguments"
    usage
fi

# Validate agents
VALID_AGENTS="COLLECTOR PROCESSOR ANALYZER STORAGE"
if [[ ! " $VALID_AGENTS " =~ " $FROM_AGENT " ]]; then
    echo "Error: Invalid FROM_AGENT: $FROM_AGENT"
    usage
fi

if [[ ! " $VALID_AGENTS ALL " =~ " $TO_AGENT " ]]; then
    echo "Error: Invalid TO_AGENT: $TO_AGENT"
    usage
fi

# Validate priority
VALID_PRIORITIES="HIGH MEDIUM LOW"
if [[ ! " $VALID_PRIORITIES " =~ " $PRIORITY " ]]; then
    echo "Error: Invalid PRIORITY: $PRIORITY"
    usage
fi

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to send message to a specific agent
send_to_agent() {
    local agent=$1
    local formatted_msg="[$(date '+%Y-%m-%d %H:%M:%S')] [$PRIORITY] FROM: $FROM_AGENT -> TO: $agent"
    local content_msg="MESSAGE: $MESSAGE"
    
    # Send message to agent's tmux window
    tmux send-keys -t "$SESSION_NAME:$agent" "" C-m
    tmux send-keys -t "$SESSION_NAME:$agent" "echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'" C-m
    tmux send-keys -t "$SESSION_NAME:$agent" "echo '$formatted_msg'" C-m
    tmux send-keys -t "$SESSION_NAME:$agent" "echo '$content_msg'" C-m
    tmux send-keys -t "$SESSION_NAME:$agent" "echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'" C-m
    
    # Log the message
    echo "$formatted_msg" >> "$LOG_FILE"
    echo "$content_msg" >> "$LOG_FILE"
    echo "----------------------------------------" >> "$LOG_FILE"
}

# Check if tmux session exists
tmux has-session -t "$SESSION_NAME" 2>/dev/null
if [ $? != 0 ]; then
    echo "Error: tmux session '$SESSION_NAME' not found"
    echo "Please run ./scripts/setup.sh first"
    exit 1
fi

# Send message
if [ "$TO_AGENT" = "ALL" ]; then
    echo "Broadcasting message from $FROM_AGENT to all agents..."
    for agent in $VALID_AGENTS; do
        if [ "$agent" != "$FROM_AGENT" ]; then
            send_to_agent "$agent"
        fi
    done
    echo "Message broadcast complete!"
else
    echo "Sending message from $FROM_AGENT to $TO_AGENT..."
    send_to_agent "$TO_AGENT"
    echo "Message sent!"
fi

# Also display in sender's window for confirmation
tmux send-keys -t "$SESSION_NAME:$FROM_AGENT" "" C-m
tmux send-keys -t "$SESSION_NAME:$FROM_AGENT" "echo '✓ Message sent to: $TO_AGENT'" C-m