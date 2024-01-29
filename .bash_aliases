# NOTE: Some aliases haven't been tried yet on Mac and some are known
# to be temporarily broken.

# Shortcuts
alias alert="afplay /System/Library/PrivateFrameworks/ScreenReader.framework/Versions/A/Resources/Sounds/KBVONotSynched.aiff"
alias allextensions="find . -type f -name '*.*' | sed 's|.*\.||' | sort -u"
alias articlesbycategories="pushd > /dev/null; \
    cd ~/dev/sglavoie/sglavoie.github.io/main/content; \
    find . -type f -name '*.md' ! -wholename '*/pages*' | cut -d/ -f2 \
    | sort | uniq -c | sort -n; popd > /dev/null"
alias articlesnum="pushd > /dev/null; \
    cd ~/dev/sglavoie/sglavoie.github.io/main/content; \
    find . -name '*.md' | cut -d '/' -f3 | grep -E '^\d\d\d\d.*' \
    | sort | tail -1; popd > /dev/null"
alias c='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cat="bat"
alias cleanZip='_cleanZip(){ zip -d $1 "__MACOSX/*" && zip -d $1 "*/.DS_Store" }; _cleanZip'
alias ctags='`brew --prefix`/bin/ctags'
alias diff='diff-so-fancy'
alias dockerclean='docker stop $(docker ps -qa); docker system prune -a --volumes'
alias g='git'
alias gitaliases='git config -l | grep alias | sed "s/^alias\.//g" | sed "s/=/Ω/" | column -t -s "Ω"'
alias h='history'
alias ipe='echo $(curl -s ipinfo.io/ip)' # print external IP address
alias j='jobs -l'
alias lg='lazygit'
alias n='nvim'
alias p='python3.11'
alias q='exit'
alias re='tput reset'
alias www='python3 -m http.server'

# x86_64 support
alias ibrew="arch -x86_64 /usr/local/bin/brew"
alias python3.7='/usr/local/opt/python@3.7/bin/python3.7'

# Programs
alias v='vim'

# General paths
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias cheat='cd ~/Dropbox/Programming/cheatsheets'

# Colorize the grep command output for ease of use (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Python related
alias ap='source .venv/bin/activate'
alias avenv='source venv/bin/activate'
alias cleanhistory='python \
    ~/dev/sglavoie/dev-helpers/zsh_history_cleaner/zsh_history_cleaner.py'
alias da='deactivate'
alias pipupgrade="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias pipupdateall="pip install -U \$(pip freeze | awk '{split(\$0, a, \"==\"); print a[1]}')"
alias pylint='/usr/bin/env python =pylint'
alias pythonlines='find . -name \*.py | xargs wc -l'
alias pyclean='find . -name "*.py[co]" -or -name "__pycache__" -exec rm -rf -- {} +'

# macOS related
alias rmmac_garbage='find . -type f -name ".DS_Store" -delete && find . -type d -name "__MACOSX" -delete'

# Ignore specific files/directories in Dropbox
dropbox-ignore(){
arg1=$1
arg2=$2
  find . -type $arg1 -name "$arg2" |
    xargs -I {} attr -s com.dropbox.ignored -V 1 "{}"
}

# Sync specific files/directories in Dropbox
# that were previously ignored (or not)
dropbox-sync(){
arg1=$1
arg2=$2
  find . -type $arg1 -name "$arg2" |
    xargs -I {} attr -s com.dropbox.ignored -V 0 "{}"
}
