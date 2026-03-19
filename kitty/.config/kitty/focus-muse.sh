#!/bin/sh
# Find the muse window and activate it in the stack layout

MUSE_INFO=$(kitten @ ls | jq -r '
  [.[] | .tabs[] | . as $tab | .windows | to_entries[] |
   select(.value.title == "muse") |
   {tab_id: $tab.id, window_index: .key}] | .[0]')

[ -z "$MUSE_INFO" ] || [ "$MUSE_INFO" = "null" ] && exit 0

TAB_ID=$(echo "$MUSE_INFO" | jq -r '.tab_id')
WIN_IDX=$(echo "$MUSE_INFO" | jq -r '.window_index')

kitten @ focus-tab --match "id:$TAB_ID"
kitten @ action nth_window "$WIN_IDX"
