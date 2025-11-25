#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202208111053-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  ix.io --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Thursday, Aug 11, 2022 10:53 EDT
# @@File             :  ix.io
# @@Description      :  command line pastebin tool to post to ix.io
# @@Changelog        :  New script
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  bash/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2120,SC2155,SC2199,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename -- "$0" 2>/dev/null)"
VERSION="202208111053-git"
USER="${SUDO_USER:-$USER}"
RUN_USER="${RUN_USER:-$USER}"
USER_HOME="${USER_HOME:-$HOME}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
IX_IO_REQUIRE_SUDO="${IX_IO_REQUIRE_SUDO:-no}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Reopen in a terminal
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set script title
#CASJAYS_DEV_TILE_FORMAT="${USER}@${HOSTNAME}:${PWD/#$HOME/~} - $APPNAME"
#CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}"
#[ -z "$CASJAYSDEV_TITLE_SET" ] && printf '\033]0;%s\007' "$CASJAYS_DEV_TILE_FORMAT" && CASJAYSDEV_TITLE_SET="$APPNAME"
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
    printf_cyan "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE"
  fi
  [ -d "$IX_IO_CONFIG_DIR" ] || mkdir -p "$IX_IO_CONFIG_DIR"
  [ -d "$IX_IO_CONFIG_BACKUP_DIR" ] || mkdir -p "$IX_IO_CONFIG_BACKUP_DIR"
  [ -f "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" ] &&
    cp -Rf "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" "$IX_IO_CONFIG_BACKUP_DIR/$IX_IO_CONFIG_FILE.$$"
  cat <<EOF >"$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE"
# Settings for ix.io
IX_IO_USER_NAME="${IX_IO_USER_NAME:-}"
IX_IO_USER_PASS="${IX_IO_USER_PASS:-}"
IX_IO_BROWSER="${IX_IO_BROWSER:-}"
IX_IO_SERVER_HOST="${IX_IO_SERVER_HOST:-}"
IX_IO_SAVED_URL_FILE="${IX_IO_SAVED_URL_FILE:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
IX_IO_OUTPUT_COLOR_1="${IX_IO_OUTPUT_COLOR_1:-}"
IX_IO_OUTPUT_COLOR_2="${IX_IO_OUTPUT_COLOR_2:-}"
IX_IO_OUTPUT_COLOR_GOOD="${IX_IO_OUTPUT_COLOR_GOOD:-}"
IX_IO_OUTPUT_COLOR_ERROR="${IX_IO_OUTPUT_COLOR_ERROR:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
IX_IO_NOTIFY_ENABLED="${IX_IO_NOTIFY_ENABLED:-}"
IX_IO_GOOD_NAME="${IX_IO_GOOD_NAME:-}"
IX_IO_ERROR_NAME="${IX_IO_ERROR_NAME:-}"
IX_IO_GOOD_MESSAGE="${IX_IO_GOOD_MESSAGE:-}"
IX_IO_ERROR_MESSAGE="${IX_IO_ERROR_MESSAGE:-}"
IX_IO_NOTIFY_CLIENT_NAME="${IX_IO_NOTIFY_CLIENT_NAME:-}"
IX_IO_NOTIFY_CLIENT_ICON="${IX_IO_NOTIFY_CLIENT_ICON:-}"
IX_IO_NOTIFY_CLIENT_URGENCY="${IX_IO_NOTIFY_CLIENT_URGENCY:-}"

