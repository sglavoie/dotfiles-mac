# Dotfiles - macOS

Full rebuild of a Mac: see `~/scripts/system-check/REBUILD.md`.

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

Each top-level directory in this repo (`git`, `zsh`, `kitty`, …) is a **stow
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
| `--no-folding` | Link files one by one, never whole directories (see below). `just all` always uses it. |
| `--adopt` | Resolve conflicts by *moving the existing file into the repo* (see below). Only `just adopt` uses it. |

### Tree folding

By default, if a directory does not exist in `$HOME` yet, stow symlinks the
whole directory rather than each file inside it (`~/.config/kitty` becomes one
link into the repo). Every file a program later writes there then lands in the
repo: that is how agentmux's `~/.config/kitty/agent-mux.conf` link got
committed, and why the live `karabiner.json` was the tracked file itself.

`just all` therefore stows with `--no-folding`: directories in `$HOME` are always
real, and only the tracked files inside them are links. A Mac stowed by an older,
folding setup is repaired once with `just unfold` (dry run) and then
`just unfold --apply`, which moves anything untracked out of the repo before
swapping each directory link for a real directory. `just all` skips a package
that still has a folded link, with a warning, since restowing one would hide
its contents.

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

2. **Keep the local version.** `just adopt` moves each conflicting file into
   the repo (overwriting the repo's copy) and links it back:

   ```bash
   just adopt
   git diff                       # inspect what --adopt pulled in
   git checkout -- git/.gitconfig # discard it, if the repo version was right
   ```

   `--adopt` is destructive to the repo, not to `$HOME`, so it is never part of
   `just all`; check `git status` / `git diff` after `just adopt`.

3. **Merge by hand.** Copy the parts worth keeping from the local file into the
   repo version, then delete the local file and restow.

### Debugging a link

```bash
stow --no --no-folding --verbose --target=$HOME --restow zsh   # dry run for one package
ls -l ~/.zshrc                                     # where does it point?
stow --verbose --target=$HOME --delete zsh         # unlink one package
```

Stale links pointing at files that no longer exist in the repo are cleared by
`--restow` (so by `just all`); a plain `stow` without `--restow` leaves them
behind.

Stow ignores some files by default, including `README.*`, `LICENSE.*`, and
`.gitignore`, so a package can carry its own `README.md` without it being
linked into `$HOME`.

### Apple Photos backup configuration

The `osxphotos-backup` package holds
`~/.config/osxphotos-backup/photos-backup.toml`, read by the `photos-backup`
CLI from `dev-helpers/python/photos_backup`. Stow it alone with:

```bash
stow --no --no-folding --verbose --target=$HOME osxphotos-backup   # simulate
stow --no-folding --verbose --target=$HOME osxphotos-backup        # link
```

`~/.config/osxphotos-backup/photos-backup.toml` is a symlink into this repository, so editing the
file here changes the live configuration; commit and `git pull` on the other Mac
to carry it over, without restowing. `apple_photos.volume` and
`apple_photos.archive` are shared by every Mac using the drive;
`apple_photos.library`, `[sd_card]`, and `[ssd]` are the per-Mac lines, and a Mac
lacking one of those simply omits the section.

On a Mac that already keeps a real `~/.config/osxphotos-backup/photos-backup.toml`,
stowing stops with a conflict: move the file aside to use the repository copy,
or run `just adopt` to make that file the repository copy.

### Backup codes

`backup_codes/` holds recovery codes encrypted with age; `just codes-show` and
`just codes-edit` read and change them. See `backup_codes/README.md`.

## External dependencies

Some configuration lives outside this repo:

- **`~/scripts`** — custom scripts, launch agents (`com.sglavoie.*` plists), and `~/.local/bin/` symlinks
- **`~/Documents/21_programming/git/gitconfig-sglavoie`** — private git identity (included by `.gitconfig`)
- **`~/Documents/21_programming/zsh/environ.variables`** — private shell variables (sourced by `.zshrc`)
- **`~/Documents/21_programming/fonts/`** — curated paid fonts, installed by `just fonts`
- **SSH config and keys (`~/.ssh/`)** — not tracked anywhere; restored from the backup
