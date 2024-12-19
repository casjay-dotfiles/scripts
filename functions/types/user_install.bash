#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071339-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  user_install.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 13:39 EDT
# @File              :  user_install.bash
# @Description       :  Functions for user install
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
user_install() {
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    INSTALL_TYPE=user
    if [[ $(uname -s) =~ Darwin ]]; then
      HOME="/usr/local/home/root"
    fi
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="/usr/local/bin"
    SYSCONF="/usr/local/etc"
    SYSSHARE="/usr/local/share"
    SYSLOGDIR="/usr/local/log"
    BACKUPDIR="$HOME/.local/backups"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$SHARE/themes"
    ICONDIR="$SHARE/icons"
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="/Library/Fonts"; else FONTDIR="$SHARE/fonts"; fi
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="${WALLPAPERS:-$SYSSHARE/wallpapers}"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSTEMDDIR="/etc/systemd/system"
  else
    INSTALL_TYPE=user
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="$HOME/.local/bin"
    SYSCONF="$HOME/.config"
    SYSSHARE="$HOME/.local/share"
    SYSLOGDIR="$HOME/.local/log"
    BACKUPDIR="$HOME/.local/backups"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$SHARE/themes"
    ICONDIR="$SHARE/icons"
    if [[ $(uname -s) =~ Darwin ]]; then
      FONTDIR="$HOME/Library/Fonts"
    else
      FONTDIR="$SHARE/fonts"
    fi
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSTEMDDIR="$HOME/.config/systemd/user"
  fi

  APPDIR="${APPDIR:-$SHARE/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-}"
  REPORAW="${REPORAW:-}"

  installtype="user_install"
}
