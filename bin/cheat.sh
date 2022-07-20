#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207191207-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.com
# @@License          :  WTFPL
# @@ReadME           :  cheat.sh --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Tuesday, Jul 19, 2022 12:07 EDT
# @@File             :  cheat.sh
# @@Description      :  Get help with commands
# @@Changelog        :
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@sudo/root        :
# @@Template         :  bash/system
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="202207191207-git"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[[ "$1" == "--debug" ]] && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[[ "$1" == "--raw" ]] && SHOW_RAW="true" && printf_color() { printf '%b' "$1" | tr -d '\t\t' | sed '/^%b$/d;s,\x1B\[[0-9;]*[a-zA-Z],,g'; }
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
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Options are: devenvmgr_install dfmgr_install dockermgr_install fontmgr_install iconmgr_install pkmgr_install
# system_install systemmgr_install thememgr_install user_install wallpapermgr_install
user_install && __options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__devnull() {
  tee &>/dev/null || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
__devnull2() {
  eval "$*" 2>/dev/null || exitCode=1
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
__logr() {
  printf_color() { printf '%b' "$1" | tr -d '\t\t' | sed '/^%b$/d;s,\x1B\[[0-9;]*[a-zA-Z],,g'; }
  if [ "$#" -ne 0 ]; then
    eval "$*" 2>>"${LOGFILE:-$AM_I_ONLINE_LOG_DIR/$APPNAME.log}.err" >>"${LOGFILE:-$AM_I_ONLINE_LOG_DIR/$APPNAME.log}" || exitCode=1
  else
    cat - &> >(tee -ia "${LOGFILE:-$AM_I_ONLINE_LOG_DIR/$APPNAME.log}" &>/dev/null) || exitCode=1
  fi
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cmd_exist() {
  local exitCode=0
  for cmd in "$@"; do builtin command -v "$cmd" |& __devnull && true || exitCode+=1; done
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# output version
__version() { printf_purple "$VERSION"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# list options
__list_options() {
  printf_color "$1: " "$5"
  echo -ne "$2" | sed 's|:||g;s/'$3'/ '$4'/g'
  printf_newline
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__gen_config() {
  printf_blue "Generating the config file in"
  printf_cyan "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
  [ -d "$CHEAT_SH_CONFIG_DIR" ] || mkdir -p "$CHEAT_SH_CONFIG_DIR"
  [ -d "$CHEAT_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$CHEAT_SH_CONFIG_BACKUP_DIR"
  [ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] &&
    cp -Rf "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" "$CHEAT_SH_CONFIG_BACKUP_DIR/$CHEAT_SH_CONFIG_FILE.$$"
  cat <<EOF >"$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
# Settings for cheat.sh
CHEAT_SH_BIN_DIR="${CHEAT_SH_BIN_DIR:-$CASJAYSDEVDIR/sources}"
CHEAT_SH_URL="${CHEAT_SH_URL:-https://cht.sh}"
CHEAT_SH_HOME="${CHEAT_SH_HOME:-$HOME/.config/myscripts/cheat.sh}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
CHEAT_SH_OUTPUT_COLOR="${CHEAT_SH_OUTPUT_COLOR:-}"
CHEAT_SH_OUTPUT_COLOR_2="${CHEAT_SH_OUTPUT_COLOR:-}"
CHEAT_SH_OUTPUT_COLOR_GOOD="${CHEAT_SH_OUTPUT_COLOR_GOOD:-}"
CHEAT_SH_OUTPUT_COLOR_ERROR="${CHEAT_SH_OUTPUT_COLOR_ERROR:-}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
CHEAT_SH_NOTIFY_ENABLED="${CHEAT_SH_NOTIFY_ENABLED:-}"
CHEAT_SH_GOOD_NAME="${CHEAT_SH_GOOD_NAME:-}"
CHEAT_SH_ERROR_NAME="${CHEAT_SH_ERROR_NAME:-}"
CHEAT_SH_GOOD_MESSAGE="${CHEAT_SH_GOOD_MESSAGE:-}"
CHEAT_SH_ERROR_MESSAGE="${CHEAT_SH_ERROR_MESSAGE:-}"
CHEAT_SH_NOTIFY_CLIENT_NAME="${CHEAT_SH_NOTIFY_CLIENT_NAME:-}"
CHEAT_SH_NOTIFY_CLIENT_ICON="${CHEAT_SH_NOTIFY_CLIENT_ICON:-}"
CHEAT_SH_NOTIFY_CLIENT_URGENCY="${CHEAT_SH_NOTIFY_CLIENT_URGENCY:-}"

EOF
  if [ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ]; then
    [[ "$INIT_CONFIG" = "TRUE" ]] || printf_green "Your config file for $APPNAME has been created"
    . "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
    exitCode=0
  else
    printf_red "Failed to create the config file"
    exitCode=
  fi
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Help function - Align to 55
__help() {
  __printf_head() { printf_purple "$*"; }
  __printf_opts() { printf_cyan "$*"; }
  __printf_line() { printf_blue "$*"; }
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "cheat.sh:  Get help with commands"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "Usage: cheat.sh [options] [commands]"
  __printf_line "cheat.sh                  - "
  __printf_line "cheat.sh                  - "
  __printf_line "cheat.sh                  - "
  __printf_line "cheat.sh                  - "
  __printf_line "cheat.sh                  - "
  __printf_line "cheat.sh                  - "
  __printf_line "cheat.sh                  - "
  __printf_line "cheat.sh                  - "
  __printf_line ""
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "Other Options"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "cheat.sh --help             - Shows this message"
  __printf_line "cheat.sh --config           - Generate user config file"
  __printf_line "cheat.sh --version          - Show script version"
  __printf_line "cheat.sh --options          - Shows all available options"
  __printf_line "cheat.sh --debug            - enable debugging"
  __printf_line "cheat.sh --raw              - removes all formatting on output"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  printf '\n'
  exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined functions
__cheatsh() {
  if [ -f "$HOME/.local/bin/cheat.sh" ]; then
    bash "$HOME/.local/bin/cheat.sh" ${CHEAT_SH_VARS:-} "$*"
  elif [ -f "$CHEAT_SH_BIN_DIR/cheat.sh" ]; then
    bash "$CHEAT_SH_BIN_DIR/cheat.sh" ${CHEAT_SH_VARS:-} "$*"
  else
    printf_red "Can not find cheat.sh in "
    printf_red "$HOME/.local/bin or in"
    printf_exit "$CHEAT_SH_BIN_DIR"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults
exitCode=0
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
CHEAT_SH_CONFIG_FILE="${CHEAT_SH_CONFIG_FILE:-settings.conf}"
CHEAT_SH_CONFIG_DIR="${CHEAT_SH_CONFIG_DIR:-$HOME/.config/myscripts/cheat.sh}"
CHEAT_SH_CONFIG_BACKUP_DIR="${CHEAT_SH_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/cheat.sh/backups}"
CHEAT_SH_LOG_DIR="${CHEAT_SH_LOG_DIR:-$HOME/.local/log/cheat.sh}"
CHEAT_SH_TEMP_DIR="${CHEAT_SH_TEMP_DIR:-$HOME/.local/tmp/system_scripts/cheat.sh}"
CHEAT_SH_CACHE_DIR="${CHEAT_SH_CACHE_DIR:-$HOME/.cache/cheat.sh}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
CHEAT_SH_OUTPUT_COLOR="${CHEAT_SH_OUTPUT_COLOR:-4}"
CHEAT_SH_OUTPUT_COLOR_2="${CHEAT_SH_OUTPUT_COLOR:-5}"
CHEAT_SH_OUTPUT_COLOR_GOOD="${CHEAT_SH_OUTPUT_COLOR_GOOD:-2}"
CHEAT_SH_OUTPUT_COLOR_ERROR="${CHEAT_SH_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
CHEAT_SH_NOTIFY_ENABLED="${CHEAT_SH_NOTIFY_ENABLED:-yes}"
CHEAT_SH_GOOD_NAME="${CHEAT_SH_GOOD_NAME:-Great:}"
CHEAT_SH_ERROR_NAME="${CHEAT_SH_ERROR_NAME:-Error:}"
CHEAT_SH_GOOD_MESSAGE="${CHEAT_SH_GOOD_MESSAGE:-No errors reported}"
CHEAT_SH_ERROR_MESSAGE="${CHEAT_SH_ERROR_MESSAGE:-Error reported}"
CHEAT_SH_NOTIFY_CLIENT_NAME="${CHEAT_SH_NOTIFY_CLIENT_NAME:-$APPNAME}"
CHEAT_SH_NOTIFY_CLIENT_ICON="${CHEAT_SH_NOTIFY_CLIENT_ICON:-notification-new}"
CHEAT_SH_NOTIFY_CLIENT_URGENCY="${CHEAT_SH_NOTIFY_CLIENT_URGENCY:-normal}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional Variables
CHEAT_SH_URL="${CHEAT_SH_URL:-https://cht.sh}"
CHEAT_SH_HOME="${CHEAT_SH_HOME:-$HOME/.config/myscripts/cheat.sh}"
CHEAT_SH_BIN_DIR="${CHEAT_SH_BIN_DIR:-$CASJAYSDEVDIR/sources}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] ||
  [[ "$*" = *config ]] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] &&
  . "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$CHEAT_SH_LOG_DIR" ] ||
  mkdir -p "$CHEAT_SH_LOG_DIR" |& __devnull
[ -d "$CHEAT_SH_TEMP_DIR" ] ||
  mkdir -p "$CHEAT_SH_TEMP_DIR" |& __devnull
[ -d "$CHEAT_SH_CACHE_DIR" ] ||
  mkdir -p "$CHEAT_SH_CACHE_DIR" |& __devnull
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CHEAT_SH_TEMP_FILE="${CHEAT_SH_TEMP_FILE:-$(mktemp $CHEAT_SH_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap 'exitCode=${exitCode:-$?};[ -n "$CHEAT_SH_TEMP_FILE" ] && [ -f "$CHEAT_SH_TEMP_FILE" ] && rm -Rf "$CHEAT_SH_TEMP_FILE" |&__devnull' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
if [ "$CHEAT_SH_NOTIFY_ENABLED" = "yes" ]; then
  __notifications() {
    export NOTIFY_GOOD_MESSAGE="${NOTIFY_GOOD_MESSAGE:-$CHEAT_SH_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${NOTIFY_ERROR_MESSAGE:-$CHEAT_SH_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$CHEAT_SH_NOTIFY_CLIENT_ICON}"
    export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$CHEAT_SH_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_URGENCY="${NOTIFY_CLIENT_URGENCY:-$CHEAT_SH_NOTIFY_CLIENT_URGENCY}"
    notifications "$@" && exitCode=0 || exitCode=1
    unset NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON NOTIFY_GOOD_MESSAGE NOTIFY_ERROR_MESSAGE
    return ${exitCode:-$?}
  }
else
  __notifications() { false; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show warn message if variables are missing

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Argument/Option settings
SETARGS="$*"
SHORTOPTS=""
LONGOPTS="config,debug,dir:,help,options,raw,version,shell:,standalone-install:,mode:"
ARRAY=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -a -n "$(basename "$0" 2>/dev/null)" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  --raw)
    shift 1
    SHOW_RAW="true"
    printf_color() {
      printf '%b' "$1" | tr -d '\t\t' |
        sed '/^%b$/d;s,\x1B\[[0-9;]*[a-zA-Z],,g'
    }
    ;;
  --debug)
    shift 1
    set -xo pipefail
    __devnull() {
      tee || exitCode=1
      return ${exitCode:-$?}
    }
    __devnull2() {
      eval "$*" || exitCode=1
      return ${exitCode:-$?}
    }
    export SCRIPT_OPTS="--debug"
    export _DEBUG="on"
    ;;
  --options)
    shift 1
    printf_blue "Current options for ${PROG:-$APPNAME}"
    [ -z "$SHORTOPTS" ] || __list_options "Short Options" "-${SHORTOPTS}" ',' '-' 4
    [ -z "$LONGOPTS" ] || __list_options "Long Options" "--${LONGOPTS}" ',' '--' 4
    [ -z "$ARRAY" ] || __list_options "Base Options" "${ARRAY}" ',' '' 4
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
    CHEAT_SH_CWD="$2"
    shift 2
    ;;
  --shell | --standalone-install | --mode)
    [ -n "$CHEAT_SH_VARS" ] && CHEAT_SH_VARS="$1 "$2 || CHEAT_SH_VARS+="$1 $2"
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
# Redefine functions based on options

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
cmd_exists --error bash rlwrap || exit 1 # exit 1 if not found
#am_i_online --error || exit 4     # exit 1 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
export CHTSH="${CHTSH:-$CHEAT_SH_HOME}"
export CHEAT_SH_URL="${CHEAT_SH_URL}"
export CHEATSH_CACHE_TYPE=none

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env
[[ -n "$CHEAT_SH_VARS" ]] || [[ $# -ne 0 ]] || printf_exit "Usage: $APPNAME [options] [query]"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
__cheatsh "$*"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
