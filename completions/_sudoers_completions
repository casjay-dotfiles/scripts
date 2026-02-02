#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  sudoers --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created           :  Friday, Aug 06, 2021 21:18 EDT
# @File              :  sudoers
# @Description       :  sudoers completion script
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -
#[ -f "$HOME/.local/share/myscripts/sudoers/array" ] || sudoers --options &>/dev/null
_sudoers() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local SHOW_COMP_OPTS_SEP=""
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/sudoers"
  local OPTSDIR="$HOME/.local/share/myscripts/sudoers/options"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/sudoers}"
  #local SEARCHCMD="$(___findcmd "$SEARCHDIR/" "d" "1" | sort -u)"
  local DEFAULTARRAY=""
  local DEFAULTOPTS=""
  local LONGOPTS="--completions --debug --raw --options --config --version --help --silent --dir"
  local SHORTOPTS="-h -v"
  local OPTS="$DEFAULTOPTS"
  local ARRAY="remove pass remuser adduser nopass insults status users"
  local ARRAY_USERS="add remove"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""

  _init_completion || return
  if [ "$SHOW_COMP_OPTS" != "" ]; then
    SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi
  case ${COMP_WORDS[1]:-$prev} in
  -) COMPREPLY=($(compgen -W '${SHORTOPTS} ${LONGOPTS}' -- ${cur})) && prev="-" ;;
  --options) COMPREPLY=($(compgen -W '' -- "${cur}")) && prev="--options" ;;
  -c | --config) COMPREPLY=($(compgen -W '' -- "${cur}")) && prev="--config" ;;
  -h | --help) COMPREPLY=($(compgen -W '' -- "${cur}")) && prev="--help" ;;
  -v | --version) COMPREPLY=($(compgen -W '' -- "${cur}")) && prev="--version" ;;
  -l | --list) COMPREPLY=($(compgen -W '' -- "${cur}")) && prev="--list" ;;
  remove) COMPREPLY=($(compgen -u -- "$cur")) && prev="remove" ;;
  remuser) COMPREPLY=($(compgen -u -- "$cur")) && prev="remuser" ;;
  adduser) COMPREPLY=($(compgen -u -- "$cur")) && prev="adduser" ;;
  pass) COMPREPLY=($(compgen -u -- "$cur")) && prev="pass" ;;
  nopass) COMPREPLY=($(compgen -u -- "$cur")) && prev="nopass" ;;
  insults) COMPREPLY=($(compgen -W '' -- "${cur}")) && prev="insults" ;;
  status) COMPREPLY=($(compgen -W '' -- "${cur}")) && prev="status" ;;
  command) COMPREPLY=($(compgen -c -- "${cur}")) && prev="command" ;;
  users) COMPREPLY=($(compgen -W '${ARRAY_USERS}' -- "${cur}")) && prev="users" ;;
  *)
    if [ -n "$FILEDIR" ]; then _filedir; fi
    if [[ "$ARRAY" = "show__none" ]]; then
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    elif [[ "$ARRAY" = "show__filedir" ]]; then
      _filedir
    elif [[ "$ARRAY" = "show__commands" ]]; then
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
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _sudoers sudoers
