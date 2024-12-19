###################### systemmgr settings ######################
systemmgr_install() {
  system_install
  SCRIPTS_PREFIX="systemmgr"
  APPDIR="${APPDIR:-/usr/local/etc}"
  INSTDIR="${INSTDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  CONF="/usr/local/etc"
  SHARE="/usr/local/share"
  REPO="${REPO:-$SYSTEMMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME")"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="systemmgr_install"
}
