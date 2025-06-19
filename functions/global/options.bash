#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071029-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  options.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 10:29 EDT
# @File              :  options.bash
# @Description       :  functions based on getopts
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__list_available() {
  echo "${*:-$ARRAY}" | __sed 's|,--| --|g;s|,-| -|g;s|,| |g;s|:||g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__list_array() {
  local OPTSDIR="${1:-$HOME/.local/share/myscripts/${APPNAME:-$PROG}/options}"
  mkdir -p "$OPTSDIR"
  echo "${2:-$ARRAY}" | tr ',' '\n' >"$OPTSDIR/array"
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__list_options() {
  printf_color "$1: " "$5"
  echo -ne "$2" | sed 's|:||g;s/'$3'/ '$4'/g' | tr '\n' ' '
  printf_newline
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### Set options ######################
__full_app_info() {
  printf_info "APPNAME:                   $APPNAME"
  printf_info "App Dir:                   ${APPDIR:-$INSTDIR}"
  printf_info "Install Dir:               $INSTDIR"
  printf_info "APP config dir             $HOME/.config/myscripts/$APPNAME"
  printf_info "UserHomeDir:               $HOME"
  printf_info "UserBinDir:                $BIN"
  printf_info "UserConfDir:               $CONF"
  printf_info "UserShareDir:              $SHARE"
  printf_info "UserLogDir:                $LOGDIR"
  printf_info "UserStartDir:              $STARTUP"
  printf_info "SysConfDir:                $SYSCONF"
  printf_info "SysBinDir:                 $SYSBIN"
  printf_info "SysConfDir:                $SYSCONF"
  printf_info "SysShareDir:               $SYSSHARE"
  printf_info "SysLogDir:                 $SYSLOGDIR"
  printf_info "SysBackUpDir:              $BACKUPDIR"
  printf_info "ApplicationsDir:           $SHARE/applications"
  printf_info "IconDir:                   $ICONDIR"
  printf_info "ThemeDir                   $THEMEDIR"
  printf_info "FontDir:                   $FONTDIR"
  printf_info "FontConfDir:               $FONTCONF"
  printf_info "CompletionsDir:            $COMPDIR"
  printf_info "CasjaysDevDir:             $CASJAYSDEVSHARE"
  printf_info "CASJAYSDEVSAPPDIR:         $CASJAYSDEVSAPPDIR"
  printf_info "USRUPDATEDIR:              $USRUPDATEDIR"
  printf_info "SYSUPDATEDIR:              $SYSUPDATEDIR"
  printf_info "DOTFILESREPO:              $DOTFILESREPO"
  printf_info "DevEnv Repo:               $DEVENVMGRREPO"
  printf_info "Package Manager Repo:      $PKMGRREPO"
  printf_info "Icon Manager Repo:         $ICONMGRREPO"
  printf_info "Font Manager Repo:         $FONTMGRREPO"
  printf_info "Theme Manager Repo         $THEMEMGRREPO"
  printf_info "System Manager Repo:       $SYSTEMMGRREPO"
  printf_info "Wallpaper Manager Repo:    $WALLPAPERMGRREPO"
  printf_info "InstallType:               $installtype"
  printf_info "Prefix:                    $SCRIPTS_PREFIX"
  printf_info "SystemD dir:               $SYSTEMDDIR"
  printf_info "FunctionsDir:              $SCRIPTSFUNCTDIR"
  printf_info "FunctionsFile              $SCRIPTSFUNCTFILE"
  exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### call options ######################
__options() {
  $installtype
  local SHORTOPTS=""
  local LONGOPTS="full-info,raw"
  setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "options.sh" -- "$@" 2>/dev/null)
  eval set -- "${setopts[@]}" 2>/dev/null
  while :; do
    case "$1" in
    ###################### debug settings ######################
    --full-info)
      shift 1
      __full_app_info
      ;;

    --raw)
      shift 1
      export SHOW_RAW="true"
      unset -f printf_color
      printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[[0-9;]*[a-zA-Z],,g'; }
      ;;

    --)
      shift 1
      break
      ;;
    *)
      break
      ;;
    esac
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
