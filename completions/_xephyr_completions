#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  xephyr --help
# @@Copyright        :  Copyright: (c) 2023 Jason Hempstead, Casjays Developments
# @@Created          :  Monday, Mar 13, 2023 11:37 EDT
# @@File             :  xephyr
# @@Description      :  xephyr
# @@Changelog        :
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
_xephyr_completion() {
  _init_completion || return
  #####################################################################
  local cur prev words cword opts split CONFDIR="" CONFFILE="" SEARCHDIR=""
  local SHOW_COMP_OPTS="" SHORTOPTS="" LONGOPTS="" ARRAY="" LIST="" SHOW_COMP_OPTS_SEP=""
  #####################################################################
  ___ls() { ls -A "$1" 2>/dev/null | grep -v '^$' | grep '^' || false; }
  ___grep() { GREP_COLORS="" grep -shE '^.*=*..*$' "$1" 2>/dev/null | sed 's|"||g' 2>/dev/null | grep '^' || false; }
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  #####################################################################
  cur="${COMP_WORDS[$COMP_CWORD]}"
  prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  #####################################################################
  CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  #####################################################################
  CONFFILE="settings.conf"
  CONFDIR="$HOME/.config/myscripts/xephyr"
  SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/xephyr}"
  #####################################################################
  SHOW_COMP_OPTS=""
  #####################################################################
  SHORTOPTS=""
  SHORTOPTS+=""
  #####################################################################
  LONGOPTS="--completions --debug --raw --options --config --version --help --silent --dir "
  LONGOPTS+=""
  #####################################################################
  ARRAY=""
  ARRAY+=""
  #####################################################################
  LIST=""
  LIST+=""
  #####################################################################
  if [ "$SHOW_COMP_OPTS" != "" ]; then
    SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi
  #####################################################################
  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
  elif [[ ${cur} == -* ]]; then
    if [ -n "$SHORTOPTS" ]; then
      COMPREPLY=($(compgen -W '${SHORTOPTS}' -- ${cur}))
    else
      COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    fi
  else
    case "${prev:-${COMP_WORDS[1]}}" in
    --completions)
      prev=""
      COMPREPLY=($(compgen -W 'long short list array' -- "$cur"))
      ;;
    --config | --debug | --help | --options | --raw | --version)
      COMPREPLY=($(compgen -W '${ARRAY} ${LONGOPTS} ${SHORTOPTS}' -- ${cur}))
      return 0
      ;;
    --dir)
      prev="dir"
      [ "$cword" -le 2 ] && _filedir -d || COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      ;;
    *)
      COMPREPLY=($(compgen -c -- "${cur}"))
      return 0
      ;;
    esac
  fi
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _xephyr_completion -o default xephyr

# ex: ts=2 sw=2 et filetype=sh
