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
# @@sudo/root        :  yes
# @@Template         :  installers/mgr-script.system
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO="${GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO:-yes}"
GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX="${APPNAME:-GEN_SCRIPT_REPLACE_FILENAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reopen in a terminal
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Initial debugging
[ "$1" = "--debug" ] && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
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
# desktopmgr devenvmgr dfmgr dockermgr fontmgr iconmgr
# pkmgr system systemmgr thememgr user wallpapermgr
GEN_SCRIPT_REPLACE_FILENAME_install && __options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Send all output to /dev/null
__devnull() {
  tee &>/dev/null && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
# Send errors to /dev/null
__devnull2() {
  [ -n "$1" ] && local cmd="$1" && shift 1 || return 1
  eval $cmd "$*" 2>/dev/null && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
# See if the executable exists
__cmd_exists() {
  exitCode=0
  [ -n "$1" ] && local exitCode="" || return 0
  for cmd in "$@"; do
    builtin command -v "$cmd" &>/dev/null && exitCode+=$(($exitCode + 0)) || exitCode+=$(($exitCode + 1))
  done
  [ $exitCode -eq 0 ] || exitCode=3
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for a valid internet connection
__am_i_online() {
  local exitCode=0
  curl -q -LSsfI --max-time 1 --retry 0 "${1:-http://1.1.1.1}" 2>&1 | grep -qi 'server:.*cloudflare' || exitCode=4
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# colorization
if [ "$SHOW_RAW" = "true" ]; then
  printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[ 0-9;]*[a-zA-Z],,g'; }
else
  printf_color() { printf "%b" "$(tput setaf "${2:-7}" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__printf_head() { printf_color "\t\t$1\n" "5"; }
__printf_opts() { printf_color "\t\t$1\n" "6"; }
__printf_line() { printf_color "\t\t$1\n" "4"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__list_available() {
  echo -e "${1:-$LIST}" | tr ',' ' ' | tr ' ' '\n' && exit 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__list_options() {
  printf_custom "5" "$1: $(echo ${2:-$ARRAY} | __sed 's|:||g;s|'$3'| '$4'|g' 2>/dev/null)"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED:-}"
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
    exitCode=0
  else
    printf_red "Failed to create the config file"
    exitCode=11
  fi
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Help function - Align to 55
__help() {
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX: GEN_SCRIPT_REPLACE_DESC"
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
  __printf_line "                                       "
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "Other Options"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "--debug                         - enable debugging"
  __printf_line "--config                        - Generate user config file"
  __printf_line "--version                       - Show script version"
  __printf_line "--help                          - Shows this message"
  __printf_line "--options                       - Shows all available options"
  __printf_line ""
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__broken_symlinks() { find "$*" -xtype l -exec rm {} \; &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__rm_rf() { if [ -e "$1" ]; then rm -Rf "$@" &>/dev/null; else return 0; fi; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_install_version() {
  local upd file exitCode=0
  if [ -d "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" ] && ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>&1 | grep -q '^'; then
    export file="$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM/$1" 2>/dev/null)"
    if [ -f "$file" ]; then
      appname="$(__basename "$file")"
      eval "$file" "--version $appname"
      exitCode=$?
    fi
  fi
  [ "$exitCode" = 0 ] && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cron_updater() {
  local upd file exitCode=0
  if [ -z "$1" ] && [ -d "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" ] && ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>&1 | grep -q '^'; then
    for upd in $(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM"); do
      export file="$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM/$upd" 2>/dev/null)"
      if [ -f "$file" ]; then
        appname="$(__basename "$file")"
        eval "$file" "--cron $appname"
        exitCode=$?
      fi
    done
  else
    if [ -d "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" ] && ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>&1 | grep -q '^'; then
      export file="$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM/$1" 2>/dev/null)"
      if [ -f "$file" ]; then
        appname="$(__basename "$file")"
        bash -c "$file --cron $appname"
        exitCode=$?
      fi
    fi
  fi
  [ "$exitCode" = 0 ] && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__installer_delete() {
  local app="${1:-}"
  local exitCode=0
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
    { [ -e "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER/$app" ] || [ -d "$INSTALL_DIR_NAME/$app" ] || [ -d "$APP_DIR_NAME/$app" ]; } && exitCode=1 || exitCode=0
    [ $exitCode = 0 ] && printf_cyan "$app has been removed"
    return $exitCode
  else
    printf_error "$app doesn't seem to be installed"
  fi
  return ${exitCode}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_install_init() {
  local app="$1"
  local exitCode=0
  local INSTALL_DIR_NAME="$GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR"
  export SUDO_USER
  if __urlcheck "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh"; then
    export FORCE_INSTALL="$FORCE_INSTALL"
    bash -c "$(curl -q -LSsf "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh")" 2>/dev/null
    exitCode=$?
  else
    printf_error "Failed to initialize the installer from:"
    printf_red "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh\n"
    exitCode=1
  fi
  [ "$exitCode" = 0 ] && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_install_update() {
  local app APPNAME exitCode=0
  local USER_SHARE_DIR="$SYSSHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX"
  local SYSTEM_SHARE_DIR="$SYSSHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX"
  local USRUPDATEDIR="$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM"
  local SYSUPDATEDIR="$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM"
  local NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME}"
  local NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON}"
  export NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON
  __run_install_init "$1" && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__download() {
  local REPO_NAME="$1"
  local DIR_NAME="${2:-$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR/$REPO_NAME}"
  local REPO_URL="$GEN_SCRIPT_REPLACE_ENV_REPO_URL"
  local exitCode=0
  if cmd_exists gitadmin; then
    if [ -d "$DIR_NAME/.git" ]; then
      gitadmin pull "$DIR_NAME"
      exitCode=$?
    else
      gitadmin clone "$REPO_URL/$REPO_NAME" "$DIR_NAME"
      exitCode=$?
    fi
  else
    if [ -d "$DIR_NAME/.git" ]; then
      git -C "$DIR_NAME" pull
      exitCode=$?
    else
      git clone "$REPO_URL/$REPO_NAME" "$DIR_NAME"
      exitCode=$?
    fi
  fi
  if [ -d "$DIR_NAME/.git" ]; then
    if [ -n "${SUDO_USER:-$RUN_USER}" ]; then
      sudo chown -Rf ${SUDO_USER:-$RUN_USER}:${SUDO_USER:-$RUN_USER} "$DIR_NAME"
    fi
    exitCode=0
  fi
  [ "$exitCode" = 0 ] && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__api_list() {
  local exitCode=0
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
    exitCode=$?
  else
    __list_available "$LIST"
    exitCode=$?
  fi
  [ "$exitCode" = 0 ] && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_search() {
  local -a results=""
  local LIST="${LIST:-$(__api_list)}"
  [ -n "$LIST" ] || printf_exit "The environment variable LIST does not exist"
  for app in "$@"; do
    result+="$(echo -e "$LIST" | tr ' ' '\n' | grep -Fi "$app" | grep -sv '^$') "
  done
  results="$(echo "$result" | sort -u | tr '\n' ' ' | sed 's| | |g' | grep '^')"
  if [ -n "$results" ]; then
    printf '%s\n' "$results" | printf_column "${PRINTF_COLOR:-4}"
    exitCode=0
  else
    printf_exit "Your search produced no results"
    exitCode=1
  fi
  [ "$exitCode" = 0 ] && exitCode=0 || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user root
__user_is_root() { { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; } && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user not root
__user_is_not_root() { { [ $(id -u) -ne 0 ] || [ $EUID -ne 0 ] || [ "$WHOAMI" != "root" ]; } && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# # Get sudo password
__sudoask() { ask_for_password sudo true && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run sudo
__sudorun() {
  __sudoif && __cmd_exists sudo && sudo -HE "$@" || { __sudoif && eval "$@"; }
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if user is a member of sudo
__sudo_group() { grep "${1:-$USER}" "/etc/group" | grep -Eq 'wheel|adm|sudo' || return 1; }
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
  [ "$(basename "$SUDO" 2>/dev/null)" = "sudo" ] && OPTS="-n --preserve-env=PATH -HE"
  if __sudoif; then
    export PATH="$PATH"
    $SUDO ${OPTS:-} bash -c ''$CMD' '$CMD_ARGS' && true || false'
    return $?
  else
    printf '%s\n' "This requires root to run"
    return $?
  fi
  return ${?:-1}
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
__trap_exit() {
  exitCode=${exitCode:-$?}
  [ -f "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && rm -Rf "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" &>/dev/null
  if builtin type -t __trap_exit_local | grep -q 'function'; then __trap_exit_local; fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined variables/import external variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default variables
GEN_SCRIPT_REPLACE_ENV_USER_DIR="${GEN_SCRIPT_REPLACE_ENV_USER_DIR:-$USRUPDATEDIR}"
GEN_SCRIPT_REPLACE_ENV_SYSTEM_DIR="${GEN_SCRIPT_REPLACE_ENV_SYSTEM_DIR:-$SYSUPDATEDIR}"
GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR="${GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR:-$SHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
# Application Folders
GEN_SCRIPT_REPLACE_ENV_LOG_DIR="${GEN_SCRIPT_REPLACE_ENV_LOG_DIR:-$HOME/.local/log/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CACHE_DIR="${GEN_SCRIPT_REPLACE_ENV_CACHE_DIR:-$HOME/.cache/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR:-$HOME/.config/myscripts/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX/backups}"
GEN_SCRIPT_REPLACE_ENV_TEMP_DIR="${GEN_SCRIPT_REPLACE_ENV_TEMP_DIR:-$HOME/.local/tmp/system_scripts/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE="${GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE:-settings.conf}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1:-4}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR:-6}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD:-2}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED:-yes}"
GEN_SCRIPT_REPLACE_ENV_GOOD_NAME="${GEN_SCRIPT_REPLACE_ENV_GOOD_NAME:-Great:}"
GEN_SCRIPT_REPLACE_ENV_ERROR_NAME="${GEN_SCRIPT_REPLACE_ENV_ERROR_NAME:-Error:}"
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-No errors reported}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-Errors were reported}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME:-$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON:-notification-new}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY:-normal}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional Variables
GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH="${GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH:-main}"
GEN_SCRIPT_REPLACE_ENV_APP_DIR="${GEN_SCRIPT_REPLACE_ENV_APP_DIR:-$SHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR="${GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR:-$SHARE/CasjaysDev/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_CLONE_DIR="${GEN_SCRIPT_REPLACE_ENV_CLONE_DIR:-$HOME/Projects/github/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_REPO_URL="${GEN_SCRIPT_REPLACE_ENV_REPO_URL:-https://github.com/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_REPO_RAW="${GEN_SCRIPT_REPLACE_ENV_REPO_RAW:-raw/$GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH}"
GEN_SCRIPT_REPLACE_ENV_REPO_API_URL="${GEN_SCRIPT_REPLACE_ENV_REPO_API_URL:-https://api.github.com/orgs/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX/repos}"
GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE="${GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE:-1000}"
GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL="${GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL:-false}"
GEN_SCRIPT_REPLACE_ENV_DIR_USER="${GEN_SCRIPT_REPLACE_ENV_DIR_USER:-$USRUPDATEDIR}"
GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM="${GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM:-$SYSUPDATEDIR}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate non-existing config files
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] ||
  [ "$*" = "--config" ] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] &&
  . "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories and files exist
[ -d "$GEN_SCRIPT_REPLACE_ENV_LOG_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_LOG_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR"
GEN_SCRIPT_REPLACE_ENV_TEMP_FILE="${GEN_SCRIPT_REPLACE_ENV_TEMP_FILE:-$(mktemp $GEN_SCRIPT_REPLACE_ENV_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap '__trap_exit' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
__notifications() {
  __cmd_exist notifications || return
  [ "$GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED" = "yes" ] || return
  (
    export NOTIFY_GOOD_MESSAGE="${NOTIFY_GOOD_MESSAGE:-$GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${NOTIFY_ERROR_MESSAGE:-$GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"
    export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_URGENCY="${NOTIFY_CLIENT_URGENCY:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY}"
    notifications "$@"
    retval=$?
    unset NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON NOTIFY_GOOD_MESSAGE NOTIFY_ERROR_MESSAGE NOTIFY_CLIENT_URGENCY
    return $retval
  ) |& __devnull &
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom actions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables/Argument/Option settings
SETARGS=("$@")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SHORTOPTS="a,f"
SHORTOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LONGOPTS="completions:,options,config,version,help,force,all,raw"
LONGOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ARRAY="download,list,search,available,remove,version,update,install,cron"
ARRAY+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LIST=""
LIST+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -a -n "$APPNAME" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  --raw)
    shift 1
    export SHOW_RAW="true"
    printf_column() { tee | grep '^'; }
    printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[ 0-9;]*[a-zA-Z],,g'; }
    ;;
  --debug)
    shift 1
    set -xo pipefail
    export SCRIPT_OPTS="--debug"
    export _DEBUG="on"
    __devnull() { tee || return 1; }
    __devnull2() { eval "$@" |& tee || return 1; }
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
  -f | --force)
    shift 1
    export FORCE_INSTALL="true"
    ;;
  -a | --all)
    shift 1
    INSTALL_ALL="true"
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
# [ -d "$1" ] && GEN_SCRIPT_REPLACE_ENV_CWD="$1" && shift 1 || GEN_SCRIPT_REPLACE_ENV_CWD="${GEN_SCRIPT_REPLACE_ENV_CWD:-$PWD}"
# GEN_SCRIPT_REPLACE_ENV_CWD="$(readlink -f "$GEN_SCRIPT_REPLACE_ENV_CWD" 2>/dev/null)"
# if [ -d "$GEN_SCRIPT_REPLACE_ENV_CWD" ] && cd "$GEN_SCRIPT_REPLACE_ENV_CWD"; then
# printf_cyan "Setting working dir to $GEN_SCRIPT_REPLACE_ENV_CWD"
# else
# printf_exit "💔 $GEN_SCRIPT_REPLACE_ENV_CWD does not exist 💔"
# fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set actions based on variables
export GEN_SCRIPT_REPLACE_ENV_CWD="${GEN_SCRIPT_REPLACE_ENV_CWD:-$PWD}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Redefine functions based on options

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
__requiresudo "$0" "$@" || exit 2 # exit 2 if errors
__cmd_exists bash || exit 3       # exit with error code 3 if not found
__am_i_online "1.1.1.1" || exit 4 # exit with error code 4 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
declare -a LISTARRAY=()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
case "$1" in
list)
  shift 1
  printf_green "All installed $GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX packages"
  LISTARRAY=("$(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>/dev/null)")
  [ -n "${LISTARRAY[*]}" ] && printf '%s\n' "${LISTARRAY[@]}" | printf_column '5' ||
    printf_exit "There doesn't seem to be any packages installed"
  exit ${exitCode:-$?}
  ;;

available)
  shift 1
  api_info="$(__api_list)"
  pkg_count="$(echo "$api_info" | tr ' ' '\n' | wc -l)"
  if [ -n "$api_info" ]; then
    printf_purple "$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX currently has $pkg_count packages available"
    printf '%s\n' "$api_info" | printf_column '6'
    true
  else
    false
  fi
  exit ${exitCode:-$?}
  ;;

search)
  shift 1
  [ $# = 0 ] && printf_exit "Nothing to search for"
  __run_search "$@"
  exit ${exitCode:-$?}
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
    [ $? = 0 ] && __notifications "Deletion of $APPNAME was successfull" || __notifications "Deletetion of $APPNAME has failed"
    printf '\n'
  done
  exit ${exitCode:-$?}
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
    if [ -e "$GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR/$ins" ] || [ -e "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM/$ins" ] || [ -e "$GEN_SCRIPT_REPLACE_ENV_DIR_USER/$ins" ] || [ -e "$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$app" ]; then
      __notifications "$ins is already installed"
      continue
    else
      APPNAME="$ins"
      __run_install_update "$APPNAME"
      [ $? = 0 ] && __notifications "Successfully installed $APPNAME" || __notifications "Installation of $APPNAME has failed"
    fi
  done
  exit ${exitCode:-$?}
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
      [ $? = 0 ] && __notifications "Successfully updated $APPNAME" || __notifications "Update of $APPNAME has failed"
    done
  elif [ -d "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" ] && [ ${#LISTARRAY} -ne 0 ]; then
    for upd in $(ls -A "$GEN_SCRIPT_REPLACE_ENV_DIR_SYSTEM" 2>/dev/null); do
      APPNAME="$upd"
      __run_install_update "$APPNAME"
      [ $? = 0 ] && __notifications "Successfully updated $APPNAME" || __notifications "Update of $APPNAME has failed"
    done
  else
    printf_yellow "There doesn't seem to be any packages installed"
    __notifications "There doesn't seem to be any packages installed"
  fi
  exit ${exitCode:-$?}
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
      __download "$pkgs"
      [ $? = 0 ] && __notifications "Downloaded $APPNAME" || __notifications "Download of $APPNAME has failed"
    done
  else
    printf_exit "No packages selected for download"
  fi
  exit ${exitCode:-$?}
  ;;

cron)
  shift 1
  [ "$*" = "help" ] && printf_exit 2 0 "Usage: $APPNAME cron $APPNAME"
  LISTARRAY=("$@")
  for cron in "${LISTARRAY[@]}"; do
    APPNAME="$cron"
    __cron_updater "$APPNAME"
  done
  exit ${exitCode:-$?}
  ;;

version)
  shift 1
  LISTARRAY=("$@")
  for ver in "${LISTARRAY[@]}"; do
    APPNAME="$ver"
    __run_install_version "$ver"
  done
  exit ${exitCode:-$?}
  ;;

*)
  printf_red "User ID: $UID"
  printf_green "User Name: $RUN_USER"
  printf_blue "Script Name: $APPNAME"
  printf_cyan "Version: $VERSION"
  printf_yellow "Config Dir: $GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR"
  printf_purple "Current Working directory: $GEN_SCRIPT_REPLACE_ENV_CWD"
  __help
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set exit code
exitCode="${exitCode:-$?}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
