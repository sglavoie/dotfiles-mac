# Lives in ~/scripts; a fresh Mac without it has nothing folded to check
unfold := env_var("HOME") / "scripts/bin/.local/bin/stow-unfold"
packages := "atuin ghostty git karabiner kitty neovim oh-my-posh osxphotos-backup zsh"

[private]
default:
    @just --list

# --no-folding links files one by one, so a program writing into
# ~/.config/<app> never writes into this repo; a conflict with an existing real
# file aborts instead of being adopted (see `just adopt`).
# Stow all packages to $HOME
all: hooks
    if [ -x "{{ unfold }}" ]; then "{{ unfold }}" --check {{ packages }}; fi
    stow --no-folding --verbose --target=$HOME --restow {{ packages }}

# Take conflicting real files in $HOME into the repo instead (review with git diff)
adopt: hooks
    stow --no-folding --adopt --verbose --target=$HOME --restow {{ packages }}

# Repair directories an older, folding stow linked wholesale (dry run: just unfold)
unfold *apply:
    "{{ unfold }}" {{ apply }} {{ packages }}

# Point git at the repo's tracked hooks (not stored in a clone's .git/config)
hooks:
    git config core.hooksPath .githooks

# Copy configs that cannot be symlinked into the repo (also run by pre-commit)
sync:
    ./scripts/sync-karabiner.sh

# Unstow all packages from $HOME
delete:
    stow --no-folding --verbose --target=$HOME --delete {{ packages }}

# Apply scriptable macOS settings (asks for sudo for DevToolsSecurity)
macos:
    ./scripts/macos-defaults.sh

# Copy the curated fonts from ~/Documents/21_programming/fonts into ~/Library/Fonts
fonts:
    ./scripts/install-fonts.sh

# Print the decrypted backup codes (asks for the passphrase without the local key)
codes-show:
    ./scripts/backup-codes.sh show

# Edit the backup codes in $VISUAL/$EDITOR and re-encrypt them
codes-edit:
    ./scripts/backup-codes.sh edit

# New machine: restore ~/.config/age/backup-codes.key from identity.age (passphrase)
codes-unlock:
    ./scripts/backup-codes.sh unlock
