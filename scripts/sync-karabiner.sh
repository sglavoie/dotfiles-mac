#!/usr/bin/env bash
# Copy the live Karabiner-Elements config into the repo.
#
# karabiner.json cannot be stowed (see karabiner/.stow-local-ignore), so the
# repo holds a copy rather than a symlink. This keeps that copy current.
# Invoked by .githooks/pre-commit; also runnable by hand via `just sync`.
set -euo pipefail

live="$HOME/.config/karabiner/karabiner.json"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tracked_rel="karabiner/.config/karabiner/karabiner.json"
tracked="$repo_root/$tracked_rel"

if [[ ! -f "$live" ]]; then
	echo "sync-karabiner: no live config at $live; skipping" >&2
	exit 0
fi

# Never copy a truncated or corrupt config over the tracked one.
if ! /usr/bin/python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$live" 2>/dev/null; then
	echo "sync-karabiner: $live is not valid JSON; refusing to sync" >&2
	exit 1
fi

if cmp -s "$live" "$tracked"; then
	exit 0
fi

cp "$live" "$tracked"
echo "sync-karabiner: updated $tracked_rel"
