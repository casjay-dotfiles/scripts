#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202610061700-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  herdr-new --help
# @Copyright         :  Copyright: (c) 2026 Jason Hempstead, Casjays Developments
# @Created           :  Monday, Oct 06, 2026 17:00 EDT
# @File              :  herdr-new
# @Description       :  bash completion for herdr-new
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -
_herdr_new() {
  local cur prev
  cur="${COMP_WORDS[$COMP_CWORD]}"
  prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local LONGOPTS="--help --version --debug --no-color --name --exec"
  local PRESETS="single shell ai dev go rust python node bun deno devops monitoring database build test default"
  local COMMANDS="list show attach status kill config"
  local KILLTYPES="all workspace tab pane"
  local CONFIGOPTS="check create edit reload reset-keys"
  local EXECOPTS="git uptime weather keybindings"
  case "$prev" in
  --name) return 0 ;;
  --exec) COMPREPLY=($(compgen -W "$EXECOPTS" -- "$cur")) ;;
  kill) COMPREPLY=($(compgen -W "$KILLTYPES $(herdr-session-names)" -- "$cur")) ;;
  config) COMPREPLY=($(compgen -W "$CONFIGOPTS" -- "$cur")) ;;
  attach) COMPREPLY=($(compgen -W "$(herdr-session-names)" -- "$cur")) ;;
  *)
    if [[ "$cur" == -* ]]; then
      COMPREPLY=($(compgen -W "$LONGOPTS" -- "$cur"))
    else
      COMPREPLY=($(compgen -W "$PRESETS $COMMANDS" -- "$cur"))
    fi
    ;;
  esac
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
herdr-session-names() { herdr session list --json 2>/dev/null | jq -r '.sessions[].name' 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# enable completions
complete -F _herdr_new herdr-new
