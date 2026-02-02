#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  gen-caddy --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Aug 12, 2021 19:03 EDT
# @File              :  gen-caddy
# @Description       :  Setup caddy web server
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_gen-caddy() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/gen-caddy"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/gen-caddy}"
  #local SEARCHCMD="$(___findcmd "$SEARCHDIR/" "d" "1" | sort -u)"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local OPTS=""
  local LONGOPTS="--completions --config --debug --dir --help --options --raw --version --silent --force --domain --port --fpm --caddyfile --no-php"
  local SHORTOPTS=""
  local ARRAY="start stop reload restart status install update fixphp installphp edit service uninstall delete-service config html backup restore about help version download reverse check"
  local SERVER_COMMANDS="start stop reload restart status"
  local INSTALL_COMMANDS="install update uninstall"
  local CONFIG_COMMANDS="config edit check"
  local PHP_COMMANDS="installphp fixphp"

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

    --dir)
      _filedir -d
      ;;
    --domain | --port | --fpm)
      # These expect custom input
      ;;
    --caddyfile)
      _filedir
      ;;
    --force | --no-php | --silent)
      # Boolean flags - no additional arguments
      ;;
    
    install)
      # Install can take --no-php
      if [[ ${cur} == --* ]]; then
        COMPREPLY=($(compgen -W '--no-php --force' -- "${cur}"))
      fi
      ;;
      
    reverse)
      case $COMP_CWORD in
        2) COMPREPLY=($(compgen -W '80 443 8080 3000 5000' -- "${cur}")) ;;  # To port
        3) COMPREPLY=($(compgen -W '3000 5000 8000 8080 9000' -- "${cur}")) ;;  # From port
      esac
      ;;
      
    config)
      # Config command - no additional arguments
      ;;
      
    edit | check)
      _filedir
      ;;

    *)
      COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      ;;
    esac
  fi
  #
  # [[ ${cword} == 2 ]] && _filedir && compopt -o nospace
  # [[ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
  # [[ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
  # [[ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  #prev=""
  #compopt -o nospace
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _gen-caddy gen-caddy
