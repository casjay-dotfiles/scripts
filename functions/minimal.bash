#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070941-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  colors.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:41 EDT
# @File              :  colors.bash
# @Description       :  colorize functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
USER="${SUDO_USER:-$USER}"
RUN_USER="${RUN_USER:-$USER}"
USER_HOME="${USER_HOME:-$HOME}"
SRC_DIR="${BASH_SOURCE%/*}"
CASJAYSDEV_USERDIR="${CASJAYSDEV_USERDIR:-$HOME/.local/share/CasjaysDev}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
RUN_USER="$(logname 2>/dev/null)"
SUDO_USER="${RUN_USER:-$SUDO_USER}"
export RUN_USER SUDO_USER
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set Main Repo for dotfiles
GIT_REPO_BRANCH="${GIT_DEFAULT_BRANCH:-main}"
DOTFILESREPO="https://github.com/dfmgr"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set other Repos
DFMGRREPO="https://github.com/dfmgr"
DESKTOPGRREPO="https://github.com/desktopmgr"
PKMGRREPO="https://github.com/pkmgr"
DEVENVMGRREPO="https://github.com/devenvmgr"
DOCKERMGRREPO="https://github.com/dockermgr"
ICONMGRREPO="https://github.com/iconmgr"
FONTMGRREPO="https://github.com/fontmgr"
THEMEMGRREPO="https://github.com/thememgr"
SYSTEMMGRREPO="https://github.com/systemmgr"
WALLPAPERMGRREPO="https://github.com/wallpapermgr"
WHICH_LICENSE_URL="https://github.com/devenvmgr/licenses/raw/$GIT_REPO_BRANCH"
WHICH_LICENSE_DEF="$CASJAYSDEVDIR/templates/wtfpl.md"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup temp folders
TMP="${TMP:-$HOME/.local/tmp}"
TEMP="${TMP:-$HOME/.local/tmp}"
TMPDIR="${TMP:-$HOME/.local/tmp}"
mkdir -p "$TMPDIR" "$TEMP" "$TMP" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup path
TMPPATH="/usr/local/opt/gnu-getopt/bin:"
TMPPATH+="$HOME/.local/share/bash/basher/cellar/bin:$HOME/.local/share/bash/basher/bin:"
TMPPATH+="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/gem/bin:/usr/local/bin:"
TMPPATH+="/usr/local/share/CasjaysDev/scripts/bin:/usr/local/sbin:/usr/sbin:"
TMPPATH+="/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH:."
PATH="$(echo "$TMPPATH" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:.#g')"
unset TMPPATH
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__which() { which "$1" 2>/dev/null; }
__type() { type -P "$1" 2>/dev/null; }
__command() { command -v "$1" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# OS Settings
__detect_os() {
  if [ -f "$CASJAYSDEVDIR/bin/detectostype" ] && [ -z "$DISTRO_NAME" ]; then
    . "$CASJAYSDEVDIR/bin/detectostype"
  fi
} && __detect_os
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
user_install() {
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    INSTALL_TYPE=user
    if [[ $(uname -s) =~ Darwin ]]; then
      HOME="/usr/local/home/root"
    fi
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="/usr/local/bin"
    SYSCONF="/usr/local/etc"
    SYSSHARE="/usr/local/share"
    SYSLOGDIR="/usr/local/log"
    BACKUPDIR="$HOME/.local/backups"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$SHARE/themes"
    ICONDIR="$SHARE/icons"
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="/Library/Fonts"; else FONTDIR="$SHARE/fonts"; fi
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="${WALLPAPERS:-$SYSSHARE/wallpapers}"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSTEMDDIR="/etc/systemd/system"
  else
    INSTALL_TYPE=user
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="$HOME/.local/bin"
    SYSCONF="$HOME/.config"
    SYSSHARE="$HOME/.local/share"
    SYSLOGDIR="$HOME/.local/log"
    BACKUPDIR="$HOME/.local/backups"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$SHARE/themes"
    ICONDIR="$SHARE/icons"
    if [[ $(uname -s) =~ Darwin ]]; then
      FONTDIR="$HOME/Library/Fonts"
    else
      FONTDIR="$SHARE/fonts"
    fi
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSTEMDDIR="$HOME/.config/systemd/user"
  fi

  APPDIR="${APPDIR:-$SHARE/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-}"
  REPORAW="${REPORAW:-}"

  installtype="user_install"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#setup colors
NC="$(tput sgr0 2>/dev/null)"
RESET="$(tput sgr0 2>/dev/null)"
BLACK="\033[0;30m"
RED="\033[1;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
ORANGE="\033[0;33m"
LIGHTRED='\033[1;31m'
BG_GREEN="\[$(tput setab 2 2>/dev/null)\]"
BG_RED="\[$(tput setab 9 2>/dev/null)\]"
ICON_INFO="[ ℹ️ ]"
ICON_GOOD="[ ✔ ]"
ICON_WARN="[ ❗ ]"
ICON_ERROR="[ ✖ ]"
ICON_QUESTION="[ ❓ ]"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# printf functions
__col() { awk -v col="$1" '{print $col}'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_newline() {
  [[ -n "$1" ]] && printf '%b\n' "${*:-}" || printf '\n'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$SHOW_RAW" = "true" ]; then
  unset -f printf_color
  printf_color() { printf '%b' "$1" | tr -d '\t'; }
  __printf_color() { printf_color "$1"; }
else
  __printf_color() { printf_color "$@"; }
  printf_color() {
    printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"
  }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_reset() {
  printf_color "\r$1 " ${2:-1}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_normal() {
  printf_color "$1" "$2"
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_green() {
  printf_color "$1" 2
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_red() {
  printf_color "$1" 9
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_purple() {
  printf_color "$1" 5
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_yellow() {
  printf_color "$1" 3
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_blue() {
  printf_color "$1" 33
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_cyan() {
  printf_color "$1" 6
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_info() {
  printf_color "$ICON_INFO $1" 3
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_success() {
  printf_color "$ICON_GOOD $1" 2
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_warning() {
  printf_color "$ICON_WARN $1" 3
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_error_stream() {
  while read -r line; do
    printf_error "↳ ERROR: $line"
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_execute_success() {
  printf_color "$ICON_GOOD $1" 2
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_execute_error() {
  printf_color "$ICON_WARN $1 $2" 9
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_execute_result() {
  if [[ "$1" = 0 ]]; then printf_execute_success "$2"; else printf_execute_error "${3:-$2}"; fi
  return "$1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_not_found() {
  if builtin type -P "$1" &>/dev/null; then
    printf_exit "The command $1 is not installed"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_execute_error_stream() {
  while read -r line; do
    printf_execute_error "↳ ERROR: $line"
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_help() {
  printf "%b" "$(tput setaf "${2:-4}" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"
  printf '\n'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#used for printing console notifications
printf_console() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\n$msg" "${PRINTF_COLOR:-$color}"
  printf "\n\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_pause() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="${*:-Press any key to continue}"
  printf_color "$msg " "${PRINTF_COLOR:-$color}"
  read -r -n 1 -s
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_wait() {
  printf_pause "$*"
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#same as printf_error
printf_return() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  [ ${#msg} = 0 ] || { printf_color "$msg" "$color" 1>&2 && printf "\n"; }
  return ${exitCode:-2}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_error "color" "exitcode" "message"
printf_error() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  printf_color "$ICON_ERROR $msg" "$color" 1>&2
  printf "\n"
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_exit "color" "exitcode" "message"
printf_exit() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  shift
  printf_color "$msg" "$color" 1>&2
  printf "\n"
  exit "$exitCode"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_single() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local COLUMNS=80
  local TEXT="$*"
  local LEN=${#TEXT}
  local WIDTH=$(($LEN + ($COLUMNS - $LEN) / 2))
  printf "%b" "$(tput setaf "${PRINTF_COLOR:-$color}" 2>/dev/null)" "$TEXT " "$(tput sgr0 2>/dev/null)" | sed 's#\t# #g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_help() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local filename="$()"
  local msg="$*"
  shift
  echo ""
  if [ "${PROG:-$APPNAME}" ]; then
    printf_color "$(grep ^"# @Description" "$(builtin type -P "${PROG:-$APPNAME}")" 2>/dev/null | grep ' : ' | sed 's#..* : ##g' || "${PROG:-$APPNAME}" help)\n" 2
  fi
  printf_color "$msg" "${PRINTF_COLOR:-$color}"
  printf "\n\n"
  exit 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_custom() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="$*"
  shift
  printf_color "$msg" "${PRINTF_COLOR:-$color}"
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_read() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "$line" "${PRINTF_COLOR:-$color}"
  done
  printf "\n"
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_readline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "$line" "${PRINTF_COLOR:-$color}"
    printf "\n"
  done
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_readline_trunc() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  test -n "$2" && test -z "${2//[0-9]/}" && local TRUNC_IT="$2" && shift 1 || local TRUNC_IT="${TRUNC_IT:-110}"
  while read line; do
    printf_color "$line" "${PRINTF_COLOR:-$color}" |& cat - |& cut -c 1-${TRUNC_IT} |& tee
  done
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_column() {
  local -a column=""
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="7"
  cat - |& column | printf_readline "${color:-$COLOR}"
  printf "\n"
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_cat() {
  file=${1:--}
  while IFS= read -r line; do
    printf '%s\n' "$line"
  done < <(cat -- "$file")
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local msg="$*"
  shift
  printf_color "$ICON_QUESTION $msg? " "${PRINTF_COLOR:-$color}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_custom_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "$msg " "${PRINTF_COLOR:-$color}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_question_term() {
  printf_read_question "4" "$1" "1" "REPLY"
  printf_answer_yes "$REPLY" && eval "${2:-true}" && exitCode=0 || exitCode=1
  [ -z "$REPLY" ] && printf '\n' && exitCode=1 || exitCode=${exitCode:-0}
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_read_input "color" "message" "maxLines" "answerVar" "readopts"
printf_read_input() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$1" && shift 1
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  local reply="${1:-REPLY}" && shift 1
  local readopts="${1:-}" && shift 1
  printf_color "$msg " "${PRINTF_COLOR:-$color}"
  read -e -r -n $lines ${readopts:-} ${reply:-} || return 1
  [ -z "$reply" ] && printf '\n' && return 1 || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_read_question "color" "message" "maxLines" "answerVar" "readopts"
printf_read_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$1" && shift 1
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  local reply="${1:-REPLY}" && shift 1
  local readopts="${1:-}" && shift 1
  printf_color "$msg " "${PRINTF_COLOR:-$color}"
  read -t 30 -e -r -n $lines ${readopts:-} ${reply:-} || return 1
  [ -z "$reply" ] && printf '\n' && return 1 || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_read_question "color" "message" "maxLines" "answerVar" "readopts"
printf_read_question_nt() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$1" && shift 1
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  local reply="${1:-REPLY}" && shift 1
  local readopts="${1:-}" && shift 1
  printf_color "$msg " "${PRINTF_COLOR:-$color}"
  read -e -r -n $lines ${readopts:-} ${reply:-} || return 1
  [ -z "$reply" ] && printf '\n' && return 1 || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# printf_read_password "color" "message" "varName"
printf_read_password() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="3"
  local passmesg="$1 " && shift 1
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  local reply="${1:-REPLY}" && shift
  printf_color "$passmesg" "${PRINTF_COLOR:-$color}"
  read -s -r -n $lines ${reply:-}
  printf '\n'
  [ -z "$reply" ] && return 1 || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_read_error() {
  export "${1:-}"
  printf_newline
}
#printf_answer "Var" "maxNum" "Opts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_answer() {
  read -t 10 -r -s -n 1 "${1:-$REPLY}"
  if [ -z "$reply" ]; then
    printf '\n'
    return 1
  fi
  #history -s "${1:-$REPLY}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_answer_yes "var" "response"
printf_answer_yes() {
  local answerVar="${1:-$REPLY}"
  if [[ "$answerVar" =~ ${2:-^[Yy]$} ]]; then
    exitCode=0
  elif [ -z "$answerVar" ] || [ "$answerVar" = "" ]; then
    printf '\n'
    exitCode=1
  else
    #printf '\n'
    exitCode=1
  fi
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_answer_no() {
  local answerVar="${1:-$REPLY}"
  if [[ "$answerVar" =~ ${2:-^[Nn]$} ]]; then
    return 1
  elif [ -z "$answerVar" ] || [ "$answerVar" = "" ]; then
    printf '\n'
    return 1
  else
    #printf '\n'
    return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_head() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  local msg1="$1" && shift 1
  local msg2="$1" && shift 1 || msg2=
  local msg3="$1" && shift 1 || msg3=
  local msg4="$1" && shift 1 || msg4=
  local msg5="$1" && shift 1 || msg5=
  local msg6="$1" && shift 1 || msg6=
  local msg7="$1" && shift 1 || msg7=
  shift
  [ -z "$msg1" ] || printf_color "##################################################\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg1" ] || printf_color "$msg1\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg2" ] || printf_color "$msg2\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg3" ] || printf_color "$msg3\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg4" ] || printf_color "$msg4\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg5" ] || printf_color "$msg5\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg6" ] || printf_color "$msg6\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg7" ] || printf_color "$msg7\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg1" ] || printf_color "##################################################\n" "${PRINTF_COLOR:-$color}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# same as printf_head but no formatting
printf_header() {
  local msg1="$1" && shift 1
  local msg2="$1" && shift 1 || msg2=
  local msg3="$1" && shift 1 || msg3=
  local msg4="$1" && shift 1 || msg4=
  local msg5="$1" && shift 1 || msg5=
  local msg6="$1" && shift 1 || msg6=
  local msg7="$1" && shift 1 || msg7=
  shift
  [ -z "$msg1" ] || printf "##################################################\n"
  [ -z "$msg1" ] || printf '%s\n' "$msg1"
  [ -z "$msg2" ] || printf '%s\n' "$msg2"
  [ -z "$msg3" ] || printf '%s\n' "$msg3"
  [ -z "$msg4" ] || printf '%s\n' "$msg4"
  [ -z "$msg5" ] || printf '%s\n' "$msg5"
  [ -z "$msg6" ] || printf '%s\n' "$msg6"
  [ -z "$msg7" ] || printf '%s\n' "$msg7"
  [ -z "$msg1" ] || printf "##################################################\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_result() {
  PREV="$4"
  [ -n "$1" ] && EXIT="$1" || EXIT="$?"
  [ -n "$2" ] && local OK="$2" || local OK="Command executed successfully"
  [ -n "$3" ] && local FAIL="$3" || local FAIL="${PREV:-The previous command} has failed"
  [ -n "$4" ] && local FAIL="$3" || local FAIL="$3"
  if [ "$EXIT" = 0 ]; then
    printf_success "$OK"
    return 0
  else
    if [ -z "$4" ]; then
      printf_error "$FAIL"
    else
      printf_error "$FAIL: $PREV"
    fi
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_counter "color" "time" "message"
printf_counter() {
  printf_newline "\n\n"
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local wait_time="$1" && shift 1 || local wait_time="5"
  message="$*" && shift
  temp_cnt=${wait_time}
  while [[ ${temp_cnt} -gt 0 ]]; do
    printf "\r%s" "$(printf_custom $color $message: ${temp_cnt}) "
    sleep 1
    ((temp_cnt--))
  done
  printf_newline "\n\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_debug() {
  printf_yellow "Running in debug mode "
  for d in "$@"; do
    echo "$d" | printf_readline "5"
  done
  exit 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#counter time "color" "message" "seconds(s) "
__counter() {
  local wait_time="$1" # seconds
  local color="$2"
  local msg="$3"
  local duration="${4:-}"
  local temp_cnt=${wait_time}
  while [[ ${temp_cnt} -gt 0 ]]; do
    printf "\r%s\r" "$(printf_custom "${PRINTF_COLOR:-$color}" $msg $duration ${temp_cnt} "$4")"
    sleep 1
    ((temp_cnt--))
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_debug() {
  printf_yellow "Running in debug mode "
  for d in "$@"; do
    echo "$d" | printf_readline "5"
  done
  exit 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#counter time "color" "message" "seconds(s) "
__counter() {
  local wait_time="$1" # seconds
  local color="$2"
  local msg="$3"
  local duration="${4:-}"
  local temp_cnt=${wait_time}
  while [[ ${temp_cnt} -gt 0 ]]; do
    printf "\r%s\r" "$(printf_custom "${PRINTF_COLOR:-$color}" $msg $duration ${temp_cnt} "$4")"
    sleep 1
    ((temp_cnt--))
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_fix_name() {
  [[ -f "${1:-/etc/casjaysdev/updates/versions/osversion.txt}" ]] &&
    sudo sed -i 's|[",]||g;s| [lL]inux:||g' "${1:-/etc/casjaysdev/updates/versions/osversion.txt}" ||
    return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_name() {
  [ -n "$DISTRO_NAME" ] && printf '%s\n' "$DISTRO_NAME" ||
    grep -sh '^NAME=' "/etc/os-release" | awk -F '=' '{print $2}' | grep '^' ||
    grep -sh '^ID=' "/etc/os-release" | awk -F '=' '{print $2}' | grep '^' ||
    echo "OS: Unknown"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_version() {
  os_v=""
  if [ -n "$DISTRO_VERSION" ] && [ "$DISTRO_VERSION" != "N/A" ] && printf '%s\n' "$DISTRO_VERSION" | grep -q '^[0-9]'; then
    printf '%s\n' "$DISTRO_VERSION"
    return
  fi
  if [ -z "$os_v" ]; then
    os_v="$([ -f "/etc/debian_version" ] && grep '[0-9]' "/etc/debian_version" | head -n1 | awk -F '.' '{print $1}')"
  fi
  if [ -z "$os_v" ]; then
    os_v="$(grep -sh '^VERSION=' /etc/os-release 2>/dev/null | sed 's|[a-zA-Z]||g;s/[^.0-9]*//g' | grep -v '/' | grep '[0-9]$')"
  fi
  if [ -z "$os_v" ]; then
    os_v="$(grep -sh 'BUILD_ID' /etc/os-release 2>/dev/null | awk -F '=' '{print $2}' | sed 's|[a-zA-Z]||g;s/[^.0-9]*//g' | grep '[0-9]$')"
  fi
  if [ -z "$os_v" ]; then
    os_v="$($LSB_RELEASE -a 2>/dev/null | grep -i '^Release' | grep -v '/' | awk '{print $2}' | grep '^' | grep '[0-9]')"
  fi
  [ -n "$os_v" ] && printf '%s\n' "$os_v" | sed 's|"||g' || echo "Version: Unknown"
  unset os_v
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getpythonver() {
  if builtin type -P python3 &>/dev/null; then
    PYTHONVER="python3"
    PIP="pip3"
    PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
  elif builtin type -P python2 &>/dev/null; then
    PYTHONVER="python2"
    PIP="pip"
    PATH="${PATH}:$(python2 -c 'import site; print(site.USER_BASE)')/bin"
  elif builtin type -P python &>/dev/null; then
    PYTHONVER="python"
    PIP="pip"
    PATH="${PATH}:$(python -c 'import site; print(site.USER_BASE)')/bin"
  fi
  if builtin type -P yay &>/dev/null || builtin type -P pacman &>/dev/null; then
    PYTHONVER="python"
    PIP="pip3"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getphpver() {
  if builtin type -P php &>/dev/null; then
    PHPVER="$(php -v | grep --only-matching --perl-regexp "(PHP )\d+\.\\d+\.\\d+" | cut -c 5-7)"
  else
    PHPVER=""
  fi
  echo "$PHPVER"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__setcursor() {
  echo -e -n "\x1b[\x35 q" "\e]12;cyan\a" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#basedir "file"
__basedir() {
  if [ "$(dirname "$1" 2>/dev/null)" = . ]; then
    echo "$PWD"
  else
    dirname "$1" | sed 's#\../##g' 2>/dev/null
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#basename -- "file"
__basename() {
  basename -- "${1:-.}" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# dirname dir
__dirname() {
  cd "$1" 2>/dev/null && echo "$PWD" || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#to_lowercase "args"
__to_lowercase() {
  echo "$@" |
    tr '[A-Z]' '[a-z]'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#to_uppercase "args"
__to_uppercase() {
  echo "$@" |
    tr '[a-z]' '[A-Z]'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#strip_ext "Filename"
__strip_ext() {
  echo "$@" |
    sed 's#\..*##g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#get_full_file "file"
__get_full_file() {
  ls -A "$*" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#cat file | rmcomments
__rmcomments() {
  $sed 's/[[:space:]]*#.*//;/^[[:space:]]*$/d'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#countwd file
__countwd() {
  cat "$@" |
    wc -l |
    __rmcomments
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__column() {
  builtin type -P column &>/dev/null &&
    column || tee
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#getuser "username" "grep options"
__getuser() {
  if [ -n "${1:-$USER}" ]; then
    cut -d: -f1 /etc/passwd |
      grep "${1:-$USER}" |
      cut -d: -f1 /etc/passwd |
      grep "${1:-$USER}" ${2:-}
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#getuser_shell "shellname"
__getuser_shell() {
  local PATH="/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games"
  local CURSHELL=${1:-$(grep "$USER" /etc/passwd | tr ':' '\n' | tail -n1)} && shift 1
  local USER=${1:-$USER} && shift 1
  grep "$USER" /etc/passwd |
    cut -d: -f7 |
    grep -q "${CURSHELL:-$SHELL}" &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getuser_cur_shell() {
  local PATH="/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games"
  local CURSHELL="$(grep "$USER" /etc/passwd | tr ':' '\n' | tail -n1)"
  grep "$USER" /etc/passwd | tr ':' '\n' | grep "${CURSHELL:-$SHELL}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#mkd dir
__mkd() {
  for d in "$@"; do
    [ -e "$d" ] || mkdir -p "$d" &>/dev/null
  done
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__file_not_empty() {
  [ -s "$1" ] && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__file_is_empty() {
  [ ! -s "$1" ] && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#vim "file"
__vim() {
  local vim="${vim:-vim}"
  eval $vim "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#keeps output color
if ! builtin type -P unbuffer &>/dev/null; then
  unbuffer() {
    exec "$@"
  }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#sed "commands"
__sed() {
  local sed="${sed:-sed}"
  ${sed:-sed} "$*" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# find replace
__find_replace() {
  find -L "$3" -type f -exec "$sed" -i 's#'$1'#'$2'#g' {} \; 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#replace file
__replace() {
  $sed -i 's|'"$1"'|'"$2"'|g' "$3" &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#tar "filename dir"
__tar_create() {
  tar cfvz "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#tar filename
__tar_extract() {
  tar xfvz "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#while_true "command"
__while_loop() {
  while :; do
    "${@}" && sleep .3
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#for_each "option" "command"
__for_each() {
  for item in ${1}; do
    ${2} ${item} && sleep .1
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__readline() {
  while read -r line; do
    echo "$line"
  done <"$1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#timeout "time" "command"
__timeout() {
  timeout ${1} bash -c "${2}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#start_count "proc" "search"
__start_count() {
  ps -ux |
    grep "$1" |
    grep -v 'grep ' |
    grep -c "${2:$1}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#count_words "file"
__count_lines() {
  wc -l "$1" |
    awk '${print $1}'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#count_files "dir"
__count_files() {
  find -L "${1:-./}" -maxdepth "${2:-1}" \
    -not -path "${1:-./}/.git/*" -type f 2>/dev/null |
    wc -l
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#count_dir "dir"
__count_dir() {
  find -L "${1:-./}" -maxdepth "${2:-1}" \
    -not -path "${1:-./}/.git/*" -type d 2>/dev/null |
    wc -l
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#touch file
__touch() {
  for f in "$@"; do
    local dir="$(dirname "$f" 2>/dev/null)"
    mkdir -p "$dir" &>/dev/null
    touch "$f" &>/dev/null
  done
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#symlink "file" "dest"
__symlink() {
  if [ -e "$1" ]; then
    __ln_sf "${1}" "${2}" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#mv_f "file" "dest"
__mv_f() {
  if [ -e "$1" ]; then
    mv -f "$1" "$2" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#cp_rf "file" "dest"
__cp_rf() {
  if [ -e "$1" ]; then
    cp -Rf "$1" "$2" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#rm_rf "file"
__rm_rf() {
  if [ -e "$1" ]; then
    rm -Rf "$@" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# unlink "location"
__unlink() {
  if [ -L "$1" ]; then
    unlink "$@" &>/dev/null || return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# broken_symlinks "file"
__broken_symlinks() {
  find -L "$@" -type l \
    -exec rm -f {} \; &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#ln_rm "file"
__ln_rm() {
  if [ -e "$1" ]; then
    find -L $1 -mindepth 1 -maxdepth 1 \
      -type l -exec rm -f {} \; &>/dev/null
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#ln_sf "file"
__ln_sf() {
  [ -L "$2" ] && __rm_rf "$2" || true
  ln -sf "$1" "$2" &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#find_mtime "file/dir" "time minutes"
__find_mtime() {
  if [ "$(find ${1:-.} -maxdepth 1 -type f -cmin ${2:-60} 2>/dev/null | wc -l)" -ne 0 ]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#find "dir" "options"
__find() {
  local DEF_OPTS=""
  local opts="${FIND_OPTS:-$DEF_OPTS}"
  find "${*:-.}" -not -path "$dir/.git/*" $opts 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#find_old "dir" "minutes" "action"
__find_old() {
  [ -d "$1" ] && local dir="$1" && shift 1
  local time="$1" && shift 1
  local action="$1" && shift 1
  find "${dir:-$HOME/.local/tmp}" -type f -mmin +${time:-120} -${action:-delete} 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#find "dir" - return path relative to dir
__find_rel() {
  #f for file | d for dir
  local DIR="${*:-.}"
  local DEF_TYPE="${FIND_TYPE:-f,l}"
  local DEF_DEPTH="${FIND_DEPTH:-1}"
  local DEF_OPTS="${FIND_OPTS:-}"
  find $DIR/* -maxdepth $DEF_DEPTH -type $DEF_TYPE $DEF_OPTS \
    -not -path "$dir/.git/*" -print 2>/dev/null | $sed 's#'$DIR'/##g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#cd "dir"
__cd() { cd "$1" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cd into directory with message
__cd_into() {
  if [ $PWD != "$1" ]; then
    cd "$1" && printf_green "Changing the directory to $1" &&
      printf_green "Type exit to return to your previous directory" &&
      exec bash || exit 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
path_info() { echo "$PATH" | tr ':' '\n' | sort -u; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
check_local() {
  local file="${1:-$PWD}"
  if [ -d "$file" ]; then
    type="dir"
    localfile="true"
    return 0
  elif [ -f "$file" ]; then
    type="file"
    localfile="true"
    return 0
  elif [ -L "$file" ]; then
    type="symlink"
    localfile="true"
    return 0
  elif [ -S "$file" ]; then
    type="socket"
    localfile="true"
    return 0
  elif [ -b "$file" ]; then
    type="block"
    localfile="true"
    return 0
  elif [ -p "$file" ]; then
    type="pipe"
    localfile="true"
    return 0
  elif [ -c "$file" ]; then
    type="character"
    localfile="true"
    return 0
  elif [ -e "$file" ]; then
    type="file"
    localfile="true"
    return 0
  else
    type= && localfile=
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#do_not_add_a_url "url"
__do_not_add_a_url() {
  regex="(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]"
  string="$1"
  if [[ "$string" =~ $regex ]]; then
    printf_exit "Do not provide the full url: only provide the username/repo"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__options() {
  local SHORTOPTS="d"
  local LONGOPTS="debug,raw"
  setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$FUNCFILE" -- "$@" 2>/dev/null)
  eval set -- "${setopts[@]}" 2>/dev/null
  while :; do
    case "$1" in
    -d)
      shift 1
      export SCRIPT_OPTS=""
      export _DEBUG=""
      ;;

    --debug)
      shift 1
      set -xo pipefail
      export SCRIPT_OPTS="--debug"
      export _DEBUG="on"
      ;;

    --raw)
      shift 1
      export SHOW_RAW="true"
      unset -f printf_color
      printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[[0-9;]*[a-zA-Z],,g'; }

      ;;
    --)
      shift 1
      break
      ;;
    esac
  done
}
