###################### desktopmgr settings ######################
desktopmgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="desktopmgr"
  APPDIR="${APPDIR:-$CONF}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-$DESKTOPMGRREPO}"
  REPORAW="${REPORAW:-$DESKTOPMGRREPO/$APPNAME/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(grep -s '^' $CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  #[ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -sv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="desktopmgr_install"
  #__main_installer_info
}
