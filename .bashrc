[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export GPG_TTY=$(tty)
. "$HOME/.cargo/env"


for bcfile in ~/.bash_completion.d/* ; do
  . $bcfile
done