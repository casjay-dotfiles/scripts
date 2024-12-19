###################### fontmgr settings ######################
fontmgr_install() {
  system_install
  SCRIPTS_PREFIX="fontmgr"
  APPDIR="${APPDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$FONTMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  FONTDIR="${FONTDIR:-$SHARE/fonts}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  __mkd "$FONTDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="fontmgr_install"
}
