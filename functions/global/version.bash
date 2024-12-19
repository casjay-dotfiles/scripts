#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070943-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  version.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:43 EDT
# @File              :  version.bash
# @Description       :  version functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Versioning Info - __required_version "VersionNumber"
localVersion="${localVersion:-202108121011-git}"
requiredVersion="${requiredVersion:-202108121011-git}"
if [ -f "$CASJAYSDEVDIR/version.txt" ]; then
  currentVersion="${currentVersion:-$(<"$CASJAYSDEVDIR/version.txt")}"
else
  currentVersion="${currentVersion:-$localVersion}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get version
scripts_version() {
  local version="$(cat ${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/version.txt)"
  printf_green "scripts version is $version\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__appversion() {
  local versionfile="${1:-$REPORAW/version.txt}"
  if [ -f "$INSTDIR/version.txt" ]; then
    local tmpLocalVersion="$(<$INSTDIR/version.txt)"
  else
    local tmpLocalVersion="$localVersion"
  fi
  localVersion=${tmpLocalVersion//-git/}
  __curl "${versionfile}" 2>/dev/null | head -n1 || echo "$localVersion"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__required_version() {
  [[ -d "$CASJAYSDEV_USERDIR/apps/$SCRIPTS_PREFIX/new_update" ]] &&
    __rm_rf "$CASJAYSDEV_USERDIR/apps/$SCRIPTS_PREFIX/new_update"
  local requiredVersion="${1:-$requiredVersion}"
  local NEW_DIR="$CASJAYSDEV_USERDIR/apps/$SCRIPTS_PREFIX/$new_update"
  [ -d "$NEW_DIR" ] || mkdir -p "$NEW_DIR" &>/dev/null
  if [ -f "$CASJAYSDEVDIR/version.txt" ]; then
    local currentVersion="${APPVERSION:-$currentVersion}"
    local rVersion="${requiredVersion//-git/}"
    local cVersion="${currentVersion//-git/}"
    [ -f "$NEW_DIR/$APPNAME" ] && local NEW_VER="$(<"$NEW_DIR/$APPNAME")"
    [ "$NEW_VER" = "$requiredVersion" ] && return
    if [ "$cVersion" -lt "$rVersion" ] && [ "$APPNAME" != "scripts" ] && [ "$SCRIPTS_PREFIX" != "systemmgr" ]; then
      printf_yellow "Requires version higher than $rVersion"
      printf_yellow "You will need to update for new features"
      echo "$requiredVersion" >"$NEW_DIR/$APPNAME"
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
get_installer_version() {
  $installtype
  local GITREPO=""$REPO/$APPNAME""
  local APPVERSION="${APPVERSION:-$(__appversion ${1:-})}"
  [ -n "$WHOAMI" ] && printf_info "WhoamI:                    $WHOAMI"
  [ -n "$RUN_USER" ] && printf_info "SUDO USER:                 $RUN_USER"
  [ -n "$INSTALL_TYPE" ] && printf_info "Install Type:              $INSTALL_TYPE"
  [ -n "$APPNAME" ] && printf_info "APP name:                  $APPNAME"
  [ -n "$APPDIR" ] && printf_info "APP dir:                   $APPDIR"
  [ -n "$INSTDIR" ] && printf_info "Downloaded to:             $INSTDIR"
  [ -n "$GITREPO" ] && printf_info "APP repo:                  $REPO/$APPNAME"
  [ -n "$PLUGNAMES" ] && printf_info "Plugins:                   $PLUGNAMES"
  [ -n "$PLUGIN_DIR" ] && printf_info "PluginsDir:                $PLUGIN_DIR"
  [ -n "$version" ] && printf_info "Installed Version:         $version"
  [ -n "$APPVERSION" ] && printf_info "Online Version:            $APPVERSION"
  if [ "$version" = "$APPVERSION" ]; then
    printf_info "Update Available:          No"
  else
    printf_info "Update Available:          Yes"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sed_remove_empty() {
  local sed="${sed:-sed}"
  $sed '/^\#/d;/^$/d;s#^ ##g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sed_head_remove() {
  awk -F'  :' '{print $2}'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sed_head() {
  local sed="${sed:-sed}"
  $sed -E 's|^.*#||g;s#^ ##g;s|^@||g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grep_head() {
  grep -shE '[".#]?@[A-Z]' "${2:-$appname}" |
    grep "${1:-}" |
    head -n 12 |
    sed_head |
    sed_remove_empty |
    grep '^' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grep_head_remove() {
  local sed="${sed:-sed}"
  grep -shE '[".#]?@[A-Z]' "${2:-$appname}" |
    grep "${1:-}" | grep -Ev 'GEN_SCRIPT_*|\${|\$\(' |
    sed_head_remove |
    $sed '/^\#/d;/^$/d;s#^ ##g' |
    grep '^' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grep_version() {
  grep_head ''${1:-Version}'' "${2:-$appname}" |
    sed_head |
    sed_head_remove |
    sed_remove_empty |
    head -n1 |
    grep '^'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# grep_head() {
#   grep -v "$1" "$2" 2>/dev/null | grep '       : ' |
#     grep -v '\$' |
#     grep -E ^'.*#.@'${1:-*}'' |
#     sed -E 's/..*#[#, ]@//g' |
#     sed -E 's/.*#[#, ]@//g' |
#     head -n14 |
#     grep '^' || return 1
# }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
get_desc() {
  local PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin"
  local appname="$(builtin type -P "${PROG:-$APPNAME}" 2>/dev/null || builtin type -P "${PROG:-$APPNAME}" 2>/dev/null)"
  local desc="$(grep_head_remove "Description" "$appname" | head -n1)"
  [ -n "$desc" ] && printf '%s' "$desc" || printf '%s' "$(__basename $appname) --help"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__version() { __app_version; } # TODO: to be removed on refactor
__app_version() {
  local name="${1:-$(__basename $0)}"                  # get from os
  local prog="${APPNAME:-$PROG}"                       # get from file
  local appname="${prog:-$name}"                       # figure out wich one
  filename="$(builtin type -P "$appname" 2>/dev/null)" # get filename
  if [ -f "$filename" ]; then                          # check for file
    printf_newline
    printf_green "Getting info for $appname"
    [ -n "$WHOAMI" ] && printf_yellow "WhoamI            :  $WHOAMI"
    [ -n "$RUN_USER" ] && printf_yellow "SUDO USER:        :  $RUN_USER"
    grep_head "Description" "$filename" &>/dev/null &&
      grep_head '' "$filename" | printf_readline "3" &&
      printf_green "$(grep_head "Version" "$filename" | head -n1)" &&
      printf_blue "Required ver      :  $requiredVersion" ||
      printf_red "File was found, however, No information was provided"
  else
    printf_red "${1:-$appname} was not found"
  fi
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__required_version "$requiredVersion"
#[ "$installtype" = "devenvmgr_install" ] &&
devenvmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "dfmgr_install" ] &&
dfmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "desktopmgr_install" ] &&
desktopmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "dockermgr_install" ] &&
dockermgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "fontmgr_install" ] &&
fontmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "iconmgr_install" ] &&
iconmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "pkmgr_install" ] &&
pkmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "systemmgr_install" ] &&
systemmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "thememgr_install" ] &&
thememgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "wallpapermgr_install" ] &&
wallpapermgr_req_version() { __required_version "$1"; }
