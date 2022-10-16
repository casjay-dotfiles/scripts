#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  GEN_SCRIPT_REPLACE_VERSION
# @@Author           :  GEN_SCRIPT_REPLACE_AUTHOR
# @@Contact          :  GEN_SCRIPT_REPLACE_EMAIL
# @@License          :  GEN_SCRIPT_REPLACE_LICENSE
# @@ReadME           :  GEN_SCRIPT_REPLACE_FILENAME --help
# @@Copyright        :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @@Created          :  GEN_SCRIPT_REPLACE_DATE
# @@File             :  GEN_SCRIPT_REPLACE_FILENAME
# @@Description      :  GEN_SCRIPT_REPLACE_DESC
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  GEN_SCRIPT_REPLACE_TODO
# @@Other            :  GEN_SCRIPT_REPLACE_OTHER
# @@Resource         :  GEN_SCRIPT_REPLACE_RES
# @@Terminal App     :  GEN_SCRIPT_REPLACE_TERMINAL
# @@sudo/root        :  GEN_SCRIPT_REPLACE_SUDO
# @@Template         :  installers/dockermgr
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
VERSION="GEN_SCRIPT_REPLACE_VERSION"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
SCRIPTS_PREFIX="dockermgr"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
[ "$1" = "--debug" ] && set -x && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[ "$1" = "--raw" ] && export SHOW_RAW="true"
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-mgr-installers.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/$SCRIPTS_PREFIX/installer/raw/main/functions}"
connect_test() { curl -q -ILSsf --retry 1 -m 1 "https://1.1.1.1" | grep -iq 'server:*.cloudflare' || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -q -LSsf "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 90
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure the scripts repo is installed
scripts_check
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define extra functions
__sudo() { sudo -n true && eval sudo "$@" || eval "$@" || return 1; }
__sudo_root() { sudo -n true && ask_for_password true && eval sudo "$@" || return 1; }
__enable_ssl() { { [ "$SSL_ENABLED" = "yes" ] || [ "$SSL_ENABLED" = "true" ]; } && return 0 || return 1; }
__ssl_certs() { [ -f "$HOST_SSL_CA" ] && [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ] && return 0 || return 1; }
__port_not_in_use() { [ -d "/etc/nginx/vhosts.d" ] && grep -wRsq "${1:-$CONTAINER_HTTP_PORT}" "/etc/nginx/vhosts.d" && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define pre-install scripts
run_pre_install() {

  return ${?:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define custom functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Repository variables
REPO="${DOCKERMGRREPO:-https://github.com/dockermgr}/GEN_SCRIPT_REPLACE_APPNAME"
APPVERSION="$(__appversion "$REPO/raw/${GIT_REPO_BRANCH:-main}/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults variables
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
INSTDIR="$HOME/.local/share/CasjaysDev/dockermgr/GEN_SCRIPT_REPLACE_APPNAME"
APPDIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME"
DATADIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME/files"
DOCKERMGR_CONFIG_DIR="${DOCKERMGR_CONFIG_DIR:-$HOME/.config/myscripts/dockermgr}"
DOCKER_HOST_IP="${DOCKER_HOST_IP:-$(ip a show 'docker0' | grep -w 'inet' | awk -F'/' '{print $1}' | awk '{print $2}' | grep '^')}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
dockermgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# trap the cleanup function
trap_exit
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a certain version
dockermgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define folders
HOST_DATA_DIR="$DATADIR/data"
HOST_CONFIG_DIR="$DATADIR/config"
LOCAL_DATA_DIR="${LOCAL_DATA_DIR:-$HOST_DATA_DIR}"
LOCAL_CONFIG_DIR="${LOCAL_CONFIG_DIR:-$HOST_CONFIG_DIR}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup variables
TZ=""
CONTAINER_DOMAINNAME=""
CONTAINER_HOSTNAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# URL to container image [docker pull URL]
HUB_IMAGE_URL="casjaysdevdocker/GEN_SCRIPT_REPLACE_APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# image tag [docker pull HUB_IMAGE_URL:tag]
HUB_IMAGE_TAG="latest"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup server mounts
HOST_SSL_DIR="${HOST_SSL_DIR:-/etc/ssl/CA/CasjaysDev}"
HOST_SSL_CA="${HOST_SSL_CA:-$HOST_SSL_DIR/certs/ca.crt}"
HOST_SSL_CRT="${HOST_SSL_CRT:-$HOST_SSL_DIR/certs/localhost.crt}"
HOST_SSL_KEY="${HOST_SSL_KEY:-$HOST_SSL_DIR/private/localhost.key}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup container mounts
CONTAINER_SSL_DIR="${CONTAINER_SSL_DIR:-/config/ssl}"
CONTAINER_SSL_CA="${CONTAINER_SSL_CA:-$CONTAINER_SSL_DIR/ca.crt}"
CONTAINER_SSL_CRT="${CONTAINER_SSL_CRT:-$CONTAINER_SSL_DIR/localhost.crt}"
CONTAINER_SSL_KEY="${CONTAINER_SSL_KEY:-$CONTAINER_SSL_DIR/localhost.key}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set to yes for container SSL support and set mount point IE: [/data/ssl/ca.crt]
SSL_ENABLED="no"
SSL_CA="$HOST_SSL_CA"
SSL_KEY="$HOST_SSL_KEY"
SSL_CERT="$HOST_SSL_CRT"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to 0.0.0.0 to listen on all or specify addresses
DEFINE_LISTEN=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set to yes for container to listen on LOCAL_IP only
LOCAL_IP="127.0.0.1"
HOST_LISTEN_LOCAL="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the network type - bridge,host [bridge]
HOST_NETWORK_TYPE="bridge"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable privileged container
CONTAINER_IS_PRIVILEGED="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the SHM Size - default 64M
CONTAINER_SHM_SIZE="128M"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable display in container
CONTAINER_DISPLAY="no"
HOST_X11_SOCKET="/tmp/.X11-unix"
HOST_X11_XAUTH="$HOME/.Xauthority"
CONTAINER_X11_XAUTH="/home/x11user/.Xauthority"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker socket [pathToSocket]
DOCKER_SOCKET_ENABLED="no"
DOCKER_SOCKET_MOUNT="/var/run/docker.sock"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set capabilites
ADD_CAPABILITIES="SYS_ADMIN "
ADD_CAPABILITIES+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional mounts [ /dir:/dir ]
ADDITIONAL_MOUNTS="$LOCAL_CONFIG_DIR:/config:z $LOCAL_DATA_DIR:/data:z "
ADDITIONAL_MOUNTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional variables [ myvar=var ]
ADDITION_ENV=""
ADDITION_ENV+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional devices [ /dev:/dev ]
ADDITION_DEVICES=""
ADDITION_DEVICES+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional docker arguments - see docker run --help
CUSTOM_ARGUMENTS=""
CUSTOM_ARGUMENTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to the protocol the the container will use [http]
CONTAINER_HTTP_PROTO="http"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add Add sevicee port [port] or [port:port] - LISTEN will be added if defined [DEFINE_LISTEN]
# Only ONE HTTP or HTTPS if web server or SERVICE port for mysql pgsql ftp etc. add more to CONTAINER_ADD_CUSTOM_PORT
CONTAINER_HTTP_PORT=""
CONTAINER_HTTPS_PORT=""
CONTAINER_SERVICE_PORT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add Add sevicee port [port] or [port:port] - LISTEN will be added if defined [DEFINE_LISTEN]
CONTAINER_ADD_CUSTOM_PORT=""
CONTAINER_ADD_CUSTOM_PORT+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show user info message
POST_SHOW_MESSAGE_USER=""
POST_SHOW_MESSAGE_PASS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show post install message
POST_SHOW_MESSAGE_FINISHED=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup nginx proxy variables
NGINX_SSL="yes"
NGINX_HTTP="80"
NGINX_HTTPS="443"
NGINX_PROXY=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End of configuration options
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import global variables
if [ -f "$APPDIR/env.sh" ] && [ ! -f "$APPDIR/.env" ]; then
  cp -Rf "$APPDIR/env.sh" "$APPDIR/.env"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -f "$APPDIR/.env" ] && . "$APPDIR/.env"
[ -f "$DOCKERMGR_CONFIG_DIR/.env.sh" ] && . "$DOCKERMGR_CONFIG_DIR/.env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/env/$APPNAME" ] && . "$DOCKERMGR_CONFIG_DIR/env/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$HUB_IMAGE_URL" ] || [ "$HUB_IMAGE_URL" = " " ]; then
  printf_exit "Please set the url to the containers image"
fi
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
# Initialize the installer
dockermgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run pre-install commands
execute "run_pre_install" "Running pre-installation commands"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure directories exist
ensure_dirs
ensure_perms
mkdir -p "$LOCAL_DATA_DIR"
mkdir -p "$LOCAL_CONFIG_DIR"
chmod -Rf 777 "$APPDIR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Variables - Do not change
NGINX_LISTEN_OPTS=""
HOST_IP="${CURRIP4:-$LOCAL_IP}"
HOST_TIMEZONE="${TZ:-$TIMEZONE}"
HOST_LISTEN_ADDR="${DEFINE_LISTEN:-$HOST_IP}"
CONTAINER_SHM_SIZE="${CONTAINER_SHM_SIZE:-64M}"
HOST_SERVICE_PORT="${CONTAINER_SERVICE_PORT//:*/}"
DEFINE_LISTEN="${DEFINE_LISTEN:-$HOST_LISTEN_ADDR}"
CONTAINER_HTTP_PROTO="${CONTAINER_HTTP_PROTO:-http}"
HOST_NETWORK_TYPE="--network ${HOST_NETWORK_TYPE:-bridge}"
POST_SHOW_MESSAGE_FINISHED="${POST_SHOW_MESSAGE_FINISHED:-}"
HOST_WEB_PORT="${CONTAINER_HTTPS_PORT:-$CONTAINER_HTTP_PORT}"
CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-"$(hostname -d 2>/dev/null | grep '^' || echo 'local')"}"
CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-$APPNAME.$CONTAINER_DOMAINNAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Configure variables
[ -n "$HOST_TIMEZONE" ] || HOST_TIMEZONE="America/New_York"
[ "$CONTAINER_HTTPS_PORT" = "https" ] && CONTAINER_HTTP_PROTO="https"
[ "$HOST_LISTEN_LOCAL" = "yes" ] && DEFINE_LISTEN="${LOCAL_IP:-127.0.0.1}"
[ -n "$CONTAINER_X11_XAUTH" ] || CONTAINER_X11_XAUTH="/home/x11user/.Xauthority"
[ "$DOCKER_SOCKET_ENABLED" = "yes" ] && ADDITIONAL_MOUNTS+="$DOCKER_SOCKET_MOUNT:/var/run/docker.sock "
[ "$CONTAINER_IS_PRIVILEGED" = "yes" ] && CONTAINER_IS_PRIVILEGED="--privileged" || CONTAINER_IS_PRIVILEGED=""
[ "$NGINX_SSL" = "yes" ] && [ -n "$NGINX_HTTPS" ] && NGINX_PORT="${NGINX_HTTPS:-443}" || NGINX_PORT="${NGINX_HTTP:-80}"
[ -n "$CONTAINER_DISPLAY" ] && ADDITIONAL_MOUNTS+="${HOST_X11_SOCKET:-/tmp/.X11-unix}:/tmp/.X11-unix $HOST_X11_XAUTH:$CONTAINER_X11_XAUTH "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite variables
[ -n "$HUB_IMAGE_TAG" ] || HUB_IMAGE_TAG="latest"
[ -n "$HOST_WEB_PORT" ] && HOST_PORT="${HOST_WEB_PORT//:*/}"
[ -n "$DEFINE_LISTEN" ] && DEFINE_LISTEN="${DEFINE_LISTEN//:*/}:" || DEFINE_LISTEN=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL setup
if [ "$SSL_ENABLED" = "yes" ]; then
  if [ "$CONTAINER_HTTP_PROTO" = "http" ]; then
    NGINX_LISTEN_OPTS="ssl http2"
    NGINX_PROXY="https://$HOST_LISTEN_ADDR:$HOST_PORT"
    CONTAINER_HTTP_PROTO="https"
  fi
  if [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ]; then
    [ -f "$CONTAINER_SSL_CA" ] && ADDITIONAL_MOUNTS+="$HOST_SSL_CA:$CONTAINER_SSL_CA "
    ADDITIONAL_MOUNTS+="$HOST_SSL_CRT:$CONTAINER_SSL_CRT "
    ADDITIONAL_MOUNTS+="$HOST_SSL_KEY:$CONTAINER_SSL_KEY "
  fi
