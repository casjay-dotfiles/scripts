#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  GEN_SCRIPT_REPLACE_VERSION
# @Author            :  GEN_SCRIPT_REPLACE_AUTHOR
# @Contact           :  GEN_SCRIPT_REPLACE_EMAIL
# @License           :  GEN_SCRIPT_REPLACE_LICENSE
# @ReadME            :  GEN_SCRIPT_REPLACE_FILENAME --help
# @Copyright         :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @Created           :  GEN_SCRIPT_REPLACE_DATE
# @File              :  GEN_SCRIPT_REPLACE_FILENAME
# @Description       :  GEN_SCRIPT_REPLACE_DESC
# @TODO              :  GEN_SCRIPT_REPLACE_TODO
# @Other             :  GEN_SCRIPT_REPLACE_OTHER
# @Resource          :  GEN_SCRIPT_REPLACE_RES
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="\$(basename "\$0")"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
HOME="\${USER_HOME:-\$HOME}"
USER="\${SUDO_USER:-\$USER}"
RUN_USER="\${SUDO_USER:-\$USER}"
SRC_DIR="\${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [[ "\$1" = "--debug" ]]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi
trap 'exitCode=\${exitCode:-\$?};[ -n "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && [ -f "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && rm -Rf "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" &>/dev/null' EXIT

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
