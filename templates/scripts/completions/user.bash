#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : GEN_SCRIPTS_REPLACE_VERSION
# @Author        : GEN_SCRIPTS_REPLACE_AUTHOR
# @Contact       : GEN_SCRIPTS_REPLACE_EMAIL
# @License       : GEN_SCRIPTS_REPLACE_LICENSE
# @ReadME        : GEN_SCRIPTS_REPLACE_FILENAME --help
# @Copyright     : GEN_SCRIPTS_REPLACE_COPYRIGHT
# @Created       : GEN_SCRIPTS_REPLACE_DATE
# @File          : GEN_SCRIPTS_REPLACE_FILENAME
# @Description   : GEN_SCRIPTS_REPLACE_FILENAME completion script
# @TODO          : GEN_SCRIPTS_REPLACE_TODO
# @Other         : GEN_SCRIPTS_REPLACE_OTHER
# @Resource      : GEN_SCRIPTS_REPLACE_RES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#[ -f "$HOME/.local/share/misc/GEN_SCRIPTS_REPLACE_FILENAME/options/array" ] || GEN_SCRIPTS_REPLACE_FILENAME --options &>/dev/null
_GEN_SCRIPTS_REPLACE_FILENAME() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/misc/settings/GEN_SCRIPTS_REPLACE_FILENAME"
  local OPTSDIR="$HOME/.local/share/misc/GEN_SCRIPTS_REPLACE_FILENAME/options"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/misc/settings/GEN_SCRIPTS_REPLACE_FILENAME}"
  #local SEARCHCMD="$(___findcmd "$SEARCHDIR/" "d" "1")"
  local DEFAULTARRAY=""
  local DEFAULTOPTS=""
  local LONGOPTS="--help --version --config --options"
  local SHORTOPTS="-h -v"
  local OPTS="$DEFAULTOPTS"
  local ARRAY="$DEFAULTARRAY"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""

  _init_completion || return
  if [ "$SHOW_COMP_OPTS" != "" ]; then
    local SHOW_COMP_OPTS_SEP="$(echo "$SHOW_COMP_OPTS" | tr ',' ' ')"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi
  case ${COMP_WORDS[1]:-$prev} in
  -) prev="-" COMPREPLY=($(compgen -W '${SHORTOPTS} ${LONGOPTS}' -- ${cur})) ;;
  --options) prev="--options" && COMPREPLY=($(compgen -W '' -- "${cur}")) ;;
  -c | --config) prev="--config" && COMPREPLY=($(compgen -W '' -- "${cur}")) ;;
  -h | --help) prev="--help" && COMPREPLY=($(compgen -W '' -- "${cur}")) ;;
  -v | --version) prev="--version" && COMPREPLY=($(compgen -W '' -- "${cur}")) ;;
  -m | --modify)
    prev="-m"
    compopt -o nospace
    [ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
    [ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
    [ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
    ;;
  -r | --remove)
    prev="-r"
    [ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
    [ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
    ;;
  *)
    if [ -n "$FILEDIR" ]; then _filedir; fi
    if [[ "$ARRAY" = "show-none" ]]; then
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    elif [[ "$ARRAY" = "show-_filedir" ]]; then
      _filedir
    elif [[ "$ARRAY" = "show-commands" ]]; then
      COMPREPLY=($(compgen -c -- "${cur}"))
    elif [[ -n "$ARRAY" ]]; then
      #[ $COMP_CWORD -eq 3 ] && \
      COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
    elif [[ -n "$OPTS" ]]; then
      #[ $COMP_CWORD -gt 3 ] && \
      COMPREPLY=($(compgen -W '${OPTS}' -- "${cur}"))
    elif [[ ${cur} == --* ]]; then
      COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    elif [[ ${cur} == -* ]]; then
      COMPREPLY=($(compgen -W '${SHORTOPTS}' -- ${cur}))
    fi
    ;;
  esac
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _GEN_SCRIPTS_REPLACE_FILENAME GEN_SCRIPTS_REPLACE_FILENAME
