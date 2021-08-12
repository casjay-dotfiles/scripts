#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
FUNCFILE="testing.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 020920211625-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : LICENSE.md
# @ReadME        : README.md
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Tuesday, Feb 09, 2021 17:17 EST
# @File          : testing.bash
# @Description   : Functions for apps
# @TODO          : Refactor code - It is a mess/change to zenity
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main scripts location
CASJAYSDEVDIR="/usr/local/share/CasjaysDev/scripts"
# Fail if git, curl, wget are not installed
if ! type -P git &>/dev/null; then
  echo -e "\t\t\033[0;31mAttempting to install git\033[0m"
  if __command -P brew &>/dev/null; then
    brew install -f git &>/dev/null
  elif __command -P apt &>/dev/null; then
    apt install -yy -q git &>/dev/null
  elif __command -P pacman &>/dev/null; then
    pacman -S --noconfirm git &>/dev/null
  elif __command -P yum &>/dev/null; then
    yum install -yy -q git &>/dev/null
  elif __command -P choco &>/dev/null; then
    choco install git -y &>/dev/null
    if __command -P git &>/dev/null; then
      echo -e "\t\t\033[0;31mGit was not installed\033[0m"
      exit 1
    fi
  else
    echo -e "\t\t\033[0;31mGit is not installed\033[0m"
    exit 1
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#getopt() { builtin command getopt; }
builtin type -p am_i_online &>/dev/null || am_i_online() { builtin command am_i_online || true; }
builtin type -p __am_i_online &>/dev/null || __am_i_online() { builtin command am_i_online || true; }
cmd_exist() { __command "$1" &>/dev/null || return 1; }
__cmd_exist() { __command "$1" &>/dev/null || return 1; }
__local_gen_header() { echo -e "$1" >>"$2"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for check in git curl wget; do
  if ! builtin type -P "$check" &>/dev/null; then
    echo -e "\n\n\t\t\033[0;31m$check is not installed\033[0m\n"
    exit 1
  fi
done
###################### builtins ######################
__command() {
  [ "$1" = "-v" ] && shift 1
  if [ $# -ne 1 ]; then
    if builtin type "$@" 2>/dev/null | grep -v alias | head -n1 | awk '{print $1}' | grep '^'; then
      return 0
    else
      return 1
    fi
  elif builtin type "$@" 2>/dev/null | grep -v alias | head -n1 | awk '{print $1}' | grep -q '^'; then
    return 0
  else
    return 1
  fi
}
export -f __command
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Versioning Info - __required_version "VersionNumber"
localVersion="${localVersion:-202103310525-git}"
requiredVersion="${requiredVersion:-202103310525-git}"
if grep -qs '^' "$CASJAYSDEVDIR/version.txt"; then
  currentVersion="${currentVersion:-$(<$CASJAYSDEVDIR/version.txt)}"
else
  currentVersion="$localVersion"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set Main Repo for dotfiles
GIT_REPO_BRANCH="${GIT_DEFAULT_BRANCH:-main}"
DOTFILESREPO="https://github.com/dfmgr"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set other Repos
DFMGRREPO="https://github.com/dfmgr"
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
# Timezone data
if [ -f "/etc/timezone" ]; then
  export TIMEZONE="$(cat /etc/timezone)"
else
  export TIMEZONE="America/New_York"
fi
# OS Settings
if [ -f "$CASJAYSDEVDIR/bin/detectostype" ]; then
  . "$CASJAYSDEVDIR/bin/detectostype"
fi
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
# Setup sudo and user
# if [ -n "$DISPLAY" ] && __command ask_for_password; then
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
# TTY Check
is_tty() { [[ -t 1 || -p /dev/stdout ]]; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### devnull/logging/error handling ######################
# send all output to /dev/null
__devnull() {
  local CMD="$1" && shift 1
  local ARGS="$*" && shift
  eval $CMD $ARGS &>/dev/null
}
# only send stdout to display
__devnull1() {
  local CMD="$1" && shift 1
  local ARGS="$*" && shift
  eval $CMD $ARGS 1>/dev/null >&0
}
# send stderr to /dev/null
__devnull2() {
  local CMD="$1" && shift 1
  local ARGS="$*" && shift
  eval $CMD $ARGS 2>/dev/null
}
# log all app out to file
__runapp() {
  local logdir="${LOGDIR:-$HOME/.local/log}/runapp"
  __mkd "$logdir"
  if [ "$1" = "--bg" ]; then
    local logname="$2"
    shift 2
    __local_gen_header "#################################" "$logdir/$logname.log"
    date +'%A, %B %d, %Y' >>"$logdir/$logname.log"
    __local_gen_header "#################################" "$logdir/$logname.log"
    bash -c "${@:-$(false)}" >>"$logdir/$logname.log" 2>>"$logdir/$logname.err" &
  elif [ "$1" = "--log" ]; then
    local logname="$2"
    shift 2
    __local_gen_header "#################################" "$logdir/$logname.log"
    date +'%A, %B %d, %Y' >>"$logdir/$logname.log"
    __local_gen_header "#################################" "$logdir/$logname.log"
    bash -c "${@:-$(false)}" >>"$logdir/$logname.log" 2>>"$logdir/$logname.err"
  else
    __local_gen_header "#################################" "$logdir/${APPNAME:-$1}.log"
    date +'%A, %B %d, %Y' >>"$logdir/${APPNAME:-$1}.log"
    __local_gen_header "#################################" "$logdir/${APPNAME:-$1}.log"
    bash -c "${@:-$(false)}" >>"$logdir/${APPNAME:-$1}.log" 2>>"$logdir/${APPNAME:-$1}.err"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exec command
__exec() {
  local cmd="$1" && shift 1
  local args="$*" && shift $#
  if [ "$cmd" = "$TERMINAL" ]; then
    eval $cmd "$args" 2>/dev/null && true || notifications "Failed to launch $cmd $args"
  else
    $cmd "$args" &>/dev/null && true || notifications "Failed to launch $cmd $args" &
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# macos fixes
case "$(uname -s)" in
Darwin) alias dircolors=gdircolors ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get version
scripts_version() { printf_green "scripts version is $(cat ${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/version.txt)\n"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#setup colors
NC="$(tput sgr0 2>/dev/null)"
RESET="$(tput sgr0 2>/dev/null)"
BLACK="\033[0;30m"
RED="\033[0;31m"
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
printf_newline() { printf '%s\n' "${*:-}"; }
printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_normal() {
  printf_color "\t\t$1" "$2"
  printf "\n"
}
printf_green() {
  printf_color "\t\t$1" 2
  printf "\n"
}
printf_red() {
  printf_color "\t\t$1" 1
  printf "\n"
}
printf_purple() {
  printf_color "\t\t$1" 5
  printf "\n"
}
printf_yellow() {
  printf_color "\t\t$1" 3
  printf "\n"
}
printf_blue() {
  printf_color "\t\t$1" 4
  printf "\n"
}
printf_cyan() {
  printf_color "\t\t$1" 6
  printf "\n"
}
printf_info() {
  printf_color "\t\t$ICON_INFO $1" 3
  printf "\n"
}
printf_success() {
  printf_color "\t\t$ICON_GOOD $1" 2
  printf "\n"
}
printf_warning() {
  printf_color "\t\t$ICON_WARN $1" 3
  printf "\n"
}
printf_error_stream() {
  while read -r line; do
    printf_error "↳ ERROR: $line"
  done
}
printf_execute_success() {
  printf_color "\t\t$ICON_GOOD $1" 2
  printf "\n"
}
printf_execute_error() {
  printf_color "\t\t$ICON_WARN $1 $2" 1
  printf "\n"
}
printf_execute_result() {
  if [[ "$1" = 0 ]]; then printf_execute_success "$2"; else printf_execute_error "${3:-$2}"; fi
  return "$1"
}
printf_not_found() {
  if __command "$1"; then
    printf_exit "The command $1 is not installed"
  fi
}
printf_execute_error_stream() {
  while read -r line; do
    printf_execute_error "↳ ERROR: $line"
  done
}
#used for printing console notifications
printf_console() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\n\t\t$msg" "${PRINTF_COLOR:-$color}"
  printf "\n\n"
}
printf_pause() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="${*:-Press any key to continue}"
  printf_color "\t\t$msg " "${PRINTF_COLOR:-$color}"
  read -r -n 1 -s
  printf "\n"
}
print_wait() {
  printf_pause "$*"
  printf "\n"
}
#same as printf_error
printf_return() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  [ $# = 0 ] || printf_red "$*" "$color"
  return ${exitCode:-2}
}
#printf_error "color" "exitcode" "message"
printf_error() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  printf_color "\t\t$ICON_ERROR $msg" "$color"
  printf "\n"
  return $exitCode
}
#printf_exit "color" "exitcode" "message"
printf_exit() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  printf "\n"
  exit "$exitCode"
}
printf_single() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local COLUMNS=80
  local TEXT="$*"
  local LEN=${#TEXT}
  local WIDTH=$(($LEN + ($COLUMNS - $LEN) / 2))
  printf "%b" "$(tput setaf "${PRINTF_COLOR:-$color}" 2>/dev/null)" "$TEXT " "$(tput sgr0 2>/dev/null)" | sed 's#\t# #g'
}
printf_help() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local filename="$()"
  local msg="$*"
  shift
  echo ""
  if [ "${PROG:-$APPNAME}" ]; then
    printf_color "\t\t$(grep ^"# @Description" "$(__command -P "${PROG:-$APPNAME}")" | grep ' : ' | sed 's#..* : ##g' || "${PROG:-$APPNAME}" help)\n" 2
  fi
  printf_color "\t\t$msg" "${PRINTF_COLOR:-$color}"
  printf "\n\n"
  exit 0
}
printf_custom() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "${PRINTF_COLOR:-$color}"
  printf "\n"
}
printf_read() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "\t\t$line" "${PRINTF_COLOR:-$color}"
  done
  printf "\n"
  set +o pipefail
}
printf_readline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "\t\t$line" "${PRINTF_COLOR:-$color}"
    printf "\n"
  done
  set +o pipefail
}
printf_column() {
  local -a column=""
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="7"
  cat - | column | printf_readline "${color:-$COLOR}"
  printf "\n"
  set +o pipefail
}
printf_cat() {
  file=${1:--}
  while IFS= read -r line; do
    printf '%s\n' "$line"
  done < <(cat -- "$file")
}
printf_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local msg="$*"
  shift
  printf_color "\t\t$ICON_QUESTION $msg? " "${PRINTF_COLOR:-$color}"
}
printf_custom_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg " "${PRINTF_COLOR:-$color}"
}
printf_question_term() {
  printf_read_question "4" "$1" "1" "REPLY" "-s"
  printf_answer_yes "$REPLY" && eval "${2:-true}" || return 1
}
#printf_read_input "color" "message" "maxLines" "answerVar" "readopts"
printf_read_input() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$1" && shift 1
  local readopts=""
  local reply=""
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  local reply="${1:-REPLY}" && shift 1
  local readopts="${1:-}" && shift 1
  printf_color "\t\t$msg " "${PRINTF_COLOR:-$color}"
  read -r -n $lines ${readopts:-} ${reply:-} || return 1
}
#printf_read_question "color" "message" "maxLines" "answerVar" "readopts"
printf_read_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$1" && shift 1
  local readopts=""
  local reply=""
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  local reply="${1:-REPLY}" && shift 1
  local readopts="${1:-}" && shift 1
  printf_color "\t\t$msg " "${PRINTF_COLOR:-$color}"
  read -t 30 -e -r -n $lines ${readopts:-} ${reply:-} || return 1
}
#printf_read_question "color" "message" "maxLines" "answerVar" "readopts"
printf_read_question_nt() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$1" && shift 1
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  local reply="${1:-REPLY}" && shift 1
  local readopts="${1:-}" && shift 1
  printf_color "\t\t$msg " "${PRINTF_COLOR:-$color}"
  read -e -r -n $lines ${readopts} ${reply} || return 1
}
printf_read_passwd() {
  printf_read_question_nt ${1:-3} "$2:" "100" "$3" "-s"
}

