# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/bashrc.pre.bash"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export GPG_TTY=$(tty)

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/bashrc.post.bash"
