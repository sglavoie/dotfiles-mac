# Dotfiles - macOS

## Usage

```bash
brew install stow
git clone git@github.com:sglavoie/dotfiles-mac.git ~/dotfiles
cd ~/dotfiles
./setup.sh  # first usage only: use `make` for updates
```

## Update/recreate dotfiles

```bash
make
```

## Remove all dotfiles symlinks

```bash
make delete
```
