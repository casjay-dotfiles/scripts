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
# @@Description      :  docker installer script for GEN_SCRIPT_REPLACE_APPNAME
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
__port() { echo "$((50000 + $RANDOM % 1000))"; }
__sudo() { sudo -n true && eval sudo "$@" || eval "$@" || return 1; }
__sudo_root() { sudo -n true && ask_for_password true && eval sudo "$@" || return 1; }
__password() { cat "/dev/urandom" | tr -dc '[0-9][a-z][A-Z]@$' | head -c14 && echo ""; }
__name() { echo "$HUB_IMAGE_URL-${HUB_IMAGE_TAG:-latest}" | awk -F '/' '{print $(NF-1)"-"$NF}'; }
__enable_ssl() { { [ "$SSL_ENABLED" = "yes" ] || [ "$SSL_ENABLED" = "true" ]; } && return 0 || return 1; }
__ssl_certs() { [ -f "$HOST_SSL_CA" ] && [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ] && return 0 || return 1; }
__host_name() { hostname -f 2>/dev/null | grep '\.' | grep '^' || hostname -f 2>/dev/null | grep '^' || echo "$HOSTNAME"; }
__domain_name() { hostname -f 2>/dev/null | awk -F '.' '{print $(NF-1)"."$NF}' | grep '\.' | grep '^' || hostname -f 2>/dev/null | grep '^' || return 1; }
__port_in_use() { { [ -d "/etc/nginx/vhosts.d" ] && grep -wRsq "${1:-$CONTAINER_HTTP_PORT}" "/etc/nginx/vhosts.d" || netstat -taupln 2>/dev/null | grep -q "${1:-$CONTAINER_HTTP_PORT}"; } && return 1 || return 0; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__public_ip() { curl -q -LSsf "http://ifconfig.co" | grep '^'; }
__docker_gateway_ip() { __sudo docker network inspect -f '{{json .IPAM.Config}}' bridge | jq -r '.[].Gateway'; }
__local_lan_ip() { [ -n "$LOCAL_IP" ] && { echo "$LOCAL_IP" | grep -E '192\.168\.[0-255]\.[0-255]' 2>/dev/null || echo "$LOCAL_IP" | grep -E '10\.[0-255]\.[0-255]\.[0-255]' 2>/dev/null || echo "$LOCAL_IP" | grep -E '172\.[16-31]\.[0-255]\.[0-255]' 2>/dev/null; }; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__random_port() {
  local port
  port="$(__port)"
  while :; do
    { [ $port -lt 50000 ] && [ $port -gt 50999 ]; } && port="$(__port)"
    __port_in_use "$port" && break
  done
  echo "$port"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define any pre-install scripts
run_pre_install() {
  true
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define any post-install scripts
run_post_install() {

  return 0
}
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__show_post_message() {
  if [ -f "$DATADIR/config/auth/htpasswd" ]; then
    printf_purple "Username: root and Password: toor"
  fi
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define custom functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure docker is installed
[ -n "$(type -p docker 2>/dev/null)" ] || [ -n "$DOCKERMGR_CLI" ] || dockermgr init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Pre-define variables
RANDOM_PASS="$(__password)"
RANDOM_PORT="$(__random_port)"
SET_HOSTNAME="${CONTAINER_HOSTNAME:-$(__host_name)}"
SET_DOMAINNAME="${CONTAINER_DOMAINNAME:-$(__domain_name)}"
LOCAL_NET_DEV="$(ip route 2>/dev/null | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}' | grep '^' || echo 'eth0')"
LOCAL_IP="$(ifconfig $LOCAL_NET_DEV 2>/dev/null | grep -w 'inet' | awk -F ' ' '{print $2}' | grep -vE '127\.[0-255]\.[0-255]\.[0-255]' | tr ' ' '\n' | grep '^')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Repository variables
REPO="${DOCKERMGRREPO:-https://github.com/dockermgr}/GEN_SCRIPT_REPLACE_APPNAME"
APPVERSION="$(__appversion "$REPO/raw/${GIT_REPO_BRANCH:-main}/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults variables
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
APPDIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME"
DATADIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME/rootfs"
INSTDIR="$HOME/.local/share/CasjaysDev/dockermgr/GEN_SCRIPT_REPLACE_APPNAME"
DOCKERMGR_CONFIG_DIR="${DOCKERMGR_CONFIG_DIR:-$HOME/.config/myscripts/dockermgr}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
dockermgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "e:,p:,h:,d:" --long "options,env:,port:,host:,domain:" -n "$APPNAME" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  -e | --env) ENV_VAR="$2 $ENV_VAR" && shift 2 ;;
  -p | --port) PORT_VAR="$2 $PORT_VAR" && shift 2 ;;
  -h | --host) CONTAINER_HOSTNAME="$2" && shift 2 ;;
  -d | --domain) CONTAINER_DOMAINNAME="$2" && shift 2 ;;
  --options) shift 1 && echo "Options: -e -p -h -d --options --env --port --host --domain" && exit 1 ;;
  *) break ;;
  esac
