#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  GEN_SCRIPT_REPLACE_VERSION
# @@Author           :  GEN_SCRIPT_REPLACE_AUTHOR
# @@Contact          :  GEN_SCRIPT_REPLACE_EMAIL
# @@License          :  GEN_SCRIPT_REPLACE_LICENSE
# @@ReadME           :  GEN_SCRIPT_REPLACE_FILENAME --help
# @@Copyright        :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @@Created          :  GEN_SCRIPT_REPLACE_DATE
# @@File             :  GEN_SCRIPT_REPLACE_FILENAME
# @@Description      :  GEN_SCRIPT_REPLACE_DESC
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  GEN_SCRIPT_REPLACE_TODO
# @@Other            :  GEN_SCRIPT_REPLACE_OTHER
# @@Resource         :  GEN_SCRIPT_REPLACE_RES
# @@Terminal App     :  GEN_SCRIPT_REPLACE_TERMINAL
# @@sudo/root        :  no
# @@Template         :  installers/mgr-script.system
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1003,SC2016,SC2031,SC2120,SC2155,SC2199,SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename -- "$0" 2>/dev/null)"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
USER="${SUDO_USER:-$USER}"
RUN_USER="${RUN_USER:-$USER}"
USER_HOME="${USER_HOME:-$HOME}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO="${GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO:-no}"
GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX="${APPNAME:-GEN_SCRIPT_REPLACE_FILENAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reopen in a terminal
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set script title
#CASJAYS_DEV_TILE_FORMAT="${USER}@${HOSTNAME}:${PWD//$HOME/\~} - $APPNAME"
#CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}"
#[ -z "$CASJAYSDEV_TITLE_SET" ] && printf '\033]2│;%s\033\\' "$CASJAYS_DEV_TILE_FORMAT" && CASJAYSDEV_TITLE_SET="$APPNAME"
export CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}" CASJAYSDEV_TITLE_SET
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Initial debugging
[ "$1" = "--debug" ] && set -x && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Disables colorization
[ "$1" = "--raw" ] && export SHOW_RAW="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# pipes fail
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-managers.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX/installer/raw/main/functions}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 90
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Options are: *_install
# system user desktopmgr devenvmgr dfmgr dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
GEN_SCRIPT_REPLACE_FILENAME_install && __options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Send all output to /dev/null
__devnull() {
  tee &>/dev/null && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
# Send errors to /dev/null
__devnull2() {
  [ -n "$1" ] && local cmd="$1" && shift 1 || return 1
  eval $cmd "$*" 2>/dev/null && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
# See if the executable exists
__cmd_exists() {
  GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  [ -n "$1" ] && local GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS="" || return 0
  for cmd in "$@"; do
    builtin command -v "$cmd" &>/dev/null && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS+=$(($GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS + 0)) || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS+=$(($GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS + 1))
  done
  [ $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS -eq 0 ] || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=3
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for a valid internet connection
__am_i_online() {
  local GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  curl -q -LSsfI --max-time 1 --retry 0 "${1:-https://1.1.1.1}" 2>&1 | grep -qi 'server:.*cloudflare' || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=4
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional printf_ colors
__printf_head() { printf_color "$1\n" "5"; }
__printf_opts() { printf_color "$1\n" "6"; }
__printf_line() { printf_color "$1\n" "4"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# list all packages
__list_available() {
  echo -e "${1:-$LIST}" | tr ',' ' ' | tr ' ' '\n' && exit 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# list options
__list_options() {
  printf_custom "5" "$1: $(echo ${2:-$ARRAY} | __sed 's|:||g;s|'$3'| '$4'|g' 2>/dev/null | tr '\n' ' ')"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create the config file
__gen_config() {
  local NOTIFY_CLIENT_NAME=""
  [ "$INIT_CONFIG" = "TRUE" ] || printf_green "Generating the config file in"
  [ "$INIT_CONFIG" = "TRUE" ] || printf_green "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
  [ -d "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR"
  [ -d "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR"
  [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] &&
    cp -Rf "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE.$$"
  cat <<EOF >"$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# Settings for GEN_SCRIPT_REPLACE_FILENAME
GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH="${GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH:-}"
GEN_SCRIPT_REPLACE_ENV_APP_DIR="${GEN_SCRIPT_REPLACE_ENV_APP_DIR:-}"
GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR="${GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR:-}"
GEN_SCRIPT_REPLACE_ENV_CLONE_DIR="${GEN_SCRIPT_REPLACE_ENV_CLONE_DIR:-}"
GEN_SCRIPT_REPLACE_ENV_REPO_URL="${GEN_SCRIPT_REPLACE_ENV_REPO_URL:-}"
GEN_SCRIPT_REPLACE_ENV_REPO_RAW="${GEN_SCRIPT_REPLACE_ENV_REPO_RAW:-}"
GEN_SCRIPT_REPLACE_ENV_REPO_API_URL="${GEN_SCRIPT_REPLACE_ENV_REPO_API_URL:-}"
GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE="${GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE:-}"
GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL="${GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL:-}"
GEN_SCRIPT_REPLACE_ENV_TEMPLATE_NAME="${GEN_SCRIPT_REPLACE_ENV_TEMPLATE_NAME:-installers/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX.sh}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_ENABLED:-}"
GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_COMMAND="${GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_COMMAND:-}"
# System
GEN_SCRIPT_REPLACE_ENV_SYSTEM_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_SYSTEM_NOTIFY_ENABLED:-}"
GEN_SCRIPT_REPLACE_ENV_GOOD_NAME="${GEN_SCRIPT_REPLACE_ENV_GOOD_NAME:-}"
GEN_SCRIPT_REPLACE_ENV_ERROR_NAME="${GEN_SCRIPT_REPLACE_ENV_ERROR_NAME:-}"
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME:-}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON:-}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY:-}"

EOF
  if builtin type -t __gen_config_local | grep -q 'function'; then __gen_config_local; fi
  if [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ]; then
    [ "$INIT_CONFIG" = "TRUE" ] || printf_green "Your config file for $APPNAME has been created"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  else
    printf_red "Failed to create the config file"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=11
  fi
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Help function - Align to 50
__help() {
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "GEN_SCRIPT_REPLACE_FILENAME: GEN_SCRIPT_REPLACE_DESC - $VERSION"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "Usage: $GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX [options] [packageName]"
  __printf_line "available                       - List all available packages"
  __printf_line "list                            - List installed packages"
  __printf_line "search    [package]             - Search for a package"
  __printf_line "install   [package]             - Install a package"
  __printf_line "update    [package]             - Update a package"
  __printf_line "download  [package]             - Downloads the source"
  __printf_line "remove    [package]             - Remove a package"
  __printf_line "cron      [package]             - Enables the use of cron to update packages on a schedule"
  __printf_line "version   [package]             - Shows the version of an installed package"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "Other Options"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "--debug                         - enable debugging"
  __printf_line "--config                        - Generate user config file"
  __printf_line "--version                       - Show script version"
  __printf_line "--help                          - Shows this message"
  __printf_line "--options                       - Shows all available options"
  __printf_line "--raw                           - Removes all formatting on output"
  __printf_line "--no                            - No options"
  __printf_line "--yes                           - Yes options"
  __printf_line ""
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__grep() { grep "$@" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__broken_symlinks() { find "$*" -xtype l -exec rm {} \; &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__rm_rf() { if [ -e "$1" ]; then rm -Rf "$@" &>/dev/null; else return 0; fi; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_container() {
  local docker_bin="$(type -P docker || type -P podman)"
  [ -n "$docker_bin" ] || printf_exit "This feature requires docker/podman"
  eval $docker_bin "$*"
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_install_version() {
  local upd file GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  if [ -d "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" ] && ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>&1 | grep -q '^'; then
    file="$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM/$1" 2>/dev/null)"
    export file
    if [ -f "$file" ]; then
      appname="$(__basename "$file")"
      eval "$file" "--version $appname"
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
    fi
  fi
  [ "$GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS" = 0 ] && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cron_updater() {
  local upd file GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  if [ -z "$1" ] && [ -d "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" ] && ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>&1 | grep -q '^'; then
    for upd in $(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM"); do
      file="$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM/$upd" 2>/dev/null)"
      export file
      if [ -f "$file" ]; then
        appname="$(__basename "$file")"
        eval "$file" "--cron $appname"
        GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS + $?))
      fi
    done
  else
    if [ -d "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" ] && ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>&1 | grep -q '^'; then
      file="$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM/$1" 2>/dev/null)"
      export file
      if [ -f "$file" ]; then
        appname="$(__basename "$file")"
        bash -c "$file --cron $appname"
        GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS + $?))
      fi
    fi
  fi
  [ "$GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS" = 0 ] && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__installer_delete() {
  local app="${1:-}"
  local GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  local APP_DIR_NAME="$GEN_SCRIPT_REPLACE_ENV_APP_DIR"
  local INSTALL_DIR_NAME="$GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR"
  local MESSAGE="${MESSAGE:-Removing $app from ${msg:-your system}}"
  [ -n "$app" ] || printf_exit "Please specify the name to delete"
  [ "$INSTALL_DIR_NAME/$app" == "$INSTALL_DIR_NAME/" ] && return
  if [ -d "$APP_DIR_NAME/$app" ] || [ -d "$INSTALL_DIR_NAME/$app" ]; then
    printf_yellow "$MESSAGE"
    if [ -e "$APP_DIR_NAME/$app" ]; then
      printf_blue "Deleting the files from $APP_DIR_NAME/$app"
      __rm_rf "$APP_DIR_NAME/$app"
    fi
    if [ -e "$INSTALL_DIR_NAME/$app" ]; then
      printf_blue "Deleting the files from $APP_DIR_NAME/$app"
      __rm_rf "$INSTALL_DIR_NAME/$app"
    fi
    if [ -e "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER/$app" ]; then
      printf_blue "Deleting the files from $APP_DIR_NAME/$app"
      __rm_rf "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER/$app"
    fi
    printf_yellow "Removing any broken symlinks"
    __broken_symlinks "$BIN" "$SHARE" "$COMPDIR" "$CONF" "$THEMEDIR" "$FONTDIR" "$ICONDIR"
    { [ -e "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER/$app" ] || [ -d "$INSTALL_DIR_NAME/$app" ] || [ -d "$APP_DIR_NAME/$app" ]; } && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
    [ $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS = 0 ] && printf_cyan "$app has been removed"
    return $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS
  else
    printf_error "$app doesn't seem to be installed"
  fi
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_install_init() {
  local app="$1"
  local GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  local INSTALL_DIR_NAME="$GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR"
  export SUDO_USER
  if __urlcheck "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh"; then
    export FORCE_INSTALL="$FORCE_INSTALL"
    bash -c "$(curl -q -LSsf "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh")" 2>/dev/null
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
  else
    printf_error "Failed to initialize the installer from:"
    printf_red "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh\n"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  fi
  [ "$GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS" = 0 ] && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_install_update() {
  local app APPNAME GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  local USER_SHARE_DIR="$SYSSHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX"
  local SYSTEM_SHARE_DIR="$SYSSHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX"
  local USRUPDATEDIR="$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM"
  local SYSUPDATEDIR="$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM"
  local NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME}"
  local NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON}"
  export NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON
  __run_install_init "$1" && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_download() {
  local REPO_NAME="$1"
  local DIR_NAME="${2:-$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR/$REPO_NAME}"
  local REPO_URL="$GEN_SCRIPT_REPLACE_ENV_REPO_URL"
  local REPO_CHECK="${REPO_URL//*:\/\/https:\/\//}"
  local ERROR_CODE="$(curl -q -LSsfI "$REPO_CHECK" && echo '')"
  local GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  if [ -n "$REPO_CHECK" ]; then
    printf_cyan "The requested URL returned error: $ERROR_CODE"
    printf_exit 3 3 "$REPO_URL/$REPO_NAME"
  fi
  if __cmd_exists gitadmin; then
    if [ -d "$DIR_NAME/.git" ]; then
      gitadmin pull "$DIR_NAME"
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
    else
      gitadmin clone "$REPO_URL/$REPO_NAME" "$DIR_NAME"
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
    fi
  else
    if [ -d "$DIR_NAME/.git" ]; then
      git -C "$DIR_NAME" pull
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
    else
      git clone "$REPO_URL/$REPO_NAME" "$DIR_NAME"
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
    fi
  fi
  if [ -d "$DIR_NAME/.git" ]; then
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  fi
  [ "$GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS" = 0 ] && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__api_list() {
  local GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  local api_call=""
  local prefix="$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX"
  local per_page="${GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE:-1000}"
  local api_url="${GEN_SCRIPT_REPLACE_ENV_REPO_API_URL:-https://api.github.com/orgs/$prefix/repos}"
  if __urlcheck "$api_url"; then
    api_call="$(curl -q -LSsf -H "Accept: application/vnd.github.v3+json" "$api_url?per_page=$per_page" 2>/dev/null | jq '.[].name' 2>/dev/null | sed 's#"##g' | grep -Ev '.github|template|^null$' | grep '^')"
    if [ -n "$api_call" ]; then
      printf '%s\n' "$api_call"
    else
      __list_available "$LIST"
    fi
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
  else
    __list_available "$LIST"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
  fi
  [ "$GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS" = 0 ] && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_search() {
  local -a results=""
  local LIST="${LIST:-$(__api_list)}"
  [ -n "$LIST" ] || printf_exit "The environment variable LIST does not exist"
  for app in "$@"; do
    result+="$(echo -e "$LIST" | tr ' ' '\n' | grep -Fi "$app" | grep -shv '^$') "
  done
  results="$(echo "$result" | sort -u | tr '\n' ' ' | sed 's| | |g' | grep '^')"
  if [ -n "$results" ]; then
    printf '%s\n' "$results" | printf_column "${PRINTF_COLOR:-4}"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  else
    printf_exit "Your search produced no results"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  fi
  [ "$GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS" = 0 ] && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check if arg is a builtin option
__is_an_option() { if echo "$ARRAY" | grep -q "${1:-^}"; then return 1; else return 0; fi; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user root
__user_is_root() {
  { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; } && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user not root
__user_is_not_root() {
  if { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; }; then return 1; else return 0; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if user is a member of sudo
__sudo_group() {
  grep -sh "${1:-$USER}" "/etc/group" | grep -Eq 'wheel|adm|sudo' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# # Get sudo password
__sudoask() {
  ask_for_password sudo true && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run sudo
__sudorun() {
  __sudoif && __cmd_exists sudo && sudo -HE "$@" || { __sudoif && eval "$@"; }
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Test if user has access to sudo
__can_i_sudo() {
  (sudo -vn && sudo -ln) 2>&1 | grep -vq 'may not' >/dev/null && return 0
  __sudo_group "${1:-$USER}" || __sudoif || __sudo true &>/dev/null || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User can run sudo
__sudoif() {
  __user_is_root && return 0
  __can_i_sudo "${RUN_USER:-$USER}" && return 0
  __user_is_not_root && __sudoask && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute sudo
__sudo() {
  CMD="${1:-echo}" && shift 1
  CMD_ARGS="${*:--e "${RUN_USER:-$USER}"}"
  SUDO="$(builtin command -v sudo 2>/dev/null || echo 'eval')"
  [ "$(basename -- "$SUDO" 2>/dev/null)" = "sudo" ] && OPTS="--preserve-env=PATH -HE"
  if __sudoif; then
    export PATH="$PATH"
    $SUDO ${OPTS:-} $CMD $CMD_ARGS && true || false
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
  else
    printf '%s\n' "This requires root to run"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  fi
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run command as root
__requiresudo() {
  if [ "$GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO" = "yes" ] && [ -z "$GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO_RUN" ]; then
    export GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO="no"
    export GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO_RUN="true"
    __sudo "$@"
    exit $?
  else
    return 0
  fi
}
# End of sudo functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__how_long_did_it_take() {
  local retprev=$?
  local retval=${1:-$retprev}
  __cmd_exists bc || return $retval
  [ -n "$GEN_SCRIPT_REPLACE_ENV_START_TIMER" ] || return 0
  local stop_time="$(date +%s.%N)"
  local dt=$(echo "$stop_time - $GEN_SCRIPT_REPLACE_ENV_START_TIMER" | bc)
  local dd=$(echo "$dt/86400" | bc)
  local dt2=$(echo "$dt-86400*$dd" | bc)
  local dh=$(echo "$dt2/3600" | bc)
  local dt3=$(echo "$dt2-3600*$dh" | bc)
  local dm=$(echo "$dt3/60" | bc)
  local ds=$(echo "$dt3-60*$dm" | bc)
  printf_purple "$(LC_NUMERIC=C printf "Total runtime: %d Days, %02d Hours, %02d Minutes, %02.4f Seconds\n" $dd $dh $dm $ds)"
  return $retval
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__trap_exit_GEN_SCRIPT_REPLACE_FILENAME() {
  GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  [ -f "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && rm -Rf "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" &>/dev/null
  #unset CASJAYSDEV_TITLE_SET && printf '\033]2│;%s\033\\' "${USER}@${HOSTNAME}:${PWD//$HOME/\~} - ${CASJAYSDEV_TITLE_PREV:-$SHELL}"
  if builtin type -t __trap_exit_local | grep -q 'function'; then __trap_exit_local; fi
  return $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create a --no-* options function
__options_function_no() {
  local options="${1//=*/}"
  local argument="${1//*=/}"
  case "$options" in
  *) echo "${argument:-No argument provided}" && shift ;;
  esac
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create a --yes-* options function
__options_function_yes() {
  local options="${1//=*/}"
  local argument="${1//*=/}"
  case "$options" in
  *) echo "${argument:-No argument provided}" && shift ;;
  esac
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
__notifications() {
  __cmd_exists notifications || return
  [ "$GEN_SCRIPT_REPLACE_ENV_SYSTEM_NOTIFY_ENABLED" = "yes" ] || return
  [ "$SEND_NOTIFICATION" = "no" ] && return
  (
    export SCRIPT_OPTS="" _DEBUG=""
    export NOTIFY_GOOD_MESSAGE="${NOTIFY_GOOD_MESSAGE:-$GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${NOTIFY_ERROR_MESSAGE:-$GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"
    export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_URGENCY="${NOTIFY_CLIENT_URGENCY:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY}"
    notifications "$@"
  ) |& __devnull &
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__notify_remote() {
  local cmd="$(echo "$GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_COMMAND" | awk -F ' ' '{print $1}')"
  if [ "$GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_ENABLED" = "yes" ]; then
    if [ -n "$(command -v "$cmd")" ]; then
      eval $GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_COMMAND "$@"
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap '__trap_exit_GEN_SCRIPT_REPLACE_FILENAME' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined variables/import external variables
GEN_SCRIPT_REPLACE_ENV_START_TIMER="${GEN_SCRIPT_REPLACE_ENV_START_TIMER:-$(date +%s.%N)}"
[ -f "$HOME/.local/dotfiles/personal/home/.config/myscripts/GEN_SCRIPT_REPLACE_FILENAME/settings.conf" ] && . "$HOME/.local/dotfiles/personal/home/.config/myscripts/GEN_SCRIPT_REPLACE_FILENAME/settings.conf"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default exit code
GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default variables
GEN_SCRIPT_REPLACE_ENV_USER_DIR="${GEN_SCRIPT_REPLACE_ENV_USER_DIR:-$USRUPDATEDIR}"
GEN_SCRIPT_REPLACE_ENV_SYSTEM_DIR="${GEN_SCRIPT_REPLACE_ENV_SYSTEM_DIR:-$SYSUPDATEDIR}"
GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR="${GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR:-$SHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
GEN_SCRIPT_REPLACE_ENV_LOG_DIR="${GEN_SCRIPT_REPLACE_ENV_LOG_DIR:-$HOME/.local/log/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CACHE_DIR="${GEN_SCRIPT_REPLACE_ENV_CACHE_DIR:-$HOME/.cache/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR:-$HOME/.config/myscripts/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX/backups}"
GEN_SCRIPT_REPLACE_ENV_RUN_DIR="${GEN_SCRIPT_REPLACE_ENV_RUN_DIR:-$HOME/.local/run/system_scripts/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_TEMP_DIR="${GEN_SCRIPT_REPLACE_ENV_TEMP_DIR:-$HOME/.local/tmp/system_scripts/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# File settings
GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE="${GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE:-settings.conf}"
GEN_SCRIPT_REPLACE_ENV_LOG_ERROR_FILE="${GEN_SCRIPT_REPLACE_ENV_LOG_ERROR_FILE:-$GEN_SCRIPT_REPLACE_ENV_LOG_DIR/error.log}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1:-33}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR:-6}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD:-2}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_ENABLED:-yes}"
GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_COMMAND="${GEN_SCRIPT_REPLACE_ENV_REMOTE_NOTIFY_COMMAND:-web-notify telegram}"
# System
GEN_SCRIPT_REPLACE_ENV_SYSTEM_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_SYSTEM_NOTIFY_ENABLED:-yes}"
GEN_SCRIPT_REPLACE_ENV_GOOD_NAME="${GEN_SCRIPT_REPLACE_ENV_GOOD_NAME:-Great:}"
GEN_SCRIPT_REPLACE_ENV_ERROR_NAME="${GEN_SCRIPT_REPLACE_ENV_ERROR_NAME:-Error:}"
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-No errors reported}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-Errors were reported}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME:-$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON:-notification-new}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY:-normal}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional Variables
GEN_SCRIPT_REPLACE_ENV_DIR_USER="${GEN_SCRIPT_REPLACE_ENV_DIR_USER:-$USRUPDATEDIR}"
GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM="${GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM:-$SYSUPDATEDIR}"
GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL="${GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL:-false}"
GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH="${GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH:-main}"
GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE="${GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE:-1000}"
GEN_SCRIPT_REPLACE_ENV_REPO_RAW="${GEN_SCRIPT_REPLACE_ENV_REPO_RAW:-raw/$GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH}"
GEN_SCRIPT_REPLACE_ENV_APP_DIR="${GEN_SCRIPT_REPLACE_ENV_APP_DIR:-$SHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR="${GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR:-$SHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CLONE_DIR="${GEN_SCRIPT_REPLACE_ENV_CLONE_DIR:-$HOME/Projects/github/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_TEMPLATE_NAME="${GEN_SCRIPT_REPLACE_ENV_TEMPLATE_NAME:-installers/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX.sh}"
GEN_SCRIPT_REPLACE_ENV_REPO_URL="${GEN_SCRIPT_REPLACE_ENV_REPO_URL:-https://github.com/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_REPO_API_URL="${GEN_SCRIPT_REPLACE_ENV_REPO_API_URL:-https://api.github.com/orgs/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX/repos}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Export variables
export SCRIPTS_PREFIX="$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate non-existing config files
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] || [ "$*" = "--config" ] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] && . "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories and files exist
[ -d "$GEN_SCRIPT_REPLACE_ENV_RUN_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_RUN_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_LOG_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_LOG_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR"
GEN_SCRIPT_REPLACE_ENV_TEMP_FILE="${GEN_SCRIPT_REPLACE_ENV_TEMP_FILE:-$(mktemp $GEN_SCRIPT_REPLACE_ENV_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom actions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables/Argument/Option settings
SETARGS=("$@")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SHORTOPTS="a,f"
SHORTOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
GET_OPTIONS_NO="no-*"
GET_OPTIONS_YES="yes-*"
LONGOPTS="all,completions:,config,reset-config,debug,force,help,options,raw,version,"
LONGOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ARRAY="available,cron,download,install,list,remove,search,update,version"
ARRAY+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LIST=""
LIST+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
    SHOW_LIST="$(__api_list || echo '' &)"
    [ -n "$1" ] || printf_blue "Current options for ${PROG:-$APPNAME}"
    [ -z "$SHORTOPTS" ] || __list_options "Short Options" "-${SHORTOPTS}" ',' '-'
    [ -z "$LONGOPTS" ] || __list_options "Long Options" "--${LONGOPTS}" ',' '--'
    [ -z "$ARRAY" ] || __list_options "Base Options" "${ARRAY}" ',' ''
    [ -n "$SHOW_LIST" ] && printf '\n' && printf_yellow "Below are the available packages:" &&
      printf '%s\n' "$SHOW_LIST" | printf_column $GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR
    printf '\n'
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
  --reset-config)
    shift 1
    [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] && rm -Rf "${GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR:?}/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
    __gen_config
    exit $?
    ;;
  -f | --force)
    shift 1
    export FORCE_INSTALL="true"
    GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL="true"
    ;;
  -a | --all)
    shift 1
    INSTALL_ALL="true"
    ;;
  --no-*)
    __options_function_no "$@"
    shift 1
    ;;
  --yes-*)
    __options_function_yes "$@"
    shift 1
    ;;
  --)
    shift 1
    break
    ;;
  esac
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Get directory from args
# set -- "$@"
# for arg in "$@"; do
# if [ -d "$arg" ]; then
# GEN_SCRIPT_REPLACE_ENV_CWD="$arg" && shift 1
# elif [ -f "$arg" ]; then
# GEN_SCRIPT_REPLACE_ENV_CWD="$(dirname "$arg" 2>/dev/null)" && shift 1
# else
# SET_NEW_ARGS+=("$arg")
# fi
# done
# set -- "${SET_NEW_ARGS[@]}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set directory to first argument
# [ -d "$1" ] && __is_an_option "$1" && GEN_SCRIPT_REPLACE_ENV_CWD="$1" && shift 1 || GEN_SCRIPT_REPLACE_ENV_CWD="${GEN_SCRIPT_REPLACE_ENV_CWD:-$PWD}"
GEN_SCRIPT_REPLACE_ENV_CWD="$(realpath "${GEN_SCRIPT_REPLACE_ENV_CWD:-$PWD}" 2>/dev/null)"
# if [ -d "$GEN_SCRIPT_REPLACE_ENV_CWD" ] && cd "$GEN_SCRIPT_REPLACE_ENV_CWD"; then
# if [ "$GEN_SCRIPT_REPLACE_ENV_SILENT" != "true" ] && [ "$CWD_SILENCE" != "true" ]; then
# printf_cyan "Setting working dir to $GEN_SCRIPT_REPLACE_ENV_CWD"
# fi
# else
# printf_exit "💔 $GEN_SCRIPT_REPLACE_ENV_CWD does not exist 💔"
# fi
export GEN_SCRIPT_REPLACE_ENV_CWD
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set actions based on variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
# __sudoif && __requiresudo "$0" "${SETARGS[@]}" || exit 2 # exit 2 if errors
# __cmd_exists bash || exit 3                              # exit with error code 3 if not found
# __am_i_online "1.1.1.1" || exit 4                        # exit with error code 4 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
declare -a LISTARRAY=()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Export variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute commands

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
case "$1" in
list)
  shift 1
  printf_green "All installed $GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX packages"
  LISTARRAY=("$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>/dev/null)")
  if [ -n "${LISTARRAY[*]}" ]; then
    printf '%s\n' "${LISTARRAY[@]}" | printf_column '5'
  else
    printf_red "There doesn't seem to be any packages installed"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  fi
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

available)
  shift 1
  api_info="$(__api_list)"
  pkg_count="$(echo "$api_info" | tr ' ' '\n' | wc -l)"
  if [ -n "$api_info" ]; then
    printf_purple "$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX currently has $pkg_count packages available"
    printf '%s\n' "$api_info" | printf_column '6'
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  else
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  fi
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

search)
  shift 1
  [ $# = 0 ] && printf_exit "Nothing to search for"
  __run_search "$@"
  GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

remove)
  shift 1
  if [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY=("$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>/dev/null)")
  else
    LISTARRAY=("$@")
  fi
  [ ${#LISTARRAY} -ne 0 ] || printf_exit "No packages selected for removal"
  for rmf in "${LISTARRAY[@]}"; do
    MESSAGE="Removing $rmf from $GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR/$rmf"
    __installer_delete "$rmf"
    retVal=$?
    [ $retVal = 0 ] && __notifications "Deletion of $APPNAME was successfull" || __notifications "Deletetion of $APPNAME has failed"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($retVal + $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS))
    printf '\n'
  done
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

install)
  shift 1
  if [ "$INSTALL_ALL" = "true" ] || [ $# -eq 0 ]; then
    printf_blue "No packages provide running the updater"
    exit
  else
    LISTARRAY=("$@")
  fi
  for ins in "${LISTARRAY[@]}"; do
    if [ -e "$GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR/$ins" ] || [ -e "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM/$ins" ] || [ -e "$GEN_SCRIPT_REPLACE_ENV_DIR_USER/$ins" ] || [ -e "$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$ins" ]; then
      __notifications "$ins is already installed"
      continue
    else
      APPNAME="$ins"
      __run_install_update "$APPNAME"
      retVal=$?
      [ $retVal = 0 ] && __notifications "Successfully installed $APPNAME" || __notifications "Installation of $APPNAME has failed"
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($retVal + $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS))
    fi
  done
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

update)
  shift 1
  if [ $# -eq 0 ] || [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY=("$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>/dev/null)")
  else
    LISTARRAY=("$@")
  fi
  if [ $# -ne 0 ]; then
    for ins in "${LISTARRAY[@]}"; do
      APPNAME="$ins"
      __run_install_update "$APPNAME"
      retVal=$?
      [ $retVal = 0 ] && __notifications "Successfully updated $APPNAME" || __notifications "Update of $APPNAME has failed"
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($retVal + $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS))
    done
  elif [ -d "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" ] && [ ${#LISTARRAY} -ne 0 ]; then
    for upd in $(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>/dev/null); do
      APPNAME="$upd"
      __run_install_update "$APPNAME"
      retVal=$?
      [ $retVal = 0 ] && __notifications "Successfully updated $APPNAME" || __notifications "Update of $APPNAME has failed"
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($retVal + $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS))
    done
  else
    printf_yellow "There doesn't seem to be any packages installed"
    __notifications "There doesn't seem to be any packages installed"
  fi
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

download | clone)
  shift 1
  if [ $# = 0 ] || [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY=("$(__api_list)")
  else
    LISTARRAY=("$@")
  fi
  if [ -n "${LISTARRAY[*]}" ]; then
    for pkgs in "${LISTARRAY[@]}"; do
      __run_download "$pkgs"
      retVal=$?
      [ $retVal = 0 ] && __notifications "Downloaded $APPNAME" || __notifications "Download of $APPNAME has failed"
      GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($retVal + $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS))
    done
  else
    printf_exit "No packages selected for download"
  fi
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

cron)
  shift 1
  [ "$*" = "help" ] && printf_exit 2 0 "Usage: $APPNAME cron $APPNAME"
  LISTARRAY=("$@")
  for cron in "${LISTARRAY[@]}"; do
    APPNAME="$cron"
    __cron_updater "$APPNAME"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($? + $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS))
  done
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

version)
  shift 1
  LISTARRAY=("$@")
  for ver in "${LISTARRAY[@]}"; do
    APPNAME="$ver"
    __run_install_version "$ver"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$(($? + $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS))
  done
  exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
  ;;

*)
  printf_cyan '#### Script info \n'
  printf_blue "Script Name:    $APPNAME - $VERSION"
  printf_green "User Name:      $RUN_USER"
  printf_red "User ID:        $UID"
  printf_yellow "Config Dir:     $GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR"
  printf_purple "Git Source Dir: $GEN_SCRIPT_REPLACE_ENV_CLONE_DIR"
  printf_purple "Git Source URL: $GEN_SCRIPT_REPLACE_ENV_REPO_URL"
  printf_cyan '#### Help \n'
  __help
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set exit code
GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS="${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-0}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
