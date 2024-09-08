###################### hakmgr settings ######################
hakmgr_install() {
  user_install
  SCRIPTS_PREFIX="hakmgr"
  APPDIR="${APPDIR:-$CONF}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$HAKMGRREPO}"
  REPORAW="${REPORAW:-$HAKMGRREPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
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
  installtype="hakmgr_install"
  #__main_installer_info
}
