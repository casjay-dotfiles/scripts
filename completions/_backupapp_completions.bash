#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  backupapp --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Thursday, Jul 21, 2022 10:59 EDT
# @@File             :  backupapp
# @@Description      :  Backup files and folders
# @@Changelog        :
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
_backupapp_completion() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CONFDIR="$HOME/.config/myscripts/backupapp"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/backupapp}"
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local CONFFILE="settings.conf"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  #local SEARCHCMD="$(___findcmd "$SEARCHDIR/" "d" "1" | sort -u)"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local LONGOPTS="--completions --debug --raw --options --config --version --help --silent --dir --term --cron --once --console "
  local SHORTOPTS=""
  local ARRAY="cron create"

  _init_completion || return

  if [ "$SHOW_COMP_OPTS" != "" ]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
  elif [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS:---}' -- ${cur})) && compopt -o nospace
  else
    case "${COMP_WORDS[1]:-$prev}" in
    --debug | --raw | --help | --version | --config | --options)
      COMPREPLY=($(compgen -W '${ARRAY} ${LONGOPTS} ${SHORTOPTS}' -- ${cur}))
      return 0
      ;;
    cron)
      prev="cron"
      COMPREPLY=($(compgen -W 'all list add del' -- "$cur"))
      ;;
    new | run | create)
      prev="new"
      [[ "$cword" -gt 2 ]] && _filedir ||
        COMPREPLY=($(compgen -c -- "$cur"))
      ;;
    *)
      COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      return 0
      ;;
    esac
  fi
  #
  # if [[ -n "$FILEDIR" ]]; then _filedir; fi
  # if [[ $cword -gt 2 ]]; then
  #   return
  # elif [[ $cword == 2 ]]; then
  #   _filedir
  #   compopt -o nospace
  #   return
  # elif [[ $cword -eq 1 ]]; then
  #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
  #   compopt -o nospace
  #   return
  # if [[ "$ARRAY" = "show__none" ]]; then
  #   COMPREPLY=($(compgen -W '' -- "${cur}"))
  # elif [[ "$ARRAY" = "show__filedir" ]]; then
  #   _filedir
  # elif [[ "$ARRAY" = "show__commands" ]]; then
  #   COMPREPLY=($(compgen -c -- "${cur}"))
  # elif [ "$ARRAY" != "" ]; then
  #   COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
  # elif [ -n "$OPTS" ]; then
  #   COMPREPLY=($(compgen -W '${OPTS}' -- "${cur}"))
  # else
  #   COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
  # elif [[ $cword -gt 2 ]]; then
  #   return
  # elif [[ $cword == 2 ]]; then
  #   _filedir
  #   compopt -o nospace
  #   return
  # elif [[ $cword -eq 1 ]]; then
  #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
  #   compopt -o nospace
  #   return
  # fi
  # [[ ${cword} == 2 ]] && _filedir && compopt -o nospace
  # [[ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
  # [[ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
  # [[ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  # prev=""
  # compopt -o nospace
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _backupapp_completion -o default backupapp
