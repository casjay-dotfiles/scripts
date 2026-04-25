#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602042115-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  zellij-new --help
# @Copyright         :  Copyright: (c) 2026 Jason Hempstead, Casjays Developments
# @Created           :  Tuesday, Feb 04, 2026 21:15 UTC
# @File              :  zellij-new
# @Description       :  Bash completion for zellij-new
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_zellij-new() {
  ___findcmd() { find -L "${1:-$SEARCHDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local SEARCHDIR="$HOME/.config/myscripts/zellij-new"
  local SEARCHCMD="$(___findcmd "$SEARCHDIR/layouts/" "f" "1" | sed 's/.kdl$//' | sort -u)"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local OPTS=""
  local LONGOPTS="--completions --config --debug --dir --help --options --raw --version --silent --kill --name"
  local SHORTOPTS=""
  local ARRAY="kill clean list attach switch rename status clone nested single shell server web docker dev go rust python devops monitoring database rpm node bun deno build ssh productivity test default edit create update"
  local LAUNCH="nested single shell server web docker dev go rust python devops monitoring database rpm node bun deno build ssh productivity test default"
  local zellij_sessions="$(zellij list-sessions 2>/dev/null | awk '{print $1}' | grep -vE '^$' || echo '')"
  _init_completion || return

  if [[ "$SHOW_COMP_OPTS" != "" ]]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    return
  else
    case "${COMP_WORDS[1]:-$prev}" in
    --options)
      shift 1
      local prev="--options"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --config)
      shift 1
      local prev="--config"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --help)
      shift 1
      prev="--help"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --version)
      shift 1
      local prev="--version"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --completions)
      shift 1
      local prev="--completions"
      COMPREPLY=($(compgen -W 'short long array list' -- "${cur}"))
      ;;

    --dir)
      shift 1
      local prev="dir"
      _filedir
      return
      ;;

    list | ls)
      shift 1
      local prev="ls"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;
    attach | a)
      COMPREPLY=($(compgen -W '${zellij_sessions}' -- "${cur}"))
      ;;
    switch | sw)
      COMPREPLY=($(compgen -W '${zellij_sessions}' -- "${cur}"))
      ;;
    rename | mv)
      if [ $COMP_CWORD -eq 2 ]; then
        COMPREPLY=($(compgen -W '${zellij_sessions}' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      fi
      ;;
    clone | copy)
      if [ $COMP_CWORD -eq 2 ]; then
        COMPREPLY=($(compgen -W '${zellij_sessions}' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      fi
      ;;
    kill)
      if [ $COMP_CWORD -eq 2 ]; then
        # Complete kill subcommands
        COMPREPLY=($(compgen -W 'all session' -- "${cur}"))
      elif [ $COMP_CWORD -gt 2 ] && [ "${COMP_WORDS[2]}" = "session" ]; then
        # Complete session names for kill session
        COMPREPLY=($(compgen -W '${zellij_sessions}' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      fi
      ;;
    create)
      COMPREPLY=($(compgen -W '$(echo {a..z})' -- "${cur}"))
      ;;
    edit)
      [ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '${SEARCHCMD}' -- "${cur}")) || COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;
    update)
      if [ $COMP_CWORD -eq 2 ]; then
        COMPREPLY=($(compgen -W 'templates template all' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      fi
      ;;
    *)
      COMPREPLY=($(compgen -W '${ARRAY} ${LAUNCH}' -- "${cur}"))
      compopt -o nospace
      ;;
    esac
  fi
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _zellij-new zellij-new
