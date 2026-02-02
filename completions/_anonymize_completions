#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  anonymize --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Thursday, Jul 21, 2022 10:57 EDT
# @@File             :  anonymize
# @@Description      :  Anonymous web access
# @@Changelog        :  Added completions for all new commands
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
_anonymize_completion() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CONFDIR="$HOME/.config/myscripts/anonymize"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/anonymize}"
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local CONFFILE="settings.conf"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  #local SEARCHCMD="$(___findcmd "$SEARCHDIR/" "d" "1" | sort -u)"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local LONGOPTS="--completions --config --debug --dir --help --options --raw --version --silent --download --console --profile"
  local SHORTOPTS=""
  local ARRAY="init wireguard i2p freenet tor proxy zerotier status stop restart check-ip check-dns vpn lokinet harden killswitch mac profile monitor speedtest versions"

  _init_completion || return

  if [ "$SHOW_COMP_OPTS" != "" ]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
  elif [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS:---}' -- ${cur})) && compopt -o nospace
  else
    case "${COMP_WORDS[1]:-$prev}" in
    --debug | --raw | --help | --version | --config | --options)
      COMPREPLY=($(compgen -W '${ARRAY} ${LONGOPTS} ${SHORTOPTS}' -- ${cur}))
      return 0
      ;;
    --freenet | --i2p | --download | --console)
      COMPREPLY=($(compgen -W '' -- "$cur"))
      ;;
    init | i2p | freenet | tor | zerotier | lokinet)
      COMPREPLY=($(compgen -W '' -- "$cur"))
      ;;
    status)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W 'tor i2p freenet zerotier vpn all' -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    stop)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W 'tor i2p freenet zerotier all' -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    restart)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W 'tor i2p freenet zerotier' -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    check-ip | check-dns | monitor | speedtest)
      COMPREPLY=($(compgen -W '' -- "$cur"))
      ;;
    vpn)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W 'list connect disconnect status' -- "$cur"))
      elif [[ $cword -eq 3 ]] && [[ "${COMP_WORDS[2]}" == "connect" ]]; then
        # List available VPN connections
        local vpns=$(nmcli connection show 2>/dev/null | grep -E 'vpn|wireguard' | awk '{print $1}')
        COMPREPLY=($(compgen -W "$vpns" -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    harden)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W 'firefox chrome chromium' -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    killswitch)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W 'enable disable' -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    mac)
      if [[ $cword -eq 2 ]]; then
        # List network interfaces
        local interfaces=$(ip link show 2>/dev/null | grep -E '^[0-9]+:' | cut -d: -f2 | tr -d ' ' | grep -v lo)
        COMPREPLY=($(compgen -W "$interfaces" -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    profile)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W 'save load list delete' -- "$cur"))
      elif [[ $cword -eq 3 ]]; then
        local profiles=$(ls -1 "$HOME/.config/myscripts/anonymize/profiles" 2>/dev/null)
        COMPREPLY=($(compgen -W "$profiles" -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    versions)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W 'check update' -- "$cur"))
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    wireguard)
      [ $cword -eq 2 ] && _filedir || COMPREPLY=($(compgen -W '' -- "$cur"))
      ;;
    proxy)
      if [[ $cword -eq 2 ]]; then
        COMPREPLY=($(compgen -W '$(echo {0..9})' -- "$cur"))
      elif [[ $cword -eq 3 ]]; then
        COMPREPLY=($(compgen -c -- "${cur}"))
      elif [[ $cword -eq 4 ]]; then
        COMPREPLY=($(compgen -W 'https:// http://' -- "${cur}")) && compopt -o nospace
      else
        COMPREPLY=($(compgen -W '' -- "$cur"))
      fi
      ;;
    *)
      COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur")) && compopt -o nospace
      return 0
      ;;
    esac
  fi
  #
  # if [[ -n "$FILEDIR" ]]; then _filedir; fi
  # if [[ $cword -gt 2 ]]; then
  #   return
  # elif [[ $cword == 2 ]]; then
  #   _filedir
  #   compopt -o nospace
  #   return
  # elif [[ $cword -eq 1 ]]; then
  #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
  #   compopt -o nospace
  #   return
  # if [[ "$ARRAY" = "show__none" ]]; then
  #   COMPREPLY=($(compgen -W '' -- "${cur}"))
  # elif [[ "$ARRAY" = "show__filedir" ]]; then
  #   _filedir
  # elif [[ "$ARRAY" = "show__commands" ]]; then
  #   COMPREPLY=($(compgen -c -- "${cur}"))
  # elif [ "$ARRAY" != "" ]; then
  #   COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
  # elif [ -n "$OPTS" ]; then
  #   COMPREPLY=($(compgen -W '${OPTS}' -- "${cur}"))
  # else
  #   COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
  # elif [[ $cword -gt 2 ]]; then
  #   return
  # elif [[ $cword == 2 ]]; then
  #   _filedir
  #   compopt -o nospace
  #   return
  # elif [[ $cword -eq 1 ]]; then
  #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
  #   compopt -o nospace
  #   return
  # fi
  # [[ ${cword} == 2 ]] && _filedir && compopt -o nospace
  # [[ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
  # [[ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
  # [[ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  # prev=""
  # compopt -o nospace
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _anonymize_completion anonymize
