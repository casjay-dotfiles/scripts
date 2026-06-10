#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202606101630-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  cloudflare --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Aug 12, 2021 19:02 EDT
# @Updated           :  Friday, Sep 20, 2024 08:30 EDT
# @File              :  cloudflare
# @Description       :  cloudflare api script
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -
_cloudflare() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/cloudflare"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/cloudflare}"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local OPTS=""
  local SHORTOPTS=""
  local LONGOPTS="--completions --config --debug --help --options --no-color --version "
  local LONGOPTS+="--ip --zone --proxy --record --api --key --delete-all --id --bulk"
  local ARRAY="create update delete list verify tunnel zones cron"

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
    --completions)
      local prev="--completions"
      COMPREPLY=($(compgen -W 'short long array list' -- "${cur}"))
      ;;

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

    --dir)
      local prev="dir"
      _filedir
      return
      ;;

    --record)
      local prev="--record"
      COMPREPLY=($(compgen -W 'A AAAA CNAME TXT MX NS CAA' -- "${cur}"))
      ;;

    --proxy)
      local prev="--proxy"
      COMPREPLY=($(compgen -W 'true false yes no' -- "${cur}"))
      ;;

    --id)
      prev="${COMP_WORDS[1]}"
      COMPREPLY=($(compgen -W 'zone=\"\" record=\"\"' -- ${cur}))
      ;;
    create | update | delete | list | verify | tunnel | zones | cron)
      local prev="${COMP_WORDS[1]}"
      COMPREPLY=($(compgen -W ' ' -- ${cur}))
      ;;

    *)
      [[ $COMP_CWORD -lt 2 ]] && COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      [[ $COMP_CWORD -gt 5 ]] && COMPREPLY=($(compgen -W '$(compopt -o nospace)' -- "${cur}"))
      return
      ;;
    esac
  fi
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _cloudflare cloudflare