done
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
TZ="${TZ:-$TIMEZONE}"
TIMEZONE="${TZ:-$TIMEZONE}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Get username and password from env if variables exist [username] [pass,random]
GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME="${GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME:-$DEFAULT_USERNAME}"
GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD="${GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD:-$DEFAULT_PASSWORD}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container hostname and domain - Default GEN_SCRIPT_REPLACE_APPNAME
CONTAINER_HOSTNAME=""
CONTAINER_DOMAINNAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# URL to container image [docker pull URL]
HUB_IMAGE_URL="casjaysdevdocker/GEN_SCRIPT_REPLACE_APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# image tag [docker pull HUB_IMAGE_URL:tag]
HUB_IMAGE_TAG="latest"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the container name default [casjaysdevdocker/GEN_SCRIPT_REPLACE_APPNAME-$HUB_IMAGE_TAG]
CONTAINER_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup server mounts
HOST_SSL_DIR="${HOST_SSL_DIR:-/etc/ssl/CA/CasjaysDev}"
HOST_SSL_CA="${HOST_SSL_CA:-$HOST_SSL_DIR/certs/ca.crt}"
HOST_SSL_CRT="${HOST_SSL_CRT:-$HOST_SSL_DIR/certs/localhost.crt}"
HOST_SSL_KEY="${HOST_SSL_KEY:-$HOST_SSL_DIR/private/localhost.key}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set mount ssl points IE: [/data/ssl/ca.crt]
SSL_CA="$HOST_SSL_CA"
SSL_KEY="$HOST_SSL_KEY"
SSL_CERT="$HOST_SSL_CRT"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup container mounts
CONTAINER_SSL_DIR="${CONTAINER_SSL_DIR:-/config/ssl}"
CONTAINER_SSL_CA="${CONTAINER_SSL_CA:-$CONTAINER_SSL_DIR/ca.crt}"
CONTAINER_SSL_CRT="${CONTAINER_SSL_CRT:-$CONTAINER_SSL_DIR/localhost.crt}"
CONTAINER_SSL_KEY="${CONTAINER_SSL_KEY:-$CONTAINER_SSL_DIR/localhost.key}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to 0.0.0.0 to listen on all or specific addresses
DEFINE_LISTEN="0.0.0.0"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Listen on local address only [no,local,lan,docker]
HOST_LOCAL_ONLY="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup nginx proxy variables [yes,no]
NGINX_PROXY="yes"
NGINX_SSL="yes"
NGINX_HTTP="80"
NGINX_HTTPS="443"
NGINX_UPDATE_CONF="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable this is container is running a webserver [yes/no] [yes/no] [internalPort]
WEB_SERVER="no"
WEB_SSL_ENABLE="no"
WEB_SERVER_AUTH="no"
WEB_SERVER_PORT="80"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add service port [port] or [port:port] - LISTEN will be added if defined [DEFINE_LISTEN] or CONTAINER_PRIVATE=yes
# Only ONE HTTP or HTTPS if web server or SERVICE port for mysql pgsql ftp etc. add more to CONTAINER_ADD_CUSTOM_PORT
CONTAINER_HTTP_PORT=""
CONTAINER_HTTPS_PORT=""
CONTAINER_SERVICE_PORT=""
CONTAINER_ADD_CUSTOM_PORT=""
CONTAINER_ADD_CUSTOM_PORT+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add service port [listen]:[externalPort:internalPort]/[tcp,udp]
CONTAINER_ADD_CUSTOM_LISTEN=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to the protocol the the container will use [http,https,git,ftp,etc]
CONTAINER_HTTP_PROTO="http"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set to yes to have HTTP[S] or SERVICE to listen on localhost only
CONTAINER_PRIVATE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the network type - bridge,host - default is bridge
HOST_NETWORK_TYPE="bridge"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set link [ containerName ]
CONTAINER_LINK=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable privileged container [ yes/no ]
CONTAINER_IS_PRIVILEGED="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the SHM Size - default is 64M
CONTAINER_SHM_SIZE="128M"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Restart container [always,no,on-failure,unless-stopped]
CONTAINER_AUTO_RESTART="always"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete container after exit [yes/no]
CONTAINER_AUTO_DELETE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable tty and interactive [yes/no]
CONTAINER_TTY="yes"
CONTAINER_INTERACTIVE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable display in container
CONTAINER_DISPLAY="no"
HOST_X11_SOCKET="/tmp/.X11-unix"
HOST_X11_XAUTH="$HOME/.Xauthority"
CONTAINER_X11_XAUTH="/home/x11user/.Xauthority"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable hosts /etc/hosts file [yes/no]
HOST_ETC_HOSTS_FILE="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable cgroups [yes/no]
CGROUP_ENABLED="no"
CGROUP_MOUNTS="/sys/fs/cgroup:/sys/fs/cgroup:ro"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set location to resolv.conf [yes/no]
HOST_RESOLVE_MOUNT="no"
HOST_RESOLVE_FILE="/etc/resolv.conf"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker socket [pathToSocket]
DOCKER_SOCKET_ENABLED="no"
DOCKER_SOCKET_MOUNT="/var/run/docker.sock"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker config [~/.docker/config.json]
DOCKER_CONFIG_ENABLED="no"
DOCKER_CONFIG_MOUNT="$HOME/.docker/config.json"
DOCKER_CONFIG_TO_MOUNT="/root/.docker/config.json"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional mounts [ /dir:/dir,/otherdir:/otherdir ]
ADDITIONAL_MOUNTS="$LOCAL_CONFIG_DIR:/config:z,$LOCAL_DATA_DIR:/data:z "
ADDITIONAL_MOUNTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional devices [ /dev:/dev,/otherdev:/otherdev ]
ADDITION_DEVICES=""
ADDITION_DEVICES+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional variables [ myvar=var,myothervar=othervar ]
ADDITION_ENV=""
ADDITION_ENV+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set sysctl []
ADD_SYSCTL=""
ADD_SYSCTL+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set capabilites [ CAP,OTHERCAP ]
ADD_CAPABILITIES="SYS_ADMIN,SYS_TIME "
ADD_CAPABILITIES+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define labels [ traefik.enable=true ] [ label=label,otherlabel=label2 ]
ADDITION_LABELS=""
ADDITION_LABELS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container user and group ID [yes/no]
SET_USER_ID="no"
CONTAINER_USER_ID=""
CONTAINER_GROUP_ID=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container username and password and the env name [ CONTAINER_ENV_USER_NAME=CONTAINER_USER_NAME] - [ password=pass]
CONTAINER_USER_NAME="${GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME:-}"
CONTAINER_USER_PASS="${GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD:-}"
CONTAINER_ENV_USER_NAME=""
CONTAINER_ENV_PASS_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Specify container arguments - will run in container [/path/to/script]
CONTAINER_COMMANDS=""
CONTAINER_COMMANDS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional docker arguments - see docker run --help [ arg1,arg2 ]
CUSTOM_ARGUMENTS=""
CUSTOM_ARGUMENTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show post install message
POST_SHOW_FINISHED_MESSAGE=""
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
mkdir -p "$DOCKERMGR_CONFIG_DIR/scripts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite variables
[ -n "$HOST_LOCAL_ONLY" ] || HOST_LOCAL_ONLY="no"
[ "$DEFINE_LISTEN" = "public" ] && DEFINE_LISTEN="0.0.0.0"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SERVER_SHORT_DOMAIN="$(hostname -s 2>/dev/null | grep '^')"
SERVER_FULL_DOMAIN="$(hostname -d 2>/dev/null | grep '^' || echo 'home')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Variables - Do not change anything below this line
ENV_PORTS=""
DOCKER_OPTS=""
NGINX_LISTEN_OPTS=""
CONTAINER_LISTEN="127.0.0.1"
HOST_TIMEZONE="${TZ:-$TIMEZONE}"
DEFINE_LISTEN="${DEFINE_LISTEN:-}"
HOST_IP="${CURRENT_IP_4:-$(__local_lan_ip)}"
HOST_LISTEN_ADDR="${DEFINE_LISTEN:-$HOST_IP}"
CONTAINER_SHM_SIZE="${CONTAINER_SHM_SIZE:-64M}"
HOST_SERVICE_PORT="${CONTAINER_SERVICE_PORT:-}"
CONTAINER_HTTP_PROTO="${CONTAINER_HTTP_PROTO:-http}"
CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-SET_HOSTNAME}"
HOST_NETWORK_TYPE="--network ${HOST_NETWORK_TYPE:-bridge}"
POST_SHOW_FINISHED_MESSAGE="${POST_SHOW_FINISHED_MESSAGE:-}"
HOST_WEB_PORT="${CONTAINER_HTTPS_PORT:-$CONTAINER_HTTP_PORT}"
CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-SET_DOMAINNAME}"
SET_USER_NAME="${CONTAINER_USER_NAME:-$GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME}"
SET_USER_PASS="${CONTAINER_USER_PASS:-$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD}"
CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-$APPNAME.$SERVER_SHORT_DOMAIN.$SERVER_FULL_DOMAIN}"
echo "$CONTAINER_HOSTNAME" | grep -Fq '.' || CONTAINER_HOSTNAME="$APPNAME.$SERVER_SHORT_DOMAIN.$SERVER_FULL_DOMAIN"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Configure variables
[ -n "$CONTAINER_NAME" ] || CONTAINER_NAME="$(__name)"
[ "$HOST_LOCAL_ONLY" = "yes" ] && CONTAINER_PRIVATE="yes"
[ "$HOST_LOCAL_ONLY" = "local" ] && DEFINE_LISTEN="127.0.0.1"
[ "$CONTAINER_HTTPS_PORT" = "" ] || CONTAINER_HTTP_PROTO="https"
[ "$CGROUP_ENABLED" = "yes" ] && ADDITIONAL_MOUNTS="$CGROUP_MOUNTS "
[ "$SET_USER_PASS" = "random" ] && CONTAINER_USER_PASS="$RANDOM_PASS"
[ "$HOST_ETC_HOSTS_FILE" = "yes" ] && ADDITIONAL_MOUNTS+="/etc/hosts:/usr/local/etc/hosts:ro "
[ "$DOCKER_SOCKET_ENABLED" = "yes" ] && ADDITIONAL_MOUNTS+="$DOCKER_SOCKET_MOUNT:/var/run/docker.sock "
[ "$DOCKER_CONFIG_ENABLED" = "yes" ] && ADDITIONAL_MOUNTS="$DOCKER_CONFIG_MOUNT:$DOCKER_CONFIG_TO_MOUNT:ro "
[ "$HOST_LOCAL_ONLY" = "yes" ] && DEFINE_LISTEN="127.0.0.1" && HOST_LISTEN_ADDR="127.0.0.1" || HOST_LOCAL_ONLY=""
[ "$HOST_LOCAL_ONLY" = "lan" ] && DEFINE_LISTEN="$(__local_lan_ip)" && HOST_LISTEN_ADDR="$(__local_lan_ip)" || HOST_LOCAL_ONLY=""
[ "$HOST_LOCAL_ONLY" = "docker" ] && DEFINE_LISTEN="$(__docker_gateway_ip)" && HOST_LISTEN_ADDR="$(__docker_gateway_ip)" || HOST_LOCAL_ONLY=""
[ "$HOST_RESOLVE_MOUNT" = "yes" ] && ADDITIONAL_MOUNTS+="$HOST_RESOLVE_MOUNT:/etc/resolv.conf " || HOST_RESOLVE_MOUNT=""
[ "$NGINX_SSL" = "yes" ] && [ -n "$NGINX_HTTPS" ] && NGINX_PORT="${NGINX_HTTPS:-443}" && NGINX_LISTEN_OPTS="ssl http2" || NGINX_PORT="${NGINX_HTTP:-80}"
[[ "$CONTAINER_DOMAINNAME" = server.* ]] && CONTAINER_HOSTNAME="$APPNAME.$SERVER_FULL_DOMAIN" || CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-$APPNAME.$CONTAINER_DOMAINNAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite variables
[ -n "$HUB_IMAGE_TAG" ] || HUB_IMAGE_TAG="latest"
[ -n "$HOST_TIMEZONE" ] || HOST_TIMEZONE="America/New_York"
[ -n "$HOST_WEB_PORT" ] && HOST_WEB_PORT="${HOST_WEB_PORT:-}"
[ -n "$CUSTOM_ARGUMENTS" ] && CUSTOM_ARGUMENTS="${CUSTOM_ARGUMENTS//,/ }"
[ -n "$DEFINE_LISTEN" ] && DEFINE_LISTEN="${DEFINE_LISTEN//:*/}" || DEFINE_LISTEN=""
[ -n "$CONTAINER_DOMAINNAME" ] && CUSTOM_ARGUMENTS+="--domainname $CONTAINER_DOMAINNAME "
[ -n "$CONTAINER_COMMANDS" ] && CONTAINER_COMMANDS="${CONTAINER_COMMANDS//,/ }" || CONTAINER_COMMANDS=""
[ -z "$CONTAINER_USER_NAME" ] || ADDITION_ENV+="${CONTAINER_ENV_USER_NAME:-username}=$CONTAINER_USER_NAME "
[ -z "$CONTAINER_USER_PASS" ] || ADDITION_ENV+="${CONTAINER_ENV_PASS_NAME:-password}=$CONTAINER_USER_PASS "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IS_PRIVATE="${HOST_WEB_PORT:-$CONTAINER_SERVICE_PORT}"
CLEANUP_PORT="${HOST_SERVICE_PORT:-$IS_PRIVATE}"
CLEANUP_PORT="${CLEANUP_PORT//\/*/}"
PRETTY_PORT="$CLEANUP_PORT"
NGINX_PROXY_PORT="$PRETTY_PORT"
#NGINX_PROXY_PORT="$(echo "$CLEANUP_PORT" | awk -F':' '{printf $NF}' | grep '^' || echo "$CLEANUP_PORT")"
#echo "$PRETTY_PORT" | grep -q ':' && PRETTY_PORT="$(echo "$PRETTY_PORT" | awk -F':' '{print $1}')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$HOST_NETWORK_TYPE" = "host" ] && HOST_NETWORK_TYPE="--net-host"
[ "$CONTAINER_TTY" = "yes" ] && DOCKER_OPTS+="--tty " || CONTAINER_TTY=""
[ "$CONTAINER_INTERACTIVE" = "yes" ] && DOCKER_OPTS+="--interactive " || CONTAINER_INTERACTIVE=""
[ "$CONTAINER_IS_PRIVILEGED" = "yes" ] && DOCKER_OPTS+="--privileged " || CONTAINER_IS_PRIVILEGED=""
[ "$CONTAINER_AUTO_DELETE" = "yes" ] && DOCKER_OPTS+="--rm " && CONTAINER_AUTO_RESTART="" || CONTAINER_AUTO_DELETE=""
[ -n "$CONTAINER_AUTO_RESTART" ] && DOCKER_OPTS+="--restart=$CONTAINER_AUTO_RESTART " || DOCKER_OPTS+="--restart=unless-stopped "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$SET_USER_ID" = "yes" ]; then
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
if [ "$WEB_SERVER_AUTH" = "yes" ]; then
  CONTAINER_USER_NAME="${CONTAINER_USER_NAME:-root}"
  CONTAINER_USER_PASS="${CONTAINER_USER_PASS:-$RANDOM_PASS}"
  SET_USER_NAME="$CONTAINER_USER_NAME"
  SET_USER_PASS="$CONTAINER_USER_PASS"
  [ -d "/etc/nginx/auth" ] || mkdir -p "/etc/nginx/auth"
  if [ ! -f "/etc/nginx/auth/$APPNAME" ] && [ -n "$(builtin type -P htpasswd)" ]; then
    if ! grep -q "$CONTAINER_USER_NAME"; then
      printf_yellow "Creating auth /etc/nginx/auth/$APPNAME"
      htpasswd -b -c "/etc/nginx/auth/$APPNAME" "$CONTAINER_USER_NAME" "$CONTAINER_USER_PASS" &>/dev/null
    fi
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add username and password to env file
if [ -n "$SET_USER_NAME" ]; then
  if ! grep -qs "$GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME" "$DOCKERMGR_CONFIG_DIR/env/$APPNAME"; then
    cat <<EOF >>"$DOCKERMGR_CONFIG_DIR/env/$APPNAME"
GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME="${SET_USER_NAME:-$GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME}"
EOF
  fi
fi
if [ -n "$SET_USER_PASS" ]; then
  if ! grep -qs "$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD" "$DOCKERMGR_CONFIG_DIR/env/$APPNAME"; then
    cat <<EOF >>"$DOCKERMGR_CONFIG_DIR/env/$APPNAME"
GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD="${SET_USER_PASS:-$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD}"
EOF
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Auto create web server
if [ "$WEB_SERVER" = "yes" ]; then
  WEB_SERVER_IP="$(__docker_gateway_ip)"
  WEB_SERVER_PORT="${WEB_SERVER_PORT//,/ }"
  CONTAINER_HTTP_PORT=""
  CONTAINER_HTTPS_PORT=""
  for web_ports in $WEB_SERVER_PORT; do
    RANDOM_PORT="$(__random_port)"
    CONTAINER_ADD_CUSTOM_LISTEN+="$WEB_SERVER_IP:$RANDOM_PORT:$web_ports "
  done
  [ "$WEB_SSL_ENABLE" = "yes" ] && CONTAINER_HTTP_PROTO="https"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_LINK=""
CONTAINER_LINK="${CONTAINER_LINK//,/ }"
for link in $CONTAINER_LINK; do
  [ "$link" = " " ] && link=""
  if [ -n "$link" ]; then
    SET_LINK+="--link $link "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_LABELS=""
