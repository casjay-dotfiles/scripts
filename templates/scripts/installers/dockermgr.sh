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
export SCRIPTS_PREFIX="dockermgr"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
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
# Define any pre-install scripts
run_pre_install() {
  true
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define any post-install scripts
run_post_install() {
  true
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define custom functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure docker is installed
[ -n "$(type -p docker 2>/dev/null)" ] || [ -n "$DOCKERMGR_CLI" ] || dockermgr init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Repository variables
REPO="${DOCKERMGRREPO:-https://github.com/dockermgr}/GEN_SCRIPT_REPLACE_APPNAME"
APPVERSION="$(__appversion "$REPO/raw/${GIT_REPO_BRANCH:-main}/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults variables
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
INSTDIR="$HOME/.local/share/CasjaysDev/dockermgr/GEN_SCRIPT_REPLACE_APPNAME"
APPDIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME"
DATADIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME/rootfs"
DOCKERMGR_CONFIG_DIR="${DOCKERMGR_CONFIG_DIR:-$HOME/.config/myscripts/dockermgr}"
DOCKER_HOST_IP="${DOCKER_HOST_IP:-$(ip a show 'docker0' 2>/dev/null | grep -w 'inet' | awk -F'/' '{print $1}' | awk '{print $2}' | grep '^')}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
dockermgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help
while :; do
  case "$1" in
  -e | --env) ENV_VAR="$2 $ENV_VAR" && shift 2 ;;
  -p | --port) PORT_VAR="$2 $PORT_VAR" && shift 2 ;;
  *) break ;;
  esac
done
# Script options IE: --help
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# trap the cleanup function
trap_exit
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a certain version
dockermgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import global variables
[ -f "$INSTDIR/env.sh" ] && . "$INSTDIR/env.sh"
[ -f "$APPDIR/env.sh" ] && . "$APPDIR/env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/.env.sh" ] && . "$DOCKERMGR_CONFIG_DIR/.env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/env/$APPNAME" ] && . "$DOCKERMGR_CONFIG_DIR/env/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define folders
HOST_DATA_DIR="$DATADIR/data"
HOST_CONFIG_DIR="$DATADIR/config"
LOCAL_DATA_DIR="${LOCAL_DATA_DIR:-$HOST_DATA_DIR}"
LOCAL_CONFIG_DIR="${LOCAL_CONFIG_DIR:-$HOST_CONFIG_DIR}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container timezone - Default America/New_York
TZ=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Get username and password from env if variables exist
GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME="${GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME:-$DEFAULT_USERNAME}"
GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD="${GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD:-$DEFAULT_PASSWORD}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container hostname and domain - Default GEN_SCRIPT_REPLACE_APPNAME
CONTAINER_HOSTNAME="$APPNAME"
CONTAINER_DOMAINNAME="$HOSTNAME"
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
# Set to yes for container to listen on LOCAL_IP only
HOST_LOCAL_ONLY="no"
LOCAL_IP="127.0.0.1"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to 0.0.0.0 to listen on all or specify addresses
DEFINE_LISTEN=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the network type - bridge,host - default is bridge
HOST_NETWORK_TYPE="bridge"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set location to resolv.conf [yes,no]
HOST_RESOLVE_MOUNT="no"
HOST_RESOLVE_FILE="/etc/resolv.conf"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable privileged container
CONTAINER_IS_PRIVILEGED="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the SHM Size - default is 64M
CONTAINER_SHM_SIZE="128M"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Restart container [always,no,on-failure,unless-stopped]
CONTAINER_AUTO_RESTART="always"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete container after exit [yes,no]
CONTAINER_AUTO_DELETE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable tty and interactive [yes,no]
CONTAINER_TTY="yes"
CONTAINER_INTERACTIVE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable display in container
CONTAINER_DISPLAY="no"
HOST_X11_SOCKET="/tmp/.X11-unix"
HOST_X11_XAUTH="$HOME/.Xauthority"
CONTAINER_X11_XAUTH="/home/x11user/.Xauthority"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container user and group ID [true,false]
SET_USER_ID=""
CONTAINER_USER_ID=""
CONTAINER_GROUP_ID=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container username and password and the env name [-e CONTAINER_ENV_USER_NAME=CONTAINER_USER_NAME] - [-e password=pass]
CONTAINER_USER_NAME="${GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME:-}"
CONTAINER_USER_PASS="${GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD:-}"
CONTAINER_ENV_USER_NAME=""
CONTAINER_ENV_PASS_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker socket [pathToSocket]
DOCKER_SOCKET_ENABLED="no"
DOCKER_SOCKET_MOUNT="/var/run/docker.sock"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Specify container arguments
CONTAINER_COMMANDS=""
CONTAINER_COMMANDS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set capabilites
ADD_CAPABILITIES="SYS_ADMIN "
ADD_CAPABILITIES+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set sysctl
ADD_SYSCTL=""
ADD_SYSCTL+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set link [ containerName ]
CONTAINER_LINK=""
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
# Define labels [ traefik.enable=true ]
ADDITION_LABELS=""
ADDITION_LABELS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional docker arguments - see docker run --help
CUSTOM_ARGUMENTS=""
CUSTOM_ARGUMENTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to the protocol the the container will use [http,https,git,ftp,etc]
CONTAINER_HTTP_PROTO="http"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add service port [port] or [port:port] - LISTEN will be added if defined [DEFINE_LISTEN]
# Only ONE HTTP or HTTPS if web server or SERVICE port for mysql pgsql ftp etc. add more to CONTAINER_ADD_CUSTOM_PORT
CONTAINER_HTTP_PORT=""
CONTAINER_HTTPS_PORT=""
CONTAINER_SERVICE_PORT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add Add service port [port] or [port:port] - LISTEN will be added if defined [DEFINE_LISTEN]
CONTAINER_ADD_CUSTOM_PORT=""
CONTAINER_ADD_CUSTOM_PORT+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add Add service port [listen]:[externalPort:internalPort]/[tcp,udp]
CONTAINER_ADD_CUSTOM_LISTEN=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show post install message
POST_SHOW_FINISHED_MESSAGE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup nginx proxy variables
NGINX_AUTH="no"
NGINX_SSL="yes"
NGINX_HTTP="80"
NGINX_HTTPS="443"
NGINX_PROXY=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End of configuration options
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$HUB_IMAGE_URL" ] || [ "$HUB_IMAGE_URL" = " " ]; then
  printf_exit "Please set the url to the containers image"
