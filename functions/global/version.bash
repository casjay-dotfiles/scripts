#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070943-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.com
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
