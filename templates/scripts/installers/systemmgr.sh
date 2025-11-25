#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  GEN_SCRIPT_REPLACE_VERSION
# @@Author           :  GEN_SCRIPT_REPLACE_AUTHOR
# @@Contact          :  GEN_SCRIPT_REPLACE_EMAIL
# @@License          :  GEN_SCRIPT_REPLACE_LICENSE
# @@ReadME           :  GEN_SCRIPT_REPLACE_FILENAME --help
# @@Copyright        :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @@Created          :  GEN_SCRIPT_REPLACE_DATE
# @@File             :  GEN_SCRIPT_REPLACE_FILENAME
# @@Description      :  Install configurations for GEN_SCRIPT_REPLACE_APPNAME
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  GEN_SCRIPT_REPLACE_TODO
# @@Other            :  GEN_SCRIPT_REPLACE_OTHER
# @@Resource         :  GEN_SCRIPT_REPLACE_RES
# @@Terminal App     :  GEN_SCRIPT_REPLACE_TERMINAL
# @@sudo/root        :  GEN_SCRIPT_REPLACE_SUDO
# @@Template         :  installers/systemmgr
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
USER="${SUDO_USER:-$USER}"
RUN_USER="${RUN_USER:-$USER}"
USER_HOME="${USER_HOME:-$HOME}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
export SCRIPTS_PREFIX="systemmgr"
# - - - - - - - - - - - - - - - - - - - - - - - - -
REPO_BRANCH="${GIT_REPO_BRANCH:-main}"
REPO="https://github.com/$SCRIPTS_PREFIX/$APPNAME"
REPORAW="https://github.com/$SCRIPTS_PREFIX/$APPNAME/raw/$REPO_BRANCH"
# - - - - - - - - - - - - - - - - - - - - - - - - -
INSTDIR="/usr/local/share/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
APPDIR="/usr/local/share/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
PLUGIN_DIR="/usr/local/share/$SCRIPTS_PREFIX/$APPNAME/plugins"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
trap 'retVal=$?;trap_exit' ERR EXIT SIGINT
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
[ "$1" = "--debug" ] && set -x && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[ "$1" = "--raw" ] && export SHOW_RAW="true"
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - -
for app in curl wget git; do type -P "$app" >/dev/null 2>&1 || missing_app+=("$app"); done && [ -z "${missing_app[*]}" ] || { printf '%s\n' "${missing_app[*]}" && exit 1; }
connect_test() { curl -q -ILSsf --retry 1 --max-time 2 "https://1.1.1.1" 2>&1 | grep -iq 'server:*.cloudflare' || return 1; }
verify_url() { urlcheck "$1" &>/dev/null || { printf_red "😿 The URL $1 returned an error. 😿" && exit 1; }; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-mgr-installers.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/systemmgr/installer/raw/GEN_SCRIPT_REPLACE_DEFAULT_BRANCH/functions}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -q -LSsf "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 90
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# printf_space spacing color message value
__printf_space() {
  test -n "$1" && test -z "${1//[0-9]/}" && local padl="$1" && shift 1 || local padl="40"
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="7"
  local string1="$1"
  local string2="$2"
  local pad=$(printf '%0.1s' " "{1..60})
  local message="$(printf "%b" "$(tput setaf "$color" 2>/dev/null)")"
  message+="$(printf '%s' "$string1") "
  message+="$(printf '%*.*s' 0 $((padl - ${#string1} - ${#string2})) "$pad") "
  message+="$(printf '%s' "$string2") "
  message+="$(printf '%b\n' "$(tput sgr0 2>/dev/null)")"
  printf '%s\n' "$message"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define custom functions
__am_i_online() { connect_test || return 1; }
__run_git_clone_pull() { git_update "$1" "$2"; }
__cmd_exists() { builtin type -P $1 &>/dev/null; }
__mkdir() { mkdir -p "$@" &>/dev/null || return 1; }
__app_is_running() { pidof "$1" &>/dev/null || return 1; }
__mv_f() { [ -e "$1" ] && mv -f "$@" &>/dev/null || return 1; }
__cp_rf() { [ -e "$1" ] && cp -Rfa "$@" &>/dev/null || return 1; }
__ln() { [ -e "$1" ] && ln -sf "$1" "$2" &>/dev/null || return 1; }
__chmod() { [ -e "$2" ] && chmod -Rf "$@" 2>/dev/null || return 1; }
__replace_one() { $sed -i "s|$1|$2|g" "$3" &>/dev/null || return 1; }
__rm_rf() { [ -e "$1" ] && { rm -Rf "$@" &>/dev/null || return 1; } || true; }
__rm_link() { [ -e "$1" ] && { rm -rf "$1" &>/dev/null || return 1; } || true; }
__download_file() { curl -q -LSsf "$1" -o "$2" 2>/dev/null || return 1; }
__input_is_number() { test -n "$1" && test -z "${1//[0-9]/}" || return 1; }
__failexitcode() { [ $1 -ne 0 ] && printf_red "😠 $2 😠" && exit ${1:-4}; }
__get_exit_status() { local s=$? && getRunStatus=$((s + ${getRunStatus:-0})) && return $s; }
__get_version() { echo "$@" | awk -F '.' '{ printf("%d%d%d%d\n", $1,$2,$3,$4) }'; }
__silent_start() { __cmd_exists $1 && (eval "$*" &>/dev/null &) && __app_is_running $1 || return 1; }
__total_memory() { mem="$(free | grep -i 'mem: ' | awk -F ' ' '{print $2}')" && echo $((mem / 1000)); }
__symlink() { { __rm_rf "$2" || true; } && ln_sf "$1" "$2" &>/dev/null || { [ -L "$2" ] || return 1; }; }
__get_pid() { ps -aux | grep -v ' grep ' | grep "$1" | awk -F ' ' '{print $2}' | grep ${2:-[0-9]} || return 1; }
__dir_count() { find -L "${1:-./}" -maxdepth "${2:-1}" -not -path "${1:-./}/.git/*" -type d 2>/dev/null | wc -l; }
__file_count() { find -L "${1:-./}" -maxdepth "${2:-1}" -not -path "${1:-./}/.git/*" -type f 2>/dev/null | wc -l; }
__kill_process_id() { __input_is_number $1 && pid=$1 && { [ -z "$pid" ] || kill -15 $pid &>/dev/null; } || return 1; }
__kill() { __kill_process_id "$1" || __kill_process_name "$1" || { ! __app_is_running "$1" || kill -9 $pid &>/dev/null; } || return 1; }
__port_in_use() { netstat -tauln 2>&1 | grep ' LISTEN' | awk -F' ' '{print $4}' | awk -F':' '{print $NF}' | sort -u | grep -q "^$1$" || return 2; }
__replace_all() { [ -n "$3" ] && [ -e "$3" ] && find "$3" -not -path "$3/.git/*" -type f -exec $sed -i "s|$1|$2|g" {} \; >/dev/null 2>&1 || return 1; }
__kill_process_name() { local pid="$(pidof "$1" 2>/dev/null)" && { [ -z "$pid" ] || { kill -19 $pid &>/dev/null && ! __app_is_running "$1" && return 0; } || kill -9 $pid &>/dev/null; } || return 1; }
__does_container_exist() { [ -n "$(command -v docker 2>/dev/null)" ] && docker ps -a | awk '{print $NF}' | grep -v '^NAMES$' | grep -q "$1" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
__service_enable() { \systemctl enable --now "$1" || return 1; }
__service_disable() { \systemctl disable --now "$1" || return 1; }
__service_start() { \systemctl restart "$1" || \systemctl start "$1" || return 1; }
__service_running() { \systemctl is-active $1 2>&1 | grep -qiw 'active' || return 1; }
__service_exists() { \systemctl list-unit-files 2>&1 | awk '{print $1}' | grep -q "^$1\." && return 0 || return 1; }
__service_active() { (\systemctl is-enabled "$1" || \systemctl is-active "$1") | grep -qiE 'enabled|active' || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
__get_user_name() { grep ':' /etc/passwd | awk -F ':' '{print $1}' | sort -u | grep "^${1:-root}$" || return 1; }
__get_user_group() { grep ':' /etc/group | awk -F ':' '{print $1}' | sort -u | grep "^${1:-root}$" || return 1; }
__chuser() { local user=$1 && shift && grep -qs "^$user:" /etc/passwd && chown -Rf "$user" "$@" 2>/dev/null; }
__chgroup() { local group=$1 && shift && grep -qs "$^group:" /etc/group && chgrp -Rf "$group" "$@" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
sed="$(builtin type -P gsed 2>/dev/null || builtin type -P sed 2>/dev/null || return)"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help --version
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Verify repository exists
verify_url "$REPO"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# OS Support: supported_os unsupported_oses
supported_os linux mac windows
unsupported_oses
# - - - - - - - - - - - - - - - - - - - - - - - - -
# get sudo credentials
sudorun "true"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Requires root - restarting with sudo
sudoreq "$0 $*"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure the scripts repo is installed
scripts_check
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
systemmgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - -
# trap the cleanup function
trap_exit
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Initialize the installer
systemmgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Do not update
#installer_noupdate "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults
APPVERSION="$(__appversion "https://github.com/$SCRIPTS_PREFIX/$APPNAME/raw/$REPO_BRANCH/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define these if build script is used
BUILD_NAME="GEN_SCRIPT_REPLACE_APPNAME"
BUILD_SCRIPT_REBUILD="false"
BUILD_SRC_URL=""
BUILD_SCRIPT_SRC_DIR="$PLUGIN_DIR/source"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup plugins
PLUGIN_REPOS=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Grab release from github releases
LATEST_RELEASE=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Specify global packages
GLOBAL_OS_PACKAGES="GEN_SCRIPT_REPLACE_APPNAME "
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define MacOS only packages
MAC_OS_PACKAGES=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define Windows only packages
WIN_OS_PACKAGES=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define linux only packages
LINUX_OS_PACKAGES=""
# Define archLinux specific packages
ARCH_OS_PACKAGES=""
# Define redhat specific packages
CENTOS_OS_PACKAGES=""
# Define debian specific packages
DEBIAN_OS_PACKAGES=""
# Define ubuntu specific packages
UBUNTU_OS_PACKAGES=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Specify ARCH_USER_REPO Pacakges
AUR_PACKAGES=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define required system python packages
PYTHON_PACKAGES=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define required system perl packages
PERL_PACKAGES=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# define additional packages - tries to install via tha package managers
NODEJS=""
PERL_CPAN=""
RUBY_GEMS=""
PYTHON_PIP=""
PHP_COMPOSER=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Run custom actions

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Show a custom message after install
__run_post_message() {
  true
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define pre-install scripts
__run_pre_install() {
  local getRunStatus=0

  return $getRunStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# run before primary post install function
__run_prepost_install() {
  local getRunStatus=0

  return $getRunStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# run after primary post install function
__run_post_install() {
  local getRunStatus=0

  return $getRunStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Custom plugin function
__custom_plugin() {
  local getRunStatus=0
  # execute "__run_git_clone_pull repo dir" "Installing plugName"
  return $getRunStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# execute build script if exists and install failed or set BUILD_SCRIPT_REBUILD to true to always rebuild
__run_build_script() {
  local getRunStatus=0
  if ! __cmd_exists "$BUILD_NAME" && [ -f "$INSTDIR/build.sh" ]; then
    export BUILD_NAME BUILD_SCRIPT_SRC_DIR BUILD_SRC_URL BUILD_SCRIPT_REBUILD
    [ -x "$INSTDIR/build.sh" ] || chmod 755 "$INSTDIR/build.sh"
    eval "$INSTDIR/build.sh"
  fi
  return $getRunStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Other dependencies
dotfilesreq misc
dotfilesreqadmin cron
# - - - - - - - - - - - - - - - - - - - - - - - - -
# END OF CONFIGURATION
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a version higher than
systemmgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Run pre-install commands
execute "__run_pre_install" "Running pre-installation commands"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# define arch user repo packages
if_os_id arch && ARCH_USER_REPO="$AUR_PACKAGES"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# define linux packages
if if_os linux; then
  if if_os_id arch; then
    SYSTEM_PACKAGES="$GLOBAL_OS_PACKAGES $LINUX_OS_PACKAGES $ARCH_OS_PACKAGES"
  elif if_os_id centos; then
    SYSTEM_PACKAGES="$GLOBAL_OS_PACKAGES $LINUX_OS_PACKAGES $CENTOS_OS_PACKAGES"
  elif if_os_id debian; then
    SYSTEM_PACKAGES="$GLOBAL_OS_PACKAGES $LINUX_OS_PACKAGES $DEBIAN_OS_PACKAGES"
  elif if_os_id ubuntu; then
    SYSTEM_PACKAGES="$GLOBAL_OS_PACKAGES $LINUX_OS_PACKAGES $UBUNTU_OS_PACKAGES"
  else
    SYSTEM_PACKAGES="$GLOBAL_OS_PACKAGES $LINUX_OS_PACKAGES"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define MacOS packages - homebrew
if if_os mac; then
  SYSTEM_PACKAGES="$GLOBAL_OS_PACKAGES $MAC_OS_PACKAGES"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Define Windows packages - choco
if if_os win; then
  SYSTEM_PACKAGES="$GLOBAL_OS_PACKAGES $WIN_OS_PACKAGES"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Attempt install from github release
install_latest_release "$LATEST_RELEASE"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# install required packages using the aur - Requires yay to be installed
install_aur "${ARCH_USER_REPO//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# install packages - useful for package that have the same name on all oses
install_packages "${SYSTEM_PACKAGES//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# install required packages using file from pkmgr repo
install_required "$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check for perl modules and install using system package manager
install_perl "${PERL_PACKAGES//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check for python modules and install using system package manager
install_python "${PYTHON_PACKAGES//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check for pip binaries and install using python package manager
install_pip "${PYTHON_PIP//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check for cpan binaries and install using perl package manager
install_cpan "${PERL_CPAN//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check for ruby binaries and install using ruby package manager
install_gem "${RUBY_GEMS//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check for npm binaries and install using npm/yarn package manager
install_npm "${NODEJS//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check for php binaries and install using php composer
install_php "${PHP_COMPOSER//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure directories exist
ensure_dirs
ensure_perms
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Backup if needed
[ -d "$APPDIR" ] && execute "backupapp $APPDIR $APPNAME" "Backing up $APPDIR"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Get configuration files
instCode=0
if __am_i_online; then
  if [ -d "$INSTDIR/.git" ]; then
    execute "__run_git_clone_pull $INSTDIR" "Updating $APPNAME configurations"
    instCode=$?
  else
    execute "__run_git_clone_pull $REPO $INSTDIR" "Installing $APPNAME configurations"
    instCode=$?
  fi
  # exit on fail
  __failexitcode $instCode "Failed to setup the git repo from $REPO"
fi
unset instCode
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Install Plugins
exitCodeP=0
exitCodeC=0
if __am_i_online; then
  if [ "$PLUGIN_REPOS" != "" ]; then
    [ -d "$PLUGIN_DIR" ] || mkdir -p "$PLUGIN_DIR"
    for plugin in $PLUGIN_REPOS; do
      plugin_name="$(basename -- "$plugin")"
      plugin_dir="$PLUGIN_DIR/$plugin_name"
      if [ -d "$plugin_dir/.git" ]; then
        execute "git_update $plugin_dir" "Updating plugin $plugin_name"
        exitCodeC=$?
        [ $exitCodeC -ne 0 ] && exitCodeP=$((exitCodeC + exitCodeP)) && printf_red "Failed to update $plugin_name"
      else
        execute "git_clone $plugin $plugin_dir" "Installing plugin $plugin_name"
        exitCodeC=$?
        [ $exitCodeC -ne 0 ] && exitCodeP=$(($exitCodeC + exitCodeP)) && printf_red "Failed to install $plugin_name"
      fi
    done
  fi
  __custom_plugin
  exitCodeP=$(($? + exitCodeP))
  # exit on fail
  __failexitcode $exitCodeP "Installation of plugin failed"
fi
unset exitCodeP
# - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
run_postinst() {
  local exitCodeP=0
  __run_prepost_install || exitCodeP=$((exitCodeP + 1))
  systemmgr_run_post || exitCodeP=$((exitCodeP + 1))
  __run_post_install || exitCodeP=$((exitCodeP + 1))
  return $exitCodeP
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
execute "run_postinst" "Running post install scripts"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# run any external scripts
__run_build_script
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Output post install message
__run_post_message
# - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
systemmgr_install_version
# - - - - - - - - - - - - - - - - - - - - - - - - -
# run exit function
run_exit
# - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${EXIT:-${exitCode:-0}}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
