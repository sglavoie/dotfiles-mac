#!/bin/bash

# Get the name of all running sessions
TMUX_SESSIONS=`tmux ls | cut -f1 -d ":" 2>&1`

# # No listed session, then notify about it
echo "$TMUX_SESSIONS" | grep -q "no server running" \
    && echo "No active tmux session found" \
    && exit 0

# Show all running sessions with fzf and store the selection in a variable
SESSION=`echo -n "$TMUX_SESSIONS" | fzf`

if [[ ! -z "$SESSION" ]]; then
  # Kill the selected session
  tmux kill-session -t $SESSION
fi

