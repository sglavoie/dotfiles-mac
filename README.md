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

## How stow works

Each top-level directory in this repo (`git`, `zsh`, `tmux`, …) is a **stow
package**. The contents of a package mirror the layout of `$HOME`, so
`zsh/.config/zsh/aliases` in the repo becomes `~/.config/zsh/aliases` on the
system. Stow never copies anything: it creates symlinks pointing back into the
repo, which is why editing a file here immediately changes the live config.

The package list lives in the `packages` variable at the top of the `justfile`.
A new package only needs a new directory plus its name added there.

Useful flags (all used with `--target=$HOME` from the repo root):

| Flag | Effect |
| --- | --- |
| `--no` / `-n` | Simulate only; print what would happen and change nothing. Always pair with `--verbose`. |
| `--verbose` | Show each link created or removed. Repeat (`-vv`) for more detail. |
| `--restow` | Unstow then stow again. This is what `just all` does; it cleans up links for files that were renamed or deleted in the repo. |
| `--delete` | Remove the symlinks a package owns, leaving the repo untouched. |
| `--adopt` | Resolve conflicts by *moving the existing file into the repo* (see below). |

### Tree folding

If a directory does not exist in `$HOME` yet, stow symlinks the whole directory
rather than each file inside it (`~/.config/atuin` becomes one link). When a
second package later needs the same parent directory, stow "unfolds" it: it
replaces the directory symlink with a real directory containing individual
links. This is normal and safe, but it means the shape of the links can change
after adding a package. It also means that a new file added to a folded
directory in `$HOME` lands inside the repo. Run `just all` after adding
packages so the folding is recomputed consistently, and check `git status`.

### Conflicts

A conflict means the target path already exists as a real file or directory
that stow did not create, for example:

```
WARNING! stowing git would cause conflicts:
  * cannot stow ../git/.gitconfig over existing target .gitconfig since neither a link nor a directory and --adopt not specified
All operations aborted.
```

Stow refuses to overwrite it and aborts the whole operation — nothing is linked
until the conflict is resolved. Three ways out, in order of preference:

1. **Keep the repo version.** Back up the local file, delete it, then restow:

   ```bash
   mv ~/.gitconfig ~/.gitconfig.bak
   just all
   ```

2. **Keep the local version.** Use `--adopt`, which moves the existing file
   into the repo (overwriting the repo's copy) and then links it back:

   ```bash
   stow --adopt --verbose --target=$HOME --restow git
   git diff                       # inspect what --adopt pulled in
   git checkout -- git/.gitconfig # discard it, if the repo version was right
   ```

   `--adopt` is destructive to the repo, not to `$HOME`. Because `just all`
   runs with `--adopt`, **always check `git status` / `git diff` afterwards**:
   a stray local file silently becomes the tracked version.

3. **Merge by hand.** Copy the parts worth keeping from the local file into the
   repo version, then delete the local file and restow.

### Debugging a link

```bash
stow --no --verbose --target=$HOME --restow zsh   # dry run for one package
ls -l ~/.zshrc                                     # where does it point?
stow --verbose --target=$HOME --delete zsh         # unlink one package
```

Stale links pointing at files that no longer exist in the repo are cleared by
`--restow` (so by `just all`); a plain `stow` without `--restow` leaves them
behind.

Stow ignores some files by default, including `README.*`, `LICENSE.*`, and
`.gitignore`, so `tmux/README.md` is never linked into `$HOME`.

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
