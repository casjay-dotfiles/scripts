###################### iconmgr settings ######################
iconmgr_install() {
  system_install
  SCRIPTS_PREFIX="iconmgr"
  APPDIR="${APPDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$ICONMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  __mkd "$ICONDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="iconmgr_install"
}