elif echo "$HUB_IMAGE_URL" | grep -q ':'; then
  HUB_IMAGE_URL="$(echo "$HUB_IMAGE_URL" | awk -F':' '{print $1}')"
  HUB_IMAGE_TAG="$(echo "$HUB_IMAGE_URL" | awk -F':' '{print $2}')"
fi
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
chmod -Rf 777 "$APPDIR"
mkdir -p "$LOCAL_DATA_DIR"
mkdir -p "$LOCAL_CONFIG_DIR"
mkdir -p "$DOCKERMGR_CONFIG_DIR/env"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Variables - Do not change anything below this line
DOCKER_OPTS=""
NGINX_LISTEN_OPTS=""
HOST_IP="${CURRENT_IP_4:-$LOCAL_IP}"
HOST_TIMEZONE="${TZ:-$TIMEZONE}"
DEFINE_LISTEN="${DEFINE_LISTEN:-}"
HOST_LISTEN_ADDR="${DEFINE_LISTEN:-$HOST_IP}"
CONTAINER_SHM_SIZE="${CONTAINER_SHM_SIZE:-64M}"
HOST_SERVICE_PORT="${CONTAINER_SERVICE_PORT:-}"
CONTAINER_HTTP_PROTO="${CONTAINER_HTTP_PROTO:-http}"
SET_USER_NAME="${CONTAINER_USER_NAME:-$GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME}"
SET_USER_PASS="${CONTAINER_USER_PASS:-$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD}"
HOST_NETWORK_TYPE="--network ${HOST_NETWORK_TYPE:-bridge}"
POST_SHOW_FINISHED_MESSAGE="${POST_SHOW_FINISHED_MESSAGE:-}"
HOST_WEB_PORT="${CONTAINER_HTTPS_PORT:-$CONTAINER_HTTP_PORT}"
SERVER_SHORT_DOMAIN="$(hostname -s 2>/dev/null | grep '^')"
SERVER_FULL_DOMAIN="$(hostname -d 2>/dev/null | grep '^' || echo 'home')"
CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-$APPNAME.$SERVER_SHORT_DOMAIN.$SERVER_FULL_DOMAIN}"
echo "$CONTAINER_HOSTNAME" | grep -Fq '.' || CONTAINER_HOSTNAME="$APPNAME.$SERVER_SHORT_DOMAIN.$SERVER_FULL_DOMAIN"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Configure variables
[ "$CONTAINER_HTTPS_PORT" = "" ] || CONTAINER_HTTP_PROTO="https"
[ "$DOCKER_SOCKET_ENABLED" = "yes" ] && ADDITIONAL_MOUNTS+="$DOCKER_SOCKET_MOUNT:/var/run/docker.sock "
[ "$NGINX_SSL" = "yes" ] && [ -n "$NGINX_HTTPS" ] && NGINX_PORT="${NGINX_HTTPS:-443}" || NGINX_PORT="${NGINX_HTTP:-80}"
[ "$HOST_RESOLVE_MOUNT" = "yes" ] && ADDITIONAL_MOUNTS+="$HOST_RESOLVE_MOUNT:/etc/resolv.conf " || HOST_RESOLVE_MOUNT=""
[ "$HOST_LOCAL_ONLY" = "yes" ] && DEFINE_LISTEN="${LOCAL_IP:-127.0.0.1}" && HOST_LISTEN_ADDR="${LOCAL_IP:-127.0.0.1}" || HOST_LOCAL_ONLY=""
[[ "$CONTAINER_DOMAINNAME" = server.* ]] && CONTAINER_HOSTNAME="$APPNAME.$SERVER_FULL_DOMAIN" || CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-$APPNAME.$CONTAINER_DOMAINNAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite variables
[ -n "$HUB_IMAGE_TAG" ] || HUB_IMAGE_TAG="latest"
[ -n "$CONTAINER_COMMANDS" ] || CONTAINER_COMMANDS=""
[ -n "$HOST_TIMEZONE" ] || HOST_TIMEZONE="America/New_York"
[ -n "$HOST_WEB_PORT" ] && HOST_PORT="${HOST_WEB_PORT:-}"
[ -n "$DEFINE_LISTEN" ] && DEFINE_LISTEN="${DEFINE_LISTEN//:*/}" || DEFINE_LISTEN=""
[ -z "$CONTAINER_USER_PASS" ] || ADDITION_ENV+="${CONTAINER_ENV_PASS_NAME:-password}=$CONTAINER_USER_PASS "
[ -z "$CONTAINER_USER_NAME" ] || ADDITION_ENV+="${CONTAINER_ENV_USER_NAME:-username}=$CONTAINER_USER_NAME "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
HOST_LISTEN_ADDR="${HOST_LISTEN_ADDR//:*/}"
PRETTY_PORT="${HOST_SERVICE_PORT:-$HOST_PORT}"
PRETTY_PORT="${PRETTY_PORT//*:\/\//}"
if echo "$PRETTY_PORT" | grep -qE '\.*:.*.:[0-9]'; then
  PRETTY_PORT="$(echo "$PRETTY_PORT" | awk -F ':' '{printf $2}' | grep '^' || echo "$PRETTY_PORT")"
