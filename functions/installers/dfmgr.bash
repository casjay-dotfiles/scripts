###################### dfmgr settings ######################
dfmgr_install() {
  user_install
  SCRIPTS_PREFIX="dfmgr"
  APPDIR="${APPDIR:-$CONF}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$DFMGRREPO}"
  REPORAW="${REPORAW:-$DFMGRREPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  #[ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="dfmgr_install"
  #__main_installer_info
}
