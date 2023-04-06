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
# @@Description      :  Container installer script for GEN_SCRIPT_REPLACE_APPNAME
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  Completely rewrite/refactor/variable cleanup
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
trap 'retVal=$?;trap_exit' ERR EXIT SIGINT
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
# Repository variables
REPO="${DOCKERMGRREPO:-https://github.com/dockermgr}/GEN_SCRIPT_REPLACE_APPNAME"
APPVERSION="$(__appversion "$REPO/raw/${GIT_REPO_BRANCH:-main}/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults variables
APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
export APPDIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME"
export DATADIR="$HOME/.local/share/srv/docker/GEN_SCRIPT_REPLACE_APPNAME/rootfs"
export INSTDIR="$HOME/.local/share/CasjaysDev/dockermgr/GEN_SCRIPT_REPLACE_APPNAME"
export DOCKERMGR_CONFIG_DIR="${DOCKERMGR_CONFIG_DIR:-$HOME/.config/myscripts/dockermgr}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
dockermgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# trap the cleanup function
trap_exit
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a certain version
dockermgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Custom required functions
__sudo() { [ -n "$(type -P 'sudo')" ] && sudo -n true && sudo -HE "$@" || eval "$*" || return 1; }
__sudo_root() { [ -n "$(type -P 'sudo')" ] && sudo -n true && ask_for_password true && sudo "$@" || eval "$*" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__remove_extra_spaces() { sed 's/\( \)*/\1/g;s|^ ||g'; }
__port() { echo "$((50000 + $RANDOM % 1000))" | grep '^' || return 1; }
__docker_check() { [ -n "$(type -p docker 2>/dev/null)" ] || return 1; }
__password() { cat "/dev/urandom" | tr -dc '0-9a-zA-Z' | head -c${1:-16} && echo ""; }
__docker_ps() { docker ps -a 2>&1 | grep -qs "$CONTAINER_NAME" && return 0 || return 1; }
__enable_ssl() { { [ "$SSL_ENABLED" = "yes" ] || [ "$SSL_ENABLED" = "true" ]; } && return 0 || return 1; }
__ssl_certs() { [ -f "$HOST_SSL_CA" ] && [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ] && return 0 || return 1; }
__host_name() { hostname -f 2>/dev/null | grep '\.' | grep '^' || hostname -f 2>/dev/null | grep '^' || echo "$HOSTNAME"; }
__container_name() { echo "$HUB_IMAGE_URL-${HUB_IMAGE_TAG:-latest}" | awk -F '/' '{print $(NF-1)"-"$NF}' | grep '^' || return 1; }
__docker_init() { [ -n "$(type -p dockermgr 2>/dev/null)" ] && dockermgr init || printf_exit "Failed to Initialize the docker installer"; }
__domain_name() { hostname -f 2>/dev/null | awk -F '.' '{print $(NF-1)"."$NF}' | grep '\.' | grep '^' || hostname -f 2>/dev/null | grep '^' || return 1; }
__port_in_use() { { [ -d "/etc/nginx/vhosts.d" ] && grep -wRsq "${1:-443}" "/etc/nginx/vhosts.d" || netstat -taupln 2>/dev/null | grep '[0-9]:[0-9]' | grep 'LISTEN' | grep -q "${1:-443}"; } && return 1 || return 0; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__route() { [ -n "$(type -P ip)" ] && eval ip route 2>/dev/null || return 1; }
__public_ip() { curl -q -LSsf "http://ifconfig.co" | grep -v '^$' | head -n1 | grep '^'; }
__ifconfig() { [ -n "$(type -P ifconfig)" ] && eval ifconfig "$*" 2>/dev/null || return 1; }
__docker_net_ls() { docker network ls 2>&1 | grep -v 'NETWORK ID' | awk -F ' ' '{print $2}'; }
__docker_gateway_ip() { sudo docker network inspect -f '{{json .IPAM.Config}}' ${HOST_DOCKER_NETWORK:-bridge} 2>/dev/null | jq -r '.[].Gateway' | grep -Ev '^$|null' | head -n1 | grep '^' || echo '172.17.0.1'; }
__docker_net_create() { __docker_net_ls | grep -q "$HOST_DOCKER_NETWORK" && return 0 || { docker network create -d bridge --attachable $HOST_DOCKER_NETWORK &>/dev/null && __docker_net_ls | grep -q "$HOST_DOCKER_NETWORK" && echo "$HOST_DOCKER_NETWORK" && return 0 || return 1; }; }
__local_lan_ip() { [ -n "$SET_LAN_IP" ] && (echo "$SET_LAN_IP" | grep -E '192\.168\.[0-255]\.[0-255]' 2>/dev/null || echo "$SET_LAN_IP" | grep -E '10\.[0-255]\.[0-255]\.[0-255]' 2>/dev/null || echo "$SET_LAN_IP" | grep -E '172\.[10-32]' | grep -v '172\.[10-15]' 2>/dev/null) | grep -v '172\.17' | grep -v '^$' | head -n1 | grep '^' || echo "$CURRENT_IP_4" | grep '^'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure docker is installed
__docker_check || __docker_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define any pre-install scripts
run_pre_install() {

  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define any post-install scripts
run_post_install() {

  return 0
}
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__show_post_message() {

  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "e:,m:,p:,h:,d:" --long "options,env:,mount:,port:,host:,domain:" -n "$APPNAME" -- "$@" 2>/dev/null)
set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  -h | --host) CONTAINER_OPT_HOSTNAME="$2" && shift 2 ;;
  -d | --domain) CONTAINER_OPT_DOMAINNAME="$2" && shift 2 ;;
  -e | --env) CONTAINER_OPT_ENV_VAR="$2 $CONTAINER_OPT_ENV_VAR" && shift 2 ;;
  -m | --mount) CONTAINER_OPT_MOUNT_VAR="$2 $CONTAINER_OPT_ENV_VAR" && shift 2 ;;
  -p | --port) CONTAINER_OPT_PORT_VAR="$2 $CONTAINER_OPT_PORT_VAR" && shift 2 ;;
  --options) shift 1 && echo "Options: -e -p -h -d --options --env --port --host --domain" && exit 1 ;;
  *) break ;;
  esac
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup networking
SET_LAN_DEV=$(__route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}' | grep '^' || echo 'eth0')
SET_LAN_IP=$(__ifconfig $SET_LAN_DEV | grep -w 'inet' | awk -F ' ' '{print $2}' | grep -vE '127\.[0-255]\.[0-255]\.[0-255]' | tr ' ' '\n' | head -n1 | grep '^' || echo '')
SET_LAN_IP="${SET_LAN_IP:-$(__local_lan_ip)}"
SET_DOCKER_IP="$(__docker_gateway_ip)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get variables from env
ENV_HOSTNAME="${ENV_HOSTNAME:-$SET_HOSTNAME}"
ENV_DOMAINNAME="${ENV_DOMAINNAME:-$SET_DOMAIN}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get variables from host
SET_LOCAL_HOSTNAME=$(__host_name)
SET_LOCAL_DOMAINNAME=$(__domain_name)
SET_LONG_HOSTNAME=$(hostname -f 2>/dev/null | grep '^')
SET_SHORT_HOSTNAME=$(hostname -s 2>/dev/null | grep '^')
SET_DOMAIN_NAME=$(hostname -d 2>/dev/null | grep '^' || echo 'home')
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set hostname and domain
SET_HOST_SHORT_HOST="${SET_LOCAL_HOSTNAME:-$SET_SHORT_HOSTNAME}"
SET_HOST_FULL_HOST="${SET_LOCAL_HOSTNAME:-$SET_LONG_HOSTNAME}"
SET_HOST_FULL_DOMAIN="${SET_LOCAL_DOMAINNAME:-$SET_DOMAIN_NAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define folders
HOST_DATA_DIR="$DATADIR/data"
HOST_CONFIG_DIR="$DATADIR/config"
LOCAL_DATA_DIR="${LOCAL_DATA_DIR:-$HOST_DATA_DIR}"
LOCAL_CONFIG_DIR="${LOCAL_CONFIG_DIR:-$HOST_CONFIG_DIR}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup server mounts
HOST_SSL_DIR="${HOST_SSL_DIR:-/etc/ssl/CA}"
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
# URL to container image - docker pull - [URL]
HUB_IMAGE_URL="casjaysdevdocker/GEN_SCRIPT_REPLACE_APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# image tag - [docker pull HUB_IMAGE_URL:tag]
HUB_IMAGE_TAG="latest"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the container name Default: [org-repo-tag]
CONTAINER_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this if the container depend on external file/app
CONTAINER_REQUIRES=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container timezone - Default: [America/New_York]
CONTAINER_TIMEZONE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the working dir - [/root]
CONTAINER_WORK_DIR=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the html dir - [/data/www/html] [WWW_ROOT_DIR]
CONTAINER_HTML_DIR=""
CONTAINER_HTML_ENV=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container user and group ID - [yes/no] [id]
USER_ID_ENABLED="no"
CONTAINER_USER_ID=""
CONTAINER_GROUP_ID=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set runas user - default root - [mysql]
CONTAINER_USER_RUN=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable privileged container - [ yes/no ]
CONTAINER_PRIVILEGED_ENABLED="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the SHM Size - Default: 64M - [128M]
CONTAINER_SHM_SIZE="128M"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the RAM Size in Megs - [1024]
CONTAINER_RAM_SIZE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the SWAP Size in Megs - [512]
CONTAINER_SWAP_SIZE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the number of cpus - [2]
CONTAINER_CPU_COUNT="2"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Restart container - [no/always/on-failure/unless-stopped]
CONTAINER_AUTO_RESTART="always"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete container after exit - [yes/no]
CONTAINER_AUTO_DELETE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable tty and interactive - [yes/no]
CONTAINER_TTY_ENABLED="yes"
CONTAINER_INTERACTIVE_ENABLED="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create an env file - [yes/no] [/config/.env]
CONTAINER_ENV_FILE_ENABLED="no"
CONTAINER_ENV_FILE_MOUNT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable cgroups - [yes/no] [/sys/fs/cgroup]
CGROUPS_ENABLED="no"
CGROUPS_MOUNTS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set location to resolv.conf - [yes/no] [/etc/resolv.conf]
HOST_RESOLVE_ENABLED="no"
HOST_RESOLVE_FILE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable hosts /etc/hosts file - [yes/no] [/usr/local/etc/hosts]
HOST_ETC_HOSTS_ENABLED="yes"
HOST_ETC_HOSTS_MOUNT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker socket - [yes/no] [/var/run/docker.sock]
DOCKER_SOCKET_ENABLED="no"
DOCKER_SOCKET_MOUNT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker config - [yes/no] [~/.docker/config.json] [/root/.docker/config.json]
DOCKER_CONFIG_ENABLED="no"
HOST_DOCKER_CONFIG=""
CONTAINER_DOCKER_CONFIG_FILE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount soundcard - [yes/no] [/dev/snd] [/dev/snd]
DOCKER_SOUND_ENABLED="no"
HOST_SOUND_DEVICE="/dev/snd"
CONTAINER_SOUND_DEVICE_FILE="/dev/snd"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable display in container - [yes/no] [0] [/tmp/.X11-unix] [~/.Xauthority]
CONTAINER_X11_ENABLED="no"
HOST_X11_DISPLAY=""
HOST_X11_SOCKET=""
HOST_X11_XAUTH=""
CONTAINER_X11_SOCKET="/tmp/.X11-unix"
CONTAINER_X11_XAUTH="/home/x11user/.Xauthority"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container hostname and domain - Default: [GEN_SCRIPT_REPLACE_APPNAME.$SET_HOST_FULL_HOST] [$SET_HOST_FULL_DOMAIN]
CONTAINER_HOSTNAME=""
CONTAINER_DOMAINNAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the network type - default is bridge - [bridge/host]
HOST_DOCKER_NETWORK="bridge"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Link to an existing container - [name:alias,name]
HOST_DOCKER_LINK=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set listen type - Default all - [all/local/lan/docker/public]
HOST_NETWORK_ADDR="all"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup nginx proxy variables - [yes/no] [yes/no] [http] [https] [yes/no]
HOST_NGINX_ENABLED="yes"
HOST_NGINX_SSL_ENABLED="yes"
HOST_NGINX_HTTP_PORT="80"
HOST_NGINX_HTTPS_PORT="443"
HOST_NGINX_UPDATE_CONF="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable this if container is running a webserver - [yes/no] [internalPort] [yes/no] [yes/no] [listen]
CONTAINER_WEB_SERVER_ENABLED="no"
CONTAINER_WEB_SERVER_INT_PORT="80"
CONTAINER_WEB_SERVER_SSL_ENABLED="no"
CONTAINER_WEB_SERVER_AUTH_ENABLED="no"
CONTAINER_WEB_SERVER_LISTEN_ON="127.0.0.10"
CONTAINER_WEB_SERVER_VHOSTS=""
CONTAINER_WEB_SERVER_CONFIG_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# mail settings - [yes/no] [user] [domainname] [server]
CONTAINER_EMAIL_ENABLED=""
CONTAINER_EMAIL_USER=""
CONTAINER_EMAIL_DOMAIN=""
CONTAINER_EMAIL_RELAY=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add service port - [port]
CONTAINER_SERVICE_PORT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add custom port - [port] or [port:port]
CONTAINER_ADD_CUSTOM_PORT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add custom listening ports - [listen:externalPort:internalPort/[tcp,udp]]
CONTAINER_ADD_CUSTOM_LISTEN=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to the protocol the the container will use - [http/https/git/ftp/pgsql/mysql/mongodb]
CONTAINER_PROTOCOL="http"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Database settings - [listen] [yes/no]
CONTAINER_DATABASE_LISTEN=""
CONTAINER_REDIS_ENABLED=""
CONTAINER_SQLITE3_ENABLED=""
CONTAINER_MARIADB_ENABLED=""
CONTAINER_MONGODB_ENABLED=""
CONTAINER_COUCHDB_ENABLED=""
CONTAINER_POSTGRES_ENABLED=""
CONTAINER_SUPABASE_ENABLED=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Database root user - [user] [pass/random]
CONTAINER_DATABASE_USER_ROOT=""
CONTAINER_DATABASE_PASS_ROOT=""
CONTAINER_DATABASE_LENGTH_ROOT="20"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Database non-root user - [user] [pass/random]
CONTAINER_DATABASE_USER_NORMAL=""
CONTAINER_DATABASE_PASS_NORMAL=""
CONTAINER_DATABASE_LENGTH_NORMAL="20"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set a username and password - [user] [pass/random]
CONTAINER_USER_NAME=""
CONTAINER_USER_PASS=""
CONTAINER_PASS_LENGTH="18"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container username and password env name - [CONTAINER_ENV_USER_NAME=$CONTAINER_USER_NAME]
CONTAINER_ENV_USER_NAME=""
CONTAINER_ENV_PASS_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add the names of processes - [apache,mysql]
CONTAINER_SERVICES_LIST=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount container data dir - [yes/no] [/data]
CONTAINER_MOUNT_DATA_ENABLED="yes"
CONTAINER_MOUNT_DATA_MOUNT_DIR=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount container config dir - [yes/no] [/config]
CONTAINER_MOUNT_CONFIG_ENABLED="yes"
CONTAINER_MOUNT_CONFIG_MOUNT_DIR=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional mounts - [/dir:/dir,/otherdir:/otherdir]
CONTAINER_MOUNTS=""
CONTAINER_MOUNTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional devices - [/dev:/dev,/otherdev:/otherdev]
CONTAINER_DEVICES=""
CONTAINER_DEVICES+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional variables - [myvar=var,myothervar=othervar]
CONTAINER_ENV=""
CONTAINER_ENV+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set sysctl - []
CONTAINER_SYSCTL=""
CONTAINER_SYSCTL+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set capabilites - [CAP,OTHERCAP]
CONTAINER_CAPABILITIES="SYS_ADMIN,SYS_TIME,"
CONTAINER_CAPABILITIES+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define labels - [traefik.enable=true,label=label,otherlabel=label2]
CONTAINER_LABELS=""
CONTAINER_LABELS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Specify container arguments - will run in container  -[/path/to/script]
CONTAINER_COMMANDS=""
CONTAINER_COMMANDS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional docker arguments - see docker run --help - [--option arg1,--option2]
DOCKER_CUSTOM_ARGUMENTS=""
DOCKER_CUSTOM_ARGUMENTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable debugging - [yes/no] [Eex]
CONTAINER_DEBUG_ENABLED="no"
CONTAINER_DEBUG_OPTIONS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# additional directories to create - [/config/dir1,/data/dir2]
CONTAINER_CREATE_DIRECTORY=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show post install message
POST_SHOW_FINISHED_MESSAGE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom container enviroment variables - [--env MYVAR="VAR"]
__custom_docker_env() {
  cat <<EOF | tee | sed 's|,| --env |g' | tr '\n' ' ' | __remove_extra_spaces

EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# this function will create an env file in the containers filesystem - see CONTAINER_ENV_FILE_ENABLED
__container_import_variables() {
  [ "$CONTAINER_ENV_FILE_ENABLED" = "yes" ] || return 0
  local base_dir="" base_file="$1"
  base_dir="$(realpath "$DATADIR")/$(dirname "$base_file")"
  [ -d "$base_dir" ] || mkdir -p "$base_dir"
  cat <<EOF | __remove_extra_spaces | tee "$base_dir/$base_file" &>/dev/null

EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__dockermgr_variables() {
  [ -d "$DOCKERMGR_CONFIG_DIR/env" ] || mkdir -p "$DOCKERMGR_CONFIG_DIR/env"
  cat <<EOF | tee | tr '|' '\n' | __remove_extra_spaces
# Enviroment variables for $APPNAME
ENV_SET_LAN_DEV="${ENV_SET_LAN_DEV:-$SET_LAN_DEV}"
ENV_SET_LAN_IP="${ENV_SET_LAN_IP:-$SET_LAN_IP}"
ENV_SET_LAN_IP="${ENV_SET_LAN_IP:-$SET_LAN_IP}"
ENV_SET_DOCKER_IP="${ENV_SET_DOCKER_IP:-$SET_DOCKER_IP}"
ENV_SET_LOCAL_HOSTNAME="${ENV_SET_LOCAL_HOSTNAME:-$SET_LOCAL_HOSTNAME}"
ENV_SET_LOCAL_DOMAINNAME="${ENV_SET_LOCAL_DOMAINNAME:-$SET_LOCAL_DOMAINNAME}"
ENV_SET_LONG_HOSTNAME="${ENV_SET_LONG_HOSTNAME:-$SET_LONG_HOSTNAME}"
ENV_SET_SHORT_HOSTNAME="${ENV_SET_SHORT_HOSTNAME:-$SET_SHORT_HOSTNAME}"
ENV_SET_DOMAIN_NAME="${ENV_SET_DOMAIN_NAME:-$SET_DOMAIN_NAME}"
ENV_SET_HOST_SHORT_HOST="${ENV_SET_HOST_SHORT_HOST:-$SET_HOST_SHORT_HOST}"
ENV_SET_HOST_FULL_HOST="${ENV_SET_HOST_FULL_HOST:-$SET_HOST_FULL_HOST}"
ENV_SET_HOST_FULL_DOMAIN="${ENV_SET_HOST_FULL_DOMAIN:-$SET_HOST_FULL_DOMAIN}"
ENV_HOST_DATA_DIR="${ENV_HOST_DATA_DIR:-$HOST_DATA_DIR}"
ENV_HOST_CONFIG_DIR="${ENV_HOST_CONFIG_DIR:-$HOST_CONFIG_DIR}"
ENV_HOST_SSL_DIR="${ENV_HOST_SSL_DIR:-$HOST_SSL_DIR}"
ENV_HOST_SSL_CA="${ENV_HOST_SSL_CA:-$HOST_SSL_CA}"
ENV_HOST_SSL_CRT="${ENV_HOST_SSL_CRT:-$HOST_SSL_CRT}"
ENV_HOST_SSL_KEY="${ENV_HOST_SSL_KEY:-$HOST_SSL_KEY}"
ENV_CONTAINER_SSL_DIR="${ENV_CONTAINER_SSL_DIR:-$CONTAINER_SSL_DIR}"
ENV_CONTAINER_SSL_CA="${ENV_CONTAINER_SSL_CA:-$CONTAINER_SSL_CA}"
ENV_CONTAINER_SSL_CRT="${ENV_CONTAINER_SSL_CRT:-$CONTAINER_SSL_CRT}"
ENV_CONTAINER_SSL_KEY="${ENV_CONTAINER_SSL_KEY:-$CONTAINER_SSL_KEY}"
ENV_CONTAINER_NAME="${ENV_CONTAINER_NAME:-$CONTAINER_NAME}"
ENV_CONTAINER_REQUIRES="${ENV_CONTAINER_REQUIRES:-$CONTAINER_REQUIRES}"
ENV_CONTAINER_TIMEZONE="${ENV_CONTAINER_TIMEZONE:-$CONTAINER_TIMEZONE}"
ENV_CONTAINER_WORK_DIR="${ENV_CONTAINER_WORK_DIR:-$CONTAINER_WORK_DIR}"
ENV_CONTAINER_HTML_DIR="${ENV_CONTAINER_HTML_DIR:-$CONTAINER_HTML_DIR}"
ENV_CONTAINER_HTML_ENV="${ENV_CONTAINER_HTML_ENV:-$CONTAINER_HTML_ENV}"
ENV_CONTAINER_USER_ID="${ENV_CONTAINER_USER_ID:-$CONTAINER_USER_ID}"
ENV_CONTAINER_GROUP_ID="${ENV_CONTAINER_GROUP_ID:-$CONTAINER_GROUP_ID}"
ENV_CONTAINER_USER_RUN="${ENV_CONTAINER_USER_RUN:-$CONTAINER_USER_RUN}"
ENV_CONTAINER_PRIVILEGED_ENABLED="${ENV_CONTAINER_PRIVILEGED_ENABLED:-$CONTAINER_PRIVILEGED_ENABLED}"
ENV_CONTAINER_SHM_SIZE="${ENV_CONTAINER_SHM_SIZE:-$CONTAINER_SHM_SIZE}"
ENV_CONTAINER_RAM_SIZE="${ENV_CONTAINER_RAM_SIZE:-$CONTAINER_RAM_SIZE}"
ENV_CONTAINER_SWAP_SIZE="${ENV_CONTAINER_SWAP_SIZE:-$CONTAINER_SWAP_SIZE}"
ENV_CONTAINER_CPU_COUNT="${ENV_CONTAINER_CPU_COUNT:-$CONTAINER_CPU_COUNT}"
ENV_CONTAINER_AUTO_RESTART="${ENV_CONTAINER_AUTO_RESTART:-$CONTAINER_AUTO_RESTART}"
ENV_CONTAINER_AUTO_DELETE="${ENV_CONTAINER_AUTO_DELETE:-$CONTAINER_AUTO_DELETE}"
ENV_CONTAINER_TTY_ENABLED="${ENV_CONTAINER_TTY_ENABLED:-$CONTAINER_TTY_ENABLED}"
ENV_CONTAINER_INTERACTIVE_ENABLED="${ENV_CONTAINER_INTERACTIVE_ENABLED:-$CONTAINER_INTERACTIVE_ENABLED}"
ENV_CONTAINER_ENV_FILE_ENABLED="${ENV_CONTAINER_ENV_FILE_ENABLED:-$CONTAINER_ENV_FILE_ENABLED}"
ENV_CONTAINER_ENV_FILE_MOUNT="${ENV_CONTAINER_ENV_FILE_MOUNT:-$CONTAINER_ENV_FILE_MOUNT}"
ENV_HOST_RESOLVE_ENABLED="${ENV_HOST_RESOLVE_ENABLED:-$HOST_RESOLVE_ENABLED}"
ENV_HOST_RESOLVE_FILE="${ENV_HOST_RESOLVE_FILE:-$HOST_RESOLVE_FILE}"
ENV_HOST_ETC_HOSTS_ENABLED="${ENV_HOST_ETC_HOSTS_ENABLED:-$HOST_ETC_HOSTS_ENABLED}"
ENV_HOST_ETC_HOSTS_MOUNT="${ENV_HOST_ETC_HOSTS_MOUNT:-$HOST_ETC_HOSTS_MOUNT}"
ENV_HOST_DOCKER_CONFIG="${ENV_HOST_DOCKER_CONFIG:-$HOST_DOCKER_CONFIG}"
ENV_CONTAINER_DOCKER_CONFIG_FILE="${ENV_CONTAINER_DOCKER_CONFIG_FILE:-$CONTAINER_DOCKER_CONFIG_FILE}"
ENV_HOST_SOUND_DEVICE="${ENV_HOST_SOUND_DEVICE:-$HOST_SOUND_DEVICE}"
ENV_CONTAINER_SOUND_DEVICE_FILE="${ENV_CONTAINER_SOUND_DEVICE_FILE:-$CONTAINER_SOUND_DEVICE_FILE}"
ENV_CONTAINER_X11_ENABLED="${ENV_CONTAINER_X11_ENABLED:-$CONTAINER_X11_ENABLED}"
ENV_HOST_X11_DISPLAY="${ENV_HOST_X11_DISPLAY:-$HOST_X11_DISPLAY}"
ENV_HOST_X11_SOCKET="${ENV_HOST_X11_SOCKET:-$HOST_X11_SOCKET}"
ENV_HOST_X11_XAUTH="${ENV_HOST_X11_XAUTH:-$HOST_X11_XAUTH}"
ENV_CONTAINER_X11_SOCKET="${ENV_CONTAINER_X11_SOCKET:-$CONTAINER_X11_SOCKET}"
ENV_CONTAINER_X11_XAUTH="${ENV_CONTAINER_X11_XAUTH:-$CONTAINER_X11_XAUTH}"
ENV_CONTAINER_HOSTNAME="${ENV_CONTAINER_HOSTNAME:-$CONTAINER_HOSTNAME}"
ENV_CONTAINER_DOMAINNAME="${ENV_CONTAINER_DOMAINNAME:-$CONTAINER_DOMAINNAME}"
ENV_HOST_DOCKER_NETWORK="${ENV_HOST_DOCKER_NETWORK:-$HOST_DOCKER_NETWORK}"
ENV_HOST_DOCKER_LINK="${ENV_HOST_DOCKER_LINK:-$HOST_DOCKER_LINK}"
ENV_HOST_NETWORK_ADDR="${ENV_HOST_NETWORK_ADDR:-$HOST_NETWORK_ADDR}"
ENV_HOST_NGINX_ENABLED="${ENV_HOST_NGINX_ENABLED:-$HOST_NGINX_ENABLED}"
ENV_HOST_NGINX_SSL_ENABLED="${ENV_HOST_NGINX_SSL_ENABLED:-$HOST_NGINX_SSL_ENABLED}"
ENV_HOST_NGINX_HTTP_PORT="${ENV_HOST_NGINX_HTTP_PORT:-$HOST_NGINX_HTTP_PORT}"
ENV_HOST_NGINX_HTTPS_PORT="${ENV_HOST_NGINX_HTTPS_PORT:-$HOST_NGINX_HTTPS_PORT}"
ENV_HOST_NGINX_UPDATE_CONF="${ENV_HOST_NGINX_UPDATE_CONF:-$HOST_NGINX_UPDATE_CONF}"
ENV_CONTAINER_WEB_SERVER_ENABLED="${ENV_CONTAINER_WEB_SERVER_ENABLED:-$CONTAINER_WEB_SERVER_ENABLED}"
ENV_CONTAINER_WEB_SERVER_INT_PORT="${ENV_CONTAINER_WEB_SERVER_INT_PORT:-$CONTAINER_WEB_SERVER_INT_PORT}"
ENV_CONTAINER_WEB_SERVER_SSL_ENABLED="${ENV_CONTAINER_WEB_SERVER_SSL_ENABLED:-$CONTAINER_WEB_SERVER_SSL_ENABLED}"
ENV_CONTAINER_WEB_SERVER_AUTH_ENABLED="${ENV_CONTAINER_WEB_SERVER_AUTH_ENABLED:-$CONTAINER_WEB_SERVER_AUTH_ENABLED}"
ENV_CONTAINER_WEB_SERVER_LISTEN_ON="${ENV_CONTAINER_WEB_SERVER_LISTEN_ON:-$CONTAINER_WEB_SERVER_LISTEN_ON}"
ENV_CONTAINER_WEB_SERVER_VHOSTS="${ENV_CONTAINER_WEB_SERVER_VHOSTS:-$CONTAINER_WEB_SERVER_VHOSTS}"
ENV_CONTAINER_WEB_SERVER_CONFIG_NAME="${ENV_CONTAINER_WEB_SERVER_CONFIG_NAME:-$CONTAINER_WEB_SERVER_CONFIG_NAME}"
ENV_CONTAINER_SERVICE_PORT="${ENV_CONTAINER_SERVICE_PORT:-$CONTAINER_SERVICE_PORT}"
ENV_CONTAINER_ADD_CUSTOM_PORT="${ENV_CONTAINER_ADD_CUSTOM_PORT:-$CONTAINER_ADD_CUSTOM_PORT}"
ENV_CONTAINER_ADD_CUSTOM_LISTEN="${ENV_CONTAINER_ADD_CUSTOM_LISTEN:-$CONTAINER_ADD_CUSTOM_LISTEN}"
ENV_CONTAINER_PROTOCOL="${ENV_CONTAINER_PROTOCOL:-$CONTAINER_PROTOCOL}"
ENV_CONTAINER_DATABASE_LISTEN="${ENV_CONTAINER_DATABASE_LISTEN:-$CONTAINER_DATABASE_LISTEN}"
ENV_CONTAINER_REDIS_ENABLED="${ENV_CONTAINER_REDIS_ENABLED:-$CONTAINER_REDIS_ENABLED}"
ENV_CONTAINER_SQLITE3_ENABLED="${ENV_CONTAINER_SQLITE3_ENABLED:-$CONTAINER_SQLITE3_ENABLED}"
ENV_CONTAINER_MARIADB_ENABLED="${ENV_CONTAINER_MARIADB_ENABLED:-$CONTAINER_MARIADB_ENABLED}"
ENV_CONTAINER_MONGODB_ENABLED="${ENV_CONTAINER_MONGODB_ENABLED:-$CONTAINER_MONGODB_ENABLED}"
ENV_CONTAINER_COUCHDB_ENABLED="${ENV_CONTAINER_COUCHDB_ENABLED:-$CONTAINER_COUCHDB_ENABLED}"
ENV_CONTAINER_POSTGRES_ENABLED="${ENV_CONTAINER_POSTGRES_ENABLED:-$CONTAINER_POSTGRES_ENABLED}"
ENV_CONTAINER_SUPABASE_ENABLED="${ENV_CONTAINER_SUPABASE_ENABLED:-$CONTAINER_SUPABASE_ENABLED}"
ENV_CONTAINER_DATABASE_USER_ROOT="${ENV_CONTAINER_DATABASE_USER_ROOT:-$CONTAINER_DATABASE_USER_ROOT}"
ENV_CONTAINER_DATABASE_LENGTH_ROOT="${ENV_CONTAINER_DATABASE_LENGTH_ROOT:-$CONTAINER_DATABASE_LENGTH_ROOT}"
ENV_CONTAINER_DATABASE_USER_NORMAL="${ENV_CONTAINER_DATABASE_USER_NORMAL:-$CONTAINER_DATABASE_USER_NORMAL}"
ENV_CONTAINER_DATABASE_LENGTH_NORMAL="${ENV_CONTAINER_DATABASE_LENGTH_NORMAL:-$CONTAINER_DATABASE_LENGTH_NORMAL}"
ENV_CONTAINER_USER_NAME="${ENV_CONTAINER_USER_NAME:-$CONTAINER_USER_NAME}"
ENV_CONTAINER_USER_PASS="${ENV_CONTAINER_USER_PASS:-$CONTAINER_USER_PASS}"
ENV_CONTAINER_PASS_LENGTH="${ENV_CONTAINER_PASS_LENGTH:-$CONTAINER_PASS_LENGTH}"
ENV_CONTAINER_ENV_USER_NAME="${ENV_CONTAINER_ENV_USER_NAME:-$CONTAINER_ENV_USER_NAME}"
ENV_CONTAINER_EMAIL_ENABLED="${ENV_CONTAINER_EMAIL_ENABLED:-$CONTAINER_EMAIL_ENABLED}"
ENV_CONTAINER_EMAIL_USER="${ENV_CONTAINER_EMAIL_USER:-$CONTAINER_EMAIL_USER}"
ENV_CONTAINER_EMAIL_DOMAIN="${ENV_CONTAINER_EMAIL_DOMAIN:-$CONTAINER_EMAIL_DOMAIN}"
ENV_CONTAINER_EMAIL_RELAY="${ENV_CONTAINER_EMAIL_RELAY:-$CONTAINER_EMAIL_RELAY}"
ENV_CONTAINER_SERVICES_LIST="${ENV_CONTAINER_SERVICES_LIST:-$CONTAINER_SERVICES_LIST}"
ENV_CONTAINER_MOUNT_DATA_ENABLED="${ENV_CONTAINER_MOUNT_DATA_ENABLED:-$CONTAINER_MOUNT_DATA_ENABLED}"
ENV_CONTAINER_MOUNT_DATA_MOUNT_DIR="${ENV_CONTAINER_MOUNT_DATA_MOUNT_DIR:-$CONTAINER_MOUNT_DATA_MOUNT_DIR}"
ENV_CONTAINER_MOUNT_CONFIG_ENABLED="${ENV_CONTAINER_MOUNT_CONFIG_ENABLED:-$CONTAINER_MOUNT_CONFIG_ENABLED}"
ENV_CONTAINER_MOUNT_CONFIG_MOUNT_DIR="${ENV_CONTAINER_MOUNT_CONFIG_MOUNT_DIR:-$CONTAINER_MOUNT_CONFIG_MOUNT_DIR}"
ENV_CONTAINER_MOUNTS="${ENV_CONTAINER_MOUNTS:-$CONTAINER_MOUNTS}"
ENV_CONTAINER_DEVICES="${ENV_CONTAINER_DEVICES:-$CONTAINER_DEVICES}"
ENV_CONTAINER_ENV="${ENV_CONTAINER_ENV:-$CONTAINER_ENV}"
ENV_CONTAINER_SYSCTL="${ENV_CONTAINER_SYSCTL:-$CONTAINER_SYSCTL}"
ENV_CONTAINER_CAPABILITIES="${ENV_CONTAINER_CAPABILITIES:-$CONTAINER_CAPABILITIES}"
ENV_CONTAINER_LABELS="${ENV_CONTAINER_LABELS:-$CONTAINER_LABELS}"
ENV_CONTAINER_COMMANDS="${ENV_CONTAINER_COMMANDS:-$CONTAINER_COMMANDS}"
ENV_CONTAINER_DEBUG_ENABLED="${ENV_CONTAINER_DEBUG_ENABLED:-$CONTAINER_DEBUG_ENABLED}"
ENV_CONTAINER_DEBUG_OPTIONS="${ENV_CONTAINER_DEBUG_OPTIONS:-$CONTAINER_DEBUG_OPTIONS}"

EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__dockermgr_password_variables() {
  [ -d "$DOCKERMGR_CONFIG_DIR/secure" ] || mkdir -p "$DOCKERMGR_CONFIG_DIR/secure"
  cat <<EOF | tee | tr '|' '\n' | __remove_extra_spaces
# Enviroment variables for $APPNAME
ENV_CONTAINER_ENV_PASS_NAME="${ENV_CONTAINER_ENV_PASS_NAME:-$CONTAINER_ENV_PASS_NAME}"
ENV_CONTAINER_DATABASE_PASS_ROOT="${ENV_CONTAINER_DATABASE_PASS_ROOT:-$CONTAINER_DATABASE_PASS_ROOT}"
ENV_CONTAINER_DATABASE_PASS_NORMAL="${ENV_CONTAINER_DATABASE_PASS_NORMAL:-$CONTAINER_DATABASE_PASS_NORMAL}"

EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define extra functions
__rport() {
  local port=""
  port="$(__port)"
  while :; do
    { [ $port -lt 50000 ] && [ $port -gt 50999 ]; } && port="$(__port)"
    __port_in_use "$port" && break
  done
  echo "$port" | head -n1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__trim() {
  local var="$*"
  var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
  printf '%s' "$var" | grep -v '^$' | __remove_extra_spaces
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import variables from a file
[ -f "$INSTDIR/env.sh" ] && . "$INSTDIR/env.sh"
[ -f "$APPDIR/env.sh" ] && . "$APPDIR/env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/.env.sh" ] && . "$DOCKERMGR_CONFIG_DIR/.env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/env/$APPNAME" ] && . "$DOCKERMGR_CONFIG_DIR/env/$APPNAME"
[ -f "$DOCKERMGR_CONFIG_DIR/env/custom.$APPNAME" ] && . "$DOCKERMGR_CONFIG_DIR/env/custom.$APPNAME"
[ -r "$DOCKERMGR_CONFIG_DIR/secure/$APPNAME" ] && . "$DOCKERMGR_CONFIG_DIR/secure/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Initialize the installer
dockermgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run pre-install commands
execute "run_pre_install" "Running pre-installation commands"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ensure_dirs
ensure_perms
mkdir -p "$DOCKERMGR_CONFIG_DIR/env"
mkdir -p "$DOCKERMGR_CONFIG_DIR/secure"
mkdir -p "$DOCKERMGR_CONFIG_DIR/scripts"
mkdir -p "$DOCKERMGR_CONFIG_DIR/installed"
mkdir -p "$DOCKERMGR_CONFIG_DIR/containers"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# fix directory permissions
chmod -f 777 "$APPDIR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# variable cleanup

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# verify required file exists
if [ -n "$CONTAINER_REQUIRES" ]; then
  CONTAINER_REQUIRES="${CONTAINER_REQUIRES//,/}"
  for required in $CONTAINER_REQUIRES; do
    if [ ! -e "$required" ] || [ -z "$(type "$required" 2>/dev/null)" ]; then
      required_missing="$required $required_missing"
    fi
  done
  [ "$required_missing" != " " ] || unset required_missing
  if [ -n "$required_missing" ]; then
    echo "Missing required: $required_missing"
    exit 1
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite variables from env file
SET_LAN_DEV="${ENV_SET_LAN_DEV:-$SET_LAN_DEV}"
SET_LAN_IP="${ENV_SET_LAN_IP:-$SET_LAN_IP}"
SET_LAN_IP="${ENV_SET_LAN_IP:-$SET_LAN_IP}"
SET_DOCKER_IP="${ENV_SET_DOCKER_IP:-$SET_DOCKER_IP}"
SET_LOCAL_HOSTNAME="${ENV_SET_LOCAL_HOSTNAME:-$SET_LOCAL_HOSTNAME}"
SET_LOCAL_DOMAINNAME="${ENV_SET_LOCAL_DOMAINNAME:-$SET_LOCAL_DOMAINNAME}"
SET_LONG_HOSTNAME="${ENV_SET_LONG_HOSTNAME:-$SET_LONG_HOSTNAME}"
SET_SHORT_HOSTNAME="${ENV_SET_SHORT_HOSTNAME:-$SET_SHORT_HOSTNAME}"
SET_DOMAIN_NAME="${ENV_SET_DOMAIN_NAME:-$SET_DOMAIN_NAME}"
SET_HOST_SHORT_HOST="${ENV_SET_HOST_SHORT_HOST:-$SET_HOST_SHORT_HOST}"
SET_HOST_FULL_HOST="${ENV_SET_HOST_FULL_HOST:-$SET_HOST_FULL_HOST}"
SET_HOST_FULL_DOMAIN="${ENV_SET_HOST_FULL_DOMAIN:-$SET_HOST_FULL_DOMAIN}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
HOST_DATA_DIR="${ENV_HOST_DATA_DIR:-$HOST_DATA_DIR}"
HOST_CONFIG_DIR="${ENV_HOST_CONFIG_DIR:-$HOST_CONFIG_DIR}"
HOST_SSL_DIR="${ENV_HOST_SSL_DIR:-$HOST_SSL_DIR}"
HOST_SSL_CA="${ENV_HOST_SSL_CA:-$HOST_SSL_CA}"
HOST_SSL_CRT="${ENV_HOST_SSL_CRT:-$HOST_SSL_CRT}"
HOST_SSL_KEY="${ENV_HOST_SSL_KEY:-$HOST_SSL_KEY}"
HOST_RESOLVE_ENABLED="${ENV_HOST_RESOLVE_ENABLED:-$HOST_RESOLVE_ENABLED}"
HOST_RESOLVE_FILE="${ENV_HOST_RESOLVE_FILE:-$HOST_RESOLVE_FILE}"
HOST_ETC_HOSTS_ENABLED="${ENV_HOST_ETC_HOSTS_ENABLED:-$HOST_ETC_HOSTS_ENABLED}"
HOST_ETC_HOSTS_MOUNT="${ENV_HOST_ETC_HOSTS_MOUNT:-$HOST_ETC_HOSTS_MOUNT}"
HOST_DOCKER_CONFIG="${ENV_HOST_DOCKER_CONFIG:-$HOST_DOCKER_CONFIG}"
HOST_SOUND_DEVICE="${ENV_HOST_SOUND_DEVICE:-$HOST_SOUND_DEVICE}"
HOST_X11_DISPLAY="${ENV_HOST_X11_DISPLAY:-$HOST_X11_DISPLAY}"
HOST_X11_SOCKET="${ENV_HOST_X11_SOCKET:-$HOST_X11_SOCKET}"
HOST_X11_XAUTH="${ENV_HOST_X11_XAUTH:-$HOST_X11_XAUTH}"
HOST_DOCKER_NETWORK="${ENV_HOST_DOCKER_NETWORK:-$HOST_DOCKER_NETWORK}"
HOST_DOCKER_LINK="${ENV_HOST_DOCKER_LINK:-$HOST_DOCKER_LINK}"
HOST_NETWORK_ADDR="${ENV_HOST_NETWORK_ADDR:-$HOST_NETWORK_ADDR}"
HOST_NGINX_ENABLED="${ENV_HOST_NGINX_ENABLED:-$HOST_NGINX_ENABLED}"
HOST_NGINX_SSL_ENABLED="${ENV_HOST_NGINX_SSL_ENABLED:-$HOST_NGINX_SSL_ENABLED}"
HOST_NGINX_HTTP_PORT="${ENV_HOST_NGINX_HTTP_PORT:-$HOST_NGINX_HTTP_PORT}"
HOST_NGINX_HTTPS_PORT="${ENV_HOST_NGINX_HTTPS_PORT:-$HOST_NGINX_HTTPS_PORT}"
HOST_NGINX_UPDATE_CONF="${ENV_HOST_NGINX_UPDATE_CONF:-$HOST_NGINX_UPDATE_CONF}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_NAME="${ENV_CONTAINER_NAME:-}"
CONTAINER_HOSTNAME="${ENV_HOSTNAME:-}"
CONTAINER_DOMAINNAME="${ENV_DOMAINNAME:-$CONTAINER_DOMAINNAME}"
CONTAINER_SSL_DIR="${ENV_CONTAINER_SSL_DIR:-$CONTAINER_SSL_DIR}"
CONTAINER_SSL_CA="${ENV_CONTAINER_SSL_CA:-$CONTAINER_SSL_CA}"
CONTAINER_SSL_CRT="${ENV_CONTAINER_SSL_CRT:-$CONTAINER_SSL_CRT}"
CONTAINER_SSL_KEY="${ENV_CONTAINER_SSL_KEY:-$CONTAINER_SSL_KEY}"
CONTAINER_REQUIRES="${ENV_CONTAINER_REQUIRES:-$CONTAINER_REQUIRES}"
CONTAINER_TIMEZONE="${ENV_CONTAINER_TIMEZONE:-$CONTAINER_TIMEZONE}"
CONTAINER_WORK_DIR="${ENV_CONTAINER_WORK_DIR:-$CONTAINER_WORK_DIR}"
CONTAINER_HTML_DIR="${ENV_CONTAINER_HTML_DIR:-$CONTAINER_HTML_DIR}"
CONTAINER_HTML_ENV="${ENV_CONTAINER_HTML_ENV:-$CONTAINER_HTML_ENV}"
CONTAINER_USER_ID="${ENV_CONTAINER_USER_ID:-$CONTAINER_USER_ID}"
CONTAINER_GROUP_ID="${ENV_CONTAINER_GROUP_ID:-$CONTAINER_GROUP_ID}"
CONTAINER_USER_RUN="${ENV_CONTAINER_USER_RUN:-$CONTAINER_USER_RUN}"
CONTAINER_PRIVILEGED_ENABLED="${ENV_CONTAINER_PRIVILEGED_ENABLED:-$CONTAINER_PRIVILEGED_ENABLED}"
CONTAINER_SHM_SIZE="${ENV_CONTAINER_SHM_SIZE:-$CONTAINER_SHM_SIZE}"
CONTAINER_RAM_SIZE="${ENV_CONTAINER_RAM_SIZE:-$CONTAINER_RAM_SIZE}"
CONTAINER_SWAP_SIZE="${ENV_CONTAINER_SWAP_SIZE:-$CONTAINER_SWAP_SIZE}"
CONTAINER_CPU_COUNT="${ENV_CONTAINER_CPU_COUNT:-$CONTAINER_CPU_COUNT}"
CONTAINER_AUTO_RESTART="${ENV_CONTAINER_AUTO_RESTART:-$CONTAINER_AUTO_RESTART}"
CONTAINER_AUTO_DELETE="${ENV_CONTAINER_AUTO_DELETE:-$CONTAINER_AUTO_DELETE}"
CONTAINER_TTY_ENABLED="${ENV_CONTAINER_TTY_ENABLED:-$CONTAINER_TTY_ENABLED}"
CONTAINER_INTERACTIVE_ENABLED="${ENV_CONTAINER_INTERACTIVE_ENABLED:-$CONTAINER_INTERACTIVE_ENABLED}"
CONTAINER_ENV_FILE_ENABLED="${ENV_CONTAINER_ENV_FILE_ENABLED:-$CONTAINER_ENV_FILE_ENABLED}"
CONTAINER_ENV_FILE_MOUNT="${ENV_CONTAINER_ENV_FILE_MOUNT:-$CONTAINER_ENV_FILE_MOUNT}"
CONTAINER_DOCKER_CONFIG_FILE="${ENV_CONTAINER_DOCKER_CONFIG_FILE:-$CONTAINER_DOCKER_CONFIG_FILE}"
CONTAINER_SOUND_DEVICE_FILE="${ENV_CONTAINER_SOUND_DEVICE_FILE:-$CONTAINER_SOUND_DEVICE_FILE}"
CONTAINER_X11_ENABLED="${ENV_CONTAINER_X11_ENABLED:-$CONTAINER_X11_ENABLED}"
CONTAINER_X11_SOCKET="${ENV_CONTAINER_X11_SOCKET:-$CONTAINER_X11_SOCKET}"
CONTAINER_X11_XAUTH="${ENV_CONTAINER_X11_XAUTH:-$CONTAINER_X11_XAUTH}"
CONTAINER_HOSTNAME="${ENV_CONTAINER_HOSTNAME:-$SET_HOST_FULL_HOST}"
CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-SET_HOST_FULL_DOMAIN}"
CONTAINER_WEB_SERVER_ENABLED="${ENV_CONTAINER_WEB_SERVER_ENABLED:-$CONTAINER_WEB_SERVER_ENABLED}"
CONTAINER_WEB_SERVER_INT_PORT="${ENV_CONTAINER_WEB_SERVER_INT_PORT:-$CONTAINER_WEB_SERVER_INT_PORT}"
CONTAINER_WEB_SERVER_SSL_ENABLED="${ENV_CONTAINER_WEB_SERVER_SSL_ENABLED:-$CONTAINER_WEB_SERVER_SSL_ENABLED}"
CONTAINER_WEB_SERVER_AUTH_ENABLED="${ENV_CONTAINER_WEB_SERVER_AUTH_ENABLED:-$CONTAINER_WEB_SERVER_AUTH_ENABLED}"
CONTAINER_WEB_SERVER_LISTEN_ON="${ENV_CONTAINER_WEB_SERVER_LISTEN_ON:-$CONTAINER_WEB_SERVER_LISTEN_ON}"
CONTAINER_WEB_SERVER_VHOSTS="${ENV_CONTAINER_WEB_SERVER_VHOSTS:-$CONTAINER_WEB_SERVER_VHOSTS}"
CONTAINER_WEB_SERVER_CONFIG_NAME="${ENV_CONTAINER_WEB_SERVER_CONFIG_NAME:-$CONTAINER_WEB_SERVER_CONFIG_NAME}"
CONTAINER_SERVICE_PORT="${ENV_CONTAINER_SERVICE_PORT:-$CONTAINER_SERVICE_PORT}"
CONTAINER_ADD_CUSTOM_PORT="${ENV_CONTAINER_ADD_CUSTOM_PORT:-$CONTAINER_ADD_CUSTOM_PORT}"
CONTAINER_ADD_CUSTOM_LISTEN="${ENV_CONTAINER_ADD_CUSTOM_LISTEN:-$CONTAINER_ADD_CUSTOM_LISTEN}"
CONTAINER_PROTOCOL="${ENV_CONTAINER_PROTOCOL:-$CONTAINER_PROTOCOL}"
CONTAINER_DATABASE_LISTEN="${ENV_CONTAINER_DATABASE_LISTEN:-$CONTAINER_DATABASE_LISTEN}"
CONTAINER_REDIS_ENABLED="${ENV_CONTAINER_REDIS_ENABLED:-$CONTAINER_REDIS_ENABLED}"
CONTAINER_SQLITE3_ENABLED="${ENV_CONTAINER_SQLITE3_ENABLED:-$CONTAINER_SQLITE3_ENABLED}"
CONTAINER_MARIADB_ENABLED="${ENV_CONTAINER_MARIADB_ENABLED:-$CONTAINER_MARIADB_ENABLED}"
CONTAINER_MONGODB_ENABLED="${ENV_CONTAINER_MONGODB_ENABLED:-$CONTAINER_MONGODB_ENABLED}"
CONTAINER_COUCHDB_ENABLED="${ENV_CONTAINER_COUCHDB_ENABLED:-$CONTAINER_COUCHDB_ENABLED}"
CONTAINER_POSTGRES_ENABLED="${ENV_CONTAINER_POSTGRES_ENABLED:-$CONTAINER_POSTGRES_ENABLED}"
CONTAINER_SUPABASE_ENABLED="${ENV_CONTAINER_SUPABASE_ENABLED:-$CONTAINER_SUPABASE_ENABLED}"
CONTAINER_DATABASE_USER_ROOT="${ENV_CONTAINER_DATABASE_USER_ROOT:-$CONTAINER_DATABASE_USER_ROOT}"
CONTAINER_DATABASE_PASS_ROOT="${ENV_CONTAINER_DATABASE_PASS_ROOT:-$CONTAINER_DATABASE_PASS_ROOT}"
CONTAINER_DATABASE_LENGTH_ROOT="${ENV_CONTAINER_DATABASE_LENGTH_ROOT:-$CONTAINER_DATABASE_LENGTH_ROOT}"
CONTAINER_DATABASE_USER_NORMAL="${ENV_CONTAINER_DATABASE_USER_NORMAL:-$CONTAINER_DATABASE_USER_NORMAL}"
CONTAINER_DATABASE_PASS_NORMAL="${ENV_CONTAINER_DATABASE_PASS_NORMAL:-$CONTAINER_DATABASE_PASS_NORMAL}"
CONTAINER_DATABASE_LENGTH_NORMAL="${ENV_CONTAINER_DATABASE_LENGTH_NORMAL:-$CONTAINER_DATABASE_LENGTH_NORMAL}"
CONTAINER_USER_NAME="${ENV_CONTAINER_USER_NAME:-$CONTAINER_USER_NAME}"
CONTAINER_USER_PASS="${ENV_CONTAINER_USER_PASS:-$CONTAINER_USER_PASS}"
CONTAINER_PASS_LENGTH="${ENV_CONTAINER_PASS_LENGTH:-$CONTAINER_PASS_LENGTH}"
CONTAINER_ENV_USER_NAME="${ENV_CONTAINER_ENV_USER_NAME:-$CONTAINER_ENV_USER_NAME}"
CONTAINER_ENV_PASS_NAME="${ENV_CONTAINER_ENV_PASS_NAME:-$CONTAINER_ENV_PASS_NAME}"
CONTAINER_EMAIL_ENABLED="${ENV_CONTAINER_EMAIL_ENABLED:-$CONTAINER_EMAIL_ENABLED}"
CONTAINER_EMAIL_USER="${ENV_CONTAINER_EMAIL_USER:-$CONTAINER_EMAIL_USER}"
CONTAINER_EMAIL_DOMAIN="${ENV_CONTAINER_EMAIL_DOMAIN:-$CONTAINER_EMAIL_DOMAIN}"
CONTAINER_EMAIL_RELAY="${ENV_CONTAINER_EMAIL_RELAY:-$CONTAINER_EMAIL_RELAY}"
CONTAINER_SERVICES_LIST="${ENV_CONTAINER_SERVICES_LIST:-$CONTAINER_SERVICES_LIST}"
CONTAINER_MOUNT_DATA_ENABLED="${ENV_CONTAINER_MOUNT_DATA_ENABLED:-$CONTAINER_MOUNT_DATA_ENABLED}"
CONTAINER_MOUNT_DATA_MOUNT_DIR="${ENV_CONTAINER_MOUNT_DATA_MOUNT_DIR:-$CONTAINER_MOUNT_DATA_MOUNT_DIR}"
CONTAINER_MOUNT_CONFIG_ENABLED="${ENV_CONTAINER_MOUNT_CONFIG_ENABLED:-$CONTAINER_MOUNT_CONFIG_ENABLED}"
CONTAINER_MOUNT_CONFIG_MOUNT_DIR="${ENV_CONTAINER_MOUNT_CONFIG_MOUNT_DIR:-$CONTAINER_MOUNT_CONFIG_MOUNT_DIR}"
CONTAINER_MOUNTS="${ENV_CONTAINER_MOUNTS:-$CONTAINER_MOUNTS}"
CONTAINER_DEVICES="${ENV_CONTAINER_DEVICES:-$CONTAINER_DEVICES}"
CONTAINER_ENV="${ENV_CONTAINER_ENV:-$CONTAINER_ENV}"
CONTAINER_SYSCTL="${ENV_CONTAINER_SYSCTL:-$CONTAINER_SYSCTL}"
CONTAINER_CAPABILITIES="${ENV_CONTAINER_CAPABILITIES:-$CONTAINER_CAPABILITIES}"
CONTAINER_LABELS="${ENV_CONTAINER_LABELS:-$CONTAINER_LABELS}"
CONTAINER_COMMANDS="${ENV_CONTAINER_COMMANDS:-$CONTAINER_COMMANDS}"
CONTAINER_DEBUG_ENABLED="${ENV_CONTAINER_DEBUG_ENABLED:-$CONTAINER_DEBUG_ENABLED}"
CONTAINER_DEBUG_OPTIONS="${ENV_CONTAINER_DEBUG_OPTIONS:-$CONTAINER_DEBUG_OPTIONS}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup arrays
DOCKER_SET_PUBLISH=""
CONTAINER_CONTAINER_ENV_PORTS=()
DOCKER_SET_TMP_PUBLISH=()
DOCKER_SET_OPTIONS=()
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure that the image has a tag
if [ -z "$HUB_IMAGE_TAG" ]; then
  HUB_IMAGE_TAG="latest"
fi
if [ -z "$HUB_IMAGE_URL" ] || [ "$HUB_IMAGE_URL" = " " ]; then
  printf_exit "Please set the url to the containers image"
elif echo "$HUB_IMAGE_URL" | grep -q ':'; then
  HUB_IMAGE_URL="$(echo "$HUB_IMAGE_URL" | awk -F':' '{print $1}')"
  HUB_IMAGE_TAG="$(echo "$HUB_IMAGE_URL" | awk -F':' '{print $2}')"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set containers name
if [ -z "$CONTAINER_NAME" ]; then
  CONTAINER_NAME="$(__container_name || echo "casjaysdevdocker/GEN_SCRIPT_REPLACE_APPNAME-$HUB_IMAGE_TAG")"
fi
DOCKER_SET_OPTIONS+=("--name=$CONTAINER_NAME")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup time zone
if [ -z "$CONTAINER_TIMEZONE" ]; then
  CONTAINER_TIMEZONE="America/New_York"
fi
DOCKER_SET_OPTIONS+=("--env TZ=$CONTAINER_TIMEZONE")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set working dir
if [ -n "$CONTAINER_WORK_DIR" ]; then
  DOCKER_SET_OPTIONS+=("--workdir $CONTAINER_WORK_DIR")
  DOCKER_SET_OPTIONS+=("--env WORKDIR=$CONTAINER_WORK_DIR")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the html directory
if [ -n "$CONTAINER_HTML_DIR" ]; then
  if [ -z "$CONTAINER_HTML_ENV" ]; then
    CONTAINER_HTML_ENV="WWW_ROOT_DIR"
  fi
  DOCKER_SET_OPTIONS+=("--env $CONTAINER_HTML_ENV=$CONTAINER_HTML_DIR")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set user ID
if [ "$USER_ID_ENABLED" = "yes" ]; then
  if [ -z "$CONTAINER_USER_ID" ]; then
    DOCKER_SET_OPTIONS+=("--env PUID=$(id -u)")
  else
    DOCKER_SET_OPTIONS+=("--env PUID=$CONTAINER_USER_ID")
  fi
  if [ -z "$CONTAINER_GROUP_ID" ]; then
    DOCKER_SET_OPTIONS+=("--env PGID=$(id -g)")
  else
    DOCKER_SET_OPTIONS+=("--env PGID=$CONTAINER_GROUP_ID")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the process owner
if [ -n "$CONTAINER_USER_RUN" ]; then
  DOCKER_SET_OPTIONS+=("--env USER=$CONTAINER_USER_RUN")
  DOCKER_SET_OPTIONS+=("--env SERVICE_USER=$CONTAINER_USER_RUN")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run the container privileged
if [ "$CONTAINER_PRIVILEGED_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS+=("--privileged")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set ram size
if [ -n "$CONTAINER_RAM_SIZE" ]; then
  CONTAINER_RAM_SIZE=$((1024 * 1024 * $CONTAINER_RAM_SIZE))
  DOCKER_SET_OPTIONS+=("--memory $CONTAINER_RAM_SIZE")
  unset CONTAINER_RAM_SIZE
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set swap size
if [ -n "$CONTAINER_SWAP_SIZE" ]; then
  CONTAINER_SWAP_SIZE=$((1024 * 1024 * $CONTAINER_SWAP_SIZE))
  DOCKER_SET_OPTIONS+=("--memory-swap $CONTAINER_SWAP_SIZE")
  unset CONTAINER_SWAP_SIZE
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set CPU count
if [ -n "$CONTAINER_CPU_COUNT" ]; then
  DOCKER_SET_OPTIONS+=("--cpus $CONTAINER_CPU_COUNT")
  unset CONTAINER_CPU_COUNT
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the containers SHM size
if [ -z "$CONTAINER_SHM_SIZE" ]; then
  DOCKER_SET_OPTIONS+=("--shm-size=128M")
else
  DOCKER_SET_OPTIONS+=("--shm-size=$CONTAINER_SHM_SIZE")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Auto restart the container
if [ -z "$CONTAINER_AUTO_RESTART" ]; then
  DOCKER_SET_OPTIONS+=("--restart unless-stopped")
else
  DOCKER_SET_OPTIONS+=("--restart=$CONTAINER_AUTO_RESTART")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Only run the container to execute command and then delete
if [ "$CONTAINER_AUTO_DELETE" = "yes" ]; then
  DOCKER_SET_OPTIONS+=("--rm")
  CONTAINER_AUTO_RESTART=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable the tty
if [ "$CONTAINER_TTY_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS+=("--tty")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run in interactive mode
if [ "$CONTAINER_INTERACTIVE_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS+=("--interactive")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount cgroups in the container
if [ "$CGROUPS_ENABLED" = "yes" ]; then
  if [ -z "$CGROUPS_MOUNTS" ]; then
    DOCKER_SET_OPTIONS+=("--volume /sys/fs/cgroup:/sys/fs/cgroup:ro")
  else
    DOCKER_SET_OPTIONS+=("--volume $CGROUPS_MOUNTS")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount hosts resolv.conf in the container
if [ "$HOST_RESOLVE_ENABLED" = "yes" ]; then
  if [ -z "$HOST_RESOLVE_FILE" ]; then
    DOCKER_SET_OPTIONS+=("--volume /etc/resolv.conf:/etc/resolv.conf:ro")
  else
    DOCKER_SET_OPTIONS+=("--volume $HOST_RESOLVE_FILE:/etc/resolv.conf:ro")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount the docker socket
if [ "$DOCKER_SOCKET_ENABLED" = "yes" ]; then
  if [ -z "$DOCKER_SOCKET_MOUNT" ]; then
    DOCKER_SET_OPTIONS+=("--volume /var/run/docker.sock:/var/run/docker.sock")
  else
    DOCKER_SET_OPTIONS+=("--volume $DOCKER_SOCKET_MOUNT:/var/run/docker.sock")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker config in the container
if [ "$DOCKER_CONFIG_ENABLED" = "yes" ]; then
  if [ -z "$CONTAINER_DOCKER_CONFIG_FILE" ]; then
    CONTAINER_DOCKER_CONFIG_FILE="/root/.docker/config.json"
  fi
  if [ -n "$HOST_DOCKER_CONFIG" ]; then
    DOCKER_SET_OPTIONS+=("--volume $HOST_DOCKER_CONFIG:$CONTAINER_DOCKER_CONFIG_FILE:ro")
  elif [ -f "$HOME/.docker/config.json" ]; then
    DOCKER_SET_OPTIONS+=("--volume $HOME/.docker/config.json:$CONTAINER_DOCKER_CONFIG_FILE:ro")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount sound card in container
if [ "$DOCKER_SOUND_ENABLED" = "yes" ]; then
  if [ -z "$HOST_SOUND_DEVICE_FILE" ]; then
    HOST_SOUND_DEVICE_FILE="/dev/snd"
  fi
  if [ -z "$CONTAINER_SOUND_DEVICE_FILE" ]; then
    CONTAINER_SOUND_DEVICE_FILE="/dev/snd"
  fi
  if [ -n "$HOST_SOUND_DEVICE_FILE" ] && [ -n "$CONTAINER_SOUND_DEVICE_FILE" ]; then
    DOCKER_SET_OPTIONS+=("--device $HOST_SOUND_DEVICE_FILE:$CONTAINER_SOUND_DEVICE_FILE")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup display if enabled
if [ "$CONTAINER_X11_ENABLED" = "yes" ]; then
  if [ -z "$HOST_X11_DISPLAY" ] && [ -n "$DISPLAY" ]; then
    HOST_X11_DISPLAY="${DISPLAY//*:/}"
  fi
  if [ -z "$HOST_X11_SOCKET" ]; then
    HOST_X11_SOCKET="/tmp/.X11-unix"
  fi
  if [ -z "$HOST_X11_XAUTH" ]; then
    HOST_X11_XAUTH="$HOME/.Xauthority"
  fi
  if [ -n "$HOST_X11_DISPLAY" ] && [ -n "$HOST_X11_SOCKET" ] && [ -n "$HOST_X11_XAUTH" ]; then
    DOCKER_SET_OPTIONS+=("--env DISPLAY=:$HOST_X11_DISPLAY")
    DOCKER_SET_OPTIONS+=("--volume $HOST_X11_SOCKET:${CONTAINER_X11_SOCKET:-/tmp/.X11-unix}")
    DOCKER_SET_OPTIONS+=("--volume $HOST_X11_XAUTH:${CONTAINER_X11_XAUTH:-/home/x11user/.Xauthority}")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if [ "$HOST_ETC_HOSTS_ENABLED" = "yes" ]; then
  if [ -z "$HOST_ETC_HOSTS_MOUNT" ]; then
    HOST_ETC_HOSTS_MOUNT="/usr/local/etc/host"
  fi
  DOCKER_SET_OPTIONS+=("--volume /etc/hosts:$HOST_ETC_HOSTS_MOUNT:ro")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup containers hostname
if [[ "$SET_HOST_FULL_HOST" = server.* ]] && [ -z "$CONTAINER_HOSTNAME" ]; then
  CONTAINER_HOSTNAME="$APPNAME.$SET_HOST_FULL_DOMAIN"
else
  CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-$SET_HOST_FULL_DOMAIN}"
  CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-$APPNAME.$SET_HOST_FULL_HOST}"
fi
if [ -n "$CONTAINER_HOSTNAME" ]; then
  DOCKER_SET_OPTIONS+=("--hostname $CONTAINER_HOSTNAME")
  DOCKER_SET_OPTIONS+=("--env HOSTNAME=$CONTAINER_HOSTNAME")
else
  DOCKER_SET_OPTIONS+=("--hostname $CONTAINER_NAME")
  DOCKER_SET_OPTIONS+=("--env HOSTNAME=$CONTAINER_NAME")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the domain name
if [ -n "$CONTAINER_DOMAINNAME" ]; then
  DOCKER_SET_OPTIONS+=("--domainname $CONTAINER_DOMAINNAME")
  DOCKER_SET_OPTIONS+=("--env DOMAINNAME=$CONTAINER_DOMAINNAME")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the docker network
if [ "$HOST_DOCKER_NETWORK" = "host" ]; then
  DOCKER_SET_OPTIONS+=("--net-host")
else
  if [ -z "$HOST_DOCKER_NETWORK" ]; then
    HOST_DOCKER_NETWORK="bridge"
  fi
  DOCKER_SET_OPTIONS+=("--network $HOST_DOCKER_NETWORK")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create network if needed
DOCKER_CREATE_NET="$(__docker_net_create)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Container listen address [address:extPort:intPort]
if [ "$HOST_NETWORK_ADDR" = "public" ]; then
  HOST_DEFINE_LISTEN=0.0.0.0
  HOST_LISTEN_ADDR=$(__public_ip)
elif [ "$HOST_NETWORK_ADDR" = "lan" ]; then
  HOST_DEFINE_LISTEN=$(__local_lan_ip)
  HOST_LISTEN_ADDR=$(__local_lan_ip)
elif [ "$HOST_NETWORK_ADDR" = "local" ]; then
  HOST_DEFINE_LISTEN="127.0.0.1"
  HOST_LISTEN_ADDR="127.0.0.1"
  CONTAINER_PRIVATE="yes"
elif [ "$HOST_NETWORK_ADDR" = "docker" ]; then
  HOST_DEFINE_LISTEN="$SET_DOCKER_IP"
  HOST_LISTEN_ADDR="$SET_DOCKER_IP"
elif [ "$HOST_NETWORK_ADDR" = "yes" ]; then
  HOST_DEFINE_LISTEN="127.0.0.1"
  HOST_LISTEN_ADDR="127.0.0.1"
  CONTAINER_PRIVATE="yes"
else
  HOST_DEFINE_LISTEN=0.0.0.0
  HOST_LISTEN_ADDR=$(__local_lan_ip)
fi
if [ "$HOST_LISTEN_ADDR" = "0.0.0.0" ]; then
  HOST_LISTEN_ADDR="$SET_LAN_IP"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if [ "$HOST_NGINX_ENABLED" = "yes" ]; then
  if [ "$HOST_NGINX_SSL_ENABLED" = "yes" ] && [ -n "$HOST_NGINX_HTTPS_PORT" ]; then
    NGINX_LISTEN_OPTS="ssl http2"
    NGINX_PORT="${HOST_NGINX_HTTPS_PORT:-443}"
  else
    NGINX_PORT="${HOST_NGINX_HTTP_PORT:-80}"
  fi
  if [ -f "/etc/nginx/nginx.conf" ] && [ -w "/etc/nginx" ]; then
    NGINX_DIR="/etc/nginx"
  else
    NGINX_DIR="$HOME/.config/nginx"
  fi
  if [ "$CONTAINER_WEB_SERVER_AUTH_ENABLED" = "yes" ]; then
    NGINX_AUTH_DIR="$NGINX_DIR/auth"
    CONTAINER_USER_NAME="${CONTAINER_USER_NAME:-root}"
    CONTAINER_USER_PASS="${CONTAINER_USER_PASS:-$RANDOM_PASS}"
    if [ ! -d "$NGINX_AUTH_DIR" ]; then
      mkdir -p "$NGINX_AUTH_DIR"
    fi
    if [ -n "$(builtin type -P htpasswd)" ]; then
      if ! grep -q "$CONTAINER_USER_NAME"; then
        printf_yellow "Creating auth $NGINX_AUTH_DIR/$APPNAME"
        if [ -f "$NGINX_AUTH_DIR/$APPNAME" ]; then
          htpasswd -b "$NGINX_AUTH_DIR/$APPNAME" "$CONTAINER_USER_NAME" "$CONTAINER_USER_PASS" &>/dev/null
        else
          htpasswd -b -c "$NGINX_AUTH_DIR/$APPNAME" "$CONTAINER_USER_NAME" "$CONTAINER_USER_PASS" &>/dev/null
        fi
      fi
    fi
  fi
  if [ "$HOST_NGINX_UPDATE_CONF" = "yes" ]; then
    mkdir -p "$NGINX_DIR/vhosts.d"
  fi
  if [ ! -f "$NGINX_DIR/vhosts.d/$NGINX_CONFIG_NAME.conf" ]; then
    HOST_NGINX_UPDATE_CONF="yes"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup containers web server
if [ "$CONTAINER_WEB_SERVER_ENABLED" = "yes" ]; then
  if [ "$CONTAINER_WEB_SERVER_SSL_ENABLED" = "yes" ]; then
    DOCKER_SET_OPTIONS+=("--env SSL_ENABLED=true")
  fi
  if [ -n "$CONTAINER_WEB_SERVER_INT_PORT" ]; then
    CONTAINER_WEB_SERVER_INT_PORT="${CONTAINER_WEB_SERVER_INT_PORT//,/ }"
    DOCKER_SET_OPTIONS+=("--env WEB_PORT=\"$CONTAINER_WEB_SERVER_INT_PORT\"")
  fi
  if [ "$CONTAINER_WEB_SERVER_SSL_ENABLED" = "yes" ]; then
    CONTAINER_PROTOCOL="https"
  else
    CONTAINER_PROTOCOL="http"
  fi
  if [ -z "$CONTAINER_WEB_SERVER_LISTEN_ON" ]; then
    CONTAINER_WEB_SERVER_LISTEN_ON="$HOST_LISTEN_ADDR"
  fi
  NGINX_PROXY_ADDRESS="${CONTAINER_WEB_SERVER_LISTEN_ON:-$HOST_LISTEN_ADDR}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL setup
NGINX_PROXY_URL=""
PROXY_HTTP_PROTO="$CONTAINER_PROTOCOL"
if [ "$NGINX_SSL" = "yes" ]; then
  if [ "$SSL_ENABLED" = "yes" ]; then
    PROXY_HTTP_PROTO="https"
  fi
  if [ "$PROXY_HTTP_PROTO" = "https" ]; then
    NGINX_PROXY_URL="$PROXY_HTTP_PROTO://$NGINX_PROXY_ADDRESS:$NGINX_PROXY_PORT"
    if [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ]; then
      if [ -f "$CONTAINER_SSL_CA" ]; then
        CONTAINER_MOUNTS+="$HOST_SSL_CA:$CONTAINER_SSL_CA "
      fi
      CONTAINER_MOUNTS+="$HOST_SSL_CRT:$CONTAINER_SSL_CRT "
      CONTAINER_MOUNTS+="$HOST_SSL_KEY:$CONTAINER_SSL_KEY "
    fi
  fi
else
  CONTAINER_PROTOCOL="${CONTAINER_PROTOCOL:-http}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup ports
SET_SERVER_PORTS_TMP=""
if [ -n "$CONTAINER_ADD_CUSTOM_PORT" ]; then
  SET_SERVER_PORTS_TMP+="${CONTAINER_ADD_CUSTOM_PORT//,/ }"
fi
if [ -n "$SET_SERVER_PORTS_TMP" ]; then
  SET_SERVER_PORTS="$SET_SERVER_PORTS_TMP"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup the listen address
if [ -n "$HOST_DEFINE_LISTEN" ]; then
  SET_LISTEN_ADDRESS="${HOST_DEFINE_LISTEN//:*/}"
fi
if [ -n "$CONTAINER_ADD_CUSTOM_LISTEN" ]; then
  CONTAINER_ADD_CUSTOM_LISTEN="${CONTAINER_ADD_CUSTOM_LISTEN//,/ }"
fi
HOST_LISTEN_ADDR="${HOST_LISTEN_ADDR:-$HOST_DEFINE_LISTEN}"
HOST_LISTEN_ADDR="${HOST_LISTEN_ADDR//0.0.0.0/$SET_LAN_IP}"
HOST_LISTEN_ADDR="${HOST_LISTEN_ADDR//:*/}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if [ "$CONTAINER_HTTPS_PORT" != "" ]; then
  CONTAINER_PROTOCOL="https"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Database setup
if [ -z "$CONTAINER_DATABASE_LISTEN" ]; then
  CONTAINER_DATABASE_LISTEN="0.0.0.0"
fi
if [ -z "$DATABASE_BASE_DIR" ]; then
  DATABASE_BASE_DIR="/data/db"
  DOCKER_SET_OPTIONS+=("--env DATABASE_BASE_DIR=$DATABASE_BASE_DIR")
fi
if [ "$CONTAINER_REDIS_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_ENV_PORTS+=("6379")
  CONTAINER_DATABASE_ENABLED="yes"
  MESSAGE_REDIS="Database files are saved to:      $DATABASE_DIR_REDIS"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:6379:6379")
  DATABASE_DIR_REDIS="${DATABASE_DIR_REDIS:-$DATABASE_BASE_DIR/redis}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_DATA_DIR/db/redis:/$DATABASE_DIR_REDIS:z")
  DOCKER_SET_OPTIONS+=("--env DATABASE_DIR_REDIS=$DATABASE_DIR_REDIS")
  CONTAINER_DATABASE_PROTO="redis://$HOST_LISTEN_ADDR:6379"
fi
if [ "$CONTAINER_SQLITE3_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  DATABASE_DIR_SQLITE3="${DATABASE_DIR_SQLITE3:-$DATABASE_BASE_DIR/sqlite3}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_DATA_DIR/db/sqlite3:/$DATABASE_DIR_SQLITE3:z")
  DOCKER_SET_OPTIONS+=("--env DATABASE_DIR_SQLITE3=$DATABASE_DIR_SQLITE3")
  CONTAINER_DATABASE_PROTO="sqlite3://$DATABASE_DIR_SQLITE3"
  MESSAGE_SQLITE3="Database files are saved to:      $DATABASE_DIR_SQLITE3"
  CONTAINER_CREATE_DIRECTORY="$DATABASE_DIR_SQLITE3 $CONTAINER_CREATE_DIRECTORY"
fi
if [ "$CONTAINER_POSTGRES_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_ENV_PORTS+=("5432")
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:5432:5432")
  DATABASE_DIR_POSTGRES="${DATABASE_DIR_POSTGRES:-$DATABASE_BASE_DIR/pgsql}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_DATA_DIR/db/postgres:/$DATABASE_DIR_POSTGRES:z")
  DOCKER_SET_OPTIONS+=("--env DATABASE_DIR_POSTGRES=$DATABASE_DIR_POSTGRES")
  CONTAINER_DATABASE_PROTO="postgresql://$HOST_LISTEN_ADDR:5432"
  MESSAGE_PGSQL="Database files are saved to:      $DATABASE_DIR_POSTGRES"
fi
if [ "$CONTAINER_MARIADB_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_ENV_PORTS+=("3306")
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:3306:3306")
  DATABASE_DIR_MARIADB="${DATABASE_DIR_MARIADB:-$DATABASE_BASE_DIR/mariadb}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_DATA_DIR/db/mariadb:/$DATABASE_DIR_MARIADB:z")
  DOCKER_SET_OPTIONS+=("--env DATABASE_DIR_MARIADB=$DATABASE_DIR_MARIADB")
  CONTAINER_DATABASE_PROTO="mysql://$HOST_LISTEN_ADDR:3306"
  MESSAGE_MARIADB="Database files are saved to:      $DATABASE_DIR_MARIADB"
fi
if [ "$CONTAINER_COUCHDB_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_ENV_PORTS+=("5984")
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:5984:5984")
  DATABASE_DIR_COUCHDB="${DATABASE_DIR_COUCHDB:-$DATABASE_BASE_DIR/couchdb}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_DATA_DIR/db/couchdb:/$DATABASE_DIR_COUCHDB:z")
  DOCKER_SET_OPTIONS+=("--env DATABASE_DIR_COUCHDB=$DATABASE_DIR_COUCHDB")
  MESSAGE_COUCHDB="Database files are saved to:      $DATABASE_DIR_COUCHDB"
  CONTAINER_DATABASE_PROTO="http://$HOST_LISTEN_ADDR:5984"
fi
if [ "$CONTAINER_MONGODB_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_ENV_PORTS+=("27017")
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:27017:27017")
  DATABASE_DIR_MONGODB="${DATABASE_DIR_MONGODB:-$DATABASE_BASE_DIR/mongodb}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_DATA_DIR/db/mongodb:/$DATABASE_DIR_MONGODB:z")
  DOCKER_SET_OPTIONS+=("--env DATABASE_DIR_MONGODB=$DATABASE_DIR_MONGODB")
  MESSAGE_MONGODB="Database files are saved to:      $DATABASE_DIR_MONGODB"
  CONTAINER_DATABASE_PROTO="mongodb://$HOST_LISTEN_ADDR:27017"
fi
if [ "$CONTAINER_SUPABASE_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_ENV_PORTS+=("5432")
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:5432:5432")
  DATABASE_DIR_SUPABASE="${DATABASE_DIR_SUPABASE:-$DATABASE_BASE_DIR/supabase}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_DATA_DIR/db/supabase:/$DATABASE_DIR_SUPABASE:z")
  DOCKER_SET_OPTIONS+=("--env DATABASE_DIR_SUPABASE=$DATABASE_DIR_SUPABASE")
  MESSAGE_SUPABASE="Database files are saved to:      $DATABASE_DIR_SUPABASE"
  CONTAINER_DATABASE_PROTO="http://$HOST_LISTEN_ADDR:8000"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if [ "$CONTAINER_DATABASE_ENABLED" = "yes" ]; then
  if [ -n "$CONTAINER_DATABASE_USER_ROOT" ]; then
    DOCKER_SET_OPTIONS+=("--env DATABASE_USER_ROOT=${CONTAINER_DATABASE_USER_ROOT:-root}")
  fi
  if [ -n "$CONTAINER_DATABASE_PASS_ROOT" ]; then
    if [ "$CONTAINER_DATABASE_PASS_ROOT" = "random" ]; then
      CONTAINER_DATABASE_PASS_ROOT="$(__password "${CONTAINER_DATABASE_LENGTH_ROOT:-12}")"
    fi
    DOCKER_SET_OPTIONS+=("--env DATABASE_PASS_ROOT=$CONTAINER_DATABASE_PASS_ROOT")
  fi
  if [ -n "$CONTAINER_DATABASE_USER_NORMAL" ]; then
    DOCKER_SET_OPTIONS+=("--env DATABASE_USER_NORMAL=${CONTAINER_DATABASE_USER_NORMAL:-$USER}")
  fi
  if [ -n "$CONTAINER_DATABASE_PASS_NORMAL" ]; then
    if [ "$CONTAINER_DATABASE_PASS_NORMAL" = "random" ]; then
      CONTAINER_DATABASE_PASS_NORMAL="$(__password "${CONTAINER_DATABASE_LENGTH_NORMAL:-12}")"
    fi
    DOCKER_SET_OPTIONS+=("--env DATABASE_PASS_NORMAL=$CONTAINER_DATABASE_PASS_NORMAL")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# containers username and password configuration
if [ -n "$GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME" ]; then
  CONTAINER_USER_NAME="$GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME"
fi
if [ -n "$CONTAINER_USER_NAME" ]; then
  CONTAINER_USER_NAME="${GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME:-${CONTAINER_USER_NAME:-$DEFAULT_USERNAME}}"
fi
if [ -n "$CONTAINER_USER_NAME" ]; then
  if [ -n "$CONTAINER_ENV_USER_NAME" ]; then
    DOCKER_SET_OPTIONS+=("--env ${CONTAINER_ENV_USER_NAME:-username}=\"$CONTAINER_USER_NAME\"")
  fi
fi
if [ -n "$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD" ]; then
  CONTAINER_USER_PASS="$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD"
fi
if [ -n "$CONTAINER_USER_PASS" ]; then
  if [ "$CONTAINER_USER_PASS" = "random" ]; then
    CONTAINER_USER_PASS="$(__password "${CONTAINER_PASS_LENGTH:-16}")"
  fi
  CONTAINER_USER_PASS="${GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD:-${CONTAINER_USER_PASS:-$DEFAULT_PASSWORD}}"
fi
if [ -n "$CONTAINER_USER_PASS" ]; then
  if [ -n "$CONTAINER_ENV_PASS_NAME" ]; then
    DOCKER_SET_OPTIONS+=("--env ${CONTAINER_ENV_PASS_NAME:-PASSWORD}=\"$CONTAINER_USER_PASS\"")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup email variables
if [ "$CONTAINER_EMAIL_ENABLED" = "yes" ]; then
  if [ -n "$CONTAINER_EMAIL_DOMAIN" ]; then
    DOCKER_SET_OPTIONS+=("--env EMAIL_DOMAIN=$CONTAINER_EMAIL_DOMAIN")
  fi
  if [ -n "$CONTAINER_EMAIL_RELAY" ]; then
    DOCKER_SET_OPTIONS+=("--env EMAIL_RELAY=$CONTAINER_EMAIL_RELAY")
  fi
  if [ -n "$CONTAINER_EMAIL_USER" ]; then
    DOCKER_SET_OPTIONS+=("--env EMAIL_ADMIN=$CONTAINER_EMAIL_USER@")
  fi
  if [ -z "$CONTAINER_EMAIL_PORTS" ]; then
    CONTAINER_EMAIL_PORTS="25,465,587"
  fi
  CONTAINER_EMAIL_PORTS="$(echo "${CONTAINER_EMAIL_PORTS//,/ }" | tr ' ' '\n')"
  DOCKER_SET_OPTIONS+=("--env EMAIL_ENABLED=$CONTAINER_EMAIL_ENABLED")
  CONTAINER_ENV_PORTS+=("$CONTAINER_EMAIL_PORTS")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# process list
if [ -n "$CONTAINER_SERVICES_LIST" ]; then
  DOCKER_SET_OPTIONS+=("--env PROCS_LIST=$CONTAINER_SERVICES_LIST")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup data mount point
if [ "$CONTAINER_MOUNT_DATA_ENABLED" = "yes" ]; then
  if [ -z "$CONTAINER_MOUNT_DATA_MOUNT_DIR" ]; then
    CONTAINER_MOUNT_DATA_MOUNT_DIR="/data"
  fi
  CONTAINER_MOUNT_DATA_MOUNT_DIR="${CONTAINER_MOUNT_DATA_MOUNT_DIR//:*/}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_DATA_DIR:$CONTAINER_MOUNT_DATA_MOUNT_DIR:z")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set config mount point
if [ "$CONTAINER_MOUNT_CONFIG_ENABLED" = "yes" ]; then
  if [ -z "$CONTAINER_MOUNT_CONFIG_MOUNT_DIR" ]; then
    CONTAINER_MOUNT_CONFIG_MOUNT_DIR="/config"
  fi
  CONTAINER_MOUNT_CONFIG_MOUNT_DIR="${CONTAINER_MOUNT_CONFIG_MOUNT_DIR//:*/}"
  DOCKER_SET_OPTIONS+=("--volume $LOCAL_CONFIG_DIR:$CONTAINER_MOUNT_CONFIG_MOUNT_DIR:z")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# additional docker arguments
if [ -n "$DOCKER_CUSTOM_ARGUMENTS" ]; then
  DOCKER_CUSTOM_ARGUMENTS="${DOCKER_CUSTOM_ARGUMENTS//,/ }"
  DOCKER_SET_OPTIONS+=("$DOCKER_CUSTOM_ARGUMENTS")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# debugging
if [ "$CONTAINER_DEBUG_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS+=("--env DEBUGGER=on")
  if [ -n "$CONTAINER_DEBUG_OPTIONS" ]; then
    DOCKER_SET_OPTIONS+=("--env DEBUGGER_OPTIONS=$CONTAINER_DEBUG_OPTIONS")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Send command to container
if [ -n "$CONTAINER_COMMANDS" ]; then
  CONTAINER_COMMANDS="${CONTAINER_COMMANDS//,/ } "
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup links
if [ -n "$HOST_DOCKER_LINK" ]; then
  for link in $HOST_DOCKER_LINK; do
    [ -n "$link" ] && DOCKER_SET_LINK="--link $link "
  done
  link=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup mounts
if [ -n "$CONTAINER_MOUNTS" ]; then
  DOCKER_SET_MNT=""
  CONTAINER_MOUNTS="${CONTAINER_MOUNTS//,/ }"
  for mnt in $CONTAINER_MOUNTS; do
    if [ "$mnt" != "" ] && [ "$mnt" != " " ]; then
      echo "$mnt" | grep -q ':' || mnt="$mnt:$mnt"
      DOCKER_SET_MNT+="--volume $mnt "
    fi
  done
  mnt=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_OPT_MOUNT_VAR" ]; then
  DOCKER_SET_MNT=""
  CONTAINER_OPT_MOUNT_VAR="${CONTAINER_OPT_MOUNT_VAR//,/ }"
  for mnt in $CONTAINER_OPT_MOUNT_VAR; do
    if [ "$mnt" != "" ] && [ "$mnt" != " " ]; then
      echo "$mnt" | grep -q ':' || mnt="$mnt:$mnt"
      DOCKER_SET_MNT+="--volume $mnt "
    fi
  done
  mnt=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup devices
if [ -n "$CONTAINER_DEVICES" ]; then
  DOCKER_SET_DEV=""
  CONTAINER_DEVICES="${CONTAINER_DEVICES//,/ }"
  for dev in $CONTAINER_DEVICES; do
    if [ "$dev" != "" ] && [ "$dev" != " " ]; then
      echo "$dev" | grep -q ':' || dev="$dev:$dev"
      DOCKER_SET_DEV+="--device $dev "
    fi
  done
  dev=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup enviroment variables
if [ -n "$CONTAINER_ENV" ]; then
  DOCKER_SET_ENV=""
  CONTAINER_ENV="${CONTAINER_ENV//,/ }"
  for env in $CONTAINER_ENV; do
    if [ "$env" != "" ] && [ "$env" != " " ]; then
      DOCKER_SET_ENV+="--env $env "
    fi
  done
  env=""
fi
if [ -n "$CONTAINER_OPT_ENV_VAR" ]; then
  CONTAINER_OPT_ENV_VAR="${CONTAINER_OPT_ENV_VAR//,/ }"
  for env in $CONTAINER_OPT_ENV_VAR; do
    if [ "$env" != "" ] && [ "$env" != " " ]; then
      DOCKER_SET_ENV+="--env $env "
    fi
  done
  env=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup capabilites
if [ -n "$CONTAINER_CAPABILITIES" ]; then
  DOCKER_SET_CAP=""
  CONTAINER_CAPABILITIES="${CONTAINER_CAPABILITIES//,/ }"
  for cap in $CONTAINER_CAPABILITIES; do
    if [ "$cap" != "" ] && [ "$cap" != " " ]; then
      DOCKER_SET_CAP+="--cap-add $cap "
    fi
  done
  cap=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup sysctl
if [ -n "$CONTAINER_SYSCTL" ]; then
  DOCKER_SET_SYSCTL=""
  CONTAINER_SYSCTL="${CONTAINER_SYSCTL//,/ }"
  for sysctl in $CONTAINER_SYSCTL; do
    if [ "$sysctl" != "" ] && [ "$sysctl" != " " ]; then
      DOCKER_SET_SYSCTL+="--sysctl $sysctl "
    fi
  done
  sysctl=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup container labels
if [ -n "$CONTAINER_LABELS" ]; then
  DOCKER_SET_LABELS=""
  CONTAINER_LABELS="${CONTAINER_LABELS//,/ }"
  for label in $CONTAINER_LABELS; do
    if [ "$label" != "" ] && [ "$label" != " " ]; then
      DOCKER_SET_LABELS+="--label $label "
    fi
  done
  label=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup optional ports
if [ -n "$CONTAINER_OPT_PORT_VAR" ]; then
  CONTAINER_OPT_PORT_VAR="${CONTAINER_OPT_PORT_VAR//,/ }"
  if [ -n "$CONTAINER_OPT_PORT_VAR" ]; then
    for set_port in $CONTAINER_OPT_PORT_VAR; do
      if [ "$set_port" != "" ] && [ "$set_port" != " " ]; then
        port=$set_port
        echo "$port" | grep -q ':' || port="${port//\/*/}:$port"
        DOCKER_SET_TMP_PUBLISH+=("--publish $port")
      fi
    done
    set_port=""
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup ports
if [ -n "$SET_SERVER_PORTS" ]; then
  SET_LISTEN="${HOST_DEFINE_LISTEN//:*/}"
  for set_port in $SET_SERVER_PORTS; do
    if [ "$set_port" != " " ] && [ -n "$set_port" ]; then
      port=$set_port
      echo "$port" | grep -q ':.*.:' || random_port="$(__rport)"
      echo "$port" | grep -q ':' || port="${random_port:-$port//\/*/}:$port"
      if [ "$CONTAINER_PRIVATE" = "yes" ] && [ "$port" = "${IS_PRIVATE//\/*/}" ]; then
        SET_ADDR="${HOST_LISTEN_ADDR:-127.0.0.1}"
        DOCKER_SET_TMP_PUBLISH+=("--publish $SET_ADDR:$port")
      elif [ -n "$SET_LISTEN" ]; then
        DOCKER_SET_TMP_PUBLISH+=("--publish $SET_LISTEN:$port")
      else
        DOCKER_SET_TMP_PUBLISH+=("--publish $port")
      fi
    fi
  done
  set_port=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup custom ports
if [ -n "$CONTAINER_ADD_CUSTOM_LISTEN" ]; then
  for set_port in $CONTAINER_ADD_CUSTOM_LISTEN; do
    if [ "$set_port" != " " ] && [ -n "$set_port" ]; then
      port=${set_port//\/*/}
      echo "$port" | grep -q ':' || port="$port:$port"
      TYPE="$(echo "$set_port" | grep '/' | awk -F '/' '{print $NF}' | head -n1 | grep '^' || echo '')"
      if [ -z "$TYPE" ]; then
        DOCKER_SET_TMP_PUBLISH+=("--publish $port")
      else
        DOCKER_SET_TMP_PUBLISH+=("--publish $port/$TYPE")
      fi
    fi
  done
  set_port=""
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# container web server configuration
SET_WEB_PORT=""
NGINX_PROXY_PORT=""
CLEANUP_PORT="${CONTAINER_WEB_SERVER_INT_PORT:-$CONTAINER_SERVICE_PORT}"
CLEANUP_PORT="${CLEANUP_PORT//\/*/}"
PRETTY_PORT="$CLEANUP_PORT"
if [ "$CONTAINER_WEB_SERVER_ENABLED" = "yes" ]; then
  CONTAINER_WEB_SERVER_INT_PORT="${CONTAINER_WEB_SERVER_INT_PORT//,/ }"
  for set_port in $CONTAINER_WEB_SERVER_INT_PORT; do
    if [ "$set_port" != " " ] && [ -n "$set_port" ]; then
      port=${set_port//\/*/}
      random_port="$(__rport)"
      TYPE="$(echo "$port" | grep '/' | awk -F '/' '{print $NF}' | head -n1 | grep '^' || echo '')"
      if [ -z "$TYPE" ]; then
        DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_WEB_SERVER_LISTEN_ON:$random_port:$port")
      else
        DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_WEB_SERVER_LISTEN_ON:$random_port:$port/$TYPE")
      fi
      SET_WEB_PORT+="$CONTAINER_WEB_SERVER_LISTEN_ON:$random_port "
    fi
  done
  set_port=""
  if [ -n "$SET_WEB_PORT" ]; then
    SET_NGINX_PROXY_PORT="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | awk -F':' '{print $1":"$2}' | grep -v '^$' | tr '\n' ' ' | head -n1 | grep '^')"
  fi
  if [ -n "$SET_WEB_PORT" ]; then
    CLEANUP_PORT="${SET_NGINX_PROXY_PORT//--publish /}"
    CLEANUP_PORT="${CLEANUP_PORT//\/*/}"
  fi
  if [ -n "$SET_WEB_PORT" ]; then
    PRETTY_PORT="$CLEANUP_PORT"
    NGINX_PROXY_PORT="$CLEANUP_PORT"
  fi
  if [ -n "$SET_NGINX_PROXY_PORT" ]; then
    NGINX_PROXY_PORT="$SET_NGINX_PROXY_PORT"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fix/create port
if echo "$PRETTY_PORT" | grep -q ':.*.:'; then
  NGINX_PROXY_PORT="$(echo "$PRETTY_PORT" | grep ':.*.:' | awk -F':' '{print $2}' | grep '^')"
else
  NGINX_PROXY_PORT="$(echo "$PRETTY_PORT" | grep -v ':.*.:' | awk -F':' '{print $2}' | grep '^')"
fi
if [ -n "$NGINX_PROXY_PORT" ]; then
  PRETTY_PORT="$NGINX_PROXY_PORT"
else
  NGINX_PROXY_PORT="$CLEANUP_PORT"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NGINX_PROXY_URL="${NGINX_PROXY_URL:-$PROXY_HTTP_PROTO://$NGINX_PROXY_ADDRESS:$NGINX_PROXY_PORT}"
NGINX_PROXY_URL="${NGINX_PROXY_URL// /}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set temp env for PORTS ENV variable
DOCKER_SET_PORTS_ENV_TMP="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | grep ':.*.:' | awk -F ':' '{print $1":"$3}' | grep '^')"
DOCKER_SET_PORTS_ENV_TMP+="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | grep -v ':.*.:' | awk -F ':' '{print $1":"$2}' | grep '^')"
DOCKER_SET_PORTS_ENV_TMP="$(echo "$DOCKER_SET_PORTS_ENV_TMP" | tr ',' '\n' | grep '[0-9]:[0-9]' | sort -u | sed 's|/.*||g' | grep -v '^$' | tr '\n' ',' | grep '^' || echo '')"
DOCKER_SET_PORTS_ENV="${DOCKER_SET_PORTS_ENV_TMP//,/ }"
DOCKER_SET_PORTS_ENV="${DOCKER_SET_PORTS_ENV//*:/}"
DOCKER_SET_PORTS_ENV="$(__trim "${DOCKER_SET_PORTS_ENV[*]}")"
ENV_PORTS="$(echo "$DOCKER_SET_PORTS_ENV" "${CONTAINER_ENV_PORTS[*]}" | tr ' ' '\n' | sort -u)"
if [ -n "$ENV_PORTS" ]; then
  DOCKER_SET_OPTIONS+=("--env ENV_PORTS=\"$ENV_PORTS\"")
  unset DOCKER_SET_PORTS_ENV ENV_PORTS
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_CUSTOM_ARRAY="$(__custom_docker_env | grep '\--')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Clean up variables
HUB_IMAGE_URL="$(__trim "${HUB_IMAGE_URL[*]:-}")"               # image url
HUB_IMAGE_TAG="$(__trim "${HUB_IMAGE_TAG[*]:-}")"               # image tag
DOCKER_GET_CAP="$(__trim "${DOCKER_SET_CAP[*]:-}")"             # --capabilites
DOCKER_GET_ENV="$(__trim "${DOCKER_SET_ENV[*]:-}")"             # --env
DOCKER_GET_DEV="$(__trim "${DOCKER_SET_DEV[*]:-}")"             # --device
DOCKER_GET_MNT="$(__trim "${DOCKER_SET_MNT[*]:-}")"             # --volume
DOCKER_GET_LINK="$(__trim "${DOCKER_SET_LINK[*]:-}")"           # --link
DOCKER_GET_LABELS="$(__trim "${DOCKER_SET_LABELS[*]:-}")"       # --labels
DOCKER_GET_SYSCTL="$(__trim "${DOCKER_SET_SYSCTL[*]:-}")"       # --sysctl
DOCKER_GET_OPTIONS="$(__trim "${DOCKER_SET_OPTIONS[*]:-}")"     # --env
DOCKER_GET_CUSTOM="$(__trim "${DOCKER_CUSTOM_ARRAY[*]:-}")"     # --tty --rm --interactive
DOCKER_GET_PUBLISH="$(__trim "${DOCKER_SET_TMP_PUBLISH[*]:-}")" # --publish ports
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_COMMANDS="$(__trim "${CONTAINER_COMMANDS[*]:-}")" # pass command to container
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set docker commands - script creation
EXECUTE_PRE_INSTALL="docker stop $CONTAINER_NAME;docker rm -f $CONTAINER_NAME"
EXECUTE_DOCKER_CMD="docker run -d $DOCKER_GET_OPTIONS $DOCKER_GET_CUSTOM $DOCKER_GET_LINK $DOCKER_GET_LABELS $DOCKER_GET_CAP $DOCKER_GET_SYSCTL $DOCKER_GET_DEV $DOCKER_GET_MNT $DOCKER_GET_ENV $DOCKER_GET_PUBLISH $HUB_IMAGE_URL:$HUB_IMAGE_TAG $CONTAINER_COMMANDS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run functions
__container_import_variables "$CONTAINER_ENV_FILE_MOUNT"
__dockermgr_variables >"$DOCKERMGR_CONFIG_DIR/env/$APPNAME"
__dockermgr_password_variables >"$DOCKERMGR_CONFIG_DIR/secure/$APPNAME"
chmod -f 600 "$DOCKERMGR_CONFIG_DIR/secure/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__custom_docker_env | tr ' ' '\n' | sed 's|--.*||g' | grep -v '^$' >"$DOCKERMGR_CONFIG_DIR/env/custom.$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main progam
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -d "$APPDIR/files" ] && { [ ! -d "$DATADIR" ] && mv -f "$APPDIR/files" "$DATADIR"; }
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
# Write the container name to file
echo "$CONTAINER_NAME" >"$DOCKERMGR_CONFIG_DIR/installed/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ ! -d "$LOCAL_DATA_DIR" ]; then 
  mkdir -p "$LOCAL_DATA_DIR"
  chmod -f 777 "$LOCAL_DATA_DIR"
fi
if [ ! -d "$LOCAL_CONFIG_DIR" ]; then 
  mkdir -p "$LOCAL_CONFIG_DIR"
  chmod -f 777 "$LOCAL_CONFIG_DIR"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_CREATE_DIRECTORY="$(__trim "$CONTAINER_CREATE_DIRECTORY")"
if [ -n "$CONTAINER_CREATE_DIRECTORY" ]; then
  CONTAINER_CREATE_DIRECTORY="${CONTAINER_CREATE_DIRECTORY//, }"
  for dir in $CONTAINER_CREATE_DIRECTORY;do
    if [ -n "$dir" ] && [ ! -d "$DATADIR/$dir" ]; then
      mkdir -p "$DATADIR/$dir"
      chmod -f 777 "$DATADIR/$dir"
    fi
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy over data files - keep the same stucture as -v DATADIR/mnt:/mnt
if [ -d "$INSTDIR/rootfs" ] && [ ! -f "$DATADIR/.installed" ]; then
  printf_yellow "Copying files to $DATADIR"
  __sudo cp -Rf "$INSTDIR/rootfs/." "$DATADIR/" &>/dev/null
  find "$DATADIR" -name ".gitkeep" -type f -exec rm -rf {} \; &>/dev/null
fi
if [ -f "$DATADIR/.installed" ]; then
  __sudo date +'Updated on %Y-%m-%d at %H:%M' | tee "$DATADIR/.installed" &>/dev/null
else
  __sudo chown -Rf "$SUDO_USER":"$SUDO_USER" "$DOCKERMGR_CONFIG_DIR" &>/dev/null
  __sudo chown -f "$SUDO_USER":"$SUDO_USER" "$DATADIR" "$INSTDIR" "$INSTDIR" &>/dev/null
  __sudo date +'installed on %Y-%m-%d at %H:%M' | tee "$DATADIR/.installed" &>/dev/null
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup the container
if cmd_exists docker-compose && [ -f "$INSTDIR/docker-compose.yml" ]; then
  printf_yellow "Installing containers using docker-compose"
  sed -i 's|REPLACE_DATADIR|'$DATADIR'' "$INSTDIR/docker-compose.yml" &>/dev/null
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
    cat <<EOF >"$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
#!/usr/bin/env bash
# Install script for $CONTAINER_NAME

$EXECUTE_PRE_INSTALL
$EXECUTE_DOCKER_CMD && docker ps -a 2>&1 | grep -q "$CONTAINER_NAME"
exit \$?

EOF
    [ -f "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME" ] && chmod -Rf 755 "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
  fi
  if __sudo ${EXECUTE_DOCKER_CMD} 1>/dev/null 2>"${TMP:-/tmp}/$APPNAME.err.log"; then
    rm -Rf "${TMP:-/tmp}/$APPNAME.err.log"
    echo "$CONTAINER_NAME" >"$DOCKERMGR_CONFIG_DIR/containers/$APPNAME"
  else
    ERROR_LOG="true"
  fi
fi
sleep 10
__docker_ps && CONTAINER_INSTALLED="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
if [ -w "$NGINX_DIR/vhosts.d" ]; then
  NGINX_VHOST_ENABLED="true"
  NGINX_VHOST_NAMES="${CONTAINER_WEB_SERVER_VHOSTS//,/ }"
  NGINX_CONFIG_NAME="${CONTAINER_WEB_SERVER_CONFIG_NAME:-$CONTAINER_HOSTNAME}"
  if [ "$HOST_NGINX_UPDATE_CONF" = "yes" ] && [ -f "$INSTDIR/nginx/proxy.conf" ]; then
    cp -f "$INSTDIR/nginx/proxy.conf" "/tmp/$$.$CONTAINER_HOSTNAME.conf"
    sed -i "s|REPLACE_APPNAME|$APPNAME|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_NGINX_PORT|$NGINX_PORT|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_HOST_PROXY|$NGINX_PROXY_URL|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_NGINX_HOST|$CONTAINER_HOSTNAME|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_NGINX_VHOSTS|$NGINX_VHOST_NAMES|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    sed -i "s|REPLACE_SERVER_LISTEN_OPTS|$NGINX_LISTEN_OPTS|g" "/tmp/$$.$CONTAINER_HOSTNAME.conf" &>/dev/null
    if [ -d "$NGINX_DIR/vhosts.d" ]; then
      __sudo_root mv -f "/tmp/$$.$CONTAINER_HOSTNAME.conf" "$NGINX_DIR/vhosts.d/$NGINX_CONFIG_NAME.conf"
      [ -f "$NGINX_DIR/vhosts.d/$NGINX_CONFIG_NAME.conf" ] && NGINX_IS_INSTALLED="yes" && NGINX_CONF_FILE="$NGINX_DIR/vhosts.d/$NGINX_CONFIG_NAME.conf"
      systemctl status nginx | grep -q enabled &>/dev/null && __sudo_root systemctl reload nginx &>/dev/null
    else
      mv -f "/tmp/$$.$CONTAINER_HOSTNAME.conf" "$INSTDIR/nginx/$NGINX_CONFIG_NAME.conf" &>/dev/null
    fi
  else
    NGINX_PROXY_URL=""
  fi
  SERVER_URL="$CONTAINER_PROTOCOL://$CONTAINER_HOSTNAME:$PRETTY_PORT"
  [ -f "$NGINX_DIR/vhosts.d/$NGINX_CONFIG_NAME.conf" ] && NGINX_PROXY_URL="$CONTAINER_PROTOCOL://$CONTAINER_HOSTNAME"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# finalize
if [ "$CONTAINER_INSTALLED" = "true" ] || __docker_ps; then
  DOCKER_PORTS="$(__trim "${DOCKER_GET_PUBLISH//--publish/}")"
  SET_PORT="$(echo "$DOCKER_PORTS" | tr ' ' '\n' | sort -u | grep -v '^$')"
  if ! grep -sq "$CONTAINER_HOSTNAME" "/etc/hosts" && [ -w "/etc/hosts" ]; then
    if [ -n "$PRETTY_PORT" ]; then
      if [ "$HOST_LISTEN_ADDR" = 'home' ]; then
        echo "$HOST_LISTEN_ADDR        $APPNAME.home" | sudo tee -a "/etc/hosts" &>/dev/null
      else
        echo "$HOST_LISTEN_ADDR        $APPNAME.home" | sudo tee -a "/etc/hosts" &>/dev/null
        echo "$HOST_LISTEN_ADDR        $CONTAINER_HOSTNAME" | sudo tee -a "/etc/hosts" &>/dev/null
      fi
    fi
  fi
  printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  printf_yellow "The container name is:          $CONTAINER_NAME"
  printf_yellow "The container is listening on:  $HOST_LISTEN_ADDR"
  printf_yellow "The hostname name is set to:    $CONTAINER_HOSTNAME"
  printf_yellow "Containers data is saved in:    $DATADIR"
  printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  if [ "$DOCKER_CREATE_NET" ]; then
    printf_purple "Created docker network:         $HOST_DOCKER_NETWORK"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ "$SUDO_USER" != "root" ] && [ -n "$SUDO_USER" ]; then
    __sudo chown -f "$SUDO_USER":"$SUDO_USER" "$DATADIR" "$INSTDIR" &>/dev/null
  fi
  if [ "$NGINX_IS_INSTALLED" = "yes" ] && [ -f "$NGINX_CONF_FILE" ]; then
    printf_cyan "nginx vhost name:                $CONTAINER_HOSTNAME"
    printf_cyan "nginx proxy to port:             $NGINX_PROXY_URL"
    printf_cyan "nginx config file installed to:  $NGINX_CONF_FILE"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -n "$SET_PORT" ] && [ -n "$NGINX_PROXY_URL" ]; then
    MESSAGE="true"
    printf_blue "Server address:                  $NGINX_PROXY_URL"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -n "$CONTAINER_USER_NAME" ]; then
    MESSAGE="true"
    printf_cyan "Username is:                     $CONTAINER_USER_NAME"
  fi
  if [ -n "$CONTAINER_USER_PASS" ]; then
    MESSAGE="true"
    printf_blue "Password is:                     $CONTAINER_USER_PASS"
  fi
  if [ "$CONTAINER_DATABASE_USER_ROOT" ]; then
    MESSAGE="true"
    printf_blue "Database root user:              $CONTAINER_DATABASE_USER_ROOT"
  fi
  if [ "$CONTAINER_DATABASE_PASS_ROOT" ]; then
    MESSAGE="true"
    printf_blue "Database root password:          $CONTAINER_DATABASE_PASS_ROOT"
  fi
  if [ "$CONTAINER_DATABASE_USER_NORMAL" ]; then
    MESSAGE="true"
    printf_blue "Database user:                   $CONTAINER_DATABASE_USER_NORMAL"
  fi
  if [ "$CONTAINER_DATABASE_PASS_NORMAL" ]; then
    MESSAGE="true"
    printf_blue "Database password:               $CONTAINER_DATABASE_PASS_NORMAL"
  fi
  if [ "$SHOW_DATABASE_INFO" = "true" ]; then
    MESSAGE="true"
    printf_yellow "Database is running on:          $CONTAINER_DATABASE_PROTO"
    if [ -n "$MESSAGE_COUCHDB" ]; then
      printf_cyan "$MESSAGE_COUCHDB"
    fi
    if [ -n "$MESSAGE_SQLITE3" ]; then
      printf_cyan "$MESSAGE_SQLITE3"
    fi
    if [ -n "$MESSAGE_MARIADB" ]; then
      printf_cyan "$MESSAGE_MARIADB"
    fi
    if [ -n "$MESSAGE_MONGODB" ]; then
      printf_cyan "$MESSAGE_MONGODB"
    fi
    if [ -n "$MESSAGE_PGSQL" ]; then
      printf_cyan "$MESSAGE_PGSQL"
    fi
    if [ -n "$MESSAGE_REDIS" ]; then
      printf_cyan "$MESSAGE_REDIS"
    fi
    if [ -n "$MESSAGE_SUPABASE" ]; then
      printf_cyan "$MESSAGE_SUPABASE"
    fi
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -f "$DATADIR/config/auth/htpasswd" ]; then
    MESSAGE="true"
    printf_purple "Username:                        root"
    printf_purple "Password:                        ${SET_USER_PASS:-toor}"
    printf_purple "htpasswd File:                   /config/auth/htpasswd"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -n "$POST_SHOW_FINISHED_MESSAGE" ]; then
    printf_green "$POST_SHOW_FINISHED_MESSAGE"
  fi
  __show_post_message
else
  printf_cyan "The container $CONTAINER_NAME seems to have failed"
  if [ "$ERROR_LOG" = "true" ]; then
    printf_yellow "Errors logged to ${TMP:-/tmp}/$APPNAME.err.log"
  else
    printf_red "Something seems to have gone wrong with the install"
  fi
  if [ -f "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME" ]; then
    printf_yellow "Script: $DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
  fi
  exit 10
fi
if [ -z "$SET_PORT" ]; then
  printf_yellow "This container does not have services configured"
else
  printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  for service in $SET_PORT; do
    if [ "$service" != "--publish" ] && [ "$service" != " " ] && [ -n "$service" ]; then
      get_type="${service//*\//}"
      get_type="${get_type//$service/}"
      type=${get_type//*\//}
      service=${service//\/*/}
      set_listen=${service%:*}
      set_service=${service//*:*[^:]*:/}
      listen_ip=${set_listen//0.0.0.0/$HOST_LISTEN_ADDR}
      listen=${listen_ip//*^:/$listen_ip}
      echo "$listen" | grep -q ":" || listen="$listen_ip"
      if [ -n "$listen" ]; then
        if [ -n "$type" ]; then
          printf_cyan "Port ${set_service//*:/} is mapped to:           $listen/$type"
        else
          printf_cyan "Port ${set_service//*:/} is mapped to:           $listen"
        fi
      fi
    fi
  done
fi
if [ "$MESSAGE" = "true" ]; then
  printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
fi
if [ -f "$DOCKERMGR_CONFIG_DIR/env/$APPNAME" ] || [ -f "$DOCKERMGR_CONFIG_DIR/env/custom.$APPNAME" ]; then
  if [ -f "$DOCKERMGR_CONFIG_DIR/env/$APPNAME" ]; then
    printf_green "variables saved to:              $DOCKERMGR_CONFIG_DIR/env/$APPNAME"
  fi
  if [ -f "$DOCKERMGR_CONFIG_DIR/env/custom.$APPNAME" ]; then
    printf_green "Container variables saved to:    $DOCKERMGR_CONFIG_DIR/env/custom.$APPNAME"
  fi
  printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
fi
printf_cyan "$APPNAME has been installed to:   $INSTDIR"
printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n\n'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
run_postinst() {
  dockermgr_run_post
}
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
execute "run_postinst" "Running post install scripts" 1>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Output post install message
run_post_install &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
dockermgr_install_version &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exit
run_exit >/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# ex: ts=2 sw=2 et filetype=sh
