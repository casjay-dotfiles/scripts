#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  020520211122-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  castero --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created           :  Friday, Feb 05, 2021 11:22 EST
# @File              :  castero
# @Description       :  autocomplete for castero
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -
_castero() {
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword
  ARRAY="-h --help --import --export -v --version"
  _init_completion || return

  case $prev in
  --import)
    _filedir
    return
    ;;
  --export)
    _filedir
    return
    ;;
  *)
    _filedir
    return
    ;;
  esac
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _castero castero
