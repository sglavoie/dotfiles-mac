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
export SDKMAN_DIR="$HOME/.sdkman"
export NVM_DIR="$HOME/.nvm"
export HOMEBREW_NO_AUTO_UPDATE=1

path_prepend_all \
  "$GOPATH/bin" \
  "$HOME/.local/bin" \
  /opt/homebrew/opt/ruby/bin \
  "$HOME/.google-cloud-sdk/bin" \
  "$HOME/.sdkman/candidates/java/current/bin" \
  "$PNPM_HOME"

[[ -d "$HOME/.zfunc" ]] && fpath=("$HOME/.zfunc" "${fpath[@]}")

# Read external environment variables
[[ -r "$HOME/Documents/21_programming/zsh/environ.variables" ]] && source "$HOME/Documents/21_programming/zsh/environ.variables"

unfunction path_prepend_all

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ssh-agent fzf fzf-tab gitignore)

# Load multiple SSH keys
zstyle :omz:plugins:ssh-agent quiet yes identities id_ed25519

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

# Read aliases
[[ -r "$HOME/.config/zsh/aliases" ]] && source "$HOME/.config/zsh/aliases"

bindkey '^x^x' edit-command-line  # Open default editor

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source "$ZSH/oh-my-zsh.sh"

# Treat the alias as the real command
compdef g=git

# A smarter cd command - https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# https://ohmyposh.dev/
eval "$(oh-my-posh init zsh --config ~/.oh-my-posh.json)"

eval "$(atuin init zsh --disable-up-arrow)"

# Add custom aliases conditionally
(( $+commands[eza] )) && alias ls=eza

_gcloud_lazy_completion() {
  unfunction _gcloud_lazy_completion
  [[ -r "$HOME/.google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/.google-cloud-sdk/completion.zsh.inc"

  if (( $+functions[_bash_complete] && $+functions[_python_argcomplete] )); then
    _bash_complete -o nospace -o default -F _python_argcomplete "$@"
  fi
}
compdef _gcloud_lazy_completion gcloud

__load_nvm() {
  unfunction nvm 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}

nvm() {
  __load_nvm
  nvm "$@"
}

sdk() {
  unfunction sdk 2>/dev/null
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  sdk "$@"
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
