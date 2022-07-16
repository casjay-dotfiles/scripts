#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207042242-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.com
# @License           :  WTFPL
# @ReadME            :  transfer.sh --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created           :  Wednesday, Aug 18, 2021 10:57 EDT
# @File              :  transfer.sh
# @Description       :  Upload file to https://transfer.sh
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="202108181057-git"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [[ "$1" == "--debug" ]]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi
set -o pipefail

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
  exit 90
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# user system devenv dfmgr dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
user_install && __options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__list_options() { printf_custom "$1" "$2: $(echo ${3:-$ARRAY} | __sed 's|:||g;s|'$4'| '$5'|g')" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__gen_config() {
  [[ "$INIT_CONFIG" = "TRUE" ]] || printf_green "Generating the config file in"
  [[ "$INIT_CONFIG" = "TRUE" ]] || printf_green "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
  [ -d "$TRANSFER_SH_CONFIG_DIR" ] || mkdir -p "$TRANSFER_SH_CONFIG_DIR"
  [ -d "$TRANSFER_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$TRANSFER_SH_CONFIG_BACKUP_DIR"
  [ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] &&
    cp -Rf "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" "$TRANSFER_SH_CONFIG_BACKUP_DIR/$TRANSFER_SH_CONFIG_FILE.$$"
  cat <<EOF >"$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
# Settings for transfer.sh
TRANSFER_SH_USER="${TRANSFER_SH_USER:-$USER}"
TRANSFER_SH_GPG_PASS="${TRANSFER_SH_GPG_PASS:-your_very_strong_password}"
TRANSFER_SH_DAYS_MAX="${TRANSFER_SH_DAYS_MAX:-30}"
TRANSFER_SH_URL="${TRANSFER_SH_URL:-https://transfer.sh}"
TRANSFER_SH_SAVED_LINKS="${TRANSFER_SH_SAVED_LINKS:-$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_URL-savedLinks.txt}"

# Notification settings
TRANSFER_SH_GOOD_MESSAGE="${TRANSFER_SH_GOOD_MESSAGE:-}"
TRANSFER_SH_ERROR_MESSAGE="${TRANSFER_SH_ERROR_MESSAGE:-}"
TRANSFER_SH_NOTIFY_ENABLED="${TRANSFER_SH_NOTIFY_ENABLED:-yes}"
TRANSFER_SH_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
TRANSFER_SH_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$TRANSFER_SH_NOTIFY_CLIENT_ICON}"

# Colorization settings
TRANSFER_SH_OUTPUT_COLOR="${TRANSFER_SH_OUTPUT_COLOR:-5}"
TRANSFER_SH_OUTPUT_COLOR_GOOD="${TRANSFER_SH_OUTPUT_COLOR_GOOD:-2}"
TRANSFER_SH_OUTPUT_COLOR_ERROR="${TRANSFER_SH_OUTPUT_COLOR_ERROR:-1}"

EOF
  if [ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ]; then
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
__filename() {
  local file="$1"
  if [ -d "$file" ]; then
    zip -r -q - "$file" 2>/dev/null >>"${TRANSFER_SH_TMP_UPLOAD_FILE}.zip" || printf_exit 1 10 "Failed to create zip file"
    file="${TRANSFER_SH_TMP_UPLOAD_FILE}.zip"
  elif [ -e "$file" ]; then
    if [[ "$file" = "$TRANSFER_SH_TMP_UPLOAD_FILE" ]]; then
      file="$TRANSFER_SH_TMP_UPLOAD_FILE"
    else
      cp -Rf "$file" "$TRANSFER_SH_TMP_UPLOAD_FILE" 2>/dev/null
      file="$file"
    fi
  else
    printf_exit 1 1 "No file was found at $file"
  fi

  filename="$file"
  TRANSFER_SH_UPLOAD_NAME="$TRANSFER_SH_USER-$(basename "${filename}" 2>/dev/null | sed -e 's|[^a-zA-Z0-9._-]|-|g')"
  export filename TRANSFER_SH_UPLOAD_NAME
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__curl_upload() {
  curl -q -LSsf -H "Max-Days: $TRANSFER_SH_DAYS_MAX" --connect-timeout 2 --retry 0 --upload-file "$1" "$2" 2>"$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME"
  exitCode=$?
  return "${exitCode:-$?}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__curl_put() {
  curl -q -LSsf -H "Max-Days: $TRANSFER_SH_DAYS_MAX" -X PUT --connect-timeout 2 --retry 0 --upload-file "$1" "$2" 2>"$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME"
  exitCode=$?
  return "${exitCode:-$?}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__upload_status() {
  if [[ "${exitCode:-$?}" = 0 ]] && [[ -f "$TRANSFER_SH_STATUS_FILE" ]] && [[ -s "$TRANSFER_SH_STATUS_FILE" ]]; then
    MESSAGE="$(cat "$TRANSFER_SH_STATUS_FILE")"
    TRANSFER_SH_GOOD_MESSAGE="$(printf '%s\n%s\n' "${1:-Link is}" "$MESSAGE")"
    printf_blue "$TRANSFER_SH_GOOD_MESSAGE"
    __notifications "$TRANSFER_SH_GOOD_MESSAGE"
    printf '%s - %s' "$filename" "$message" >>"$TRANSFER_SH_SAVED_LINKS"
    exitCode=0
  else
    echo "error 404" >$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME
    [ -s "$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME" ] && TRANSFER_SH_ERROR_MESSAGE="$(<"$TRANSFER_SH_LOG_DIR/$TRANSFER_SH_UPLOAD_NAME")" || printf '%s' "An unknown error has occurred"
    printf_red "$TRANSFER_SH_ERROR_MESSAGE"
    [ -n "$error" ] && printf '%s\n' "$TRANSFER_SH_ERROR_MESSAGE" | printf_readline 5 &&
      __notifications "$TRANSFER_SH_ERROR_MESSAGE\n"
    exitCode=1
  fi
  [ -f "$TRANSFER_SH_STATUS_FILE" ] && __rm_rf "$TRANSFER_SH_STATUS_FILE"
  [ -f "$TRANSFER_SH_TMP_UPLOAD_FILE" ] && __rm_rf "$TRANSFER_SH_TMP_UPLOAD_FILE"
  [ -f "$TRANSFER_SH_TMP_SDTIN_FILE" ] && __rm_rf "$TRANSFER_SH_TMP_SDTIN_FILE"
  return "${exitCode:-$?}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default variables
exitCode="0"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
TRANSFER_SH_LOG_DIR="${TRANSFER_SH_LOG_DIR:-$HOME/.local/log/transfer.sh}"
TRANSFER_SH_CACHE_DIR="${TRANSFER_SH_CACHE_DIR:-$HOME/.cache/transfer.sh}"
TRANSFER_SH_CONFIG_DIR="${TRANSFER_SH_CONFIG_DIR:-$HOME/.config/myscripts/transfer.sh}"
TRANSFER_SH_CONFIG_BACKUP_DIR="${TRANSFER_SH_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/transfer.sh/backups}"
TRANSFER_SH_TEMP_DIR="${TRANSFER_SH_TEMP_DIR:-$HOME/.local/tmp/system_scripts/transfer.sh}"
TRANSFER_SH_OPTIONS_DIR="${TRANSFER_SH_OPTIONS_DIR:-$HOME/.local/share/myscripts/transfer.sh/options}"
TRANSFER_SH_CONFIG_FILE="${TRANSFER_SH_CONFIG_FILE:-settings.conf}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
TRANSFER_SH_OUTPUT_COLOR="${TRANSFER_SH_OUTPUT_COLOR:-4}"
TRANSFER_SH_OUTPUT_COLOR_2="${TRANSFER_SH_OUTPUT_COLOR:-6}"
TRANSFER_SH_OUTPUT_COLOR_GOOD="${TRANSFER_SH_OUTPUT_COLOR_GOOD:-2}"
TRANSFER_SH_OUTPUT_COLOR_ERROR="${TRANSFER_SH_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
TRANSFER_SH_GOOD_MESSAGE="${TRANSFER_SH_GOOD_MESSAGE:-}"
TRANSFER_SH_ERROR_MESSAGE="${TRANSFER_SH_ERROR_MESSAGE:-}"
TRANSFER_SH_NOTIFY_ENABLED="${TRANSFER_SH_NOTIFY_ENABLED:-yes}"
TRANSFER_SH_NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APPNAME}"
TRANSFER_SH_NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$TRANSFER_SH_NOTIFY_CLIENT_ICON}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional Variables
TRANSFER_SH_USER="${TRANSFER_SH_USER:-$USER}"
TRANSFER_SH_GPG_PASS="${TRANSFER_SH_GPG_PASS:-your_very_strong_password}"
TRANSFER_SH_DAYS_MAX="${TRANSFER_SH_DAYS_MAX:-30}"
TRANSFER_SH_URL="${TRANSFER_SH_URL:-https://transfer.sh}"
TRANSFER_SH_SAVED_LINKS="$(echo "${TRANSFER_SH_SAVED_LINKS:-$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_URL-savedLinks.txt}" | sed 's|.*://||g')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate non-existing config files
[ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] || [[ "$*" = *config ]] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE" ] && . "$TRANSFER_SH_CONFIG_DIR/$TRANSFER_SH_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories and files exist
[ -d "$TRANSFER_SH_LOG_DIR" ] || mkdir -p "$TRANSFER_SH_LOG_DIR" &>/dev/null
[ -d "$TRANSFER_SH_TEMP_DIR" ] || mkdir -p "$TRANSFER_SH_TEMP_DIR" &>/dev/null
[ -d "$TRANSFER_SH_CACHE_DIR" ] || mkdir -p "$TRANSFER_SH_CACHE_DIR" &>/dev/null
[ -f "$TRANSFER_SH_SAVED_LINKS" ] || printf '# Saved links from %s\n' "$TRANSFER_SH_URL" >"$TRANSFER_SH_SAVED_LINKS"
TRANSFER_SH_TEMP_FILE="${TRANSFER_SH_TEMP_FILE:-$(mktemp $TRANSFER_SH_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap 'exitCode=${exitCode:-$?};[ -n "$TRANSFER_SH_TEMP_FILE" ] && [ -f "$TRANSFER_SH_TEMP_FILE" ] && rm -Rf "$TRANSFER_SH_TEMP_FILE" &>/dev/null' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
if [ "$TRANSFER_SH_NOTIFY_ENABLED" = "yes" ]; then
  __notifications() {
    export NOTIFY_GOOD_MESSAGE="${TRANSFER_SH_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${TRANSFER_SH_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_NAME="${TRANSFER_SH_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_ICON="${TRANSFER_SH_NOTIFY_CLIENT_ICON}"
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
SHORTOPTS=""
LONGOPTS="options,config,version,help,dir:"
ARRAY="list scan virustotal backup encrypt"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
cmd_exists --error --ask bash || exit 1 # exit 1 if not found
am_i_online --error || exit 1           # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
[ -n "$1" ] || __help
TRANSFER_SH_STATUS_FILE="$(mktemp -t XXXXXXXXXXXX)"
TRANSFER_SH_TMP_SDTIN_FILE="$(mktemp -t XXXXXXXXXXXX)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
case "$1" in
list)
  shift 1
  printf_cyan "list of links:"
  cat "$TRANSFER_SH_SAVED_LINKS" | printf_column 4 | grep '^' || printf_yellow "No links were found!"
  exit $?
  ;;
scan)
  shift 1
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename "${1:-stdin}")-$(basename "$(mktemp -t XXXXXXXXX)")"
  if [ ! -t 0 ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE" &&
      tar cfz "$TRANSFER_SH_TMP_UPLOAD_FILE.tar.gz" "$TRANSFER_SH_TMP_SDTIN_FILE" &>/dev/null &&
      TRANSFER_SH_TMP_UPLOAD_FILE="$TRANSFER_SH_TMP_UPLOAD_FILE.tar.gz"
    [ -f "$TRANSFER_SH_TMP_UPLOAD_FILE" ] || printf_exit 5 5 "Well something went wrong"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  __curl_upload "$TRANSFER_SH_TMP_UPLOAD_FILE" "https://transfer.sh/${TRANSFER_SH_UPLOAD_NAME}/scan" >>"$TRANSFER_SH_STATUS_FILE" || exitCode=1
  __upload_status "Scan results"
  ;;

virustotal)
  shift 1
  printf_exit 5 1 "This seems to be broken as of July 15, 2022"
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename "${1:-stdin}")-$(basename "$(mktemp -t XXXXXXXXX)")"
  if [ ! -t 0 ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE" &&
      tar cfz "$TRANSFER_SH_TMP_UPLOAD_FILE.tar.gz" "$TRANSFER_SH_TMP_SDTIN_FILE" &>/dev/null &&
      TRANSFER_SH_TMP_UPLOAD_FILE="$TRANSFER_SH_TMP_UPLOAD_FILE.tar.gz"
    [ -f "$TRANSFER_SH_TMP_UPLOAD_FILE" ] || printf_exit 5 5 "Well something went wrong"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  __curl_put "$TRANSFER_SH_TMP_UPLOAD_FILE" "https://transfer.sh/${TRANSFER_SH_UPLOAD_NAME}/virustotal" >>"$TRANSFER_SH_STATUS_FILE" ||
    exitCode=1
  __upload_status "Virus results"
  ;;

encrypt)
  shift 1
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename "${1:-stdin}")-$(basename "$(mktemp -t XXXXXXXXX)")"
  if [ ! -t 0 ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE" && mv -f "$TRANSFER_SH_TMP_SDTIN_FILE" "$TRANSFER_SH_TMP_UPLOAD_FILE.gz"
    TRANSFER_SH_TMP_UPLOAD_FILE="$TRANSFER_SH_TMP_UPLOAD_FILE.gz"
    [ -f "$TRANSFER_SH_TMP_UPLOAD_FILE" ] || printf_exit 5 5 "Well something went wrong"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  cat "$TRANSFER_SH_TMP_UPLOAD_FILE" | gzip | gpg --passphrase "$TRANSFER_SH_GPG_PASS" --batch --quiet --yes -ac -o- |
    __curl_put "-" "https://transfer.sh/${TRANSFER_SH_UPLOAD_NAME}" >>"$TRANSFER_SH_STATUS_FILE" ||
    exitCode=1
  __upload_status "Backed up to"
  ;;

backup)
  shift 1
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename "${1:-stdin}")-$(basename "$(mktemp -t XXXXXXXXX)")"
  if [ ! -t 0 ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE" && mv -f "$TRANSFER_SH_TMP_SDTIN_FILE" "$TRANSFER_SH_TMP_UPLOAD_FILE.gz"
    TRANSFER_SH_TMP_UPLOAD_FILE="$TRANSFER_SH_TMP_UPLOAD_FILE.gz"
    [ -f "$TRANSFER_SH_TMP_UPLOAD_FILE" ] || printf_exit 5 5 "Well something went wrong"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  cat "$TRANSFER_SH_TMP_UPLOAD_FILE" | gzip | gpg --passphrase "$TRANSFER_SH_GPG_PASS" --batch --quiet --yes -ac -o- |
    __curl_put "-" "https://transfer.sh/${TRANSFER_SH_UPLOAD_NAME}" >>"$TRANSFER_SH_STATUS_FILE" ||
    exitCode=1
  __upload_status "Backed up to"
  ;;

*)
  TRANSFER_SH_TMP_UPLOAD_FILE="${TMP:-$HOME/.local/tmp}/$(basename "${1:-stdin}")-$(basename "$(mktemp -t XXXXXXXXX)")"
  if [ ! -t 0 ]; then
    cat - >"$TRANSFER_SH_TMP_SDTIN_FILE" &&
      tar cfz "$TRANSFER_SH_TMP_UPLOAD_FILE.tar.gz" "$TRANSFER_SH_TMP_SDTIN_FILE" &>/dev/null &&
      TRANSFER_SH_TMP_UPLOAD_FILE="$TRANSFER_SH_TMP_UPLOAD_FILE.tar.gz"
    [ -f "$TRANSFER_SH_TMP_UPLOAD_FILE" ] || printf_exit 5 5 "Well something went wrong"
  fi
  __filename "${1:-$TRANSFER_SH_TMP_UPLOAD_FILE}"
  __curl_upload "$TRANSFER_SH_TMP_UPLOAD_FILE" "https://transfer.sh/$TRANSFER_SH_UPLOAD_NAME" >>"$TRANSFER_SH_STATUS_FILE" ||
    exitCode=1
  __upload_status "Link is"
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
