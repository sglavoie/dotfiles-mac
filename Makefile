packages = atuin git kitty neovim tmux zsh

all:
	stow --verbose --target=$$HOME --restow ${packages}

delete:
	stow --verbose --target=$$HOME --delete ${packages}
