# Backup codes and recovery keys

## Usage

1. Install Ansible (`brew install ansible` or https://www.ansible.com/).
2. Edit the vault: `ansible-vault edit codes-and-keys.txt`.
3. Commit changes.

## Setup

1. Install Ansible (`brew install ansible` or https://www.ansible.com/).
2. Decrypt the vault if encrypted: `ansible-vault decrypt codes-and-keys.txt`.
3. Update the vault as needed.
4. Encrypt the vault: `ansible-vault encrypt codes-and-keys.txt`.
5. Commit.
