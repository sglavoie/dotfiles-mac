# Static equivalent of `brew shellenv` (saves a ~35 ms subprocess). It leaves
# out `export FPATH`: an exported fpath leaks into nested shells in a different
# order, which makes oh-my-zsh rebuild its completion dump on every switch
# between a fresh and a nested shell. .zshrc adds the site-functions dir.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
# GNU sed as plain `sed`, for scripts and tools that spawn it (git editors,
# xargs, Makefiles) too, not just interactive shells; BSD sed stays at
# /usr/bin/sed.
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
