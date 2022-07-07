#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070947-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.com
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
#   export SUDO_PROMPT="$(printf "\n\t\t\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m" && echo)"
# fi
if [ -n "$SUDO_USER" ]; then
  RUN_USER=${RUN_USER:-$SUDO_USER}
else
  RUN_USER=${RUN_USER:-$(whoami)}
fi
WHOAMI="${USER}"
export RUN_USER="${RUN_USER:-$USER}"
export USER="${SUDO_USER:-$USER}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudo() {
  PATH=$PATH builtin command sudo "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudo() {
  PATH=$PATH builtin command sudo "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudorun() {
  if sudoif; then
    sudo "$@"
  else "$@"; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudo() {
  $(builtin type -P sudo) --preserve-env=PATH -HE "$@" ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudo_group() {
  grep "${1:-$USER}" /etc/group |
    grep -Eq 'wheel|adm|sudo' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudoif() {
  (sudo -vn && sudo -ln) 2>&1 |
    grep -v 'may not' >/dev/null &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__can_i_sudo() {
  __sudo_group "${1:-$USER}" ||
    sudoif || sudo -n true &>/dev/null ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudorerun() {
  local CMD="${1:-$APPNAME}" && shift 1
  local ARGS="${*:-$ARGS}" && shift $#
  if [[ $UID != 0 ]]; then
    if sudoif; then
      sudo "$CMD" "$ARGS"
      if [[ $? -ne 0 ]]; then
        return 1
      fi
    else
      sudoreq
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudoreq() {
  sudo_check=$(sudo -H -S -- echo SUDO_OK 2>&1 &)
  [[ $sudo_check == "SUDO_OK" ]] && return
  if [[ $UID != 0 ]]; then
    if builtin type -P ask_for_password &>/dev/null; then
      [[ "$SUDO_SUCCESS" = "TRUE" ]] || ask_for_password ${*:-true}
      export SUDO_SUCCESS="TRUE"
      return 0
    else
      printf_newline
      printf_error "Please run this script with sudo/root\n"
      exit 1
    fi
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
    __sudoask || printf_green "Getting privileges successful continuing" && true
  else
    printf_red "Failed to get privileges\n" && false
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__requiresudo() {
  if __can_i_sudo; then
    __sudoask && __sudoexit && __sudo "$@" 2>/dev/null
  else
    printf_red "You dont have access to sudo\n\t\tPlease contact the syadmin for access"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if __sudo_group "$USER"; then
  __passwd() { sudo passwd "$*"; }
else
  __passwd() { passwd "$*"; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
