packages = atuin git iterm2 neovim starship tmux zsh

all:
	stow --verbose --target=$$HOME --restow ${packages}

delete:
	stow --verbose --target=$$HOME --delete ${packages}
