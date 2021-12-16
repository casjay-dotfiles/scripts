#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202112161543-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : install.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created       : Sunday, Dec 05, 2021 22:12 EST
# @File          : install.sh
# @Description   :
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [[ "$1" == "--debug" ]]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
connect_test() { ping -c1 1.1.1.1 &>/dev/null || curl --disable -LSs --connect-timeout 3 --retry 0 --max-time 1 1.1.1.1 2>/dev/null | grep -e "HTTP/[0123456789]" | grep -q "200" -n1 &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
user_installdirs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define extra functions
__sudo() { sudo -n true && eval sudo "$*" || eval "$*" || return 1; }
__sudo_root() { sudo -n true && ask_for_password true && eval sudo "$*" || return 1; }
__enable_ssl() { [[ "$SERVER_SSL" = "yes" ]] && [[ "$SERVER_SSL" = "true" ]] && return 0 || return 1; }
__ssl_certs() { [ -f "${1:-$SERVER_SSL_CRT}" ] && [ -f "${2:-SERVER_SSL_KEY}" ] && return 0 || return 1; }
__port_not_in_use() { [[ -d "/etc/nginx/vhosts.d" ]] && grep -wRsq "${1:-$SERVER_PORT}" /etc/nginx/vhosts.d && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure the scripts repo is installed
scripts_check
REPO_BRANCH="${GIT_REPO_BRANCH:-main}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
APPDIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME"
DATADIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME/files"
INSTDIR="$HOME/.local/share/dockermgr/GEN_SCRIPT_REPLACE_APPNAME"
REPO="${DOCKERMGRREPO:-https://github.com/dockermgr}/GEN_SCRIPT_REPLACE_APPNAME"
REPORAW="$REPO/raw/$REPO_BRANCH"
APPVERSION="$(__appversion "$REPORAW/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# URL to container image [docker pull URL]
HUB_URL="HubURL/GEN_SCRIPT_REPLACE_APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Directory variables
SERVER_DATA_DIR=""
SERVER_CONFIG_DIR=""
LOCAL_DATA_DIR="$DATADIR/data"
LOCAL_CONFIG_DIR="$DATADIR/config"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup variables
NGINX_HTTP="${NGINX_HTTP:-80}"
NGINX_HTTPS="${NGINX_HTTPS:-443}"
SERVER_IP="${CURRIP4:-127.0.0.1}"
SERVER_LISTEN="${SERVER_LISTEN:-$SERVER_IP}"
SERVER_HOST="${APPNAME}.$(hostname -d 2>/dev/null | grep '^' || echo local)"
SERVER_TIMEZONE="${TZ:-${TIMEZONE:-America/New_York}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Port Setup [ _INT is container port ]
SERVER_PORT="${SERVER_PORT:-}"
SERVER_PORT_INT="${SERVER_PORT_INT:-}"
SERVER_PORT_ADMIN="${SERVER_PORT_ADMIN:-}"
SERVER_PORT_ADMIN_INT="${SERVER_PORT_ADMIN_INT:-}"
SERVER_PORT_OTHER="${SERVER_PORT_OTHER:-}"
SERVER_PORT_OTHER_INT="${SERVER_PORT_OTHER_INT:-}"
SERVER_WEB_PORT="${SERVER_WEB_PORT:-$SERVER_PORT}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup
SERVER_SSL_CA="/etc/ssl/CA/CasjaysDev/certs/ca.crt"
SERVER_SSL_CRT="/etc/ssl/CA/CasjaysDev/certs/localhost.crt"
SERVER_SSL_KEY="/etc/ssl/CA/CasjaysDev/private/localhost.key"
[[ -f "$SERVER_SSL_CRT" ]] && [[ -f "$SERVER_SSL_KEY" ]] && SERVER_SSL="true"
[[ -n "$SERVER_SSL" ]] || SERVER_SSL="${SERVER_SSL:-false}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Override global variables
[[ -f "$HOME/.config/myscripts/dockermgr/env" ]] && . "$HOME/.config/myscripts/dockermgr/env"
[[ -f "$APPDIR/env" ]] && . "$APPDIR/env"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show post install message
SERVER_MESSAGE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a higher version
dockermgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the dockermgr function
dockermgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Requires root - no point in continuing
#sudoreq "$0 $*" # sudo required
#sudorun # sudo optional
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Do not update - add --force to overwrite
#installer_noupdate "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# initialize the installer
dockermgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure directories exist
ensure_dirs
ensure_perms
mkdir -p "$LOCAL_DATA_DIR"
mkdir -p "$LOCAL_CONFIG_DIR"
chmod -Rf 777 "$APPDIR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Clone/update the repo
if am_i_online; then
  if [ -d "$INSTDIR/.git" ]; then
    message="Updating $APPNAME configurations"
    execute "git_update $INSTDIR" "$message"
  else
    message="Installing $APPNAME configurations"
    execute "git_clone $REPO $INSTDIR" "$message"
  fi
  # exit on fail
  failexitcode $? "$message has failed"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy over data files - keep the same stucture as -v dataDir/mnt:/mount
if [[ -d "$INSTDIR/dataDir" ]] && [[ ! -f "$DATADIR/.installed" ]]; then
  printf_blue "Copying files to $DATADIR"
  cp -Rf "$INSTDIR/dataDir/." "$DATADIR/"
  find "$DATADIR" -name ".gitkeep" -type f -exec rm -rf {} \; &>/dev/null
fi
if [[ -f "$DATADIR/.installed" ]]; then
  date +'Updated on %Y-%m-%d at %H:%M' >"$DATADIR/.installed"
else
  date +'installed on %Y-%m-%d at %H:%M' >"$DATADIR/.installed"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main progam
if cmd_exists docker-compose && [ -f "$INSTDIR/docker-compose.yml" ]; then
  printf_blue "Installing containers using dockercompose"
  sed -i "s|REPLACE_DATADIR|$DATADIR" "$INSTDIR/docker-compose.yml"
  if cd "$INSTDIR"; then
    __sudo docker-compose pull &>/dev/null
    __sudo docker-compose up -d &>/dev/null
  fi
else
  if docker ps -a | grep -qsw "$APPNAME"; then
    __sudo docker stop "$APPNAME" &>/dev/null
    __sudo docker rm -f "$APPNAME" &>/dev/null
  fi
  __sudo docker run -d \
    --name="$APPNAME" \
    --hostname "$SERVER_HOST" \
    --restart=always \
    --privileged \
    -e TZ="$SERVER_TIMEZONE" \
    -v $LOCAL_DATA_DIR:/data \
    -v $LOCAL_CONFIG_DIR:/config \
    -p $SERVER_LISTEN:$SERVER_PORT:$SERVER_PORT_INT \
    "$HUB_URL" &>/dev/null
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
if [[ ! -f "/etc/nginx/vhosts.d/$APPNAME.conf" ]] && [[ -f "$INSTDIR/nginx/proxy.conf" ]]; then
  if __port_not_in_use "$SERVER_PORT"; then
    printf_green "Copying the nginx configuration"
    __sudo_root cp -Rf "$APPDIR/nginx/proxy.conf" "/etc/nginx/vhosts.d/$APPNAME.conf"
    sed -i "s|REPLACE_APPNAME|$APPNAME|g" "/etc/nginx/vhosts.d/$APPNAME.conf" &>/dev/null
    sed -i "s|REPLACE_NGINX_HTTP|$NGINX_HTTP|g" "/etc/nginx/vhosts.d/$APPNAME.conf" &>/dev/null
    sed -i "s|REPLACE_NGINX_HTTPS|$NGINX_HTTPS|g" "/etc/nginx/vhosts.d/$APPNAME.conf" &>/dev/null
    sed -i "s|REPLACE_SERVER_PORT|$SERVER_PORT|g" "/etc/nginx/vhosts.d/$APPNAME.conf" &>/dev/null
    sed -i "s|REPLACE_SERVER_LISTEN|$SERVER_LISTEN|g" "/etc/nginx/vhosts.d/$APPNAME.conf" &>/dev/null
    systemctl status nginx | grep -q enabled &>/dev/null && __sudo_root systemctl reload nginx &>/dev/null
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
run_postinst() {
  dockermgr_run_post
  if ! grep -sq "$SERVER_HOST" /etc/hosts; then
    if [[ -n "$SERVER_PORT_INT" ]]; then
      if [[ $(hostname -d 2>/dev/null | grep '^') = 'local' ]]; then
        echo "$SERVER_LISTEN     $APPNAME.local" | sudo tee -a /etc/hosts &>/dev/null
      else
        echo "$SERVER_LISTEN     $APPNAME.local" | sudo tee -a /etc/hosts &>/dev/null
        echo "$SERVER_LISTEN     $SERVER_HOST" | sudo tee -a /etc/hosts &>/dev/null
      fi
    fi
  fi
}
#
execute "run_postinst" "Running post install scripts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
dockermgr_install_version
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run exit function
if docker ps -a | grep -qs "$APPNAME"; then
  printf_blue "DATADIR in $DATADIR"
  printf_cyan "Installed to $INSTDIR"
  [[ -n "$SERVER_PORT" ]] && printf_blue "Service is running on: $SERVER_IP:$SERVER_PORT"
  [[ -n "$SERVER_WEB_PORT" ]] && printf_blue "and should be available at: http://$SERVER_LISTEN:$SERVER_WEB_PORT or http://$SERVER_HOST:$SERVER_WEB_PORT"
  [[ -z "$SERVER_WEB_PORT" ]] && printf_yellow "This container does not have a web interface"
  [[ -n "$SERVER_MESSAGE" ]] && printf_red "$SERVER_MESSAGE"
else
  printf_error "Something seems to have gone wrong with the install"
fi
run_exit &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
