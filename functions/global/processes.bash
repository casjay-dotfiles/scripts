#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071046-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  processes.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 10:46 EDT
# @File              :  processes.bash
# @Description       :  Processes check
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__get_status_pid() {
  __ps "$1" | grep -v grep | grep -q "$1" 2>/dev/null && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__get_pid_of() {
  __ps "$1" | head -n1 | awk '{print $2}' | grep '^' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__ps() {
  local proc="$(__basename "$1")"
  local prog="${APPNAME:-$PROG}"
  [ -n "$proc" ] || return 1
  ps -aux | grep -v 'grep ' | grep -E '\?' | grep -w "$proc" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#kill "app"
__kill() {
  kill -s KILL "$(pidof "$1" 2>/dev/null)" >/dev/null 2>&1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#running "app"
__running() {
  pidof "$1" &>/dev/null && return 1 || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#start "app"
__start() {
  sleep 1 && "$@" 2>/dev/null &
  disown
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
