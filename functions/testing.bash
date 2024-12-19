#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  020920211625-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  LICENSE.md
# @ReadME            :  README.md
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created           :  Tuesday, Feb 09, 2021 17:17 EST
# @File              :  testing.bash
# @Description       :  Functions for apps
# @TODO              :  Refactor code - It is a mess/change, change to zenity
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[[ "$_DEBUG" = "on" ]] && set -xo pipefail

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main scripts location
FUNCFILE="testing.bash"
CASJAYSDEVDIR="/usr/local/share/CasjaysDev/scripts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default enviroment variables
source "$CASJAYSDEVDIR/functions/global/env.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default OS functions
source "$CASJAYSDEVDIR/functions/global/os.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# System checks and other functions
source "$CASJAYSDEVDIR/functions/global/initialize.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Versioning Info
source "$CASJAYSDEVDIR/functions/global/version.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Bring in sudo functions
source "$CASJAYSDEVDIR/functions/global/sudo.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Sysem utility functions
source "$CASJAYSDEVDIR/functions/global/system.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Timezone data
source "$CASJAYSDEVDIR/functions/global/timezone.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if input is from a pipe
source "$CASJAYSDEVDIR/functions/global/tty.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set logging functions
source "$CASJAYSDEVDIR/functions/global/logging.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Redifine OS Based functions
source "$CASJAYSDEVDIR/functions/global/fixes.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Colorization and printf functions
source "$CASJAYSDEVDIR/functions/global/colors.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Display functions
source "$CASJAYSDEVDIR/functions/global/x_server.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Network based functions
source "$CASJAYSDEVDIR/functions/global/network.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Functions based on getopts
source "$CASJAYSDEVDIR/functions/global/options.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Functions for systemctl
source "$CASJAYSDEVDIR/functions/global/systemctl.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# package managers base functions and variables
source "$CASJAYSDEVDIR/functions/global/pkgs.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# System processes functions
source "$CASJAYSDEVDIR/functions/global/processes.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# git functions
source "$CASJAYSDEVDIR/functions/global/git.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# crontab functions
source "$CASJAYSDEVDIR/functions/global/crontab.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Alternate package names
source "$CASJAYSDEVDIR/functions/global/alternatenames.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# spinner function
source "$CASJAYSDEVDIR/functions/global/spinner.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# menu function
source "$CASJAYSDEVDIR/functions/global/menu.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exitcode functions
source "$CASJAYSDEVDIR/functions/global/exit_status.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# default variables based on application requirements
source "$CASJAYSDEVDIR/functions/types/user_install.bash"
source "$CASJAYSDEVDIR/functions/types/system_install.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# application specfic
source "$CASJAYSDEVDIR/functions/types/main.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# help
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
# Run functions
__getlipaddr
__getpythonver
###################### end application functions ######################
