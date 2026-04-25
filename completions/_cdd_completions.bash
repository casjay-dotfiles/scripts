#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  cdd --help
# @@Copyright        :  Copyright: (c) 2023 Jason Hempstead, Casjays Developments
# @@Created          :  Saturday, Feb 25, 2023 22:43 EST
# @@File             :  cdd
# @@Description      :  cd into directories using shortcuts
# @@Changelog        :
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
_cdd_completion() {
  _init_completion || return
  #####################################################################
  local cur prev words cword opts split CONFDIR="" CONFFILE="" SEARCHDIR=""
  local SHOW_COMP_OPTS="" SHORTOPTS="" LONGOPTS="" ARRAY="" LIST="" SHOW_COMP_OPTS_SEP=""
  #####################################################################
  ___ls() { ls -A "$1" 2>/dev/null | grep -v '^$' | grep '^' || false; }
  ___grep() { GREP_COLORS="" grep -shE '^.*=*..*$' "$1" 2>/dev/null | sed 's|"||g' 2>/dev/null | grep '^' || false; }
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  #####################################################################
  cur="${COMP_WORDS[$COMP_CWORD]}"
  prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  #####################################################################
  CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  #####################################################################
  CONFFILE="settings.conf"
  CONFDIR="$HOME/.config/myscripts/cdd"
  SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/cdd}"
  #####################################################################
  SHOW_COMP_OPTS=""
  #####################################################################
  SHORTOPTS="-c -v -h -m -r -l -s -a -d"
  SHORTOPTS+=""
  #####################################################################
  LONGOPTS="--completions --config --debug --dir --help --options --raw "
  LONGOPTS+=",--version --silent --modify --remove --list --shell --add --delete --root --cd"
  #####################################################################
  ARRAY="$(___ls "${CDD_OPTIONS_PROJECT_DIR:-$HOME/.local/share/cdd/projects}")"
  ARRAY="$(echo "${ARRAY[@]}" && [ -f "$HOME/.config/myscripts/cdd/aliases.conf" ] && cat "$HOME/.config/myscripts/cdd/aliases.conf" | awk -F '=' '{print $1}' | grep -v '#')"
  #####################################################################
  LIST=""
  LIST+=""
  #####################################################################
  if [ "$SHOW_COMP_OPTS" != "" ]; then
    SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi
  #####################################################################
  if [[ ${cur} == --* ]]; then
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
    --config | --debug | --help | --options | --raw | --version)
      COMPREPLY=($(compgen -W '${ARRAY} ${LONGOPTS} ${SHORTOPTS}' -- ${cur}))
      return 0
      ;;
    --dir)
      prev="dir"
      [ "$cword" -le 2 ] && _filedir -d || COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      ;;
    -l | --list) prev="--list" && COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}")) ;;
    -d | --delete) prev="--list" && COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}")) ;;
    -m | --modify)
      prev="-m"
      compopt -o nospace
      [ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
      [ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
      [ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;
    -r | --remove)
      prev="-r"
      [ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      [ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;
    *)
      COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      compopt -o nospace
      return 0
      ;;
    esac
  fi
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _cdd_completion -o default cdd

# ex: ts=2 sw=2 et filetype=sh
