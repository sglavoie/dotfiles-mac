packages := "atuin git iterm2 kitty neovim oh-my-posh tmux zsh"

[private]
default:
    @just --list

# Stow all packages to $HOME
all:
    stow --adopt --verbose --target=$HOME --restow {{ packages }}

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
