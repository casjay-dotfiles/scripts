#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071123-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  crontab.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 11:23 EDT
# @File              :  crontab.bash
# @Description       :  crontab functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__removecrontab() {
  command="$(echo "$*" | sed 's#>/dev/null 2>&1##g')"
  crontab -l | grep -v "${command}" | crontab -
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__setupcrontab() {
  [ "$1" = "--help" ] && printf_help "setupcrontab "0 0 1 * *" "echo hello""
  local frequency="$1"
  local command="sleep $(expr $RANDOM \% 300) && $2"
  local job="$frequency $command"
  if cat <(grep -Fivq "$2" <(crontab -l)); then
    cat <(grep -Fiv "$2" <(crontab -l)) <(echo "$job") | crontab - >/dev/null 2>&1
  fi
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__addtocrontab() {
  [ "$1" = "--help" ] && printf_help "addtocrontab "0 0 1 * *" "echo hello""
  local frequency="$1"
  local command="__am_i_online && sleep $(expr $RANDOM \% 300) && $2"
  local job="$frequency $command"
  cat <(grep -F -i -v "$2" <(crontab -l)) <(echo "$job") | crontab - >/dev/null 2>&1
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cron_updater() {
  [ "$*" = "--help" ] && shift 1 && printf_help "Usage: ${PROG:-$APPNAME} updater $APPNAME"
  if user_is_root; then
    if [ -z "$1" ] && [ -d "$SYSUPDATEDIR" ] && ls "$SYSUPDATEDIR"/* 1>/dev/null 2>&1; then
      for upd in $(ls $SYSUPDATEDIR/); do
        file="$(ls -A $SYSUPDATEDIR/$upd 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename "$file")"
          sudo file="$file" bash -c "$file --cron $*"
        fi
      done
    else
      if [ -d "$SYSUPDATEDIR" ] && ls "$SYSUPDATEDIR"/* 1>/dev/null 2>&1; then
        file="$(ls -A $SYSUPDATEDIR/$1 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename "$file")"
          sudo file="$file" bash -c "$file --cron $*"
        fi
      fi
    fi
  else
    if [ -z "$1" ] && [ -d "$USRUPDATEDIR" ] && ls "$USRUPDATEDIR"/* 1>/dev/null 2>&1; then
      for upd in $(ls $USRUPDATEDIR/); do
        export file="$(ls -A $USRUPDATEDIR/$upd 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename "$file")"
          bash -c "$file --cron $*"
        fi
      done
    else
      if [ -d "$USRUPDATEDIR" ] && ls "$USRUPDATEDIR"/* 1>/dev/null 2>&1; then
        export file="$(ls -A $USRUPDATEDIR/$1 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(__basename "$file")"
          bash -c "$file --cron $*"
        fi
      fi
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
