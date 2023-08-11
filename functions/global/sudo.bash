#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070947-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  sudo.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:47 EDT
# @File              :  sudo.bash
# @Description       :  sudo functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup sudo and user
# if [ -n "$DISPLAY" ] && builtin type -P  ask_for_password &>/dev/null; then
#   unalias sudo &>/dev/null
#   unset -f sudo &>/dev/null
#   sudo() { builtin command sudo -A $*; }
# else
#   export SUDO_ASKPASS="${SUDO_ASKPASS:-}"
#   export SUDO_PROMPT="$(printf "\n\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m" && echo)"
# fi
WHOAMI="${USER}"
[ -n "$SUDO_USER" ] && RUN_USER=${RUN_USER:-$SUDO_USER} || RUN_USER=${RUN_USER:-$WHOAMI}
export RUN_USER="${RUN_USER:-$USER}"
export USER="${SUDO_USER:-$USER}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudo() { \sudo -HE "$@"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudorun() { sudoif && sudo "$@" || eval "$@"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudo_group() { grep "${1:-$USER}" /etc/group | grep -Eq 'wheel|adm|sudo' || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudo_group "$USER" && __passwd() { sudo passwd "$*"; } || __passwd() { passwd "$*"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudoif() { (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__can_i_sudo() { __sudo_group "${1:-$USER}" || sudoif || sudo -n true &>/dev/null || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudorerun() {
  local CMD="${1:-$APPNAME}" && shift 1
  local ARGS="${*:-$ARGS}" && shift $#
  if [[ $UID != 0 ]]; then
    if sudoif; then
      sudo -HE "$CMD" "$ARGS"
      exit $?
    else
      sudoreq "$CMD" "$ARGS"
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudoreq() {
  sudo_check=$(sudo -H -S -- echo SUDO_OK 2>&1 &)
  [ $sudo_check == "SUDO_OK" ] && return
  if [ $UID != 0 ]; then
    if builtin type -P ask_for_password &>/dev/null; then
      [ "$SUDO_SUCCESS" = "TRUE" ] || ask_for_password "${@:-true}" && export SUDO_SUCCESS="TRUE" || printf_exit "Please run this script with sudo/root\n"
      sudorun "$@"
      exit $?
    else
      printf_newline
      printf_error "Please run this script with sudo/root\n"
      exit 1
    fi
  else
    return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudoask() {
  if [ ! -f "$HOME/.sudo" ]; then
    sudo true &>/dev/null && return 0 || return 1
    while true; do
      echo "$$" >"$HOME/.sudo"
      sudo -n true
      sleep 10
      rm -Rf "$HOME/.sudo"
      kill -0 "$$" || return
    done &>/dev/null &
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudoexit() {
  if __can_i_sudo; then
    __sudoask || { printf_green "Getting privileges successful continuing" && true; }
  else
    printf_red "Failed to get privileges\n" && false || return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__requiresudo() {
  __can_i_sudo && __sudoask && __sudoexit && return 0 ||
    { printf_red "You dont have access to sudo\nPlease contact the syadmin for access" && return 1; }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
