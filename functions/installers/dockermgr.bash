###################### dockermgr settings ######################
dockermgr_install() {
  user_install
  SCRIPTS_PREFIX="dockermgr"
  APPDIR="${APPDIR:-$HOME/.local/share/srv/docker}"
  INSTDIR="${INSTDIR:-$HOME/.local/share/CasjaysDev/dockermgr}"
  DATADIR="${DATADIR:-$HOME/.local/share/srv/docker}"
  REPO="${REPO:-$DOCKERMGRREPO}"
  REPORAW="${REPORAW:-$REPO/raw/$GIT_REPO_BRANCH}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  user_is_root && SYSSHARE="$CASJAYSDEVSAPPDIR/dockermgr/$APPNAME" || SYSSHARE="$HOME/.local/share/CasjaysDev/dockermgr/$APPNAME"
  user_is_root && SRV_DIR="/srv/docker" || SRV_DIR="$HOME/.local/share/srv/docker"
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