ADDITION_LABELS="${ADDITION_LABELS//,/ }"
for label in $ADDITION_LABELS; do
  [ "$label" = " " ] && label=""
  if [ -n "$label" ]; then
    SET_LABELS+="--label $label "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_CAP=""
ADD_CAPABILITIES="${ADD_CAPABILITIES//,/ }"
for cap in $ADD_CAPABILITIES; do
  [ "$cap" = " " ] && cap=""
  if [ -n "$cap" ]; then
    SET_CAP+="--cap-add $cap "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_SYSCTL=""
ADD_SYSCTL="${ADD_SYSCTL//,/ }"
for sysctl in $ADD_SYSCTL; do
  [ "$sysctl" = " " ] && sysctl=""
  if [ -n "$sysctl" ]; then
    SET_SYSCTL+="--sysctl $sysctl "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_ENV=""
ENV_VAR="${ENV_VAR//,/ }"
ADDITION_ENV="${ADDITION_ENV//,/ }"
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
ADDITION_DEVICES="${ADDITION_DEVICES//,/ }"
for dev in $ADDITION_DEVICES; do
  [ "$dev" = " " ] && dev=""
  if [ -n "$dev" ]; then
    echo "$dev" | grep -q ':' || dev="$dev:$dev"
    SET_DEV+="--device $dev "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_MNT=""
