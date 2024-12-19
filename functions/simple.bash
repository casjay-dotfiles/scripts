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
[ "$_DEBUG" = "on" ] && set -xo pipefail

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main scripts location
FUNCFILE="${SCRIPTSFUNCTFILE:-simple}"
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default enviroment variables
source "$CASJAYSDEVDIR/functions/global/env.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Colorization and printf functions
source "$CASJAYSDEVDIR/functions/global/colors.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default OS functions
source "$CASJAYSDEVDIR/functions/global/os.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Versioning Info
source "$CASJAYSDEVDIR/functions/global/version.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Sysem utility functions
source "$CASJAYSDEVDIR/functions/global/system.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if input is from a pipe
source "$CASJAYSDEVDIR/functions/global/tty.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set logging functions
source "$CASJAYSDEVDIR/functions/global/logging.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Redefine OS Based functions
source "$CASJAYSDEVDIR/functions/global/fixes.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Network based functions
source "$CASJAYSDEVDIR/functions/global/network.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Functions based on getopts
source "$CASJAYSDEVDIR/functions/global/options.bash"
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
# spinner function
source "$CASJAYSDEVDIR/functions/global/spinner.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exitcode functions
source "$CASJAYSDEVDIR/functions/global/exit_status.bash"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# default variables based on application requirements
source "$CASJAYSDEVDIR/functions/types/user_install.bash"
# Run functions
__getpythonver
###################### end application functions ######################