elif echo "$PRETTY_PORT" | grep -qE '.*:.*.:[0-9]'; then
  PRETTY_PORT="$(echo "$PRETTY_PORT" | awk -F ':' '{printf $2}' | grep '^' || echo "$PRETTY_PORT")"
elif echo "$PRETTY_PORT" | grep -qE ':[0-9]'; then
  PRETTY_PORT="$(echo "$PRETTY_PORT" | awk -F ':' '{printf $NF}' | grep '^' || echo "$PRETTY_PORT")"
fi
PRETTY_PORT="${PRETTY_PORT//*:/}"
PRETTY_PORT="${PRETTY_PORT//\/*/}"
HOST_PORT="$PRETTY_PORT"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$HOST_NETWORK_TYPE" = "host" ] && HOST_NETWORK_TYPE="--net-host"
[ "$CONTAINER_TTY" = "yes" ] && DOCKER_OPTS+="--tty " || CONTAINER_TTY=""
[ "$CONTAINER_INTERACTIVE" = "yes" ] && DOCKER_OPTS+="--interactive " || CONTAINER_INTERACTIVE=""
[ "$CONTAINER_IS_PRIVILEGED" = "yes" ] && DOCKER_OPTS+="--privileged " || CONTAINER_IS_PRIVILEGED=""
[ "$CONTAINER_AUTO_DELETE" = "yes" ] && DOCKER_OPTS+="--rm " && CONTAINER_AUTO_RESTART="" || CONTAINER_AUTO_DELETE=""
[ -n "$CONTAINER_AUTO_RESTART" ] && DOCKER_OPTS+="--restart=$CONTAINER_AUTO_RESTART " || DOCKER_OPTS+="--restart=unless-stopped "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$SET_USER_ID" = "true" ]; then
  [ -n "$CONTAINER_USER_ID" ] && ADDITION_ENV+="PUID=$CONTAINER_USER_ID " || ADDITION_ENV+="PUID=$(id -u) "
  [ -n "$CONTAINER_GROUP_ID" ] && ADDITION_ENV+="PGID=$CONTAINER_GROUP_ID " || ADDITION_ENV+="PGID=$(id -g) "
