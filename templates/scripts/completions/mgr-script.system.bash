#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  GEN_SCRIPT_REPLACE_VERSION
# @@Author           :  GEN_SCRIPT_REPLACE_AUTHOR
# @@Contact          :  GEN_SCRIPT_REPLACE_EMAIL
# @@License          :  GEN_SCRIPT_REPLACE_LICENSE
# @@ReadME           :  GEN_SCRIPT_REPLACE_FILENAME --help
# @@Copyright        :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @@Created          :  GEN_SCRIPT_REPLACE_DATE
# @@File             :  GEN_SCRIPT_REPLACE_FILENAME
# @@Description      :  GEN_SCRIPT_REPLACE_DESC
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  GEN_SCRIPT_REPLACE_TODO
# @@Other            :  GEN_SCRIPT_REPLACE_OTHER
# @@Resource         :  GEN_SCRIPT_REPLACE_RES
# @@Terminal App     :  GEN_SCRIPT_REPLACE_TERMINAL
# @@sudo/root        :  GEN_SCRIPT_REPLACE_SUDO
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_GEN_SCRIPT_REPLACE_FILENAME_completion() {
  ___ls() { ls -A "$1" 2>/dev/null | grep -v '^$' | grep '^' || false; }
  ___grep() { GREP_COLORS="" grep -sE '^.*=*..*$' "$1" 2>/dev/null | sed 's|"||g' 2>/dev/null | grep '^' || false; }
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  #####################################################################
  local CONFDIR="$HOME/.config/myscripts/GEN_SCRIPT_REPLACE_FILENAME"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/GEN_SCRIPT_REPLACE_FILENAME}"
  #####################################################################
  local SHOW_COMP_OPTS=""
  #####################################################################
  local SHORTOPTS="-a -f "
  #####################################################################
  local LONGOPTS="--all --completions --config --debug --force --help --options --raw --version "
  local LONGOPTS+=""
  #####################################################################
  local ARRAY="available cron download install list remove search update version "
  local ARRAY+=""
  #####################################################################
  local LIST=""
  local LIST+=""
  #####################################################################
  _init_completion || return
  #####################################################################
  if [ "$SHOW_COMP_OPTS" != "" ]; then
    local SHOW_COMP_OPTS_SEP="$(echo "$SHOW_COMP_OPTS" | tr ',' ' ')"
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
    --all)
      COMPREPLY=($(compgen -W '' -- "$cur"))
      ;;
    *)
      [ $cword -gt 2 ] && COMPREPLY=($(compgen -W '${LIST}' -- "$cur")) ||
        COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      return 0
      ;;
    esac
  fi
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _GEN_SCRIPT_REPLACE_FILENAME_completion GEN_SCRIPT_REPLACE_FILENAME

# ex: ts=2 sw=2 et filetype=sh