EOF
  if builtin type -t __gen_config_local | grep -q 'function'; then __gen_config_local; fi
  if [ -f "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" ]; then
    [ "$INIT_CONFIG" = "TRUE" ] || printf_green "Your config file for $APPNAME has been created"
    . "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE"
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
  __printf_opts "ix.io:  command line pastebin tool to post to ix.io - $VERSION"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "Usage: ix.io [options] [commands] [File,Text]"
  __printf_line "*                               - Paste file or text"
  __printf_line "post                            - Paste file or text"
  __printf_line "create                          - Creates a new user"
  __printf_line "latest                          - Get the latest posts"
  __printf_line "user                            - "
  __printf_line "id                              - "
  __printf_line "raw                             - "
  __printf_line "-d [id]                         - Delete paste "
  __printf_line "-i [id]                         - Replace ID"
  __printf_line "-n [number]                     - Self destruct after x reads"
  __printf_line "--anonymous                     - Post anonymously if you have username set"
  __printf_line "--user                          - Creates a new user"
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
  if [ "$IX_IO_REQUIRE_SUDO" = "yes" ] && [ -z "$IX_IO_REQUIRE_SUDO_RUN" ]; then
    export IX_IO_REQUIRE_SUDO="no"
    export IX_IO_REQUIRE_SUDO_RUN="true"
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
  [ -f "$IX_IO_TEMP_FILE" ] && rm -Rf "$IX_IO_TEMP_FILE" &>/dev/null
  #unset CASJAYSDEV_TITLE_SET && printf '\033]2│;%s\033\\' "${USER}@${HOSTNAME}:${PWD/#$HOME/~} - ${CASJAYSDEV_TITLE_PREV:-$SHELL}"
  if builtin type -t __trap_exit_local | grep -q 'function'; then __trap_exit_local; fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined functions