fi
CONTAINER_USER_ID=""
CONTAINER_GROUP_ID=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup display if enabled
if [ "$CONTAINER_DISPLAY" = "yes" ]; then
  ADDITION_ENV+="DISPLAY=:${DISPLAY//*:/} "
  ADDITIONAL_MOUNTS+="${HOST_X11_SOCKET:-/tmp/.X11-unix}:/tmp/.X11-unix "
  if [ -n "$HOST_X11_XAUTH" ] && [ -n "$CONTAINER_X11_XAUTH" ]; then
    ADDITIONAL_MOUNTS+="$HOST_X11_XAUTH:$CONTAINER_X11_XAUTH "
  fi
fi
HOST_X11_XAUTH=""
CONTAINER_DISPLAY=""
CONTAINER_X11_XAUTH=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$NGINX_AUTH" = "yes" ]; then
  I2P_USERNAME="${I2P_USERNAME:-root}"
  I2P_PASSWORD="${I2P_PASSWORD:-toor}"
  [ -d "/etc/nginx/auth" ] || mkdir -p "/etc/nginx/auth"
  if [ ! -f "/etc/nginx/auth/$APPNAME" ] && [ -n "$(builtin type -P htpasswd)" ]; then
    printf_yellow "Creating auth /etc/nginx/auth/$APPNAME"
    htpasswd -b -c "/etc/nginx/auth/$APPNAME" "$I2P_USERNAME" "${I2P_PASSWORD}" &>/dev/null
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL setup
if [ "$SSL_ENABLED" = "yes" ]; then
  if [ "$CONTAINER_HTTP_PROTO" = "https" ]; then
    CONTAINER_HTTP_PROTO="https"
    NGINX_LISTEN_OPTS="ssl http2"
    NGINX_PROXY="https://$HOST_LISTEN_ADDR:$PRETTY_PORT"
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
NGINX_PROXY="${NGINX_PROXY:-$CONTAINER_HTTP_PROTO://$HOST_LISTEN_ADDR:$PRETTY_PORT}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_LINK=""
for link in $CONTAINER_LINK; do
  [ "$link" = " " ] && link=""
  if [ -n "$link" ]; then
    SET_LINK+="--link $link "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_LABELS=""
for label in $ADDITION_LABELS; do
  [ "$label" = " " ] && label=""
  if [ -n "$label" ]; then
    SET_LABELS+="--label $label "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_CAP=""
for cap in $ADD_CAPABILITIES; do
  [ "$cap" = " " ] && cap=""
  if [ -n "$cap" ]; then
    SET_CAP+="--cap-add $cap "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_SYSCTL=""
for sysctl in $ADD_SYSCTL; do
  [ "$sysctl" = " " ] && sysctl=""
  if [ -n "$sysctl" ]; then
    SET_SYSCTL+="--sysctl $sysctl "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_ENV=""
if [ -n "$ENV_VAR" ]; then
  for env in $ENV_VAR; do
    SET_ENV+="--env $env "
  done
fi
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
  [ "$mnt" = "" ] && mnt=""
  [ "$mnt" = " " ] && mnt=""
  if [ -n "$mnt" ]; then
    echo "$mnt" | grep -q ':' || port="$mnt:$mnt"
    SET_MNT+="--volume $mnt "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_PORT=""
SET_LISTEN="${DEFINE_LISTEN//:*/}"
if [ -n "$PORT_VAR" ]; then
  for port in $PORT_VAR; do
    [ "$port" = "" ] && port=""
    [ "$port" = " " ] && port=""
    SET_PORT+="--publish $port "
  done
