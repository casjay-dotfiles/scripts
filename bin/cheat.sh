#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202108190117-git"
RUN_USER="${SUDO_USER:-${USER}}"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
trap 'exitCode=${exitCode:-$?};[ -f "$CHEAT_SH_TEMP_FILE" ] && rm -Rf "$CHEAT_SH_TEMP_FILE" &>/dev/null' EXIT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202108190117-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : cheat.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created       : Thursday, Aug 19, 2021 01:17 EDT
# @File          : cheat.sh
# @Description   : Get help with commands
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
  printf_green "Generating the config file in"
  printf_green "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
  [ -d "$CHEAT_SH_CONFIG_DIR" ] || mkdir -p "$CHEAT_SH_CONFIG_DIR"
  [ -d "$CHEAT_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$CHEAT_SH_CONFIG_BACKUP_DIR"
  [ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] &&
    cp -Rf "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" "$CHEAT_SH_CONFIG_BACKUP_DIR/$CHEAT_SH_CONFIG_FILE.$$"
  cat <<EOF >"$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
# Settings for cheat.sh
CHEAT_SH_BIN_DIR="${CHEAT_SH_BIN_DIR:-$CASJAYSDEVDIR/sources}"
CHEAT_SH_URL="${CHEAT_SH_URL:-https://cht.sh}"
CHEAT_SH_HOME="${CHEAT_SH_HOME:-$HOME/.config/myscripts/cheat.sh}"

# Notification settings
CHEAT_SH_GOOD_MESSAGE="${CHEAT_SH_GOOD_MESSAGE:-Everything Went OK}"
CHEAT_SH_ERROR_MESSAGE="${CHEAT_SH_ERROR_MESSAGE:-Well that didn\'t work}"
CHEAT_SH_NOTIFY_ENABLED="${CHEAT_SH_NOTIFY_ENABLED:-yes}"
CHEAT_SH_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
CHEAT_SH_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$CHEAT_SH_NOTIFY_CLIENT_ICON}"

# Colorization settings
CHEAT_SH_OUTPUT_COLOR="${CHEAT_SH_OUTPUT_COLOR:-5}"
CHEAT_SH_OUTPUT_COLOR_GOOD="${CHEAT_SH_OUTPUT_COLOR_GOOD:-2}"
CHEAT_SH_OUTPUT_COLOR_ERROR="${CHEAT_SH_OUTPUT_COLOR_ERROR:-1}"

EOF
  if [ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ]; then
    printf_green "Your config file for cheat.sh has been created"
    true
  else
    printf_red "Failed to create the config file"
    false
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional functions
__cheatsh() {
  if [ -f "$HOME/.local/bin/cheat.sh" ]; then
    bash "$HOME/.local/bin/cheat.sh" "$*"
  elif [ -f "$CHEAT_SH_BIN_DIR/cheat.sh" ]; then
    bash "$CHEAT_SH_BIN_DIR/cheat.sh" "$*"
  else
    printf_red "Can not find cheat.sh in "
    printf_red "$HOME/.local/bin or in"
    printf_exit "$CHEAT_SH_BIN_DIR"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default variables
exitCode="0"
CHEAT_SH_CACHE_DIR="${CHEAT_SH_CACHE_DIR:-$HOME/.cache/cheat.sh}"
CHEAT_SH_CONFIG_DIR="${CHEAT_SH_CONFIG_DIR:-$HOME/.config/myscripts/cheat.sh}"
CHEAT_SH_OPTIONS_DIR="${CHEAT_SH_OPTIONS_DIR:-$HOME/.local/share/myscripts/cheat.sh/options}"
CHEAT_SH_CONFIG_BACKUP_DIR="${CHEAT_SH_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/cheat.sh/backups}"
CHEAT_SH_TEMP_DIR="${CHEAT_SH_TEMP_DIR:-$HOME/.local/tmp/system_scripts/cheat.sh}"
CHEAT_SH_TEMP_FILE="${CHEAT_SH_TEMP_FILE:-$(mktemp $CHEAT_SH_TEMP_DIR/XXXXXX 2>/dev/null)}"
CHEAT_SH_CONFIG_FILE="${CHEAT_SH_CONFIG_FILE:-settings.conf}"
CHEAT_SH_GOOD_MESSAGE="${CHEAT_SH_GOOD_MESSAGE:-Everything Went OK}"
CHEAT_SH_ERROR_MESSAGE="${CHEAT_SH_ERROR_MESSAGE:-Well that didn\'t work}"
CHEAT_SH_NOTIFY_ENABLED="${CHEAT_SH_NOTIFY_ENABLED:-yes}"
CHEAT_SH_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
CHEAT_SH_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$CHEAT_SH_NOTIFY_CLIENT_ICON}"
CHEAT_SH_OUTPUT_COLOR="${CHEAT_SH_OUTPUT_COLOR:-5}"
CHEAT_SH_OUTPUT_COLOR_GOOD="${CHEAT_SH_OUTPUT_COLOR_GOOD:-2}"
CHEAT_SH_OUTPUT_COLOR_ERROR="${CHEAT_SH_OUTPUT_COLOR_ERROR:-1}"
CHEAT_SH_URL="${CHEAT_SH_URL:-https://cht.sh}"
CHEAT_SH_HOME="${CHEAT_SH_HOME:-$HOME/.config/myscripts/cheat.sh}"
CHEAT_SH_BIN_DIR="${CHEAT_SH_BIN_DIR:-$CASJAYSDEVDIR/sources}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$CHEAT_SH_TEMP_DIR" ] || mkdir -p "$CHEAT_SH_TEMP_DIR" &>/dev/null
[ -d "$CHEAT_SH_CACHE_DIR" ] || mkdir -p "$CHEAT_SH_CACHE_DIR" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] ||
  __gen_config &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] &&
  . "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show warn message if variables are missing

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables/Argument/Option settings
SETARGS="$*"
SHORTOPTS="z:"
LONGOPTS="options,config,version,help,dir:,shell,standalone-install,mode"
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
  -z | --dir)
    CHEAT_SH_CWD="$2"
    shift 2
    ;;
  --shell | --standalone-install | --mode)
    shift 1
    RESET_VARS="true"
    ;;
  --)
    shift 1
    break
    ;;
  esac
done
[[ -z "$RESET_VARS" ]] || set -- "$SETARGS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env
if [ "$CHEAT_SH_NOTIFY_ENABLED" = "yes" ]; then
  __notifications() {
    export NOTIFY_GOOD_MESSAGE="${CHEAT_SH_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${CHEAT_SH_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_NAME="${CHEAT_SH_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_ICON="${CHEAT_SH_NOTIFY_CLIENT_ICON}"
    notifications "$*" || return 1
  }
else
  __notifications() { false; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
cmd_exists --error --ask bash || exit 1       # exit 1 if not found
am_i_online --error "$CHEAT_SH_URL" || exit 1 # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
export CHTSH="${CHTSH:-$CHEAT_SH_HOME}"
export CHEAT_SH_URL="${CHEAT_SH_URL}"
export CHEATSH_CACHE_TYPE=none

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
__cheatsh "$*"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
