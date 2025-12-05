packages = atuin git iterm2 local_bin neovim oh-my-posh tmux zsh

all:
	stow --adopt --verbose --target=$$HOME --restow ${packages}

delete:
	stow --verbose --target=$$HOME --delete ${packages}
