#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="202108181057-git"
RUN_USER="${SUDO_USER:-${USER}}"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[[ "$1" == "--debug" ]] && shift 1 && set -euo pipefail
trap 'exitCode=${exitCode:-$?};[ -f "$TRANSFER_SH_TEMP_FILE" ] && rm -Rf "$TRANSFER_SH_TEMP_FILE" &>/dev/null' EXIT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202108181057-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : transfer.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created       : Wednesday, Aug 18, 2021 10:57 EDT
# @File          : transfer.sh
# @Description   : Upload file to https://transfer.sh
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
  printf_green "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
  [ -d "$TRANSFER_SH_CONFIG_DIR" ] || mkdir -p "$TRANSFER_SH_CONFIG_DIR"
  [ -d "$TRANSFER_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$TRANSFER_SH_CONFIG_BACKUP_DIR"
  [ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] &&
    cp -Rf "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" "$TRANSFER_SH_CONFIG_BACKUP_DIR/$TRANSFER_SH_CONFIG_FILE.$$"
  cat <<EOF >"$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
# Settings for transfer.sh

# Notification settings
TRANSFER_SH_GOOD_MESSAGE="${TRANSFER_SH_GOOD_MESSAGE:-Everything Went OK}"
TRANSFER_SH_ERROR_MESSAGE="${TRANSFER_SH_ERROR_MESSAGE:-Well that didn\'t work}"
TRANSFER_SH_NOTIFY_ENABLED="${TRANSFER_SH_NOTIFY_ENABLED:-yes}"
TRANSFER_SH_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
TRANSFER_SH_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$TRANSFER_SH_NOTIFY_CLIENT_ICON}"

# Colorization settings
TRANSFER_SH_OUTPUT_COLOR="${TRANSFER_SH_OUTPUT_COLOR:-5}"
TRANSFER_SH_OUTPUT_COLOR_GOOD="${TRANSFER_SH_OUTPUT_COLOR_GOOD:-2}"
TRANSFER_SH_OUTPUT_COLOR_ERROR="${TRANSFER_SH_OUTPUT_COLOR_ERROR:-1}"

EOF
  if [ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ]; then
    printf_green "Your config file for transfer.sh has been created"
    true
  else
    printf_red "Failed to create the config file"
    false
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional functions
__curl_upload() { curl -q -LSs --connect-timeout 3 --retry 0 --upload-file "$1" "$2" 2>/dev/null || return 1; }
__filename() { export basefile="$USER-$(basename "$1" 2>/dev/null | sed -e 's/[^a-zA-Z0-9._-]/-/g')"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default variables
exitCode="0"
TRANSFER_SH_CACHE_DIR="${TRANSFER_SH_CACHE_DIR:-$HOME/.cache/transfer.sh}"
TRANSFER_SH_CONFIG_DIR="${TRANSFER_SH_CONFIG_DIR:-$HOME/.config/myscripts/transfer.sh}"
TRANSFER_SH_OPTIONS_DIR="${TRANSFER_SH_OPTIONS_DIR:-$HOME/.local/share/myscripts/transfer.sh/options}"
TRANSFER_SH_CONFIG_BACKUP_DIR="${TRANSFER_SH_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/transfer.sh/backups}"
TRANSFER_SH_TEMP_DIR="${TRANSFER_SH_TEMP_DIR:-$HOME/.local/tmp/system_scripts/transfer.sh}"
TRANSFER_SH_TEMP_FILE="${TRANSFER_SH_TEMP_FILE:-$(mktemp $TRANSFER_SH_TEMP_DIR/XXXXXX 2>/dev/null)}"
TRANSFER_SH_CONFIG_FILE="${TRANSFER_SH_CONFIG_FILE:-settings.conf}"
TRANSFER_SH_GOOD_MESSAGE="${TRANSFER_SH_GOOD_MESSAGE:-Everything Went OK}"
TRANSFER_SH_ERROR_MESSAGE="${TRANSFER_SH_ERROR_MESSAGE:-Well that didn\'t work}"
TRANSFER_SH_NOTIFY_ENABLED="${TRANSFER_SH_NOTIFY_ENABLED:-yes}"
TRANSFER_SH_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
TRANSFER_SH_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$TRANSFER_SH_NOTIFY_CLIENT_ICON}"
TRANSFER_SH_OUTPUT_COLOR="${TRANSFER_SH_OUTPUT_COLOR:-5}"
TRANSFER_SH_OUTPUT_COLOR_GOOD="${TRANSFER_SH_OUTPUT_COLOR_GOOD:-2}"
TRANSFER_SH_OUTPUT_COLOR_ERROR="${TRANSFER_SH_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$TRANSFER_SH_TEMP_DIR" ] || mkdir -p "$TRANSFER_SH_TEMP_DIR" &>/dev/null
[ -d "$TRANSFER_SH_CACHE_DIR" ] || mkdir -p "$TRANSFER_SH_CACHE_DIR" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] ||
  __gen_config &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] &&
  . "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show warn message if variables are missing

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables/Argument/Option settings
SETARGS="$*"
SHORTOPTS="z:"
LONGOPTS="options,config,version,help,dir:"
ARRAY="scan virustotal backup"
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
    TRANSFER_SH_CWD="$2"
    shift 1
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
if [ "$TRANSFER_SH_NOTIFY_ENABLED" = "yes" ]; then
  __notifications() {
    export NOTIFY_GOOD_MESSAGE="${TRANSFER_SH_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${TRANSFER_SH_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_NAME="${TRANSFER_SH_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_ICON="${TRANSFER_SH_NOTIFY_CLIENT_ICON}"
    notifications "$*" || return 1
  }
else
  __notifications() { false; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
cmd_exists --error --ask bash || exit 1 # exit 1 if not found
am_i_online --error || exit 1           # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
[ -n "$1" ] || __help
tmpfile="$(mktemp -t transferXXXXXX)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
case "$1" in
scan)
  shift 1
  __filename "$1"
  __curl_upload "$1" "https://transfer.sh/${basefile}/scan" >>"$tmpfile" || exitCode=1
  ;;

virustotal)
  shift 1
  __filename "$1"
  __curl_upload "$1" "https://transfer.sh/${basefile}/virustotal" >>"$tmpfile" || exitCode=1
  ;;

backup)
  shift 1
  __filename "$1"
  gpg -ac -o- | __curl_upload "-" "https://transfer.sh/${basefile}" >>"$tmpfile" || exitCode=1
  ;;

*)
  if tty -s; then
    __filename "$1"
    __curl_upload "$1" "https://transfer.sh/$basefile" >>"$tmpfile" || exitCode=1
  else
    __curl_upload "-" "https://transfer.sh/${1}" >>"$tmpfile" || exitCode=1
  fi
  ;;
esac
if [[ "$exitCode" = 0 ]] && [[ -f "$tmpfile" ]] && [[ -s "$tmpfile" ]]; then
  printf_blue "Your file has been uploaded..."
  printf_green "Link: $(cat "$tmpfile")"
else
  printf_red "Nothing seems to have happened"
fi
__rm_rf "$tmpfile"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
