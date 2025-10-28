# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ssh-agent fzf fzf-tab gitignore rye zsh-z)

# Load multiple SSH keys
zstyle :omz:plugins:ssh-agent quiet yes identities id_ed25519 id_rsa

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=1000000
HISTSIZE=1000000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

export GOPATH=$HOME/.go
export PATH="/opt/homebrew/bin:$GOPATH/bin:$HOME/.local/bin:$HOME/development/flutter/bin:$HOME/.node/bin:$HOME/.cargo/bin:/opt/homebrew/opt/ruby/bin:$HOME/.local/share/gem/ruby/3.4.0/bin:$HOME/.rye/env:$HOME/Programming/google-cloud-sdk/bin:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Set default editor to use
export EDITOR='vim'
export VISUAL='vim'

export PAGER=delta

# Get colorized output for `man` pages with `bat`
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc.
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'

# Always search case-insensitively
export LESS="-i"

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
	tmp="$(mktemp)"
	lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
	fi
}
bindkey -s '^o' 'lfcd\n'

# cd to directory
cdd() {
local dir
dir=$(fd --type d | fzf +m) &&
cd "$dir"
}

# Read external environment variables
[ -f "$HOME/Documents/2_areas/programming/zsh/environ.variables" ] && source "$HOME/Documents/2_areas/programming/zsh/environ.variables"

# Read aliases
[ -f "$HOME/Documents/2_areas/programming/zsh/aliases" ] && source "$HOME/Documents/2_areas/programming/zsh/aliases"

bindkey '^x^x' edit-command-line  # Open default editor

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Treat the alias as the real command
compdef g=git

# A smarter cd command - https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/sglavoie/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# https://ohmyposh.dev/
eval "$(oh-my-posh init zsh --config ~/.oh-my-posh.json)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/sglavoie/.miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/sglavoie/.miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/sglavoie/.miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/sglavoie/.miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/sglavoie/.miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/sglavoie/.miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# The next line updates PATH for the Google Cloud SDK
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

# Add custom aliases conditionally
type eza >/dev/null 2>&1 && alias ls=eza

# https://rye-up.com/guide/installation/#add-shims-to-path
source "$HOME/.rye/env"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh --disable-up-arrow)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/sglavoie/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [[ -d "$HOME/.bash_completion.d" ]]; then
    for bcfile in ~/.bash_completion.d/* ; do
      source $bcfile
    done
fi

alias claude="/Users/sglavoie/.claude/local/claude"