fi
for port in $CONTAINER_HTTP_PORT $CONTAINER_SERVICE_PORT $CONTAINER_HTTPS_PORT $CONTAINER_ADD_CUSTOM_PORT; do
  [ "$port" = "" ] && port=""
  [ "$port" = " " ] && port=""
  if [ -n "$port" ]; then
    if echo "$port" | grep -E '[a-z,A-Z,0-9]\.[a-z,A-Z,0-9]' | grep -q ':.*.'; then
      SET_LISTEN="$(echo "$port" | awk -F":" '{print $1}')"
      port="$(echo "$port" | awk -F":" '{print $2}')"
      port="${port//\/*/}:${port//\/*/}"
    elif echo "$port" | grep -q ':'; then
      SET_LISTEN="$DEFINE_LISTEN"
      port="${port//\/*/}:${port//\/*/}"
    else
      SET_LISTEN="$DEFINE_LISTEN"
      port="${port//\/*/}:$port"
    fi
    if [ -n "${SET_LISTEN}" ]; then
      SET_PORT+="--publish $SET_LISTEN:$port "
    else
      SET_PORT+="--publish $port "
    fi
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_ADD_CUSTOM_LISTEN" ]; then
  for list in $CONTAINER_ADD_CUSTOM_LISTEN; do
    SET_PORT+="--publish $list "
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -d "$APPDIR/files" ] && [ ! -d "$DATADIR" ] && mv -f "$APPDIR/files" "$DATADIR"
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
if [ -d "$INSTDIR/rootfs" ] && [ ! -f "$DATADIR/.installed" ]; then
  printf_yellow "Copying files to $DATADIR"
  cp -Rf "$INSTDIR/rootfs/." "$DATADIR/"
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
  __sudo docker run -d --name="$APPNAME" $SET_LABELS $SET_LINK \
    --shm-size=$CONTAINER_SHM_SIZE $DOCKER_OPTS $SET_CAP $SET_SYSCTL \
    --hostname "$CONTAINER_HOSTNAME" --env TZ="$HOST_TIMEZONE" \
    --env TIMEZONE="$HOST_TIMEZONE" $SET_ENV $SET_DEV $SET_MNT $SET_PORT $CUSTOM_ARGUMENTS $HOST_NETWORK_TYPE \
    "$HUB_IMAGE_URL:$HUB_IMAGE_TAG" $CONTAINER_COMMANDS 1>/dev/null 2>"${TMP:-/tmp}/$APPNAME.err.log" &&
    rm -Rf "${TMP:-/tmp}/$APPNAME.err.log" || ERROR_LOG="true"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
if [ ! -f "/etc/nginx/vhosts.d/$CONTAINER_HOSTNAME.conf" ] && [ -f "$INSTDIR/nginx/proxy.conf" ]; then
  cp -f "$INSTDIR/nginx/proxy.conf" "/tmp/$$.$CONTAINER_HOSTNAME.conf"
  sed -i "s|REPLACE_APPNAME|$APPNAME|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_NGINX_PORT|$NGINX_PORT|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_HOST_PROXY|$NGINX_PROXY|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
  sed -i "s|REPLACE_NGINX_HOST|$CONTAINER_DOMAINNAME|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
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
    if [ -n "$PRETTY_PORT" ]; then
      if [ $(hostname -d 2>/dev/null | grep '^') = 'home' ]; then
        echo "$HOST_LISTEN_ADDR     $APPNAME.home" | sudo tee -a "/etc/hosts" &>/dev/null
      else
        echo "$HOST_LISTEN_ADDR     $APPNAME.home" | sudo tee -a "/etc/hosts" &>/dev/null
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
run_post_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
dockermgr_install_version
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run exit function
if docker ps -a | grep -qs "$APPNAME"; then
  printf_yellow "The DATADIR is in $DATADIR"
  printf_cyan "$APPNAME has been installed to $INSTDIR"
  if [ -z "$PRETTY_PORT" ]; then
    printf_yellow "This container does not have service"
  else
    printf_yellow "Service is running on: $HOST_LISTEN_ADDR:${PRETTY_PORT}"
    printf_cyan "Service is listening on $HOST_LISTEN_ADDR:$PRETTY_PORT or $CONTAINER_HOSTNAME:$PRETTY_PORT"
    printf_yellow "and should be available at: $NGINX_PROXY or $CONTAINER_HTTP_PROTO//$CONTAINER_HOSTNAME:$PRETTY_PORT"
  fi
  [ -z "$SET_USER_NAME" ] || printf_cyan "Username is:  $SET_USER_NAME"
  [ -z "$SET_USER_PASS" ] || printf_purple "Password is:  $SET_USER_PASS"
  [ -z "$POST_SHOW_FINISHED_MESSAGE" ] || printf_green "$POST_SHOW_FINISHED_MESSAGE"
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
# End application
# ex: ts=2 sw=2 et filetype=sh
