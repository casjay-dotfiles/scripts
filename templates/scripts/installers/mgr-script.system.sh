#!/usr/bin/env bash
#- - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  GEN_SCRIPT_REPLACE_VERSION
# @Author            :  GEN_SCRIPT_REPLACE_AUTHOR
# @Contact           :  GEN_SCRIPT_REPLACE_EMAIL
# @License           :  GEN_SCRIPT_REPLACE_LICENSE
# @ReadME            :  GEN_SCRIPT_REPLACE_FILENAME --help
# @Copyright         :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @Created           :  GEN_SCRIPT_REPLACE_DATE
# @File              :  GEN_SCRIPT_REPLACE_FILENAME
# @Description       :  GEN_SCRIPT_REPLACE_DESC
# @TODO              :  GEN_SCRIPT_REPLACE_TODO
# @Other             :  GEN_SCRIPT_REPLACE_OTHER
# @Resource          :  GEN_SCRIPT_REPLACE_RES
# @sudo/root         :  yes
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [[ "$1" == "--debug" ]]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-managers.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/GEN_SCRIPT_REPLACE_ENV_/installer/raw/main/functions}"
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
# user system devenvmgr dfmgr dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
GEN_SCRIPT_REPLACE_FILENAME_install && __options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__help() {
  # Help function - Align to 50
  printf_head() { printf_purple "$*"; }
  printf_opts() { printf_blue "$*"; }
  printf_line() { printf_blue "$*"; }
  #
  printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  printf_opts "GEN_SCRIPT_REPLACE_FILENAME: GEN_SCRIPT_REPLACE_DESC"
  printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  printf_line "Usage: GEN_SCRIPT_REPLACE_FILENAME [options] [commands]"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME available                             - list all available packages"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME list                                  - list installed packages"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME search    [package]                   - search for a package"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME version   [package]                   - show the version info"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME install   [package]                   - install a package"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME remove    [package]                   - remove a package"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME update    [package]                   - update a package"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME download  [package]                   - downloads the source"
  printf_line ""
  printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  printf_opts "Other Options"
  printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME --debug                               - enable debugging"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME --config                              - Generate user config file"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME --version                             - Show script version"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME --help                                - Shows this message"
  printf_line "GEN_SCRIPT_REPLACE_FILENAME --options                             - Shows all available options"
  printf_line ""
  printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__list_available() {
  [[ -n "$LIST" ]] || LIST="$(__api_list)"
  echo -e "${1:-$LIST}" | tr ',' ' ' | tr ' ' '\n' && exit 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__list_options() { printf_custom "$1" "$2: $(echo ${3:-$ARRAY} | __sed 's|:||g;s|'$4'| '$5'|g')" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__gen_config() {
  [[ -z "$NOTIFY_CLIENT_NAME" ]] || NOTIFY_CLIENT_NAME=""
  [[ "$INIT_CONFIG" = "TRUE" ]] || printf_green "Generating the config file in"
  [[ "$INIT_CONFIG" = "TRUE" ]] || printf_green "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
  [ -d "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR"
  [ -d "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR"
  [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] &&
    cp -Rf "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE.$$"
  cat <<EOF >"$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# Settings for GEN_SCRIPT_REPLACE_FILENAME
GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH="${GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH:-main}"
GEN_SCRIPT_REPLACE_ENV_APP_DIR="${GEN_SCRIPT_REPLACE_ENV_APP_DIR:-$SHARE/CasjaysDev/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR="${GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR:-$SHARE/CasjaysDev/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_CLONE_DIR="${GEN_SCRIPT_REPLACE_ENV_CLONE_DIR:-$HOME/Projects/github/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_REPO_URL="${GEN_SCRIPT_REPLACE_ENV_REPO_URL:-https://github.com/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_REPO_RAW="${GEN_SCRIPT_REPLACE_ENV_REPO_RAW:-raw/$GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH}"
GEN_SCRIPT_REPLACE_ENV_REPO_API="${GEN_SCRIPT_REPLACE_ENV_REPO_API:-https://api.github.com/orgs/GEN_SCRIPT_REPLACE_FILENAME/repos}"
GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE="${GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE:-1000}"
GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL="${GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL:-false}"

# Notification settings
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-Everything Went OK}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-Well that did not work}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED:-yes}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"

# Colorization settings
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR:-5}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD:-2}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR:-1}"

EOF
  if [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ]; then
    [[ "$INIT_CONFIG" = "TRUE" ]] || printf_green "Your config file for $APPNAME has been created"
    exitCode=0
  else
    printf_red "Failed to create the config file"
    exitCode=1
  fi
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional functions
__rm_rf() { if [ -e "$1" ]; then __require_sudo rm -Rf "$@" &>/dev/null; else return 0; fi; }
__broken_symlinks() { __require_sudo find "$*" -xtype l -exec rm {} \; &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__require_sudo() {
  if [[ "$REQUIRE_SUDO" = "TRUE" ]] || [[ "$USER" != "root" ]] || [[ "$UID" != "0" ]] || [[ -z "$SUDO_USER" ]]; then
    sudo -HE "$APPNAME $SETARGS"
    return $?
  else
    eval "$*"
    return $?
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cron_updater() {
  local upd file
  local USRUPDATEDIR="$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER"
  local SYSUPDATEDIR="$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_SYSTEM"
  [ "$*" = "help" ] && shift 1 && printf_help "Usage: ${PROG:-$APPNAME} updater $APPNAME"
  if user_is_root; then
    if [ -z "$1" ] && [ -d "$SYSUPDATEDIR" ] && ls "$SYSUPDATEDIR"/* 1>/dev/null 2>&1; then
      for upd in $(ls $SYSUPDATEDIR/); do
        file="$(ls -A $SYSUPDATEDIR/$upd 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename $file)"
          __require_sudo file="$file" bash "$file --cron $*"
        fi
      done
    else
      if [ -d "$SYSUPDATEDIR" ] && ls "$SYSUPDATEDIR"/* 1>/dev/null 2>&1; then
        file="$(ls -A $SYSUPDATEDIR/$1 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename $file)"
          __require_sudo file="$file" bash "$file --cron $*"
        fi
      fi
    fi
  else
    if [ -z "$1" ] && [ -d "$USRUPDATEDIR" ] && ls "$USRUPDATEDIR"/* 1>/dev/null 2>&1; then
      for upd in $(ls $USRUPDATEDIR/); do
        export file="$(ls -A $USRUPDATEDIR/$upd 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename $file)"
          __require_sudo bash "$file --cron $*"
        fi
      done
    else
      if [ -d "$USRUPDATEDIR" ] && ls "$USRUPDATEDIR"/* 1>/dev/null 2>&1; then
        export file="$(ls -A $USRUPDATEDIR/$1 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename $file)"
          __require_sudo bash "$file --cron $*"
        fi
      fi
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__installer_delete() {
  local app="${1:-}"
  local APP_DIR_NAME="$GEN_SCRIPT_REPLACE_ENV_APP_DIR"
  local INSTALL_DIR_NAME="$GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR"
  local MESSAGE="${MESSAGE:-Removing $app from ${msg:-your system}}"
  [[ -n "$app" ]] || printf_exit "Please specify the name to delete"
  [[ "$INSTALL_DIR_NAME/$app" == "$INSTALL_DIR_NAME/" ]] && return
  if [ -d "$APP_DIR_NAME/$app" ] || [ -d "$INSTALL_DIR_NAME/$app" ]; then
    printf_yellow "$MESSAGE"
    if [[ -e "$APP_DIR_NAME/$app" ]]; then
      printf_blue "Deleting the files from $APP_DIR_NAME/$app"
      __rm_rf "$APP_DIR_NAME/$app" && exitCode+=0 || exitCode+=1
    fi
    if [[ -e "$INSTALL_DIR_NAME/$app" ]]; then
      printf_blue "Deleting the files from $APP_DIR_NAME/$app"
      __rm_rf "$INSTALL_DIR_NAME/$app" && exitCode+=0 || exitCode+=1
    fi
    if [[ -e "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER/$app" ]]; then
      printf_blue "Deleting the files from $APP_DIR_NAME/$app"
      __rm_rf "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER/$app" && exitCode+=0 || exitCode+=1
    fi
    { [[ -d "$INSTALL_DIR_NAME/$app" ]] || [[ -d "$APP_DIR_NAME/$app" ]]; } && exitCode=0 || exitCode=1
    printf_yellow "Removing any broken symlinks"
    __broken_symlinks "$BIN" "$SHARE" "$COMPDIR" "$CONF" "$THEMEDIR" "$FONTDIR" "$ICONDIR"
    [[ $exitCode = 0 ]] && "$app has been removed"
    return $exitCode
  else
    printf_error "$app doesn't seem to be installed"
  fi
  return ${exitCode}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_install_init() {
  local app
  local INSTALL_DIR_NAME="$GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR"
  for app in "$@"; do
    export SUDO_USER
    if __urlcheck "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh"; then
      export FORCE_INSTALL="$FORCE_INSTALL"
      __require_sudo curl -q -LSsf "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh" 2>/dev/null | bash -s -- 2>/dev/null
    else
      printf_error "Failed to initialize the installer from:"
      printf_exit "$GEN_SCRIPT_REPLACE_ENV_REPO_URL/$app/$GEN_SCRIPT_REPLACE_ENV_REPO_RAW/install.sh\n"
    fi
    local exitCode+=$?
  done
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_install_update() {
  local app APPNAME exitCode
  local USER_SHARE_DIR="$SHARE/CasjaysDev/GEN_SCRIPT_REPLACE_FILENAME"
  local SYSTEM_SHARE_DIR="$SYSSHARE/CasjaysDev/GEN_SCRIPT_REPLACE_FILENAME"
  local USRUPDATEDIR="$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER"
  local SYSUPDATEDIR="$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_SYSTEM"
  local NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME}"
  local NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON}"
  export NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON
  if [ $# = 0 ]; then
    if [[ -d "$USRUPDATEDIR" && -n "$(ls -A "$USRUPDATEDIR" | grep '^' || ls "$USER_SHARE_DIR" | grep '^')" ]]; then
      for app in $(ls "$USRUPDATEDIR" | grep '^' || ls "$USER_SHARE_DIR" | grep '^'); do
        APPNAME="$app"
        __run_install_init "$APPNAME" &&
          __notifications "Installed $APPNAME" ||
          __notifications "Installation of $APPNAME has failed"
        local exitCode+=$?
      done
    fi
    if user_is_root && [ "$USRUPDATEDIR" != "$SYSUPDATEDIR" ]; then
      if [[ -d "$SYSUPDATEDIR" && -n "$(ls -A "$SYSUPDATEDIR" | grep '^' || ls "$SYSTEM_SHARE_DIR" | grep '^')" ]]; then
        for app in $(ls "$SYSUPDATEDIR" | grep '^' || ls "$SYSTEM_SHARE_DIR" | grep '^'); do
          APPNAME="$app"
          __run_install_init "$APPNAME" &&
            __notifications "Installed $APPNAME" ||
            __notifications "Installation of $APPNAME has failed"
          local exitCode+=$?
        done
      fi
    fi
  else
    for app in "$@"; do
      APPNAME="$app"
      __run_install_init "$APPNAME" &&
        __notifications "Installed $APPNAME" ||
        __notifications "Installation of $APPNAME has failed"
      local exitCode+=$?
    done
  fi
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__download() {
  local REPO_NAME="$1"
  local DIR_NAME="${2:-$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR/$REPO_NAME}"
  local REPO_URL="$GEN_SCRIPT_REPLACE_ENV_REPO_URL"
  if cmd_exists gitadmin; then
    if [[ -d "$DIR_NAME/.git" ]]; then
      sudo -u $SUDO_USER gitadmin pull "$DIR_NAME"
      exitCode=$?
    else
      gitadmin clone "$REPO_URL/$REPO_NAME" "$DIR_NAME"
      exitCode=$?
    fi
  else
    if [[ -d "$DIR_NAME/.git" ]]; then
      sudo -u $SUDO_USER git -C "$DIR_NAME" pull
      exitCode=$?
    else
      sudo -u $SUDO_USER git clone "$REPO_URL/$REPO_NAME" "$DIR_NAME"
      exitCode=$?
    fi
  fi
  [[ -d "$DIR_NAME" ]] && exitCode="0" #&& [[ -n "$SUDO_USER" ]] && sudo chown -Rf $SUDO_USER:$SUDO_USER "$DIR_NAME"
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__api_list() {
  local api_url="${GEN_SCRIPT_REPLACE_ENV_REPO_API:-https://api.github.com/orgs/GEN_SCRIPT_REPLACE_FILENAME/repos?per_page=${GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE:-1000}}"
  if __urlcheck "$api_url"; then
    curl -q -LSsf -H "Accept: application/vnd.github.v3+json" "$api_url" 2>/dev/null |
      jq '.[].name' 2>/dev/null | sed 's#"##g' | grep -Ev '.github|template|^null$' |
      grep -v '^null$' | grep '^' || __list_options
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_search() {
  local results=""
  [ $# = 0 ] && printf_exit "Nothing to search for"
  [ -n "$LIST" ] || printf_exit "The enviroment variable LIST does not exist"
  for app in "$@"; do
    local -a result+="$(echo -e "$LIST" | tr ' ' '\n' | grep -Fi "$app" | grep -sv '^$') "
  done
  results="$(echo "$result" | sort -u | tr '\n' ' ' | sed 's| | |g' | grep '^')"
  if [ -z "$results" ]; then
    printf_exit "Your seach produced no results"
  else
    printf '%s\n' "$results" | printf_column "${PRINTF_COLOR:-4}"
  fi
  unset results app
  exit $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default variables
exitCode="0"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
GEN_SCRIPT_REPLACE_ENV_LOG_DIR="${GEN_SCRIPT_REPLACE_ENV_LOG_DIR:-$HOME/.local/log/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_CACHE_DIR="${GEN_SCRIPT_REPLACE_ENV_CACHE_DIR:-$HOME/.cache/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR:-$HOME/.config/myscripts/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/GEN_SCRIPT_REPLACE_FILENAME/backups}"
GEN_SCRIPT_REPLACE_ENV_TEMP_DIR="${GEN_SCRIPT_REPLACE_ENV_TEMP_DIR:-$HOME/.local/tmp/system_scripts/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE="${GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE:-settings.conf}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR:-4}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR:-6}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD:-2}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-Everything Went OK}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-Well something seems to have gone wrong}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED:-yes}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Application overrides
GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH="${GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH:-main}"
GEN_SCRIPT_REPLACE_ENV_APP_DIR="${GEN_SCRIPT_REPLACE_ENV_APP_DIR:-${GEN_SCRIPT_REPLACE_ENV_APP_DIR:-$SHARE/CasjaysDev/GEN_SCRIPT_REPLACE_FILENAME}}"
GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR="${GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR:-${GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR:-$SHARE/CasjaysDev/GEN_SCRIPT_REPLACE_FILENAME}}"
GEN_SCRIPT_REPLACE_ENV_CLONE_DIR="${GEN_SCRIPT_REPLACE_ENV_CLONE_DIR:-$HOME/Projects/github/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_REPO_URL="${GEN_SCRIPT_REPLACE_ENV_REPO_URL:-https://github.com/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_REPO_RAW="${GEN_SCRIPT_REPLACE_ENV_REPO_RAW:-raw/$GEN_SCRIPT_REPLACE_ENV_GIT_REPO_BRANCH}"
GEN_SCRIPT_REPLACE_ENV_REPO_API="${GEN_SCRIPT_REPLACE_ENV_REPO_API:-https://api.github.com/orgs/GEN_SCRIPT_REPLACE_FILENAME/repos}"
GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE="${GEN_SCRIPT_REPLACE_ENV_REPO_API_PER_PAGE:-1000}"
GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL="${GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL:-false}"
GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER="${GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER:-${GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER:-$HOME/.local/share/CasjaysDev/apps/GEN_SCRIPT_REPLACE_FILENAME}}"
GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_SYSTEM="${GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_SYSTEM:-{$:-GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_SYSTEM/usr/local/share/CasjaysDev/apps/GEN_SCRIPT_REPLACE_FILENAME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate non-existing config files
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config "$*"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] && . "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories and files exist
[ -d "$GEN_SCRIPT_REPLACE_ENV_LOG_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_LOG_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR"
GEN_SCRIPT_REPLACE_ENV_TEMP_FILE="${GEN_SCRIPT_REPLACE_ENV_TEMP_FILE:-$(mktemp $GEN_SCRIPT_REPLACE_ENV_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap 'exitCode=${exitCode:-$?};[ -f "GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && rm -Rf "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" &>/dev/null' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
if [ "$GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED" = "yes" ]; then
  __notifications() {
    export NOTIFY_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_NAME="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_ICON="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"
    notifications "$@" || return 1
  }
else
  __notifications() { false; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show warn message if variables are missing

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables/Argument/Option settings
SETARGS="$*"
SHORTOPTS="a,f"
LONGOPTS="options,config,version,help,dir:force,all,raw"
ARRAY="download,list,search,available,remove,version,update,install,cron"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LIST=""
LIST+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -a -n "$(basename "$0" 2>/dev/null)" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case $1 in
  --options)
    shift 1
    [ -n "$1" ] || printf_blue "Current options for ${PROG:-$APPNAME}"
    [ -z "$SHORTOPTS" ] || __list_options "5" "Short Options" "-$SHORTOPTS" ',' '-'
    [ -z "$LONGOPTS" ] || __list_options "5" "Long Options" "--$LONGOPTS" ',' '--'
    [ -z "$ARRAY" ] || __list_options "5" "Base Options" "$ARRAY" ',' ''
    [ -z "$LIST" ] && __api_list | printf_column $GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR || __list_available "$LIST" | printf_column $GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR
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
  --dir)
    shift 1
    GEN_SCRIPT_REPLACE_ENV_CWD="$1"
    ;;
  -f | --force)
    shift 1
    export FORCE_INSTALL="true"
    ;;
  -a | --all)
    shift 1
    INSTALL_ALL="true"
    ;;
  --raw)
    export SHOW_RAW="true"
    unset -f printf_color
    printf_color() { printf '%b' "$1" | tr -d '\t\t' | sed '/^%b$/d;s,\x1B\[[0-9;]*[a-zA-Z],,g'; }

    ;;
  --)
    shift 1
    break
    ;;
  esac
done
#set -- "$SETARGS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
sudo -n true && ask_for_password true && REQUIRE_SUDO="TRUE" || exit 1 # Require root
cmd_exists --error --ask bash curl jq || exit 1                        # exit 1 if not found
__am_i_online --error || exit 1                                        # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
case $1 in
list)
  shift 1
  printf_green "All available GEN_SCRIPT_REPLACE_FILENAME packs"
  __list_available | printf_column '5'
  ;;

available)
  shift 1
  printf_cyan "All available GEN_SCRIPT_REPLACE_FILENAME packs"
  __api_list | printf_column '6'
  ;;

search)
  shift 1
  __run_search "$@"
  ;;

remove)
  shift 1
  if [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY="$(ls -A "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER" 2>/dev/null)"
  else
    LISTARRAY="$*"
  fi
  [ ${#LISTARRAY} -ne 0 ] || printf_exit "No packages selected for removal"
  for rmf in $LISTARRAY; do
    MESSAGE="Removing $rmf from $GEN_SCRIPT_REPLACE_ENV_INSTALL_DIR/$rmf"
    __installer_delete "$rmf"
    echo ""
  done
  ;;

update)
  shift 1
  if [ $# -eq 0 ] || [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY="$(ls -A "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER" 2>/dev/null)"
  else
    LISTARRAY="$*"
  fi
  if [ $# -ne 0 ]; then
    for ins in $LISTARRAY; do
      APPNAME="$ins"
      __run_install_update "$APPNAME"
    done
  elif [[ -d "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER" ]] && [[ ${#LISTARRAY} -ne 0 ]]; then
    for upd in $(ls "$GEN_SCRIPT_REPLACE_ENV_VERSION_DIR_USER"); do
      APPNAME="$upd"
      __run_install_update "$APPNAME"
    done
  else
    printf_yellow "There doesn't seem to be any packages installed"
    __notifications "There doesn't seem to be any packages installed"
  fi
  exit $?
  ;;

install)
  shift 1
  if [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY="$(__list_options)"
  elif [ $# -eq 0 ]; then
    printf_blue "No packages provide running the updater"
    __run_install_update
    exit $?
  else
    LISTARRAY="$*"
  fi
  for ins in $LISTARRAY; do
    APPNAME="$ins"
    __run_install_update "$APPNAME"
  done
  exit $?
  ;;

download | clone)
  shift 1
  if [[ $# = 0 ]] || [[ "$INSTALL_ALL" = "true" ]]; then
    LISTARRAY="$(__list_available)"
  else
    LISTARRAY="$*"
  fi
  if [[ -n "$LISTARRAY" ]]; then
    for pkgs in $LISTARRAY; do
      __download "$pkgs"
    done
  else
    printf_exit "No packages selected for download"
  fi
  ;;

cron)
  shift 1
  LISTARRAY="$*"
  for cron in $LISTARRAY; do
    APPNAME="$cron"
    __cron_updater "$cron"
  done
  ;;

version)
  shift 1
  LISTARRAY="$*"
  for ver in $LISTARRAY; do
    APPNAME="$ver"
    run_install_version "$ver"
  done
  ;;

*)
  __help
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