ADDITIONAL_MOUNTS="${ADDITIONAL_MOUNTS//,/ }"
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
PORT_VAR="${PORT_VAR//,/ }"
SET_LISTEN="${DEFINE_LISTEN//:*/}"
if [ -n "$PORT_VAR" ]; then
  for port in $PORT_VAR; do
    if [ "$port" != "" ] && [ "$port" != " " ]; then
      echo "$port" | grep -q ':' || port="${port//\/*/}:$port"
      SET_PORT+="--publish $port "
    fi
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_SERVER_PORTS="$CONTAINER_HTTP_PORT $CONTAINER_HTTPS_PORT $CONTAINER_SERVICE_PORT $CONTAINER_ADD_CUSTOM_PORT"
SET_SERVER_PORTS="${SET_SERVER_PORTS//,/ }"
for port in $SET_SERVER_PORTS; do
  if [ "$port" != " " ] && [ -n "$port" ]; then
    echo "$port" | grep -q ':' || port="${port//\/*/}:$port"
    if [ "$CONTAINER_PRIVATE" = "yes" ] && [ "$port" = "${IS_PRIVATE//\/*/}" ]; then
      HOST_LISTEN_ADDR="$CONTAINER_LISTEN"
      SET_PORT+="--publish $CONTAINER_LISTEN:$port "
    elif [ -n "$SET_LISTEN" ]; then
      SET_PORT+="--publish $SET_LISTEN$port "
    else
      SET_PORT+="--publish $port "
    fi
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_ADD_CUSTOM_LISTEN="${CONTAINER_ADD_CUSTOM_LISTEN//,/ }"
if [ -n "$CONTAINER_ADD_CUSTOM_LISTEN" ]; then
  for list in $CONTAINER_ADD_CUSTOM_LISTEN; do
    echo "$list" | grep -q ':' || list="${list//\/*/}:$list"
    SET_PORT+="--publish $list "
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL setup
NGINX_PROXY_URL=""
PROXY_HTTP_PROTO="http"
if [ "$NGINX_SSL" = "yes" ]; then
  [ "$SSL_ENABLED" = "yes" ] && PROXY_HTTP_PROTO="https"
  if [ "$PROXY_HTTP_PROTO" = "https" ]; then
    NGINX_PROXY_URL="$PROXY_HTTP_PROTO://$HOST_LISTEN_ADDR:$NGINX_PROXY_PORT"
    if [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ]; then
      [ -f "$CONTAINER_SSL_CA" ] && ADDITIONAL_MOUNTS+="$HOST_SSL_CA:$CONTAINER_SSL_CA "
      ADDITIONAL_MOUNTS+="$HOST_SSL_CRT:$CONTAINER_SSL_CRT "
      ADDITIONAL_MOUNTS+="$HOST_SSL_KEY:$CONTAINER_SSL_KEY "
    fi
  fi
