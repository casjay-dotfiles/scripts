#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  gitcommit --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Aug 12, 2021 19:03 EDT
# @File              :  gitcommit
# @Description       :  Commit changes to a git repo (self-contained)
# @TODO              :  N/A
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_gitcommit() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/gitcommit"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/gitcommit}"
  local SHOW_COMP_OPTS="default"
  local FILEDIR=""
  local OPTS=""
  local LONGOPTS="--completions --debug --raw --options --version --help --config --silent --dir --message --amend --force"
  local SHORTOPTS="-m"
  local ARRAY="ai is all amend status s log l reset branch fixup fix fix-last squash push pull merge merge-resolve "
  local ARRAY+="version files modified updated deleted added renamed changed restored spelling "
  local ARRAY+="new improved fixes fixed release deploy docs test breaking refactor performance "
  local ARRAY+="permissions permission bugs bug docker node ruby php perl python scratchpad "
  local ARRAY+="todo recipe notes blog init setup emojify emj emojy random custom tag tar search alot "
  _init_completion || return

  if [[ "$SHOW_COMP_OPTS" != "" ]]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    return
  elif [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS}' -- ${cur}))
    return
  else
    case "${COMP_WORDS[1]:-$prev}" in
    --options)
      local prev="--options"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --config)
      local prev="--config"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --help)
      prev="--help"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --version)
      local prev="--version"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    is)
      local prev="is"
      COMPREPLY=($(compgen -W 'clean dirty' -- "${cur}"))
      ;;

    log)
      local prev="log"
      COMPREPLY=($(compgen -W 'show search' -- "${cur}"))
      ;;

    tag)
      local prev="tag"
      COMPREPLY=($(compgen -W 'add remove version' -- "${cur}"))
      ;;

    merge)
      local prev="merge"
      COMPREPLY=($(compgen -W 'auto ff no-ff squash help' -- "${cur}"))
      ;;

    merge-resolve)
      local prev="merge-resolve"
      COMPREPLY=($(compgen -W 'status show edit ours theirs abort' -- "${cur}"))
      ;;

    setup)
      local prev="setup"
      COMPREPLY=($(compgen -W 'all org' -- "${cur}"))
      ;;

    *)
      if [[ "$array" != "true" ]] && [[ ${#COMP_WORDS[@]} -le 2 ]]; then
        local array="true"
        COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      else
        _filedir
      fi
      ;;
    esac
  fi
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _gitcommit gitcommit
