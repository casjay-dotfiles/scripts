#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202507170940-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  tty.bash --help
# @Copyright         :  Copyright (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:57 EDT
# @File              :  tty.bash
# @Description       :  Check for TTY or piped output using POSIX-safe syntax
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

############################################################
# Check if output is a terminal or a named pipe
# Returns 0 if stdout is a terminal or a FIFO
############################################################

__is_tty() {
  if [ -t 1 ]; then
    return 0
  elif [ -p /dev/stdout ]; then
    return 0
  else
    return 1
  fi
}
