#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071022-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  x_server.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 10:22 EDT
# @File              :  x_server.bash
# @Description       :  functions if user has display
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__yad__text() {
  set -o pipefail
  local title="$1"
  local color="$2"
  if __cmd_exists yad; then
    cat - | yad --text-info --center --title="$title" --width=${YAD_WIDTH:-500} --height=${YAD_HEIGHT:-400} 2>/dev/null &
    return $?
  elif __cmd_exists zenity; then
    cat - | zenity --text-info --title="$title" --width=${YAD_WIDTH:-500} --height=${YAD_HEIGHT:-400} 2>/dev/null &
    return $?
  else
    cat - | printf_readline $color
    return $?
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__yad__list() {
  local title="$1"
  if __cmd_exists yad; then
    cat - | yad --list --center --title="$title" --width=${YAD_WIDTH:-500} --height=${YAD_HEIGHT:-400} --column=${2:-Results} 2>/dev/null &
  elif __cmd_exists zenity; then
    cat - | zenity --list --center --title="$title" --width=${YAD_WIDTH:-500} --height=${YAD_HEIGHT:-400} --column=${2:-Results} 2>/dev/null &
  else
    cat - | printf_readline $color
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__pkmgr_gui() {
  { pkmgr silent install "$1" && return 0 || return 1; } |
    zenity --width=400 --progress --no-cancel --pulsate --text "Installing packages $prog" --auto-close
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
