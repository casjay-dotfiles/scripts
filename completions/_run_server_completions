#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  run_server --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Aug 12, 2021 19:03 EDT
# @File              :  run_server
# @Description       :  Start an HTTP server from a directory
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_run_server() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/run_server"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/run_server}"
  #local SEARCHCMD="$(___findcmd "$SEARCHDIR/" "d" "1" | sort -u)"
  local SHOW_COMP_OPTS=""
  local FILEDIR="yes"
  local OPTS=""
  local LONGOPTS="--completions --config --debug --dir --help --options --raw --version --silent "
  local LONGOPTS+=",--bg --screen --editor --filemanager --browser --console --enable-browser --enable-filemanager "
  local LONGOPTS+=",--enable-editor --enable-all --disable-browser --disable-filemanager --disable-editor --disable-all --allow-root"
  local SHORTOPTS=""
  local ARRAY="-- static proxy caddy go jekyll nginx"
  local ARRAY+="js php rails ruby python2 python3 netcat default "

  _init_completion || return

  if [[ "$SHOW_COMP_OPTS" != "" ]]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    return
  elif [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS} ${LONGOPTS}' -- ${cur}))
    return
  else
    case "${COMP_CWORD:-$prev}" in
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
      [ -e "${cword}" ] && shift
      if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
        _filedir
        return
      elif [[ ${#COMP_WORDS[@]} -eq 3 ]]; then
        COMPREPLY=($(compgen -W '${ARRAY}' -o nospace -- "${cur}"))
        return
      elif [[ ${#COMP_WORDS[@]} -eq 4 ]]; then
        compopt -o nospace
        COMPREPLY+=($(compgen -W '{19000..19019}' -o nospace -- "${cur}"))
        return
      elif [[ ${#COMP_WORDS[@]} -gt 4 ]]; then
        compopt -o nospace
        COMPREPLY+=($(compgen -W '{1..9}' -- "${cur}"))
        return
      else
        COMPREPLY=($(compgen -W '${ARRAY}' -- ${cur}))
        return
      fi
      ;;
    esac
  fi
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _run_server run_server
