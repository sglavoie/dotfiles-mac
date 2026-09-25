packages := "atuin ghostty git karabiner kitty neovim oh-my-posh osxphotos-backup tmux zsh"

[private]
default:
    @just --list

# Stow all packages to $HOME
all: hooks
    stow --adopt --verbose --target=$HOME --restow {{ packages }}

# Point git at the repo's tracked hooks (not stored in a clone's .git/config)
hooks:
    git config core.hooksPath .githooks

# Copy configs that cannot be symlinked into the repo (also run by pre-commit)
sync:
    ./scripts/sync-karabiner.sh

# Unstow all packages from $HOME
delete:
    stow --verbose --target=$HOME --delete {{ packages }}

# Apply scriptable macOS settings (asks for sudo for DevToolsSecurity)
macos:
    ./scripts/macos-defaults.sh

# Copy the curated fonts from ~/Documents/21_programming/fonts into ~/Library/Fonts
fonts:
    ./scripts/install-fonts.sh
