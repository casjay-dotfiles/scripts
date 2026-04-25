#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  virtmgr --help
# @Copyright         :  Copyright: (c) 2025 Jason Hempstead, Casjays Developments
# @Created           :  Monday, Sep 16, 2025 00:35 EDT
# @File              :  virtmgr
# @Description       :  Comprehensive virtualization management tool
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_virtmgr() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  ___get_vms() { sudo virsh list --all --name 2>/dev/null | grep -v '^$' || return 1; }
  ___get_running_vms() { sudo virsh list --name 2>/dev/null | grep -v '^$' || return 1; }
  ___get_containers() { incus list --format csv 2>/dev/null | cut -d',' -f1 || return 1; }
  
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/virtmgr"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/virtmgr}"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local OPTS=""
  local LONGOPTS="--completions --options --config --version --help --dir --cpu --memory --disk --arch --uefi --force --debug --raw --silent"
  local SHORTOPTS=""
  local ARRAY="status setup init list start restore create new delete ip ssh open manage incus"

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

    --help | --version)
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --dir)
      _filedir
      return
      ;;

    --cpu)
      COMPREPLY=($(compgen -W 'host-passthrough host-model qemu64 kvm64' -- "${cur}"))
      ;;

    --arch)
      COMPREPLY=($(compgen -W 'x86_64 aarch64 arm' -- "${cur}"))
      ;;

    --memory)
      COMPREPLY=($(compgen -W '1024 2048 4096 8192 16384' -- "${cur}"))
      ;;

    --disk)
      COMPREPLY=($(compgen -W '20 50 100 200 500' -- "${cur}"))
      ;;

    # Commands that need VM names
    start | delete | open | create | restore | ip | ssh)
      COMPREPLY=($(compgen -W "$(___get_vms 2>/dev/null)" -- "${cur}"))
      ;;

    # Commands that need running VM names
    ssh)
      COMPREPLY=($(compgen -W "$(___get_running_vms 2>/dev/null)" -- "${cur}"))
      ;;

    # File completion for ISO files
    new)
      case $COMP_CWORD in
      2) 
        # VM name - no completion
        COMPREPLY=()
        ;;
      3)
        # ISO file
        _filedir '@(iso|ISO)'
        ;;
      4)
        # Disk size
        COMPREPLY=($(compgen -W '20 50 100 200 500' -- "${cur}"))
        ;;
      5)
        # RAM size
        COMPREPLY=($(compgen -W '1024 2048 4096 8192' -- "${cur}"))
        ;;
      esac
      ;;

    # Commands with no arguments
    list | init | setup | status | manage | incus)
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    *)
      if [[ -n "$FILEDIR" ]]; then _filedir; fi
      if [[ "$ARRAY" = "show__none" ]]; then
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      elif [[ "$ARRAY" = "show__filedir" ]]; then
        _filedir
      elif [[ "$ARRAY" = "show__commands" ]]; then
        COMPREPLY=($(compgen -c -- "${cur}"))
      elif [ "$ARRAY" != "" ]; then
        COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      elif [ -n "$OPTS" ]; then
        COMPREPLY=($(compgen -W '${OPTS}' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      fi
      ;;
    esac
  fi
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _virtmgr virtmgr