#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202208042200-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  cheat.sh --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Thursday, Aug 04, 2022 22:00 EDT
# @@File             :  cheat.sh
# @@Description      :  Get help with commands
# @@Changelog        :  New script
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  bash/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename -- "$0" 2>/dev/null)"
VERSION="202208042200-git"
USER="${SUDO_USER:-$USER}"
RUN_USER="${RUN_USER:-$USER}"
USER_HOME="${USER_HOME:-$HOME}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
CHEAT_SH_REQUIRE_SUDO="${CHEAT_SH_REQUIRE_SUDO:-no}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Reopen in a terminal
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set script title
#CASJAYS_DEV_TILE_FORMAT="${USER}@${HOSTNAME}:${PWD/#$HOME/~} - $APPNAME"
#CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}"
#[ -z "$CASJAYSDEV_TITLE_SET" ] && printf '\033]0;%s\007' "$CASJAYS_DEV_TILE_FORMAT" && CASJAYSDEV_TITLE_SET="$APPNAME"
export CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}" CASJAYSDEV_TITLE_SET
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Initial debugging
[ "$1" = "--debug" ] && set -x && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Disables colorization
[ "$1" = "--raw" ] && export SHOW_RAW="true"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# pipes fail
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-testing.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Options are: *_install
# system user desktopmgr devenvmgr dfmgr dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
user_install && __options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Send all output to /dev/null
__devnull() {
  tee &>/dev/null && exitCode=0 || exitCode=1
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -'
# Send errors to /dev/null
__devnull2() {
  [ -n "$1" ] && local cmd="$1" && shift 1 || return 1
  eval $cmd "$*" 2>/dev/null && exitCode=0 || exitCode=1
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -'
# See if the executable exists
__cmd_exists() {
  local exitCode=0
  [ -n "$1" ] || return 0
  for cmd in "$@"; do
    if builtin command -v "$cmd" &>/dev/null; then
      exitCode=$((exitCode + 0))
    else
      exitCode=$((exitCode + 1))
    fi
  done
  [ $exitCode -eq 0 ] || exitCode=3
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for a valid internet connection
__am_i_online() {
  local exitCode=0
  curl -q -LSsfI --max-time 2 --retry 1 "${1:-https://1.1.1.1}" 2>&1 | grep -qi 'server:.*cloudflare' || exitCode=4
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# colorization
if [ "$SHOW_RAW" = "true" ]; then
  NC=""
  RESET=""
  BLACK=""
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  PURPLE=""
  CYAN=""
  WHITE=""
  ORANGE=""
  LIGHTRED=""
  BG_GREEN=""
  BG_RED=""
  ICON_INFO="[ info ]"
  ICON_GOOD="[ ok ]"
  ICON_WARN="[ warn ]"
  ICON_ERROR="[ error ]"
  ICON_QUESTION="[ ? ]"
  printf_column() { tee | grep '^'; }
  printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[ 0-9;]*[a-zA-Z],,g'; }
else
  printf_color() { printf "%b" "$(tput setaf "${2:-7}" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional printf_ colors
__printf_head() { printf_blue "$1"; }
__printf_opts() { printf_purple "$1"; }
__printf_line() { printf_cyan "$1"; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# output version
__version() { printf_cyan "$VERSION"; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# list options
__list_options() {
  printf_color "$1: " "$5"
  echo -ne "$2" | sed 's|:||g;s/'$3'/ '$4'/g' | tr '\n' ' '
  printf_newline
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# create the config file
__gen_config() {
  local NOTIFY_CLIENT_NAME="$APPNAME"
  if [ "$INIT_CONFIG" != "TRUE" ]; then
    printf_blue "Generating the config file in"
    printf_cyan "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
  fi
  [ -d "$CHEAT_SH_CONFIG_DIR" ] || mkdir -p "$CHEAT_SH_CONFIG_DIR"
  [ -d "$CHEAT_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$CHEAT_SH_CONFIG_BACKUP_DIR"
  [ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] &&
    cp -Rf "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" "$CHEAT_SH_CONFIG_BACKUP_DIR/$CHEAT_SH_CONFIG_FILE.$$"
  cat <<EOF >"$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
# Settings for cheat.sh
CHEAT_SH_URL="${CHEAT_SH_URL:-}"
CHEAT_SH_UPDATE_URL="${CHEAT_SH_UPDATE_URL:-}"
CHEAT_SH_HOME="${CHEAT_SH_HOME:-}"
CHEAT_SH_BIN_DIR="${CHEAT_SH_BIN_DIR:-}"
CHEAT_SH_QUERY_OPTIONS="${CHEAT_SH_QUERY_OPTIONS:-}"
CHEAT_SH_CACHE_TTL="${CHEAT_SH_CACHE_TTL:-}"
CHEAT_SH_CURL_TIMEOUT="${CHEAT_SH_CURL_TIMEOUT:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
CHEAT_SH_OUTPUT_COLOR_1="${CHEAT_SH_OUTPUT_COLOR_1:-}"
CHEAT_SH_OUTPUT_COLOR_2="${CHEAT_SH_OUTPUT_COLOR_2:-}"
CHEAT_SH_OUTPUT_COLOR_GOOD="${CHEAT_SH_OUTPUT_COLOR_GOOD:-}"
CHEAT_SH_OUTPUT_COLOR_ERROR="${CHEAT_SH_OUTPUT_COLOR_ERROR:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
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
  if builtin type -t __gen_config_local | grep -q 'function'; then __gen_config_local; fi
  if [ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ]; then
    [ "$INIT_CONFIG" = "TRUE" ] || printf_green "Your config file for $APPNAME has been created"
    . "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
    exitCode=0
  else
    printf_red "Failed to create the config file"
    exitCode=1
  fi
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Help function - Align to 50
__help() {
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "cheat.sh:  Get help with commands - $VERSION"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "Usage: cheat.sh [options] [commands]"
  __printf_line "TOPIC                           - show cheat sheet on the TOPIC"
  __printf_line "TOPIC/SUB                       - show cheat sheet on the SUB topic in TOPIC"
  __printf_line "~KEYWORD                        - search cheat sheets for KEYWORD"
  __printf_line ":list                           - list all cheat sheets"
  __printf_line ":post                           - how to post new cheat sheet"
  __printf_line ":styles                         - list of color styles"
  __printf_line ":styles-demo                    - show color styles usage examples"
  __printf_line ":random                         - fetches a random cheat sheet"
  __printf_line ":help                           - this page"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "Other Options"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "--help                          - Shows this message"
  __printf_line "--config                        - Generate user config file"
  __printf_line "--version                       - Show script version"
  __printf_line "--options                       - Shows all available options"
  __printf_line "--debug                         - Enables script debugging"
  __printf_line "--raw                           - Removes all formatting on output"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - -"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check if arg is a builtin option
__is_an_option() { if echo "$ARRAY" | grep -q "${1:-^}"; then return 1; else return 0; fi; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user root
__user_is_root() {
  { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; } && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user not root
__user_is_not_root() {
  if { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; }; then return 1; else return 0; fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if user is a member of sudo
__sudo_group() {
  grep -sh "${1:-$USER}" "/etc/group" | grep -Eq 'wheel|adm|sudo' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# # Get sudo password
__sudoask() {
  ask_for_password sudo true && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Run sudo
__sudorun() {
  __sudoif && __cmd_exists sudo && sudo -HE "$@" || { __sudoif && eval "$@"; }
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Test if user has access to sudo
__can_i_sudo() {
  (sudo -vn && sudo -ln) 2>&1 | grep -vq 'may not' >/dev/null && return 0
  __sudo_group "${1:-$USER}" || __sudoif || __sudo true &>/dev/null || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User can run sudo
__sudoif() {
  __user_is_root && return 0
  __can_i_sudo "${RUN_USER:-$USER}" && return 0
  __user_is_not_root && __sudoask && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Run command as root
requiresudo() {
  if [ "$CHEAT_SH_REQUIRE_SUDO" = "yes" ] && [ -z "$CHEAT_SH_REQUIRE_SUDO_RUN" ]; then
    export CHEAT_SH_REQUIRE_SUDO="no"
    export CHEAT_SH_REQUIRE_SUDO_RUN="true"
    __sudo "$@"
    exit $?
  else
    return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute sudo
__sudo() {
  CMD="${1:-echo}" && shift 1
  CMD_ARGS="${*:--e "${RUN_USER:-$USER}"}"
  SUDO="$(builtin command -v sudo 2>/dev/null || echo 'eval')"
  [ "$(basename -- "$SUDO" 2>/dev/null)" = "sudo" ] && OPTS="--preserve-env=PATH -HE"
  if __sudoif; then
    export PATH="$PATH"
    $SUDO ${OPTS:-} $CMD $CMD_ARGS && true || false
    exitCode=$?
  else
    printf '%s\n' "This requires root to run"
    exitCode=1
  fi
  return ${exitCode:-1}
}
# End of sudo functions
# - - - - - - - - - - - - - - - - - - - - - - - - -
__trap_exit() {
  exitCode=${exitCode:-0}
  [ -f "$CHEAT_SH_TEMP_FILE" ] && rm -Rf "$CHEAT_SH_TEMP_FILE" &>/dev/null
  #unset CASJAYSDEV_TITLE_SET && printf '\033]2│;%s\033\\' "${USER}@${HOSTNAME}:${PWD/#$HOME/~} - ${CASJAYSDEV_TITLE_PREV:-$SHELL}"
  if builtin type -t __trap_exit_local | grep -q 'function'; then __trap_exit_local; fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined functions
__curl() { curl -q -LSSf --max-time 2 "$*"; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
__execute_cheatsh() {
  local rc=0

  if [ -n "$standalone_target" ]; then
    __cheatsh_handle_standalone
    return $?
  fi

  if [ -n "$mode_request" ]; then
    __cheatsh_handle_mode "$mode_request"
    return $?
  fi

  if [ "$shell_mode" = "true" ]; then
    __cheatsh_shell_loop "$shell_lang"
    return $?
  fi

  __cheatsh_process_query "$topic" "$list" "$@"
  rc=$?
  return $rc
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__mtime() { # print epoch mtime
  if stat -f %m "$1" >/dev/null 2>&1; then
    stat -f %m "$1"
  else
    stat -c %Y "$1" 2>/dev/null
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__strip_ansi() {
  if __cmd_exists perl; then
    perl -pe 's/\e\[[0-9;]*[A-Za-z]//g'
  else
    # Fallback: attempt with sed (BSD sed uses octal escape for ESC)
    sed -E $'s/\033\\[[0-9;]*[A-Za-z]//g' 2>/dev/null || cat
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Encode a single string (spaces -> '+')
__urlencode() {
  if __cmd_exists python3; then
    python3 - "$@" <<'PY'
import sys, urllib.parse
s = " ".join(sys.argv[1:])
print(urllib.parse.quote_plus(s))
PY
  else
    local s="$*"
    local out="" c i hex
    LC_ALL=C
    for ((i = 0; i < ${#s}; i++)); do
      c="${s:i:1}"
      case "$c" in
      [a-zA-Z0-9.~_-]) out+="$c" ;;
      ' ') out+='+' ;;
      *)
        printf -v hex '%02X' "'$c"
        out+="%$hex"
        ;;
      esac
    done
    printf '%s' "$out"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__file_hash() {
  local s="$1"
  if __cmd_exists sha1sum; then
    printf %s "$s" | sha1sum | awk '{print $1}'
  elif __cmd_exists shasum; then
    printf %s "$s" | shasum -a 1 | awk '{print $1}'
  elif __cmd_exists md5sum; then
    printf %s "$s" | md5sum | awk '{print $1}'
  elif __cmd_exists md5; then
    printf %s "$s" | md5 | awk '{print $NF}'
  else
    printf %s "$s" | cksum | awk '{print $1}'
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# URL encode while keeping path delimiters intact
__urlencode_path() {
  local s="$*"
  if __cmd_exists python3; then
    python3 - "$s" <<'PY'
import sys, urllib.parse
value = " ".join(sys.argv[1:])
print(urllib.parse.quote(value, safe="/:~?&="))
PY
  else
    local encoded
    encoded="$(__urlencode "$s")"
    encoded="${encoded//%2F//}"
    encoded="${encoded//%3A/:}"
    encoded="${encoded//%7E/~}"
    encoded="${encoded//%3F/?}"
    encoded="${encoded//%26/&}"
    encoded="${encoded//%3D/=}"
    printf '%s' "$encoded"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_cache_path() {
  local query="$1"
  [ -n "$CHEAT_SH_EFFECTIVE_CACHE_DIR" ] || return 1
  local key="$(__file_hash "${query}-${CHEAT_SH_QUERY_OPTIONS}")"
  printf '%s/%s.cache' "$CHEAT_SH_EFFECTIVE_CACHE_DIR" "$key"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_cache_valid() {
  local file="$1"
  local ttl="$2"
  [ -f "$file" ] || return 1
  [ "$ttl" -gt 0 ] 2>/dev/null || return 1
  local mtime now
  mtime="$(__mtime "$file")" || return 1
  now="$(date +%s)" || return 1
  [ $((now - mtime)) -le "$ttl" ] 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_build_url() {
  local query="$1"
  local encoded
  encoded="$(__urlencode_path "$query")" || return 1
  local url="${CHEAT_SH_URL%/}/${encoded}"
  if [ -n "$CHEAT_SH_QUERY_OPTIONS" ]; then
    if printf '%s' "$url" | grep -q '\?'; then
      url="${url}&${CHEAT_SH_QUERY_OPTIONS}"
    else
      url="${url}?${CHEAT_SH_QUERY_OPTIONS}"
    fi
  fi
  printf '%s' "$url"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_fetch_to_file() {
  local query="$1"
  local dest="$2"
  local cache_file=""
  if [ "$CHEAT_SH_EFFECTIVE_TTL" -gt 0 ] 2>/dev/null; then
    cache_file="$(__cheatsh_cache_path "$query")"
    if [ -n "$cache_file" ] && __cheatsh_cache_valid "$cache_file" "$CHEAT_SH_EFFECTIVE_TTL"; then
      cp "$cache_file" "$dest" 2>/dev/null && return 0
    fi
  fi

  local url
  url="$(__cheatsh_build_url "$query")" || return 1
  if ! curl -fsSL --max-time "${CHEAT_SH_CURL_TIMEOUT:-10}" "$url" -o "$dest" 2>/dev/null; then
    printf_red "Failed to retrieve cheat sheet for: $query"
    return 1
  fi

  if [ -n "$cache_file" ]; then
    mkdir -p "$CHEAT_SH_EFFECTIVE_CACHE_DIR" 2>/dev/null
    cp "$dest" "$cache_file" 2>/dev/null
  fi
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_copy_output() {
  local file="$1"
  if __cmd_exists wl-copy; then
    wl-copy <"$file"
    return 0
  elif __cmd_exists xclip; then
    xclip -selection clipboard <"$file"
    return 0
  elif __cmd_exists pbcopy; then
    pbcopy <"$file"
    return 0
  elif __cmd_exists clip.exe; then
    clip.exe <"$file"
    return 0
  fi
  printf_yellow "Copy requested but no supported clipboard utility was found"
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_deliver_output() {
  local file="$1"
  local query="$2"

  if [ -n "$save" ]; then
    local target="$save"
    if [ -d "$target" ] || printf '%s' "$target" | grep -q '/$'; then
      local sanitized="${query//\//_}"
      sanitized="${sanitized//[^A-Za-z0-9_.-]/_}"
      target="${target%/}/${sanitized}.txt"
    fi
    mkdir -p "$(dirname "$target")" 2>/dev/null
    cp "$file" "$target" 2>/dev/null || printf_yellow "Unable to save output to $target"
  fi

  if [ "$copy" -eq 1 ] 2>/dev/null; then
    __cheatsh_copy_output "$file"
  fi

  [ "$CHEAT_SH_SILENT" = "true" ] && return 0

  local use_pager=0
  case "${pager_mode:-auto}" in
  on) use_pager=1 ;;
  off) use_pager=0 ;;
  *) [ -n "$PAGER" ] && use_pager=1 ;;
  esac

  if [ "$use_pager" -eq 1 ]; then
    local pager_cmd="${PAGER:-less -R}"
    $pager_cmd "$file"
  else
    cat "$file"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_build_query() {
  local topic="$1"
  local list_flag="$2"
  shift 2 || true
  local args=("$@")

  if [ "$list_flag" -eq 1 ] 2>/dev/null; then
    printf '%s' ":list"
    return 0
  fi

  if [ ${#args[@]} -gt 0 ]; then
    local first="${args[0]}"
    case "$first" in
    :* | ~*)
      printf '%s' "${args[*]}"
      return 0
      ;;
    esac
  fi

  local sections=()
  if [ -n "$topic" ]; then
    IFS='/' read -r -a sections <<<"$topic"
  fi
  if [ ${#args[@]} -gt 0 ]; then
    sections+=("${args[@]}")
  fi

  if [ ${#sections[@]} -eq 0 ]; then
    return 1
  fi

  local query=""
  local sep=""
  local part
  for part in "${sections[@]}"; do
    [ -z "$part" ] && continue
    query+="${sep}${part}"
    sep="/"
  done

  printf '%s' "$query"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_process_query() {
  local topic="$1"
  local list_flag="$2"
  shift 2 || true
  local args=("$@")
  local query
  if ! query="$(__cheatsh_build_query "$topic" "$list_flag" "${args[@]}")"; then
    printf_red "No query specified"
    return 1
  fi

  local tmp_file
  tmp_file="$(mktemp "${CHEAT_SH_TEMP_DIR}/result.XXXXXX" 2>/dev/null)" || tmp_file="$(mktemp 2>/dev/null)"
  if [ -z "$tmp_file" ]; then
    printf_red "Unable to create temporary file"
    return 1
  fi

  if ! __cheatsh_fetch_to_file "$query" "$tmp_file"; then
    rm -f "$tmp_file"
    return 1
  fi

  __cheatsh_deliver_output "$tmp_file" "$query"
  local rc=$?
  rm -f "$tmp_file"
  return $rc
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_handle_mode() {
  local requested="$1"
  local mode_file="${CHEAT_SH_HOME%/}/mode"
  mkdir -p "${mode_file%/*}" 2>/dev/null

  if [ -z "$requested" ] || [ "$requested" = "show" ] || [ "$requested" = "current" ]; then
    if [ -f "$mode_file" ]; then
      cat "$mode_file"
    else
      printf '%s\n' "lite"
    fi
    return 0
  fi

  case "$requested" in
  auto | lite)
    if printf '%s\n' "$requested" >"$mode_file"; then
      printf_green "Mode set to $requested"
      return 0
    fi
    printf_red "Failed to write mode setting to $mode_file"
    return 1
    ;;
  *)
    printf_red "Unsupported mode: $requested"
    return 1
    ;;
  esac
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_handle_standalone() {
  if [ "$standalone_target" = "help" ]; then
    cat <<'EOF'
Standalone installation is not supported directly by this bundled client.

You can install the upstream cheat.sh standalone package manually by
following the guide at:
  https://github.com/chubin/cheat.sh#standalone-mode

Once installed, this wrapper will automatically use the local instance.
EOF
    return 0
  fi
  printf_yellow "Standalone installation is not supported by the embedded client."
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__cheatsh_shell_loop() {
  local section="$1"
  local prompt="cheat.sh"
  [ -n "$section" ] && prompt="${prompt}/${section}"
  printf_cyan "Interactive mode started. Type 'exit' to quit, 'use <topic>' to change section."
  while true; do
    printf '%s> ' "$prompt"
    IFS= read -r line || break
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    case "$line" in
    "") continue ;;
    exit | quit | :q | :quit | :exit) break ;;
    use\ *)
      section="${line#use }"
      section="${section#"${section%%[![:space:]]*}"}"
      section="${section%"${section##*[![:space:]]}"}"
      prompt="cheat.sh"
      [ -n "$section" ] && prompt="${prompt}/${section}"
      continue
      ;;
    esac
    IFS=' ' read -r -a parts <<<"$line"
    __cheatsh_process_query "$section" 0 "${parts[@]}"
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined variables/import external variables

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
CHEAT_SH_CONFIG_FILE="${CHEAT_SH_CONFIG_FILE:-settings.conf}"
CHEAT_SH_CONFIG_DIR="${CHEAT_SH_CONFIG_DIR:-$HOME/.config/myscripts/cheat.sh}"
CHEAT_SH_CONFIG_BACKUP_DIR="${CHEAT_SH_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/cheat.sh/backups}"
CHEAT_SH_LOG_DIR="${CHEAT_SH_LOG_DIR:-$HOME/.local/log/cheat.sh}"
CHEAT_SH_TEMP_DIR="${CHEAT_SH_TEMP_DIR:-$HOME/.local/tmp/system_scripts/cheat.sh}"
CHEAT_SH_CACHE_DIR="${CHEAT_SH_CACHE_DIR:-$HOME/.cache/cheat.sh}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
CHEAT_SH_OUTPUT_COLOR_1="${CHEAT_SH_OUTPUT_COLOR_1:-33}"
CHEAT_SH_OUTPUT_COLOR_2="${CHEAT_SH_OUTPUT_COLOR_2:-5}"
CHEAT_SH_OUTPUT_COLOR_GOOD="${CHEAT_SH_OUTPUT_COLOR_GOOD:-2}"
CHEAT_SH_OUTPUT_COLOR_ERROR="${CHEAT_SH_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
CHEAT_SH_NOTIFY_ENABLED="${CHEAT_SH_NOTIFY_ENABLED:-yes}"
CHEAT_SH_GOOD_NAME="${CHEAT_SH_GOOD_NAME:-Great:}"
CHEAT_SH_ERROR_NAME="${CHEAT_SH_ERROR_NAME:-Error:}"
CHEAT_SH_GOOD_MESSAGE="${CHEAT_SH_GOOD_MESSAGE:-No errors reported}"
CHEAT_SH_ERROR_MESSAGE="${CHEAT_SH_ERROR_MESSAGE:-Errors were reported}"
CHEAT_SH_NOTIFY_CLIENT_NAME="${CHEAT_SH_NOTIFY_CLIENT_NAME:-$APPNAME}"
CHEAT_SH_NOTIFY_CLIENT_ICON="${CHEAT_SH_NOTIFY_CLIENT_ICON:-notification-new}"
CHEAT_SH_NOTIFY_CLIENT_URGENCY="${CHEAT_SH_NOTIFY_CLIENT_URGENCY:-normal}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional Variables
CHEAT_SH_URL="${CHEAT_SH_URL:-https://cht.sh}"
CHEAT_SH_UPDATE_URL="${CHEAT_SH_UPDATE_URL:-$CHEAT_SH_URL/:cht.sh}"
CHEAT_SH_HOME="${CHEAT_SH_HOME:-$HOME/.config/myscripts/cheat.sh}"
CHEAT_SH_BIN_DIR="${CHEAT_SH_BIN_DIR:-$CASJAYSDEVDIR/sources}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] || [ "$*" = "--config" ] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE" ] && . "$CHEAT_SH_CONFIG_DIR/$CHEAT_SH_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$CHEAT_SH_LOG_DIR" ] || mkdir -p "$CHEAT_SH_LOG_DIR" |& __devnull
[ -d "$CHEAT_SH_TEMP_DIR" ] || mkdir -p "$CHEAT_SH_TEMP_DIR" |& __devnull
[ -d "$CHEAT_SH_CACHE_DIR" ] || mkdir -p "$CHEAT_SH_CACHE_DIR" |& __devnull
# - - - - - - - - - - - - - - - - - - - - - - - - -
CHEAT_SH_TEMP_FILE="${CHEAT_SH_TEMP_FILE:-$(mktemp $CHEAT_SH_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap '__trap_exit' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
__notifications() {
  __cmd_exists notifications || return
  [ "$CHEAT_SH_NOTIFY_ENABLED" = "yes" ] || return
  [ "$SEND_NOTIFICATION" = "no" ] && return
  (
    export SCRIPT_OPTS="" _DEBUG=""
    export NOTIFY_GOOD_MESSAGE="${NOTIFY_GOOD_MESSAGE:-$CHEAT_SH_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${NOTIFY_ERROR_MESSAGE:-$CHEAT_SH_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$CHEAT_SH_NOTIFY_CLIENT_ICON}"
    export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$CHEAT_SH_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_URGENCY="${NOTIFY_CLIENT_URGENCY:-$CHEAT_SH_NOTIFY_CLIENT_URGENCY}"
    notifications "$@"
  ) |& __devnull &
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom actions

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Argument/Option settings
topic="${topic:-}"
list=0
pager_mode="${pager_mode:-auto}"
copy=0
save=""
ttl=""
cache_dir=""
shell_mode="false"
shell_lang=""
standalone_target=""
mode_request=""
SETARGS=("$@")
# - - - - - - - - - - - - - - - - - - - - - - - - -
SHORTOPTS="t:LpPcs:T:C:"
# - - - - - - - - - - - - - - - - - - - - - - - - -
LONGOPTS="completions:,config,debug,help,options,raw,version,silent,"
LONGOPTS+="shell:,standalone-install:,mode:,topic:,list,pager,no-pager,copy,save:,ttl:,cache-dir:"
# - - - - - - - - - - - - - - - - - - - - - - - - -
ARRAY=""
ARRAY+=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
LIST=""
LIST+=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$APPNAME" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  --raw)
    shift 1
    export SHOW_RAW="true"
    NC=""
    RESET=""
    BLACK=""
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    PURPLE=""
    CYAN=""
    WHITE=""
    ORANGE=""
    LIGHTRED=""
    BG_GREEN=""
    BG_RED=""
    ICON_INFO="[ info ]"
    ICON_GOOD="[ ok ]"
    ICON_WARN="[ warn ]"
    ICON_ERROR="[ error ]"
    ICON_QUESTION="[ ? ]"
    printf_column() { tee | grep '^'; }
    printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[ 0-9;]*[a-zA-Z],,g'; }
    ;;
  --debug)
    shift 1
    set -xo pipefail
    export SCRIPT_OPTS="--debug"
    export _DEBUG="on"
    __devnull() { tee || return 1; }
    __devnull2() { eval "$@" |& tee -p || return 1; }
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
    printf_blue "Current options for ${PROG:-$APPNAME}"
    [ -z "$SHORTOPTS" ] || __list_options "Short Options" "-${SHORTOPTS}" ',' '-' 4
    [ -z "$LONGOPTS" ] || __list_options "Long Options" "--${LONGOPTS}" ',' '--' 4
    [ -z "$ARRAY" ] || __list_options "Base Options" "${ARRAY}" ',' '' 4
    [ -z "$LIST" ] || __list_options "LIST Options" "${LIST}" ',' '' 4
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
  --silent)
    shift 1
    CHEAT_SH_SILENT="true"
    ;;
  --shell)
    shell_mode="true"
    shell_lang="$2"
    shift 2
    ;;
  --standalone-install)
    standalone_target="$2"
    shift 2
    ;;
  --mode)
    mode_request="$2"
    shift 2
    ;;
  -t | --topic)
    topic="$2"
    shift 2
    ;;
  -L | --list)
    list=1
    shift
    ;;
  -p | --pager)
    pager_mode="on"
    shift
    ;;
  -P | --no-pager)
    pager_mode="off"
    shift
    ;;
  -c | --copy)
    copy=1
    shift
    ;;
  -s | --save)
    save="$2"
    shift 2
    ;;
  -T | --ttl)
    ttl="$2"
    shift 2
    ;;
  -C | --cache-dir)
    cache_dir="$2"
    shift 2
    ;;
  --)
    shift 1
    break
    ;;
  esac
done
# - - - - - - - - - - - - - - - - - - - - - - - - -
CHEAT_SH_EFFECTIVE_CACHE_DIR="${cache_dir:-$CHEAT_SH_CACHE_DIR}"
[ -n "$CHEAT_SH_EFFECTIVE_CACHE_DIR" ] && mkdir -p "$CHEAT_SH_EFFECTIVE_CACHE_DIR" |& __devnull
CHEAT_SH_EFFECTIVE_TTL="${ttl:-${CHEAT_SH_CACHE_TTL:-0}}"
case "${CHEAT_SH_EFFECTIVE_TTL:-0}" in
'') CHEAT_SH_EFFECTIVE_TTL=0 ;;
*[!0-9]*)
  [ -n "$ttl" ] && printf_yellow "Ignoring invalid TTL value: $ttl"
  CHEAT_SH_EFFECTIVE_TTL=0
  ;;
esac
CHEAT_SH_CURL_TIMEOUT="${CHEAT_SH_CURL_TIMEOUT:-10}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Get directory from args
# set -- "$@"
# for arg in "$@"; do
# if [ -d "$arg" ]; then
# CHEAT_SH_CWD="$arg" && shift 1 && SET_NEW_ARGS=("$@") && break
# elif [ -f "$arg" ]; then
# CHEAT_SH_CWD="$(dirname "$arg" 2>/dev/null)" && shift 1 && SET_NEW_ARGS=("$@") && break
# else
# SET_NEW_ARGS+=("$arg")
# fi
# done
# set -- "${SET_NEW_ARGS[@]}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set directory to first argument
# [ -d "$1" ] && __is_an_option "$1" && CHEAT_SH_CWD="$1" && shift 1 || CHEAT_SH_CWD="${CHEAT_SH_CWD:-$PWD}"
CHEAT_SH_CWD="$(realpath "${CHEAT_SH_CWD:-$PWD}" 2>/dev/null)"
# if [ -d "$CHEAT_SH_CWD" ] && cd "$CHEAT_SH_CWD"; then
# if [ "$CHEAT_SH_SILENT" != "true" ] && [ "$CWD_SILENCE" != "true" ]; then
# printf_cyan "Setting working dir to $CHEAT_SH_CWD"
# fi
# else
# printf_exit "💔 $CHEAT_SH_CWD does not exist 💔"
# fi
export CHEAT_SH_CWD
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set actions based on variables

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
#requiresudo "$0" "$@" || exit 2     # exit 2 if errors
#cmd_exists --error --ask bash || exit 3 # exit 3 if not found
#am_i_online --error || exit 4           # exit 4 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides
export CHTSH="${CHTSH:-$CHEAT_SH_HOME}"
export CHEAT_SH_URL="${CHEAT_SH_URL}"
export CHEATSH_CACHE_TYPE="${CHEATSH_CACHE_TYPE:-none}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env
if [ "$shell_mode" != "true" ] && [ -z "$mode_request" ] && [ -z "$standalone_target" ] && [ "$list" -eq 0 ] 2>/dev/null && [ -z "$topic" ] && [ $# -eq 0 ]; then
  printf_exit "Usage: $APPNAME [options] [query]"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute functions

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute commands

# - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
__execute_cheatsh "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set exit code
exitCode=$?
# - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-0}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
