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
plugins=(git ssh-agent fzf gitignore)

# Load multiple SSH keys
zstyle :omz:plugins:ssh-agent quiet yes identities id_ed25519 id_rsa

# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/go/bin:$HOME/dev/git-scripts:$HOME/.local/bin:$HOME/.node/bin:$HOME/.cargo/bin:$HOME/.gem/ruby/2.7.0/bin:$PATH"

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

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000

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

aptsources-cleanup () {
    sudo ~/.local/bin/aptsources-cleanup
}

# Read external environment variables
source ~/Dropbox/.custom/zsh/environ.variables

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
# source "${VIRTUAL_ENV}/bin/activate"  # commented out by conda initialize
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/sglavoie/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/sglavoie/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/sglavoie/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/sglavoie/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sglavoie/Programming/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sglavoie/Programming/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sglavoie/Programming/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sglavoie/Programming/google-cloud-sdk/completion.zsh.inc'; fi

# Add custom aliases conditionally
type exa >/dev/null 2>&1 && alias ls=exa

# bun completions
[ -s "/opt/homebrew/Cellar/bun/1.0.1/share/zsh/site-functions/_bun" ] && source "/opt/homebrew/Cellar/bun/1.0.1/share/zsh/site-functions/_bun"


nvm use node 1> /dev/null
# Load aliases if existent.
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

