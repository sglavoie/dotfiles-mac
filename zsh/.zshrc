# Keep PATH/fpath unique as entries are added by login files and tool hooks.
typeset -U path PATH fpath FPATH

path_prepend_all() {
  local -a dirs
  local dir

  for dir in "$@"; do
    [[ -d "$dir" ]] && dirs+=("$dir")
  done

  path=("${dirs[@]}" "${path[@]}")
}

export GOPATH="$HOME/.go"
export PNPM_HOME="$HOME/Library/pnpm"
export NVM_DIR="$HOME/.nvm"
export HOMEBREW_NO_AUTO_UPDATE=1

path_prepend_all \
  "$GOPATH/bin" \
  "$HOME/.local/bin" \
  /opt/homebrew/opt/ruby/bin \
  "$PNPM_HOME"

fpath=(/opt/homebrew/share/zsh/site-functions "${fpath[@]}")

# Read external environment variables
[[ -r "$HOME/Documents/21_programming/zsh/environ.variables" ]] && source "$HOME/Documents/21_programming/zsh/environ.variables"

unfunction path_prepend_all

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
setopt HIST_VERIFY

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Set default editor to use
export EDITOR='nvim'
export VISUAL='nvim'

# https://dandavison.github.io/delta/
(( $+commands[delta] )) && export PAGER=delta

# Get colorized output for `man` pages with `bat`
(( $+commands[bat] )) && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# --files: List files that would be searched but do not search
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'

# Always search case-insensitively
export LESS="-i"

# Colours for eza, completion lists and BSD ls (bold cyan directories)
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

################################################################################
# Shell behaviour formerly provided by oh-my-zsh
################################################################################

setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_MINUS
setopt INTERACTIVE_COMMENTS LONG_LIST_JOBS MULTIOS
setopt AUTO_MENU COMPLETE_IN_WORD ALWAYS_TO_END
unsetopt MENU_COMPLETE FLOW_CONTROL
# Word motions and ^W stop at any punctuation (/, -, ., …)
WORDCHARS=''

# Emacs keymap, explicitly: with EDITOR=nvim zsh would default to vi mode.
bindkey -e

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search \
  edit-command-line bracketed-paste-magic url-quote-magic
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
# Quote URLs as they are typed or pasted
zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic

() {
  # Both normal (^[[) and application (^[O) cursor-key sequences
  local -A keys=(
    '^[[A' up-line-or-beginning-search '^[OA' up-line-or-beginning-search
    '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search
    '^[[H' beginning-of-line '^[OH' beginning-of-line '^[[1~' beginning-of-line
    '^[[F' end-of-line '^[OF' end-of-line '^[[4~' end-of-line
    '^[[Z' reverse-menu-complete
    '^[[3~' delete-char
    '^[[3;5~' kill-word
    '^[[1;5C' forward-word
    '^[[1;5D' backward-word
    '^[w' kill-region
    '^[m' copy-prev-shell-word
    ' ' magic-space
    '^x^e' edit-command-line
    '^x^x' edit-command-line
  )
  local k
  for k in ${(k)keys}; do
    bindkey "$k" "$keys[$k]"
  done
}

alias history='fc -l 1'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias diff='diff --color'
alias -- -='cd -'
alias -g ...='../..'
alias -g ....='../../..'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lsa='ls -lah'

# Completion
zmodload -i zsh/complist
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:*:users' ignored-patterns '_*'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/compcache"
zstyle '*' single-ignored show

# -C skips scanning fpath for new completion functions. Do the full scan only
# when the dump is missing or a completion dir changed since it was written
# (installing a tool adds a file to site-functions and bumps its mtime).
# -u skips compaudit's ownership check of the completion dirs.
autoload -Uz compinit
() {
  local dump="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION" dir

  for dir in $fpath; do
    if [[ ! -s $dump || $dir -nt $dump ]]; then
      mkdir -p "${dump:h}"
      compinit -u -d "$dump"
      { zcompile "$dump" } &!
      return
    fi
  done
  compinit -u -C -d "$dump"
}

