#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202609031820-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  screen-new --help
# @@Copyright        :  Copyright: (c) 2026 Jason Hempstead, Casjays Developments
# @@Created          :  Friday, Feb 06, 2026 09:24 EST
# @@File             :  screen-new
# @@Description      :  Completions for screen-new session manager
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
_screen-new() {
  local cur prev words cword
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"

  # Fallback if _init_completion is not available
  if declare -F _init_completion &>/dev/null; then
    _init_completion || return
  fi

  local LONGOPTS="--completions --config --reset --debug --dir --exec --help --name --options --no-color --version --silent --force"

  local SUBCOMMANDS="a attach ls list kill d detach edit switch sw rename mv clone copy status info show update create"

  local PRESETS="ai single shell dev go rust python devops monitoring database docker rpm node bun deno build ssh productivity test default"

  local ALL_COMMANDS="${SUBCOMMANDS} ${PRESETS}"

  # Helper: get active screen-new session names
  __sn_sessions() {
    screen -ls 2>/dev/null | grep -E '\.scn-|\.sn-' | sed 's/.*\.\(scn\|sn\)-//;s/[[:space:]].*//' | sort -u
  }

  # Options always available
  if [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W "${LONGOPTS}" -- "${cur}"))
    return 0
  fi

  # Handle subcommands and their completions
  case "${COMP_WORDS[1]}" in
  a | attach)
    # Attach completes with existing sessions
    if [ $COMP_CWORD -eq 2 ]; then
      local sessions="$(__sn_sessions)"
      COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
    fi
    return 0
    ;;
  ls | list)
    # No additional completions
    return 0
    ;;
  kill)
    if [ $COMP_CWORD -eq 2 ]; then
      local sessions="$(__sn_sessions)"
      COMPREPLY=($(compgen -W "${sessions} all" -- "${cur}"))
    fi
    return 0
    ;;
  d | detach)
    if [ $COMP_CWORD -eq 2 ]; then
      local sessions="$(__sn_sessions)"
      COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
    fi
    return 0
    ;;
  edit)
    if [ $COMP_CWORD -eq 2 ]; then
      local sessions="$(__sn_sessions)"
      COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
    fi
    return 0
    ;;
  switch | sw)
    if [ $COMP_CWORD -eq 2 ]; then
      local sessions="$(__sn_sessions)"
      COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
    fi
    return 0
    ;;
  rename | mv)
    if [ $COMP_CWORD -eq 2 ]; then
      local sessions="$(__sn_sessions)"
      COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
    fi
    return 0
    ;;
  clone | copy)
    if [ $COMP_CWORD -eq 2 ]; then
      local sessions="$(__sn_sessions)"
      COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
    fi
    return 0
    ;;
  status | info)
    # No additional completions
    return 0
    ;;
  show)
    # No additional completions
    return 0
    ;;
  create)
    # For create, first arg is name, then window:cmd pairs
    return 0
    ;;
  update)
    if [ $COMP_CWORD -eq 2 ]; then
      COMPREPLY=($(compgen -W "template sessions all" -- "${cur}"))
    fi
    return 0
    ;;
  --completions)
    if [ $COMP_CWORD -eq 2 ]; then
      COMPREPLY=($(compgen -W "long short list array" -- "${cur}"))
    fi
    return 0
    ;;
  --dir)
    # Complete with directories
    _filedir -d
    return 0
    ;;
  --name)
    # Complete with existing sessions
    local sessions="$(__sn_sessions)"
    COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
    return 0
    ;;
  --exec)
    if [ $COMP_CWORD -eq 2 ]; then
      COMPREPLY=($(compgen -W "git weather uptime keybindings" -- "${cur}"))
    fi
    return 0
    ;;
  --debug | --no-color | --silent | --force | --help | --version | --config | --reset | --options)
    # After standalone flags, complete with commands
    local sessions="$(__sn_sessions)"
    COMPREPLY=($(compgen -W "${ALL_COMMANDS} ${sessions}" -- "${cur}"))
    return 0
    ;;
  esac

  # First argument: subcommands, presets, and existing sessions
  if [ $COMP_CWORD -eq 1 ]; then
    local sessions="$(__sn_sessions)"
    COMPREPLY=($(compgen -W "${ALL_COMMANDS} ${sessions}" -- "${cur}") $(compgen -d -- "${cur}"))
    COMPREPLY=($(printf '%s\n' "${COMPREPLY[@]}" | sort -u))
  fi
} &&
  complete -F _screen-new screen-new

# ex: ts=2 sw=2 et filetype=sh
