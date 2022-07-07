# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071459-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.com
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
source "$CASJAYSDEVDIR/functions/types/mgr_install.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__main_installer_info() {
  if [ "$APPNAME" = "scripts" ] || [ "$APPNAME" = "installer" ]; then
    PLUGDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
get_installer_version() {
  $installtype
  local GITREPO=""$REPO/$APPNAME""
  local APPVERSION="${APPVERSION:-$(__appversion ${1:-})}"
  [ -n "$WHOAMI" ] && printf_info "WhoamI:                    $WHOAMI"
  [ -n "$RUN_USER" ] && printf_info "SUDO USER:                 $RUN_USER"
  [ -n "$INSTALL_TYPE" ] && printf_info "Install Type:              $INSTALL_TYPE"
  [ -n "$APPNAME" ] && printf_info "APP name:                  $APPNAME"
  [ -n "$APPDIR" ] && printf_info "APP dir:                   $APPDIR"
  [ -n "$INSTDIR" ] && printf_info "Downloaded to:             $INSTDIR"
  [ -n "$GITREPO" ] && printf_info "APP repo:                  $REPO/$APPNAME"
  [ -n "$PLUGNAMES" ] && printf_info "Plugins:                   $PLUGNAMES"
  [ -n "$PLUGDIR" ] && printf_info "PluginsDir:                $PLUGDIR"
  [ -n "$version" ] && printf_info "Installed Version:         $version"
  [ -n "$APPVERSION" ] && printf_info "Online Version:            $APPVERSION"
  if [ "$version" = "$APPVERSION" ]; then
    printf_info "Update Available:          No"
  else
    printf_info "Update Available:          Yes"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sed_remove_empty() {
  local sed="${sed:-sed}"
  $sed '/^\#/d;/^$/d;s#^ ##g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sed_head_remove() {
  awk -F'  :' '{print $2}'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sed_head() {
  local sed="${sed:-sed}"
  $sed -E 's|^.*#||g;s#^ ##g;s|^@||g'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grep_head() {
  grep -sE '[".#]?@[A-Z]' "${2:-$appname}" |
    grep "${1:-}" |
    head -n 12 |
    sed_head |
    sed_remove_empty |
    grep '^' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grep_head_remove() {
  local sed="${sed:-sed}"
  grep -sE '[".#]?@[A-Z]' "${2:-$appname}" |
    grep "${1:-}" | grep -Ev 'GEN_SCRIPT_*|\${|\$\(' |
    sed_head_remove |
    $sed '/^\#/d;/^$/d;s#^ ##g' |
    grep '^' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grep_version() {
  grep_head ''${1:-Version}'' "${2:-$appname}" |
    sed_head |
    sed_head_remove |
    sed_remove_empty |
    head -n1 |
    grep '^'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# grep_head() {
#   grep -v "$1" "$2" 2>/dev/null | grep '       : ' |
#     grep -v '\$' |
#     grep -E ^'.*#.@'${1:-*}'' |
#     sed -E 's/..*#[#, ]@//g' |
#     sed -E 's/.*#[#, ]@//g' |
#     head -n14 |
#     grep '^' || return 1
# }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
get_desc() {
  local PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin"
  local appname="$(type -P "${PROG:-$APPNAME}" 2>/dev/null || builtin type -p "${PROG:-$APPNAME}" 2>/dev/null)"
  local desc="$(grep_head_remove "Description" "$appname" | head -n1)"
  [ -n "$desc" ] && printf '%s' "$desc" || printf '%s' "$(__basename $appname) --help"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__help() {
  if [ -f "$CASJAYSDEVDIR/helpers/man/$APPNAME" ] && [ -s "$CASJAYSDEVDIR/helpers/man/$APPNAME" ]; then
    source "$CASJAYSDEVDIR/helpers/man/$APPNAME"
  else
    printf_help "There is no man page for this app in: "
    printf_help "$CASJAYSDEVDIR/helpers/man/$APPNAME"
  fi
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__version() {
  local name="${1:-$(__basename $0)}"          # get from os
  local prog="${APPNAME:-$PROG}"               # get from file
  local appname="${prog:-$name}"               # figure out wich one
  filename="$(type -P "$appname" 2>/dev/null)" # get filename
  if [ -f "$filename" ]; then                  # check for file
    printf_newline
    printf_green "Getting info for $appname"
    [ -n "$WHOAMI" ] && printf_yellow "WhoamI            :  $WHOAMI"
    [ -n "$RUN_USER" ] && printf_yellow "SUDO USER:        :  $RUN_USER"
    grep_head "Description" "$filename" &>/dev/null &&
      grep_head '' "$filename" | printf_readline "3" &&
      printf_green "$(grep_head "Version" "$filename" | head -n1)" &&
      printf_blue "Required ver      :  $requiredVersion" ||
      printf_red "File was found, however, No information was provided"
  else
    printf_red "${1:-$appname} was not found"
  fi
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__remove_app() {
  local exitCode=0
  local ARRAY="$*"
  for app in $ARRAY; do
    installer_delete "$*" || exitCode+=1
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
      local exitCode+=$?
    else
      if __urlcheck "$REPORAW/install.sh"; then
        FORCE_INSTALL="$FORCE_INSTALL" bash -c "$(curl -q -LSs "$REPORAW/install.sh" 2>/dev/null)"
      else
        printf_error "Failed to initialize the installer from:"
        printf_exit "$REPORAW/install.sh\n"
      fi
      local exitCode+=$?
    fi
    unset APPNAME REPO REPORAW
  done
  unset app
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_install_update() {
  local app=""
  local APPNAME=""
  local exitCode=0
  local mgr_init="${mgr_init:-true}"
  local NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME}"
  local NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON}"
  export mgr_init NOTIFY_CLIENT_NAME NOTIFY_CLIENT_ICON
  if [ $# = 0 ]; then
    if [[ -d "$USRUPDATEDIR" && -n "$(ls -A "$USRUPDATEDIR" | grep '^' || ls "$SHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^')" ]]; then
      for app in $(ls "$USRUPDATEDIR" | grep '^' || ls "$SHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^'); do
        APPNAME="$app"
        run_install_init "$app" && __notifications "Installed $app" || __notifications "Installation of $app has failed"
        local exitCode+=$?
      done
    fi
    if user_is_root && [ "$USRUPDATEDIR" != "$SYSUPDATEDIR" ]; then
      if [[ -d "$SYSUPDATEDIR" && -n "$(ls -A "$SYSUPDATEDIR" | grep '^' || ls "$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^')" ]]; then
        for app in $(ls "$SYSUPDATEDIR" | grep '^' || ls "$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX" | grep '^'); do
          APPNAME="$app"
          run_install_init "$app" && __notifications "Installed $app" || __notifications "Installation of $app has failed"
          local exitCode+=$?
        done
      fi
    fi
  else
    local LISTARRAY="$*"
    for app in $LISTARRAY; do
      APPNAME="$app"
      run_install_init "$app" && __notifications "Installed $app" || __notifications "Installation of $app has failed"
      local exitCode+=$?
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
      local exitCode+=$?
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
          installed+="$(echo "$app" | sed 's| ||g' | grep -sv "^$") "
        done
        printf '%s\n' "$installed" | printf_column "4"
      fi
    elif [ "$(__count_dir "$SYSUPDATEDIR")" != 0 ]; then
      declare -a LSINST="$(ls "$SYSUPDATEDIR/")"
      if [ -n "${LSINST[0]}" ]; then
        for app in "${LSINST[@]}"; do
          installed+="$(echo "$app" | sed 's| ||g' | grep -sv "^$") "
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
  local -a LSINST="$*"
  local results=""
  for app in ${LSINST[*]}; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    local -a result+="$(echo -e "$LIST" | tr ' ' '\n' | grep -Fi "$app" | grep -sv '^$') "
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
    __list_available ${*:-} | printf_column "${PRINTF_COLOR:-4}"
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
      exitCode+=1
      return 1
    fi
  done
  unset args app
  [ "$exitCode" = 0 ] && scripts_version || exit 1
}

installer_delete() {
  local app=""
  local exitCode=0
  local LISTARRAY="$*"
  for app in $LISTARRAY; do
    export APPNAME="$app" REPO="$REPO/$APPNAME" REPORAW="$REPO/raw/$GIT_REPO_BRANCH"
    local MESSAGE="${MESSAGE:-Removing $app from ${msg:-your system}}"
    if [ -d "$APPDIR/$app" ] || [ -d "$INSTDIR/$app" ]; then
      printf_yellow "$MESSAGE"
      printf_blue "Deleting the files"
      [ -d "$INSTDIR/$app" ] && __rm_rf "$INSTDIR/$app" || exitCode+=1
      __rm_rf "$APPDIR/$app" "$INSTDIR/$app" || exitCode+=1
      __rm_rf "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$app" || exitCode+=1
      __rm_rf "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$app" || exitCode+=1
      printf_yellow "Removing any broken symlinks"
      __broken_symlinks "$BIN" "$SHARE" "$COMPDIR" "$CONF" "$THEMEDIR" "$FONTDIR" "$ICONDIR" || exitCode+=1
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
