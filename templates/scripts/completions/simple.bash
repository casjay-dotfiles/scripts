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
# @@Template         :  installers/simple
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
_GEN_SCRIPT_REPLACE_FILENAME_completion() {
  local cur prev words cword
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  #####################################################################
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  #####################################################################
  local SHOW_COMP_OPTS=""
  #####################################################################
  local SHORTOPTS=""
  #####################################################################
  local LONGOPTS="--completions --config --debug --help --options --raw --version "
  #####################################################################
  local ARRAY=""
  #####################################################################
  local LIST=""
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
    COMPREPLY=($(compgen -W '${SHORTOPTS:---}' -- ${cur})) && compopt -o nospace
  else
    case "${prev:-${COMP_WORDS[1]}}" in
    --completions)
      prev=""
      COMPREPLY=($(compgen -W 'long short list array' -- "$cur"))
      ;;
    --debug | --raw | --help | --version | --config | --options)
      prev=""
      COMPREPLY=($(compgen -W '${SHORTOPTS:-$LONGOPTS}' -- "$cur"))
      ;;
    *)
      if [ $cword -gt 2 ]; then
        return
      else
        COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
        return 0
      fi
      ;;
    esac
  fi
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _GEN_SCRIPT_REPLACE_FILENAME_completion GEN_SCRIPT_REPLACE_FILENAME
