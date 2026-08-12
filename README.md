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
cd ~/dotfiles
just ansible
```

## Re-running parts of the setup

Each task file is tagged, so you can re-run specific parts with `--tags`:

```bash
cd ~/dotfiles/ansible

# Run only Homebrew packages and casks
ansible-playbook main.yml -K --tags homebrew

# Run only npm packages
ansible-playbook main.yml -K --tags npm

# Run only macOS system defaults
ansible-playbook main.yml -K --tags mac

# Combine multiple tags
ansible-playbook main.yml -K --tags "homebrew,npm"
```

Available tags: `ansible-playbook main.yml --list-tags`.

## Dotfiles usage

```bash
brew install stow  # if not already installed
git clone git@github.com:sglavoie/dotfiles-mac.git ~/dotfiles
cd ~/dotfiles
just
```

### Update/recreate dotfiles

```bash
just all
```

### Remove all dotfiles symlinks

```bash
just delete
```

### Apple Photos backup configuration

The `osxphotos-backup` package holds
`~/.config/osxphotos-backup/photos-backup.toml`, read by the `photos-backup`
CLI from `dev-helpers/python/photos_backup`. Stow it alone with:

```bash
stow --no --verbose --target=$HOME osxphotos-backup   # simulate
stow --verbose --target=$HOME osxphotos-backup        # link
```

`~/.config/osxphotos-backup` is a symlink into this repository, so editing the
file here changes the live configuration; commit and `git pull` on the other Mac
to carry it over, without restowing. `apple_photos.volume` and
`apple_photos.archive` are shared by every Mac using the drive;
`apple_photos.library`, `[sd_card]`, and `[ssd]` are the per-Mac lines, and a Mac
lacking one of those simply omits the section.

On a Mac that already keeps a real `~/.config/osxphotos-backup/photos-backup.toml`,
move it aside before stowing: `just all` runs stow with `--adopt`, which would
replace the repository copy with that file instead of the other way around.

## Detect drift between dotfiles and installed packages

```bash
just drift
just drift --no-color  # for piping to a file
```

This compares brew formulae, casks, fonts, npm packages, and VS Code extensions defined in `ansible/` against what's actually installed on the system.

## External dependencies

Some configuration lives outside this repo:

- **`~/scripts`** — custom scripts, launch agents (`com.sglavoie.*` plists), and `~/.local/bin/` symlinks
- **`~/Documents/21_programming/git/gitconfig-sglavoie`** — private git identity (included by `.gitconfig`)
- **`~/Documents/21_programming/zsh/environ.variables`** — private shell variables (sourced by `.zshrc`)
- **`~/Documents/21_programming/fonts/`** — custom fonts installed by Ansible
- **SSH config (`~/.ssh/config`)** — tracked in `~/scripts` repo (contains host-specific info)
