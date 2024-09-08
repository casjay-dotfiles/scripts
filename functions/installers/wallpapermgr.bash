###################### wallpapermgr settings ######################
wallpapermgr_install() {
  system_install
  SCRIPTS_PREFIX="wallpapermgr"
  APPDIR="${APPDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$WALLPAPERMGRREPO}"
  REPORAW="${REPORAW:-$WALLPAPERMGRREPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  #[ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$WALLPAPERS"
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  export installtype="wallpapermgr_install"
  #__main_installer_info
}
