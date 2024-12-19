#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071323-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  exit_status.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 13:23 EDT
# @File              :  exit_status.bash
# @Description       :  exit code functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#setexitstatus || setexitstatus $?
__setexitstatus() {
  local EXITCODE=$?
  test -n "$1" && test -z "${1//[0-9]/}" && local EXITCODE="$1" && shift 1
  [ -z "$1" ] || EXIT="$1"
  if [ "$EXITCODE" = 0 ]; then
    NEW_BG_EXIT="${BG_GREEN}"
  else
    NEW_BG_EXIT="${BG_RED}"
  fi
  export NEW_BG_EXIT
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#returnexitcode $?
__returnexitcode() {
  local EXITCODE=$?
  test -n "$1" && test -z "${1//[0-9]/}" && local EXITCODE="$1" && shift 1
  if [ $EXITCODE -eq 0 ]; then
    NEW_BG_EXIT="${BG_GREEN}"
    NEW_PS_SYMBOL=" 😺 [ $EXITCODE] "
    EXIT=0
  elif [ $EXITCODE -gt 1 ]; then
    NEW_BG_EXIT="${BG_RED}"
    NEW_PS_SYMBOL=" ⁉️ [ $EXITCODE] "
  else
    NEW_BG_EXIT="${BG_RED}"
    NEW_PS_SYMBOL=" 😟 [ $EXITCODE] "
  fi
  export NEW_BG_EXIT NEW_PS_SYMBOL
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#getexitcode "$?" "OK Message" "Error Message"
__getexitcode() {
  local EXITCODE=$?
  test -n "$1" && test -z "${1//[0-9]/}" && EXITCODE="$1" && shift 1 || EXITCODE="${EXITCODE:-0}"
  if [ -n "$1" ]; then
    local PSUCCES="$1"
  elif [ -n "$SUCCES" ]; then
    local PSUCCES="$SUCCES"
  elif [ -n "$GETEXITCODE_SUCCES" ]; then
    local PSUCCES="$GETEXITCODE_SUCCES"
  else
    local PSUCCES="Command successful"
  fi
  if [ -n "$2" ]; then
    local PERROR="$2"
  elif [ -n "$ERROR" ]; then
    local PERROR="$ERROR"
  elif [ -n "$GETEXITCODE_ERROR" ]; then
    local PSUCCES="$GETEXITCODE_ERROR"
  else
    local PERROR="Last command failed to complete"
  fi
  if [ "$EXITCODE" = 0 ]; then
    printf_cyan "$PSUCCES"
  else
    printf_error "$PERROR"
  fi
  __returnexitcode "$EXITCODE"
  return "$EXITCODE"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#return "code" "message 1" "message 2"
__return() {
  #clear
  printf_newline "\n"
  if [ -n "$2" ]; then printf_red "$2"; fi
  if [ -n "$3" ]; then printf_red "$3"; fi
  return "$1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