################################################################################
# Functions and key bindings
################################################################################

# Use lf to switch directories and bind it to ctrl-o
lfcd() {
  local tmp dir

  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [[ -f "$tmp" ]]; then
    dir="$(<"$tmp")"
    rm -f "$tmp"
    [[ -d "$dir" && "$dir" != "$PWD" ]] && cd "$dir"
  fi
}
bindkey -s '^o' 'lfcd\n'

# cd to directory
cdd() {
  local dir

  if (( $+commands[fd] )); then
    dir=$(fd --type d | fzf +m)
  else
    dir=$(find . -mindepth 1 -type d -not -path '*/.git/*' | fzf +m)
  fi
  [[ -n "$dir" ]] && cd "$dir"
}

# Count fsync/F_FULLFSYNC calls per process (default 10s)
fsyncers() {
  sudo fs_usage -w -t "${1:-10}" -f filesys \
    | grep -iE 'fsync|fullfsync' \
    | awk '{print $NF}' | sed 's/\.[0-9]*$//' \
    | sort | uniq -c | sort -rn | head -"${2:-10}"
}

# Schedule shutdown cleanly (`shutdown -h` is abrupt)
shutdown_in() {
  local mins=${1:-60}
  if [[ ! $mins =~ ^[0-9]+$ ]]; then
    echo "usage: shutdown_in [minutes]" >&2
    return 1
  fi
  ( sleep $(( mins * 60 )) && osascript -e 'tell app "System Events" to shut down' ) &>/dev/null &!
  echo "Shutdown scheduled at $(date -v+${mins}M '+%H:%M') (PID $!)"
}

# Read aliases
[[ -r "$HOME/.config/zsh/aliases" ]] && source "$HOME/.config/zsh/aliases"

# Treat the alias as the real command
compdef g=git

# Prompt (native zsh; formerly oh-my-posh)
source "$HOME/.config/zsh/prompt.zsh"

# Source a command's init script from a cache, regenerated when the command
# moves (e.g. a brew upgrade) or is modified.
cached_eval() {
  local cmd=${${commands[$1]:-$1}:A} cache="$HOME/.cache/zsh/${1:t}.zsh" key

  [[ -x "$cmd" ]] || return
  [[ -r "$cache" ]] && read -r key < "$cache"
  if [[ "$key" != "# $cmd" || "$cmd" -nt "$cache" ]]; then
    mkdir -p "${cache:h}"
    { print -r -- "# $cmd"; "$@" } >| "$cache"
  fi
  source "$cache"
}

# fzf key bindings and completion; fzf-tab must come after so it owns Tab.
# fzf-tab is a plain clone (see ~/scripts/system-check/REBUILD.md).
cached_eval fzf --zsh
[[ -r "$HOME/.local/share/zsh/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$HOME/.local/share/zsh/fzf-tab/fzf-tab.plugin.zsh"

# A smarter cd command - https://github.com/ajeetdsouza/zoxide
cached_eval zoxide init zsh

cached_eval atuin init zsh --disable-up-arrow

cached_eval ~/1_dev_projects/sglavoie_raspberry_pi/scripts/pi.py completion zsh

unfunction cached_eval

# Add custom aliases conditionally
(( $+commands[eza] )) && alias ls=eza

__load_nvm() {
  unfunction nvm 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}

nvm() {
  __load_nvm
  nvm "$@"
}

# TOTP code from an otpauth:// URI or a bare base32 secret.
# Requires oath-toolkit (brew install oath-toolkit).
totp() {
	local uri="$1" secret
	case "$uri" in
	otpauth://*) secret=$(printf '%s' "$uri" | sed -n 's/.*[?&]secret=\([^&]*\).*/\1/p') ;;
	*) secret="$uri" ;;
	esac
	[ -n "$secret" ] || {
		echo "usage: totp <otpauth://... | BASE32SECRET>" >&2
		return 1
	}
	oathtool --totp -b "$secret"
}
