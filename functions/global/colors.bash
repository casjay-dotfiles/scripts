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
#setup colors
NC="$(tput sgr0 2>/dev/null)"
RESET="$(tput sgr0 2>/dev/null)"
BLACK="\033[0;30m"
RED="\033[0;91m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
ORANGE="\033[0;33m"
LIGHTRED='\033[0;91m'
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
  __printf_color() { printf_color "$1"; }
  printf_color() { printf '%b' "$1" | tr -d '\t'; }
  __printf_space() { printf "%b%${1:-30}s" "${2}" "${3}"; }
else
  __printf_color() { printf_color "$@"; }
  printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
  __printf_space() { printf "%b%${1:-30}s" "$(tput setaf "${4:-5}" 2>/dev/null)${2}" "${3}$(tput sgr0 2>/dev/null)"; }
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
  file="${1:--}"
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
# printf_space space message value
__printf_space() {
  test -n "$1" && test -z "${1//[0-9]/}" && local padl="$1" && shift 1 || local padl="40"
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="7"
  local string1="$1"
  local string2="$2"
  local pad=$(printf '%0.1s' " "{1..60})
  local message="$(printf "%b" "$(tput setaf "$color" 2>/dev/null)")"
  message+="$(printf '%s' "$string1") "
  message+="$(printf '%*.*s' 0 $((padl - ${#string1} - ${#string2})) "$pad") "
  message+="$(printf '%s' "$string2") "
  message+="$(printf '%b\n' "$(tput sgr0 2>/dev/null)")"
  printf '%s\n' "$message"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__printf_center() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="7"
  local head="$(printf '=%.0s' $(seq 1 $(tput cols)))"
  local mess="$(echo "$1" | sed -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols))"
  local foot="$(printf '=%.0s' $(seq 1 $(tput cols)))"
  __printf_color "$color" "$head"
  __printf_color "$color" "$mess"
  __printf_color "$color" "$foot"

}
