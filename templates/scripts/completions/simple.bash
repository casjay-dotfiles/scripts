#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : GEN_SCRIPT_REPLACE_VERSION
# @Author        : GEN_SCRIPT_REPLACE_AUTHOR
# @Contact       : GEN_SCRIPT_REPLACE_EMAIL
# @License       : GEN_SCRIPT_REPLACE_LICENSE
# @ReadME        : GEN_SCRIPT_REPLACE_FILENAME --help
# @Copyright     : GEN_SCRIPT_REPLACE_COPYRIGHT
# @Created       : GEN_SCRIPT_REPLACE_DATE
# @File          : GEN_SCRIPT_REPLACE_FILENAME
# @Description   : GEN_SCRIPT_REPLACE_DESC
# @TODO          : GEN_SCRIPT_REPLACE_TODO
# @Other         : GEN_SCRIPT_REPLACE_OTHER
# @Resource      : GEN_SCRIPT_REPLACE_RES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
_GEN_SCRIPT_REPLACE_FILENAME() {
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local SHOW_COMP_OPTS=""
  local LONGOPTS="--help --version --config --options"
  local SHORTOPTS=""
  local ARRAY=""

  _init_completion || return

  if [ "$SHOW_COMP_OPTS" != "" ]; then
    local SHOW_COMP_OPTS_SEP="$(echo "$SHOW_COMP_OPTS" | tr ',' ' ')"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
  elif [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS}' -- ${cur}))
  else
    case "${COMP_WORDS[1]:-$prev}" in
    *)
      COMPREPLY=($(compgen -W '$ARRAY' -- "$cur"))
      return 0
      ;;
    esac
  fi
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _GEN_SCRIPT_REPLACE_FILENAME am_i_online
