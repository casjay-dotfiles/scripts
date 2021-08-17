#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
RUN_USER="${SUDO_USER:-${USER}}"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
trap 'exitCode=${exitCode:-$?};[ -f "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && rm -Rf "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" &>/dev/null' EXIT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : GEN_SCRIPT_REPLACE_VERSION
# @Author        : GEN_SCRIPT_REPLACE_AUTHOR
# @Contact       : GEN_SCRIPT_REPLACE_EMAIL
# @License       : GEN_SCRIPT_REPLACE_LICENSE
# @ReadME        : GEN_SCRIPT_REPLACE_FILENAME --help
# @Copyright     : GEN_SCRIPT_REPLACE_COPYRIGHT
# @Created       : GEN_SCRIPT_REPLACE_DATE
# @File          : GEN_SCRIPT_REPLACE_FILENAME
# @Description   : GEN_SCRIPT_REPLACE_DESC
# @TODO          : GEN_SCRIPT_REPLACE_TODO
# @Other         : GEN_SCRIPT_REPLACE_OTHER
# @Resource      : GEN_SCRIPT_REPLACE_RES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-testing.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/GEN_SCRIPT_REPLACE_ENV/installer/raw/main/functions}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# user system devenv GEN_SCRIPT_REPLACE_ENV dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
user_install
__options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__list_available() { echo -e "$LIST" | tr ',' ' ' | tr ' ' '\n' && exit 0; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__list_options() { printf_custom "$1" "$2: $(echo ${3:-$ARRAY} | __sed 's|:||g;s|'$4'| '$5'|g')" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__gen_config() {
  printf_green "Generating the config file in"
  printf_green "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
  [ -d "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR"
  [ -d "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR"
  [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] &&
    cp -Rf "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE.$$"
  cat <<EOF >"$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# Settings for GEN_SCRIPT_REPLACE_FILENAME
GEN_SCRIPT_REPLACE_ENV_CLONE_DIR="${GEN_SCRIPT_REPLACE_ENV_CLONE_DIR:-$HOME/Projects/github/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_GIT_REPO="${GEN_SCRIPT_REPLACE_ENV_GIT_REPO:-https://github.com/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL="${GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL:-false}"

# Notification settings
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-Everything Went OK}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-Well that didn\'t work}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED:-yes}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"

EOF
  if [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ]; then
    printf_green "Your config file for GEN_SCRIPT_REPLACE_FILENAME has been created"
    true
  else
    printf_red "Failed to create the config file"
    false
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional functions
__download() {
  REPO_NAME="$1"
  REPO_URL="$GEN_SCRIPT_REPLACE_ENV_GIT_REPO/$REPO_NAME"
  DIR_NAME="$GEN_SCRIPT_REPLACE_ENV_CLONE_DIR/$REPO_NAME"
  gitadmin clone "$REPO_URL" "$DIR_NAME"
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__api_list() {
  local api_url="https://api.github.com/orgs/GEN_SCRIPT_REPLACE_FILENAME/repos?per_page=1000"
  am_i_online && curl -q -H "Accept: application/vnd.github.v3+json" -LSs "$api_url" 2>/dev/null |
    jq '.[].name' 2>/dev/null | sed 's#"##g' | grep -v 'template' || __list_options
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_search() {
  [ $# = 0 ] && printf_exit "Nothing to search for"
  [ -n "$LIST" ] || printf_exit "The enviroment variable LIST does not exist"
  local -a LSINST="$*"
  local results=""
  for app in ${LSINST[*]}; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
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
GEN_SCRIPT_REPLACE_ENV_CACHE_DIR="${GEN_SCRIPT_REPLACE_ENV_CACHE_DIR:-/$HOME/.cache/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR:-$HOME/.config/myscripts/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_OPTIONS_DIR="${GEN_SCRIPT_REPLACE_ENV_OPTIONS_DIR:-$HOME/.local/share/myscripts/GEN_SCRIPT_REPLACE_FILENAME/options}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/GEN_SCRIPT_REPLACE_FILENAME/backups}"
GEN_SCRIPT_REPLACE_ENV_TEMP_DIR="${GEN_SCRIPT_REPLACE_ENV_TEMP_DIR/system_scripts/GEN_SCRIPT_REPLACE_FILENAME:-$HOME/.local/tmp/system_scripts/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_TEMP_FILE="${GEN_SCRIPT_REPLACE_ENV_TEMP_DIR:-$HOME/.local/tmp/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE="${GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE:-settings.conf}"
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-Everything Went OK}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-Well that didn\'t work}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED:-yes}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"
GEN_SCRIPT_REPLACE_ENV_GIT_REPO="${GEN_SCRIPT_REPLACE_ENV_GIT_REPO:-https://github.com/GEN_SCRIPT_REPLACE_FILENAME}"
GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL="${GEN_SCRIPT_REPLACE_ENV_FORCE_INSTALL:-false}"
GEN_SCRIPT_REPLACE_ENV_CLONE_DIR="${GEN_SCRIPT_REPLACE_ENV_CLONE_DIR:-$HOME/Projects/github/GEN_SCRIPT_REPLACE_FILENAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" &>/dev/null
[ -d "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] ||
  __gen_config &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] &&
  . "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show warn message if variables are missing

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables/Argument/Option settings
SETARGS="$*"
SHORTOPTS="c,v,h,z:,a,f"
LONGOPTS="options,config,version,help,dir:force,all"
ARRAY="download,list,search,available,remove,version,update,install,cron"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LIST=""
LIST+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -a -n "$PROG" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case $1 in
  --options)
    shift 1
    [ -n "$1" ] || printf_blue "Current options for ${PROG:-$APPNAME}"
    [ -z "$SHORTOPTS" ] || __list_options "5" "Short Options" "-$SHORTOPTS" ',' '-'
    [ -z "$LONGOPTS" ] || __list_options "5" "Long Options" "--$LONGOPTS" ',' '--'
    [ -z "$ARRAY" ] || __list_options "5" "Base Options" "$ARRAY" ',' ''
    exit $?
    ;;
  -v | --version)
    shift 1
    __version
    exit $?
    ;;
  -h | --help)
    shift 1
    __help
    exit $?
    ;;
  -c | --config)
    shift 1
    __gen_config
    exit $?
    ;;
  -z | --dir)
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
  --)
    shift 1
    break
    ;;
  esac
done
#set -- "$SETARGS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env
if [ "$GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED" = "yes" ]; then
  __notifications() {
    export NOTIFY_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_NAME="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_ICON="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"
    notifications "$*" || return 1
  }
else
  __notifications() { false; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
cmd_exists --error bash curl jq || exit 1 # exit 1 if not found
am_i_online --error || exit 1             # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
export GEN_SCRIPT_REPLACE_ENVREPO="$GEN_SCRIPT_REPLACE_ENV_GIT_REPO"
export REPO="$GEN_SCRIPT_REPLACE_ENVREPO"
export APPDIR="$SHARE/CasjaysDev/$SCRIPTS_PREFIX"
export INSTDIR="$SHARE/CasjaysDev/$SCRIPTS_PREFIX"
export installtype
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
case $1 in
list)
  shift 1
  printf_green "All available wallpaper packs"
  __list_available | printf_column '5'
  ;;

search)
  shift 1
  __run_search "$@"
  ;;

available)
  shift 1
  printf_cyan "All available wallpaper packs"
  __api_list | printf_column '6'
  ;;