printf_read_error() {
  export "${1:-}"
  printf_newline
}
#printf_answer "Var" "maxNum" "Opts"
printf_answer() {
  read -t 10 -r -s -n 1 "${1:-$REPLY}"
  if [ -z "$reply" ]; then
    return 1
  fi
  #history -s "${1:-$REPLY}"
}
#printf_answer_yes "var" "response"
printf_answer_yes() {
  [[ "${1:-$REPLY}" =~ ${2:-^[Yy]$} ]] || return 1
}
printf_answer_no() {
  [[ "${1:-$REPLY}" =~ ${2:-^[Nn]$} ]] && return 1 || return 0
}
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
  [ -z "$msg1" ] || printf_color "\t\t##################################################\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg1" ] || printf_color "\t\t$msg1\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg2" ] || printf_color "\t\t$msg2\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg3" ] || printf_color "\t\t$msg3\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg4" ] || printf_color "\t\t$msg4\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg5" ] || printf_color "\t\t$msg5\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg6" ] || printf_color "\t\t$msg6\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg7" ] || printf_color "\t\t$msg7\n" "${PRINTF_COLOR:-$color}"
  [ -z "$msg1" ] || printf_color "\t\t##################################################\n" "${PRINTF_COLOR:-$color}"
}
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
  [ -z "$msg1" ] || printf "$msg1\n"
  [ -z "$msg2" ] || printf "$msg2\n"
  [ -z "$msg3" ] || printf "$msg3\n"
  [ -z "$msg4" ] || printf "$msg4\n"
  [ -z "$msg5" ] || printf "$msg5\n"
  [ -z "$msg6" ] || printf "$msg6\n"
  [ -z "$msg7" ] || printf "$msg7\n"
  [ -z "$msg1" ] || printf "##################################################\n"
}
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
  wait_time=$1 # seconds
  color="$2"
  msg="$3"
  temp_cnt=${wait_time}
  while [[ ${temp_cnt} -gt 0 ]]; do
    printf "\r%s" "$(printf_custom "${PRINTF_COLOR:-$color}" "$msg" ${temp_cnt} "$4")"
    sleep 1
    ((temp_cnt--))
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__local_network() {
  if [ "$1" = "localhost" ] || [ "$1" = "$(hostname -s)" ] || [ "$1" = "$(hostname -f)" ] ||
    [[ "$1" =~ 10.*.*.* ]] || [[ "$1" =~ 192.168.*.* ]] || [[ "$1" =~ 172.16.*.* ]] || [[ "$1" =~ 127.*.*.* ]]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__local_sysname() {
  if [ "$1" = "localhost" ] || [ "$1" = "$(hostname -s)" ] || [ "$1" = "$(hostname -f)" ]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### Options ######################
__list_available() { echo ${*:-$ARRAY} | __sed 's|,--| --|g;s|,-| -|g;s|,| |g;s|:||g'; }
__list_array() {
  local OPTSDIR="${1:-$HOME/.local/share/myscripts/${APPNAME:-$PROG}/options}"
  mkdir -p "$OPTSDIR"
  echo "${2:-$ARRAY}" | tr ',' '\n' >"$OPTSDIR/array"
  return
}
__list_options() {
  local OPTSDIR="${1:-$HOME/.local/share/myscripts/${APPNAME:-$PROG}/options}"
  mkdir -p "$OPTSDIR"
  echo -n "-$SHORTOPTS " | sed 's#:##g;s#,# -#g' >"$OPTSDIR/options"
  echo "--$LONGOPTS " | sed 's#:##g;s#,# --#g' >>"$OPTSDIR/options"
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### checks ######################
#system_service_active "list of services to check"
__system_service_active() {
  for service in "$@"; do
    if [ "$(systemctl show -p ActiveState $service | cut -d'=' -f2)" == active ]; then
      return 0
    else
      return 1
    fi
  done
}
#system_service_running "list of services to check"
__system_service_running() {
  for service in "$@"; do
    if systemctl status $service 2>/dev/null | grep -Fq running; then
      return 0
    else
      return 1
    fi
  done
}
#system_service_exists "servicename"
__system_service_exists() {
  for service in "$@"; do
    if sudo systemctl list-unit-files | grep -Fq "$service.service" || sudo systemctl list-unit-files | grep -Fq "$service.socket"; then return 0; else return 1; fi
    __setexitstatus $?
  done
  set --
}
#system_service_enable "servicename"
__system_service_enable() {
  for service in "$@"; do
    if __system_service_exists "$service"; then __devnull "sudo systemctl enable --now -f $service"; fi
    __setexitstatus $?
  done
  set --
}
#system_service_disable "servicename"
__system_service_disable() {
  for service in "$@"; do
    if __system_service_exists "$service"; then __devnull "sudo systemctl disable --now -f $service"; fi
    __setexitstatus $?
  done
  set --
}
#system_service_start "servicename"
__system_service_start() {
  for service in "$@"; do
    if __system_service_exists "$service"; then __devnull "sudo systemctl start $service"; fi
    __setexitstatus $?
  done
  set --
}
#system_service_stop "servicename"
__system_service_stop() {
  for service in "$@"; do
    if __system_service_exists "$service"; then __devnull "sudo systemctl stop $service"; fi
    __setexitstatus $?
  done
  set --
}
#system_service_restart "servicename"
__system_service_restart() {
  for service in "$@"; do
    if __system_service_exists "$service"; then __devnull "sudo systemctl restart $service"; fi
    __setexitstatus $?
  done
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#npm_exists "npmpackage"
__npm_exists() {
  __command npm || printf_return "NPM is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo npm" && shift 1 || local cmdbin="npm"
  local package="$1"
  if __devnull2 $cmdbin list -g 2>&1 | grep -q "$package"; then
    return 0
  elif __devnull2 $cmdbin list 2>&1 | grep -q "$package"; then
    return 0
  else return 1; fi
  set --
}
#perl_exists "perlpackage"
__perl_exists() {
  __command perl || printf_return "Perl is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo perl" && shift 1 || local cmdbin="perl"
  local package="$1"
  if __devnull $cmdbin -M$package -le 'print $INC{"$package/Version.pm"}' 2>&1; then return 0; else return 1; fi
  set --
}
#python_exists "pythonpackage"
__python_exists() {
  __command python3 || __command python2 || __command python || printf_return "Python is not installed"
  __getpythonver
  [ "$1" = "--sudo" ] && local cmdbin="sudo $PYTHONVER" && shift 1 || local cmdbin="$PYTHONVER"
  local package="$1"
  if __devnull $cmdbin -c "import $package" 2>&1; then return 0; else return 1; fi
  set --
}
#gem_exists "gemname"
__gem_exists() {
  __command gem || printf_return "Ruby Gem is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo gem" && shift 1 || local cmdbin="gem"
  local package="$1"
  if $cmdbin list 2>&1 | grep -wq "$package"; then
    return 0
  else
    return 1
  fi
  set --
}
#lua_exists "luaname"
__lua_exists() {
  __command luarocks || printf_return "luarocks is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo luarocks" && shift 1 || local cmdbin="luarocks"
  local package="$1"
  if $cmdbin list 2>&1 | grep -wq "$package"; then
    return 0
  else
    return 1
  fi
  set --
}
#go_exists "goname"
__go_exists() {
  __command go || printf_return "go is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo go" && shift 1 || local cmdbin="go"
  local package="$1"
  if $cmdbin list -m 2>&1 | grep -wq "$package"; then
    return 0
  else
    return 1
  fi
  set --
}
#check_pip "pipname"
__check_pip() {
  local ARGS="$*"
  local MISSING=""
  for cmd in $ARGS; do type -P "$cmd" &>/dev/null || MISSING+="$cmd "; done
  if [ -n "$MISSING" ]; then
    printf_read_question "2" "$1 is not installed Would you like install it? [y/N]" "1" "choice" "-s"
    if printf_answer_yes "$choice"; then
      for miss in $MISSING; do
        __execute "pkmgr pip $miss" "Installing $miss"
      done
    fi
  else
    return $?
  fi
}
#check_cpan "cpanname"
__check_cpan() {
  local MISSING=""
  for cmd in "$@"; do type $cmd || MISSING+="$cmd "; done
  if [ -n "$MISSING" ]; then
    printf_question "2" "$1 is not installed Would you like install it? [y/N]" "1" "choice" "-s"
    if printf_answer_yes "$choice"; then
      for miss in $MISSING; do
        __execute "pkmgr cpan $miss" "Installing $miss"
      done
    fi
  else
    return $?
  fi
}
#check_app "app"
__check_app() {
  local cmd=""
  local choice=""
  local MISSING=""
  local ARGS="$*"
  export APP="${APPNAME:-$PROG}"
  export NOTIFY_CLIENT_ICON="software"
  export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APP}"
  for cmd in $ARGS; do __command $cmd || MISSING+="$cmd "; done
  if [ -n "$MISSING" ]; then
    notifications "${NOTIFY_CLIENT_NAME:-$APPNAME}" "Missing $MISSING"
    if [ -n "$DESKTOP_SESSION" ]; then
      __ask_confirm "Would you like install $MISSING" "pkmgr silent-install $MISSING" || return 1
    else
      printf_red "The following apps are missing: $MISSING"
      printf_read_question "2" "Would you like install the missing packages? [y/N]" "1" "choice" "-s"
      if printf_answer_yes "$choice"; then
        for miss in $MISSING; do
          __execute "pkmgr silent-install $miss" "Installing $miss" || return 1
        done
      else
        return 1
      fi
    fi
  else
    return $?
  fi
}
__require_app() { __check_app "$@" || exit 1; }
__requires() {
  local ARGS="$*"
  for cmd in $ARGS; do
    type $cmd || local CMD+="$cmd "
  done
  if [ -n "$CMD" ]; then __require_app "$CMD"; fi
  [ "$?" = 0 ] && return 0 || exit 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### get versions ######################
__getpythonver() {
  if __command python3; then
    PYTHONVER="python3"
    PIP="pip3"
    PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
  elif __command python2; then
    PYTHONVER="python2"
    PIP="pip"
    PATH="${PATH}:$(python2 -c 'import site; print(site.USER_BASE)')/bin"
  elif __command python; then
    PYTHONVER="python"
    PIP="pip"
    PATH="${PATH}:$(python -c 'import site; print(site.USER_BASE)')/bin"
  fi
  if __command -P yay &>/dev/null || __command -P pacman &>/dev/null; then PYTHONVER="python" && PIP="pip3"; fi
}
__getphpver() {
  if __command php; then
    PHPVER="$(php -v | grep --only-matching --perl-regexp "(PHP )\d+\.\\d+\.\\d+" | cut -c 5-7)"
  else
    PHPVER=""
  fi
  echo $PHPVER
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### macos fixes#################
if [ "$(uname -s)" = Darwin ]; then
  __command gls && lscmd="$(type -P gls)" || lscmd="$(type -P ls)"
  alias ls='$lscmd'
  __command gdate && datecmd="$(type -P gdate)" || datecmd="$(type -P date)"
  __command greadlink && readlinkcmd="$(type -P greadlink)" || readlinkcmd="$(type -P readlink)"
  __command g__basename && __basenamecmd="$(type -P g__basename)" || __basenamecmd="$(type -P __basename)"
  __command gdircolors && dircolorscmd="$(type -P gdircolors)" || dircolorscmd="$(type -P dircolors)"
  __command grealpath && realpathcmd="$(type -P grealpath)" || realpathcmd="$(type -P realpath)"
  [ -n "$datecmd" ] || date() { $datecmd "$@"; }
  [ -n "$readlinkcmd" ] || readlink() { $readlinkcmd "$@"; }
  [ -n "$__basenamecmd" ] || __basename() { $__basenamecmd "$@"; }
  [ -n "$dircolorscmd" ] || dircolors() { $dircolorscmd "$@"; }
  [ -n "$realpathcmd" ] || realpath() { $realpathcmd "$@"; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### tools ######################
__setcursor() { echo -e -n "\x1b[\x35 q" "\e]12;cyan\a" 2>/dev/null; }
__get_status_pid() { __ps "$1" | grep -v grep | grep -q "$1" 2>/dev/null && return 0 || return 1; }
__get_pid_of() { __ps "$1" | head -n1 | awk '{print $2}' | grep '^' || return 1; }
__ps() {
  local proc="$(__basename "$1")"
  local prog="${APPNAME:-$PROG}"
  [ -n "$proc" ] || return 1
  ps -aux | grep -v 'grep ' | grep -E '?' | grep -w "$proc" 2>/dev/null
}
#basedir "file"
__basedir() {
  if [ "$(dirname "$1" 2>/dev/null)" = . ]; then
    echo "$PWD"
  else
    dirname "$1" | sed 's#\../##g' 2>/dev/null
  fi
}
#basename "file"
__basename() { basename "${1:-.}" 2>/dev/null; }
# dirname dir
__dirname() { cd "$1" 2>/dev/null && echo "$PWD" || return 1; }
#to_lowercase "args"
__to_lowercase() { echo "$@" | tr '[A-Z]' '[a-z]'; }
#to_uppercase "args"
__to_uppercase() { echo "$@" | tr '[a-z]' '[A-Z]'; }
#strip_ext "Filename"
__strip_ext() { echo "$@" | sed 's#\..*##g'; }
#get_full_file "file"
__get_full_file() { ls -A "$*" 2>/dev/null; }
#cat file | rmcomments
__rmcomments() { sed 's/[[:space:]]*#.*//;/^[[:space:]]*$/d'; }
#countwd file
__countwd() { cat "$@" | wc -l | __rmcomments; }
__column() { __command column && column || tee; }
#getuser "username" "grep options"
__getuser() { if [ -n "${1:-$USER}" ]; then cut -d: -f1 /etc/passwd | grep "${1:-$USER}" | cut -d: -f1 /etc/passwd | grep "${1:-$USER}" ${2:-}; fi; }
#getuser_shell "shellname"
__getuser_shell() {
  local PATH="/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games"
  local CURSHELL=${1:-$(grep "$USER" /etc/passwd | tr ':' '\n' | tail -n1)} && shift 1
  local USER=${1:-$USER} && shift 1
  grep "$USER" /etc/passwd | cut -d: -f7 | grep -q "${CURSHELL:-$SHELL}" && return 0 || return 1
}
__getuser_cur_shell() {
  local PATH="/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games"
  local CURSHELL="$(grep "$USER" /etc/passwd | tr ':' '\n' | tail -n1)"
  grep "$USER" /etc/passwd | tr ':' '\n' | grep "${CURSHELL:-$SHELL}"
}
###################### Apps ######################
#vim "file"
vim="$(type -P /usr/local/bin/vim || type -P vim)"
__vim() { $vim "$@"; }
#mkd dir
__mkd() {
  for d in "$@"; do [ -e "$d" ] || mkdir -p "$d" &>/dev/null; done
  return 0
}
#netcat
netcat="$(type -P nc 2>/dev/null || type -P -v netcat 2>/dev/null || return 1)"
__netcat_test() { __command netcat || printf_error "The program netcat is not installed"; }
__netcat_pids() { netstat -tupln 2>/dev/null | grep ":$1" | grep "$(__basename ${netcat:-nc})" | awk '{print $7}' | sed 's#'/"$(__basename ${netcat:-nc})"'##g' | grep '^'; }
# kill_netpid "port" "procname"
__kill_netpid() { netstatg "$1" | grep "$(__basename "$2")" | awk '{print $7}' | sed 's#/'$2'##g' && netstat -taupln | grep -qv "$1" || return 1; }
__netcat_kill() {
  pidof "$netcat" &>/dev/null && kill -s KILL "$(__netcat_pids "$1")" &>/dev/null
  netstat -taupln | grep -Fqv ":$1 " || return 1
}
#__kill_server "port required" "print success" "print fail" "success message" "failed message"
__netcat_kill_server() {
  port="${1:?}"
  prints="${2:-printf_green}"
  printf="${3:-printf_red}"
  succ="${4:-Server has been stopped}"
  fail="${5:-Failed to stop}"
  __netcat_kill "${port}" >/dev/null 2>&1 &&
    ${prints} "${succ}" || ${printf} "${fail}"
  sleep 2
}
#file_is_emtpy return 1
__file_not_empty() { [ -s "$1" ] && return 0 || return 1; }
__file_is_empty() { [ ! -s "$1" ] && return 0 || return 1; }
#sed "commands"
sed="$(builtin type -P gsed 2>/dev/null || builtin type -P sed 2>/dev/null)"
__sed() { ${sed:-sed} "$*" 2>/dev/null; }
#tar "filename dir"
__tar_create() { tar cfvz "$@"; }
#tar filename
__tar_extract() { tar xfvz "$@"; }
#while_true "command"
__while_loop() { while :; do "${@}" && sleep .3; done; }
#for_each "option" "command"
__for_each() { for item in ${1}; do ${2} ${item} && sleep .1; done; }
__readline() { while read -r line; do echo "$line"; done <"$1"; }
#hostname ""
__hostname() { __devnull2 hostname -s "${1:-$HOSTNAME}"; }
#domainname ""
__domainname() { hostname -d "${1:-$HOSTNAME}" 2>/dev/null || hostname -f "${1:-$HOSTNAME}" 2>/dev/null; }
#hostname2ip "hostname"
__hostname2ip() { getent ahosts "$1" | grep -v ':*:*:' | cut -d' ' -f1 | head -n1 || nslookup "$1" 2>/dev/null | grep -v '#|:*:*:' | grep Address: | awk '{print $2}' | grep ^ || return 1; }
#ip2hostname "ipaddr"
__ip2hostname() { nslookup "$1" 2>/dev/null | grep -v ':*:*:' | grep Name: | awk '{print $2}' | head -n1 | grep ^ || return 1; }
#timeout "time" "command"
__timeout() { timeout ${1} bash -c "${2}"; }
#start_count "proc" "search"
__start_count() { ps -ux | grep "$1" | grep -v 'grep ' | grep -c "${2:$1}"; }
#count_words "file"
__count_lines() { wc -l "$1" | awk '${print $1}'; }
#count_files "dir"
__count_files() { __devnull2 find -L "${1:-./}" -maxdepth "${2:-1}" -not -path "${1:-./}/.git/*" -type l,f 2>/dev/null | wc -l; }
#count_dir "dir"
__count_dir() { __devnull2 find -L "${1:-./}" -maxdepth "${2:-1}" -not -path "${1:-./}/.git/*" -type d 2>/dev/null | wc -l; }
__touch() { touch "$@" 2>/dev/null || return 0; }
#symlink "file" "dest"
__symlink() { if [ -e "$1" ]; then __devnull __ln_sf "${1}" "${2}" || return 0; fi; }
#mv_f "file" "dest"
__mv_f() { if [ -e "$1" ]; then __devnull mv -f "$1" "$2" || return 0; fi; }
#cp_rf "file" "dest"
__cp_rf() { if [ -e "$1" ]; then __devnull cp -Rf "$1" "$2" || return 0; fi; }
#rm_rf "file"
__rm_rf() { if [ -e "$1" ]; then __devnull rm -Rf "$@" || return 0; fi; }
# unlink "location"
__unlink() { if [ -L "$1" ]; then __devnull unlink "$@" || return 0; fi; }
#
__broken_symlinks() {
  __devnull find -L "$@" -type l -exec rm -f {} \;
}
#ln_rm "file"
__ln_rm() {
  if [ -e "$1" ]; then
    __devnull find -L $1 -mindepth 1 -maxdepth 1 -type l -exec rm -f {} \;
  fi
}
#ln_sf "file"
__ln_sf() {
  [ -L "$2" ] && __rm_rf "$2" || true
  __devnull ln -sf "$1" "$2"
}
#find_mtime "file/dir" "time minutes"
__find_mtime() {
  if [ "$(find ${1:-.} -maxdepth 1 -type l,f -cmin +${2:-60} 2>/dev/null | wc -l)" -ne 0 ]; then
    return 0
  else
    return 1
  fi
}
#find "dir" "options"
__find() {
  local DEF_OPTS="-type l,f,d"
  local opts="${FIND_OPTS:-$DEF_OPTS}"
  __devnull2 find "${*:-.}" -not -path "$dir/.git/*" $opts
}
#find_old "dir" "minutes" "action"
__find_old() {
  [ -d "$1" ] && local dir="$1" && shift 1
  local time="$1" && shift 1
  local action="$1" && shift 1
  find "${dir:-$HOME/.local/tmp}" -type l,f -mmin +${time:-120} -${action:-delete}
}
#find "dir" - return path relative to dir
__find_rel() {
  #f for file | d for dir
  local DIR="${*:-.}"
  local DEF_TYPE="${FIND_TYPE:-f,l}"
  local DEF_DEPTH="${FIND_DEPTH:-1}"
  local DEF_OPTS="${FIND_OPTS:-}"
  __devnull2 find $DIR/* -maxdepth $DEF_DEPTH -type $DEF_TYPE $DEF_OPTS -not -path "$dir/.git/*" -print | sed 's#'$DIR'/##g'
}
#cd "dir"
__cd() { cd "$1" || return 1; }
# cd into directory with message
__cd_into() {
  if [ $PWD != "$1" ]; then
    cd "$1" && printf_green "Changing the directory to $1" &&
      printf_green "Type exit to return to your previous directory" &&
      exec bash || exit 1
  fi
}
#kill "app"
__kill() { kill -s KILL "$(pidof "$1")" >/dev/null 2>&1; }
#running "app"
__running() { pidof "$1" &>/dev/null && return 1 || return 0; }
#start "app"
__start() {
  sleep 1 && "$@" 2>/dev/null &
  disown
}
path_info() { echo "$PATH" | tr ':' '\n' | sort -u; }
###################### url functions ######################
__curl() {
  am_i_online && curl --disable -LSsfk --connect-timeout 3 --retry 0 --fail "$@" 2>/dev/null || return 1
}
__curl_exit() { EXIT=0 && return 0 || EXIT=1 && return 1; }
#curl_header "site" "code"
__curl_header() { curl --disable -LSIsk --connect-timeout 3 --retry 0 --max-time 2 "$1" 2>/dev/null | grep -E "HTTP/[0123456789]" | grep "${2:-200}" -n1 -q; }
#curl_download "url" "file"
__curl_download() { curl --disable --create-dirs -LSsk --connect-timeout 3 --retry 0 "$1" -o "$2" 2>/dev/null; }
#curl_version "url"
__curl_version() { curl --disable -LSsk --connect-timeout 3 --retry 0 "${1:-$REPORAW/version.txt}" 2>/dev/null; }
#curl_upload "file" "url"
__curl_upload() { curl -disable -LSsk --connect-timeout 3 --retry 0 --upload-file "$1" "$2" 2>/dev/null; }
#curl_api "API URL"
__curl_api() { curl --disable -LSsk --connect-timeout 3 --retry 0 "https://api.github.com/orgs/${1:-SCRIPTS_PREFIX}/repos?per_page=1000" 2>/dev/null; }
#urlcheck "url"
__urlcheck() { curl --disable -LSsk --connect-timeout 1 --retry 0 --retry-delay 0 --output /dev/null --silent --head --fail "$1" 2>/dev/null && __curl_exit; }
#urlverify "url"
__urlverify() { __urlcheck "$1" || __urlinvalid "$1"; }
#urlinvalid "url"
__urlinvalid() {
  if [ -z "$1" ]; then
    printf_red "Invalid URL"
  else
    printf_red "Can't find $1"
  fi
  return 1
}
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
check_uri() {
  local url="$1"
  if echo "$url" | grep -q "http.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="http"
    return 0
  elif echo "$url" | grep -q "ftp.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="ftp"
    return 0
  elif echo "$url" | grep -q "git.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="git"
    return 0
  elif echo "$url" | grep -q "ssh.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="ssh"
    return 0
  else
    uri=""
    return 1
  fi
}
#very simple function to ensure connection and jq exists
__api_test() {
  local message="${*:-}"
  if am_i_online && __command -P jq &>/dev/null; then
    return 0
  else
    if [ -n "$message" ]; then printf_error "$message"; fi
    return 1
  fi
}
#do_not_add_a_url "url"
__do_not_add_a_url() {
  regex="(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]"
  string="$1"
  if [[ "$string" =~ $regex ]]; then
    printf_exit "Do not provide the full url: only provide the username/repo"
  fi
}
###################### git commands ######################
#git_globaluser
__git_globaluser() {
  local author="$(git config --get user.name || echo "$USER")"
  echo "$author"
}
#git_globalemail
__git_globalemail() {
  local email="$(git config --get user.email || echo "$USER"@"$(hostname -s)".local)"
  echo "$email"
}
__git() {
  local args="$*" && shift $#
  local exitCode=0
  local args="$*" && shift $#
  local tmpfile="${TMPDIR:-/tmp}/gitlog.$$.tmp"
  local PATH="/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
  git $args &>"$tmpfile"
  grep -Evqi "[rejectected]|error:|fatal:" "$tmpfile" && exitCode=0 || exitCode=1
  __rm_rf "$tmpfile"
  return ${exitCode:$?}
}
#git_clone "url" "dir"
__git_clone() {
  [ $# -ne 2 ] && printf_exit "Usage: git_clone remoteRepo localDir"
  local repo="$1"
  local dir="${2:-$dir}"
  __git_username_repo "$repo"
  [ -n "$2" ] && local dir="$2" && shift 1 || local dir="${INSTDIR:-.}"
  if [ -d "$dir/.git" ]; then
    __git_update "$dir" || false
  else
    [ -d "$dir" ] && __rm_rf "$dir"
    __git clone -q --recursive "$repo" "$dir" || false
  fi
  if [ "$?" != "0" ]; then
    printf_error "Failed to clone the repo"
  fi
}
#git_pull "dir"
__git_update() {
  [ -n "$1" ] && local dir="$1" && shift 1 || local dir="${INSTDIR:-.}"
  local repo="$(git -C "$dir" remote -v | grep fetch | head -n 1 | awk '{print $2}')"
  local gitrepo="$(dirname $dir/.git)"
  local reponame="${APPNAME:-$gitrepo}"
  git -C "$dir" reset --hard || return 1
  __git -C "$dir" pull --recurse-submodules -fq || return 1
  __git -C "$dir" submodule update --init --recursive -q || return 1
  git -C "$dir" reset --hard -q || return 1
  if [ "$?" != "0" ]; then
    printf_error "Failed to update the repo"
    #__backupapp "$dir" "$reponame" && __rm_rf "$dir" && git clone -q "$repo" "$dir"
  fi
}
#git_commit "dir"
__git_commit() {
  [ -n "$1" ] && local dir="$1" && shift 1 || local dir="${INSTDIR:-.}"
  if __command -P gitcommit &>/dev/null; then
    if [ -d "$2" ]; then shift 1; fi
    local mess="${*}"
    gitcommit "$dir" "$mess"
  else
    local mess="${1}"
    if [ ! -d "$dir" ]; then
      __mkd "$dir"
      git -C "$dir" init -q
    fi
    touch "$dir/README.md"
    git -C "$dir" add -A .
    if ! __git_porcelain "$dir"; then
      git -C "$dir" commit -q -m "${mess:-🏠🐜❗ Updated Files 🏠🐜❗}" | printf_readline "2"
    else
      return 0
    fi
  fi
}
#git_init "dir"
__git_init() {
  [ -n "$1" ] && local dir="$1" && shift 1 || local dir="${APPDIR:-.}"
  if __command -P gitadmin &>/dev/null; then
    if [ -d "$2" ]; then shift 1; fi
    gitadmin "$dir" setup
  else
    set --
    __mkd "$dir"
    __git -C "$dir" init -q &>/dev/null
    __git -C "$dir" add -A . &>/dev/null
    if ! __git_porcelain "$dir"; then
      git -C "$dir" commit -q -m " 🏠🐜❗ Initial Commit 🏠🐜❗ " | printf_readline "2"
    else
      return 0
    fi
  fi
}
#set folder name based on githost
__git_hostname() {
  echo "$@" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/" | awk -F. '{print $(NF-1) "." $NF}' | sed 's#\..*##g'
}
#setup directory structure
__git_username_repo() {
  unset protocol separator hostname username userrepo
  local url="$1"
  local re="^(https?|git|ssh)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)$"
  local githostname="$(__git_hostname $url 2>/dev/null)"
  if [ -d "$url" ]; then
    protocol=
    separator=
    hostname=localhost
    userrepo="$(__basename "$url")"
    username="$(__basename "$(dirname "$url")")"
    folder="local"
    projectdir="${PROJECT_DIR:-$HOME/Projects}/$folder/$username-$userrepo"
  elif [[ $url =~ $re ]]; then
    protocol=${BASH_REMATCH[1]}
    separator=${BASH_REMATCH[2]}
    hostname=${BASH_REMATCH[3]}
    username=${BASH_REMATCH[4]}
    userrepo=${BASH_REMATCH[5]}
    folder=$githostname
    projectdir="${PROJECT_DIR:-$HOME/Projects}/$folder/$username/$userrepo"
  else
    return 1
  fi
}
#usage: git_CMD gitdir
__git_status() { git -C "${1:-.}" status -b -s 2>/dev/null && return 0 || return 1; }
__git_log() { git -C "${1:-.}" log --pretty='%C(magenta)%h%C(red)%d %C(yellow)%ar %C(green)%s %C(yellow)(%an)' 2>/dev/null && return 0 || return 1; }
__git_pull() { git -C "${1:-.}" pull -q 2>/dev/null && return 0 || return 1; }
__git_top_dir() { git -C "${1:-.}" rev-parse --show-toplevel 2>/dev/null | grep -v fatal && return 0 || echo "${1:-$PWD}"; }
__git_top_rel() { __devnull __git_top_dir "${1:-.}" && git -C "${1:-.}" rev-parse --show-cdup 2>/dev/null | sed 's#/$##g' | head -n1 || return 1; }
__git_remote_pull() { git -C "${1:-.}" remote -v 2>/dev/null | grep push | head -n 1 | awk '{print $2}' 2>/dev/null | grep '^'; }
__git_remote_fetch() { git -C "${1:-.}" remote -v 2>/dev/null | grep fetch | head -n 1 | awk '{print $2}' 2>/dev/null | grep '^' && return 0 || return 1; }
__git_remote_origin() { __git_remote_pull "${1:-.}" && return 0 || return 1; }
__git_porcelain() { __git_porcelain_count "${1:-.}" && return 0 || return 1; }
__git_porcelain_count() { [ -d "$(__git_top_dir ${1:-.})/.git" ] && [ "$(git -C "${1:-.}" status --porcelain 2>/dev/null | wc -l 2>/dev/null)" -eq "0" ] && return 0 || return 1; }
__git_repobase() { __basename "$(__git_top_dir "${1:-$PWD}") | grep -v null 2>/dev/null" || echo __basename $PWD; }
# __reldir="$(__git_top_rel ${1:-$PWD} || echo $PWD)"
# __topdir="$(__git_top_dir "${1:-$PWD}" || echo $PWD)"

###################### crontab functions ######################
__removecrontab() {
  command="$(echo "$*" | sed 's#>/dev/null 2>&1##g')"
  crontab -l | grep -v "${command}" | crontab -
  return $?
}
__setupcrontab() {
  [ "$1" = "--help" ] && printf_help "setupcrontab "0 0 1 * *" "echo hello""
  local frequency="$1"
  local command="sleep $(expr $RANDOM \% 300) && $2"
  local job="$frequency $command"
  if cat <(grep -Fivq "$2" <(crontab -l)); then
    cat <(grep -Fiv "$2" <(crontab -l)) <(echo "$job") | crontab - >/dev/null 2>&1
  fi
  return $?
}
__addtocrontab() {
  [ "$1" = "--help" ] && printf_help "addtocrontab "0 0 1 * *" "echo hello""
  local frequency="$1"
  local command="am_i_online && sleep $(expr $RANDOM \% 300) && $2"
  local job="$frequency $command"
  cat <(grep -F -i -v "$2" <(crontab -l)) <(echo "$job") | crontab - >/dev/null 2>&1
  return $?
}
__cron_updater() {
  [ "$*" = "--help" ] && shift 1 && printf_help "Usage: ${PROG:-$APPNAME} updater $APPNAME"
  if user_is_root; then
    if [ -z "$1" ] && [ -d "$SYSUPDATEDIR" ] && ls "$SYSUPDATEDIR"/* 1>/dev/null 2>&1; then
      for upd in $(ls $SYSUPDATEDIR/); do
        file="$(ls -A $SYSUPDATEDIR/$upd 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename $file)"
          sudo file="$file" bash -c "$file --cron $*"
        fi
      done
    else
      if [ -d "$SYSUPDATEDIR" ] && ls "$SYSUPDATEDIR"/* 1>/dev/null 2>&1; then
        file="$(ls -A $SYSUPDATEDIR/$1 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename $file)"
          sudo file="$file" bash -c "$file --cron $*"
        fi
      fi
    fi
  else
    if [ -z "$1" ] && [ -d "$USRUPDATEDIR" ] && ls "$USRUPDATEDIR"/* 1>/dev/null 2>&1; then
      for upd in $(ls $USRUPDATEDIR/); do
        export file="$(ls -A $USRUPDATEDIR/$upd 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename $file)"
          bash -c "$file --cron $*"
        fi
      done
    else
      if [ -d "$USRUPDATEDIR" ] && ls "$USRUPDATEDIR"/* 1>/dev/null 2>&1; then
        export file="$(ls -A $USRUPDATEDIR/$1 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename $file)"
          bash -c "$file --cron $*"
        fi
      fi
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#alternative names
tf() { [ -f "$(builtin type -P tinyfigue 2>/dev/null)" ] || [ -f "$(builtin type -P tf 2>/dev/null)" ] || return 1; }
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
gtk-2.0() { find /lib* /usr* -iname "*libgtk*2*.so*" -type f 2>/dev/null | grep -q . || return 1; }
gtk-3.0() { find /lib* /usr* -iname "*libgtk*3*.so*" -type f 2>/dev/null | grep -q . || return 1; }
transmission-remote-cli() { [ -f "$(builtin type -P transmission-remote-cli 2>/dev/null)" ] || [ -f "$(builtin type -P transmission-remote 2>/dev/null)" ] || return 1; }
export -f cron mlocate xfce4 imagemagick fdfind speedtest neovim chromium firefox gtk-2.0 gtk-3.0
export -f transmission-remote-cli cowsay xfce4-notifyd grub
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#backupapp "directory" "filename"
__backupapp() {
  local filename count backupdir rmpre4vbackup
  [ -n "$1" ] && local myappdir="$1" || local myappdir="$APPDIR"
  [ -n "$2" ] && local myappname="$2" || local myappname="$APPNAME"
  local downloaddir="$INSTDIR"
  local logdir="${LOGDIR:-$HOME/.local/log}/backups/${SCRIPTS_PREFIX:-apps}"
  local curdate="$(date +%Y-%m-%d-%H-%M-%S)"
  local filename="$myappname-$curdate.tar.gz"
  local backupdir="${MY_BACKUP_DIR:-$HOME/.local}/backups/${SCRIPTS_PREFIX:-apps}/"
  local count="$(find "$backupdir/$myappname"*.tar.gz 2>/dev/null | wc -l 2>/dev/null)"
  local rmpre4vbackup="$(find "$backupdir/$myappname"*.tar.gz 2>/dev/null | head -n 1)"
  mkdir -p "$backupdir" "$logdir"
  if [ -d "$myappdir" ] && [ "$myappdir" != "$downloaddir" ] && [ ! -f "$APPDIR/.installed" ]; then
    __local_gen_header "#################################" "$logdir/$myappname.log"
    __local_gen_header "# Started on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    __local_gen_header "# Backing up $myappdir" >>"$logdir/$myappname.log"
    __local_gen_header "#################################" "$logdir/$myappname.log"
    tar cfzv "$backupdir/$filename" "$myappdir" >>"$logdir/$myappname.log" 2>>"$logdir/$myappname.log"
    __local_gen_header "#################################" "$logdir/$myappname.log"
    __local_gen_header "# Ended on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    __local_gen_header "#################################" "$logdir/$myappname.log"
    [ -f "$APPDIR/.installed" ] || rm_rf "$myappdir"
  fi
  if [ "$count" -gt "3" ]; then rm_rf $rmpre4vbackup; fi
}
###################### menu functions ######################
__run_menu_start() {
  clear
  if __running "$1"; then
    __start "$@" && return 0 || return 1
  else
    echo -e "\n\n\n\n"
    printf_red "$1 is already running"
    sleep 5
    return 1
  fi
}
__run_menu_failed() { clear && echo -e "\n\n\n\n\n\n" && printf_red "${1:-An error has occured}" && sleep 3 && return 1; }
#attemp_install_menus "programname"
__attemp_install_menus() {
  local prog="$*"
  message() {
    zenity --width=400 --timeout=10 --title="install $prog" --question --text="$prog is not installed! \nshould I try to install it?" || return 1
  }
  __pkmgr() { __devnull pkmgr silent "$prog" && pkmgr_exitCode=0 || pkmgr_exitCode=1; }
  if message; then
    sleep 2
    clear
    __pkmgr | zenity --width=400 --progress --no-cancel --pulsate --text "Installing packages $prog" --auto-close
    if [ "$pkmgr_exitCode" = 0 ]; then
      zenity --timeout=10 --width=400 --text-info --title="Success" --text="Successfully installed $prog"
      return 0
    else
      zenity --timeout=10 --width=400 --error --title="failed" --text="$prog failed to install"
      return 1
    fi
  else
    zenity --timeout=10 --width=400 --error --title="cancelled" --text="Installation of $prog has been cancelled"
    return 1
  fi
}
__custom_menus() {
  local custom="" opts=""
  printf_read_input "6" "Enter your custom program : " "120" "custom"
  printf_read_input "6" "Enter any additional options [type file to choose] : " "120" "opts"
  if [ "$opts" = "file" ]; then opts="$(__open_file_menus $custom)"; fi
  __start $custom "$opts" 2>/dev/null || __run_menu_failed "$custom is an invalid program"
}
#open_file_menus
__open_file_menus() {
  local prog="$1" && shift 1
  local args="$*" && shift $#
  if __command type $prog; then
    local file="$(dialog --title "Play a file" --stdout --title "Please choose a file or url to play" --fselect "$HOME/" 14 48 || return 1)"
    if [ -f "$file" ] || [ -d "$file" ]; then
      __run_menu_start "$prog" "$file" || __run_menu_failed
    else
      __run_menu_start "$prog" || __run_menu_failed
    fi
  else
    __attemp_install_menus "$prog" && __run_menu_start "$prog" "$args" || __run_menu_failed
  fi
}
#run___command "full command" - terminal apps
__run_command() {
  local cmd="$1" && shift 1
  local arg="$*" && shift $#
  clear
  if __command $cmd; then
    $cmd ${arg:-} 2>/dev/null
  else
    printf_newline "\n\n\n"
    printf_pause 1 "Sorry but $cmd doesn't seem to exist"
  fi
}
#run_prog_menus - graphical apps
__run_prog_menus() {
  local prog="$1" && shift 1
  local args="$*" && shift $#
  clear
  printf_newline "\n\n\n"
  if __command $prog; then
    __run_menu_start "$prog" "$args" && printf_counter "5" "3" "Launching $prog"
  else
    __attemp_install_menus "$prog" && __run_menu_start "$prog" "$args"
  fi
  clear
}
__edit_menu() {
  local EDITOR="$EDITOR"
  [ -f "$1" ] && local file="$1" && shift 1 || local file="$file"
  [ -d "$1" ] && local dir="$1" && shift 1 || local dir="${WDIR:-$HOME}"
  if __command dialog; then
    [ -n "$file" ] || file=$(dialog --title "Play a file" --stdout --title "Please choose a file to edit" --fselect "$dir/" 20 80 || __return 1)
    [ -f "$file" ] && __editor "$file" && __return 0 || __return 1 "Can not open file" "$file does not exists"
  else
    [ -f "$file" ] && __editor "$file" && __return 0 || __return 1 "Can not open file" "$file does not exists"
  fi
  __returnexitcode $?
}
##################### editor functions ####################
__editor() {
  local EDITOR="$EDITOR"
  if __command myeditor; then
    myeditor "$@"
  elif [ -n "$EDITOR" ] && __command -t "$EDITOR"; then
    $EDITOR "$@"
  elif __command vim; then
    local vimoptions="$vimoptions"
    __vim ${vimoptions:-} "$@"
  elif __command nano; then
    local nanooptions="$nanooptions"
    nano ${nanooptions:-} "$@"
  else
    printf_exit 1 1 "Can not open file: Please set the variable EDITOR=myeditor"
  fi
  return $?
}
##################### sudo functions ####################
__sudo() { $(builtin type -P sudo) --preserve-env=PATH -HE "$@" || return 1; }
__sudo_group() { grep "${1:-$USER}" /etc/group | grep -Eq 'wheel|adm|sudo' || return 1; }
sudoif() { (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null && return 0 || return 1; }
sudorun() { if sudoif; then sudo "$@"; else "$@"; fi; }
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
sudoreq() {
  if [[ $UID != 0 ]]; then
    if builtin type -P ask_for_password && ask_for_password; then
      return 0
    else
      printf_newline
      printf_error "Please run this script with sudo/root\n"
      exit 1
    fi
  fi
}
__can_i_sudo() { __sudo_group "${1:-$USER}" || sudoif; }
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
__sudoexit() {
  if __can_i_sudo; then
    __sudoask || printf_green "Getting privileges successfull continuing" && true
  else
    printf_red "Failed to get privileges\n" && false
    return 1
  fi
}
__requiresudo() {
  if __can_i_sudo; then
    __sudoask && __sudoexit && __sudo "$@" 2>/dev/null
  else
    printf_red "You dont have access to sudo\n\t\tPlease contact the syadmin for access"
    return 1
  fi
}
user_is_root() {
  if [[ $(id -u) -eq 0 ]] || [[ "$EUID" = 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    return 0
  else return 1; fi
}
if __sudo_group "$USER"; then
  __passwd() { sudo passwd "$*"; }
else
  __passwd() { passwd "$*"; }
fi

__newpasswd() {
  local oldpassword newpassword newpasswordc
  printf_read_passwd "3" "Enter old password for $1" "oldpassword"
  printf_read_passwd "3" "Enter new password for $1" "newpassword"
  printf_read_passwd "3" "Confirm new password for $1" "newpasswordc"
  [ "$oldpassword" = "$newpassword" ] && printf_exit "Password needs to be different"
  [ "$newpassword" = "$newpasswordc" ] || printf_exit "Passwords don't match"
  printf '%s\n%s\n%s' "$oldpassword" "$newpassword" "$newpasswordc" | __passwd "$1" &>/dev/null &&
    printf_green "Password has been updated" || printf_exit "Password change has failed"
}
###################### spinner and execute function ######################
# show a spinner while executing code or zenity
# if __command zenity && [ -n "$DISPLAY" ] && [ -z "$SSH_TTY" ]; then
#   __execute() {
#     local CMD="$1"
#     local MSG="$2"
#     $CMD | zenity --width=400 --progress --no-cancel --pulsate --auto-close --title="${APPNAME:-Executing}" --text="${MSG:-Executing commands}" || printf_readline "5"
#   }
# else
__execute() {
  __set_trap() { trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"; }
  __kill_all_subprocesses() {
    local i=""
    for i in $(jobs -p); do
      kill "$i"
      wait "$i" &>/dev/null
    done
  }
  __show_spinner() {
    local -r FRAMES='/-\|'
    local -r NUMBER_OR_FRAMES=${#FRAMES}
    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"
    local i=0
    local frameText=""
    while kill -0 "$PID" &>/dev/null; do
      frameText="                [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
      printf "%s" "$frameText"
      sleep 0.2
      printf "\r"
    done
  }
  local -r CMDS="$1"
  local -r MSG="${2:-$1} "
  local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
  local exitCode=0
  local cmdsPID=""
  __set_trap "EXIT" "__kill_all_subprocesses"
  eval "$CMDS" >/dev/null 2>"$TMP_FILE" &
  cmdsPID=$!
  __show_spinner "$cmdsPID" "$CMDS" "$MSG"
  wait "$cmdsPID" &>/dev/null
  exitCode=$?
  printf_execute_result $exitCode "$MSG"
  if [ $exitCode -ne 0 ]; then
    printf_execute_error_stream <"$TMP_FILE"
  fi
  rm -rf "$TMP_FILE"
  return $exitCode
}
# fi
#runpost "program"
__run_post() {
  local e="$1"
  local m="${e//__devnull//}"
  __execute "$e" "executing: $m"
  __setexitstatus
  set --
}
###################### exitcode functions ######################
#setexitstatus || setexitstatus $?
__setexitstatus() {
  local EXIT="$?"
  if [ -z "$EXIT" ] || [ -n "$1" ]; then local EXIT="$1"; fi
  local EXITSTATUS+="$EXIT"
  if [ "$EXITSTATUS" = 0 ]; then
    BG_EXIT="${BG_GREEN}"
    unset EXIT
    return 0
  else
    BG_EXIT="${BG_RED}"
    unset EXIT
    return 1
  fi
}
#returnexitcode $?
__returnexitcode() {
  [ -z "$1" ] || EXIT="${?:-0}"
  if [ "$EXIT" = 0 ]; then
    BG_EXIT="${BG_GREEN}"
    PS_SYMBOL=" 😺 "
    return 0
  elif [ "$EXIT" -gt 2 ]; then
    BG_EXIT="${BG_RED}"
    PS_SYMBOL=" ⁉️ "
    return "$EXIT"
  else
    BG_EXIT="${BG_RED}"
    PS_SYMBOL=" 😟 "
    return "$EXIT"
  fi
}
#getexitcode "$?" "OK Message" "Error Message"
__getexitcode() {
  local EXITCODE="${1:-$?}"
  test -n "$1" && test -z "${1//[0-9]/}" && local EXITCODE="$1" && shift 1
  if [ -n "$1" ]; then
    local PSUCCES="$1"
  elif [ -n "$SUCCES" ]; then
    local PSUCCES="$SUCCES"
  else
    local PSUCCES="Command successful"
  fi
  if [ -n "$2" ]; then
    local PERROR="$2"
  elif [ -n "$ERROR" ]; then
    local PERROR="$ERROR"
  else
    local PERROR="Last __command failed to complete"
  fi
  if [ "$EXITCODE" = 0 ]; then
    printf_cyan "$PSUCCES"
  else
    printf_error "$PERROR"
  fi
  __returnexitcode "$EXITCODE"
  return "$EXITCODE"
}
#return "code" "message 1" "message 2"
__return() {
  #clear
  printf_newline "\n"
  if [ -n "$2" ]; then printf_red "$2"; fi
  if [ -n "$3" ]; then printf_red "$3"; fi
  return "$1"
}
###################### OS Functions ######################
#alternative names
tf() { [ -f "$(builtin type -P timyfigue 2>/dev/null)" ] || [ -f "$(builtin type -P tf 2>/dev/null)" ] || return 1; }
cron() { [ -f "$(builtin type -P crond 2>/dev/null)" ] || [ -f "$(builtin type -P cron 2>/dev/null)" ] || return 1; }
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
gtk-2.0() { find /lib* /usr* -iname "*libgtk*2*.so*" -type f 2>/dev/null | grep -q . || return 1; }
gtk-3.0() { find /lib* /usr* -iname "*libgtk*3*.so*" -type f 2>/dev/null | grep -q . || return 1; }
transmission-remote-cli() { [ -f "$(builtin type -P transmission-remote-cli 2>/dev/null)" ] || [ -f "$(builtin type -P transmission-remote 2>/dev/null)" ] || return 1; }
export -f cron mlocate xfce4 imagemagick fdfind speedtest neovim chromium firefox gtk-2.0 gtk-3.0
export -f transmission-remote-cli cowsay xfce4-notifyd
##################################################################################################
__ask_confirm() {
  local appname="${PROG:-$APPNAME}"
  local question="${1:-Would you like to proceed?}"
  local command="${2:-true}"
  local name="${3:-$appname}"
  notify_good() {
    local prog="$name"
    local name="${1:-$prog}"
    local message="${command:-Command} was successfull"
    if [ -z "$SEND_NOTIFY" ]; then
      notifications "${prog:-$name}:" "$message" || printf_green "${prog:-$name}: $message"
      export YN_NOTIFY=yes
    fi
    return 0
  }
  notify_error() {
    local prog="$name"
    local name="${1:-$prog}"
    local message="${command:-Command} has failed"
    if [ -z "$SEND_NOTIFY" ]; then
      notifications "${prog:-$name}:" "$message" || printf_red "${prog:-$name}: $message"
      export YN_NOTIFY=yes
    fi
    return 1
  }
  __rofi() { [ "$(printf "No\\nYes" | rofi -dmenu -i -p "$1" -nb purple -sb white -sf black -nf gray)" = "Yes" ] && ${2:-true} || return 1; }
  __dmenu() { [ "$(printf "No\\nYes" | dmenu -i -p "$1" -nb purple -sb white -sf black -nf gray)" = "Yes" ] && ${2:-true} || return 1; }
  __zenity() { zenity --question --width=400 --text="$1" --ellipsize --default-cancel && $2 || return 1; }
  __dialog() { gdialog --trim --cr-wrap --colors --title "question" --yesno "$1" 15 40 && $2 || return 1; }
  __term() { printf_question_term "$1" "$2" || return 1; }
  if [ -n "$DISPLAY" ]; then
    if [ -n "$DESKTOP_SESSION" ]; then
      if __command zenity; then
        __zenity "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      elif __command rofi; then
        __rofi "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      elif __command dmenu; then
        __dmenu "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      elif __command gdialog; then
        __dialog "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      else
        __term "$question" "$command" && notify_good "${name:-$appname}" || notify_error "${name:-$appname}"
      fi
    elif [ -t 0 ]; then
      __term "$question" "$command" || notify_error
    fi
  else
    __term "$question" "$command" || notify_error
  fi
  return ${exitCode:-$?}
}
#function to get network device
__getlipaddr() {
  if __command -P route &>/dev/null || __command -P ip &>/dev/null; then
    if [[ "$OSTYPE" =~ ^darwin ]]; then
      NETDEV="$(route get default 2>/dev/null | grep interface | awk '{print $2}')"
    else
      NETDEV="$(ip route 2>/dev/null | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}')"
    fi
    if __command ipconfig; then
      CURRIP4="$(/sbin/ifconfig $NETDEV 2>/dev/null | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed s/addr://g | head -n1)"
      CURRIP6="$(/sbin/ifconfig "$NETDEV" 2>/dev/null | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1)"
    else
      CURRIP4="$(ip addr | grep inet 2>/dev/null | grep -vE "127|inet6" | tr '/' ' ' | awk '{print $2}' | head -n 1)"
      CURRIP6="$(ip addr | grep inet6 2>/dev/null | grep -v "::1/" -v | tr '/' ' ' | awk '{print $2}' | head -n 1)"
    fi
  else
    NETDEV="lo"
    CURRIP4="127.0.0.1"
    CURRIP6="::1"
  fi
}
#os_support oses
__os_support() {
  if [ -n "$1" ]; then
    OSTYPE="$(echo $1 | tr '[:upper:]' '[:lower:]')"
  else
    OSTYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
  fi
  case "$OSTYPE" in
  linux*) echo "Linux" ;;
  mac* | darwin*) echo "MacOS" ;;
  win* | msys* | mingw* | cygwin*) echo "Windows" ;;
  bsd*) echo "BSD" ;;
  solaris*) echo "Solaris" ;;
  *) echo "Unknown OS" ;;
  esac
}
#supported_oses oses
__supported_oses() {
  if [[ $# -eq 0 ]]; then return 1; fi
  local ARGS="$*"
  for os in $ARGS; do
    UNAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
    case "$os" in
    linux)
      if [[ "$UNAME" =~ ^linux ]]; then
        return 0
      else
        return 1
      fi
      ;;
    mac*)
      if [[ "$UNAME" =~ ^darwin ]]; then
        return 0
      else
        return 1
      fi
      ;;
    win*)
      if [[ "$UNAME" =~ ^ming ]]; then
        return 0
      else
        return 1
      fi
      ;;
    *) return ;;
    esac
  done
}
#unsupported_oses oses
__unsupported_oses() {
  for os in "$@"; do
    if [[ "$(echo $1 | tr '[:upper:]' '[:lower:]')" =~ $(os_support) ]]; then
      printf_red "\t\t$(os_support $os) is not supported\n"
      exit 1
    fi
  done
}
__if_os_id() {
  unset distroname distroversion distro_id distro_version
  if [ -f "/etc/os-release" ]; then
    #local distroname=$(grep "ID_LIKE=" /etc/os-release | sed 's#ID_LIKE=##' | tr '[:upper:]' '[:lower:]' | sed 's#"##g' | awk '{print $1}')
    local distroname=$(grep '^ID=' /etc/os-release | sed 's#ID=##g' | sed 's#"##g' | tr '[:upper:]' '[:lower:]')
    local distroversion=$(grep '^VERSION="' /etc/os-release | sed 's#VERSION="##g;s#"##g')
    local codename="$(grep VERSION_CODENAME /etc/os-release && grep ^VERSION_CODENAME /etc/os-release | sed 's#VERSION_CODENAME="##g;s#"##g' || true)"
  elif __command -p lsb_release &>/dev/null; then
    local distroname="$(lsb_release -a 2>/dev/null | grep 'Distributor ID' | awk '{print $3}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
    local distroversion="$(lsb_release -a 2>/dev/null | grep 'Release' | awk '{print $2}')"
  elif __command -p lsb-release &>/dev/null; then
    local distroname="$(lsb-release -a 2>/dev/null | grep 'Distributor ID' | awk '{print $3}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
    local distroversion="$(lsb-release -a 2>/dev/null | grep 'Release' | awk '{print $2}')"
  elif [ -f "/etc/redhat-release" ]; then
    local distroname=$(awk '{print $1}' /etc/redhat-release | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
    local distroversion=$(awk '{print $4}' /etc/redhat-release | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
  elif __command sw_vers; then
    local distroname="darwin"
    local distroversion="$(sw_vers -productVersion)"
  else
    return 1
  fi
  local in="$*"
  local def="${DISTRO}"
  local args="$(echo "${*:-$def}" | tr '[:upper:]' '[:lower:]')"
  for id_like in $args; do
    case "$id_like" in
    arch* | arco*)
      if [[ $distroname =~ ^arco ]] || [[ "$distroname" =~ ^arch ]]; then
        distro_id=Arch
        distro_version="$(cat /etc/os-release | grep '^BUILD_ID' | sed 's#BUILD_ID=##g')"
        return 0
      else
        return 1
      fi
      ;;
    rhel* | centos* | fedora*)
      if [[ "$distroname" =~ ^scientific ]] || [[ "$distroname" =~ ^redhat ]] || [[ "$distroname" =~ ^centos ]] || [[ "$distroname" =~ ^casjay ]] || [[ "$distroname" =~ ^fedora ]]; then
        distro_id=RHEL
        distro_version="$distroversion"
        return 0
      else
        return 1
      fi
      ;;
    debian* | ubuntu*)
      if [[ "$distroname" =~ ^kali ]] || [[ "$distroname" =~ ^parrot ]] || [[ "$distroname" =~ ^debian ]] || [[ "$distroname" =~ ^raspbian ]] ||
        [[ "$distroname" =~ ^ubuntu ]] || [[ "$distroname" =~ ^linuxmint ]] || [[ "$distroname" =~ ^elementary ]] || [[ "$distroname" =~ ^kde ]]; then
        distro_id=Debian
        distro_version="$distroversion"
        distro_codename="$codename"
        return 0
      else
        return 1
      fi
      ;;
    darwin* | mac*)
      if [[ "$distroname" =~ ^mac ]] || [[ "$distroname" =~ ^darwin ]]; then
        distro_id=MacOS
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
  # [ -z $distro_id ] || distro_id="Unknown"
  # [ -z $distro_version ] || distro_version="Unknown"
  # [ -n "$codename" ] && distro_codename="$codename" || distro_codename="N/A"
  # echo $id_like $distroname $distroversion $distro_codename
}
###################### setup folders - user ######################
user_installdirs() {
  #[ -n "$APPNAME" ] || APPNAME="$(__basename $0)"
  #[ -n "$APPDIR" ] || APPDIR="$(dirname $0)"
  #[ -n "$INSTDIR" ] || INSTDIR="$(dirname $0)"
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
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
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="$HOME/Library/Fonts"; else FONTDIR="$SHARE/fonts"; fi
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSTEMDDIR="$HOME/.config/systemd/user"
  fi
  REPORAW="${REPORAW:-$DFMGRREPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  installtype="user_installdirs"
}

###################### setup folders - system ######################
system_installdirs() {
  #[ -n "$APPNAME" ] || APPNAME="$(__basename $0)"
  #[ -n "$APPDIR" ] || APPDIR="$(dirname $0)"
  #[ -n "$INSTDIR" ] || INSTDIR="$(dirname $0)"
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
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
    SYSTEMDDIR="/etc/systemd/system"
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
    SYSCONF="$HOME/.config"
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
    SYSTEMDDIR="$HOME/.config/systemd/user"
  fi
  REPORAW="${REPORAW:-$DFMGRREPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  installtype="system_installdirs"
}

user_install() { user_installdirs; }
system_install() { system_installdirs; }

###################### devenv settings ######################
devenvmgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="devenv"
  APPDIR="${APPDIR:-$SHARE/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$DEVENVMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="devenvmgr_install"
  #__main_installer_info
}

###################### dfmgr settings ######################
dfmgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="dfmgr"
  APPDIR="${APPDIR:-$CONF}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$DFMGRREPO}"
  REPORAW="${REPORAW:-$DFMGRREPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  #[ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="dfmgr_install"
  #__main_installer_info
}

###################### dockermgr settings ######################
dockermgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="dockermgr"
  APPDIR="${APPDIR:-$SHARE/docker}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  DATADIR="${DATADIR:-/srv/docker/$APPNAME}"
  REPO="${REPO:-$DOCKERMGRREPO}"
  REPORAW="${REPORAw:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="dockermgr_install"
  #__main_installer_info
}

###################### fontmgr settings ######################
fontmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="fontmgr"
  APPDIR="${APPDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$FONTMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  FONTDIR="${FONTDIR:-$SHARE/fonts}"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  __mkd "$FONTDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="fontmgr_install"
  ######## Installer Functions ########
  generate_font_index() {
    printf_green "Updating the fonts in $FONTDIR"
    FONTDIR="${FONTDIR:-$SHARE/fonts}"
    fc-cache -f "$FONTDIR" &>/dev/null
  }
  #__main_installer_info
}

###################### iconmgr settings ######################
iconmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="iconmgr"
  APPDIR="${APPDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$ICONMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  __mkd "$ICONDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="iconmgr_install"
  ######## Installer Functions ########
  generate_icon_index() {
    printf_green "Updating the icon cache in $ICONDIR"
    ICONDIR="${ICONDIR:-$SHARE/icons}"
    fc-cache -f "$ICONDIR" &>/dev/null
    gtk-update-icon-cache -q -t -f "$ICONDIR" &>/dev/null
  }
  #__main_installer_info
}

###################### pkmgr settings ######################
pkmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="pkmgr"
  APPDIR="${APPDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$PKMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  REPODF="https://raw.githubusercontent.com/pkmgr/dotfiles/$GIT_REPO_BRANCH"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="pkmgr_install"
  #__main_installer_info
}

###################### systemmgr settings ######################
systemmgr_install() {
  #__requiresudo "true"
  system_installdirs
  SCRIPTS_PREFIX="systemmgr"
  APPDIR="${APPDIR:-/usr/local/etc}"
  INSTDIR="${INSTDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  CONF="/usr/local/etc"
  SHARE="/usr/local/share"
  REPO="${REPO:-$SYSTEMMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="systemmgr_install"
}

###################### thememgr settings ######################
thememgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="thememgr"
  APPDIR="${APPDIR:-SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$THEMEMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  THEMEDIR="${THEMEDIR:-$SHARE/themes}"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="thememgr_install"
  ######## Installer Functions ########
  generate_theme_index() {
    printf_green "Updating the theme index in $THEMEDIR"
    LISTARRAY="${*:-$APPNAME}"
    for index in $LISTARRAY; do
      THEMEDIR="${THEMEDIR:-$SHARE/themes}/${index:-}"
      if [ -d "$THEMEDIR" ]; then
        find "$THEMEDIR" -mindepth 0 -maxdepth 2 -type f,l,d -not -path "*/.git/*" 2>/dev/null | while read -r THEME; do
          if [ -f "$THEME/index.theme" ]; then
            __command gtk-update-icon-cache && gtk-update-icon-cache -qf "$THEME"
          fi
        done
      fi
    done
  }
  #__main_installer_info
}

###################### wallpapermgr settings ######################
wallpapermgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="wallpapermgr"
  APPDIR="${APPDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$WALLPAPERMGRREPO}"
  REPORAW="${REPORAW:-$WALLPAPERMGRREPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  #[ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$WALLPAPERS"
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  export installtype="wallpapermgr_install"
  #__main_installer_info
}

###################### create directories ######################
ensure_dirs() {
  $installtype
  if [[ $EUID -ne 0 ]] || [[ "$WHOAMI" != "root" ]]; then
    __mkd "$BIN"
    __mkd "$SHARE"
    __mkd "$LOGDIR"
    __mkd "$LOGDIR/dfmgr"
    __mkd "$LOGDIR/fontmg"
    __mkd "$LOGDIR/iconmgr"
    __mkd "$LOGDIR/systemmgr"
    __mkd "$LOGDIR/thememgr"
    __mkd "$LOGDIR/wallpapermgr"
    __mkd "$COMPDIR"
    __mkd "$STARTUP"
    __mkd "$BACKUPDIR"
    __mkd "$FONTDIR"
    __mkd "$ICONDIR"
    __mkd "$THEMEDIR"
    __mkd "$FONTCONF"
    __mkd "$CASJAYSDEVSHARE"
    __mkd "$CASJAYSDEVSAPPDIR"
    __mkd "$USRUPDATEDIR"
    __mkd "$SHARE/applications"
    __mkd "$SHARE/CasjaysDev/functions"
    __mkd "$SHARE/wallpapers/system"
    user_is_root && __mkd "$SYSUPDATEDIR"
  fi
  return 0
}
##################################################################################################
__main_installer_info() {
  if [ "$APPNAME" = "scripts" ] || [ "$APPNAME" = "installer" ]; then
    #APPNAME="installer"
    #APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
    #INSTDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
    PLUGDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  fi
  #printf_exit "A:$APPNAME D:$APPDIR I:$INSTDIR P:$PLUGDIR"
}
###################### get installer versions ######################

get_installer_version() {
  $installtype
  local GITREPO=""$REPO/$APPNAME""
  local APPVERSION="${APPVERSION:-$(__appversion ${1:-})}"
  [ -n "$WHOAMI" ] && printf_info "WhoamI:                    $WHOAMI"
  [ -n "$RUN_USER" ] && printf_info "SUDO USER:                 $RUN_USER"
  [ -n "$INSTALL_TYPE" ] && printf_info "Install Type:              $INSTALL_TYPE"
  [ -n "$APPNAME" ] && printf_info "APP name:                  $APPNAME"
  [ -n "$APPDIR" ] && printf_info "APP dir:                   $APPDIR"
  [ -n "$INSTDIR" ] && printf_info "Downloaded to:             $INSTDIR"
  [ -n "$GITREPO" ] && printf_info "APP repo:                  $REPO/$APPNAME"
  [ -n "$PLUGNAMES" ] && printf_info "Plugins:                   $PLUGNAMES"
  [ -n "$PLUGDIR" ] && printf_info "PluginsDir:                $PLUGDIR"
  [ -n "$version" ] && printf_info "Installed Version:         $version"
  [ -n "$APPVERSION" ] && printf_info "Online Version:            $APPVERSION"
  if [ "$version" = "$APPVERSION" ]; then
    printf_info "Update Available:          No"
  else
    printf_info "Update Available:          Yes"
  fi
}
sed_remove_empty() { sed '/^\#/d;/^$/d;s#^ ##g'; }
sed_head_remove() { awk -F'  :' '{print $2}'; }
sed_head() { sed -E 's|^.*#||g;s#^ ##g;s|^@||g'; }
grep_head() { grep -sE '[".#]?@[A-Z]' "${2:-$appname}" | grep "${1:-}" | head -n 12 | sed_head | sed_remove_empty | grep '^' || return 1; }
grep_head_remove() { grep -sE '[".#]?@[A-Z]' "${2:-$appname}" | grep "${1:-}" | grep -Ev 'GEN_SCRIPT_*|\${|\$\(' | sed_head_remove | sed '/^\#/d;/^$/d;s#^ ##g' | grep '^' || return 1; }
grep_version() { grep_head ''${1:-Version}'' "${2:-$appname}" | sed_head | sed_head_remove | sed_remove_empty | head -n1 | grep '^'; }
# grep_head() {
#   grep -v "$1" "$2" 2>/dev/null | grep '   :' |
#     grep -v '\$' |
#     grep -E ^'.*#.@'${1:-*}'' |
#     sed -E 's/..*#[#, ]@//g' |
#     sed -E 's/.*#[#, ]@//g' |
#     head -n14 |
#     grep '^' || return 1
# }
###################### help ######################
get_desc() {
  local PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin"
  local appname="$(type -P "${PROG:-$APPNAME}" 2>/dev/null || __command -p "${PROG:-$APPNAME}" 2>/dev/null)"
  local desc="$(grep_head_remove "Description" "$appname" | head -n1)"
  [ -n "$desc" ] && printf '%s' "$desc" || printf '%s' "$(__basename $appname) --help"
}
__help() {
  #----------------
  printf_help() {
    printf "%b" "$(tput setaf "${2:-4}" 2>/dev/null)" "\t\t$1" "$(tput sgr0 2>/dev/null)"
    printf '\n'
  }
  #----------------
  if [ -f "$CASJAYSDEVDIR/helpers/man/$APPNAME" ] && [ -s "$CASJAYSDEVDIR/helpers/man/$APPNAME" ]; then
    source "$CASJAYSDEVDIR/helpers/man/$APPNAME"
  else
    printf_help "There is no man page for this app in: "
    printf_help "$CASJAYSDEVDIR/helpers/man/$APPNAME"
  fi
  printf "\n"
  exit 0
}
__version() {
  local name="${1:-$(__basename $0)}" # get from os
  local prog="${APPNAME:-$PROG}"      # get from file
  local appname="${prog:-$name}"      # figure out wich one
  filename="$(type -P $appname)"      # get filename
  if [ -f "$filename" ]; then         # check for file
    printf_newline
    printf_green "Getting info for $appname"
    [ -n "$WHOAMI" ] && printf_yellow "WhoamI        : $WHOAMI"
    [ -n "$RUN_USER" ] && printf_yellow "SUDO USER:    : $RUN_USER"
    grep_head "Description" "$filename" &>/dev/null &&
      grep_head '' "$filename" | printf_readline "3" &&
      printf_green "$(grep_head "Version" "$filename" | head -n1)" &&
      printf_blue "Required ver  : $requiredVersion" ||
      printf_red "File was found, however, No information was provided"
  else
    printf_red "${1:-$appname} was not found"
  fi
  printf "\n"
}
###################### Set options ######################
__vdebug() {
  if [ -f ./applications.debug ]; then . ./applications.debug; fi
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  printf_debug 'APP:'$APPNAME' - ARGS:'$*''
  printf_debug "USER:$USER HOME:$HOME PREFIX:$SCRIPTS_PREFIX REPO:$REPO REPORAW:$REPORAW CONF:$CONF SHARE:$SHARE"
  printf_debug "APPDIR:$APPDIR USRUPDATEDIR:$USRUPDATEDIR SYSUPDATEDIR:$SYSUPDATEDIR"
  printf_custom "4" "FUNCTIONSDir:$DIR"
  exit
}

__full_app_info() {
  printf_info "APPNAME:                   $APPNAME"
  printf_info "App Dir:                   $APPDIR"
  printf_info "Install Dir:               $INSTDIR"
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
  printf_info "InstallType:               $installtype"
  printf_info "Prefix:                    $SCRIPTS_PREFIX"
  printf_info "SystemD dir:               $SYSTEMDDIR"
  printf_info "FunctionsDir:              $SCRIPTSFUNCTDIR"
  printf_info "FunctionsFile              $SCRIPTSFUNCTFILE"
  exit
}
__remove_app() {
  local exitCode=0
  local ARRAY="$*"
  for app in $ARRAY; do
    installer_delete "$*" || exitCode+=1
  done
  if [[ $exitCode -ne 0 ]]; then
    exit 1
  else
    exit 0
  fi
}

###################### *mgr scripts install/update/version ######################
export mgr_init="${mgr_init:-true}"
run_install_init() {
  $installtype
  local app=""
  local exitCode=""
  local LISTARRAY="$*"
  for app in $LISTARRAY; do
    __main_installer_info
    APPNAME="$app"
    REPO="$REPO/$APPNAME"
    REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    export APPNAME REPO REPORAW
    if user_is_root; then
      export SUDO_USER
      if [ -f "$INSTDIR/install.sh" ]; then
        sudo FORCE_INSTALL="$FORCE_INSTALL" bash -c "$INSTDIR/$app/install.sh"
      else
        if __urlcheck "$REPORAW/install.sh"; then
          sudo FORCE_INSTALL="$FORCE_INSTALL" bash -c "$(curl -q -LSs "$REPORAW/install.sh" 2>/dev/null)"
        else
          printf_error "Failed to initialize the installer from:"
          printf_exit "$REPORAW/install.sh\n"
        fi
      fi
      local exitCode+=$?
    else
      if [ -f "$INSTDIR/install.sh" ]; then
        FORCE_INSTALL="$FORCE_INSTALL" bash -c "$INSTDIR/install.sh"
      else
        if __urlcheck "$REPORAW/install.sh"; then
          FORCE_INSTALL="$FORCE_INSTALL" bash -c "$(curl -q -LSs "$REPORAW/install.sh" 2>/dev/null)"
        else
          printf_error "Failed to initialize the installer from:"
          printf_exit "$REPORAW/install.sh\n"
        fi
      fi
      local exitCode+=$?
    fi
    unset APPNAME REPO REPORAW
  done
  unset app
  return $exitCode
}

run_install_update() {
  local app=""
  local APPNAME=""
  local exitCode=0
  local mgr_init="${mgr_init:-true}"
  local NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME}"
  local NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON}"
  export mgr_init NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON
  if [ $# = 0 ]; then
    if [[ -d "$USRUPDATEDIR" && -n "$(ls -A "$USRUPDATEDIR" | grep '^' || ls "$SHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^')" ]]; then
      for app in $(ls "$USRUPDATEDIR" | grep '^' || ls "$SHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^'); do
        APPNAME="$app"
        run_install_init "$APPNAME" && __notifications "Installed $APPNAME" || __notifications "Installation of $APPNAME has failed"
        local exitCode+=$?
      done
    fi
    if user_is_root && [ "$USRUPDATEDIR" != "$SYSUPDATEDIR" ]; then
      if [[ -d "$SYSUPDATEDIR" && -n "$(ls -A "$SYSUPDATEDIR" | grep '^' || ls "$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^')" ]]; then
        for app in $(ls "$SYSUPDATEDIR" | grep '^' || ls "$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^'); do
          APPNAME="$app"
          run_install_init "$APPNAME" && __notifications "Installed $APPNAME" || __notifications "Installation of $APPNAME has failed"
          local exitCode+=$?
        done
      fi
    fi
  else
    local LISTARRAY="$*"
    for app in $LISTARRAY; do
      APPNAME="$app"
      run_install_init "$APPNAME" && __notifications "Installed $APPNAME" || __notifications "Installation of $APPNAME has failed"
      local exitCode+=$?
    done
  fi
  unset app
  return $exitCode
}

run_install_list() {
  local installed=""
  if [ $# -ne 0 ]; then
    local args="$*"
    for app in $args; do
      export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
      if [ -d "$USRUPDATEDIR" ] && [ -n "$(ls -A "$USRUPDATEDIR/$f" 2>/dev/null)" ]; then
        file="$(ls -A "$USRUPDATEDIR/$f" 2>/dev/null)"
        if [ -f "$file" ]; then
          printf_green "Information about $f:"
          printf_green "$(bash -c "$file --version")"
        fi
      elif [ -d "$SYSUPDATEDIR" ] && [ -n "$(ls -A "$SYSUPDATEDIR/$f" 2>/dev/null)" ] && [ "$USRUPDATEDIR" != "$SYSUPDATEDIR" ]; then
        file="$(ls -A "$SYSUPDATEDIR/$f" 2>/dev/null)"
        if [ -f "$file" ]; then
          printf_green "Information about $f:"
          printf_green "$(bash -c "$file --version")"
        fi
      else
        printf_red "File was not found is it installed?"
      fi
    done
  else
    if [ "$(__count_dir "$USRUPDATEDIR")" != 0 ]; then
      local -a LSINST="$(ls "$USRUPDATEDIR")"
      if [ -n "$LSINST" ]; then
        for app in "${LSINST[@]}"; do
          installed+="$(echo "$app" | sed 's| ||g' | grep -sv "^$") "
        done
        printf '%s\n' "$installed" | printf_column "4"
      fi
    elif [ "$(__count_dir "$SYSUPDATEDIR")" != 0 ]; then
      declare -a LSINST="$(ls "$SYSUPDATEDIR/")"
      if [ -n "${LSINST[0]}" ]; then
        for app in "${LSINST[@]}"; do
          installed+="$(echo "$app" | sed 's| ||g' | grep -sv "^$") "
        done
        printf '%s\n' "$installed" | printf_column "4"
      fi
    else
      printf_red "Nothing was found"
    fi
  fi
  unset args file app
  return $?
}

run_install_search() {
  [ $# = 0 ] && printf_exit "Nothing to search for"
  local results=""
  local -a LSINST="$*"
  for app in "${LSINST[@]}"; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    local -a results+="$(echo -e "$LIST" | grep -Fi "$app" | sed 's| ||g' | grep -sv '^$') "
  done
  results="$(echo "$results" | sort -u | tr '\n' ' ' | sed 's| | |g' | grep '^')"
  if [ -z "$results" ]; then
    printf_exit "Your seach produced no results"
  else
    printf '%s\n' "$installed" | printf_column "${PRINTF_COLOR:-4}"
  fi
  unset results app
  exit $?
}

run_install_available() {
  local app="$APPNAME"
  export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
  if __api_test ${1:-}; then
    __curl_api "$app" | jq -r '.[] | .name' 2>/dev/null | printf_readline "4"
  else
    __list_available ${*:-} | printf_column "${PRINTF_COLOR:-4}"
  fi
  unset app
}

run_install_version() {
  [ $# = 0 ] && local args="${PROG:-$APPNAME}" || local args="$*"
  local app=""
  local exitCode=0
  for app in $args; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    if [ -d "$USRUPDATEDIR" ] && [ -n "$(ls -A $USRUPDATEDIR/$app 2>/dev/null)" ]; then
      file="$(ls -A $USRUPDATEDIR/$app 2>/dev/null)"
      if [ -f "$file" ]; then
        printf_green "Information about $app: \n$(bash -c "$file --version" | sed '/^\#/d;/^$/d')"
      fi
    elif [ -d "$SYSUPDATEDIR" ] && [ -n "$(ls -A $SYSUPDATEDIR/$app 2>/dev/null)" ] && [ "$SYSUPDATEDIR" != "$USRUPDATEDIR" ]; then
      file="$(ls -A $SYSUPDATEDIR/$app 2>/dev/null)"
      if [ -f "$file" ]; then
        printf_green "Information about $app: \n$(bash -c "$file --version" | sed '/^\#/d;/^$/d')"
      fi
    elif __command -P $app &>/dev/null; then
      printf_green "$(bash -c "$app --version 2>/dev/null" | sed '/^\#/d;/^$/d')"
    else
      echo $USRUPDATEDIR/$app
      printf_red "File was not found is it installed?"
      exitCode+=1
      return 1
    fi
  done
  unset args app
  [ "$exitCode" = 0 ] && scripts_version || exit 1
}

installer_delete() {
  local app=""
  local exitCode=0
  local LISTARRAY="$*"
  for app in $LISTARRAY; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    local MESSAGE="${MESSAGE:-Removing $app from ${msg:-your system}}"
    if [ -d "$APPDIR/$app" ] || [ -d "$INSTDIR/$app" ]; then
      printf_yellow "$MESSAGE"
      printf_blue "Deleting the files"
      [ -d "$INSTDIR/$app" ] && __rm_rf "$INSTDIR/$app" || exitCode+=1
      __rm_rf "$APPDIR/$app" "$INSTDIR/$app" || exitCode+=1
      __rm_rf "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$app" || exitCode+=1
      __rm_rf "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$app" || exitCode+=1
      printf_yellow "Removing any broken symlinks"
      __broken_symlinks "$BIN" "$SHARE" "$COMPDIR" "$CONF" "$THEMEDIR" "$FONTDIR" "$ICONDIR" || exitCode+=1
      __getexitcode $exitCode "$app has been removed" " "
      return $exitCode
    else
      printf_error "1" "$exitCode" "$app doesn't seem to be installed"
    fi
  done
  unset app
  return ${exitCode}
}

##################################################################################################
# Versioning
__appversion() {
  local versionfile="${1:-$REPORAW/version.txt}"
  if [ -f "$INSTDIR/version.txt" ]; then
    get_localVersion="$(<$INSTDIR/version.txt)"
  fi
  localVersion="${get_localVersion:-$localVersion}"
  __curl "${versionfile}" 2>/dev/null | head -n1 || echo "$localVersion"
}

__required_version() {
  if [ -f "$CASJAYSDEVDIR/version.txt" ]; then
    local requiredVersion="${1:-$requiredVersion}"
    local currentVersion="${APPVERSION:-$currentVersion}"
    local rVersion="${requiredVersion//-git/}"
    local cVersion="${currentVersion//-git/}"
    if [ "$cVersion" -lt "$rVersion" ] && [ "$APPNAME" != "scripts" ] && [ "$SCRIPTS_PREFIX" != "systemmgr" ]; then
      printf_yellow "Requires version higher than $rVersion"
      printf_yellow "You will need to update for new features"
    fi
  fi
}

__required_version "$requiredVersion"
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

###################### export and call functions ######################
__getpythonver

###################### debugging tool ######################
# __load_debug() {
#   if [ -f ./applications.debug ]; then . ./applications.debug; fi
#   DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
#   printf_info "$(dirname $0)/$APPNAME"
#   printf_custom "4" "ARGS: $DEBUGARGS"
#   printf_custom "4" "FUNCTIONSDir: $DIR"
#   for path in USER:$USER HOME:$HOME PREFIX:$SCRIPTS_PREFIX CONF:$CONF SHARE:$SHARE \
#     USRUPDATEDIR:$USRUPDATEDIR SYSUPDATEDIR:$SYSUPDATEDIR; do
#     [ -z "$path" ] || printf_custom "4" $path
#   done
#   __devnull() {
#     TMP_FILE="$(mktemp "${TMP:-/tmp}"/_XXXXXXX.err)"
#     eval "$@" 2>"$TMP_FILE" >/dev/null && EXIT=0 || EXIT=1
#     [ ! -s "$TMP_FILE" ] || return_error "$1" "$TMP_FILE"
#     rm -rf "$TMP_FILE"
#     return $EXIT
#   }
#   __devnull1() { __devnull "$@"; }
#   __devnull2() { __devnull "$@"; }
#   return_error() {
#     PREV="$1"
#     ERRL="$2"
#     printf_red "Command $PREV failed"
#     cat "$ERRL" | printf_readline "3"
#   }
# }
###################### unload variables ######################
# unload_var_path() {
#   unset APPDIR APPVERSION ARRAY BACKUPDIR BIN CASJAYSDEVSAPPDIR CASJAYSDEVSHARE COMPDIR CONF DEVENVMGR
#   unset DFMGRREPO DOCKERMGRREPO FONTCONF FONTDIR FONTMGRREPO ICONDIR ICONMGRREPO INSTALL_TYPE
#   unset LIST PKMGRREPO SCRIPTS_PREFIX REPO REPODF REPORAW SHARE STARTUP SYSBIN SYSCONF SYSLOGDIR SYSSHARE SYSTEMMGRREPO
#   unset SYSSHARE SYSTEMMGRREPO SYSUPDATEDIR THEMEDIR THEMEMGRREPO USRUPDATEDIR WALLPAPERMGRREPO WALLPAPERS
# }
__runtest() {
  [ "$1" = "--x" ] && set -x && shift 1
  export LOG_FILE="${TMP:-$HOME/.local/tmp}/$APPNAME/$(date +'%Y-%m-%d').log"
  export LOG_FILE_ERR="${TMP:-$HOME/.local/tmp}/$APPNAME/$(date +'%Y-%m-%d').err"
  printf_cyan "Saving all output to $LOG_FILE"
  __printf_log "$1" 2>>"$LOG_FILE_ERR" >>"$LOG_FILE"
  __devnull() {
    local CMD="$1" && shift 1
    local ARGS="$*" && shift
    __printf_log "Running $CMD"
    eval $CMD $ARGS 2>>"$LOG_FILE_ERR" >>"$LOG_FILE"
  }
  # only send stdout to display
  __devnull1() {
    local CMD="$1" && shift 1
    local ARGS="$*" && shift
    __printf_log "Running $CMD"
    eval $CMD $ARGS 2>>"$LOG_FILE_ERR" >>"$LOG_FILE"
  }
  # send stderr to /dev/null
  __devnull2() {
    local CMD="$1" && shift 1
    local ARGS="$*" && shift
    __printf_log "Running $CMD"
    eval $CMD $ARGS 2>>"$LOG_FILE_ERR" >>"$LOG_FILE"
  }
  export -f devnull devnull1 devnull2 __printf_log
}
###################### call options ######################
__options() {
  $installtype
  case $1 in
  --test)
    __runtest "$*"
    ;;
  # --cron)
  #   shift 1
  #   [ "$1" = "--help" ] && printf_help 'Usage: '$APPNAME' --cron remove | add "command"' && exit 0
  #   [ "$1" = "--add" ] && shift 2 && __setupcrontab "0 0 * * *" "$*"
  #   [ "$1" = "--del" ] && shift 2 && echo $* # && __removecrontab "$*"
  #   exit "$?"
  #;;

  #--update) ###################### Update check ######################
  #  shift 1
  #  printf_error "Not enabled in apps: See the installer"
  #  exit
  #  ;;

  # --help) ###################### help ######################
  #   shift 1
  #   __help
  #   exit
  #   ;;

  # --version) ###################### get info from app ######################
  #   shift 1
  #   __version "${APPNAME:-$PROG}"
  #   exit
  #   ;;

  --vdebug) ###################### basic debug ######################
    shift 1
    __vdebug "$*"
    ;;

  --full) ###################### debug settings ######################
    shift 1
    __full_app_info
    ;;

  --remove | --uninstall)
    shift 1
    __remove_app "$*"
    ;;

  -*)
    export option_two="$2"
    ;;
  esac
}
user_install # default type
###################### end application functions ######################
