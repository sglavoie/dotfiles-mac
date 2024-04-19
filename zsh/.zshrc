# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(direnv git ssh-agent fzf gitignore rye)

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
export PATH="$GOPATH/bin:$HOME/.local/bin:$HOME/.node/bin:$HOME/.cargo/bin:$HOME/.gem/ruby/2.7.0/bin:$HOME/.rye/env:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Set default editor to use
export EDITOR='nvim'
export VISUAL='nvim'

# Get colorized output for `man` pages with `bat`
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc.
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'

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

# Read external environment variables
source ~/Dropbox/.custom/zsh/environ.variables
[ -f "$HOME/Dropbox/.custom/zsh/environ.variables" ] && source "$HOME/Dropbox/.custom/zsh/environ.variables"

# Read aliases
[ -f "$HOME/Dropbox/.custom/zsh/aliases" ] && source "$HOME/Dropbox/.custom/zsh/aliases"

bindkey '^x^x' edit-command-line  # Open default editor

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/oh-my-zsh.sh

# Activate correct virtual environment from inside Neovim when
# the VIRTUAL_ENV var is set
# From https://vi.stackexchange.com/a/7654
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
fi

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

# Add custom aliases conditionally
type eza >/dev/null 2>&1 && alias ls=eza

for bcfile in ~/.bash_completion.d/* ; do
  . $bcfile
done

# Treat the alias as the real command
compdef g=git
compdef t=tmux

# A smarter cd command - https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# https://rye-up.com/guide/installation/#add-shims-to-path
source "$HOME/.rye/env"
