#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602200031-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  incusmgr --help
# @Copyright         :  Copyright: (c) 2025 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Feb 20, 2025 00:31 EST
# @File              :  incusmgr
# @Description       :  Comprehensive Incus container and VM management tool
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_incusmgr() {
  ___incus_instances() { incus list -c n -f csv 2>/dev/null | grep '^'; }
  ___incus_running() { incus list -c ns -f csv 2>/dev/null | grep ',RUNNING$' | cut -d',' -f1; }
  ___incus_stopped() { incus list -c ns -f csv 2>/dev/null | grep ',STOPPED$' | cut -d',' -f1; }
  ___incus_images() { incus image list -c l -f csv 2>/dev/null | grep '^'; }
  ___incus_networks() { incus network list -c n -f csv 2>/dev/null | grep '^'; }
  ___incus_profiles() { incus profile list -c n -f csv 2>/dev/null | grep '^'; }
  ___incus_storage() { incus storage list -c n -f csv 2>/dev/null | grep '^'; }
  ___incus_remotes() { incus remote list 2>/dev/null | awk 'NR>3 && NF>0 && !/^\+/ {print $2}' | grep '^'; }
  ___incus_snapshots() { [ -n "$1" ] && incus info "$1" 2>/dev/null | awk '/Snapshots:/,0' | grep -E '^\s+' | awk '{print $1}' | grep '^'; }
  
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/incusmgr"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/incusmgr}"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local OPTS=""
  local SHORTOPTS="-f"
  local LONGOPTS="--completions --debug --raw --options --config --version --help --force"
  local ARRAY="init status version list ls info launch run start stop restart delete rm exec enter shell rename snapshot restore "
  local ARRAY+="storage network profile image remote prune "

  _init_completion || return

  local special i
  for ((i = 1; i < ${#words[@]} - 1; i++)); do
    if [[ ${words[i]} == @(storage|network|profile|image|remote|prune) ]]; then
      special=${words[i]}
      break
    fi
  done

  if [[ -v special ]]; then
    [[ $cur == @(*/|[.~])* && $special == @(storage|network|profile|image|remote|prune) ]]
  fi

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
      local prev="--help"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --version)
      local prev="--version"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    init | status | version)
      local prev="endopts"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    list | ls)
      if [[ ${#COMP_WORDS[*]} -gt 2 ]]; then
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      fi
      ;;

    info)
      if [[ ${#COMP_WORDS[*]} -gt 3 ]]; then
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '$(___incus_instances)' -- "${cur}"))
      fi
      ;;

    launch | run)
      case $COMP_CWORD in
      2)
        COMPREPLY=($(compgen -W 'ubuntu: ubuntu-daily: images: local:' -- "${cur}"))
        compopt -o nospace
        ;;
      3)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      *)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      esac
      ;;

    start)
      COMPREPLY=($(compgen -W '$(___incus_stopped)' -- "${cur}"))
      ;;

    stop | restart)
      COMPREPLY=($(compgen -W '$(___incus_running)' -- "${cur}"))
      ;;

    delete | rm)
      if [[ ${#COMP_WORDS[*]} -gt 3 ]]; then
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '$(___incus_instances)' -- "${cur}"))
      fi
      ;;

    exec)
      case $COMP_CWORD in
      2)
        COMPREPLY=($(compgen -W '$(___incus_running)' -- "${cur}"))
        ;;
      *)
        COMPREPLY=($(compgen -c -- "${cur}"))
        ;;
      esac
      ;;

    enter | shell)
      if [[ ${#COMP_WORDS[*]} -gt 3 ]]; then
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '$(___incus_instances)' -- "${cur}"))
      fi
      ;;

    rename)
      case $COMP_CWORD in
      2)
        COMPREPLY=($(compgen -W '$(___incus_instances)' -- "${cur}"))
        ;;
      3)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      *)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      esac
      ;;

    snapshot)
      case $COMP_CWORD in
      2)
        COMPREPLY=($(compgen -W '$(___incus_instances)' -- "${cur}"))
        ;;
      3)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      *)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      esac
      ;;

    restore)
      case $COMP_CWORD in
      2)
        COMPREPLY=($(compgen -W '$(___incus_instances)' -- "${cur}"))
        ;;
      3)
        local instance="${COMP_WORDS[2]}"
        COMPREPLY=($(compgen -W '$(___incus_snapshots "$instance")' -- "${cur}"))
        ;;
      *)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      esac
      ;;

    storage)
      case "$prev" in
      storage)
        COMPREPLY=($(compgen -W 'list ls create delete rm show info' -- "${cur}"))
        ;;
      list | ls)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      create)
        if [[ ${#COMP_WORDS[*]} -gt 4 ]]; then
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        else
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        fi
        ;;
      delete | rm | show | info)
        if [[ ${#COMP_WORDS[*]} -gt 4 ]]; then
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        else
          COMPREPLY=($(compgen -W '$(___incus_storage)' -- "${cur}"))
        fi
        ;;
      *)
        COMPREPLY=($(compgen -W 'list ls create delete rm show info' -- "${cur}"))
        ;;
      esac
      ;;

    network)
      case "$prev" in
      network)
        COMPREPLY=($(compgen -W 'list ls create delete rm show info' -- "${cur}"))
        ;;
      list | ls)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      create)
        if [[ ${#COMP_WORDS[*]} -gt 4 ]]; then
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        else
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        fi
        ;;
      delete | rm | show | info)
        if [[ ${#COMP_WORDS[*]} -gt 4 ]]; then
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        else
          COMPREPLY=($(compgen -W '$(___incus_networks)' -- "${cur}"))
        fi
        ;;
      *)
        COMPREPLY=($(compgen -W 'list ls create delete rm show info' -- "${cur}"))
        ;;
      esac
      ;;

    profile)
      case "$prev" in
      profile)
        COMPREPLY=($(compgen -W 'list ls show info create delete rm' -- "${cur}"))
        ;;
      list | ls)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      create)
        if [[ ${#COMP_WORDS[*]} -gt 4 ]]; then
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        else
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        fi
        ;;
      show | info | delete | rm)
        if [[ ${#COMP_WORDS[*]} -gt 4 ]]; then
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        else
          COMPREPLY=($(compgen -W '$(___incus_profiles)' -- "${cur}"))
        fi
        ;;
      *)
        COMPREPLY=($(compgen -W 'list ls show info create delete rm' -- "${cur}"))
        ;;
      esac
      ;;

    image)
      case "$prev" in
      image)
        COMPREPLY=($(compgen -W 'list ls info show delete rm copy cp' -- "${cur}"))
        ;;
      list | ls)
        COMPREPLY=($(compgen -W 'ubuntu: ubuntu-daily: images: local:' -- "${cur}"))
        compopt -o nospace
        ;;
      info | show | delete | rm)
        if [[ ${#COMP_WORDS[*]} -gt 4 ]]; then
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        else
          COMPREPLY=($(compgen -W '$(___incus_images)' -- "${cur}"))
        fi
        ;;
      copy | cp)
        case $COMP_CWORD in
        3 | 4)
          COMPREPLY=($(compgen -W '$(___incus_images)' -- "${cur}"))
          ;;
        *)
          COMPREPLY=($(compgen -W '' -- "${cur}"))
          ;;
        esac
        ;;
      *)
        COMPREPLY=($(compgen -W 'list ls info show delete rm copy cp' -- "${cur}"))
        ;;
      esac
      ;;

    remote)
      case "$prev" in
      remote)
        COMPREPLY=($(compgen -W 'list ls add remove rm' -- "${cur}"))
        ;;
      list | ls)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      add)
        case $COMP_CWORD in
        3)
          COMPREPLY=($(compgen -W '' -- "${cur}"))
          ;;
        4)
          COMPREPLY=($(compgen -W 'https://' -- "${cur}"))
          compopt -o nospace
          ;;
        *)
          COMPREPLY=($(compgen -W '' -- "${cur}"))
          ;;
        esac
        ;;
      remove | rm)
        if [[ ${#COMP_WORDS[*]} -gt 4 ]]; then
          COMPREPLY=($(compgen -W '' -- "${cur}"))
        else
          COMPREPLY=($(compgen -W '$(___incus_remotes)' -- "${cur}"))
        fi
        ;;
      *)
        COMPREPLY=($(compgen -W 'list ls add remove rm' -- "${cur}"))
        ;;
      esac
      ;;

    prune)
      case "$prev" in
      prune)
        COMPREPLY=($(compgen -W 'instances containers volumes storage images all' -- "${cur}"))
        ;;
      *)
        COMPREPLY=($(compgen -W '' -- "${cur}"))
        ;;
      esac
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
      elif [[ -n "$ARRAY" ]]; then
        [ $COMP_CWORD -lt 2 ] &&
          COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      elif [[ -n "$OPTS" ]]; then
        [ $COMP_CWORD -gt 2 ] &&
          COMPREPLY=($(compgen -W '' -- "${cur}"))
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
  complete -F _incusmgr incusmgr
