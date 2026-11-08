# Native port of the former oh-my-posh theme, without the binary:
#
#    folder  <host icon>branch ≡*~1 |  +1  2  1.2s
#   ❯
#
# The folder sits on blue; git status is grey (one `git status` per prompt);
# the last command's run time shows from 500 ms; ❯ turns red after a failure.
# Once a line is accepted its prompt collapses to a bare ❯ (transient prompt).

zmodload zsh/datetime # EPOCHREALTIME
autoload -Uz add-zsh-hook add-zle-hook-widget

# A venv's activate script must not prefix PS1; this prompt is rebuilt anyway.
export VIRTUAL_ENV_DISABLE_PROMPT=1

typeset -g _prompt_start= _prompt_char=
typeset -gA _prompt_host_icon # remote URL lookups, cached per directory

_prompt_preexec() { _prompt_start=$EPOCHREALTIME }

# "Austin" style: 742ms, 2.5s, 1m 15s, 1h 2m 5s.
_prompt_duration() {
  local -i ms=$1 s=$(( $1 / 1000 ))
  if (( ms < 1000 )); then
    REPLY="${ms}ms"
  elif (( s >= 3600 )); then
    REPLY="$(( s / 3600 ))h $(( s % 3600 / 60 ))m $(( s % 60 ))s"
  elif (( s >= 60 )); then
    REPLY="$(( s / 60 ))m $(( s % 60 ))s"
  else
    printf -v REPLY '%.1fs' $(( ms / 1000.0 ))
  fi
}

# "?1 +2 ~3 -4 x5", zero counts left out.
_prompt_counts() {
  local -a parts
  local -i i
  local -a sym=('?' '+' '~' '-' 'x')
  for (( i = 1; i <= 5; i++ )); do
    (( ${@[i]} )) && parts+=("${sym[i]}${@[i]}")
  done
  REPLY=${(j: :)parts}
}

_prompt_git() {
  REPLY=
  local out line xy oid head upstream remote url icon branch_status wstr sstr
  local -i ahead behind stash
  # w/s: working tree/staging; untracked added modified deleted unmerged
  local -i wu wa wm wd wx sa sm sd
  out=$(git --no-optional-locks status --porcelain=v2 --branch --show-stash 2>/dev/null) || return

  for line in ${(f)out}; do
    case $line in
      ('# branch.oid '*) oid=${line#\# branch.oid } ;;
      ('# branch.head '*) head=${line#\# branch.head } ;;
      ('# branch.upstream '*) upstream=${line#\# branch.upstream } ;;
      ('# branch.ab '*)
        line=${line#\# branch.ab }
        ahead=${${line%% *}#+}
        behind=${${line##* }#-}
        ;;
      ('# stash '*) stash=${line#\# stash } ;;
      ('? '*) (( ++wu )) ;;
      ('u '*) (( ++wx )) ;;
      ([12]' '*)
        xy=${line[3,4]}
        case $xy[1] in
          (A) (( ++sa )) ;;
          (M|T|R|C) (( ++sm )) ;; # a staged rename counts as modified
          (D) (( ++sd )) ;;
        esac
        case $xy[2] in
          (A) (( ++wa )) ;;
          (M|T) (( ++wm )) ;;
          (D) (( ++wd )) ;;
        esac
        ;;
    esac
  done

  # Host icon of the upstream's remote (origin without one); none for GitHub.
  remote=${upstream%%/*}
  remote=${remote:-origin}
  if (( ! ${+_prompt_host_icon[$PWD:$remote]} )); then
    url=$(git config --get "remote.$remote.url" 2>/dev/null)
    case $url in
      (*github.com*) icon= ;;
      (*gitlab.com*) icon=$'' ;;
      (*bitbucket.org*) icon=$'' ;;
      (*codeberg.org*) icon=$'' ;;
      (*) icon=$' ' ;;
    esac
    _prompt_host_icon[$PWD:$remote]=$icon
  fi
  icon=$_prompt_host_icon[$PWD:$remote]

  if [[ $head == '(detached)' ]]; then
    head="detached at "$''"${oid[1,7]}"
  fi

  if [[ -z $upstream ]]; then
    branch_status=$'≢'
  elif (( ahead == 0 && behind == 0 )); then
    branch_status=$'≡'
  else
    local -a ab
    (( ahead )) && ab+=("%F{#88C0D0}"$'⇡'" %F{#6C6C6C}$ahead")
    (( behind )) && ab+=("%F{#88C0D0}"$'⇣'" %F{#6C6C6C}$behind")
    branch_status=${(j: :)ab}
  fi

  _prompt_counts $wu $wa $wm $wd $wx; wstr=$REPLY
  _prompt_counts 0 $sa $sm $sd 0; sstr=$REPLY

  REPLY="$icon${head//\%/%%} $branch_status"
  [[ -n $wstr ]] && REPLY+="%F{#FFAFD7}*%F{#6C6C6C}$wstr"
  [[ -n $wstr && -n $sstr ]] && REPLY+=" |"
  [[ -n $sstr ]] && REPLY+=" "$''" $sstr"
  (( stash )) && REPLY+=" "$''" $stash"
  REPLY+=" "
}

_prompt_precmd() {
  local -i st=$? ms
  local git dur

  if [[ -n $_prompt_start ]]; then
    ms=$(( (EPOCHREALTIME - _prompt_start) * 1000 ))
    _prompt_start=
    if (( ms >= 500 )); then
      _prompt_duration $ms
      dur=$REPLY
    fi
  fi
  _prompt_git
  git=$REPLY

  if (( st )); then
    _prompt_char='%F{#BF616A}❯%f'
  else
    _prompt_char='%F{#B48EAD}❯%f'
  fi

  PROMPT='%K{#61AFEF}%F{#FFFFFF} %1~ %f%k'
  [[ -n $git ]] && PROMPT+="%F{#6C6C6C}$git%f"
  [[ -n $dur ]] && PROMPT+="%F{#A3BE8C} $dur %f"
  PROMPT+=$'\n'"$_prompt_char "

  print -Pn -- '\e]0; %~\a' # window title
}

_prompt_transient() {
  [[ $CONTEXT == start ]] || return 0
  PROMPT="$_prompt_char "
  zle .reset-prompt
}

add-zsh-hook preexec _prompt_preexec
# First, so it reads the exit status before any other hook runs.
precmd_functions=(_prompt_precmd ${precmd_functions:#_prompt_precmd})
zle -N _prompt_transient
add-zle-hook-widget line-finish _prompt_transient
