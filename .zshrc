# NOTE: Some commands need to be adjusted (coming from Linux dotfiles)

zstyle :omz:plugins:ssh-agent agent-forwarding on

# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/dev/git-scripts:$HOME/.local/bin:$HOME/.node/bin:$HOME/.cargo/bin:$HOME/.gem/ruby/2.7.0/bin:$PATH"

# Set default editor to use
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER="nvim +Man!"

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc.
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'

# This fixes a possible issue where Git doesn't look for the right signing key when committing
export GPG_TTY=$(tty)

# History in cache directory:
HISTSIZE=50000
SAVEHIST=50000

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

bindkey '^x^x' edit-command-line  # Open default editor

##### Functions

# FIXME: invalid arguments for `find` command on Mac
# Select a file from current folder and recursively with fzf and open it with Neovim, ignoring hidden files
se() { find -not -path '*/\.*' -type f | cut -f 1 | fzf | xargs -r nvim ;}

# [University specific] Select a file recursively with fzf and open it with default app in the background
sc() { find ~/Dropbox/university ~/dev/sglavoie/world-class | cut -f 1 | fzf | (xargs -r open &) ;}

renamemp3() {
for f in *.mp3; do
    mv "$f" `echo $f | tr -cd "a-zA-Z0-9\-_\ \." \
        | sed s/' - '/'-'/g | sed s/' '/_/g \
        | sed s/__/_/g | sed s/'('//g | sed s/')'//g`
done
}

# Source: https://www.stefaanlippens.net/pretty-csv.html
function pretty_csv {
    column -t -s, -n "$@" | less -F -S -X -K
}

# Load aliases if existent.
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ssh-agent fzf gitignore)

source $ZSH/oh-my-zsh.sh

# dotfiles manager
alias dot="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

# enable autocompletion on dotfiles manager and aliases
compdef dot='git'
compdef g='git'
setopt complete_aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Activate correct virtual environment from inside Neovim when
# the VIRTUAL_ENV var is set
# From https://vi.stackexchange.com/a/7654
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sglavoie/Programming/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sglavoie/Programming/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sglavoie/Programming/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sglavoie/Programming/google-cloud-sdk/completion.zsh.inc'; fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

