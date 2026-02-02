#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  LICENSE.md
# @@ReadME           :  gen-traefik --help
# @@Copyright        :  Copyright: (c) 2025 Jason Hempstead, Casjays Developments
# @@Created          :  Monday, Sep 16, 2025 00:25 EDT
# @@File             :  gen-traefik
# @@Description      :  Generate a new traefik host configuration
# @@Changelog        :
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
_gen-traefik_completion() {
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
  CONFDIR="$HOME/.config/myscripts/gen-traefik"
  SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/gen-traefik}"
  #####################################################################
  SHOW_COMP_OPTS=""
  #####################################################################
  SHORTOPTS=""
  SHORTOPTS+=""
  #####################################################################
  LONGOPTS="--completions --config --reset-config --debug --dir --help --options --raw --version --silent --force --template --ssl"
  LONGOPTS+=""
  #####################################################################
  ARRAY="list"
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
    --options)
      COMPREPLY=($(compgen -W '' -- ${cur}))
      return 0
      ;;
    --help | --version | --config)
      COMPREPLY=($(compgen -W '' -- ${cur}))
      return 0
      ;;
    --debug | --raw)
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
    --template)
      COMPREPLY=($(compgen -W 'ssl standard' -- "$cur"))
      return 0
      ;;
    --ssl)
      COMPREPLY=($(compgen -W 'yes no' -- "$cur"))
      return 0
      ;;
    --dir)
      _filedir
      return 0
      ;;
    list)
      COMPREPLY=($(compgen -W '' -- "$cur"))
      return 0
      ;;
    *)
      [ $cword -gt 2 ] && COMPREPLY=($(compgen -W '${LIST}' -- "$cur")) ||
        COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      return 0
      ;;
    esac
  fi
  #
  # [ "${ARRAY}" = "show__filedir" ] && _filedir
  # [ ${cword} = 2 ] && _filedir && compopt -o nospace
  # [ "${ARRAY}" != "" ] && COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
  # [ "${ARRAY}" = "show__none" ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  # [ "${ARRAY}" = "show__commands" ] && COMPREPLY=($(compgen -c -- "${cur}"))
  # [ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
  # [ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
  # [ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  # compopt -o nospace
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _gen-traefik_completion -o default gen-traefik

# ex: ts=2 sw=2 et filetype=sh
