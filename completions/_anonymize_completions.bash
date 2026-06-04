#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202606040809-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  anonymize --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Thursday, Jul 21, 2022 10:57 EDT
# @@File             :  anonymize
# @@Description      :  Anonymous web access and privacy tool management
# - - - - - - - - - - - - - - - - - - - - - - - - -
_anonymize_completion() {
  local CONFDIR="$HOME/.config/myscripts/anonymize"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local LONGOPTS="--completions --config --console --debug --dir --download --help --no-color --options --silent --version"
  local SHORTOPTS=""
  local ARRAY="init servers tor i2p freenet lokinet zerotier wireguard proxy vpn status stop restart check-ip check-dns harden killswitch mac profile monitor speedtest versions"

  _init_completion || return

  if [ "$SHOW_COMP_OPTS" != "" ]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    return
  elif [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS:---}' -- ${cur})) && compopt -o nospace
    return
  fi

  case "${COMP_WORDS[1]:-$prev}" in
  --debug | --no-color | --help | --version | --config | --options | --silent | --console | --download)
    COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
    return 0
    ;;

  init | check-ip | check-dns | monitor | speedtest | zerotier)
    COMPREPLY=($(compgen -W '' -- "${cur}"))
    ;;

  servers)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'tor i2p freenet lokinet' -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  tor | i2p | freenet | lokinet)
    COMPREPLY=($(compgen -W '' -- "${cur}"))
    ;;

  status)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'tor i2p freenet zerotier vpn all' -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  stop)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'tor i2p freenet zerotier lokinet all' -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  restart)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'tor i2p freenet zerotier lokinet' -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  vpn)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'list connect disconnect status' -- "${cur}"))
    elif [[ $COMP_CWORD -eq 3 ]] && [[ "${COMP_WORDS[2]}" == "connect" ]]; then
      local vpns
      vpns=$(nmcli connection show 2>/dev/null | grep -E 'vpn|wireguard' | awk '{print $1}')
      COMPREPLY=($(compgen -W "$vpns" -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  wireguard)
    [[ $COMP_CWORD -eq 2 ]] && _filedir || COMPREPLY=($(compgen -W '' -- "${cur}"))
    ;;

  proxy)
    case $COMP_CWORD in
    2) COMPREPLY=($(compgen -W '$(echo {1024..9999})' -- "${cur}")) ;;
    3) COMPREPLY=($(compgen -c -- "${cur}")) ;;
    4) COMPREPLY=($(compgen -W 'https:// http://' -- "${cur}")) && compopt -o nospace ;;
    *) COMPREPLY=($(compgen -W '' -- "${cur}")) ;;
    esac
    ;;

  harden)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'firefox chrome chromium' -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  killswitch)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'enable disable' -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  mac)
    if [[ $COMP_CWORD -eq 2 ]]; then
      local interfaces
      interfaces=$(ip link show 2>/dev/null | grep -E '^[0-9]+:' | cut -d: -f2 | tr -d ' ' | grep -v lo)
      COMPREPLY=($(compgen -W "$interfaces" -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  profile)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'save load list delete' -- "${cur}"))
    elif [[ $COMP_CWORD -eq 3 ]]; then
      local profiles
      profiles=$(ls -1 "$CONFDIR/profiles" 2>/dev/null)
      COMPREPLY=($(compgen -W "$profiles" -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  versions)
    if [[ $COMP_CWORD -eq 2 ]]; then
      COMPREPLY=($(compgen -W 'check update' -- "${cur}"))
    else
      COMPREPLY=($(compgen -W '' -- "${cur}"))
    fi
    ;;

  *)
    COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
    return 0
    ;;
  esac

  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _anonymize_completion anonymize
