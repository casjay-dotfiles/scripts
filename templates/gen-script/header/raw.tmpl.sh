cat <<EOF | tee
#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  $GEN_SCRIPT_VERSION
# @@Author           :  $GEN_SCRIPT_AUTHOR
# @@Contact          :  $GEN_SCRIPT_EMAIL
# @@License          :  $GEN_SCRIPT_DEFLICENSE
# @@ReadME           :  $GEN_SCRIPT_NEWFILE --help
# @@Copyright        :  $GEN_SCRIPT_COPYRIGHT
# @@Created          :  $GEN_SCRIPT_CREATED
# @@File             :  $GEN_SCRIPT_NEWFILE
# @@Description      :  ${desc:-$get_desc}
# @@Changelog        :  ${changelog:-$get_changelog}
# @@TODO             :  ${todo:-$get_todo}
# @@Other            :  ${other:-$get_other}
# @@Resource         :  ${res:-$get_res}
# @@Terminal App     :  ${terminal:-$get_terminal}
# @@sudo/root        :  ${sudo:-$get_sudo}
# @@Template         :  ${template:-$get_template}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shell check options
# shellcheck disable=SC2317
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="\$(basename -- "\$0")"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
HOME="\${USER_HOME:-\$HOME}"
USER="\${SUDO_USER:-\$USER}"
RUN_USER="\${SUDO_USER:-\$USER}"
SRC_DIR="\${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
trap 'exitCode=\${exitCode:-\$?};[ -n "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && [ -f "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && rm -Rf "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" &>/dev/null' EXIT
#if [ ! -t 0 ] && { [ "\$1" = --term ] || [ \$# = 0 ]; }; then shift 1 && TERMINAL_APP="TRUE" myterminal -e "\$APPNAME \$*" && exit || exit 1; fi
[ "\$1" = "--debug" ] && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[ "\$1" = "--raw" ] && export SHOW_RAW="true"
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
EOF