__browser() {
  if [ -n "$DISPLAY" ] && [ -z "$SSH_CONECTION" ]; then
    if __cmd_exists; then
      mybrowser "$1"
    elif [ -n "$BROWSER" ]; then
      $BROWSER "$1"
    else
      printf_red "Can not determine a browser to use."
      printf_red "You can set the browser in $IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE."
    fi
  else
    if __cmd_exists; then
      mybrowser --console "$1"
    elif __cmd_exists lynx; then
      lynx "$1"
    else
      printf_red "Can not determine a browser to use."
      printf_red "You can set the browser in $IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE."
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__write_to_temp() {
  local filepath"" filename="" fileheader="" filefooter=""
  filepath="$(realpath "$1")"
  filename="$(echo "$filepath" | sed 's|'$HOME'|~|g')"
  fileheader="### Contents from file: "
  filefooter="### End of the file from: "
  printf_file_info "$fileheader" "$filename"
  cat "$filepath" | __tee "${IX_IO_TEMP_FILE}"
  printf_file_info "$filefooter" "$filename"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__curl() {
  if [ -n "$IX_IO_USER_NAME" ] && [ -n "$IX_IO_USER_PASS" ]; then
    curl -q -LSsf -4 --user "$IX_IO_USER_NAME:$IX_IO_USER_PASS" --basic "$@" 2>/dev/null
    return $?
  else
    curl -q -LSsf -4 "$@" 2>/dev/null
    return $?
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__tee() { tee -a "${1:-$IX_IO_TEMP_FILE}" &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
printf_file_info() {
  [ -z "$fileinfo" ] || return 0
  printf '%s %s\n\n' "$1" "$2" | __tee "${3:-$IX_IO_TEMP_FILE}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__delete_post() {
  id="$(basename -- "$1")"
  response="$(__curl --max-time 3 -X DELETE "$IX_IO_SERVER_HOST/$id" 2>&1)"
  if [ -n "$response" ]; then
    if echo "$response" | grep -q "couldn't delete"; then
      res="Failed to delete paste ID: $id"
    elif echo "$response" | grep -q "deleted"; then
      res="Deleted paste ID: $id"
    else
      res="$response"
    fi
    printf_cyan "${res^}"
    exitCode=0
  else
    printf_red "Something went wrong"
    exitCode=1
  fi
  exit $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__create_user() {
  if [ -z "$IX_IO_USER_NAME" ]; then
    USER="$USER-$(gen-passwd --silent --raw --no-upper --no-chars --length 4)"
    printf_read_input "5" "What is your username? [$USER]" "120" "$IX_IO_USER_NAME"
  fi
  if [ -z "$IX_IO_USER_PASS" ]; then
    PASS="$(gen-passwd --silent --raw --no-chars --length 16)"
    printf_read_input "5" "What is your password? [$PASS]" "120" "$IX_IO_USER_NAME"
  fi
  [ -n "$IX_IO_USER_NAME" ] || printf_exit "Failed to set username"
  [ -z "$IX_IO_USER_PASS" ] && [ -n "$PASS" ] && IX_IO_USER_PASS="$PASS"
  [ -n "$IX_IO_USER_PASS" ] && printf_cyan "Password has been saved as $IX_IO_USER_PASS" || printf_exit "Failed to set password"
  #
  printf_green "Attempting to create the account on $IX_IO_SERVER_HOST"
  res="$(curl -q -LSsf --max-time 3 --retry 0 -X POST --user "$IX_IO_USER_NAME:$IX_IO_USER_PASS" "$IX_IO_SERVER_HOST" 2>&1)"
  if echo "$res" | grep -qi 'user.*.added'; then
    printf_green "$IX_IO_USER_NAME has been created"
    __gen_config &>/dev/null
    exitCode=0
  else
    printf_yellow "Either the user $IX_IO_USER_NAME exists or something went wrong"
    [ -n "$res" ] && echo "$res" | printf_readline
    exitCode=1
  fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined variables/import external variables

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
IX_IO_CONFIG_FILE="${IX_IO_CONFIG_FILE:-settings.conf}"
IX_IO_CONFIG_DIR="${IX_IO_CONFIG_DIR:-$HOME/.config/myscripts/ix.io}"
IX_IO_CONFIG_BACKUP_DIR="${IX_IO_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/ix.io/backups}"
IX_IO_LOG_DIR="${IX_IO_LOG_DIR:-$HOME/.local/log/ix.io}"
IX_IO_TEMP_DIR="${IX_IO_TEMP_DIR:-$HOME/.local/tmp/system_scripts/ix.io}"
IX_IO_CACHE_DIR="${IX_IO_CACHE_DIR:-$HOME/.cache/ix.io}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
IX_IO_OUTPUT_COLOR_1="${IX_IO_OUTPUT_COLOR_1:-33}"
IX_IO_OUTPUT_COLOR_2="${IX_IO_OUTPUT_COLOR_2:-5}"
IX_IO_OUTPUT_COLOR_GOOD="${IX_IO_OUTPUT_COLOR_GOOD:-2}"
IX_IO_OUTPUT_COLOR_ERROR="${IX_IO_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
IX_IO_NOTIFY_ENABLED="${IX_IO_NOTIFY_ENABLED:-yes}"
IX_IO_GOOD_NAME="${IX_IO_GOOD_NAME:-Great:}"
IX_IO_ERROR_NAME="${IX_IO_ERROR_NAME:-Error:}"
IX_IO_GOOD_MESSAGE="${IX_IO_GOOD_MESSAGE:-No errors reported}"
IX_IO_ERROR_MESSAGE="${IX_IO_ERROR_MESSAGE:-Errors were reported}"
IX_IO_NOTIFY_CLIENT_NAME="${IX_IO_NOTIFY_CLIENT_NAME:-$APPNAME}"
IX_IO_NOTIFY_CLIENT_ICON="${IX_IO_NOTIFY_CLIENT_ICON:-notification-new}"
IX_IO_NOTIFY_CLIENT_URGENCY="${IX_IO_NOTIFY_CLIENT_URGENCY:-normal}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional Variables
IX_IO_USER_NAME="${IX_IO_USER_NAME:-}"
IX_IO_USER_PASS="${IX_IO_USER_PASS:-}"
IX_IO_BROWSER="${IX_IO_BROWSER:-$BROWSER}"
IX_IO_SERVER_HOST="${IX_IO_SERVER_HOST:-http://ix.io}"
IX_IO_SAVED_URL_FILE="${IX_IO_SAVED_URL_FILE:-$HOME/Documents/myscripts/${APPNAME}_pastes.txt}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" ] || [ "$*" = "--config" ] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" ] && . "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$IX_IO_LOG_DIR" ] || mkdir -p "$IX_IO_LOG_DIR" |& __devnull
[ -d "$IX_IO_TEMP_DIR" ] || mkdir -p "$IX_IO_TEMP_DIR" |& __devnull
[ -d "$IX_IO_CACHE_DIR" ] || mkdir -p "$IX_IO_CACHE_DIR" |& __devnull
[ -d "$(dirname "$IX_IO_SAVED_URL_FILE")" ] || mkdir -p "$(dirname "$IX_IO_SAVED_URL_FILE")" |& __devnull
# - - - - - - - - - - - - - - - - - - - - - - - - -
IX_IO_TEMP_FILE="${IX_IO_TEMP_FILE:-$(mktemp $IX_IO_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap '__trap_exit' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
__notifications() {
  __cmd_exists notifications || return
  [ "$IX_IO_NOTIFY_ENABLED" = "yes" ] || return
  [ "$SEND_NOTIFICATION" = "no" ] && return
  (
    export SCRIPT_OPTS="" _DEBUG=""
    export NOTIFY_GOOD_MESSAGE="${NOTIFY_GOOD_MESSAGE:-$IX_IO_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${NOTIFY_ERROR_MESSAGE:-$IX_IO_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$IX_IO_NOTIFY_CLIENT_ICON}"
    export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$IX_IO_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_URGENCY="${NOTIFY_CLIENT_URGENCY:-$IX_IO_NOTIFY_CLIENT_URGENCY}"
    notifications "$@"
  ) |& __devnull &
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom actions

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Argument/Option settings
SETARGS=("$@")
# - - - - - - - - - - - - - - - - - - - - - - - - -
SHORTOPTS="d:,i:,n:"
SHORTOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
LONGOPTS="completions:,config,debug,dir:,help,options,raw,version,silent"
LONGOPTS+=",anon,anonymous,user"
# - - - - - - - - - - - - - - - - - - - - - - - - -
ARRAY="latest user id raw post"
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
    IX_IO_SILENT="true"
    ;;
  --dir)
    CWD_IS_SET="TRUE"
    IX_IO_CWD="$2"
    [ -d "$IX_IO_CWD" ] || mkdir -p "$IX_IO_CWD" |& __devnull
    shift 2
    ;;
  --anon | --anonymous)
    shift 1
    IX_IO_USER_NAME=""
    IX_IO_USER_PASS=""
    ;;
  --user)
    shift 1
    __create_user
    exit $?
    ;;
  -d)
    __delete_post "$2"
    exit $?
    shift 2
    ;;
  -i)
    ID="$(basename -- "$2")"
    POST_TYPE="PUT"
    printf_cyan "Updating paste ID: $ID"
    IX_IO_SERVER_HOST="$IX_IO_SERVER_HOST/$ID"
    shift 2
    ;;
  -n)
    printf_cyan "Setting autonuke to $2 reads"
    opts+="-F read:1=$2"
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
# IX_IO_CWD="$arg" && shift 1 && SET_NEW_ARGS=("$@") && break
# elif [ -f "$arg" ]; then
# IX_IO_CWD="$(dirname "$arg" 2>/dev/null)" && shift 1 && SET_NEW_ARGS=("$@") && break
# else
# SET_NEW_ARGS+=("$arg")
# fi
# done
# set -- "${SET_NEW_ARGS[@]}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set directory to first argument
# [ -d "$1" ] && __is_an_option "$1" && IX_IO_CWD="$1" && shift 1 || IX_IO_CWD="${IX_IO_CWD:-$PWD}"
IX_IO_CWD="$(realpath "${IX_IO_CWD:-$PWD}" 2>/dev/null)"
# if [ -d "$IX_IO_CWD" ] && cd "$IX_IO_CWD"; then
# if [ "$IX_IO_SILENT" != "true" ] && [ "$CWD_SILENCE" != "true" ]; then
# printf_cyan "Setting working dir to $IX_IO_CWD"
# fi
# else
# printf_exit "💔 $IX_IO_CWD does not exist 💔"
# fi
export IX_IO_CWD
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set actions based on variables

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
#requiresudo "$0" "$@" || exit 2     # exit 2 if errors
#cmd_exists --error --ask bash || exit 3 # exit 3 if not found
#am_i_online --error || exit 4           # exit 4 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute functions

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute commands
printf_exit "It appears ix.io has shutdown"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
case "$1" in
latest)
  shift 1
  __browser "$IX_IO_SERVER_HOST/user/"
  ;;

