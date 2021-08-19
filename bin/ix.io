#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202108130401-git"
RUN_USER="${SUDO_USER:-${USER}}"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
trap 'exitCode=${exitCode:-$?};[ -f "$IX_IO_TEMP_FILE" ] && rm -Rf "$IX_IO_TEMP_FILE" &>/dev/null' EXIT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202108130401-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : ix.io --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created       : Friday, Aug 13, 2021 04:01 EDT
# @File          : ix.io
# @Description   : GEN_SCRIPT_REPLACE_DESC
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
__list_available() { printf_custom "$1" "$2: $(echo ${3:-$ARRAY} | __sed 's|:||g;s|'$4'| '$5'|g')" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__gen_config() {
  printf_green "Generating the config file in"
  printf_green "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE"
  [ -d "$IX_IO_CONFIG_DIR" ] || mkdir -p "$IX_IO_CONFIG_DIR"
  [ -d "$IX_IO_CONFIG_BACKUP_DIR" ] || mkdir -p "$IX_IO_CONFIG_BACKUP_DIR"
  [ -f "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" ] &&
    cp -Rf "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" "$IX_IO_CONFIG_BACKUP_DIR/$IX_IO_CONFIG_FILE.$$"
  cat <<EOF >"$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE"
# Settings for ix.io

# Notification settings
IX_IO_GOOD_MESSAGE="${IX_IO_GOOD_MESSAGE:-Everything Went OK}"
IX_IO_ERROR_MESSAGE="${IX_IO_ERROR_MESSAGE:-Well that didn\'t work}"
IX_IO_NOTIFY_ENABLED="${IX_IO_NOTIFY_ENABLED:-yes}"
IX_IO_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
IX_IO_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$IX_IO_NOTIFY_CLIENT_ICON}"

EOF
  if [ -f "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" ]; then
    printf_green "Your config file for ix.io has been created"
    true
  else
    printf_red "Failed to create the config file"
    false
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default variables
exitCode="0"
IX_IO_CACHE_DIR="${IX_IO_CACHE_DIR:-$HOME/.cache/ix.io}"
IX_IO_CONFIG_DIR="${IX_IO_CONFIG_DIR:-$HOME/.config/myscripts/ix.io}"
IX_IO_OPTIONS_DIR="${IX_IO_OPTIONS_DIR:-$HOME/.local/share/myscripts/ix.io/options}"
IX_IO_CONFIG_BACKUP_DIR="${IX_IO_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/ix.io/backups}"
IX_IO_TEMP_DIR="${IX_IO_TEMP_DIR/system_scripts/ix.io:-$HOME/.local/tmp/system_scripts/ix.io}"
IX_IO_TEMP_FILE="${IX_IO_TEMP_DIR:-$HOME/.local/tmp/ix.io}"
IX_IO_CONFIG_FILE="${IX_IO_CONFIG_FILE:-settings.conf}"
IX_IO_GOOD_MESSAGE="${IX_IO_GOOD_MESSAGE:-Everything Went OK}"
IX_IO_ERROR_MESSAGE="${IX_IO_ERROR_MESSAGE:-Well that didn\'t work}"
IX_IO_NOTIFY_ENABLED="${IX_IO_NOTIFY_ENABLED:-yes}"
IX_IO_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
IX_IO_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$IX_IO_NOTIFY_CLIENT_ICON}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$IX_IO_TEMP_DIR" ] || mkdir -p "$IX_IO_TEMP_DIR" &>/dev/null
[ -d "$IX_IO_CACHE_DIR" ] || mkdir -p "$IX_IO_CACHE_DIR" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" ] ||
  __gen_config &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE" ] &&
  . "$IX_IO_CONFIG_DIR/$IX_IO_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show warn message if variables are missing

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables/Argument/Option settings
SETARGS="$*"
SHORTOPTS="z:,h,d:,i:,n:"
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
    [ -z "$SHORTOPTS" ] || __list_available "5" "Short Options" "-$SHORTOPTS" ',' '-'
    [ -z "$LONGOPTS" ] || __list_available "5" "Long Options" "--$LONGOPTS" ',' '--'
    [ -z "$ARRAY" ] || __list_available "5" "Base Options" "$ARRAY" ',' ''
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
    shift 1
    GEN_SCRIPT_REPLACE_CWD="$1"
    ;;

  -d)
    shift 1
    printf_green "curl $opts -X DELETE "ix.io/$OPTARG""
    exit $?
    ;;

  -i)
    shift 1
    opts="$opts -X PUT"
    id="$OPTARG"
    ;;

  -n)
    shift 1
    opts="$opts -F read:1=$OPTARG"
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
if [ "$IX_IO_NOTIFY_ENABLED" = "yes" ]; then
  __notifications() {
    export NOTIFY_GOOD_MESSAGE="${IX_IO_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${IX_IO_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_NAME="${IX_IO_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_ICON="${IX_IO_NOTIFY_CLIENT_ICON}"
    notifications "$*" || return 1
  }
else
  __notifications() { false; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
cmd_exists --error --ask bash || exit 1 # exit 1 if not found
#am_i_online --error || exit       # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
[ -f "$HOME/.netrc" ] && opts='-n'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
[ -t 0 ] && {
  filename="$1"
  shift
  [ "$filename" ] && {
    curl "$opts" -F f:1=@"$filename" "$*" "ix.io/$id"
    exit
  }
  printf_green "^C to cancel, ^D to send."
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
curl "$opts" -F f:1='<-' "$*" "ix.io/$id"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
