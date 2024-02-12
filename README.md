# Dotfiles - macOS

## Starting from scratch

1. Go through the installation wizard.
2. Log in with Apple ID, log into App Store.

```bash
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/sglavoie/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Ansible
brew install ansible

# Clone dotfiles
git clone git@github.com:sglavoie/dotfiles-mac.git ~/dotfiles

# Run the Ansible playbook
cd ~/dotfiles/ansible
ansible-playbook main.yml -K
```

## Dotfiles usage

```bash
brew install stow  # if not already installed
git clone git@github.com:sglavoie/dotfiles-mac.git ~/dotfiles
cd ~/dotfiles
make
```

### Update/recreate dotfiles

```bash
make
```

### Remove all dotfiles symlinks

```bash
make delete
```

## Get installed Homebrew packages and casks

```bash
brew leaves | xargs brew desc --eval-all
brew ls --casks | xargs brew desc --eval-all
```
