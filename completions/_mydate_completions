#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  mydate --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Aug 12, 2021 19:03 EDT
# @File              :  mydate
# @Description       :  Show date
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_mydate() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/mydate"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/mydate}"
  #local SEARCHCMD="$(___findcmd "$SEARCHDIR/" "d" "1" | sort -u)"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local OPTS=""
  local LONGOPTS="--completions --debug --raw --options --config --version --help --silent --dir"
  local SHORTOPTS=""
  local ARRAY="nowtime nowdate setver setverfile custom update"

  _init_completion || return

  if [[ "$SHOW_COMP_OPTS" != "" ]]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    return
  elif [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS}' -- ${cur}))
    return
  else
    case "${COMP_WORDS[1]:-$prev}" in
    --options)
      local prev="--options"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --config)
      local prev="--config"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --help)
      prev="--help"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --version)
      local prev="--version"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --dir)
      local prev="dir"
      _filedir
      return
      ;;

    *)
      if [[ -n "$FILEDIR" ]]; then _filedir; fi
      if [[ "$ARRAY" = "show__none" ]]; then
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      elif [[ "$ARRAY" = "show__filedir" ]]; then
        _filedir
      elif [[ "$ARRAY" = "show__commands" ]]; then
        COMPREPLY=($(compgen -c -- "${cur}"))
      elif [ "$ARRAY" != "" ]; then
        COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      elif [ -n "$OPTS" ]; then
        COMPREPLY=($(compgen -W '${OPTS}' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      # elif [[ ${cword} -gt 2 ]]; then
      #   return
      # elif [[ ${cword} == 2 ]]; then
      #   _filedir
      #   compopt -o nospace
      #   return
      # elif [[ $cword -eq 1 ]]; then
      #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
      #   compopt -o nospace
      #   return
      fi
      ;;
    esac
  fi
  #
  # [[ ${cword} == 2 ]] && _filedir && compopt -o nospace
  # [[ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
  # [[ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
  # [[ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  #prev=""
  #compopt -o nospace
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _mydate mydate
