#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070946-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  pkgs.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:46 EDT
# @File              :  pkgs.bash
# @Description       :  required packages functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#npm_exists "npmpackage"
__npm_exists() {
  builtin type -P npm &>/dev/null || printf_return "NPM is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo npm" && shift 1 || local cmdbin="npm"
  local package="$1"
  if $cmdbin list -g 2>&1 | grep -q "$package" &>/dev/null; then
    return 0
  elif $cmdbin list 2>&1 | grep -q "$package" &>/dev/null; then
    return 0
  else return 1; fi
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#perl_exists "perlpackage"
__perl_exists() {
  builtin type -P perl &>/dev/null || printf_return "Perl is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo perl" && shift 1 || local cmdbin="perl"
  local package="$1"
  if $cmdbin -M$package -le 'print $INC{"$package/Version.pm"}' &>/dev/null; then return 0; else return 1; fi
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#python_exists "pythonpackage"
__python_exists() {
  local pythonver=""
  if builtin type -P python3 &>/dev/null; then
    pythonver="python3"
  elif builtin type -P python2 &>/dev/null; then
    pythonver="python2"
  elif builtin type -P python &>/dev/null; then
    pythonver="python"
  else
    printf_return "Python is not installed"
    return 1
  fi
  [ "$1" = "--sudo" ] && local cmdbin="sudo $pythonver" && shift 1 || local cmdbin="$pythonver"
  local package="$1"
  if $cmdbin -c "import importlib.util; exit(0 if importlib.util.find_spec('$package') else 1)" 2>/dev/null; then return 0; else return 1; fi
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#gem_exists "gemname"
__gem_exists() {
  builtin type -P gem &>/dev/null || printf_return "Ruby Gem is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo gem" && shift 1 || local cmdbin="gem"
  local package="$1"
  if $cmdbin list 2>&1 | grep -wq "$package"; then
    return 0
  else
    return 1
  fi
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#lua_exists "luaname"
__lua_exists() {
  builtin type -P luarocks &>/dev/null || printf_return "luarocks is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo luarocks" && shift 1 || local cmdbin="luarocks"
  local package="$1"
  if $cmdbin list 2>&1 | grep -wq "$package"; then
    return 0
  else
    return 1
  fi
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#go_exists "gopackage"
__go_exists() {
  builtin type -P go &>/dev/null || printf_return "go is not installed"
  [ "$1" = "--sudo" ] && local cmdbin="sudo go" && shift 1 || local cmdbin="go"
  local package="$1"
  if $cmdbin list -m 2>&1 | grep -wq "$package"; then
    return 0
  else
    return 1
  fi
  set --
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#check_pip "pipname"
__check_pip() {
  local ARGS="$*"
  local MISSING=""
  for cmd in $ARGS; do builtin type -P "$cmd" &>/dev/null || MISSING+="$cmd "; done
  if [ -n "$MISSING" ]; then
    printf_read_question "2" "$1 is not installed Would you like install it? [y/N]" "1" "choice"
    if printf_answer_yes "$choice"; then
      for miss in $MISSING; do
        __execute "pkmgr pip $miss" "Installing $miss"
      done
    fi
  else
    return $?
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#check_cpan "cpanname"
__check_cpan() {
  local MISSING=""
  for cmd in "$@"; do builtin type -P "$cmd" &>/dev/null || MISSING+="$cmd "; done
  if [ -n "$MISSING" ]; then
    printf_question "2" "$1 is not installed Would you like install it? [y/N]" "1" "choice" "-s"
    if printf_answer_yes "$choice"; then
      for miss in $MISSING; do
        __execute "pkmgr cpan $miss" "Installing $miss"
      done
    fi
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#check_app "app"
__check_app() {
  local cmd=""
  local choice=""
  local MISSING=""
  local ARGS="$*"
  export APP="${APPNAME:-$PROG}"
  export NOTIFY_CLIENT_ICON="software"
  export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$APP}"
  for cmd in $ARGS; do builtin type -P "$cmd" &>/dev/null || MISSING+="$cmd "; done
  if [ -n "$MISSING" ]; then
    notifications "${NOTIFY_CLIENT_NAME:-$APPNAME}" "Missing $MISSING"
    if [ -n "$DESKTOP_SESSION" ]; then
      __ask_confirm "Would you like install $MISSING" "pkmgr silent install $MISSING" || return 1
    else
      printf_red "The following apps are missing: $MISSING"
      printf_read_question "2" "Would you like install the missing packages? [y/N]" "1" "choice"
      if printf_answer_yes "$choice"; then
        for miss in $MISSING; do
          __execute "pkmgr silent install $miss" "Installing $miss" || return 1
        done
      else
        return 1
      fi
    fi
  else
    return $?
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__requires() {
  local ARGS="$*"
  for cmd in $ARGS; do
    builtin type -P "$cmd" &>/dev/null || local CMD+="$cmd "
  done
  if [ -n "$CMD" ]; then __require_app "$CMD"; fi
  [ "$?" = 0 ] && return 0 || exit 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__require_app() {
  __check_app "$@" || exit 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
