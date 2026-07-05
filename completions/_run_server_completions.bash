#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202607051400-git
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
  local cur prev words cword
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFDIR="$HOME/.config/myscripts/run_server"

  local LONGOPTS="completions: config debug dir: help options no-color version silent"
  LONGOPTS="$LONGOPTS bg screen editor filemanager browser console"
  LONGOPTS="$LONGOPTS enable-browser enable-filemanager enable-editor enable-all"
  LONGOPTS="$LONGOPTS disable-browser disable-filemanager disable-editor disable-all allow-root"

  local SHORTOPTS=""
  local COMMANDS="write static proxy caddy go jekyll js php rails ruby python2 python3 netcat nginx default"

  _init_completion || return

  if [[ ${cur} == --* ]]; then
    local options=$(echo "$LONGOPTS" | sed 's/:$//' | sed 's/ / --/g' | sed 's/^/--/')
    COMPREPLY=($(compgen -W "$options" -- ${cur}))
    return 0
  fi

  if [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W "$SHORTOPTS" -- ${cur}))
    return 0
  fi

  case "${prev}" in
  --dir)
    local cur="${COMP_WORDS[$COMP_CWORD]}"
    _filedir -d
    return 0
    ;;
  --completions)
    COMPREPLY=($(compgen -W "short long array list" -- "${cur}"))
    return 0
    ;;
  esac

  if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
    COMPREPLY=($(compgen -W "$COMMANDS" -- "${cur}"))
    return 0
  fi

  COMPREPLY=($(compgen -W "$COMMANDS" -- "${cur}"))
  return 0
} &&
complete -F _run_server run_server
