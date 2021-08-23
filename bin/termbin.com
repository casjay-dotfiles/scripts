#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="202108181957-git"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [[ "$1" == "--debug" ]]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi
trap 'exitCode=${exitCode:-$?};[ -f "$TERMBIN_COM_TEMP_FILE" ] && rm -Rf "$TERMBIN_COM_TEMP_FILE" &>/dev/null' EXIT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202108181957-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : termbin.com --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created       : Wednesday, Aug 18, 2021 19:57 EDT
# @File          : termbin.com
# @Description   : Post text to termbin.com
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-testing.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
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
# user system devenv dfmgr dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
user_install
__options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__list_options() { printf_custom "$1" "$2: $(echo ${3:-$ARRAY} | __sed 's|:||g;s|'$4'| '$5'|g')" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__gen_config() {
  [[ -n "$SHOW_CONFIG_MESSAGE" ]] || printf_green "Generating the config file in"
  [[ -n "$SHOW_CONFIG_MESSAGE" ]] || printf_green "$TERMBIN_COM_CONFIG_DIR/$TERMBIN_COM_CONFIG_FILE"
  [ -d "$TERMBIN_COM_CONFIG_DIR" ] || mkdir -p "$TERMBIN_COM_CONFIG_DIR"
  [ -d "$TERMBIN_COM_CONFIG_BACKUP_DIR" ] || mkdir -p "$TERMBIN_COM_CONFIG_BACKUP_DIR"
  [ -f "$TERMBIN_COM_CONFIG_DIR/$TERMBIN_COM_CONFIG_FILE" ] &&
    cp -Rf "$TERMBIN_COM_CONFIG_DIR/$TERMBIN_COM_CONFIG_FILE" "$TERMBIN_COM_CONFIG_BACKUP_DIR/$TERMBIN_COM_CONFIG_FILE.$$"
  cat <<EOF >"$TERMBIN_COM_CONFIG_DIR/$TERMBIN_COM_CONFIG_FILE"
# Settings for termbin.com
TERMBIN_COM_URL_HOST="${TERMBIN_COM_URL_HOST:-termbin.com}"
TERMBIN_COM_URL_HOST_PORT="${TERMBIN_COM_URL_HOST_PORT:-9999}"

# Notification settings
TERMBIN_COM_GOOD_MESSAGE="${TERMBIN_COM_GOOD_MESSAGE:-Everything Went OK}"
TERMBIN_COM_ERROR_MESSAGE="${TERMBIN_COM_ERROR_MESSAGE:-Well that didn\'t work}"
TERMBIN_COM_NOTIFY_ENABLED="${TERMBIN_COM_NOTIFY_ENABLED:-yes}"
TERMBIN_COM_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
TERMBIN_COM_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$TERMBIN_COM_NOTIFY_CLIENT_ICON}"

# Colorization settings
TERMBIN_COM_OUTPUT_COLOR="${TERMBIN_COM_OUTPUT_COLOR:-5}"
TERMBIN_COM_OUTPUT_COLOR_GOOD="${TERMBIN_COM_OUTPUT_COLOR_GOOD:-2}"
TERMBIN_COM_OUTPUT_COLOR_ERROR="${TERMBIN_COM_OUTPUT_COLOR_ERROR:-1}"

EOF
  if [ -f "$TERMBIN_COM_CONFIG_DIR/$TERMBIN_COM_CONFIG_FILE" ]; then
    [[ -n "$SHOW_CONFIG_MESSAGE" ]] || printf_green "Your config file for termbin.com has been created"
    $APPNAME "$*" && exitCode=0 || exitCode=$?
  else
    printf_red "Failed to create the config file"
    exitCode=1
  fi
  exit ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default variables
exitCode="0"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
TERMBIN_COM_LOG_DIR="${TERMBIN_COM_LOG_DIR:-$HOME/.local/log/termbin.com}"
TERMBIN_COM_CACHE_DIR="${TERMBIN_COM_CACHE_DIR:-$HOME/.cache/termbin.com}"
TERMBIN_COM_CONFIG_DIR="${TERMBIN_COM_CONFIG_DIR:-$HOME/.config/myscripts/termbin.com}"
TERMBIN_COM_CONFIG_BACKUP_DIR="${TERMBIN_COM_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/termbin.com/backups}"
TERMBIN_COM_TEMP_DIR="${TERMBIN_COM_TEMP_DIR:-$HOME/.local/tmp/system_scripts/termbin.com}"
TERMBIN_COM_OPTIONS_DIR="${TERMBIN_COM_OPTIONS_DIR:-$HOME/.local/share/myscripts/termbin.com/options}"
TERMBIN_COM_TEMP_FILE="${TERMBIN_COM_TEMP_FILE:-$(mktemp $TERMBIN_COM_TEMP_DIR/XXXXXX 2>/dev/null)}"
TERMBIN_COM_CONFIG_FILE="${TERMBIN_COM_CONFIG_FILE:-settings.conf}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
TERMBIN_COM_OUTPUT_COLOR="${TERMBIN_COM_OUTPUT_COLOR:-4}"
TERMBIN_COM_OUTPUT_COLOR_2="${TERMBIN_COM_OUTPUT_COLOR:-6}"
TERMBIN_COM_OUTPUT_COLOR_GOOD="${TERMBIN_COM_OUTPUT_COLOR_GOOD:-2}"
TERMBIN_COM_OUTPUT_COLOR_ERROR="${TERMBIN_COM_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
TERMBIN_COM_GOOD_MESSAGE="${TERMBIN_COM_GOOD_MESSAGE:-Everything Went OK}"
TERMBIN_COM_ERROR_MESSAGE="${TERMBIN_COM_ERROR_MESSAGE:-Well that didn\'t work}"
TERMBIN_COM_NOTIFY_ENABLED="${TERMBIN_COM_NOTIFY_ENABLED:-yes}"
TERMBIN_COM_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
TERMBIN_COM_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$TERMBIN_COM_NOTIFY_CLIENT_ICON}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Application overrides
TERMBIN_COM_NETCATCMD="${TERMBIN_COM_NETCATCMD:-$(type -P netcat 2>/dev/null || type -P nc 2>/dev/null)}"
TERMBIN_COM_URL_HOST="${TERMBIN_COM_URL_HOST:-termbin.com}"
TERMBIN_COM_URL_HOST_PORT="${TERMBIN_COM_URL_HOST_PORT:-9999}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$TERMBIN_COM_CONFIG_DIR/$TERMBIN_COM_CONFIG_FILE" ] && . "$TERMBIN_COM_CONFIG_DIR/$TERMBIN_COM_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$TERMBIN_COM_LOG_DIR" ] || mkdir -p "$TERMBIN_COM_LOG_DIR" &>/dev/null
[ -d "$TERMBIN_COM_TEMP_DIR" ] || mkdir -p "$TERMBIN_COM_TEMP_DIR" &>/dev/null
[ -d "$TERMBIN_COM_CACHE_DIR" ] || mkdir -p "$TERMBIN_COM_CACHE_DIR" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate non-existing config files
[ -f "$TERMBIN_COM_CONFIG_DIR/$TERMBIN_COM_CONFIG_FILE" ] || SHOW_CONFIG_MESSAGE=NO __gen_config "$*"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show warn message if variables are missing

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables/Argument/Option settings
SETARGS="$*"
SHORTOPTS=""
LONGOPTS="options,config,version,help,dir:"
ARRAY=""
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
    TERMBIN_COM_CWD="$2"
    shift 2
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
if [ "$TERMBIN_COM_NOTIFY_ENABLED" = "yes" ]; then
  __notifications() {
    export NOTIFY_GOOD_MESSAGE="${TERMBIN_COM_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${TERMBIN_COM_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_NAME="${TERMBIN_COM_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_ICON="${TERMBIN_COM_NOTIFY_CLIENT_ICON}"
    notifications "$*" || return 1
  }
else
  __notifications() { false; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
cmd_exists --error --ask bash $TERMBIN_COM_NETCATCMD || exit 1 # exit 1 if not found
#am_i_online --error || exit 1     # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
OLDIFS="$IFS"
IFS=''
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
if [ ${#} -eq 0 ]; then
  if [ -p "/dev/stdin" ]; then
    message="$(</dev/stdin)"
    printf '%s' "$message" | $TERMBIN_COM_NETCATCMD $TERMBIN_COM_URL_HOST $TERMBIN_COM_URL_HOST_PORT >"$TERMBIN_COM_TEMP_FILE" 2>/dev/null
  else
    echo "Type your paste, hit control-d when done"
    message="$(</dev/stdin)"
    printf '%s' "$message" | $TERMBIN_COM_NETCATCMD $TERMBIN_COM_URL_HOST $TERMBIN_COM_URL_HOST_PORT >"$TERMBIN_COM_TEMP_FILE" 2>/dev/null
  fi
else
  message="$*"
  printf '%s' "$message" | $TERMBIN_COM_NETCATCMD $TERMBIN_COM_URL_HOST $TERMBIN_COM_URL_HOST_PORT >"$TERMBIN_COM_TEMP_FILE" 2>/dev/null
fi
if [ -f "$TERMBIN_COM_TEMP_FILE" ]; then
  printf_readline $TERMBIN_COM_OUTPUT_COLOR <"$TERMBIN_COM_TEMP_FILE" 2>/dev/null
  printf '\n'
else
  printf_red "Something went wrong"
fi

IFS="$OLDIFS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
