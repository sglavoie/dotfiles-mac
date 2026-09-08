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

# Run the Ansible playbook (pass tags to run specific parts, e.g. just ansible --tags homebrew)
ansible *args:
    #!/usr/bin/env bash
    read -rsp "BECOME password: " SUDO_PASS; echo
    echo "$SUDO_PASS" | sudo -S -v 2>/dev/null
    ansible-playbook ansible/main.yml -i ansible/inventory \
      -e "ansible_become_pass=$SUDO_PASS" \
      {{ args }}

# List available Ansible playbook tags
tags:
    @ansible-playbook ansible/main.yml -i ansible/inventory --list-tags

# Compare dotfiles-defined packages vs what's installed
drift *args:
    ./ansible/scripts/dotfiles_drift.sh {{ args }}
