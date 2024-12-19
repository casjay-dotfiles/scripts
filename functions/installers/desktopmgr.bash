###################### desktopmgr settings ######################
desktopmgr_install() {
  user_install
  SCRIPTS_PREFIX="desktopmgr"
  APPDIR="${DESKTOPMGR_APPDIR:-$CONF/$APPNAME}"
  INSTDIR="${DESKTOPMGR_INSTDIR:-$CASJAYSDEVSHARE/desktopmgr/$APPNAME}"
  REPO_BRANCH="${GIT_REPO_BRANCH:-main}"
  REPO="${DESKTOPMGRREPO:-https://github.com/desktopmgr}/$APPNAME"
  REPORAW="${DESKTOPMGR_REPORAW:-$DESKTOPMGR/raw/$REPO_BRANCH}"
  APPVERSION="${DESKTOPMGR_APPVERSION:-$(__appversion "$DESKTOPMGR_REPORAW/version.txt")}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  #[ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$USRUPDATEDIR"
  installtype="desktopmgr_install"
  #__main_installer_info
}
