#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071339-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  system_install.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 13:39 EDT
# @File              :  system_install.bash
# @Description       :  Functions for user install
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
system_install() {
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  if [[ $(uname -s) =~ Darwin ]]; then
    HOME="/usr/local/home/root"
  fi
  BACKUPDIR="$HOME/.local/backups"
  BIN="/usr/local/bin"
  CONF="/usr/local/etc"
  SHARE="/usr/local/share"
  LOGDIR="/usr/local/log"
  STARTUP="/dev/null"
  SYSBIN="/usr/local/bin"
  SYSCONF="/usr/local/etc"
  SYSSHARE="/usr/local/share"
  SYSLOGDIR="/usr/local/log"
  COMPDIR="/etc/bash_completion.d"
  THEMEDIR="/usr/local/share/themes"
  ICONDIR="/usr/local/share/icons"
  if [[ $(uname -s) =~ Darwin ]]; then
    FONTDIR="/Library/Fonts"
  else
    FONTDIR="/usr/local/share/fonts"
  fi
  FONTCONF="/usr/local/share/fontconfig/conf.d"
  CASJAYSDEVSHARE="/usr/local/share/CasjaysDev"
  CASJAYSDEVSAPPDIR="/usr/local/share/CasjaysDev/apps"
  WALLPAPERS="/usr/local/share/wallpapers"
  USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  SYSTEMDDIR="/etc/systemd/system"

  APPDIR="${APPDIR:-$SHARE/$SCRIPTS_PREFIX}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX}"
  REPO="${REPO:-}"
  REPORAW="${REPORAW:-}"

  installtype="system_install"
}
