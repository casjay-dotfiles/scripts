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
trap 'exitCode=${exitCode:-$?};[ -f "$IX_IO_TEMP_FILE" ] && rm -Rf "$IX_IO_TEMP_FILE" &>/dev/null' EXIT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202108190117-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : ix.io --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created       : Thursday, Aug 19, 2021 01:17 EDT
# @File          : ix.io
# @Description   :
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

# Colorization settings
IX_IO_OUTPUT_COLOR="${IX_IO_OUTPUT_COLOR:-5}"
IX_IO_OUTPUT_COLOR_GOOD="${IX_IO_OUTPUT_COLOR_GOOD:-2}"
IX_IO_OUTPUT_COLOR_ERROR="${IX_IO_OUTPUT_COLOR_ERROR:-1}"

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
IX_IO_TEMP_DIR="${IX_IO_TEMP_DIR:-$HOME/.local/tmp/system_scripts/ix.io}"
IX_IO_TEMP_FILE="${IX_IO_TEMP_FILE:-$(mktemp $IX_IO_TEMP_DIR/XXXXXX 2>/dev/null)}"
IX_IO_CONFIG_FILE="${IX_IO_CONFIG_FILE:-settings.conf}"
IX_IO_GOOD_MESSAGE="${IX_IO_GOOD_MESSAGE:-Everything Went OK}"
IX_IO_ERROR_MESSAGE="${IX_IO_ERROR_MESSAGE:-Well that didn\'t work}"
IX_IO_NOTIFY_ENABLED="${IX_IO_NOTIFY_ENABLED:-yes}"
IX_IO_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
IX_IO_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$IX_IO_NOTIFY_CLIENT_ICON}"
IX_IO_OUTPUT_COLOR="${IX_IO_OUTPUT_COLOR:-5}"
IX_IO_OUTPUT_COLOR_GOOD="${IX_IO_OUTPUT_COLOR_GOOD:-2}"
IX_IO_OUTPUT_COLOR_ERROR="${IX_IO_OUTPUT_COLOR_ERROR:-1}"
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
SHORTOPTS="z:,d:,i:,n:"
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
  -z | --dir)
    IX_IO_CWD="$2"
    shift 2
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
#am_i_online --error || exit 1     # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
UA=${UA:="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36"}
[ -f "$HOME/.netrc" ] && opts='-n'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
if [ ${#} -eq 0 ]; then
  if [ -p "/dev/stdin" ]; then
    filename="$(</dev/stdin)"
  fi
else
  filename="$*"
fi
echo "$filename" | curl -F 'f:1=<-' ix.io | printf_readline $IX_IO_OUTPUT_COLOR
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
