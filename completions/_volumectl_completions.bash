#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename -- "$0" 2>/dev/null)"
VERSION="202208181821-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [[ "$1" == "--debug" ]]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi

# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  volumectl --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Aug 18, 2022 18:21 EDT
# @File              :  volumectl
# @Description       :  Control volume in terminal
# @TODO              :
# @Other             :
# @Resource          :  https://coolaj86.com/articles/how-to-control-os-x-system-volume-with-applescript/
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_volumectl() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/volumectl"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/volumectl}"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local OPTS=""
  local LONGOPTS="--completions --debug --raw --options --config --version --help --silent --dir"
  local SHORTOPTS=""
  local ARRAY="up down mute unmute set get"

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
      fi
      ;;
    esac
  fi
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _volumectl volumectl
