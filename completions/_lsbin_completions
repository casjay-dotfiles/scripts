#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  lsbin --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Friday, Nov 04, 2022 13:34 EDT
# @@File             :  lsbin
# @@Description      :
# @@Changelog        :
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
_lsbin_completion() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  #####################################################################
  local CONFDIR="$HOME/.config/myscripts/lsbin"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/lsbin}"
  #####################################################################
  local SHOW_COMP_OPTS=""
  #####################################################################
  local SHORTOPTS=""
  #####################################################################
  local LONGOPTS="--completions --config --debug --dir --help --options --raw --version --silent "
  #####################################################################
  local ARRAY="l. ls la ll lla dir"
  #####################################################################
  local LIST=""
  #####################################################################
  _init_completion || return
  #####################################################################
  if [ "$SHOW_COMP_OPTS" != "" ]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
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
    --debug | --raw | --help | --version | --config | --options)
      COMPREPLY=($(compgen -W '${ARRAY} ${LONGOPTS} ${SHORTOPTS}' -- ${cur}))
      return 0
      ;;
    --dir)
      prev="dir"
      [ "$cword" -le 2 ] && _filedir -d || COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      ;;
    l. | ls | la | ll | lla | dir)
      COMPREPLY=($(compgen -W '$(_filedir)' -- ${cur}))
      ;;

    *)
      COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      return 0
      ;;
    esac
  fi
  #
  # if [ -n "$FILEDIR" ]; then _filedir; fi
  # if [ $cword -gt 2 ]; then
  #   return
  # elif [ $cword == 2 ]; then
  #   _filedir
  #   compopt -o nospace
  #   return
  # elif [ $cword -eq 1 ]; then
  #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
  #   compopt -o nospace
  #   return
  # if [ "$ARRAY" = "show__none" ]; then
  #   COMPREPLY=($(compgen -W '' -- "${cur}"))
  # elif [ "$ARRAY" = "show__filedir" ]; then
  #   _filedir
  # elif [ "$ARRAY" = "show__commands" ]; then
  #   COMPREPLY=($(compgen -c -- "${cur}"))
  # elif [ "$ARRAY" != "" ]; then
  #   COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
  # elif [ -n "$OPTS" ]; then
  #   COMPREPLY=($(compgen -W '${OPTS}' -- "${cur}"))
  # else
  #   COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
  # elif [ $cword -gt 2 ]; then
  #   return
  # elif [ $cword == 2 ]; then
  #   _filedir
  #   compopt -o nospace
  #   return
  # elif [ $cword -eq 1 ]; then
  #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
  #   compopt -o nospace
  #   return
  # fi
  # [ ${cword} == 2 ] && _filedir && compopt -o nospace
  # [ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
  # [ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
  # [ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  # prev=""
  # compopt -o nospace
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _lsbin_completion -o default lsbin

# ex: ts=2 sw=2 et filetype=sh
