#!/usr/bin/env bash

# Adapted from
# https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

# Manually name a session or pick an existing project from a list
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/dev/sglavoie ~/dev/uol ~/dev/tradition/projects \
        -type d -maxdepth 2 -name '.git' \
        | sed -E 's|/[^/]+$||' |sort -u | fzf)
fi

# No selection: exit
if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# If tmux isn't running already, then create the session
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

# If tmux is running but the session does not exist already, create it
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

# Switch to the selected session
tmux switch-client -t $selected_name

# Little hack so that any unnamed session that was created is removed
# (i.e., those labelled with just an integer)
for i in {0..99}; do
    if tmux has-session -t $i 2> /dev/null; then
        tmux kill-session -t $i
    fi
done

