#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  LICENSE.md
# @ReadME            :  usb-writer --help
# @Copyright         :  Copyright: (c) 2025 Jason Hempstead, Casjays Developments
# @Created           :  Wednesday, Oct 2, 2025 03:19 EDT
# @File              :  usb-writer
# @Description       :  Tab completion for multi-boot USB creator
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_usb-writer() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/usb-writer"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/usb-writer}"
  local SHOW_COMP_OPTS=""
  local OPTS=""
  local LONGOPTS="--completions --config --debug --dir --help --options --raw --version --silent --label --no-verify"
  local SHORTOPTS=""
  local ARRAY=""
  local COMMANDS="create mount unmount iso"
  local ISO_SUBCOMMANDS="add remove list menu write"
  local CATEGORIES="linux windows bsd utilities tools"

  # Initialize completion (compatible with or without bash-completion)
  if declare -F _init_completion >/dev/null 2>&1; then
    _init_completion || return
  fi

  if [[ "$SHOW_COMP_OPTS" != "" ]]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP 2>/dev/null || true
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
      prev="--help"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --version)
      local prev="--version"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --dir)
      _filedir -d
      ;;

    --label)
      # Label name - no completion
      ;;

    --silent | --no-verify)
      # No additional arguments
      ;;

    create | create-multiboot | mount | unmount)
      # Device argument
      local devices="$(find /dev -maxdepth 1 -name 'sd[a-z]' -o -name 'hd[a-z]' -o -name 'vd[a-z]' -o -name 'nvme[0-9]n[0-9]' 2>/dev/null | sed 's|/dev/||g')"
      COMPREPLY=($(compgen -W "$devices" -- "${cur}"))
      ;;

    iso)
      # ISO subcommands
      case "${COMP_WORDS[2]}" in
        add | add-iso)
          case $COMP_CWORD in
            3)
              # ISO file
              compopt -o filenames -o nospace 2>/dev/null || true
              COMPREPLY=($(compgen -f -X '!*.iso' -- "${cur}"))
              COMPREPLY+=($(compgen -d -- "${cur}"))
              [[ ${#COMPREPLY[@]} -eq 0 ]] && COMPREPLY=($(compgen -f -d -- "${cur}"))
              ;;
            4)
              # Category
              COMPREPLY=($(compgen -W "$CATEGORIES" -- "${cur}"))
              ;;
            5)
              # Optional device
              local devices="$(find /dev -maxdepth 1 -name 'sd[a-z]' -o -name 'hd[a-z]' -o -name 'vd[a-z]' -o -name 'nvme[0-9]n[0-9]' 2>/dev/null | sed 's|/dev/||g')"
              COMPREPLY=($(compgen -W "$devices" -- "${cur}"))
              ;;
          esac
          ;;
        remove | remove-iso)
          case $COMP_CWORD in
            3)
              # ISO name - try to list mounted ISOs
              local USB_WRITER_MOUNT="/mnt/usb-multiboot"
              if [ -d "$USB_WRITER_MOUNT/ISOs" ]; then
                local isos="$(find "$USB_WRITER_MOUNT/ISOs" -name '*.iso' -exec basename {} \; 2>/dev/null)"
                COMPREPLY=($(compgen -W "$isos" -- "${cur}"))
              fi
              ;;
            4)
              # Optional device
              local devices="$(find /dev -maxdepth 1 -name 'sd[a-z]' -o -name 'hd[a-z]' -o -name 'vd[a-z]' -o -name 'nvme[0-9]n[0-9]' 2>/dev/null | sed 's|/dev/||g')"
              COMPREPLY=($(compgen -W "$devices" -- "${cur}"))
              ;;
          esac
          ;;
        list | list-isos | menu | update-menu)
          # Optional device
          local devices="$(find /dev -maxdepth 1 -name 'sd[a-z]' -o -name 'hd[a-z]' -o -name 'vd[a-z]' -o -name 'nvme[0-9]n[0-9]' 2>/dev/null | sed 's|/dev/||g')"
          COMPREPLY=($(compgen -W "$devices" -- "${cur}"))
          ;;
        write | write-iso)
          case $COMP_CWORD in
            3)
              # ISO file
              compopt -o filenames -o nospace 2>/dev/null || true
              COMPREPLY=($(compgen -f -X '!*.iso' -- "${cur}"))
              COMPREPLY+=($(compgen -d -- "${cur}"))
              [[ ${#COMPREPLY[@]} -eq 0 ]] && COMPREPLY=($(compgen -f -d -- "${cur}"))
              ;;
            4)
              # Device
              local devices="$(find /dev -maxdepth 1 -name 'sd[a-z]' -o -name 'hd[a-z]' -o -name 'vd[a-z]' -o -name 'nvme[0-9]n[0-9]' 2>/dev/null | sed 's|/dev/||g')"
              COMPREPLY=($(compgen -W "$devices" -- "${cur}"))
              ;;
          esac
          ;;
        *)
          # Show iso subcommands
          if [ $COMP_CWORD -eq 2 ]; then
            COMPREPLY=($(compgen -W "$ISO_SUBCOMMANDS" -- "${cur}"))
          fi
          ;;
      esac
      ;;

    *)
      case $COMP_CWORD in
        1)
          # Commands or flags
          COMPREPLY=($(compgen -W '${COMMANDS} ${LONGOPTS}' -- "${cur}"))
          ;;
        *)
          # Default file completion
          compopt -o filenames -o nospace 2>/dev/null || true
          COMPREPLY=($(compgen -f -d -- "${cur}"))
          ;;
      esac
      ;;
    esac
  fi
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _usb-writer usb-writer
