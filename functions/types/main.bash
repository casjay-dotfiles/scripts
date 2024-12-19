# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071459-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  main.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 14:59 EDT
# @File              :  main.bash
# @Description       :  Main functions for mgr
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$_DEBUG" = "on" ] && set -x
source "$CASJAYSDEVDIR/functions/types/mgr_install.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__main_installer_info() {
  [ "$_DEBUG" = "on" ] && set -x
  if [ "$APPNAME" = "scripts" ] || [ "$APPNAME" = "installer" ]; then
    PLUGIN_DIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__remove_app() {
  [ "$_DEBUG" = "on" ] && set -x
  local exitCode=0
  local ARRAY="$*"
  for app in $ARRAY; do
    installer_delete "$*"
    exitCode+=$(($? + ${exitCode:1}))
  done
  if [[ $exitCode -ne 0 ]]; then
    exit 1
  else
    exit 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
###################### *mgr scripts install/update/version ######################
export mgr_init="${mgr_init:-true}"
run_install_init() {
  [ "$_DEBUG" = "on" ] && set -x
  $installtype
  local app=""
  local exitCode=""
  local LISTARRAY="$*"
  for app in $LISTARRAY; do
    __main_installer_info
    APPNAME="$app"
    REPO="$REPO/$APPNAME"
    REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    export APPNAME REPO REPORAW
    if user_is_root; then
      export SUDO_USER
      if __urlcheck "$REPORAW/install.sh"; then
        sudo FORCE_INSTALL="$FORCE_INSTALL" bash -c "$(curl -q -LSs "$REPORAW/install.sh" 2>/dev/null)"
      else
        printf_error "Failed to initialize the installer from:"
        printf_exit "$REPORAW/install.sh\n"
      fi
      exitCode+=$(($? + ${exitCode:-0}))
    else
      if __urlcheck "$REPORAW/install.sh"; then
        FORCE_INSTALL="$FORCE_INSTALL" bash -c "$(curl -q -LSs "$REPORAW/install.sh" 2>/dev/null)"
      else
        printf_error "Failed to initialize the installer from:"
        printf_exit "$REPORAW/install.sh\n"
      fi
      exitCode+=$(($? + ${exitCode:-0}))
    fi
    unset APPNAME REPO REPORAW
  done
  unset app
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install_update() {
  [ "$_DEBUG" = "on" ] && set -x
  local app=""
  local APPNAME=""
  local exitCode=""
  local mgr_init="${mgr_init:-true}"
  local NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME}"
  local NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON}"
  export mgr_init NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON
  if [ $# = 0 ]; then
    if [[ -d "$USRUPDATEDIR" && -n "$(ls -A "$USRUPDATEDIR" | grep '^' || ls "$SHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^')" ]]; then
      for app in $(ls "$USRUPDATEDIR" | grep '^' || ls "$SHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^'); do
        APPNAME="$app"
        run_install_init "$app" && __notifications "Installed $app" || __notifications "Installation of $app has failed"
        exitCode+=$(($? + ${exitCode:-0}))
      done
    fi
    if user_is_root && [ "$USRUPDATEDIR" != "$SYSUPDATEDIR" ]; then
      if [[ -d "$SYSUPDATEDIR" && -n "$(ls -A "$SYSUPDATEDIR" | grep '^' || ls "$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^')" ]]; then
        for app in $(ls "$SYSUPDATEDIR" | grep '^' || ls "$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^'); do
          APPNAME="$app"
          run_install_init "$app" && __notifications "Installed $app" || __notifications "Installation of $app has failed"
          exitCode+=$(($? + ${exitCode:-0}))
        done
      fi
    fi
  else
    local LISTARRAY="$*"
    for app in $LISTARRAY; do
      APPNAME="$app"
      run_install_init "$app" && __notifications "Installed $app" || __notifications "Installation of $app has failed"
      exitCode+=$(($? + ${exitCode:-0}))
    done
  fi
  unset app
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install() {
  local app=""
  local APPNAME=""
  local exitCode=0
  local mgr_init="${mgr_init:-true}"
  local NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME}"
  local NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON}"
  export mgr_init NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON
  local LISTARRAY="$*"
  for app in $LISTARRAY; do
    if [[ ! -e "$USRUPDATEDIR/$app" || ! -e "$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$app" ]]; then
      APPNAME="$app"
      run_install_init "$app" && __notifications "Installed $app" || __notifications "Installation of $app has failed"
      exitCode+=$(($? + ${exitCode:-0}))
    fi
  done
  unset app
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install_list() {
  local installed=""
  if [ $# -ne 0 ]; then
    local args="$*"
    for app in $args; do
      export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
      if [ -d "$USRUPDATEDIR" ] && [ -n "$(ls -A "$USRUPDATEDIR/$f" 2>/dev/null)" ]; then
        file="$(ls -A "$USRUPDATEDIR/$f" 2>/dev/null)"
        if [ -f "$file" ]; then
          printf_green "Information about $f:"
          printf_green "$(bash -c "$file --version")"
        fi
      elif [ -d "$SYSUPDATEDIR" ] && [ -n "$(ls -A "$SYSUPDATEDIR/$f" 2>/dev/null)" ] && [ "$USRUPDATEDIR" != "$SYSUPDATEDIR" ]; then
        file="$(ls -A "$SYSUPDATEDIR/$f" 2>/dev/null)"
        if [ -f "$file" ]; then
          printf_green "Information about $f:"
          printf_green "$(bash -c "$file --version")"
        fi
      else
        printf_red "File was not found is it installed?"
      fi
    done
  else
    if [ "$(__count_dir "$USRUPDATEDIR")" != 0 ]; then
      local -a LSINST="$(ls "$USRUPDATEDIR")"
      if [ -n "$LSINST" ]; then
        for app in "${LSINST[@]}"; do
          installed+="$(echo "$app" | sed 's| ||g' | grep -shv "^$") "
        done
        printf '%s\n' "$installed" | printf_column "4"
      fi
    elif [ "$(__count_dir "$SYSUPDATEDIR")" != 0 ]; then
      declare -a LSINST="$(ls "$SYSUPDATEDIR/")"
      if [ -n "${LSINST[0]}" ]; then
        for app in "${LSINST[@]}"; do
          installed+="$(echo "$app" | sed 's| ||g' | grep -shv "^$") "
        done
        printf '%s\n' "$installed" | printf_column "4"
      fi
    else
      printf_red "Nothing was found"
    fi
  fi
  unset args file app
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install_search() {
  [ $# = 0 ] && printf_exit "Nothing to search for"
  [ -n "$LIST" ] || printf_exit "The enviroment variable LIST does not exist"
  local LSINST="$*"
  local results=""
  for app in $LSINST; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    local -a result+="$(echo -e "$LIST" | tr ' ' '\n' | grep -Fi "$app" | grep -shv '^$') "
  done
  results="$(echo "$result" | sort -u | tr '\n' ' ' | sed 's| | |g' | grep '^')"
  if [ -z "$results" ]; then
    printf_exit "Your seach produced no results"
  else
    printf '%s\n' "$results" | printf_column "${PRINTF_COLOR:-4}"
  fi
  unset results app
  exit $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install_available() {
  local app="$APPNAME"
  export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
  if __api_test ${1:-}; then
    __curl_api "$app" | jq -r '.[] | .name' 2>/dev/null | printf_readline "4"
  else
    __list_available "${*:-}" | printf_column "${PRINTF_COLOR:-4}"
  fi
  unset app
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install_version() {
  [ $# = 0 ] && local args="${PROG:-$APPNAME}" || local args="$*"
  local app=""
  local exitCode=0
  for app in $args; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    if [ -d "$USRUPDATEDIR" ] && [ -n "$(ls -A $USRUPDATEDIR/$app 2>/dev/null)" ]; then
      file="$(ls -A $USRUPDATEDIR/$app 2>/dev/null)"
      if [ -f "$file" ]; then
        printf_green "Information about $app: \n$(bash -c "$file --version" | sed '/^\#/d;/^$/d')"
      fi
    elif [ -d "$SYSUPDATEDIR" ] && [ -n "$(ls -A $SYSUPDATEDIR/$app 2>/dev/null)" ] && [ "$SYSUPDATEDIR" != "$USRUPDATEDIR" ]; then
      file="$(ls -A $SYSUPDATEDIR/$app 2>/dev/null)"
      if [ -f "$file" ]; then
        printf_green "Information about $app: \n$(bash -c "$file --version" | sed '/^\#/d;/^$/d')"
      fi
    elif builtin type -P "$app" &>/dev/null; then
      printf_green "$(bash -c "$app --version 2>/dev/null" | sed '/^\#/d;/^$/d')"
    else
      echo $USRUPDATEDIR/$app
      printf_red "File was not found is it installed?"
      exitCode+=$(($? + ${exitCode:1}))
      return 1
    fi
  done
  unset args app
  [ "$exitCode" = 0 ] && scripts_version || exit 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
installer_delete() {
  local app=""
  local exitCode=""
  local LISTARRAY="$*"
  for app in $LISTARRAY; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    local MESSAGE="${MESSAGE:-Removing $app from ${msg:-your system}}"
    if [ -d "$APPDIR/$app" ] || [ -d "$INSTDIR/$app" ]; then
      printf_yellow "$MESSAGE"
      printf_blue "Deleting the files"
      [ -d "$INSTDIR/$app" ] && __rm_rf "$INSTDIR/$app" || exitCode+=$(($? + ${exitCode:-0}))
      __rm_rf "$APPDIR/$app" "$INSTDIR/$app" || exitCode+=$(($? + ${exitCode:-0}))
      __rm_rf "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$app" || exitCode+=$(($? + ${exitCode:-0}))
      __rm_rf "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$app" || exitCode+=$(($? + ${exitCode:-0}))
      printf_yellow "Removing any broken symlinks"
      __broken_symlinks "$BIN" "$SHARE" "$COMPDIR" "$CONF" "$THEMEDIR" "$FONTDIR" "$ICONDIR" || exitCode+=$(($? + ${exitCode:-0}))
      __getexitcode $exitCode "$app has been removed" " "
      return $exitCode
    else
      printf_error "1" "$exitCode" "$app doesn't seem to be installed"
    fi
  done
  unset app
  return ${exitCode}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
