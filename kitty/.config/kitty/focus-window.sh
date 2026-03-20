#!/bin/sh
# Find a window by title and activate it in the stack layout

WINDOW_TITLE="${1:-$FOCUS_WINDOW_TITLE}"

if [ -z "$WINDOW_TITLE" ]; then
  echo "Usage: focus-window.sh <window-title>" >&2
  echo "  or set FOCUS_WINDOW_TITLE env var" >&2
  exit 1
fi

WIN_ID=$(kitten @ ls | jq -r --arg title "$WINDOW_TITLE" '
  [.[] | .tabs[] | .windows[] | select(.title == $title) | .id] | .[0]')

[ -z "$WIN_ID" ] || [ "$WIN_ID" = "null" ] && exit 0

kitten @ focus-window --match "id:$WIN_ID"
