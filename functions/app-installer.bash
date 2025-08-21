#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  020920211625-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  LICENSE.md
# @ReadME            :  README.md
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created           :  Tuesday, Feb 09, 2021 17:17 EST
# @File              :  app-installer.bash
# @Description       :  Installer functions for apps
# @TODO              :  Refactor code - It is a mess
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
trap '__trap_exit_app_install;exit 2' SIGINT
FUNCFILE="app-installer.bash"
RUN_USER="$(logname 2>/dev/null)"
SUDO_USER="${RUN_USER:-$SUDO_USER}"
export RUN_USER SUDO_USER _DEBUG
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[ "$_DEBUG" = "on" ] && set -xo pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CASJAYSDEVDIR="/usr/local/share/CasjaysDev/scripts"
CASJAYSDEV_USERDIR="${CASJAYSDEV_USERDIR:-$HOME/.local/share/CasjaysDev}"
export PATH="$CASJAYSDEVDIR/bin:/usr/local/bin:$PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Versioning Info - __required_version "VersionNumber"
localVersion="${localVersion:-202108121011-git}"
requiredVersion="${requiredVersion:-202108121011-git}"
if [ -f "$CASJAYSDEVDIR/version.txt" ]; then
  currentVersion="${currentVersion:-$(<$CASJAYSDEVDIR/version.txt)}"
else
  currentVersion="${currentVersion:-$localVersion}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CMD="${CMD:-$APPNAME}"
[ -d "$HOME/.local/log" ] && SYS_LOG_DIR="$HOME/.local/log" || SYS_LOG_DIR="/tmp/log"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### builtins ######################
[ -d "/usr/local/opt/gnu-getopt/bin" ] && TMPPATH="/usr/local/opt/gnu-getopt/bin:"
TMPPATH+="$HOME/.local/share/bash/basher/cellar/bin:$HOME/.local/share/bash/basher/bin:"
TMPPATH+="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/gem/bin:/usr/local/bin:"
TMPPATH+="/usr/local/share/CasjaysDev/scripts/bin:/usr/local/sbin:/usr/sbin:"
TMPPATH+="/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH:."
PATH="$(echo "$TMPPATH" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:.#g')"
unset TMPPATH
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$UID" = "0" ] || [ "$USER" = "root" ]; then
  export INSTALLER_LOG_DIR="$SYS_LOG_DIR/${SCRIPTS_PREFIX:-apps}/${APPNAME:-scripts}"
else
  export INSTALLER_LOG_DIR="${LOG_DIR:-$HOME/.local/log}/${SCRIPTS_PREFIX:-apps}/${APPNAME:-scripts}"
