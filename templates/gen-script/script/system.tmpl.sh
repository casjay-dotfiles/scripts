cat <<EOF | tee
$(. "$CASJAYSDEVDIR/templates/gen-script/header/default.tmpl.sh")
# - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="\${0##*/}"
VERSION="$GEN_SCRIPT_VERSION"
HOME="\${USER_HOME:-\$HOME}"
USER="\${SUDO_USER:-\$USER}"
RUN_USER="\${SUDO_USER:-\$USER}"
SRC_DIR="\${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
trap 'exitCode=\${exitCode:-\$?};[ -n "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && [ -f "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && rm -Rf "\$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" &>/dev/null' EXIT
[ "\$1" = "--debug" ] && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[ "\$1" = "--no-color" ] && export SHOW_RAW="true"
set -eo pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - -
EOF