else
  CONTAINER_HTTP_PROTO="${CONTAINER_HTTP_PROTO:-http}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NGINX_PROXY_URL="${NGINX_PROXY_URL:-$PROXY_HTTP_PROTO://$HOST_LISTEN_ADDR:$NGINX_PROXY_PORT}"
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
ENV_PORTS+="$(echo "$SET_PORT" | tr ' ' '\n' | grep ':.*.:' | awk -F ':' '{print $1":"$3}')"
ENV_PORTS+="$(echo "$SET_PORT" | tr ' ' '\n' | grep -v ':.*.:' | awk -F ':' '{print $1":"$2}')"
ENV_PORTS="$(echo "$ENV_PORTS" | tr ' ' '\n' | sort -u | grep '^')"
EXECUTE_PRE_INSTALL="docker stop $CONTAINER_NAME;docker rm -f $CONTAINER_NAME"
EXECUTE_DOCKER_CMD="docker run -d --name=$CONTAINER_NAME $SET_LABELS $SET_LINK --shm-size=$CONTAINER_SHM_SIZE $DOCKER_OPTS $SET_CAP $SET_SYSCTL --hostname $CONTAINER_HOSTNAME --env TZ=$HOST_TIMEZONE --env ENV_PORTS=\"$ENV_PORTS\" --env TIMEZONE=$HOST_TIMEZONE $SET_ENV $SET_DEV $SET_MNT $SET_PORT $CUSTOM_ARGUMENTS $HOST_NETWORK_TYPE $HUB_IMAGE_URL:$HUB_IMAGE_TAG $CONTAINER_COMMANDS"
EXECUTE_DOCKER_CMD="${EXECUTE_DOCKER_CMD//  / }"
if cmd_exists docker-compose && [ -f "$INSTDIR/docker-compose.yml" ]; then
  printf_yellow "Installing containers using docker-compose"
  sed -i 's|REPLACE_DATADIR|'$DATADIR'' "$INSTDIR/docker-compose.yml"
  if cd "$INSTDIR"; then
    EXECUTE_DOCKER_CMD=""
    __sudo docker-compose pull &>/dev/null
    __sudo docker-compose up -d &>/dev/null
  fi
elif [ -f "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME" ]; then
  EXECUTE_DOCKER_SCRIPT="$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
else
  EXECUTE_DOCKER_ENABLE="yes"
  EXECUTE_DOCKER_SCRIPT="$EXECUTE_DOCKER_CMD"
fi
if [ -n "$EXECUTE_DOCKER_SCRIPT" ]; then
  printf_cyan "Updating the image from $HUB_IMAGE_URL with tag $HUB_IMAGE_TAG"
  __sudo "$EXECUTE_PRE_INSTALL" &>/dev/null
  __sudo docker pull "$HUB_IMAGE_URL" 1>/dev/null 2>"${TMP:-/tmp}/$APPNAME.err.log"
  printf_cyan "Creating container $CONTAINER_NAME"
  if [ "$EXECUTE_DOCKER_ENABLE" = "yes" ]; then
    printf '#!/usr/bin/env bash\n\n%s\n%s\n\n' "$EXECUTE_PRE_INSTALL" "$EXECUTE_DOCKER_CMD" >"$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
    [ -f "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME" ] && chmod -Rf 755 "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
  fi
  if __sudo "$EXECUTE_DOCKER_SCRIPT" 1>/dev/null 2>"${TMP:-/tmp}/$APPNAME.err.log"; then
    rm -Rf "${TMP:-/tmp}/$APPNAME.err.log"
  else
    ERROR_LOG="true"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
if [ "$NGINX_PROXY" = "yes" ]; then
  if [ -z "$NGINX_UPDATE_CONF" ] && [ -f "$INSTDIR/nginx/proxy.conf" ]; then
    cp -f "$INSTDIR/nginx/proxy.conf" "/tmp/$$.$CONTAINER_HOSTNAME.conf"
    sed -i "s|REPLACE_APPNAME|$APPNAME|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_NGINX_PORT|$NGINX_PORT|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_HOST_PROXY|$NGINX_PROXY_URL|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_NGINX_HOST|$CONTAINER_HOSTNAME|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_SERVER_LISTEN_OPTS|$NGINX_LISTEN_OPTS|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    if [ -d "/etc/nginx/vhosts.d" ]; then
      __sudo_root mv -f "/tmp/$$.$CONTAINER_HOSTNAME.conf" "/etc/nginx/vhosts.d/$CONTAINER_HOSTNAME.conf"
      [ -f "/etc/nginx/vhosts.d/$CONTAINER_HOSTNAME.conf" ] && printf_green "[ ✅ ] Copying the nginx configuration"
      systemctl status nginx | grep -q enabled &>/dev/null && __sudo_root systemctl reload nginx &>/dev/null
    else
      mv -f "/tmp/$$.$CONTAINER_HOSTNAME.conf" "$INSTDIR/nginx/$CONTAINER_HOSTNAME.conf" &>/dev/null
    fi
  else
    NGINX_PROXY_URL=""
  fi
  SERVER_URL="$CONTAINER_HTTP_PROTO://$CONTAINER_HOSTNAME:$PRETTY_PORT"
  [ -f "/etc/nginx/vhosts.d/$CONTAINER_HOSTNAME.conf" ] && NGINX_PROXY_URL="$CONTAINER_HTTP_PROTO://$CONTAINER_HOSTNAME"
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
    printf_yellow "This container does not have services configured"
  else
    for service in $SET_PORT; do
      service="${service//\/*/}"
      listen="${service//0.0.0.0/$HOST_LISTEN_ADDR}"
      printf_blue "$service is running on: $listen"
    done
    for service in $HOST_WEB_PORT; do
      service="${service//\/*/}"
      listen="${service//0.0.0.0/$HOST_LISTEN_ADDR}"
      printf_blue "Web service is running on: $CONTAINER_HTTP_PROTO://$listen"
    done
  fi
  [ -z "$SET_USER_NAME" ] || printf_cyan "Username is:  $SET_USER_NAME"
  [ -z "$SET_USER_PASS" ] || printf_purple "Password is:  $SET_USER_PASS"
  __show_post_message
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
