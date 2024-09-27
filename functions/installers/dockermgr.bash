###################### dockermgr settings ######################
dockermgr_install() {
  user_install
  SCRIPTS_PREFIX="dockermgr"
  APPDIR="${APPDIR:-/var/lib/srv/$USER/docker}"
  DATADIR="${DATADIR:-/var/lib/srv/$USER/docker}"
  SRV_DIR="${SRV_DIR:-/var/lib/srv/$USER/docker}"
  INSTDIR="${INSTDIR:-$HOME/.local/share/CasjaysDev/dockermgr}"
  REPO="${REPO:-$DOCKERMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$HOME/.local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$CASJAYSDEVSAPPDIR/CasjaysDev/apps/$SCRIPTS_PREFIX"
  user_is_root && SYSSHARE="$SYSUPDATEDIR/$APPNAME" || SYSSHARE="$USRUPDATEDIR/$APPNAME"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(grep -shv '#' $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  __mkd "$SRV_DIR"
  __mkd "$USRUPDATEDIR"
  user_is_root && __mkd "$SYSUPDATEDIR"
  installtype="dockermgr_install"
  #__main_installer_info
}
