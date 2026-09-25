#!/usr/bin/env bash
# Copy the curated paid/proprietary fonts into ~/Library/Fonts.
#
# The fonts live outside the repo (they can't be redistributed) and are
# restored from the backup. Free fonts come from the Brewfile's font casks.
# Run with `just fonts`; safe to rerun.
set -euo pipefail

src="$HOME/Documents/21_programming/fonts"
dest="$HOME/Library/Fonts"

if [[ ! -d "$src" ]]; then
	echo "install-fonts: $src is missing; restore it from the backup first" >&2
	exit 1
fi

mkdir -p "$dest"
count=0
while IFS= read -r -d '' font; do
	cp -p "$font" "$dest/"
	count=$((count + 1))
done < <(find "$src" -type f ! -name '.*' \( -iname '*.ttf' -o -iname '*.otf' \) -print0)

echo "install-fonts: copied $count fonts into $dest"
