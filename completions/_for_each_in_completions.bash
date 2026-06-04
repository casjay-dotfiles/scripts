#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202606040928-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  for_each_in --help
# @@Copyright        :  Copyright: (c) 2026 Jason Hempstead, Casjays Developments
# @@Created          :  Friday, May 15, 2026 12:43 EDT
# @@File             :  for_each_in
# @@Description      :  Bash completions for for_each_in
# @@Changelog        :  Sync flags with script: add dry-run/verbose/stop-on-error/summary/delete/source/dest/not/no-color; remove force/raw
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
_for_each_in_completion() {
  #####################################################################
  local cur prev words cword opts split CONFDIR="" CONFFILE="" SEARCHDIR=""
  local SHOW_COMP_OPTS="" NOOPTS="" SHORTOPTS="" LONGOPTS="" ARRAY="" LIST="" SHOW_COMP_OPTS_SEP=""
  #####################################################################
  _init_completion || return
  #####################################################################
  ___jq() { jq -rc "$@" 2>/dev/null; }
  ___sed_env() { sed 's|"||g;s|.*=||g' 2>/dev/null || false; }
  ___ls() { ls -A "$1" 2>/dev/null | grep -v '^$' | grep '^' || false; }
  ___curl() { curl -q -LSsf --max-time 1 --retry 0 "$@" 2>/dev/null || return 1; }
  ___grep_file() { grep --no-filename -vsR '#' "$@" 2>/dev/null | grep '^' || return 1; }
  ___find_cmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | grep '^' || return 1; }
  ___find_rel() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} -printf "%P\n" 2>/dev/null | grep '^' || return 1; }
  ___grep_env() { GREP_COLORS="" grep -shE '^.*=*..*$' "$1" 2>/dev/null | grep -v '^#' | grep "${2:-^}" | sed 's|"||g' 2>/dev/null | grep '^' || false; }
  #####################################################################
  cur="${COMP_WORDS[$COMP_CWORD]}"
  prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  #####################################################################
  CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  #####################################################################
  CONFFILE="settings.conf"
  CONFDIR="$HOME/.config/myscripts/for_each_in"
  SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/for_each_in}"
  #####################################################################
  SHOW_COMP_OPTS=""
  #####################################################################
  SHORTOPTS="-n -v"
  SHORTOPTS+=""
  #####################################################################
  LONGOPTS="--completions --config --reset-config --debug --dir --help --options --no-color --version --silent"
  LONGOPTS+=" --dry-run --verbose --stop-on-error --summary --not"
  LONGOPTS+=" --no- --yes-"
  #####################################################################
  ARRAY=""
  ARRAY+=""
  #####################################################################
  LIST=""
  LIST+=""
  #####################################################################
  OPTS_NO="--no-* "
  OPTS_YES="--yes-* "
  #####################################################################
  if [ "$SHOW_COMP_OPTS" != "" ]; then
    SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi
  #####################################################################
  if [[ ${cur} == --no* ]]; then
    COMPREPLY=($(compgen -W '${OPTS_NO}' -- ${cur}))
  elif [[ ${cur} == --yes* ]]; then
    COMPREPLY=($(compgen -W '${OPTS_YES}' -- ${cur}))
  elif [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
  elif [[ ${cur} == -* ]]; then
    if [ -n "$SHORTOPTS" ]; then
      COMPREPLY=($(compgen -W '${SHORTOPTS}' -- ${cur}))
    else
      COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    fi
  else
    case "${prev:-${COMP_WORDS[1]}}" in
    --completions)
      prev=""
      COMPREPLY=($(compgen -W 'long short list array' -- "$cur"))
      ;;
    --source | --dest | --dir)
      _filedir
      return 0
      ;;
    --options)
      COMPREPLY=($(compgen -W '' -- ${cur}))
      return 0
      ;;
    --help | --version | --config)
      COMPREPLY=($(compgen -W '' -- ${cur}))
      return 0
      ;;
    --debug | --no-color)
      COMPREPLY=($(compgen -W '${ARRAY} ${LONGOPTS} ${SHORTOPTS}' -- ${cur}))
      return 0
      ;;
    --no-*)
      COMPREPLY=($(compgen -W '${OPTS_NO}' -- "$cur"))
      return 0
      ;;
    --yes-*)
      COMPREPLY=($(compgen -W '${OPTS_YES}' -- "$cur"))
      return 0
      ;;
    *)
      [ $cword -gt 2 ] && COMPREPLY=($(compgen -W '${LIST}' -- "$cur")) ||
        COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      return 0
      ;;
    esac
  fi
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _for_each_in_completion -o default for_each_in

# ex: ts=2 sw=2 et filetype=sh
