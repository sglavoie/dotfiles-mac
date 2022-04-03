# NOTE: Some aliases haven't been tried yet on Mac and some are known
# to be temporarily broken.

# Shortcuts
alias alert="afplay /System/Library/PrivateFrameworks/ScreenReader.framework/Versions/A/Resources/Sounds/KBVONotSynched.aiff"
alias allextensions="find . -type f -name '*.*' | sed 's|.*\.||' | sort -u"
alias articlesbycategories="pushd > /dev/null; \
    cd ~/dev/sglavoie/sglavoie.github.io-source/content; \
    find . -type f -name '*.md' ! -wholename '*/pages*' | cut -d/ -f2 \
    | sort | uniq -c | sort -n; popd > /dev/null"
alias articlesnum="pushd > /dev/null; \
    cd ~/dev/sglavoie/sglavoie.github.io-source/content; \
    find . -name '*.md' | cut -d '/' -f3 | grep -E '^\d.*' \
    | sort | tail -1; popd > /dev/null"
alias asg='. ~/Programming/virtualenvs/sg/bin/activate && cd ~/dev/sglavoie/sglavoie.github.io-source'
alias b='python3 ~/dev/sglavoie/dev-helpers/rsync_backup/rsync_backup.py'
alias c='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias cat="bat"
alias cl='clear'
alias cleanZip='_cleanZip(){ zip -d $1 "__MACOSX/*" && zip -d $1 "*/.DS_Store" }; _cleanZip'
alias ctags='`brew --prefix`/bin/ctags'
alias diff='diff-so-fancy'
alias dockerclean='docker stop $(docker ps -qa); docker system prune -a --volumes'
alias f='fg'
alias g='git'
alias gal='git addlearning'
alias gitaliases='git config -l | grep alias | sed "s/^alias\.//g" | sed "s/=/Ω/" | column -t -s "Ω"'
alias h='history'
alias ipe='echo $(curl -s ipinfo.io/ip)' # print external IP address
alias j='jobs -l'
alias n='nvim'
alias o='xdg-open'
alias p='python3'
alias q='exit'
alias re='tput reset'
alias reboot='sudo reboot'
alias sgl='cd ~/dev/sglavoie/sglavoie.github.io-source && . ~/Programming/virtualenvs/sg/bin/activate && n content/pages/learning-progress.md'
alias shutdown='sudo shutdown'
alias sysupdate='sudo apt update && sudo apt dist-upgrade -y && sudo snap refresh && sudo apt autoremove -y && sudo apt clean'
alias t='tmux'
alias www='python3 -m http.server'

# x86_64 support
alias ibrew="arch -x86_64 /usr/local/bin/brew"
alias python3.7='/usr/local/opt/python@3.7/bin/python3.7'

# confirmation
alias ln='ln -i'

# Programs
alias cast='ffmpeg -y -f x11grab -s 1366x768 -i :0.0 -f \
    alsa -i default -c:v libx264 -r 30 -c:a flac output.mkv'
alias convertcast='ffmpeg -i output.mkv -strict -2 -c copy output.mp4'
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

# Code challenges paths
alias cdchallenges='cd ~/dev/sglavoie/programming-challenges'

# Python related
alias ap='source .venv/bin/activate'
alias avenv='source venv/bin/activate'
alias cleanhistory='python \
    ~/dev/sglavoie/dev-helpers/zsh_history_cleaner/zsh_history_cleaner.py'
alias cpsglavoie='cp -rf \
    ~/dev/sglavoie/sglavoie.github.io-source/output/* \
    ~/dev/sglavoie/sglavoie.github.io/ && \
    cd ~/dev/sglavoie/sglavoie.github.io && git add .'
alias da='deactivate'
alias jl='jupyter-lab &'
alias learning-logs='~/dev/sglavoie/dev-helpers/learning-logs-to-markdown/.venv/bin/python3 ~/dev/sglavoie/dev-helpers/learning-logs-to-markdown/get_learning_logs.py'
alias pipupgrade="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias pipupdateall="pip install -U \$(pip freeze | awk '{split(\$0, a, \"==\"); print a[1]}')"
alias pylint='/usr/bin/env python =pylint'
alias pythonlines='find . -name \*.py | xargs wc -l'
alias pyclean='find . -name "*.py[co]" -or -name "__pycache__" -exec rm -rf -- {} +'

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