user)
  shift 1
  __browser "$IX_IO_SERVER_HOST/user/$1/"
  ;;

id)
  shift 1
  __curl "$IX_IO_SERVER_HOST/$1+"
  ;;

raw)
  shift 1
  __curl "$IX_IO_SERVER_HOST/$1"
  ;;

create)
  shift 1
  __create_user
  exit $?
  ;;

*)
  [ "$1" = "post" ] && shift 1
  # from IX_IO_CWD
  if [ "$CWD_IS_SET" = "TRUE" ]; then
    rm -Rf "$IX_IO_TEMP_FILE"
    for file in "$IX_IO_CWD/"*; do
      if [ -f "$file" ]; then
        __write_to_temp "$file"
      fi
    done
    filename="$IX_IO_TEMP_FILE"
    type="directory"
  # from pipe
  elif [ $# -eq 0 ] && [ -p "/dev/stdin" ]; then
    rm -Rf "$IX_IO_TEMP_FILE"
    cat - | __tee "$IX_IO_TEMP_FILE"
    filename="$IX_IO_TEMP_FILE"
    type="stdin"
    # from files/directory
  elif [ -e "$1" ]; then
    rm -Rf "$IX_IO_TEMP_FILE"
    if [ $# -eq 1 ] && [ -f "$1" ]; then
      filename="$1"
      type="files"
    else
      for file in "$@"; do
        if [ -f "$file" ]; then
          __write_to_temp "$file"
        elif [ -d "$file" ]; then
          for dir in "$file/"*; do
            if [ -f "$dir" ]; then
              __write_to_temp "$dir"
            fi
          done
        fi
      done
      filename="$IX_IO_TEMP_FILE"
      type="files"
    fi
    # from input
  elif [ $# -ne 0 ] && [ ! -e "$1" ]; then
    rm -Rf "$IX_IO_TEMP_FILE"
    for line in "$@"; do
      printf '%s\n' "$line" | __tee "$IX_IO_TEMP_FILE"
    done
    filename="$IX_IO_TEMP_FILE"
    type="input"
  else
    printf_exit "No input was received"
  fi
  # size in bytes
  minimum_size="1"
  maximum_size="1024"
  actual_size=$(du -k "$filename" | awk '{print $1}' | head -n1)
  if [ "$actual_size" -gt $maximum_size ]; then
    printf_exit "The file is to large - File must be smaller than $maximum_size kilobytes"
  fi
  if [ -f "$filename" ]; then
    printf_yellow "Posting from $filename"
    post="$(__curl -X ${POST_TYPE:-POST} -F f:1=@"$filename" $opts "$IX_IO_SERVER_HOST" || echo 'error')"
  else
    post=""
  fi
  if [ "$post" = "error" ]; then
    printf_red "Well something went wrong while trying to post"
    exitCode=1
  elif echo "$post" | grep -qi "couldn't replace"; then
    __notifications "$APPNAME" "Failed to update: $ID"
    exitCode=1
  elif [ -n "$post" ]; then
    echo "url: $post" | printf_readline $IX_IO_OUTPUT_COLOR_1
    printf '%s %s %s - url: %s\n' "$type" "sent on" "$(date +'%a %b %d, %Y at %H:%M')" "$post" >>"$IX_IO_SAVED_URL_FILE"
    __notifications "$APPNAME" "Post successful: \n$post"
    __cmd_exists clipboard && printf '%s\n' "$post" | SEND_NOTIFICATION="no" clipboard
    exitCode=0
  else
    printf_red "Something went wrong. No input received"
    exitCode=1
  fi
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