remove)
  shift 1
  if [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY="$(ls -A "$USRUPDATEDIR" 2>/dev/null)"
  else
    LISTARRAY="$*"
  fi
  [ ${#LISTARRAY} -ne 0 ] || printf_exit "No packages selected for removal"
  for rmf in $LISTARRAY; do
    MESSAGE="Removing $rmf from $WALLPAPERS"
    APPNAME="$rmf"
    installer_delete "$APPNAME"
    echo ""
  done
  ;;

update)
  shift 1
  if [ $# -eq 0 ] || [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY="$(ls -A "$USRUPDATEDIR" 2>/dev/null)"
  else
    LISTARRAY="$*"
  fi
  if [ $# -ne 0 ]; then
    for ins in $LISTARRAY; do
      APPNAME="$ins"
      run_install_update "$APPNAME"
    done
  elif [[ -d "$USRUPDATEDIR" ]] && [[ ${#LISTARRAY} -ne 0 ]]; then
    for upd in $(ls "$USRUPDATEDIR"); do
      APPNAME="$upd"
      run_install_update "$APPNAME"
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
    run_install_update
    exit $?
  else
    LISTARRAY="$*"
  fi
  for ins in $LISTARRAY; do
    APPNAME="$ins"
    run_install_update "$APPNAME"
  done
  exit $?
  ;;

download)
  shift 1
  if [ "$INSTALL_ALL" = "true" ]; then
    LISTARRAY="$(__list_options)"
  elif [ $# -ne 0 ]; then
    LISTARRAY="$*"
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
    __cron_updater "$APPNAME"
  done
  ;;

version)
  shift 1
  LISTARRAY="$*"
  for ver in $LISTARRAY; do
    APPNAME="$ver"
    run_install_version "$APPNAME"
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
