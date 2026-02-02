#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Bash completion support for: gen-dockermgr
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
##@Author            :  Jason Hempstead
##@Contact           :  jason@casjaysdev.pro
##@License           :  LICENSE.md
##@Copyright         :  Copyright: (c) 2024 Jason Hempstead, Casjays Developments
##@Created           :  Monday, Dec 09, 2024 12:00 EST
##@File              :  _gen-dockermgr_completions
##@Description       :  Bash completion for gen-dockermgr
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

_gen-dockermgr() {
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local SHORTOPTS=""
  local LONGOPTS="--help --config --version --options --debug --raw --silent "
  local LONGOPTS+="--nogit --nopush --noask --dir"
  local ARRAY="script"

  _init_completion || return

  if [[ $cur == --* ]]; then
    COMPREPLY=($(compgen -W '$LONGOPTS' -- "$cur"))
    return 0
  elif [[ $cur == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS//,/ }' -- "$cur"))
    return 0
  else
    case "${prev:-${COMP_WORDS[1]}}" in
    --completions)
      COMPREPLY=($(compgen -W 'long short list array' -- "$cur"))
      return 0
      ;;
    --config | --help | --version | --options | --raw)
      return 0
      ;;
    --dir)
      _filedir -d
      return 0
      ;;
    --nogit | --nopush | --noask | --debug | --silent)
      return 0
      ;;
    *)
      if [[ -n "$ARRAY" ]]; then
        COMPREPLY=($(compgen -W '${ARRAY//,/ }' -- "$cur"))
        return 0
      elif [[ -f "$CASJAYSDEVDIR/helpers/gen-dockermgr" ]]; then
        local OUTPUT_SHOW=""
        OUTPUT_SHOW="$($CASJAYSDEVDIR/helpers/gen-dockermgr --options 2>/dev/null | grep '^' || echo '')"
        COMPREPLY=($(compgen -W '${OUTPUT_SHOW//,/ }' -- "$cur"))
        return 0
      else
        COMPREPLY=($(compgen -W '$LONGOPTS' -- "$cur"))
        return 0
      fi
      ;;
    esac
  fi
}

complete -F _gen-dockermgr gen-dockermgr
