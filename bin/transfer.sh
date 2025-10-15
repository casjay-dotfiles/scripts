#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202208171951-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  transfer.sh --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Wednesday, Aug 17, 2022 19:51 EDT
# @@File             :  transfer.sh
# @@Description      :  Upload file to https://transfer.sh
# @@Changelog        :  New script
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  bash/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2120,SC2155,SC2199,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename -- "$0" 2>/dev/null)"
VERSION="202208171951-git"
USER="${SUDO_USER:-$USER}"
RUN_USER="${RUN_USER:-$USER}"
USER_HOME="${USER_HOME:-$HOME}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
TRANSFER_SH_REQUIRE_SUDO="${TRANSFER_SH_REQUIRE_SUDO:-no}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Reopen in a terminal
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set script title
#CASJAYS_DEV_TILE_FORMAT="${USER}@${HOSTNAME}:${PWD/#$HOME/~} - $APPNAME"
#CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}"
#[ -z "$CASJAYSDEV_TITLE_SET" ] && printf '\033]2│;%s\033\\' "$CASJAYS_DEV_TILE_FORMAT" && CASJAYSDEV_TITLE_SET="$APPNAME"
export CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}" CASJAYSDEV_TITLE_SET
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Initial debugging
[ "$1" = "--debug" ] && set -x && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Disables colorization
[ "$1" = "--raw" ] && export SHOW_RAW="true"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# pipes fail
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-testing.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Options are: *_install
# system user desktopmgr devenvmgr dfmgr dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
user_install && __options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Send all output to /dev/null
__devnull() {
  tee &>/dev/null && exitCode=0 || exitCode=1
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -'
# Send errors to /dev/null
__devnull2() {
  [ -n "$1" ] && local cmd="$1" && shift 1 || return 1
  eval $cmd "$*" 2>/dev/null && exitCode=0 || exitCode=1
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -'
# See if the executable exists
__cmd_exists() {
  local exitCode=0
  [ -n "$1" ] || return 0
  for cmd in "$@"; do
    if builtin command -v "$cmd" &>/dev/null; then
      exitCode=$((exitCode + 0))
    else
      exitCode=$((exitCode + 1))
    fi
  done
  [ $exitCode -eq 0 ] || exitCode=3
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for a valid internet connection
__am_i_online() {
  local exitCode=0
  curl -q -LSsfI --max-time 2 --retry 1 "${1:-https://1.1.1.1}" 2>&1 | grep -qi 'server:.*cloudflare' || exitCode=4
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# colorization
if [ "$SHOW_RAW" = "true" ]; then
  NC=""
  RESET=""
  BLACK=""
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  PURPLE=""
  CYAN=""
  WHITE=""
  ORANGE=""
  LIGHTRED=""
  BG_GREEN=""
  BG_RED=""
  ICON_INFO="[ info ]"
  ICON_GOOD="[ ok ]"
  ICON_WARN="[ warn ]"
  ICON_ERROR="[ error ]"
  ICON_QUESTION="[ ? ]"
  printf_column() { tee | grep '^'; }
  printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[ 0-9;]*[a-zA-Z],,g'; }
else
  printf_color() { printf "%b" "$(tput setaf "${2:-7}" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional printf_ colors
__printf_head() { printf_blue "$1"; }
__printf_opts() { printf_purple "$1"; }
__printf_line() { printf_cyan "$1"; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# output version
__version() { printf_cyan "$VERSION"; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# list options
__list_options() {
  printf_color "$1: " "$5"
  echo -ne "$2" | sed 's|:||g;s/'$3'/ '$4'/g' | tr '\n' ' '
  printf_newline
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# create the config file
__gen_config() {
  local NOTIFY_CLIENT_NAME="$APPNAME"
  if [ "$INIT_CONFIG" != "TRUE" ]; then
    printf_blue "Generating the config file in"
    printf_cyan "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
  fi
  [ -d "$TRANSFER_SH_CONFIG_DIR" ] || mkdir -p "$TRANSFER_SH_CONFIG_DIR"
  [ -d "$TRANSFER_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$TRANSFER_SH_CONFIG_BACKUP_DIR"
  [ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] &&
    cp -Rf "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" "$TRANSFER_SH_CONFIG_BACKUP_DIR/$TRANSFER_SH_CONFIG_FILE.$$"
  cat <<EOF >"$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
# Settings for transfer.sh
TRANSFER_SH_USER="${TRANSFER_SH_USER:-}"
TRANSFER_SH_GPG_PASS="${TRANSFER_SH_GPG_PASS:-}"
TRANSFER_SH_DAYS_MAX="${TRANSFER_SH_DAYS_MAX:-}"
TRANSFER_SH_SAVED_LINKS="${TRANSFER_SH_SAVED_LINKS:-}"
TRANSFER_SH_URL="${TRANSFER_SH_URL:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
TRANSFER_SH_OUTPUT_COLOR_1="${TRANSFER_SH_OUTPUT_COLOR_1:-}"
TRANSFER_SH_OUTPUT_COLOR_2="${TRANSFER_SH_OUTPUT_COLOR_2:-}"
TRANSFER_SH_OUTPUT_COLOR_GOOD="${TRANSFER_SH_OUTPUT_COLOR_GOOD:-}"
TRANSFER_SH_OUTPUT_COLOR_ERROR="${TRANSFER_SH_OUTPUT_COLOR_ERROR:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
TRANSFER_SH_NOTIFY_ENABLED="${TRANSFER_SH_NOTIFY_ENABLED:-}"
TRANSFER_SH_GOOD_NAME="${TRANSFER_SH_GOOD_NAME:-}"
TRANSFER_SH_ERROR_NAME="${TRANSFER_SH_ERROR_NAME:-}"
TRANSFER_SH_GOOD_MESSAGE="${TRANSFER_SH_GOOD_MESSAGE:-}"
TRANSFER_SH_ERROR_MESSAGE="${TRANSFER_SH_ERROR_MESSAGE:-}"
TRANSFER_SH_NOTIFY_CLIENT_NAME="${TRANSFER_SH_NOTIFY_CLIENT_NAME:-}"
TRANSFER_SH_NOTIFY_CLIENT_ICON="${TRANSFER_SH_NOTIFY_CLIENT_ICON:-}"
TRANSFER_SH_NOTIFY_CLIENT_URGENCY="${TRANSFER_SH_NOTIFY_CLIENT_URGENCY:-}"

EOF
  if builtin type -t __gen_config_local | grep -q 'function'; then __gen_config_local; fi
  if [ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ]; then
    [ "$INIT_CONFIG" = "TRUE" ] || printf_green "Your config file for $APPNAME has been created"
    . "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
    exitCode=0
  else
    printf_red "Failed to create the config file"
    exitCode=1
  fi
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Help function - Align to 50
__help() {
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "transfer.sh:  Upload file to https://transfer.sh - $VERSION"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "Usage: transfer.sh [options] [commands]"
  __printf_line "[file]                          - Upload file"
  __printf_line "cat [file] |transfer.sh]        - Upload from stdin"
  __printf_line "scan [file]                     - Scan a file for malware/viruses"
  __printf_line "virustotal [file/dir]           - Upload and scan a file"
  __printf_line "encrypt  [file/dir]             - encrypt and upload file"
  __printf_line "backup [file/dir]               - archive/encrypt and upload "
  __printf_line "list                            - List the link to uploaded files"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "Other Options"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "--help                          - Shows this message"
  __printf_line "--config                        - Generate user config file"
  __printf_line "--version                       - Show script version"
  __printf_line "--options                       - Shows all available options"
  __printf_line "--debug                         - Enables script debugging"
  __printf_line "--raw                           - Removes all formatting on output"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check if arg is a builtin option
__is_an_option() { if echo "$ARRAY" | grep -q "${1:-^}"; then return 1; else return 0; fi; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user root
__user_is_root() {
  { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; } && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user not root
__user_is_not_root() {
  if { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; }; then return 1; else return 0; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if user is a member of sudo
__sudo_group() {
  grep -sh "${1:-$USER}" "/etc/group" | grep -Eq 'wheel|adm|sudo' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# # Get sudo password
__sudoask() {
  ask_for_password sudo true && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Run sudo
__sudorun() {
  __sudoif && __cmd_exists sudo && sudo -HE "$@" || { __sudoif && eval "$@"; }
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Test if user has access to sudo
__can_i_sudo() {
  (sudo -vn && sudo -ln) 2>&1 | grep -vq 'may not' >/dev/null && return 0
  __sudo_group "${1:-$USER}" || __sudoif || __sudo true &>/dev/null || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User can run sudo
__sudoif() {
  __user_is_root && return 0
  __can_i_sudo "${RUN_USER:-$USER}" && return 0
  __user_is_not_root && __sudoask && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Run command as root
requiresudo() {
  if [ "$TRANSFER_SH_REQUIRE_SUDO" = "yes" ] && [ -z "$TRANSFER_SH_REQUIRE_SUDO_RUN" ]; then
    export TRANSFER_SH_REQUIRE_SUDO="no"
    export TRANSFER_SH_REQUIRE_SUDO_RUN="true"
    __sudo "$@"
    exit $?
  else
    return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute sudo
__sudo() {
  CMD="${1:-echo}" && shift 1
  CMD_ARGS="${*:--e "${RUN_USER:-$USER}"}"
  SUDO="$(builtin command -v sudo 2>/dev/null || echo 'eval')"
  [ "$(basename -- "$SUDO" 2>/dev/null)" = "sudo" ] && OPTS="--preserve-env=PATH -HE"
  if __sudoif; then
    export PATH="$PATH"
    $SUDO ${OPTS:-} $CMD $CMD_ARGS && true || false
    exitCode=$?
  else
    printf '%s\n' "This requires root to run"
    exitCode=1
  fi
  return ${exitCode:-1}
}
# End of sudo functions
# - - - - - - - - - - - - - - - - - - - - - - - - -
__trap_exit() {
  exitCode=${exitCode:-0}
  [ -f "$TRANSFER_SH_TEMP_FILE" ] && rm -Rf "$TRANSFER_SH_TEMP_FILE" &>/dev/null
  #unset CASJAYSDEV_TITLE_SET && printf '\033]2│;%s\033\\' "${USER}@${HOSTNAME}:${PWD/#$HOME/~} - ${CASJAYSDEV_TITLE_PREV:-$SHELL}"
  if builtin type -t __trap_exit_local | grep -q 'function'; then __trap_exit_local; fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined functions
__trap_exit_local() {
  [ -f "$TRANSFER_SH_STATUS_FILE" ] && __rm_rf "$TRANSFER_SH_STATUS_FILE"
  [ -f "$TRANSFER_SH_TMP_UPLOAD_FILE" ] && __rm_rf "$TRANSFER_SH_TMP_UPLOAD_FILE"
  [ -f "$TRANSFER_SH_TMP_SDTIN_FILE" ] && __rm_rf "$TRANSFER_SH_TMP_SDTIN_FILE"

}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__format_file_as_JSON_string() {
  sed -e 's/\\/\\\\/g' \
    -e 's/$/\\n/g' \
    -e 's/"/\\"/g' \
    -e 's/\t/\\t/g' |
    tr -d "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__filename() {
  local file="$1"
  if [ -d "$file" ]; then
    zip -r -q - "$file" 2>/dev/null >>"${TRANSFER_SH_TMP_UPLOAD_FILE}.zip" || printf_exit 1 10 "Failed to create zip file"
    file="${TRANSFER_SH_TMP_UPLOAD_FILE}.zip"
  elif [ -e "$file" ]; then
    if [[ "$file" = "$TRANSFER_SH_TMP_UPLOAD_FILE" ]]; then
      file="$TRANSFER_SH_TMP_UPLOAD_FILE"
    else
      cp -Rf "$file" "$TRANSFER_SH_TMP_UPLOAD_FILE" 2>/dev/null
    fi
  else
    printf_exit 1 1 "No file was found at $file"
  fi

  filename="$file"
  TRANSFER_SH_UPLOAD_NAME="$TRANSFER_SH_USER-$(basename -- "${filename}" 2>/dev/null | sed -e 's|[^a-zA-Z0-9._-]|-|g')"
  export filename TRANSFER_SH_UPLOAD_NAME
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__curl_upload() {
  curl -q -LSsf -H "Max-Days: $TRANSFER_SH_DAYS_MAX" --connect-timeout 2 --retry 0 --upload-file "$1" "$2" 2>"$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME"
  exitCode=$?
  sleep 1 # lets a a delay
  return "${exitCode:-0}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__curl_put() {
  curl -q -LSsf -H "Max-Days: $TRANSFER_SH_DAYS_MAX" -X PUT --connect-timeout 2 --retry 0 --upload-file "$1" "$2" 2>"$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME"
  exitCode=$?
  sleep 1 # lets a a delay
  return "${exitCode:-0}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__upload_status() {
  if [[ "${exitCode:-0}" = 0 ]] && [[ -f "$TRANSFER_SH_STATUS_FILE" ]] && [[ -s "$TRANSFER_SH_STATUS_FILE" ]]; then
    MESSAGE="$(cat "$TRANSFER_SH_STATUS_FILE" | grep -v '^$')"
    TRANSFER_SH_GOOD_MESSAGE="$(printf '%s: %s\n' "${1:-Link is}" "$MESSAGE")"
    printf_blue "$TRANSFER_SH_GOOD_MESSAGE"
    __notifications "$TRANSFER_SH_GOOD_MESSAGE"
    printf '%s - %s' "$filename" "$MESSAGE" >>"$TRANSFER_SH_SAVED_LINKS"
    printf '%s\n' "$MESSAGE" | clipboard --silent
    exitCode=0
  else
    echo "Server returned error" >$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME
    [ -s "$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME" ] && TRANSFER_SH_ERROR_MESSAGE="$(<"$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME")" || printf '%s' "An unknown error has occurred"
    printf_red "$TRANSFER_SH_ERROR_MESSAGE"
    [ -n "$error" ] && printf '%s\n' "$TRANSFER_SH_ERROR_MESSAGE" | printf_readline 5 &&
      __notifications "$TRANSFER_SH_ERROR_MESSAGE\n"
    exitCode=1
  fi
  return "${exitCode:-0}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined variables/import external variables

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
TRANSFER_SH_CONFIG_FILE="${TRANSFER_SH_CONFIG_FILE:-settings.conf}"
TRANSFER_SH_CONFIG_DIR="${TRANSFER_SH_CONFIG_DIR:-$HOME/.config/myscripts/transfer.sh}"
TRANSFER_SH_CONFIG_BACKUP_DIR="${TRANSFER_SH_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/transfer.sh/backups}"
TRANSFER_SH_LOG_DIR="${TRANSFER_SH_LOG_DIR:-$HOME/.local/log/transfer.sh}"
TRANSFER_SH_TEMP_DIR="${TRANSFER_SH_TEMP_DIR:-$HOME/.local/tmp/system_scripts/transfer.sh}"
TRANSFER_SH_CACHE_DIR="${TRANSFER_SH_CACHE_DIR:-$HOME/.cache/transfer.sh}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
TRANSFER_SH_OUTPUT_COLOR_1="${TRANSFER_SH_OUTPUT_COLOR_1:-33}"
TRANSFER_SH_OUTPUT_COLOR_2="${TRANSFER_SH_OUTPUT_COLOR_2:-5}"
TRANSFER_SH_OUTPUT_COLOR_GOOD="${TRANSFER_SH_OUTPUT_COLOR_GOOD:-2}"
TRANSFER_SH_OUTPUT_COLOR_ERROR="${TRANSFER_SH_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
TRANSFER_SH_NOTIFY_ENABLED="${TRANSFER_SH_NOTIFY_ENABLED:-yes}"
TRANSFER_SH_GOOD_NAME="${TRANSFER_SH_GOOD_NAME:-Great:}"
TRANSFER_SH_ERROR_NAME="${TRANSFER_SH_ERROR_NAME:-Error:}"
TRANSFER_SH_GOOD_MESSAGE="${TRANSFER_SH_GOOD_MESSAGE:-No errors reported}"
TRANSFER_SH_ERROR_MESSAGE="${TRANSFER_SH_ERROR_MESSAGE:-Errors were reported}"
TRANSFER_SH_NOTIFY_CLIENT_NAME="${TRANSFER_SH_NOTIFY_CLIENT_NAME:-$APPNAME}"
TRANSFER_SH_NOTIFY_CLIENT_ICON="${TRANSFER_SH_NOTIFY_CLIENT_ICON:-notification-new}"
TRANSFER_SH_NOTIFY_CLIENT_URGENCY="${TRANSFER_SH_NOTIFY_CLIENT_URGENCY:-normal}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional Variables
TRANSFER_SH_USER="${TRANSFER_SH_USER:-$USER}"
TRANSFER_SH_GPG_PASS="${TRANSFER_SH_GPG_PASS:-your_very_strong_password}"
TRANSFER_SH_DAYS_MAX="${TRANSFER_SH_DAYS_MAX:-30}"
TRANSFER_SH_URL="${TRANSFER_SH_URL:-https://transfer.sh}"
TRANSFER_SH_SAVED_LINKS="${TRANSFER_SH_SAVED_LINKS:-$HOME/Documents/myscripts/${APPNAME}_pastes.txt}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] || [ "$*" = "--config" ] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] && . "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$TRANSFER_SH_LOG_DIR" ] || mkdir -p "$TRANSFER_SH_LOG_DIR" |& __devnull
[ -d "$TRANSFER_SH_TEMP_DIR" ] || mkdir -p "$TRANSFER_SH_TEMP_DIR" |& __devnull
[ -d "$TRANSFER_SH_CACHE_DIR" ] || mkdir -p "$TRANSFER_SH_CACHE_DIR" |& __devnull
[ -d "$(dirname "$TRANSFER_SH_SAVED_LINKS")" ] || mkdir -p "$(dirname "$TRANSFER_SH_SAVED_LINKS")" |& __devnull
# - - - - - - - - - - - - - - - - - - - - - - - - -
TRANSFER_SH_TEMP_FILE="${TRANSFER_SH_TEMP_FILE:-$(mktemp $TRANSFER_SH_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap '__trap_exit' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
__notifications() {
  __cmd_exists notifications || return
  [ "$TRANSFER_SH_NOTIFY_ENABLED" = "yes" ] || return
  [ "$SEND_NOTIFICATION" = "no" ] && return
  (
    export SCRIPT_OPTS="" _DEBUG=""
    export NOTIFY_GOOD_MESSAGE="${NOTIFY_GOOD_MESSAGE:-$TRANSFER_SH_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${NOTIFY_ERROR_MESSAGE:-$TRANSFER_SH_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$TRANSFER_SH_NOTIFY_CLIENT_ICON}"
    export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$TRANSFER_SH_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_URGENCY="${NOTIFY_CLIENT_URGENCY:-$TRANSFER_SH_NOTIFY_CLIENT_URGENCY}"
    notifications "$@"
  ) |& __devnull &
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom actions

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Argument/Option settings
SETARGS=("$@")
# - - - - - - - - - - - - - - - - - - - - - - - - -
SHORTOPTS=""
SHORTOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
LONGOPTS="completions:,config,debug,dir:,help,options,raw,version,silent"
LONGOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
ARRAY="list scan virustotal backup encrypt"
ARRAY+=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
LIST=""
LIST+=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$APPNAME" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  --raw)
    shift 1
    export SHOW_RAW="true"
    NC=""
    RESET=""
    BLACK=""
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    PURPLE=""
    CYAN=""
    WHITE=""
    ORANGE=""
    LIGHTRED=""
    BG_GREEN=""
    BG_RED=""
    ICON_INFO="[ info ]"
    ICON_GOOD="[ ok ]"
    ICON_WARN="[ warn ]"
    ICON_ERROR="[ error ]"
    ICON_QUESTION="[ ? ]"
    printf_column() { tee | grep '^'; }
    printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[ 0-9;]*[a-zA-Z],,g'; }
    ;;
  --debug)
    shift 1
    set -xo pipefail
    export SCRIPT_OPTS="--debug"
    export _DEBUG="on"
    __devnull() { tee || return 1; }
    __devnull2() { eval "$@" |& tee -p || return 1; }
    ;;
  --completions)
    if [ "$2" = "short" ]; then
      printf '%s\n' "-$SHORTOPTS" | sed 's|"||g;s|:||g;s|,|,-|g' | tr ',' '\n'
    elif [ "$2" = "long" ]; then
      printf '%s\n' "--$LONGOPTS" | sed 's|"||g;s|:||g;s|,|,--|g' | tr ',' '\n'
    elif [ "$2" = "array" ]; then
      printf '%s\n' "$ARRAY" | sed 's|"||g;s|:||g' | tr ',' '\n'
    elif [ "$2" = "list" ]; then
      printf '%s\n' "$LIST" | sed 's|"||g;s|:||g' | tr ',' '\n'
    else
      exit 1
    fi
    shift 2
    exit $?
    ;;
  --options)
    shift 1
    printf_blue "Current options for ${PROG:-$APPNAME}"
    [ -z "$SHORTOPTS" ] || __list_options "Short Options" "-${SHORTOPTS}" ',' '-' 4
    [ -z "$LONGOPTS" ] || __list_options "Long Options" "--${LONGOPTS}" ',' '--' 4
    [ -z "$ARRAY" ] || __list_options "Base Options" "${ARRAY}" ',' '' 4
    [ -z "$LIST" ] || __list_options "LIST Options" "${LIST}" ',' '' 4
    exit $?
    ;;
  --version)
    shift 1
    __version
    exit $?
    ;;
  --help)
    shift 1
    __help
    exit $?
    ;;
  --config)
    shift 1
    __gen_config
    exit $?
    ;;
  --silent)
    shift 1
    TRANSFER_SH_SILENT="true"
    ;;
  --dir)
    CWD_IS_SET="TRUE"
    TRANSFER_SH_CWD="$2"
    #[ -d "$TRANSFER_SH_CWD" ] || mkdir -p "$TRANSFER_SH_CWD" |& __devnull
    shift 2
    ;;
  --)
    shift 1
    break
    ;;
  esac
done
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Get directory from args
# set -- "$@"
# for arg in "$@"; do
# if [ -d "$arg" ]; then
# TRANSFER_SH_CWD="$arg" && shift 1 && SET_NEW_ARGS=("$@") && break
# elif [ -f "$arg" ]; then
# TRANSFER_SH_CWD="$(dirname "$arg" 2>/dev/null)" && shift 1 && SET_NEW_ARGS=("$@") && break
# else
# SET_NEW_ARGS+=("$arg")
# fi
# done
# set -- "${SET_NEW_ARGS[@]}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set directory to first argument
# [ -d "$1" ] && __is_an_option "$1" && TRANSFER_SH_CWD="$1" && shift 1 || TRANSFER_SH_CWD="${TRANSFER_SH_CWD:-$PWD}"
TRANSFER_SH_CWD="$(realpath "${TRANSFER_SH_CWD:-$PWD}" 2>/dev/null)"
# if [ -d "$TRANSFER_SH_CWD" ] && cd "$TRANSFER_SH_CWD"; then
# if [ "$TRANSFER_SH_SILENT" != "true" ] && [ "$CWD_SILENCE" != "true" ]; then
# printf_cyan "Setting working dir to $TRANSFER_SH_CWD"
# fi
# else
# printf_exit "💔 $TRANSFER_SH_CWD does not exist 💔"
# fi
export TRANSFER_SH_CWD
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set actions based on variables

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
#requiresudo "$0" "$@" || exit 2     # exit 2 if errors
#cmd_exists --error --ask bash || exit 3 # exit 3 if not found
#am_i_online --error || exit 4           # exit 4 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
[ -n "$1" ] || [ -p "/dev/stdin" ] || { __help && exit; }
TRANSFER_SH_STATUS_FILE="$(mktemp -t XXXXXXXXXXXX)"
TRANSFER_SH_TMP_SDTIN_FILE="$(mktemp -t XXXXXXXXXXXX)"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute functions

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute commands

# - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
case "$1" in
list)
  shift 1
  printf_cyan "list of links:"
  cat "$TRANSFER_SH_SAVED_LINKS" | printf_column 4 | grep '^' || printf_yellow "No links were found!"
  exit $?
  ;;

scan)
  shift 1
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename -- "${1:-stdin}")-$(basename -- "$(mktemp -t XXXXXXXXX)")"
  if [ -p "/dev/sdtin" ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  __curl_upload "$TRANSFER_SH_TMP_UPLOAD_FILE" "https://transfer.sh/${TRANSFER_SH_UPLOAD_NAME}/scan" >>"$TRANSFER_SH_STATUS_FILE" || exitCode=1
  __upload_status "Scan results"
  ;;

virustotal)
  shift 1
  #printf_exit 5 1 "This seems to be broken as of July 15, 2022"
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename -- "${1:-stdin}")-$(basename -- "$(mktemp -t XXXXXXXXX)")"
  if [ -p "/dev/sdtin" ]; then
    cat - | __format_file_as_JSON_string >"$TRANSFER_SH_TMP_SDTIN_FILE"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  __curl_put "$TRANSFER_SH_TMP_UPLOAD_FILE" "https://transfer.sh/${TRANSFER_SH_UPLOAD_NAME}/virustotal" >>"$TRANSFER_SH_STATUS_FILE" || exitCode=1
  __upload_status "Virus results"
  ;;

encrypt)
  shift 1
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename -- "${1:-stdin}")-$(basename -- "$(mktemp -t XXXXXXXXX)")"
  if [ -p "/dev/sdtin" ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  cat "$TRANSFER_SH_TMP_UPLOAD_FILE" | gzip | gpg --passphrase "$TRANSFER_SH_GPG_PASS" --batch --quiet --yes -ac -o- |
    __curl_put "-" "https://transfer.sh/${TRANSFER_SH_UPLOAD_NAME}" >>"$TRANSFER_SH_STATUS_FILE" ||
    exitCode=1
  __upload_status "Backed up to"
  ;;

backup)
  shift 1
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename -- "${1:-stdin}")-$(basename -- "$(mktemp -t XXXXXXXXX)")"
  if [ ! -t 0 ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE" && mv -f "$TRANSFER_SH_TMP_SDTIN_FILE" "$TRANSFER_SH_TMP_UPLOAD_FILE.gz"
    TRANSFER_SH_TMP_UPLOAD_FILE="$TRANSFER_SH_TMP_UPLOAD_FILE.gz"
    [ -f "$TRANSFER_SH_TMP_UPLOAD_FILE" ] || printf_exit 5 5 "Well something went wrong"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  cat "$TRANSFER_SH_TMP_UPLOAD_FILE" | gzip | gpg --passphrase "$TRANSFER_SH_GPG_PASS" --batch --quiet --yes -ac -o- |
    __curl_put "-" "https://transfer.sh/${TRANSFER_SH_UPLOAD_NAME}" >>"$TRANSFER_SH_STATUS_FILE" ||
    exitCode=1
  __upload_status "Backed up to"
  ;;

*)
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename -- "${1:-stdin}")-$(basename -- "$(mktemp -t XXXXXXXXX)")"
  if [ -p "/dev/sdtin" ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  __curl_upload "$TRANSFER_SH_TMP_UPLOAD_FILE" "https://transfer.sh/$TRANSFER_SH_UPLOAD_NAME" >>"$TRANSFER_SH_STATUS_FILE" ||
    exitCode=1
  __upload_status "Link is"
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set exit code
exitCode="${exitCode:-0}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-0}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