else
  CONTAINER_HTTP_PROTO="${CONTAINER_HTTP_PROTO:-http}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NGINX_PROXY="${NGINX_PROXY:-$CONTAINER_HTTP_PROTO://$HOST_LISTEN_ADDR:$HOST_PORT}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_CAP=""
for cap in $ADD_CAPABILITIES; do
  [ "$cap" = " " ] && cap=""
  if [ -n "$cap" ]; then
    SET_CAP+="--cap-add $cap "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_ENV=""
for env in $ADDITION_ENV; do
  [ "$env" = " " ] && env=""
  if [ -n "$env" ]; then
    SET_ENV+="--env $env "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_DEV=""
for dev in $ADDITION_DEVICES; do
  [ "$dev" = " " ] && dev=""
  if [ -n "$dev" ]; then
    echo "$dev" | grep -q ':' || dev="$dev:$dev"
    SET_DEV+="--device $dev "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_MNT=""
for mnt in $ADDITIONAL_MOUNTS; do
  [ "$mnt" = " " ] && mnt=""
  if [ -n "$mnt" ]; then
    echo "$mnt" | grep -q ':' || port="$mnt:$mnt"
    SET_MNT+="--volume $mnt "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_PORT=""
for port in $CONTAINER_HTTP_PORT $CONTAINER_SERVICE_PORT $CONTAINER_HTTPS_PORT $CONTAINER_ADD_CUSTOM_PORT; do
  [ "$port" = " " ] && port=""
  if [ -n "$port" ]; then
    echo "$port" | grep -q ':' || port="$port:$port"
    SET_PORT+="--publish $DEFINE_LISTEN$port "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Clone/update the repo
if __am_i_online; then
  urlverify "$REPO" || printf_exit "$REPO was not found"
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
if [ -d "$INSTDIR/dataDir" ] && [ ! -f "$DATADIR/.installed" ]; then
  printf_yellow "Copying files to $DATADIR"
  cp -Rf "$INSTDIR/dataDir/." "$DATADIR/"
  find "$DATADIR" -name ".gitkeep" -type f -exec rm -rf {} \; &>/dev/null
fi
if [ -f "$DATADIR/.installed" ]; then
  date +'Updated on %Y-%m-%d at %H:%M' >"$DATADIR/.installed"
else
  date +'installed on %Y-%m-%d at %H:%M' >"$DATADIR/.installed"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main progam
if cmd_exists docker-compose && [ -f "$INSTDIR/docker-compose.yml" ]; then
  printf_yellow "Installing containers using docker-compose"
  sed -i 's|REPLACE_DATADIR|'$DATADIR'' "$INSTDIR/docker-compose.yml"
  if cd "$INSTDIR"; then
    __sudo docker-compose pull &>/dev/null
    __sudo docker-compose up -d &>/dev/null
  fi
else
  __sudo docker stop "$APPNAME" &>/dev/null
  __sudo docker rm -f "$APPNAME" &>/dev/null
  printf_cyan "Updating the image from $HUB_IMAGE_URL with tag $HUB_IMAGE_TAG"
  __sudo docker pull "$HUB_IMAGE_URL" &>/dev/null
  printf_cyan "Creating container $APPNAME"
  __sudo docker run -d --tty $CONTAINER_IS_PRIVILEGED --restart=always --name="$APPNAME" \
    --shm-size=$CONTAINER_SHM_SIZE --hostname "$CONTAINER_HOSTNAME" -e TZ="$HOST_TIMEZONE" \
    -e TIMEZONE="$HOST_TIMEZONE" $SET_ENV $SET_DEV $SET_MNT $SET_PORT $SET_CAP $CUSTOM_ARGUMENTS $HOST_NETWORK_TYPE \
    "$HUB_IMAGE_URL:$HUB_IMAGE_TAG" 1>/dev/null 2>"${TMP:-/tmp}/$APPNAME.err.log" &&
    rm -Rf "${TMP:-/tmp}/$APPNAME.err.log" || ERROR_LOG="true"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
if [ ! -f "/etc/nginx/vhosts.d/$CONTAINER_HOSTNAME.conf" ] && [ -f "$INSTDIR/nginx/proxy.conf" ]; then
  cp -f "$INSTDIR/nginx/proxy.conf" "/tmp/$$.$CONTAINER_HOSTNAME.conf"
  sed -i "s|REPLACE_APPNAME|$APPNAME|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_NGINX_PORT|$NGINX_PORT|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_HOST_PORT|$HOST_PORT|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_HOST_PROXY|$NGINX_PROXY|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_HOST_HOST|$CONTAINER_DOMAINNAME|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_REVPROXY_PROTO|$CONTAINER_HTTP_PROTO|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_HOST_LISTEN_OPTS|$NGINX_LISTEN_OPTS|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  if [ -d "/etc/nginx/vhosts.d" ]; then
    __sudo_root mv -f "/tmp/$$.$CONTAINER_HOSTNAME.conf" "/etc/nginx/vhosts.d/$CONTAINER_HOSTNAME.conf"
    [ -f "/etc/nginx/vhosts.d/$CONTAINER_HOSTNAME.conf" ] && printf_green "[ ✅ ] Copying the nginx configuration"
    systemctl status nginx | grep -q enabled &>/dev/null && __sudo_root systemctl reload nginx &>/dev/null
  else
    mv -f "/tmp/$$.$CONTAINER_HOSTNAME.conf" "$INSTDIR/nginx/$CONTAINER_HOSTNAME.conf" &>/dev/null
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
run_postinst() {
  dockermgr_run_post
  [ -w "/etc/hosts" ] || return 0
  if ! grep -sq "$CONTAINER_HOSTNAME" "/etc/hosts"; then
    if [ -n "$HOST_PORT" ]; then
      if [ $(hostname -d 2>/dev/null | grep '^') = 'local' ]; then
        echo "$HOST_LISTEN_ADDR     $APPNAME.local" | sudo tee -a "/etc/hosts" &>/dev/null
      else
        echo "$HOST_LISTEN_ADDR     $APPNAME.local" | sudo tee -a "/etc/hosts" &>/dev/null
        echo "$HOST_LISTEN_ADDR     $CONTAINER_HOSTNAME" | sudo tee -a "/etc/hosts" &>/dev/null
      fi
    fi
  fi
}
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
execute "run_postinst" "Running post install scripts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Output post install message

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
dockermgr_install_version
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run exit function
if docker ps -a | grep -qs "$APPNAME"; then
  printf_yellow "The DATADIR is in $DATADIR"
  printf_cyan "$APPNAME has been installed to $INSTDIR"
  [ -z "$HOST_SERVICE_PORT" ] && printf_yellow "This container does not have service" || printf_cyan "Service is running on $HOST_LISTEN_ADDR:$HOST_SERVICE_PORT or $CONTAINER_HOSTNAME:$HOST_SERVICE_PORT"
  [ -z "$HOST_PORT" ] || printf_yellow "Service is running on: $HOST_LISTEN_ADDR:$HOST_PORT"
  [ -z "$HOST_PORT" ] || printf_yellow "and should be available at: $NGINX_PROXY or $CONTAINER_HTTP_PROTO//$CONTAINER_HOSTNAME:$HOST_PORT"
  [ -z "$POST_SHOW_MESSAGE_USER" ] || printf_cyan "Username is:  $POST_SHOW_MESSAGE_USER"
  [ -z "$POST_SHOW_MESSAGE_PASS" ] || printf_purple "Password is:  $POST_SHOW_MESSAGE_PASS"
  [ -z "$POST_SHOW_MESSAGE_FINISHED" ] || printf_green "$POST_SHOW_MESSAGE_FINISHED"
else
  [ "$ERROR_LOG" = "true" ] && printf_yellow "Errors logged to ${TMP:-/tmp}/$APPNAME.err.log"
  printf_error "Something seems to have gone wrong with the install"
  printf '\n\n'
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exit
run_exit &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
