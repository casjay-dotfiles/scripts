#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070959-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  logging.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:59 EDT
# @File              :  logging.bash
# @Description       :  logging functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# send all output to /dev/null
__devnull() {
  local CMD="$1" && shift 1
  local ARGS="$*" && shift
  eval $CMD $ARGS &>/dev/null
}
# only send stdout to display
__devnull1() {
  local CMD="$1" && shift 1
  local ARGS="$*" && shift
  eval $CMD $ARGS 1>/dev/null >&0
}
# send stderr to /dev/null
__devnull2() {
  local CMD="$1" && shift 1
  local ARGS="$*" && shift
  eval $CMD $ARGS 2>/dev/null
}
# log all app out to file
__runapp() {
  local logdir="${LOGDIR:-$HOME/.local/log}/runapp"
  __mkd "$logdir"
  if [ "$1" = "--bg" ]; then
    local logname="$2"
    shift 2
    __local_gen_header "#################################" "$logdir/$logname.log"
    date +'%A, %B %d, %Y' >>"$logdir/$logname.log"
    __local_gen_header "#################################" "$logdir/$logname.log"
    bash -c "${@:-$(false)}" >>"$logdir/$logname.log" 2>>"$logdir/$logname.err" &
  elif [ "$1" = "--log" ]; then
    local logname="$2"
    shift 2
    __local_gen_header "#################################" "$logdir/$logname.log"
    date +'%A, %B %d, %Y' >>"$logdir/$logname.log"
    __local_gen_header "#################################" "$logdir/$logname.log"
    bash -c "${@:-$(false)}" >>"$logdir/$logname.log" 2>>"$logdir/$logname.err"
  else
    __local_gen_header "#################################" "$logdir/${APPNAME:-$1}.log"
    date +'%A, %B %d, %Y' >>"$logdir/${APPNAME:-$1}.log"
    __local_gen_header "#################################" "$logdir/${APPNAME:-$1}.log"
    bash -c "${@:-$(false)}" >>"$logdir/${APPNAME:-$1}.log" 2>>"$logdir/${APPNAME:-$1}.err"
  fi
}