fi
export INSTALLER_LOG_FILE="$INSTALLER_LOG_DIR/install_${CMD// /_}.log"
export INSTALLER_ERR_FILE="$INSTALLER_LOG_DIR/install_${CMD// /_}.err.log"
[ -d "$INSTALLER_LOG_DIR" ] || mkdir -p "$INSTALLER_LOG_DIR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fail if git, curl, and wget are not installed
for check in git curl wget; do
  if [ -z "$(builtin type -P "$check" 2>/dev/null)" ]; then
    printf '%b\n' "\033[1;31mAttempting to install $check\033[0m"
    if [ -f "$(builtin type -P brew 2>/dev/null)" ]; then
      brew install -f "$check" &>/dev/null
    elif [ -f "$(builtin type -P apt 2>/dev/null)" ]; then
      apt install -yy -q "$check" &>/dev/null
    elif [ -f "$(builtin type -P pacman 2>/dev/null)" ]; then
      pacman -S --noconfirm "$check" &>/dev/null
    elif [ -f "$(builtin type -P yum 2>/dev/null)" ]; then
      yum install -yy -q "$check" &>/dev/null
    elif [ -f "$(builtin type -P apk 2>/dev/null)" ]; then
      apk --no-cache add "$check" -y &>/dev/null
    elif [ -f "$(builtin type -P choco 2>/dev/null)" ]; then
      choco install "$check" -y &>/dev/null
    else
      printf '%b\n' "\033[1;31m$check can not be install automatically\033[0m"
      exit 1
    fi
  fi
  if [ -z "$(builtin type -P "$check" 2>/dev/null)" ]; then
    printf '%b\n' "\033[1;31m$check was not installed\033[0m"
    exit 1
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__which() { which "$1" 2>/dev/null; }
__type() { type -P "$1" 2>/dev/null; }
__command() { command -v "$1" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# trap errors
__trap_exit_app_install() {
  local tmp_file="${TMP:-/tmp}/${APPNAME:-scripts}.tmp"
  local tmp_inst_file="${TMP:-/tmp}/${APPNAME:-scripts}.inst.tmp"
  [ -f "$tmp_file" ] && rm -Rf "$tmp_file" || true
  [ -f "$tmp_inst_file" ] && rm -Rf "$tmp_inst_file" || true
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cmd_exists() {
  for f in "$@"; do
    builtin type -p "$f" &>/dev/null && return 0 || return 1
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__am_i_online() {
  if curl -q -LSsfI "https://1.1.1.1" 2>/dev/null | grep -q ':.cloudflare'; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# OS Settings
__detect_os() {
  if [ -f "$CASJAYSDEVDIR/bin/detectostype" ] && [ -z "$DISTRO_NAME" ]; then
    . "$CASJAYSDEVDIR/bin/detectostype"
  fi
} && __detect_os
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$SUDO_USER" ]; then
  export RUN_USER="${RUN_USER:-$SUDO_USER}"
else
  export RUN_USER="${RUN_USER:-$(whoami)}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export RUN_USER="${RUN_USER:-$USER}"
export TMP="${TMP:-/tmp}"
export TEMP="${TEMP:-/tmp}"
export TMPDIR="${TMPDIR:-/tmp}"
mkdir -p "$TMPDIR" "$TEMP" "$TMP" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export WHOAMI="${SUDO_USER:-$USER}"
export HOME="${USER_HOME:-$HOME}"
export LOGDIR="${LOGDIR:-$HOME/.local/log}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$SUDO_PROMPT" ]; then
  export SUDO_PROMPT="$(printf "\n\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m" && echo)"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Timezone data
if [ -f "/etc/timezone" ]; then
  export TIMEZONE="$(<"/etc/timezone")"
else
  export TIMEZONE="America/New_York"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
devnull() { "$@" >/dev/null 2>&1; }
devnull2() { "$@" >/dev/null 2>&1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__os_fix_name() {
  local file="${1:-/etc/casjaysdev/updates/versions/osversion.txt}"
  if [ -f "$file" ]; then
    sudo sed -i 's|[",]||g;s| [lL]inux:||g' "$file"
  else
    return 0
  fi
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
# Set Main Repo for dotfiles
export GIT_REPO_BRANCH="${GIT_DEFAULT_BRANCH:-main}"
export DOTFILESREPO="${DOTFILESREPO:-https://github.com/dfmgr}"
export DESKTOPMGRREPO="${DESKTOPMGRREPO:-https://github.com/desktopmgr}"
export DFMGRREPO="${DFMGRREPO:-https://github.com/dfmgr}"
export PKMGRREPO="${PKMGRREPO:-https://github.com/pkmgr}"
export DEVENVMGRREPO="${DEVENVMGR:-https://github.com/devenvmgr}"
export DOCKERMGRREPO="${DOCKERMGRREPO:-https://github.com/dockermgr}"
export ICONMGRREPO="${ICONMGRREPO:-https://github.com/iconmgr}"
export FONTMGRREPO="${FONTMGRREPO:-https://github.com/fontmgr}"
export HAKMGRREPO="${HAKMGRREPO:-https://github.com/hakmgr}"
export THEMEMGRREPO="${THEMEMGRREPO:-https://github.com/thememgr}"
export SYSTEMMGRREPO="${SYSTEMMGRREPO:-https://github.com/systemmgr}"
export WALLPAPERMGRREPO="${WALLPAPERMGRREPO:-https://github.com/wallpapermgr}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Colors
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
ICON_INFO="[ ℹ️  ]"
ICON_GOOD="[ ✅ ]"
ICON_WARN="[ ❗ ]"
ICON_ERROR="[ ❌ ]"
ICON_QUESTION="[ ❓ ]"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$SHOW_RAW" = "true" ]; then
  unset -f __printf_color
  printf_color() { printf '%b' "$1" | tr -d '\t'; }
  __printf_color() { printf_color "$1"; }
  __printf_space() { printf "%b%${1:-30}s" "${2}" "${3}"; }
else
  __printf_color() { printf_color "$@"; }
  printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
  __printf_space() { printf "%b%${1:-30}s" "$(tput setaf "${4:-5}" 2>/dev/null)${2}" "${3}$(tput sgr0 2>/dev/null)"; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_newline() {
  [ -n "$1" ] && printf '%b\n' "${*:-}" || printf '\n'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_normal() { printf_color "$1\n" "$2"; }
printf_green() { printf_color "$1\n" 2; }
printf_red() { printf_color "$1\n" 1; }
printf_purple() { printf_color "$1\n" 5; }
printf_yellow() { printf_color "$1\n" 3; }
printf_blue() { printf_color "$1\n" 33; }
printf_cyan() { printf_color "$1\n" 6; }
printf_info() { printf_color "$ICON_INFO $1\n" 3; }
printf_success() { printf_color "$ICON_GOOD $1\n" 2; }
printf_warning() { printf_color "$ICON_WARN $1\n" 3; }
printf_execute_success() { printf_color "$ICON_GOOD $1\n" 2; }
printf_execute_error() { printf_color "$ICON_WARN $1 $2\n" 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_error_stream() {
  while read -r line; do
    printf_error "↳ ERROR: $line"
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_execute_error_stream() {
  while read -r line; do
    printf_execute_error "↳ ERROR: $line"
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_execute_result() {
  if [ "$1" -eq 0 ]; then
    printf_execute_success "$2"
  else
    printf_execute_error "${3:-$2}"
  fi
  return "$1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local msg="$*"
  shift
  printf_color "$ICON_QUESTION $msg? " "$color"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_error "color" "exitcode" "message"
printf_error() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  printf_color "$msg" "$color" 1>&2
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# __printf_spacing "color" "space" "leftSide" "rightSide"
printf_spacing() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  test -n "$1" && test -z "${1//[0-9]/}" && local space="$1" && shift 1 || local space="20"
  local left="${1}"
  local right="${2}"
  __printf_space "$space" "$left" "$right" "${PRINTF_COLOR:-$color}"
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_exit "color" "exitcode" "message"
printf_exit() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  shift
  printf_color "$msg" "$color" 1>&2
  echo ""
  exit "$exitCode"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#printf_exit "color" "exitcode" "message"
printf_return() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  shift
  printf_color "$msg" "$color" 1>&2
  printf '\n'
  return "$exitCode"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# #printf_newline
printf_readline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "$line" "$color"
    printf '\n'
  done
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_custom() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="$*"
  shift
  printf_color "$msg" "$color"
  echo ""
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_custom_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "$msg " "$color"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_question_timeout() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$1" && shift 1
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  reply="${1:-REPLY}" && shift 1
  readopts="${1:-}" && shift 1
  printf_color "$msg " "${PRINTF_COLOR:-$color}"
  read -t 30 -r -n $lines ${readopts?} ${reply?}
  printf_newline
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
  [ -z "$msg1" ] || printf_color "##################################################\n" "$color"
  [ -z "$msg1" ] || printf_color "$msg1\n" "$color"
  [ -z "$msg2" ] || printf_color "$msg2\n" "$color"
  [ -z "$msg3" ] || printf_color "$msg3\n" "$color"
  [ -z "$msg4" ] || printf_color "$msg4\n" "$color"
  [ -z "$msg5" ] || printf_color "$msg5\n" "$color"
  [ -z "$msg6" ] || printf_color "$msg6\n" "$color"
  [ -z "$msg7" ] || printf_color "$msg7\n" "$color"
  [ -z "$msg1" ] || printf_color "##################################################\n" "$color"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_result() {
  PREV="$4"
  [ -n "$1" ] && EXIT="$1" || EXIT="$?"
  [ -n "$2" ] && local OK="$2" || local OK="Command executed successfully"
  [ -n "$3" ] && local FAIL="$3" || local FAIL="${PREV:-The previous command} has failed"
  [ -n "$4" ] && local FAIL="$3" || local FAIL="$3"
  if [ "$EXIT" -eq 0 ]; then
    printf_success "$OK"
    return 0
  else
    if [ -z "$4" ]; then
      printf_error "$FAIL\n"
    else
      printf_error "$FAIL: $PREV\n"
    fi
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__printf_space() {
  local pad=$(printf '%0.1s' " "{1..60})
  local padlength=$1
  local string1="$2"
  local string2="$3"
  local message
  message+="$(printf '%s' "$string1") "
  message+="$(printf '%*.*s' 0 $((padlength - ${#string1} - ${#string2})) "$pad") "
  message+="$(printf '%s\n' "$string2") "
  printf '%s\n' "$message"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
get_answer() { printf "%s" "$REPLY"; }
answer_is_yes() { [[ "$REPLY" =~ ^[Yy]$ ]] && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__curl() {
  __am_i_online && curl -q -LSs --connect-timeout 3 --retry 0 "$@"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__start() {
  sleep .2 && "$*" &>/dev/null &
  disown
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
die() { echo -e "$1" exit ${2:9999}; }
killpid() { devnull kill -9 "$(pidof "$1")"; }
running() { ps ux | grep "$1" | grep -vq 'grep ' &>/dev/null && return 1 || return 0; }
hostname2ip() { getent hosts "$1" | cut -d' ' -f1 | head -n1 || nslookup "$1" 2>/dev/null | grep Address: | awk '{print $2}' | grep -vE '#|:' | grep ^ || return 1; }
set_trap() { trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
getuser() {
  if [ -z "$1" ]; then
    cut -d: -f1 /etc/passwd | grep "$USER"
  else
    cut -d: -f1 /etc/passwd | grep "$1"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_active "list of services to check"
system_service_active() {
  for service in "$@"; do
    if [ "$(systemctl show -p ActiveState $service | cut -d'=' -f2)" == active ]; then
      return 0
    else
      return 1
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_running "list of services to check"
system_service_running() {
  for service in "$@"; do
    if systemctl status $service 2>/dev/null | grep -Fq running; then
      return 0
    else
      return 1
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_exists "servicename"
system_service_exists() {
  for service in "$@"; do
    if sudo systemctl list-units --full -all | grep -Fq "$service.service" || sudo -HE systemctl list-units --full -all | grep -Fq "$service.socket"; then return 0; else return 1; fi
    setexitstatus $?
  done
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_enable "servicename"
system_service_enable() {
  for service in "$@"; do
    if system_service_exists "$service"; then
      devnull "sudo -HE systemctl enable --now -f $service"
    fi
    setexitstatus $?
  done
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_disable "servicename"
system_service_disable() {
  for service in "$@"; do
    if system_service_exists "$service"; then
      devnull "sudo systemctl disable --now -f $service"
    fi
    setexitstatus $?
  done
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_start "servicename"
system_service_start() {
  for service in "$@"; do
    if system_service_exists "$service"; then
      devnull "sudo -HE systemctl start $service"
    fi
    setexitstatus $?
  done
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_stop "servicename"
system_service_stop() {
  for service in "$@"; do
    if system_service_exists "$service"; then
      devnull "sudo -HE systemctl stop $service"
    fi
    setexitstatus $?
  done
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_restart "servicename"
system_service_restart() {
  for service in "$@"; do
    if system_service_exists "$service"; then
      devnull "sudo -HE systemctl restart $service"
    fi
    setexitstatus $?
  done
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_post() {
  local e="$1"
  local m="${e//devnull//}"
  #local m="$(echo $1 | sed 's#devnull ##g')"
  execute "$e" "executing: $m"
  setexitstatus
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#alternative names
tf() { [ -f "$(builtin type -P tinyfigue 2>/dev/null)" ] || [ -f "$(builtin type -P tf 2>/dev/null)" ] || return 1; }
httpd() { [ -f "$(builtin type -P httpd 2>/dev/null)" ] || [ -f "$(builtin type -P apache2 2>/dev/null)" ] || [ -f "$(builtin type -P apache 2>/dev/null)" ] || return 1; }
cron() { [ -f "$(builtin type -P crond 2>/dev/null)" ] || [ -f "$(builtin type -P cron 2>/dev/null)" ] || return 1; }
grub() { [ -f "$(builtin type -P grub-install 2>/dev/null)" ] || [ -f "$(builtin type -P grub2-install 2>/dev/null)" ] || return 1; }
cowsay() { [ -f "$(builtin type -P cowsay 2>/dev/null)" ] || [ -f "$(builtin type -P cowpatty 2>/dev/null)" ] || return 1; }
fortune() { [ -f "$(builtin type -P fortune 2>/dev/null)" ] || [ -f "$(builtin type -P fortune-mod 2>/dev/null)" ] || return 1; }
mlocate() { [ -f "$(builtin type -P locate 2>/dev/null)" ] || [ -f "$(builtin type -P mlocate 2>/dev/null)" ] || return 1; }
xfce4() { [ -f "$(builtin type -P xfce4-about 2>/dev/null)" ] || return 1; }
xfce4-notifyd() { [ -f "$(builtin type -P xfce4-notifyd-config 2>/dev/null)" ] || find /usr/lib* -name "xfce4-notifyd" -type f 2>/dev/null | grep -q . || return 1; }
imagemagick() { [ -f "$(builtin type -P convert 2>/dev/null)" ] || return 1; }
fdfind() { [ -f "$(builtin type -P fdfind 2>/dev/null)" ] || [ -f "$(builtin type -P fd 2>/dev/null)" ] || return 1; }
speedtest() { [ -f "$(builtin type -P speedtest-cli 2>/dev/null)" ] || [ -f "$(builtin type -P speedtest 2>/dev/null)" ] || return 1; }
neovim() { [ -f "$(builtin type -P nvim 2>/dev/null)" ] || [ -f "$(builtin type -P neovim 2>/dev/null)" ] || return 1; }
chromium() { [ -f "$(builtin type -P chromium 2>/dev/null)" ] || [ -f "$(builtin type -P chromium-browser 2>/dev/null)" ] || return 1; }
firefox() { [ -f "$(builtin type -P firefox-esr 2>/dev/null)" ] || [ -f "$(builtin type -P firefox 2>/dev/null)" ] || return 1; }
powerline-status() { [ -f "$(builtin type -P powerline-config 2>/dev/null)" ] || [ -f "$(builtin type -P powerline-daemon 2>/dev/null)" ] || return 1; }
gtk-2.0() { find /lib* /usr* -iname "*libgtk*2*.so*" -type f 2>/dev/null | grep -q . || return 1; }
gtk-3.0() { find /lib* /usr* -iname "*libgtk*3*.so*" -type f 2>/dev/null | grep -q . || return 1; }
transmission-remote-cli() { [ -f "$(builtin type -P transmission-remote-cli 2>/dev/null)" ] || [ -f "$(builtin type -P transmission-remote 2>/dev/null)" ] || return 1; }
transmission() { [ -f "$(builtin type -P transmission-remote)" ] || [ -f "$(builtin type -P transmission-remote-cli)" ] || [ -f "$(builtin type -P transmission-remote-gtk)" ] || return 1; }
libvirt() { [ -f "$(builtin type -P libvirtd)" ] && return 0 || return 1; }
qemu() { [ -f "$(builtin type -P qemu-img)" ] && return 0 || return 1; }
mongodb() { [ -f "$(builtin type -P mongod)" ] || [ -f "$(builtin type -P mongodb)" ] || return 1; }
python() { [ -f "$(builtin type -P python)" ] || [ -f "$(builtin type -P python2)" ] || [ -f "$(builtin type -P python3)" ] && return 0 || return 1; }
locate() { [ -f "$(builtin type -P locate 2>/dev/null)" ] || [ -f "$(builtin type -P mlocate 2>/dev/null)" ] || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export -f cron mlocate xfce4 imagemagick fdfind speedtest neovim
export -f chromium firefox gtk-2.0 gtk-3.0 transmission transmission-remote-cli
export -f cowsay xfce4-notifyd grub powerline-status libvirt qemu mongodb python
export -f locate
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
backupapp() {
  local filename count backupdir rmpre4vbackup
  [ -n "$1" ] && local myappdir="$1" || local myappdir="$APPDIR"
  [ -n "$2" ] && local myappname="$2" || local myappname="$APPNAME"
  local downloaddir="$INSTDIR"
  local logdir="${LOGDIR:-$HOME/.local/log}/backups/${SCRIPTS_PREFIX:-apps}"
  local curdate="$(date +%Y-%m-%d-%H-%M-%S)"
  local filename="$myappname-$curdate.tar.gz"
  local backupdir="${MY_BACKUP_DIR:-$HOME/.local}/backups/${SCRIPTS_PREFIX:-apps}/"
  local count="$(find -L $backupdir/$myappname*.tar.gz -type f 2>/dev/null | wc -l 2>/dev/null)"
  local rmpre4vbackup="$(find -L $backupdir/$myappname*.tar.gz -type f 2>/dev/null | head -n 1)"
  mkdir -p "$backupdir" "$logdir"
  if [ ! -f "$APPDIR/.installed" ] && [ -d "$myappdir" ] && [ "$myappdir" != "$downloaddir" ]; then
    echo -e " #################################" >>"$logdir/$myappname.log"
    echo -e "# Started on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    echo -e "# Backing up $myappdir" >>"$logdir/$myappname.log"
    echo -e "#################################" >>"$logdir/$myappname.log"
    tar cfzv "$backupdir/$filename" "$myappdir" >>"$logdir/$myappname.log" 2>>"$logdir/$myappname.log"
    echo -e "#################################" >>"$logdir/$myappname.log"
    echo -e "# Ended on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    echo -e "#################################" >>"$logdir/$myappname.log"
    if [ ! -f "$APPDIR/.installed" ] || [ ! -d "$APPDIR/.git" ]; then
      rm_rf "$myappdir"
    fi
  fi
  if [ "$count" -gt "3" ]; then rm_rf $rmpre4vbackup; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mkd() {
  local dir="$*"
  for d in $dir; do
    if [ -f "$d" ]; then rm_rf "$d"; fi
    [ -d "$d" ] || mkdir -p "$d" &>/dev/null
  done
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__download_file() { curl -q -LSsf "$1" -o "$2" || return 1; }
__service_is_active() { systemctl is-enabled $1 | grep -q 'enabled' || return 1; }
__service_is_running() { systemctl is-active $1 | grep -q 'active' || return 1; }
__get_pid() { ps -aux | grep "$1" | awk -F ' ' '{print $2}' | grep ${2:-[0-9]} || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sed="$(builtin type -P gsed 2>/dev/null || builtin type -P sed 2>/dev/null || return)"
rm_link() { unlink "$1"; }
symlink() { ln_sf "$1" "$2"; }
countwd() { cat "$@" | wc-l | rmcomments; }
urlverify() { urlcheck "$1" || urlinvalid "$1"; }
rmcomments() { sed 's/[[:space:]]*#.*//;/^[[:space:]]*$/d'; }
sed_replace() { $sed -i 's|'"$1"'|'"$2"'|g' "$3" &>/dev/null; }
broken_symlinks() { devnull find "$*" -xtype l -exec rm {} \;; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; else return 0; fi; }
rm_rf() { if [ -e "$1" ]; then devnull rm -Rf "$@"; else return 0; fi; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; else return 0; fi; }
replace() { [ -e "$1" ] && find "$1" -not -path "$1/.git/*" -type f -exec sed -i 's|'$2'|'$3'|g' {} \; >/dev/null 2>&1 || return 0; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
urlcheck() {
  devnull curl --config /dev/null \
    --connect-timeout 3 \
    --retry 3 \
    --retry-delay 1 \
    --output /dev/null \
    --silent --head \
    --fail "$1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ln_rm() {
  if [ -e "$1" ]; then
    devnull find -L "$1" -mindepth 1 -maxdepth 1 -type l -exec rm -f {} \;
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ln_sf() {
  [ -L "$2" ] && rm_rf "$2" || true
  devnull ln -sf "$1" "$2"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mkd() {
  local dir="$*"
  for d in $dir; do
    if [ -f "$d" ]; then rm_rf "$d"; fi
    [ -d "$d" ] || mkdir -p "$d" &>/dev/null
  done
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
urlinvalid() {
  if [ -z "$1" ]; then
    printf_red "Invalid URL"
    failexitcode
  else
    printf_red "Can't find $1"
    failexitcode
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
returnexitcode() {
  local RETVAL="$?"
  EXIT="$RETVAL"
  if [ "$RETVAL" -ne 0 ]; then
    return "$EXIT"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
getexitcode() {
  local EXITCODE="$?"
  test -n "$1" && test -z "${1//[0-9]/}" && local EXITCODE="$1" && shift 1
  if [ -n "$1" ]; then
    local PSUCCES="$1"
  elif [ -n "$SUCCES" ]; then
    local PSUCCES="$SUCCES"
  elif [ -n "$GETEXITCODE_SUCCES" ]; then
    local PSUCCES="$GETEXITCODE_SUCCES"
  else
    local PSUCCES="Command successful"
  fi
  if [ -n "$2" ]; then
    local PERROR="$2"
  elif [ -n "$ERROR" ]; then
    local PERROR="$ERROR"
  elif [ -n "$GETEXITCODE_ERROR" ]; then
    local PSUCCES="$GETEXITCODE_ERROR"
  else
    local PERROR="Last command failed to complete"
  fi
  if [ "$EXITCODE" -eq 0 ]; then
    printf_cyan "$PSUCCES"
  else
    printf_red "$PERROR"
  fi
  returnexitcode "$EXITCODE"
  return "$EXITCODE"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
failexitcode() {
  local RETVAL="$?"
  test -n "$1" && test -z "${1//[0-9]/}" && local RETVAL="$1" && shift 1
  [ -n "$1" ] && local fail="$1" || local fail="Command has failed"
  [ -n "$2" ] && local success="$2" || local success=""
  if [ "$RETVAL" -ne 0 ]; then
    set -E
    printf_error "$fail\n"
    exit ${RETVAL:-1}
  else
    set +E
    [ -z "$success" ] || printf_custom "42" "$success"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
setexitstatus() {
  local EXIT=$?
  set -x
  export EXITSTATUS=$((${EXIT} + ${EXITSTATUS:-0}))
  if [ -z "$EXITSTATUS" ] || [ "$EXITSTATUS" -ne 0 ]; then
    BG_EXIT="${BG_RED}"
    return 0
  else
    BG_EXIT="${BG_GREEN}"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getip() {
  local CHANGE_IP_VAR_DIR="" IFCONFIG""
  if [[ "$OSTYPE" =~ ^darwin ]]; then
    NETDEV="$(route get default 2>/dev/null | grep interface | awk '{print $2}')"
  else
    NETDEV="$(ip route 2>/dev/null | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}' | head -n1 | grep '^' || echo 'eth0')"
  fi
  IFCONFIG="$(builtin type -P /sbin/ifconfig || builtin type -P ifconfig)"
  if [ -f "$IFCONFIG" ]; then
    # net-tools package
    CURRENT_IP_4="$(/sbin/ifconfig $NETDEV 2>/dev/null | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed s/addr://g | head -n1 | grep '^')"
    CURRENT_IP_6="$(/sbin/ifconfig $NETDEV 2>/dev/null | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1 | grep '^')"
  else
    CURRENT_IP_4="$(ip -o -f inet address show $NETDEV | awk -F'/' '{print $1}' | awk '{print $NF}' | head -n 1 | grep '^')"
    CURRENT_IP_6="$(ip -o -f inet6 address show $NETDEV | awk -F'/' '{print $1}' | awk '{print $NF}' | head -n 1 | grep '^')"
  fi
  [ -n "$NETDEV" ] || NETDEV="lo"
  [ -n "$CURRENT_IP_4" ] || CURRENT_IP_4="127.0.0.1"
  [ -n "$CURRENT_IP_6" ] || CURRENT_IP_6="::1"
}
__getip 2>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getpythonver() {
  if builtin type -P python3 &>/dev/null; then
    PYTHONBIN="python3"
  elif builtin type -P python2 &>/dev/null; then
    PYTHONBIN="python2"
  else
    PYTHONBIN="python"
  fi
  [ -n "$PYTHONBIN" ] || return 1
  if [[ "$($PYTHONBIN -V 2>/dev/null)" =~ "Python 3" ]]; then
    PYTHONVER="python3"
    PIP="pip3"
    PATH="${PATH}:$($PYTHONBIN -c 'import site; print(site.USER_BASE)')/bin"
  elif [[ "$($PYTHONBIN -V 2>/dev/null)" =~ "Python 2" ]]; then
    PYTHONVER="python"
    PIP="pip"
    PATH="${PATH}:$($PYTHONBIN -c 'import site; print(site.USER_BASE)')/bin"
  fi
  if [ -f "$(builtin type -P yay 2>/dev/null)" ] || [ -f "$(builtin type -P pacman 2>/dev/null)" ]; then
    PYTHONVER="python"
    PIP="pip3"
  fi
  [ -n "$PYTHONVER" ] || PYTHONVER=python3
  [ -n "$PIP" ] || PIP=pip3
}
__getpythonver
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__getphpver() {
  if [ -f "$(builtin type -P php 2>/dev/null)" ]; then
    PHPVER="$(php -v | grep --only-matching --perl-regexp "(PHP )\d+\.\\d+\.\\d+" | cut -c 5-7)"
  else
    PHPVER=""
  fi
  echo $PHPVER
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__sudo() { sudo "$*"; }
sudorun() { if sudoif; then sudo -HE "$@"; else "$@"; fi; }
sudoif() { (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
user_is_root() {
  if [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; then
    return 0
  else
    return 1
  fi
}
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
can_i_sudo() {
  (
    ISINDSUDO=$(sudo grep -Re "$MYUSER" /etc/sudoers* | grep "ALL" 2>/dev/null)
    sudo -vn && sudo -ln
  ) 2>&1 | grep -v 'may not' >/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudoask() {
  if [ ! -f "$HOME/.sudo" ]; then
    [ -z "$(builtin type -P ask_for_password 2>/dev/null)" ] || ask_for_password
    while true; do
      echo -e "$!" >"$HOME/.sudo"
      sudo -n true && echo -e "$$" >>"$HOME/.sudo"
      sleep 10
      rm -Rf "$HOME/.sudo"
      kill -0 "$$" || return
    done &>/dev/null &
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sudoexit() {
  local exitCode=$?
  if [ $exitCode -eq 0 ]; then
    sudoask || printf_green "Getting privileges successful continuing" &&
      sudo -n true
  else
    printf_red "Failed to get privileges"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
requiresudo() {
  if [ -f "$(builtin type -P sudo 2>/dev/null)" ]; then
    if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
      sudoask
      sudoexit && sudo "$*"
    fi
  else
    printf_red "You dont have access to sudo Please contact the syadmin for access"
    exit 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
addtocrontab() {
  [ "$1" = "--help" ] && printf_help 'addtocrontab "frequency" "command" | IE: addtocrontab "0 4 * * *" "echo hello"'
  local frequency="$1"
  local command="$2"
  local additional="$3"
  local job="$frequency $command $additional"
  cat <(grep -F -i -v "$command" <(crontab -l)) <(echo "$job") | crontab - &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
crontab_add() {
  local appname="${APPNAME:-$1}"
  local action="${action:-$1}"
  local file="${file:-$appname}"
  local frequency="${frequency:-0 4 * * *}"
  case "$action" in
  remove)
    shift 1
    if [ $EUID -ne 0 ]; then
      printf_green "Removing $file from $WHOAMI crontab"
      crontab -l | grep -v -F "$file" | crontab - &>/dev/null
      printf_custom "2" "$file has been removed from automatically updating"
    else
      printf_green "Removing $file from root crontab"
      sudo -HE crontab -l | grep -v -F "$file" | sudo -HE crontab - &>/dev/null
      printf_custom "2" "$file has been removed from automatically updating"
    fi
    ;;

  add)
    shift 1
    [ -f "$file" ] || printf_exit "1" "Can not find $file"
    if [ "$EUID" -ne 0 ]; then
      local croncmd="logr"
      local additional='bash -c "sleep $(expr $RANDOM \% 300) && '$file' &"'
      printf_green "Adding $frequency $croncmd $additional to $WHOAMI crontab"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove"
    else
      local croncmd="logr"
      local additional='bash -c "sleep $(expr $RANDOM \% 300) && '$file' &"'
      printf_green "Adding $frequency $croncmd $additional to root crontab"
      sudo -HE crontab -l | grep -qv -F "$croncmd"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove"
    fi
    ;;

  *)
    [ -f "$file" ] || printf_exit "1" "Can not find $file"
    if [ "$EUID" -ne 0 ]; then
      local croncmd="logr"
      local additional='bash -c "sleep $(expr $RANDOM \% 300) && '$file' &"'
      printf_green "Adding $frequency $croncmd $additional to $WHOAMI crontab"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove"
    else
      local croncmd="logr"
      local additional='bash -c "sleep $(expr $RANDOM \% 300) && '$file' &"'
      printf_green "Adding $frequency $croncmd $additional to root crontab"
      sudo -HE crontab -l | grep -qv -F "$croncmd"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove"
    fi
    ;;
  esac
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
versioncheck() {
  local choice=""
  if [ -f "$INSTDIR/version.txt" ]; then
    printf_green "Checking for updates"
    local NEWVERSION="$(echo $APPVERSION | grep -shv "#" | tail -n 1)"
    local OLDVERSION="$(grep -shv "#" $INSTDIR/version.txt | tail -n 1)"
    if [ "$NEWVERSION" == "$OLDVERSION" ]; then
      printf_green "No updates available currentversion is $OLDVERSION"
    else
      printf_blue "There is an update available"
      printf_blue "New version is $NEWVERSION and currentversion is $OLDVERSION"
      printf_question_timeout "4" "Would you like to update" "1" "choice" "-s"
      if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        if [ -f "$INSTDIR/install.sh" ] && bash -c "$INSTDIR/install.sh"; then
          echo
          exitCode=0
        elif [ -d "$INSTDIR/.git" ] && git -C "$INSTDIR" pull -q; then
          printf_green "Updated to $NEWVERSION"
          exitCode=0
        else
          printf_red "Failed to update"
          exitCode=1
        fi
      else
        printf_cyan "You decided not to update"
        exitCode=1
      fi
    fi
  fi
  exit ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
scripts_check() {
  local choice=""
  export -f __curl
  mkdir -p "$HOME/.config/local"
  if [ -z "$(builtin type -P pkmgr 2>/dev/null)" ] && [ ! -f "$HOME/.config/local/noscripts" ]; then
    printf_red "Please install my scripts repo - requires root/sudo"
    printf_question_timeout "4" "Would you like to do that now" "1" "choice" "-s"
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
      urlverify "$SYSTEMMGRREPO/installer/raw/$GIT_REPO_BRANCH/install.sh" &&
        sudo -HE bash -c "$(curl -q -LSsf "$SYSTEMMGRREPO/installer/raw/$GIT_REPO_BRANCH/install.sh")" && echo
    else
      touch "$HOME/.config/local/noscripts"
      exit 1
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
is_url() { echo "$1" | grep -qE 'http://|ftp://|git://|https://'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# strip_url() {
#   echo "$1" | sed 's#git+##g' | awk -F//*/ '{print $2}' | sed 's#.*./##g' | sed 's#python-##g'
# }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
git_repo_urls() {
  REPO="${REPO:-https://github.com/dfmgr}"
  REPORAW="${REPORAW:-$REPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
git_clone() {
  if __am_i_online; then
    local repo="$1"
    local myappdir="${2:-$INSTDIR}"
    if [ ! -d "$myappdir/.git" ]; then
      rm_rf "$myappdir"
    fi
    devnull git clone -q --recursive "$repo" "$myappdir"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
git_update() {
  local setrepo=""
  [ $# -eq 2 ] && setrepo="$1" && myappdir="$2" && shift 2
  __am_i_online || return 1
  local myappdir="${1:-$myappdir}"
  local myappdir="${myappdir:-$INSTDIR}"
  local exitCode="0"
  local repo="$([ -d "$myappdir/.git" ] && git -C "$myappdir" remote -v | grep fetch | head -n 1 | awk '{print $2}' || echo "$myappdir")"
  devnull git -C "$myappdir" reset --hard
  devnull git -C "$myappdir" pull --recurse-submodules
  devnull git -C "$myappdir" submodule update --init --recursive
  devnull git -C "$myappdir" reset --hard -q
  devnull git -C "$myappdir" pull --recurse-submodules && exitCode=0 || exitCode=1
  if [ "$exitCode" -ne 0 ] && [ -n "$repo" ] && [ ! -d "$myappdir/.git" ]; then
    rm_rf "$myappdir"
    git_clone "${setrepo:-$repo}" "$myappdir"
  fi
  unset myappdir repo
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dotfilesreqcmd() {
  local gitrepo="${DFMGRREPO:-https://github.com/dfmgr}/${1:-$conf}/raw/${GIT_REPO_BRANCH:-main}"
  urlverify "$gitrepo/install.sh" && bash -c "$(curl -q -LSsf $gitrepo/install.sh)" &>/dev/null
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dotfilesreqadmincmd() {
  sudo -n true || printf_exit "Can not get sudo privileges"
  local gitrepoadmin="${SYSTEMMGRREPO:-https://github.com/systemmgr}/${1:-$conf}/raw/${GIT_REPO_BRANCH:-main}"
  urlverify "$gitrepoadmin/install.sh" && sudo -HE bash -c "$(curl -q -LSsf $gitrepoadmin//install.sh)" &>/dev/null
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dotfilesreq() {
  local -a LISTARRAY=("$@")
  local SHARE="$HOME/.local/share"
  local SYSSHARE="/usr/local/share"
  local userconfdir="$SHARE/CasjaysDev/apps/dfmgr"
  local sysconfdir="$SYSSHARE/CasjaysDev/apps/dfmgr"
  for conf in "${LISTARRAY[@]}"; do
    local TMPINST="$TMPDIR/${conf}.inst.tmp"
    if [ -e "$userconfdir/$conf" ] || [ -e "$sysconfdir/$conf" ] || [ -f "$TMPINST" ]; then
      printf_cyan "[ ✅ ] Required dotfile $conf is installed 💠"
    else
      execute "dotfilesreqcmd $conf" "Installing required dotfile: $conf 💠"
    fi
  done
  unset conf
  run_cleanup
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dotfilesreqadmin() {
  local -a LISTARRAY=("$@")
  local SHARE="$HOME/.local/share"
  local SYSSHARE="/usr/local/share"
  local userconfdir="$SHARE/CasjaysDev/apps/systemmgr"
  local sysconfdir="$SYSSHARE/CasjaysDev/apps/systemmgr"
  for conf in "${LISTARRAY[@]}"; do
    local TMPINST="$TMPDIR/${conf}.inst.tmp"
    if [ -e "$userconfdir/$conf" ] || [ -e "$sysconfdir/$conf" ] || [ -f "$TMPINST" ]; then
      printf_cyan "[ ✅ ] Required system configuration $conf is installed 💠"
    else
      execute "dotfilesreqadmincmd $conf" "Installing required system: $conf 💠"
    fi
  done
  unset conf
  run_cleanup
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__devnull() { tee &>/dev/null && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__saved_file_create() { sudo touch "${PKMGR_INSTALLED_LIST_DIR:-/usr/local/etc/pkmgr/lists}/$1" || true; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
gem_exists() {
  [ -n "$(builtin type -P gem 2>/dev/null)" ] || return
  local package="$1"
  gem list | grep -q "$package" && return 0 || cmd_missing "$package" &>/dev/null || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
npm_exists() {
  [ -n "$(builtin type -P npm 2>/dev/null || builtin type -P yarn || builtin type -P pnpm || echo '')" ] || return
  local package="$1"
  if __cmd_exists npm && npm list -g --depth=0 2>&1 | grep -q "$package@"; then
    return 0
  elif __cmd_exists yarn && yarn list -g --depth=0 2>&1 | grep -q "$package"; then
    return 0
  elif __cmd_exists pnpm && pnpm list -g --depth=0 2>&1 | grep -q "$package"; then
    return 0
  elif __cmd_exists "$package"; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
perl_exists() {
  [ -n "$(builtin type -P perl 2>/dev/null)" ] || return
  local package="${1//perl-/}"
  if devnull perl -M$package -le 'print $INC{"$package/Version.pm"}' ||
    devnull perl -M$package -le 'print $INC{"$package.pm"}' ||
    devnull perl -M$package -le 'print $INC{"$package"}' || cmd_missing "$package" &>/dev/null; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
python_exists() {
  local package="$1"
  local py="$(builtin type -P python3 2>/dev/null || builtin type -P python2 2>/dev/null || builtin type -P python 2>/dev/null)"
  if [ -n "$py" ]; then
    if [ "$($py -c 'import pkgutil; print(0 if pkgutil.find_loader("$package") else 1)')" = 0 ]; then
      return 0
    elif cmd_missing "$package" &>/dev/null; then
      return 0
    else
      return 0
    fi
    return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cmd_missing() {
  if builtin type -P "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cpan_missing() {
  if perl_exists "$1"; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
gem_missing() {
  if gem_exists "$1"; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
npm_missing() {
  if npm_exists "$1"; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
perl_missing() {
  if perl_exists "$1"; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pip_missing() {
  if python_exists "$1"; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
python_missing() {
  if python_exists "$1"; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_latest_release() { latest-releases "$@" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_aur() {
  local REQUIRED="$*"
  local cmd="" MISSING=""
  [ -f "$(builtin type -P yay 2>/dev/null)" ] || return 0
  if [ -f "$(builtin type -P pkmgr 2>/dev/null)" ]; then
    for cmd in $REQUIRED; do
      [ -f "/usr/local/etc/pkmgr/lists/$cmd" ] || builtin type -P "$cmd" &>/dev/null || MISSING+="$cmd "
    done
    if [ -n "$MISSING" ]; then
      printf_warning "Attempting to install missing packages as $RUN_USER"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr --enable-log --enable-aur silent install $miss" "Installing $miss" || false
        [ $? -eq 0 ] && __saved_file_create "$miss"
      done
    fi
  fi
  unset MISSING
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_required() {
  local name="$APPNAME"
  local REQUIRED="$*"
  local MISSING=""
  local cmd=""
  [ "$SCRIPTS_PREFIX" = "dfmgr" ] || [ "$SCRIPTS_PREFIX" = "systemmgr" ] || return 0
  for cmd in $REQUIRED; do
    [ -f "/usr/local/etc/pkmgr/lists/$cmd" ] || builtin type -P "$cmd" &>/dev/null || MISSING+="$cmd "
  done
  if [ -n "$MISSING" ]; then
    if [ -f "$(builtin type -P pkmgr 2>/dev/null)" ]; then
      printf_yellow "Still missing: $MISSING"
      printf_yellow "Installing from package list"
      if pkmgr --enable-log dotfiles "$name" 2>/dev/null; then
        exitCode=0
      elif builtin type -pt $name | grep -q 'function'; then
        printf_green "$ICON_GOOD $name is installed but it seems to be a function"
        exitCode=0
      else
        exitCode=1
        false
      fi
      if [ $exitCode -eq 0 ]; then
        REQUIRED="${REQUIRED//$miss/}"
        __saved_file_create "$miss"
      else
        printf_red "$ICON_ERROR $name failed to install" >&2
        false
      fi
    fi
    unset MISSING
    for cmd in $REQUIRED; do
      builtin type -p "$cmd" &>/dev/null || MISSING+="$cmd "
    done
  fi
  if [ -n "$MISSING" ]; then
    printf_warning "Can not install all the required packages for $name"
    return 1
  fi
  unset MISSING
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_packages() {
  local REQUIRED="$*"
  local MISSING=""
  local cmd=""
  if [ -f "$(builtin type -P pkmgr 2>/dev/null)" ]; then
    for cmd in $REQUIRED; do
      [ -f "/usr/local/etc/pkmgr/lists/$cmd" ] || builtin type -P "$cmd" &>/dev/null || MISSING+="$cmd "
    done
    if [ -n "$MISSING" ]; then
      printf_warning "Attempting to install missing packages as $RUN_USER"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr --enable-log silent install $miss" "Installing $miss" || false
        [ $? -eq 0 ] && __saved_file_create "$miss" || rm_rf "/usr/local/etc/pkmgr/lists/$cmd"
      done
    fi
  fi
  [ -z "$m" ] || exitCode=1
  unset MISSING m
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_python() {
  local REQUIRED="$*"
  local MISSING=""
  local cmd=""
  __getpythonver
  [ -f "$(builtin type -P pacman 2>/dev/null)" ] && prepend="python" || prepend="$PYTHONVER"
  for cmd in $REQUIRED; do
    python_missing "$cmd" || MISSING+="$prepend-$cmd "
  done
  if [ -n "$MISSING" ]; then
    if [ -n "$(builtin type -P pkmgr 2>/dev/null)" ]; then
      printf_warning "Attempting to install missing python packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr --enable-log silent install $miss" "Installing $miss"
      done
    fi
  fi
  unset MISSING
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_perl() {
  local REQUIRED="$*"
  local MISSING=""
  local cmd=""
  for cmd in $REQUIRED; do
    perl_missing "$cmd" || MISSING+="$(echo "perl-$1" | sed 's#::#-#g') "
  done
  if [ -n "$MISSING" ]; then
    if [ -f "$(builtin type -P pkmgr 2>/dev/null)" ]; then
      printf_warning "Attempting to install missing perl packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr --enable-log perl install $miss" "Installing $miss"
      done
    fi
  fi
  unset MISSING
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_pip() {
  local REQUIRED="$*"
  local MISSING=""
  local cmd=""
  for cmd in $REQUIRED; do
    pip_missing "$cmd" || MISSING+="$cmd "
  done
  if [ -n "$MISSING" ]; then
    if [ -f "$(builtin type -P pkmgr 2>/dev/null)" ]; then
      printf_warning "Attempting to install missing pip packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr --enable-log pip install $miss" "Installing $miss"
      done
    fi
  fi
  unset MISSING
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_npm() {
  local REQUIRED="$*"
  local MISSING=""
  local cmd=""
  for cmd in $REQUIRED; do
    npm_missing "$cmd" || MISSING+="$cmd "
  done
  if [ -n "$MISSING" ]; then
    if [ -f "$(builtin type -P pkmgr 2>/dev/null)" ]; then
      printf_warning "Attempting to install missing npm packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr --enable-log npm install $miss" "Installing $miss"
      done
    fi
  fi
  unset MISSING
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_cpan() {
  local REQUIRED="$*"
  local MISSING=""
  local cmd=""
  for cmd in $REQUIRED; do
    cpan_missing "$cmd" || MISSING+="$cmd "
  done
  if [ -n "$MISSING" ]; then
    if [ -f "$(builtin type -P pkmgr 2>/dev/null)" ]; then
      printf_warning "Attempting to install missing cpan packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr --enable-log cpan install $miss" "Installing $miss"
      done
    fi
  fi
  unset MISSING
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_gem() {
  local REQUIRED="$*"
  local MISSING=""
  local cmd=""
  for cmd in $REQUIRED; do
    gem_missing "$cmd" || MISSING+="$cmd "
  done
  if [ -n "$MISSING" ]; then
    if [ -f "$(builtin type -P pkmgr 2>/dev/null)" ]; then
      printf_warning "Attempting to install missing gem packages"
      printf_warning "$MISSING"
      for miss in $MISSING; do
        execute "pkmgr --enable-log gem install $miss" "Installing $miss"
      done
    fi
  fi
  unset MISSING
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_php() {
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
trim() {
  local IFS=' '
  local trimmed="${*//[[:space:]]/}"
  echo "$trimmed"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
execute() {
  [ -n "$_DEBUG" ] && set -x
  kill_all_subprocesses() {
    [ -n "$_DEBUG" ] && set -x
    local i=""
    for i in $(jobs -p); do
      kill "$i"
      wait "$i" &>/dev/null
    done
  }
  show_spinner() {
    [ -n "$_DEBUG" ] && set -x
    local -r FRAMES='/-\|'
    local -r NUMBER_OR_FRAMES=${#FRAMES}
    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"
    local i=0
    local frameText=""
    while kill -0 "$PID" &>/dev/null; do
      frameText="[${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
      printf "%s" "$frameText"
      sleep 0.2
      printf "\r"
    done
  }
  local -r CMDS="$1"
  local -r MSG="${2:-$1} "
  local -r CMD="$(echo "$1" | awk '{print $1}')"
  local exitCode=0
  local cmdsPID=""
  set_trap "EXIT" "kill_all_subprocesses"
  eval "$CMDS" >>"$INSTALLER_LOG_FILE" 2>"$INSTALLER_ERR_FILE" &
  cmdsPID=$!
  show_spinner "$cmdsPID" "$CMDS" "$MSG"
  wait "$cmdsPID" &>/dev/null
  exitCode=$?
  printf_execute_result $exitCode "$MSG"
  if [ $exitCode -ne 0 ]; then
    printf_execute_error_stream <"$INSTALLER_ERR_FILE"
    [ -s "$INSTALLER_LOG_FILE" ] && rm -Rf "$INSTALLER_LOG_FILE" || true
    [ -s "$INSTALLER_TMP_FILE" ] && rm -Rf "$INSTALLER_ERR_FILE" || true
  else
    [ -f "$INSTALLER_LOG_FILE" ] && rm -Rf "$INSTALLER_LOG_FILE" || true
    [ -f "$INSTALLER_TMP_FILE" ] && rm -Rf "$INSTALLER_ERR_FILE" || true
  fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
os_support() {
  local OSTYPE=
  if [ -n "$1" ]; then
    OSTYPE="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  else
    OSTYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
  fi
  case "$OSTYPE" in
  linux*) echo "Linux" || return 1 ;;
  mac* | darwin*) echo "MacOS" || return 1 ;;
  win* | msys* | mingw* | cygwin*) echo "Windows" || return 1 ;;
  bsd*) echo "BSD" || return 1 ;;
  solaris*) echo "Solaris" || return 1 ;;
  *) return 0 ;;
  esac
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
supported_os() {
  [ $# -ne 0 ] || return 0
  for OSes in "$@"; do
    local app=${APPNAME:-$PROG}
    if_os "$OSes" && OS_IS_SUPPORTED="true"
  done
  [ "$OS_IS_SUPPORTED" = "true" ] && return || printf_exit 1 1 "$app does not support your OS"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
unsupported_oses() {
  [ $# -ne 0 ] || return 0
  local cur_os="" os_sup=""
  for OSes in "$@"; do
    os_sup="$(os_support | tr '[:upper:]' '[:lower:]')"
    cur_os="$(echo "$OSes" | tr '[:upper:]' '[:lower:]')"
    if [ "$cur_os" = "$os_sup" ]; then
      OS_IS_SUPPORTED="false"
    fi
  done
  [ "$OS_IS_SUPPORTED" != "false" ] && return || printf_exit 1 1 "$app does not support your OS"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if_os() {
  [ $# -ne 0 ] || return 0
  local OS="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  local UNAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
  case "$OS" in
  linux*)
    if [ "$UNAME" = "linux" ]; then
      return 0
    else
      return 1
    fi
    ;;

  mac*)
    if [ "$UNAME" = "darwin" ]; then
      return 0
    else
      return 1
    fi
    ;;
  win*)
    if [ "$UNAME" = "ming" ] || [ "$UNAME" = "WindowsNT" ]; then
      return 0
    else
      return 1
    fi
    ;;
  *)
    return 1
    ;;
  esac
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if_os_id() {
  local distroname="" distroversion="" distro_id="" distro_version="" in="" def="" args=""
  if [ "$(uname -s 2>/dev/null)" = "Darwin" ] && builtin type -P sw_vers &>/dev/null; then
    distroname="darwin"
    distroversion="$(sw_vers -productVersion)"
  elif [ -f "/etc/os-release" ]; then
    #local distroname=$(grep "ID_LIKE=" /etc/os-release | sed 's#ID_LIKE=##' | tr '[:upper:]' '[:lower:]' | sed 's#"##g' | awk '{print $1}')
    distroname=$(grep '^ID=' /etc/os-release | sed 's#ID=##g' | sed 's#"##g' | tr '[:upper:]' '[:lower:]')
    distroversion=$(grep '^VERSION="' /etc/os-release | sed 's#VERSION="##g;s#"##g')
    codename="$(grep 'VERSION_CODENAME' /etc/os-release && grep '^VERSION_CODENAME' /etc/os-release | sed 's#VERSION_CODENAME="##g;s#"##g' || true)"
  elif [ -f "/etc/redhat-release" ]; then
    distroname=$(awk '{print $1}' /etc/redhat-release | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
    distroversion=$(awk '{print $4}' /etc/redhat-release | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
  elif builtin type -P lsb_release &>/dev/null; then
    distroname="$(lsb_release -a 2>/dev/null | grep 'Distributor ID' | awk '{print $3}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
    distroversion="$(lsb_release -a 2>/dev/null | grep 'Release' | awk '{print $2}')"
  elif builtin type -P lsb-release &>/dev/null; then
    distroname="$(lsb-release -a 2>/dev/null | grep 'Distributor ID' | awk '{print $3}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
    distroversion="$(lsb-release -a 2>/dev/null | grep 'Release' | awk '{print $2}')"
  else
    return 1
  fi
  in="$*"
  def="${DISTRO}"
  args="$(echo "${*:-$def}" | tr '[:upper:]' '[:lower:]')"
  for id_like in $args; do
    case "$id_like" in
    alpine*)
      if [[ $distroname =~ ^alpine ]] || [[ "$distroname" = "Alpine Linux" ]]; then
        distro_id="alpine"
        distro_version="$(cat /etc/os-release | grep '^VERSION_ID=' | sed 's#VERSION_ID=##g')"
        return 0
      else
        return 1
      fi
      ;;
    arch* | arco*)
      if [[ $distroname =~ ^arco ]] || [[ "$distroname" =~ ^arch ]]; then
        distro_id="Arch"
        distro_version="$(cat /etc/os-release | grep '^BUILD_ID' | sed 's#BUILD_ID=##g')"
        return 0
      else
        return 1
      fi
      ;;
    rhel* | centos* | fedora* | rocky* | ol* | oracle* | redhat* | scientific* | alma*)
      if [[ "$distroname" =~ ^scientific ]] || [[ "$distroname" =~ ^redhat ]] || [[ "$distroname" =~ ^centos ]] || [[ "$distroname" =~ ^casjay ]] || [[ "$distroname" =~ ^rocky ]] || [[ "$distroname" =~ ^alma ]]; then
        distro_id="RHEL"
        distro_version="$distroversion"
        return 0
      else
        return 1
      fi
      ;;
    debian* | ubuntu*)
      if [[ "$distroname" =~ ^kali ]] || [[ "$distroname" =~ ^parrot ]] || [[ "$distroname" =~ ^debian ]] || [[ "$distroname" =~ ^raspbian ]] ||
        [[ "$distroname" =~ ^ubuntu ]] || [[ "$distroname" =~ ^linuxmint ]] || [[ "$distroname" =~ ^elementary ]] || [[ "$distroname" =~ ^kde ]]; then
        distro_id="Debian"
        distro_version="$distroversion"
        distro_codename="$codename"
        return 0
      else
        return 1
      fi
      ;;
    darwin* | mac*)
      if [[ "$distroname" =~ ^mac ]] || [[ "$distroname" =~ ^darwin ]]; then
        distro_id="MacOS"
        distro_version="$distroversion"
        return 0
      else
        return 1
      fi
      ;;
    *)
      return 1
      ;;
    esac
    # else
    #   return 1
    # fi
  done
  [ -n "$distro_id" ] || distro_id="Unknown"
  [ -n "$distro_version" ] || distro_version="Unknown"
  # [ -n "$codename" ] && distro_codename="$codename" || distro_codename="N/A"
  # echo $id_like $distroname $distroversion $distro_codename
}
###################### setup folders - user ######################
user_installdirs() {
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  APPNAME="${APPNAME:-installer}"
  REPORAW="${REPORAW:-}"
  if [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; then
    INSTALL_TYPE=user
    if [[ $(uname -s) =~ Darwin ]]; then HOME="/usr/local/home/root"; fi
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
  else
    INSTALL_TYPE=user
    HOME="${HOME:-/tmp/$USER}"
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
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="$HOME/Library/Fonts"; else FONTDIR="$SHARE/fonts"; fi
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  fi
  DOCKERMGR_HOME="${DOCKERMGR_HOME:-$HOME/.config/myscripts/dockermgr}"
  APPDIR="${APPDIR:-$HOME/.local/share/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$HOME/.local/share/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  installtype="user_installdirs"
  git_repo_urls
}
###################### setup folders - system ######################
system_installdirs() {
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  APPNAME="${APPNAME:-installer}"
  REPORAW="${REPORAW:-}"
  if [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; then
    if [[ $(uname -s) =~ Darwin ]]; then HOME="/usr/local/home/root"; fi
    BACKUPDIR="$HOME/.local/backups"
    BIN="/usr/local/bin"
    CONF="/usr/local/etc"
    SHARE="/usr/local/share"
    LOGDIR="/usr/local/log"
    STARTUP="/dev/null"
    SYSBIN="/usr/local/bin"
    SYSCONF="/usr/local/etc"
    SYSSHARE="/usr/local/share"
    SYSLOGDIR="/usr/local/log"
    COMPDIR="/etc/bash_completion.d"
    THEMEDIR="/usr/local/share/themes"
    ICONDIR="/usr/local/share/icons"
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="/Library/Fonts"; else FONTDIR="/usr/local/share/fonts"; fi
    FONTCONF="/usr/local/share/fontconfig/conf.d"
    CASJAYSDEVSHARE="/usr/local/share/CasjaysDev"
    CASJAYSDEVSAPPDIR="/usr/local/share/CasjaysDev/apps"
    WALLPAPERS="/usr/local/share/wallpapers"
    USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  else
    INSTALL_TYPE=system
    HOME="${HOME:-/home/$WHOAMI}"
    BACKUPDIR="${BACKUPS:-$HOME/.local/backups}"
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="$HOME/.local/bin"
    SYSCONF="$HOME/.local/etc"
    SYSSHARE="$HOME/.local/share"
    SYSLOGDIR="$HOME/.local/log"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$HOME/.local/share/themes"
    ICONDIR="$HOME/.local/share/icons"
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="$HOME/Library/Fonts"; else FONTDIR="$HOME/.local/share/fonts"; fi
    FONTCONF="$HOME/.local/share/fontconfig/conf.d"
    CASJAYSDEVSHARE="$HOME/.local/share/CasjaysDev"
    CASJAYSDEVSAPPDIR="$HOME/.local/share/CasjaysDev/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$HOME/.local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$HOME/.local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  fi
  APPDIR="${APPDIR:-$HOME/.local/share/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$HOME/.local/share/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  installtype="system_installdirs"
  git_repo_urls
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ensure_dirs() {
  if [ $EUID -ne 0 ] || [ "$WHOAMI" != "root" ]; then
    mkd "$BIN"
    mkd "$SHARE"
    mkd "$LOGDIR"
    mkd "$LOGDIR/dfmgr"
    mkd "$LOGDIR/fontmg"
    mkd "$LOGDIR/iconmgr"
    mkd "$LOGDIR/systemmgr"
    mkd "$LOGDIR/thememgr"
    mkd "$LOGDIR/wallpapermgr"
    mkd "$COMPDIR"
    mkd "$STARTUP"
    mkd "$BACKUPDIR"
    mkd "$FONTDIR"
    mkd "$ICONDIR"
    mkd "$THEMEDIR"
    mkd "$FONTCONF"
    mkd "$CASJAYSDEVSHARE"
    mkd "$CASJAYSDEVSAPPDIR"
    mkd "$USRUPDATEDIR"
    mkd "$SHARE/applications"
    mkd "$SHARE/CasjaysDev/functions"
    mkd "$SHARE/wallpapers/system"
    user_is_root && mkd "$SYSUPDATEDIR"
  fi
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ensure_perms() {
  if user_is_root; then
    local SUDO_USER="${SUDO_USER:-$USER}"
    chown -Rf "${SUDO_USER:-$WHOAMI}":"${SUDO_USER:-$WHOAMI}" "$HOME/.local/log"
    chown -Rf "${SUDO_USER:-$WHOAMI}":"${SUDO_USER:-$WHOAMI}" "$HOME/.local/backups"
    chown -Rf "${SUDO_USER:-$WHOAMI}":"${SUDO_USER:-$WHOAMI}" "$HOME/.local/share/CasjaysDev"
    chmod -Rf 755 "$HOME/.local/bin/"
  fi
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
get_app_version() {
  if [ -f "$INSTDIR/version.txt" ]; then
    local version="$(grep -shv "#" "$INSTDIR/version.txt" | tail -n 1)"
  else
    local version="0000000"
  fi
  local GITREPO="${REPORAW}"
  local APPVERSION="${APPVERSION:-$(__appversion "$REPORAW/version.txt")}"
  [ -n "$WHOAMI" ] && printf_info "WhoamI:                    $WHOAMI"
  [ -n "$INSTALL_TYPE" ] && printf_info "Install Type:              $INSTALL_TYPE"
  [ -n "$APPNAME" ] && printf_info "APP name:                  $APPNAME"
  [ -n "$APPDIR" ] && printf_info "APP dir:                   $APPDIR"
  [ -n "$INSTDIR" ] && printf_info "Downloaded to:             $INSTDIR"
  [ -n "$GITREPO" ] && printf_info "APP repo:                  $REPO"
  [ -n "$PLUGNAMES" ] && printf_info "Plugins:                   $PLUGNAMES"
  [ -n "$PLUGIN_DIR" ] && printf_info "PluginsDir:                $PLUGIN_DIR"
  [ -n "$version" ] && printf_info "Installed Version:         $version"
  [ -n "$APPVERSION" ] && printf_info "Online Version:            $APPVERSION"
  if [ "$version" = "$APPVERSION" ]; then
    printf_info "Update Available:          No"
  else
    printf_info "Update Available:          Yes"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
app_uninstall() {
  if [ -d "$APPDIR" ]; then
    printf_yellow "Removing $APPNAME from your system"
    [ -d "$INSTDIR" ] && rm_rf "$INSTDIR"
    rm_rf "$APPDIR" &&
      rm_rf "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME" &&
      rm_rf "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" &&
      broken_symlinks $BIN $SHARE $COMPDIR $CONF
    getexitcode "$APPNAME has been removed"
  else
    printf_red "$APPNAME doesn't seem to be installed"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
show_optvars() {
  __main_installer_info &>/dev/null
  local SHORTOPTS="d"
  local LONGOPTS="installed,full,location,uninstall,remove,version,help,stow,cron:,update,debug,force,raw"
  setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$FUNCFILE" -- "$@" 2>/dev/null)
  eval set -- "${setopts[@]}" 2>/dev/null
  while :; do
    case "$1" in
    -d)
      shift 1
      export SCRIPT_OPTS=""
      export _DEBUG=""
      ;;
    --raw)
      shift 1
      export SHOW_RAW="true"
      unset -f printf_color
      printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[[0-9;]*[a-zA-Z],,g'; }
      ;;

    --force)
      shift 1
      FORCE_INSTALL="true"
      export FORCE_INSTALL
      ;;

    --debug)
      shift 1
      set -xo pipefail
      export SCRIPT_OPTS="--debug"
      export _DEBUG="on"
      __debugger "debug"
      ;;

    --update)
      shift 1
      versioncheck
      exit "$?"
      ;;

    --cron)
      shift 1
      [ "$1" = "help" ] && printf_help "Usage: $APPNAME --cron remove | add" && exit 0
      [ "$1" = "cron" ] && shift 1
      crontab_add "$*"
      exit "$?"
      ;;

    --stow)
      shift 1
      [ "$1" = "help" ] && config --help
      shift 1
      config add "$*"
      exit "$?"
      ;;

    --help)
      shift 1
      #    if [ -f "$(builtin type -P  2>/dev/null)" ] xdg-open; then
      #      xdg-open "$REPO"
      #    elif [ -f "$(builtin type -P  2>/dev/null)" ] open; then
      #      open "$REPO"
      #    else
      printf_cyan "Go to $REPO for help"
      #    fi
      exit
      ;;

    --version)
      shift 1
      get_app_version
      exit $?
      ;;

    --remove | --uninstall)
      shift 1
      app_uninstall
      exit $?
      ;;

    --location)
      shift 1
      printf_info "AppName:                   $APPNAME"
      printf_info "Installed to:              $APPDIR"
      printf_info "Downloaded to:             $INSTDIR"
      printf_info "UserHomeDir:               $HOME"
      printf_info "UserBinDir:                $BIN"
      printf_info "UserConfDir:               $CONF"
      printf_info "UserShareDir:              $SHARE"
      printf_info "UserLogDir:                $LOGDIR"
      printf_info "UserStartDir:              $STARTUP"
      printf_info "SysConfDir:                $SYSCONF"
      printf_info "SysBinDir:                 $SYSBIN"
      printf_info "SysConfDir:                $SYSCONF"
      printf_info "SysShareDir:               $SYSSHARE"
      printf_info "SysLogDir:                 $SYSLOGDIR"
      printf_info "SysBackUpDir:              $BACKUPDIR"
      printf_info "CompletionsDir:            $COMPDIR"
      printf_info "CasjaysDevDir:             $CASJAYSDEVSHARE"
      exit $?
      ;;

    --full)
      shift 1
      path_info() { echo "$PATH" | tr ':' '\n' | sort -u; }
      get_app_version
      printf_info "UserName:                  $USER"
      printf_info "RunAs USer:                $RUN_USER"
      printf_info "UserHomeDir:               $HOME"
      printf_info "UserBinDir:                $BIN"
      printf_info "UserConfDir:               $CONF"
      printf_info "UserShareDir:              $SHARE"
      printf_info "UserLogDir:                $LOGDIR"
      printf_info "UserStartDir:              $STARTUP"
      printf_info "SysConfDir:                $SYSCONF"
      printf_info "SysBinDir:                 $SYSBIN"
      printf_info "SysConfDir:                $SYSCONF"
      printf_info "SysShareDir:               $SYSSHARE"
      printf_info "SysLogDir:                 $SYSLOGDIR"
      printf_info "SysBackUpDir:              $BACKUPDIR"
      printf_info "ApplicationsDir:           $SHARE/applications"
      printf_info "IconDir:                   $ICONDIR"
      printf_info "ThemeDir                   $THEMEDIR"
      printf_info "FontDir:                   $FONTDIR"
      printf_info "FontConfDir:               $FONTCONF"
      printf_info "CompletionsDir:            $COMPDIR"
      printf_info "CasjaysDevDir:             $CASJAYSDEVSHARE"
      printf_info "CASJAYSDEVSAPPDIR:         $CASJAYSDEVSAPPDIR"
      printf_info "USRUPDATEDIR:              $USRUPDATEDIR"
      printf_info "SYSUPDATEDIR:              $SYSUPDATEDIR"
      printf_info "DOTFILESREPO:              $DOTFILESREPO"
      printf_info "DevEnv Repo:               $DEVENVMGRREPO"
      printf_info "Package Manager Repo:      $PKMGRREPO"
      printf_info "Icon Manager Repo:         $ICONMGRREPO"
      printf_info "Font Manager Repo:         $FONTMGRREPO"
      printf_info "Theme Manager Repo         $THEMEMGRREPO"
      printf_info "System Manager Repo:       $SYSTEMMGRREPO"
      printf_info "Wallpaper Manager Repo:    $WALLPAPERMGRREPO"
      printf_info "Downloaded to:             $INSTDIR"
      printf_info "REPORAW:                   $REPORAW"
      printf_info "Prefix:                    $SCRIPTS_PREFIX"
      for PATHS in $(path_info); do
        printf_info "PATH:                      $PATHS"
      done
      exit $?
      ;;

    --installed)
      shift 1
      printf_green "User                               Group                              AppName"
      ls -l "$CASJAYSDEVSAPPDIR/dotfiles" | tr -s ' ' | cut -d' ' -f3,4,9 |
        sed 's# #                               #g' | grep -v "total." |
        printf_readline "5"
      exit $?
      ;;
    --)
      shift 1
      break
      ;;
    esac
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
installer_noupdate() {
  __git_update() { [ -d "${1:-$INSTDIR}/.git" ] && git -C "${1:-$INSTDIR}" reset --hard -q &>/dev/null && git -C "${1:-$INSTDIR}" pull &>/dev/null && return 0 || return 1; }
  [ -n "$_DEBUG" ] && set -xeo
  [ "$1" = "--force" ] && return 0
  if [ "$FORCE_INSTALL" = "true" ]; then
    rm_rf "$APPDIR/.installed" "$INSTDIR/.installed"
    return 0
  fi
  if [ -f "$APPDIR/.installed" ] || [ -f "$INSTDIR/.installed" ]; then
    APPDIR="$INSTDIR"
    printf_yellow "Copying file of $APPNAME has been disabled"
    printf_yellow "This can be changed with the --force flag"
    printf_yellow "Updating the git repository only"
    ln_sf "$INSTDIR/install.sh" "$SYSUPDATEDIR/$APPNAME"
    [ -d "$INSTDIR/.git" ] || { rm -Rf "$INSTDIR" && git clone -q "$REPO" "$INSTDIR" &>/dev/null; }
    if __git_update "$INSTDIR"; then
      printf_cyan "$APPNAME has been updated"
      printf_newline ''
      exit 0
    else
      printf_red "Failed to update $INSTDIR"
      printf_newline ''
      exit 1
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__install_fonts() {
  [ -n "$_DEBUG" ] && set -x && echo __install_fonts
  if [ -d "$INSTDIR/fontconfig" ]; then
    local fontconfdir="$FONTCONF"
    ln_sf "$INSTDIR/fontconfig"/* "$fontconfdir/"
    [ -f "$(builtin type -P fc-cache 2>/dev/null)" ] && fc-cache -f "$FONTCONF"
  fi
  if [ -d "$HOME/Library/Fonts" ]; then
    local fontdir="$HOME/Library/Fonts"
  else
    local fontdir="$FONTDIR"
  fi
  if [ -d "$INSTDIR/fonts" ]; then
    [ -d "$fontdir/$APPNAME" ] && rm_rf "$fontdir/$APPNAME"
    find -L "$INSTDIR/fonts/" -mindepth 1 -maxdepth 1 -type f -name '*.*' -print0 |
      while IFS= read -r -d '' file; do
        filename="$(basename -- "$file")"
        ln_sf "$file" "$fontdir/$filename"
      done
    [ -f "$(builtin type -P fc-cache 2>/dev/null)" ] && fc-cache -f "$FONTDIR"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__install_icons() {
  [ -n "$_DEBUG" ] && set -x && echo __install_icons
  if [ -d "$INSTDIR/icons" ]; then
    local icondir="$ICONDIR"
    local icons="$(ls "$INSTDIR/icons" 2>/dev/null | wc -l)"
    if [ "$icons" != "0" ]; then
      find -L "$INSTDIR/icons/" -mindepth 1 -maxdepth 1 -type d -name '*.*' -print0 |
        while IFS= read -r -d '' file; do
          filename="$(basename -- "$file")"
          ln_sf "$file" "$icondir/$filename"
          find -L "$ICONDIR" -mindepth 1 -maxdepth 1 -type d | while read -r ICON; do
            if [ -f "$ICON/index.theme" ]; then
              [ -f "$(builtin type -P gtk-update-icon-cache 2>/dev/null)" ] && gtk-update-icon-cache -f -q "$ICON"
            fi
          done
        done
      devnull find "$ICONDIR" -type d -exec chmod 755 {} \;
      devnull find "$ICONDIR" -type f -exec chmod 644 {} \;
      [ -f "$(builtin type -P gtk-update-icon-cache 2>/dev/null)" ] && devnull gtk-update-icon-cache -q -t -f "$ICONDIR"
    fi
  fi
  return 0
}
__install_theme() {
  [ -n "$_DEBUG" ] && set -x && echo __install_theme
  if [ -d "$INSTDIR/theme" ]; then
    local themedir="$THEMEDIR"
    local theme="$(ls "$INSTDIR/theme" 2>/dev/null | wc -l)"
    mkd "$themedir/$APPNAME"
    if [ "$theme" != "0" ]; then
      fFiles="$(ls $INSTDIR/theme --ignore='.uuid')"
      for f in $fFiles; do
        ln_sf "$INSTDIR/theme/$f" "$themedir/$APPNAME/$f"
        find -L "$THEMEDIR" -mindepth 1 -maxdepth 2 -type d | while read -r THEME; do
          if [ -f "$THEME/index.theme" ]; then
            [ -f "$(builtin type -P gtk-update-icon-cache 2>/dev/null)" ] && gtk-update-icon-cache -f -q "$THEME"
          fi
        done
      done
    fi
    ln_rm "$THEMEDIR"
    find "$THEMEDIR" -mindepth 1 -maxdepth 2 -type d -not -path "*/.git/*" | while read -r THEME; do
      if [ -f "$THEME/index.theme" ]; then
        [ -f "$(builtin type -P gtk-update-icon-cache 2>/dev/null)" ] && gtk-update-icon-cache -f -q "$THEME"
      fi
    done
  fi
  return 0
}
__install_wallpapers() {
  [ -n "$_DEBUG" ] && set -x && echo __install_wallpapers
  if [ -d "$INSTDIR/images" ]; then
    mkdir -p "$WALLPAPERS/$APPNAME"
    local wallpapers="$(ls $INSTDIR/images/ 2>/dev/null | wc -l)"
    if [ "$wallpapers" != "0" ]; then
      wallpaperFiles="$(ls $INSTDIR/images/)"
      for wallpaper in $wallpaperFiles; do
        cp_rf "$INSTDIR/images/$wallpaper" "$WALLPAPERS/$APPNAME/$wallpaper"
      done
    fi
  fi

  # if [ -d "$INSTDIR/images" ]; then
  #   local wallpapers="$(ls $INSTDIR/images/ 2>/dev/null | wc -l)"
  #   local wallpaperdir="$WALLPAPERS/$APPNAME"
  #   if [ "$wallpapers" != "0" ]; then
  #     if [ "$INSTDIR" != "$APPDIR" ] && [ -e "$APPDIR" ]; then rm_rf "$APPDIR"; fi
  #     mkd "$wallpaperdir"
  #     find -L "$INSTDIR/images/" -mindepth 1 -maxdepth 1 -type d -name '*.*' -print0 |
  #       while IFS= read -r -d '' file; do
  #         filename="$(basename -- "$file")"
  #         cp_rf "$file" "$wallpaperdir/$filename"
  #       done
  #   fi
  # fi
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### devenv settings ######################
devenvmgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="devenvmgr"
  [ -n "$_DEBUG" ] && set -x && echo "$SCRIPTS_PREFIX"
  APPDIR="${APPDIR:-$SHARE/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  REPO="${REPO:-$DEVENVMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="devenvmgr_install"
}
######## Installer Functions ########
devenvmgr_run_init() {
  run_install_init "dev enviroment"
}
devenvmgr_run_post() {
  devenvmgr_install
  run_postinst_global
}
devenvmgr_install_version() {
  devenvmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
###################### dfmgr settings ######################
dfmgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="dfmgr"
  [ -n "$_DEBUG" ] && set -x && echo "$SCRIPTS_PREFIX"
  APPDIR="${APPDIR:-$CONF/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  REPO="${REPO:-$DFMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="dfmgr_install"
}
######## Installer Functions ########
dfmgr_run_init() {
  run_install_init "configurations"
}
dfmgr_run_post() {
  dfmgr_install
  run_postinst_global
}
dfmgr_install_version() {
  dfmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
###################### desktopmgr settings ######################
desktopmgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="desktopmgr"
  [ -n "$_DEBUG" ] && set -x && echo "$SCRIPTS_PREFIX"
  DESKTOPMGR_APPDIR="${DESKTOPMGR_APPDIR:-$CONF/$APPNAME}"
  DESKTOPMGR_INSTDIR="${DESKTOPMGR_INSTDIR:-$CASJAYSDEVSHARE/desktopmgr/$APPNAME}"
  DESKTOPMGR_REPO_BRANCH="${GIT_REPO_BRANCH:-main}"
  DESKTOPMGR_REPO="${DESKTOPMGR:-https://github.com/desktopmgr}/$APPNAME"
  DESKTOPMGR_REPORAW="${DESKTOPMGR_REPORAW:-$REPO/raw/$REPO_BRANCH}"
  DESKTOPMGR_APPVERSION="${DESKTOPMGR_APPVERSION:-$(__appversion "$REPORAW/version.txt")}"
  DESKTOPMGR_USRUPDATEDIR="${DESKTOPMGR_USRUPDATEDIR:-$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX}"
  DESKTOPMGR_SYSUPDATEDIR="${DESKTOPMGR_SYSUPDATEDIR:-$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && DESKTOPMGR_APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && DESKTOPMGR_INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$DESKTOPMGR_USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="desktopmgr_install"
}
######## Installer Functions ########
desktopmgr_run_init() {
  run_install_init "configurations"
}
desktopmgr_run_post() {
  desktopmgr_install
  run_postinst_global
}
desktopmgr_install_version() {
  desktopmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dockermgr_install() {
  user_installdirs
  #[ -f "$(builtin type -P docker 2>/dev/null)" ] || printf_exit 1 1 "This requires docker, however, docker wasn't found"
  SCRIPTS_PREFIX="dockermgr"
  [ -n "$_DEBUG" ] && set -x && echo "$SCRIPTS_PREFIX"
  APPNAME="${APPNAME:-}"
  REPO_BRANCH="${GIT_REPO_BRANCH:-main}"
  REPO="${REPO:-$DOCKERMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  DOCKER_HUB_IMAGE_TAG="${DOCKER_HUB_IMAGE_TAG:-latest}"
  DOCKER_REGISTRY_URL="${DOCKER_REGISTRY_URL:-docker.io}"
  DOCKER_REGISTRY_REPO_NAME="${DOCKER_REGISTRY_REPO_NAME:-$APPNAME}"
  DOCKER_REGISTRY_USER_NAME="${DOCKER_REGISTRY_USER_NAME:-casjaysdevdocker}"
  INSTDIR="${SET_INSTDIR-${INSTDIR:-$HOME/.local/share/CasjaysDev/dockermgr/$APPNAME}}"
  APPDIR="${SET_APPDIR:-${APPDIR:-/var/lib/srv/$USER/docker/$DOCKER_REGISTRY_USER_NAME/$DOCKER_REGISTRY_REPO_NAME/$DOCKER_HUB_IMAGE_TAG}}"
  DATADIR="${SET_DATADIR:-${DATADIR:-/var/lib/srv/$USER/docker/$DOCKER_REGISTRY_USER_NAME/$DOCKER_REGISTRY_REPO_NAME/$DOCKER_HUB_IMAGE_TAG}}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv ' #' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="dockermgr_install"
  [ -d "$HOME/.docker" ] || mkdir -p "$HOME/.docker" &>/dev/null
  [ -f "$HOME/.docker/config.json" ] || touch "$HOME/.docker/config.json" &>/dev/null
}
######## Installer Functions ########
dockermgr_run_init() {
  run_install_init "docker configurations"
}
dockermgr_run_post() {
  dockermgr_install
  # local NGINX_DIR="/etc/nginx/nginx.conf"
  # local NGINX_TMPL="$APPDIR/nginx/nginx.conf"
  # local NGINX_CONF="/etc/nginx/vhosts.d/$APPNAME.conf"
  # [ -f "$APPDIR/nginx/template" ] && NGINX_TMPL="$APPDIR/nginx/template"
  # [ -f "$APPDIR/nginx/proxy.conf" ] && NGINX_TMPL="$APPDIR/nginx/proxy.conf"
  # if [ -f "$NGINX_TMPL" ] && [ -f "$NGINX_DIR" ]; then
  #   sed -i "s|REPLACE_APPNAME|$APPNAME|g" "$NGINX_TMPL" &>/dev/null
  #   sed -i "s|REPLACE_NGINX_HTTP|$NGINX_HTTP|g" "$NGINX_TMPL" &>/dev/null
  #   sed -i "s|REPLACE_NGINX_HTTPS|$NGINX_HTTPS|g" "$NGINX_TMPL" &>/dev/null
  #   sed -i "s|REPLACE_SERVER_PORT|$SERVER_PORT|g" "$NGINX_TMPL" &>/dev/null
  #   sed -i "s|REPLACE_SERVER_LISTEN|$SERVER_LISTEN|g" "$NGINX_TMPL" &>/dev/null
  #   if [ -d "/etc/nginx/vhosts.d" ]; then [ -f "$NGINX_CONF" ] || ln_sf "$NGINX_TMPL" "$NGINX_CONF"; fi
  # fi
}
dockermgr_install_version() {
  dockermgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
fontmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="fontmgr"
  [ -n "$_DEBUG" ] && set -x && echo "$SCRIPTS_PREFIX"
  APPDIR="${APPDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  REPO="${REPO:-$FONTMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  FONTDIR="${FONTDIR:-$SHARE/fonts}"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="fontmgr_install"
}
######## Installer Functions ########
fontmgr_run_init() {
  run_install_init "fonts"
}
fontmgr_run_post() {
  fontmgr_install
  run_postinst_global
  __install_fonts
}
fontmgr_install_version() {
  fontmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
iconmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="iconmgr"
  APPDIR="${APPDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  REPO="${REPO:-$ICONMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="iconmgr_install"
}
######## Installer Functions ########
iconmgr_run_init() {
  run_install_init "icons"
}
iconmgr_run_post() {
  iconmgr_install
  run_postinst_global
  __install_icons
}
iconmgr_install_version() {
  iconmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
generate_icon_index() {
  iconmgr_install
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  [ -f "$(builtin type -P fc-cache 2>/dev/null)" ] && fc-cache -f "$ICONDIR"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pkmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="pkmgr"
  APPDIR="${APPDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  REPO="${REPO:-$PKMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  REPODF="https://raw.githubusercontent.com/pkmgr/dotfiles/$GIT_REPO_BRANCH"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="pkmgr_install"
}
######## Installer Functions ########
pkmgr_run_init() {
  run_install_init "packages"
}
pkmgr_run_post() {
  pkmgr_install
  run_postinst_global
}
pkmgr_install_version() {
  pkmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
systemmgr_install() {
  requiresudo "true" || { sudo -n true 2>&1 | grep -q ' required' && sudo true || printf_exit "sudo is required"; }
  system_installdirs
  SCRIPTS_PREFIX="systemmgr"
  APPDIR="${APPDIR:-/usr/local/etc/$APPNAME}"
  INSTDIR="${INSTDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  CONF="/usr/local/etc"
  SHARE="/usr/local/share"
  REPO="${REPO:-$SYSTEMMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  if [ "$APPNAME" = "scripts" ] || [ "$APPNAME" = "installer" ]; then
    APPDIR="/usr/local/share/CasjaysDev/scripts"
    INSTDIR="/usr/local/share/CasjaysDev/scripts"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="systemmgr_install"
}
######## Installer Functions ########
systemmgr_run_init() {
  sudoif || sudo true
  run_install_init "configurations"
  #printf_blue "running as user: $USER"
}
systemmgr_run_post() {
  systemmgr_install
  run_postinst_global
}
systemmgr_install_version() {
  systemmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
thememgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="thememgr"
  APPDIR="${APPDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  REPO="${REPO:-$THEMEMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  THEMEDIR="${THEMEDIR:-$SHARE/themes}"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="thememgr_install"
}
generate_theme_index() {
  thememgr_install
}
######## Installer Functions ########
thememgr_run_init() {
  run_install_init "theme"
}
thememgr_run_post() {
  thememgr_install
  run_postinst_global
  __install_theme
  generate_theme_index
}
thememgr_install_version() {
  thememgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
wallpapermgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="wallpapermgr"
  APPDIR="${APPDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  REPO="${REPO:-$WALLPAPERMGRREPO/$APPNAME}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="${ARRAY:-}"
  LIST="${LIST:-}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="wallpapermgr_install"
}
######## Installer Functions ########
wallpapermgr_run_init() {
  run_install_init "wallpapers"
}
wallpapermgr_run_post() {
  wallpapermgr_install
  run_postinst_global
  __install_wallpapers
}
wallpapermgr_install_version() {
  wallpapermgr_install
  install_version
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__main_installer_info() {
  if [ "$APPNAME" = "scripts" ] || [ "$APPNAME" = "installer" ]; then
    printf_cyan "Installing $APPNAME installer"
    APPNAME="scripts"
    APPDIR="/usr/local/share/CasjaysDev/scripts"
    INSTDIR="/usr/local/share/CasjaysDev/scripts"
    PLUGIN_DIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
    SYSBIN="/usr/local/bin"
    REPO="$SYSTEMMGRREPO/installer"
    REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install_init() {
  local exitCode=0
  local TMPDIR="${TMPDIR:-/tmp}"
  local APPNAME="${APPNAME:-$PROG}"
  local TMPFILE="$TMPDIR/$APPNAME.tmp"
  local TMPINST="$TMPDIR/$APPNAME.inst.tmp"
  [ -f "$TMPINST" ] && exit 5 || touch "$TMPINST"
  export APPDIR INSTDIR
  SET_SUDO_PROMPT="$(printf "\n\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m")"
  (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null || sudo -n true &>/dev/null || SUDO_PROMPT="$SET_SUDO_PROMPT" sudo true
  __main_installer_info &>/dev/null
  if [ -n "$PLUGNAMES" ]; then
    [ -z "$PLUGIN_DIR" ] || mkd "$PLUGIN_DIR"
  fi
  if [ ! -f "$TMPFILE" ]; then
    printf ""
    touch "$TMPFILE"
    if [ -f "$INSTDIR/install.sh" ]; then
      printf_yellow "Initializing the installer from"
      printf_purple "${INSTDIR/$HOME/\~}/install.sh"
    else
      printf_yellow "Downloading to ${INSTDIR/$HOME/\~}"
      printf_purple "$REPORAW/install.sh"
      if ! urlcheck "$REPORAW/install.sh"; then
        printf_error "Failed to initialize the installer from: $REPORAW/install.sh\n"
      fi
    fi
    if [ -d "$INSTDIR" ]; then
      printf_green "Updating ${1:-$APPNAME} in ${APPDIR//$HOME/\~}"
    else
      printf_green "Installing ${1:-$APPNAME} to ${APPDIR//$HOME/\~}"
    fi
    if [ "$INSTDIR" = "$APPDIR" ]; then
      printf_cyan "$ICON_INFO Note: The INSTDIR and APPDIR are the same"
      true
    else
      #printf_cyan "$ICON_INFO Copying files from $INSTDIR to $APPDIR"
      true
    fi
    local exitCode=$?
    [ "$exitCode" -eq 0 ] || exit 10
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_postinst_global() {
  $installtype
  # Only run on the scripts install
  if [ "$APPNAME" = "scripts" ] || [ "$APPNAME" = "installer" ]; then
    ln_rm "$SYSBIN/"
    ln_rm "$COMPDIR/"
    if [ -d "$INSTDIR/bin" ]; then
      local bin="$(ls $INSTDIR/bin/ 2>/dev/null | wc -l)"
      if [ "$bin" != "0" ]; then
        bFiles="$(ls $INSTDIR/bin)"
        for b in $bFiles; do
          chmod -Rf 755 "$INSTDIR/bin/$app"
          ln_sf "$INSTDIR/bin/$b" "$SYSBIN/$b"
        done
      fi
      ln_rm "$BIN/"
    fi
    [ -f "$(builtin type -P updatedb 2>/dev/null)" ] && sudo updatedb || true
  else # Run on everything else
    if [ "$APPDIR" != "$INSTDIR" ]; then
      [ -d "$INSTDIR/etc" ] && mkd "$APPDIR" && cp_rf "$INSTDIR/etc/." "$APPDIR/"
    fi

    if [ -d "$INSTDIR/backgrounds" ]; then
      mkdir -p "$WALLPAPERS/system"
      local wallpapers="$(ls $INSTDIR/backgrounds/ 2>/dev/null | wc -l)"
      if [ "$wallpapers" != "0" ]; then
        wallpaperFiles="$(ls $INSTDIR/backgrounds/)"
        for wallpaper in $wallpaperFiles; do
          cp_rf "$INSTDIR/backgrounds/$wallpaper" "$WALLPAPERS/system/$wallpaper"
        done
      fi
    fi

    if [ -d "$INSTDIR/startup" ]; then
      local autostart="$(ls $INSTDIR/startup/ 2>/dev/null | wc -l)"
      if [ "$autostart" != "0" ]; then
        startFiles="$(ls $INSTDIR/startup)"
        for start in $startFiles; do
          ln_sf "$INSTDIR/startup/$start" "$STARTUP/$start"
        done
      fi
      ln_rm "$STARTUP/"
    fi

    if [ -d "$INSTDIR/bin" ]; then
      local bin="$(ls $INSTDIR/bin/ 2>/dev/null | wc -l)"
      if [ "$bin" != "0" ]; then
        bFiles="$(ls $INSTDIR/bin)"
        for b in $bFiles; do
          chmod -Rf 755 "$INSTDIR/bin/$app"
          ln_sf "$INSTDIR/bin/$b" "$BIN/$b"
        done
      fi
      ln_rm "$BIN/"
    fi

    if [ -d "$INSTDIR/completions" ]; then
      local comps="$(ls $INSTDIR/completions/ 2>/dev/null | wc -l)"
      if [ "$comps" != "0" ]; then
        compFiles="$(ls $INSTDIR/completions)"
        for comp in $compFiles; do
          ln_sf "$INSTDIR/completions/$comp" "$COMPDIR/$comp"
        done
      fi
      ln_rm "$COMPDIR/"
    fi

    if [ -d "$INSTDIR/applications" ]; then
      local apps="$(ls $INSTDIR/applications/ 2>/dev/null | wc -l)"
      if [ "$apps" != "0" ]; then
        aFiles="$(ls $INSTDIR/applications)"
        for a in $aFiles; do
          ln_sf "$INSTDIR/applications/$a" "$SHARE/applications/$a"
        done
      fi
      ln_rm "$SHARE/applications/"
    fi
    [ "$installtype" = "fontmgr_install" ] || __install_fonts
    [ "$installtype" = "iconmgr_install" ] || __install_icons
    [ "$installtype" = "thememgr_install" ] || __install_theme
    [ "$installtype" = "wallpapermgr_install" ] || __install_wallpapers
  fi
  # man pages
  __install_man_pages
  #
  if [ "$APPDIR" != "$INSTDIR" ] && [ -d "$APPDIR" ] && [ -z "$DF_NO_REPLACE" ]; then
    grep -qR '/home/jason' "$APPDIR" && replace "$APPDIR" "/home/jason" "$HOME"
    grep -qR 'replacehome' "$APPDIR" && replace "$APPDIR" "replacehome" "$HOME"
    true
  fi
  # Permission fix
  ensure_perms
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__install_man_pages() {
  local man=""
  local MANDIR=""
  user_is_root && MANDIR="/usr/local/share/man" || MANDIR="$HOME/.local/share/man"
  if [ -d "$INSTDIR/man" ]; then
    [ -d "$MANDIR" ] || mkdir -p "$MANDIR"
    for man in "$INSTDIR/man"/*.1; do
      [ -n "$man" ] || break
      name="$(basename -- "$man" 2>/dev/null)"
      [ ! -f "$MANDIR/man1/$name" ] && [ -d "$MANDIR/man1" ] && [ -n "$name" ] && ln_sf "$man" "$MANDIR/man1/$name"
    done
    for man in "$INSTDIR/man"/*.2; do
      [ -n "$man" ] || break
      name="$(basename -- "$man" 2>/dev/null)"
      [ ! -f "$MANDIR/man2/$name" ] && [ -d "$MANDIR/man2" ] && [ -n "$name" ] && ln_sf "$man" "$MANDIR/man2/$name"
    done
    for man in "$INSTDIR/man"/*.3; do
      [ -n "$man" ] || break
      name="$(basename -- "$man" 2>/dev/null)"
      [ ! -f "$MANDIR/man3/$name" ] && [ -d "$MANDIR/man3" ] && [ -n "$name" ] && ln_sf "$man" "$MANDIR/man3/$name"
    done
    for man in "$INSTDIR/man"/*.4; do
      [ -n "$man" ] || break
      name="$(basename -- "$man" 2>/dev/null)"
      [ ! -f "$MANDIR/man4/$name" ] && [ -d "$MANDIR/man4" ] && [ -n "$name" ] && ln_sf "$man" "$MANDIR/man4/$name"
    done
    for man in "$INSTDIR/man"/*.5; do
      [ -n "$man" ] || break
      name="$(basename -- "$man" 2>/dev/null)"
      [ ! -f "$MANDIR/man5/$name" ] && [ -d "$MANDIR/man5" ] && [ -n "$name" ] && ln_sf "$man" "$MANDIR/man5/$name"
    done
    for man in "$INSTDIR/man"/*.6; do
      [ -n "$man" ] || break
      name="$(basename -- "$man" 2>/dev/null)"
      [ ! -f "$MANDIR/man6/$name" ] && [ -d "$MANDIR/man6" ] && [ -n "$name" ] && ln_sf "$man" "$MANDIR/man6/$name"
    done
    for man in "$INSTDIR/man"/*.7; do
      [ -n "$man" ] || break
      name="$(basename -- "$man" 2>/dev/null)"
      [ ! -f "$MANDIR/man7/$name" ] && [ -d "$MANDIR/man7" ] && [ -n "$name" ] && ln_sf "$man" "$MANDIR/man7/$name"
    done
    for man in "$INSTDIR/man"/*.8; do
      [ -n "$man" ] || break
      name="$(basename -- "$man" 2>/dev/null)"
      [ ! -f "$MANDIR/man8/$name" ] && [ -d "$MANDIR/man8" ] && [ -n "$name" ] && ln_sf "$man" "$MANDIR/man8/$name"
    done
    unset man
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_version() {
  $installtype
  printf_blue "$ICON_GOOD installing version info"
  mkd "$CASJAYSDEVSAPPDIR/dotfiles" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  if [ "$APPNAME" = "installer" ] || [ "$APPNAME" = "scripts" ]; then
    ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/scripts"
    ln_sf "$INSTDIR/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-scripts"
  else
    [ -f "$APPDIR/version.txt" ] && ln_sf "$APPDIR/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME"
    [ -f "$APPDIR/install.sh" ] && ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
    if [ "$APPDIR" != "$INSTDIR" ]; then
      [ -f "$INSTDIR/version.txt" ] && ln_sf "$INSTDIR/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME"
      [ -f "$INSTDIR/install.sh" ] && ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_cleanup() {
  local TMPFILE="$TMPDIR/$APPNAME.tmp"
  local TMPINST="$TMPDIR/$APPNAME.inst.tmp"
  if [ -f "$TMPFILE" ]; then rm_rf "$TMPFILE"; fi
  if [ -f "$TMPINST" ]; then rm_rf "$TMPINST"; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_exit() {
  $installtype
  local APPNAME="${APPNAME:-$PROG}"
  local TMPDIR="${TMPDIR:-/tmp}"
  printf_yellow "$ICON_GOOD Running exit commands"
  [ -e "$APPDIR/$APPNAME" ] || rm_rf "$APPDIR/$APPNAME"
  [ -e "$INSTDIR/$APPNAME" ] || rm_rf "$INSTDIR/$APPNAME"
  if [ -d "$APPDIR" ] && [ ! -f "$APPDIR/.installed" ]; then
    date '+Installed on: %m/%d/%y @ %H:%M:%S' >"$APPDIR/.installed" 2>/dev/null
  fi
  if [ -d "$INSTDIR" ] && [ ! -f "$INSTDIR/.installed" ]; then
    date '+Installed on: %m/%d/%y @ %H:%M:%S' >"$INSTDIR/.installed" 2>/dev/null
  fi
  run_cleanup
  if [ -f "/tmp/$SCRIPTSFUNCTFILE" ]; then rm_rf "/tmp/$SCRIPTSFUNCTFILE"; fi
  local exitCode=$(($? + exitCode))
  getexitcode "The configurations for $APPNAME have been installed" "$APPNAME installer has encountered an error: Check the URL"
  printf_newline
  export EXIT
  return "${EXIT:-$exitCode}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install_list() {
  if [ -d "$USRUPDATEDIR" ] && [ -n "$(ls -A "$USRUPDATEDIR/$1" 2>/dev/null)" ]; then
    file="$(ls -A "$USRUPDATEDIR/$1" 2>/dev/null)"
    if [ -f "$file" ]; then
      printf_green "Information about $1: $(bash -c "$file --version")"
    else
      printf_exit "File was not found is it installed?"
      exit
    fi
  else
    declare -a LSINST="$(ls "$USRUPDATEDIR/" 2>/dev/null)"
    if [ -z "${LSINST[0]}" ]; then
      printf_red "No dotfiles are installed"
      exit
    else
      for df in "${LSINST[@]}"; do
        printf_green "$df"
      done
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Versioning
__appversion() {
  local versionfile="${1:-$REPORAW/version.txt}"
  if [ -f "$INSTDIR/version.txt" ]; then
    local localVersion="$(<$INSTDIR/version.txt)"
  else
    local localVersion="$localVersion"
  fi
  __curl "${versionfile}" 2>/dev/null | head -n1 || echo "$localVersion"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__required_version() {
  [ -d "$CASJAYSDEV_USERDIR/apps/$SCRIPTS_PREFIX/new_update" ] &&
    rm_rf "$CASJAYSDEV_USERDIR/apps/$SCRIPTS_PREFIX/new_update"
  local requiredVersion="${1:-$requiredVersion}"
  local NEW_DIR="$CASJAYSDEV_USERDIR/apps/$SCRIPTS_PREFIX/$new_update"
  [ -d "$NEW_DIR" ] || mkdir -p "$NEW_DIR" &>/dev/null
  if [ -f "$CASJAYSDEVDIR/version.txt" ]; then
    local currentVersion="${APPVERSION:-$currentVersion}"
    local rVersion="${requiredVersion//-git/}"
    local cVersion="${currentVersion//-git/}"
    [ -f "$NEW_DIR/$APPNAME" ] && local NEW_VER="$(<"$NEW_DIR/$APPNAME")"
    [ "$NEW_VER" = "$requiredVersion" ] && return
    if [ "$cVersion" -lt "$rVersion" ] && [ "$APPNAME" != "scripts" ] && [ "$SCRIPTS_PREFIX" != "systemmgr" ]; then
      printf_yellow "Requires version higher than $rVersion"
      printf_yellow "You will need to update for new features"
      echo "$requiredVersion" >"$NEW_DIR/$APPNAME"
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__required_version "$requiredVersion"
#[ "$installtype" = "devenvmgr_install" ] &&
desktopmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "devenvmgr_install" ] &&
devenvmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "dfmgr_install" ] &&
dfmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "dockermgr_install" ] &&
dockermgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "fontmgr_install" ] &&
fontmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "iconmgr_install" ] &&
iconmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "pkmgr_install" ] &&
pkmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "systemmgr_install" ] &&
systemmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "thememgr_install" ] &&
thememgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "wallpapermgr_install" ] &&
wallpapermgr_req_version() { __required_version "$1"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
vdebug() {
  echo -e "VAR - ARGS:${*:-no arguments given}"
  # for path in "USER:$USER" "HOME:$HOME" "PREFIX:$SCRIPTS_PREFIX" "REPO:$REPO" "REPORAW:$REPORAW" \
  #   "CONF:$CONF" "SHARE:$SHARE" "INSTDIR:$INSTDIR" "APPDIR:$APPDIR" "USRUPDATEDIR:$USRUPDATEDIR" \
  #   "SYSUPDATEDIR:$SYSUPDATEDIR" "FONTDIR:$FONTDIR " "ICONDIR:$ICONDIR" "THEMEDIR:$THEMEDIR" \
  #   "$INSTDIR/version.txt:$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" \
  #   "$INSTDIR/install.sh:$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME" \
  #   "$APPDIR/version.txt:$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" \
  #   "$APPDIR/install.sh:$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"; do
  #   echo -e "VAR - $path"
  # done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__debugger() {
  local debug=""
  [ "$1" = "debug" ] && debug="true" && shift 1
  if [ "$debug" = "true" ] || [ "$_DEBUG" = "on" ]; then
    set -Ex
    export debug="true" _DEBUG="on"
    export LOGDIR_DEBUG="${LOGDIR:-/tmp/$USER}/debug"
    mkdir -p "$LOGDIR_DEBUG"
    rm_rf "$LOGDIR_DEBUG/$APPNAME.log" "$LOGDIR_DEBUG/$APPNAME.err"
    touch "$LOGDIR_DEBUG/$APPNAME.log" "$LOGDIR_DEBUG/$APPNAME.err"
    chmod -Rf 755 "$LOGDIR_DEBUG"
    vdebug "$*" >>"$LOGDIR_DEBUG/$APPNAME.log"
    exec 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0
    devnull() { "$@" 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0; }
    devnull1() { "$@" 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0; }
    devnull2() { "$@" 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0; }
    execute() { $1 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0 && set --; }
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cursor
echo -e -n "\x1b[\x35 q" 2>/dev/null
echo -e -n "\e]12;cyan\a" 2>/dev/null
# end
