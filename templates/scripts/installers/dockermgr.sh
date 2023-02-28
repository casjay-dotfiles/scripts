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
__sudo() { sudo -n true && eval sudo "$*" || eval "$*" || return 1; }
__port() { echo "$((50000 + $RANDOM % 1000))" | grep '^' || return 1; }
__docker_check() { [ -n "$(type -p docker 2>/dev/null)" ] || return 1; }
__route() { [ -n "$(type -P ip)" ] && eval ip route 2>/dev/null || return 1; }
__sudo_root() { sudo -n true && ask_for_password true && eval sudo "$*" || return 1; }
__password() { cat "/dev/urandom" | tr -dc '[0-9][a-z][A-Z]@$' | head -c14 && echo ""; }
__ifconfig() { [ -n "$(type -P ifconfig)" ] && eval ifconfig "$*" 2>/dev/null || return 1; }
__name() { echo "$HUB_IMAGE_URL-${HUB_IMAGE_TAG:-latest}" | awk -F '/' '{print $(NF-1)"-"$NF}'; }
__enable_ssl() { { [ "$SSL_ENABLED" = "yes" ] || [ "$SSL_ENABLED" = "true" ]; } && return 0 || return 1; }
__ssl_certs() { [ -f "$HOST_SSL_CA" ] && [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ] && return 0 || return 1; }
__host_name() { hostname -f 2>/dev/null | grep '\.' | grep '^' || hostname -f 2>/dev/null | grep '^' || echo "$HOSTNAME"; }
__docker_init() { [ -n "$(type -p dockermgr 2>/dev/null)" ] && dockermgr init || printf_exit "Failed to Initialize the docker installer"; }
__domain_name() { hostname -f 2>/dev/null | awk -F '.' '{print $(NF-1)"."$NF}' | grep '\.' | grep '^' || hostname -f 2>/dev/null | grep '^' || return 1; }
__port_in_use() { { [ -d "/etc/nginx/vhosts.d" ] && grep -wRsq "${1:-443}" "/etc/nginx/vhosts.d" || netstat -taupln 2>/dev/null | grep '[0-9]:[0-9]' | grep 'LISTEN' | grep -q "${1:-443}"; } && return 1 || return 0; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__public_ip() { curl -q -LSsf "http://ifconfig.co" | grep -v '^$' | head -n1 | grep '^'; }
__docker_gateway_ip() { sudo docker network inspect -f '{{json .IPAM.Config}}' bridge | jq -r '.[].Gateway' | grep -v '^$' | head -n1 | grep '^' || echo '172.17.0.1'; }
__local_lan_ip() { [ -n "$SET_LOCAL_IP" ] && { echo "$SET_LOCAL_IP" | grep -E '192\.168\.[0-255]\.[0-255]' 2>/dev/null || echo "$SET_LOCAL_IP" | grep -E '10\.[0-255]\.[0-255]\.[0-255]' 2>/dev/null || echo "$SET_LOCAL_IP" | grep -E '172\.[16-31]\.[0-255]\.[0-255]' 2>/dev/null; } | grep -v '^$' || grep -v '172\.17\.0\.1' | head -n1 | grep '^' || echo "$CURRENT_IP_4"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__rport() {
  local port
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
  printf '%s' "$var" | grep -v '^$'
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
__docker_check || __docker_init
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
# import global variables
[ -f "$INSTDIR/env.sh" ] && . "$INSTDIR/env.sh"
[ -f "$APPDIR/env.sh" ] && . "$APPDIR/env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/.env.sh" ] && . "$DOCKERMGR_CONFIG_DIR/.env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/env/$APPNAME" ] && . "$DOCKERMGR_CONFIG_DIR/env/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "e:,p:,h:,d:" --long "options,env:,port:,host:,domain:" -n "$APPNAME" -- "$@" 2>/dev/null)
set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  -h | --host) CONTAINER_OPT_HOSTNAME="$2" && shift 2 ;;
  -d | --domain) CONTAINER_OPT_DOMAINNAME="$2" && shift 2 ;;
  -e | --env) CONTAINER_OPT_ENV_VAR="$2 $CONTAINER_OPT_ENV_VAR" && shift 2 ;;
  -p | --port) CONTAINER_OPT_PORT_VAR="$2 $CONTAINER_OPT_PORT_VAR" && shift 2 ;;
  --options) shift 1 && echo "Options: -e -p -h -d --options --env --port --host --domain" && exit 1 ;;
  *) break ;;
  esac
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup networking
SET_LOCAL_NET_DEV=$(__route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}' | grep '^' || echo 'eth0')
SET_LOCAL_IP=$(__ifconfig $LOCAL_NET_DEV | grep -w 'inet' | awk -F ' ' '{print $2}' | grep -vE '127\.[0-255]\.[0-255]\.[0-255]' | tr ' ' '\n' | grep '^')
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get variables from host
SET_RANDOM_PORT=$(__rport)
SET_RANDOM_PASS=$(__password)
SET_LOCAL_HOSTNAME=$(__host_name)
SET_LOCAL_DOMAINNAME=$(__domain_name)
SET_LONG_HOSTNAME=$(hostname -f 2>/dev/null | grep '^')
SET_SHORT_HOSTNAME=$(hostname -s 2>/dev/null | grep '^')
SET_DOMAIN_NAME=$(hostname -d 2>/dev/null | grep '^' || echo 'home')
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define folders
HOST_DATA_DIR="$DATADIR/data"
HOST_CONFIG_DIR="$DATADIR/config"
LOCAL_DATA_DIR="${LOCAL_DATA_DIR:-$HOST_DATA_DIR}"
LOCAL_CONFIG_DIR="${LOCAL_CONFIG_DIR:-$HOST_CONFIG_DIR}"
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
# Set container timezone - Default: [America/New_York]
CONTAINER_TIMEZONE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Get username and password from env if variables exist [username] [pass,random]
GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME="${GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME:-$DEFAULT_USERNAME}"
GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD="${GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD:-$DEFAULT_PASSWORD}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# URL to container image - docker pull [URL]
HUB_IMAGE_URL="casjaysdevdocker/GEN_SCRIPT_REPLACE_APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# image tag [docker pull HUB_IMAGE_URL:tag]
HUB_IMAGE_TAG="latest"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the container name Default: [casjaysdevdocker/GEN_SCRIPT_REPLACE_APPNAME-$HUB_IMAGE_TAG]
CONTAINER_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container user and group ID [yes/no] [id]
USER_ID_ENABLED="no"
CONTAINER_USER_ID=""
CONTAINER_GROUP_ID=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable privileged container [ yes/no ]
CONTAINER_PRIVILEGED_ENABLED="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the SHM Size - Default: 64M
CONTAINER_SHM_SIZE="128M"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Restart container [no/always/on-failure/unless-stopped]
CONTAINER_AUTO_RESTART="always"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete container after exit [yes/no]
CONTAINER_AUTO_DELETE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable tty and interactive [yes/no]
CONTAINER_TTY_ENABLED="yes"
CONTAINER_INTERACTIVE_ENABLED="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable cgroups [yes/no]
CGROUPS_ENABLED="no"
CGROUPS_MOUNTS="/sys/fs/cgroup:/sys/fs/cgroup:ro"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set location to resolv.conf [yes/no]
HOST_RESOLVE_ENABLED="no"
HOST_RESOLVE_FILE="/etc/resolv.conf"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker socket [pathToSocket]
DOCKER_SOCKET_ENABLED="no"
DOCKER_SOCKET_MOUNT="/var/run/docker.sock"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker config [~/.docker/config.json]
DOCKER_CONFIG_ENABLED="no"
HOST_DOCKER_CONFIG="$HOME/.docker/config.json"
CONTAINER_DOCKER_CONFIG_FILE="/root/.docker/config.json"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount soundcard [/dev/snd]
DOCKER_SOUND_ENABLED="no"
HOST_SOUND_CONFIG="/dev/snd"
CONTAINER_SOUND_CONFIG_FILE="/dev/snd"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable display in container
CONTAINER_X11_ENABLED="no"
HOST_X11_DISPLAY=""
HOST_X11_SOCKET="/tmp/.X11-unix"
HOST_X11_XAUTH="$HOME/.Xauthority"
CONTAINER_X11_SOCKET="/tmp/.X11-unix"
CONTAINER_X11_XAUTH="/home/x11user/.Xauthority"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable hosts /etc/hosts file [yes/no]
HOST_ETC_HOSTS_ENABLED="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container hostname and domain - Default: GEN_SCRIPT_REPLACE_APPNAME
CONTAINER_HOSTNAME=""
CONTAINER_DOMAINNAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the network type - default is bridge [bridge/host]
HOST_DOCKER_NETWORK=bridge
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set listen type - Default default all [all/local/lan/docker/public]
HOST_NETWORK_ADDR=all
HOST_NETWORK_LOCAL_ADDR=127.0.0.1
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to 0.0.0.0 to listen on all
HOST_DEFINE_LISTEN=0.0.0.0
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup nginx proxy variables [yes,no]
HOST_NGINX_ENABLED=yes
HOST_NGINX_SSL_ENABLED=yes
HOST_NGINX_HTTP_PORT=80
HOST_NGINX_HTTPS_PORT=443
HOST_NGINX_UPDATE_CONF=yes
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable this if container is running a webserver [yes/no] [yes/no] [internalPort,otherPort]
CONTAINER_WEB_SERVER_ENABLED="no"
CONTAINER_WEB_SERVER_SSL_ENABLED="no"
CONTAINER_WEB_SERVER_AUTH_ENABLED="no"
CONTAINER_WEB_SERVER_PORT="80"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to the protocol the the container will use [http/https/git/ftp/pgsql/mysql/mongodb]
CONTAINER_HTTP_PROTO="http"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add service port [port] or [port:port] - LISTEN will be added if defined [HOST_DEFINE_LISTEN] or HOST_NETWORK_ADDR=local
# Only ONE of HTTP or HTTPS if web server or SERVICE port for mysql/pgsql/ftp/pgsql. add more to CONTAINER_ADD_CUSTOM_PORT
CONTAINER_HTTP_PORT=""
CONTAINER_HTTPS_PORT=""
CONTAINER_SERVICE_PORT=""
CONTAINER_ADD_CUSTOM_PORT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add service port [listen:externalPort:internalPort/tcp,udp]
CONTAINER_ADD_CUSTOM_LISTEN=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set links between containers [containerName]
CONTAINER_LINK=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional mounts [/dir:/dir,/otherdir:/otherdir]
CONTAINER_MOUNTS="$LOCAL_CONFIG_DIR:/config:z,$LOCAL_DATA_DIR:/data:z,"
CONTAINER_MOUNTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional devices [/dev:/dev,/otherdev:/otherdev]
CONTAINER_DEVICES=""
CONTAINER_DEVICES+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional variables [myvar=var,myothervar=othervar]
CONTAINER_ENV=""
CONTAINER_ENV+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set sysctl []
CONTAINER_SYSCTL=""
CONTAINER_SYSCTL+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set capabilites [CAP,OTHERCAP]
CONTAINER_CAPABILITIES="SYS_ADMIN,SYS_TIME "
CONTAINER_CAPABILITIES+=","
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define labels [traefik.enable=true,label=label,otherlabel=label2]
CONTAINER_LABELS=""
CONTAINER_LABELS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container username and password and the env name [CONTAINER_ENV_USER_NAME=CONTAINER_USER_NAME] - [password=pass]
CONTAINER_ENV_USER_NAME=""
CONTAINER_ENV_PASS_NAME=""
CONTAINER_USER_NAME="${GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME:-}"
CONTAINER_USER_PASS="${GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Specify container arguments - will run in container [/path/to/script]
CONTAINER_COMMANDS=""
CONTAINER_COMMANDS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define additional docker arguments - see docker run --help [--option arg1,--option2]
DOCKER_CUSTOM_ARGUMENTS=""
DOCKER_CUSTOM_ARGUMENTS+=""
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
CONTAINER_HTTP_PORT=" " CONTAINER_HTTPS_PORT=" "
CONTAINER_SERVICE_PORT=" " CONTAINER_ADD_CUSTOM_PORT=" "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# variable cleanup
CONTAINER_ENV="${CONTAINER_ENV//  / }"
CONTAINER_LABELS="${CONTAINER_LABELS//  / }"
CONTAINER_SYSCTL="${CONTAINER_SYSCTL//  / }"
CONTAINER_MOUNTS="${CONTAINER_MOUNTS//  / }"
CONTAINER_DEVICES="${CONTAINER_DEVICES//  / }"
CONTAINER_COMMANDS="${CONTAINER_COMMANDS//  / }"
CONTAINER_CAPABILITIES="${CONTAINER_CAPABILITIES//  / }"
DOCKER_CUSTOM_ARGUMENTS="${DOCKER_CUSTOM_ARGUMENTS//  / }"
CONTAINER_ADD_CUSTOM_PORT="${CONTAINER_ADD_CUSTOM_PORT//  / }"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set hostname and domain
HOST_SHORT_HOST="${SET_LOCAL_HOSTNAME:-$SET_SHORT_HOSTNAME}"
HOST_FULL_HOST="${SET_LOCAL_HOSTNAME:-$SET_LONG_HOSTNAME}"
HOST_FULL_DOMAIN="${SET_LOCAL_DOMAINNAME:-$SET_DOMAIN_NAME}"
if [[ "$HOST_FULL_HOST" = server.* ]]; then
  HOST_FULL_DOMAIN="$SET_LOCAL_DOMAINNAME"
  CONTAINER_DOMAINNAME="$SET_LOCAL_DOMAINNAME"
  CONTAINER_HOSTNAME="$APPNAME.$HOST_FULL_DOMAIN"
else
  CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-$HOST_FULL_DOMAIN}"
  CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-$APPNAME.$HOST_FULL_HOST}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup arrays
DOCKER_SET_PUBLISH=""
DOCKER_SET_TMP_PUBLISH=("")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Redfine variables
[ -n "$CONTAINER_NAME" ] || CONTAINER_NAME="$(__name)"
[ "$CONTAINER_HTTPS_PORT" = "" ] || CONTAINER_HTTP_PROTO="https"
[ "$GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME" = "random" ] && CONTAINER_USER_PASS="$RANDOM_PASS"
[ -n "$CONTAINER_LINK" ] && { [ "$HOST_DOCKER_NETWORK" = "bridge" ] || [ "$HOST_DOCKER_NETWORK" = "host" ]; } && CONTAINER_LINK=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set network Variables
LOCAL_NET_IP="$(__local_lan_ip)"
LOCAL_NET_IP="${LOCAL_NET_IP:-$SET_LOCAL_IP}"
HOST_DEFINE_LISTEN="${HOST_DEFINE_LISTEN:-SET_LOCAL_IP}"
[ "$HOST_NETWORK_ADDR" = "public" ] && HOST_DEFINE_LISTEN=0.0.0.0 && HOST_LISTEN_ADDR=$(__local_lan_ip)
[ "$HOST_NETWORK_ADDR" = "lan" ] && HOST_DEFINE_LISTEN=$(__local_lan_ip) && HOST_LISTEN_ADDR=$(__local_lan_ip)
[ "$HOST_NETWORK_ADDR" = "docker" ] && HOST_DEFINE_LISTEN=$(__docker_gateway_ip) && HOST_LISTEN_ADDR=$(__docker_gateway_ip)
[ "$HOST_NETWORK_ADDR" = "yes" ] && CONTAINER_PRIVATE="yes" && HOST_DEFINE_LISTEN="127.0.0.1" && HOST_LISTEN_ADDR="127.0.0.1" && CONTAINER_PRIVATE="yes"
[ "$HOST_NETWORK_ADDR" = "local" ] && CONTAINER_PRIVATE="yes" && HOST_DEFINE_LISTEN="127.0.0.1" && HOST_LISTEN_ADDR="127.0.0.1" && CONTAINER_PRIVATE="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite variables
[ -n "$HUB_IMAGE_TAG" ] || HUB_IMAGE_TAG="latest"
[ -n "$CONTAINER_TIMEZONE" ] || CONTAINER_TIMEZONE="America/New_York"
[ -n "$HOST_DEFINE_LISTEN" ] && HOST_DEFINE_LISTEN="${HOST_DEFINE_LISTEN//:*/}"
[ ! -f "/etc/nginx/vhosts.d/$CONTAINER_HOSTNAME.conf" ] && HOST_NGINX_UPDATE_CONF="yes"
[ -n "$CONTAINER_COMMANDS" ] && CONTAINER_COMMANDS="${CONTAINER_COMMANDS//,/ }" || CONTAINER_COMMANDS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IS_PRIVATE="${CONTAINER_WEB_SERVER_PORT:-$CONTAINER_SERVICE_PORT}"
CLEANUP_PORT="${HOST_SERVICE_PORT:-$IS_PRIVATE}"
CLEANUP_PORT="${CLEANUP_PORT//\/*/}"
PRETTY_PORT="$CLEANUP_PORT"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Docker arguments from env
[ -n "$DOCKER_CUSTOM_ARGUMENTS" ] && DOCKER_CUSTOM_ARGUMENTS+="${DOCKER_CUSTOM_ARGUMENTS//,/ } "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set docker options from env
DOCKER_SET_OPTIONS="${DOCKER_CUSTOM_ARGUMENTS:-}"
[ -n "$CONTAINER_NAME" ] && DOCKER_SET_OPTIONS+="--name=$CONTAINER_NAME "
[ "$CONTAINER_TTY_ENABLED" = "yes" ] && DOCKER_SET_OPTIONS+="--tty "
[ "$CONTAINER_PRIVILEGED_ENABLED" = "yes" ] && DOCKER_SET_OPTIONS+="--privileged "
[ "$CONTAINER_INTERACTIVE_ENABLED" = "yes" ] && DOCKER_SET_OPTIONS+="--interactive "
[ -n "$CONTAINER_SHM_SIZE" ] && DOCKER_SET_OPTIONS+="--shm-size=$CONTAINER_SHM_SIZE "
[ "$CONTAINER_AUTO_DELETE" = "yes" ] && DOCKER_SET_OPTIONS+="--rm " && CONTAINER_AUTO_RESTART=""
[ -n "$CONTAINER_TIMEZONE" ] && DOCKER_SET_OPTIONS+="--env TZ=$CONTAINER_TIMEZONE --env TIMEZONE=$CONTAINER_TIMEZONE "
[ -n "$CONTAINER_HOSTNAME" ] && DOCKER_SET_OPTIONS+="--hostname $CONTAINER_HOSTNAME --env HOSTNAME=$CONTAINER_HOSTNAME "
[ -n "$CONTAINER_DOMAINNAME" ] && DOCKER_SET_OPTIONS+="--domainname $CONTAINER_DOMAINNAME --env DOMAINNAME=$HOST_FULL_DOMAIN --env HOSTADMIN= "
[ "$HOST_DOCKER_NETWORK" = "host" ] && DOCKER_SET_OPTIONS+="--net-host " || DOCKER_SET_OPTIONS+="--network ${HOST_DOCKER_NETWORK:-bridge} "
[ -n "$CONTAINER_AUTO_RESTART" ] && DOCKER_SET_OPTIONS+="--restart=$CONTAINER_AUTO_RESTART " || DOCKER_SET_OPTIONS+="--restart unless-stopped "

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mounts from env
[ "$CGROUPS_ENABLED" = "yes" ] && CONTAINER_MOUNTS+="$CGROUPS_MOUNTS "
[ "$HOST_ETC_HOSTS_ENABLED" = "yes" ] && CONTAINER_MOUNTS+="/etc/hosts:/etc/hosts:ro "
[ "$HOST_RESOLVE_ENABLED" = "yes" ] && CONTAINER_MOUNTS+="$HOST_RESOLVE_FILE:/etc/resolv.conf "
[ "$DOCKER_SOCKET_ENABLED" = "yes" ] && CONTAINER_MOUNTS+="$DOCKER_SOCKET_MOUNT:/var/run/docker.sock "
[ "$DOCKER_SOUND_ENABLED" = "yes" ] && CONTAINER_MOUNTS+="$HOST_SOUND_CONFIG:$CONTAINER_SOUND_CONFIG_FILE "
[ "$DOCKER_CONFIG_ENABLED" = "yes" ] && CONTAINER_MOUNTS+="$HOST_DOCKER_CONFIG:$CONTAINER_DOCKER_CONFIG_FILE:ro "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# env variables from env
ADDITION_ENV+="START_SERVICES=INIT"
[ -z "$CONTAINER_USER_NAME" ] || ADDITION_ENV+="${CONTAINER_ENV_USER_NAME:-username}=$CONTAINER_USER_NAME "
[ -z "$CONTAINER_USER_PASS" ] || ADDITION_ENV+="${CONTAINER_ENV_PASS_NAME:-password}=$CONTAINER_USER_PASS "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set user ID
if [ "$USER_ID_ENABLED" = "yes" ]; then
  [ -n "$CONTAINER_USER_ID" ] && CONTAINER_ENV+="PUID=$CONTAINER_USER_ID " || CONTAINER_ENV+="PUID=$(id -u) "
  [ -n "$CONTAINER_GROUP_ID" ] && CONTAINER_ENV+="PGID=$CONTAINER_GROUP_ID " || CONTAINER_ENV+="PGID=$(id -g) "
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup display if enabled
if [ "$CONTAINER_X11_ENABLED" = "yes" ] && [ -f "$HOST_X11_SOCKET" ] && [ -f "$HOST_X11_XAUTH" ]; then
  [ -n "$HOST_X11_DISPLAY" ] || HOST_X11_DISPLAY="${DISPLAY//*:/}"
  CONTAINER_ENV+="DISPLAY=:$HOST_X11_DISPLAY "
  CONTAINER_MOUNTS+="$HOST_X11_SOCKET:${CONTAINER_X11_SOCKET:-/tmp/.X11-unix} "
  CONTAINER_MOUNTS+="$HOST_X11_XAUTH:${CONTAINER_X11_XAUTH:-/home/x11user/.Xauthority} "
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# nginx settings
if [ "$HOST_NGINX_ENABLED" = "yes" ]; then
  if [ "$HOST_NGINX_SSL_ENABLED" = "yes" ] && [ -n "$HOST_NGINX_HTTPS_PORT" ]; then
    NGINX_LISTEN_OPTS="ssl http2"
    NGINX_PORT="${HOST_NGINX_HTTPS_PORT:-443}"
  else
    NGINX_PORT="${HOST_NGINX_HTTP_PORT:-80}"
  fi
  if [ "$CONTAINER_WEB_SERVER_AUTH_ENABLED" = "yes" ]; then
    CONTAINER_USER_NAME="${CONTAINER_USER_NAME:-root}"
    CONTAINER_USER_PASS="${CONTAINER_USER_PASS:-$RANDOM_PASS}"
    SET_USER_NAME="$CONTAINER_USER_NAME"
    SET_USER_PASS="$CONTAINER_USER_PASS"
    [ -d "/etc/nginx/auth" ] || mkdir -p "/etc/nginx/auth"
    if [ -n "$(builtin type -P htpasswd)" ]; then
      if ! grep -q "$CONTAINER_USER_NAME"; then
        printf_yellow "Creating auth /etc/nginx/auth/$APPNAME"
        if [ -f "/etc/nginx/auth/$APPNAME" ]; then
          htpasswd -b "/etc/nginx/auth/$APPNAME" "$CONTAINER_USER_NAME" "$CONTAINER_USER_PASS" &>/dev/null
        else
          htpasswd -b -c "/etc/nginx/auth/$APPNAME" "$CONTAINER_USER_NAME" "$CONTAINER_USER_PASS" &>/dev/null
        fi
      fi
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
DOCKER_SET_LINK=""
CONTAINER_LINK="${CONTAINER_LINK//,/ }"
CONTAINER_LINK="${CONTAINER_LINK//  / }"
for link in $CONTAINER_LINK; do
  if [ "$link" != "" ] && [ "$link" != " " ]; then
    DOCKER_SET_LINK+="--link $link "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_SET_LABELS=""
CONTAINER_LABELS="${CONTAINER_LABELS//,/ }"
CONTAINER_LABELS="${CONTAINER_LABELS//  / }"
for label in $CONTAINER_LABELS; do
  if [ "$label" != "" ] && [ "$label" != " " ]; then
    DOCKER_SET_LABELS+="--label $label "
  fi
done
CONTAINER_LABELS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_SET_CAP=""
CONTAINER_CAPABILITIES="${CONTAINER_CAPABILITIES//,/ }"
CONTAINER_CAPABILITIES="${CONTAINER_CAPABILITIES//  / }"
for cap in $CONTAINER_CAPABILITIES; do
  if [ "$cap" != "" ] && [ "$cap" != " " ]; then
    DOCKER_SET_CAP+="--cap-add $cap "
  fi
done
CONTAINER_CAPABILITIES=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_SET_SYSCTL=""
CONTAINER_SYSCTL="${CONTAINER_SYSCTL//,/ }"
CONTAINER_SYSCTL="${CONTAINER_SYSCTL//  / }"
for sysctl in $CONTAINER_SYSCTL; do
  if [ "$sysctl" != "" ] && [ "$sysctl" != " " ]; then
    DOCKER_SET_SYSCTL+="--sysctl $sysctl "
  fi
done
CONTAINER_SYSCTL=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_SET_ENV1=""
CONTAINER_OPT_ENV_VAR="${SET_CONTAINER_OPT_ENV_VAR//,/ }"
CONTAINER_OPT_ENV_VAR="${SET_CONTAINER_OPT_ENV_VAR//  / }"
if [ -n "$OPT_ENV_VAR" ]; then
  for env in $OPT_ENV_VAR; do
    if [ "$env" != "" ] && [ "$env" != " " ]; then
      DOCKER_SET_ENV1+="--env $env "
    fi
  done
fi
CONTAINER_OPT_ENV_VAR=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_SET_ENV2=""
CONTAINER_ENV="${ADDITION_ENV//,/ }"
CONTAINER_ENV="${ADDITION_ENV//  / }"
for env in $ADDITION_ENV; do
  if [ "$env" != "" ] && [ "$env" != " " ]; then
    DOCKER_SET_ENV2+="--env $env "
  fi
done
CONTAINER_ENV=""
DOCKER_SET_ENV="$DOCKER_SET_ENV1 $DOCKER_SET_ENV2"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_SET_DEV=""
CONTAINER_DEVICES="${CONTAINER_DEVICES//,/ }"
CONTAINER_DEVICES="${CONTAINER_DEVICES//  / }"
for dev in $CONTAINER_DEVICES; do
  if [ "$dev" != "" ] && [ "$dev" != " " ]; then
    echo "$dev" | grep -q ':' || dev="$dev:$dev"
    DOCKER_SET_DEV+="--device $dev "
  fi
done
CONTAINER_DEVICES=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_SET_MNT=""
CONTAINER_MOUNTS="${CONTAINER_MOUNTS//,/ }"
CONTAINER_MOUNTS="${CONTAINER_MOUNTS//  / }"
for mnt in $CONTAINER_MOUNTS; do
  if [ "$mnt" != "" ] && [ "$mnt" != " " ]; then
    echo "$mnt" | grep -q ':' || port="$mnt:$mnt"
    DOCKER_SET_MNT+="--volume $mnt "
  fi
done
CONTAINER_MOUNTS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_OPT_PORT_VAR="${CONTAINER_OPT_PORT_VAR//,/ }"
CONTAINER_OPT_PORT_VAR="${CONTAINER_OPT_PORT_VAR//  / }"
SET_LISTEN="${HOST_DEFINE_LISTEN//:*/}"
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_SERVER_PORTS_TMP="${CONTAINER_HTTP_PORT//,/ }"
SET_SERVER_PORTS_TMP+="${CONTAINER_HTTPS_PORT//,/ }"
SET_SERVER_PORTS_TMP+="${CONTAINER_SERVICE_PORT//,/ }"
SET_SERVER_PORTS_TMP+="${CONTAINER_ADD_CUSTOM_PORT//,/ }"
SET_SERVER_PORTS="${SET_SERVER_PORTS_TMP//  / }"
SET_LISTEN=${HOST_DEFINE_LISTEN//:*/}
for set_port in $SET_SERVER_PORTS; do
  if [ "$set_port" != " " ] && [ -n "$set_port" ]; then
    port=$set_port
    echo "$port" | grep -q ':' || port="${port//\/*/}:$port"
    if [ "$CONTAINER_PRIVATE" = "yes" ] && [ "$port" = "${IS_PRIVATE//\/*/}" ]; then
      ADDR="${HOST_NETWORK_LOCAL_ADDR:-127.0.0.1}"
      DOCKER_SET_TMP_PUBLISH+=("--publish $ADDR:$port")
    elif [ -n "$SET_LISTEN" ]; then
      DOCKER_SET_TMP_PUBLISH+=("--publish $SET_LISTEN:$port")
    else
      DOCKER_SET_TMP_PUBLISH+=("--publish $port")
    fi
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_ADD_CUSTOM_LISTEN="${CONTAINER_ADD_CUSTOM_LISTEN//,/ }"
CONTAINER_ADD_CUSTOM_LISTEN="${CONTAINER_ADD_CUSTOM_LISTEN//  / }"
if [ -n "$CONTAINER_ADD_CUSTOM_LISTEN" ]; then
  for set_port in $CONTAINER_ADD_CUSTOM_LISTEN; do
    port=$set_port
    if [ "$port" != " " ] && [ -n "$port" ]; then
      echo "$port" | grep -q ':' || port="${port//\/*/}:$port"
      DOCKER_SET_TMP_PUBLISH+=("--publish $port")
    fi
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# container web server configuration
SET_WEB_PORT=""
if [ "$CONTAINER_WEB_SERVER_ENABLED" = "yes" ]; then
  CONTAINER_WEB_SERVER_IP=$HOST_NETWORK_LOCAL_ADDR
  CONTAINER_WEB_SERVER_PORT="${CONTAINER_WEB_SERVER_PORT//,/ }"
  CONTAINER_WEB_SERVER_PORT="${CONTAINER_WEB_SERVER_PORT//  / }"
  for set_port in $CONTAINER_WEB_SERVER_PORT; do
    if [ "$set_port" != " " ] && [ -n "$set_port" ]; then
      port=$set_port
      RANDOM_PORT="$(__rport)"
      TYPE="$(echo "$port" | grep '/' | awk -F '/' '{print $NF}' | head -n1 | grep '^' || echo '')"
      if [ -z "$TYPE" ]; then
        DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_WEB_SERVER_IP:$RANDOM_PORT:$port")
      else
        DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_WEB_SERVER_IP:$RANDOM_PORT:$port/$TYPE")
      fi
      SET_WEB_PORT+="$CONTAINER_WEB_SERVER_IP:$RANDOM_PORT "
    fi
  done
  [ "$CONTAINER_WEB_SERVER_SSL_ENABLED" = "yes" ] && CONTAINER_HTTP_PROTO="https" || CONTAINER_HTTP_PROTO="http"
  [ -n "$SET_WEB_PORT" ] && SET_NGINX_PROXY_PORT="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | awk -F':' '{print $1":"$2}' | grep -v '^$' | tr '\n' ' ' | head -n1 | grep '^')"
  [ -n "$SET_WEB_PORT" ] && CLEANUP_PORT="${SET_NGINX_PROXY_PORT//--publish /}" CLEANUP_PORT="${CLEANUP_PORT//\/*/}"
  [ -n "$SET_WEB_PORT" ] && PRETTY_PORT="$CLEANUP_PORT" NGINX_PROXY_PORT="$PRETTY_PORT"
  [ -n "$SET_NGINX_PROXY_PORT" ] && NGINX_PROXY_PORT="$SET_NGINX_PROXY_PORT"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if echo "$PRETTY_PORT" | grep -q ':.*.:'; then
  NGINX_PROXY_PORT="$(echo "$PRETTY_PORT" | grep ':.*.:' | awk -F':' '{print $2}' | grep '^')"
else
  NGINX_PROXY_PORT="$(echo "$PRETTY_PORT" | grep -v ':.*.:' | awk -F':' '{print $2}' | grep '^')"
fi
[ -n "$NGINX_PROXY_PORT" ] || NGINX_PROXY_PORT="$CLEANUP_PORT"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL setup
NGINX_PROXY_URL=""
PROXY_HTTP_PROTO="http"
if [ "$NGINX_SSL" = "yes" ]; then
  [ "$SSL_ENABLED" = "yes" ] && PROXY_HTTP_PROTO="https"
  if [ "$PROXY_HTTP_PROTO" = "https" ]; then
    NGINX_PROXY_URL="$PROXY_HTTP_PROTO://$HOST_LISTEN_ADDR:$NGINX_PROXY_PORT"
    if [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ]; then
      [ -f "$CONTAINER_SSL_CA" ] && CONTAINER_MOUNTS+="$HOST_SSL_CA:$CONTAINER_SSL_CA "
      CONTAINER_MOUNTS+="$HOST_SSL_CRT:$CONTAINER_SSL_CRT "
      CONTAINER_MOUNTS+="$HOST_SSL_KEY:$CONTAINER_SSL_KEY "
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
  sudo -HE cp -Rf "$INSTDIR/rootfs/." "$DATADIR/" &>/dev/null
  find "$DATADIR" -name ".gitkeep" -type f -exec rm -rf {} \; &>/dev/null
fi
if [ -f "$DATADIR/.installed" ]; then
  sudo -HE date +'Updated on %Y-%m-%d at %H:%M' | tee "$DATADIR/.installed" &>/dev/null
else
  sudo -HE date +'installed on %Y-%m-%d at %H:%M' | tee "$DATADIR/.installed" &>/dev/null
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set temp env for PORTS ENV variable
DOCKER_SET_PORTS_ENV_TMP=""
DOCKER_SET_PORTS_ENV_TMP+="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | grep ':.*.:' | awk -F ':' '{print $1":"$3}' | tr '\n' ',' | grep '^')"
DOCKER_SET_PORTS_ENV_TMP+="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | grep -v ':.*.:' | awk -F ':' '{print $1":"$2}' | tr '\n' ',' | grep '^')"
DOCKER_SET_PORTS_ENV_TMP+="$(echo "$DOCKER_SET_PORTS_ENV_TMP" | tr ' ' '\n' | grep '[0-9]:[0-9]' | sort -u | sed 's|/.*||g' | grep -v '^$' | tr '\n' ',' | grep '^' || echo '')"
DOCKER_SET_PORTS_ENV="$(__trim "${DOCKER_SET_PORTS_ENV_TMP//,/ }")"
[ -n "$DOCKER_SET_PORTS_ENV" ] && DOCKER_SET_OPTIONS+="--env ENV_PORTS=\"${DOCKER_SET_PORTS_ENV//: /}\""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main progam
HUB_IMAGE_URL="$(__trim "${HUB_IMAGE_URL[*]:-}")"
HUB_IMAGE_TAG="$(__trim "${HUB_IMAGE_TAG[*]:-}")"
DOCKER_SET_CAP="$(__trim "${DOCKER_SET_CAP[*]:-}")"
DOCKER_SET_ENV="$(__trim "${DOCKER_SET_ENV[*]:-}")"
DOCKER_SET_DEV="$(__trim "${DOCKER_SET_DEV[*]:-}")"
DOCKER_SET_MNT="$(__trim "${DOCKER_SET_MNT[*]:-}")"
DOCKER_SET_LINK="$(__trim "${DOCKER_SET_LINK[*]:-}")"
DOCKER_SET_LABELS="$(__trim "${DOCKER_SET_LABELS[*]:-}")"
DOCKER_SET_SYSCTL="$(__trim "${DOCKER_SET_SYSCTL[*]:-}")"
DOCKER_SET_OPTIONS="$(__trim "${DOCKER_SET_OPTIONS[*]:-}")"
CONTAINER_COMMANDS="$(__trim "${CONTAINER_COMMANDS[*]:-}")"
DOCKER_SET_PUBLISH="$(__trim "${DOCKER_SET_TMP_PUBLISH[*]:-}")"
EXECUTE_PRE_INSTALL="docker stop $CONTAINER_NAME;docker rm -f $CONTAINER_NAME"
EXECUTE_DOCKER_CMD="docker run -d $DOCKER_SET_OPTIONS $DOCKER_SET_LINK $DOCKER_SET_LABELS $DOCKER_SET_CAP $DOCKER_SET_SYSCTL $DOCKER_SET_DEV $DOCKER_SET_MNT $DOCKER_SET_ENV $DOCKER_SET_PUBLISH $HUB_IMAGE_URL:$HUB_IMAGE_TAG $CONTAINER_COMMANDS"
EXECUTE_DOCKER_CMD="$(__trim "$EXECUTE_DOCKER_CMD")"
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
$EXECUTE_DOCKER_CMD
exit \$?

EOF
    [ -f "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME" ] && chmod -Rf 755 "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
  fi
  if __sudo ${EXECUTE_DOCKER_CMD} 1>/dev/null 2>"${TMP:-/tmp}/$APPNAME.err.log"; then
    rm -Rf "${TMP:-/tmp}/$APPNAME.err.log"
  else
    ERROR_LOG="true"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
if [ "$NGINX_PROXY" = "yes" ] && [ -w "/etc/nginx/vhosts.d" ]; then
  if [ "$HOST_NGINX_UPDATE_CONF" = "yes" ] && [ -f "$INSTDIR/nginx/proxy.conf" ]; then
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
  local addr="$HOST_LISTEN_ADDR"
  [ -w "/etc/hosts" ] || return 0
  [ "$HOST_LISTEN_ADDR" = "0.0.0.0" ] && addr="$LOCAL_NET_IP"
  if ! grep -sq "$CONTAINER_HOSTNAME" "/etc/hosts"; then
    if [ -n "$PRETTY_PORT" ]; then
      if [ "$addr" = 'home' ]; then
        echo "$addr     $APPNAME.home" | sudo tee -a "/etc/hosts" &>/dev/null
      else
        echo "$addr     $APPNAME.home" | sudo tee -a "/etc/hosts" &>/dev/null
        echo "$addr     $CONTAINER_HOSTNAME" | sudo tee -a "/etc/hosts" &>/dev/null
      fi
    fi
  fi
  if [ "$SUDO_USER" != "root" ] && [ -n "$SUDO_USER" ]; then
    sudo -HE chown -f "$SUDO_USER":"$SUDO_USER" "$DATADIR" "$INSTDIR" "$INSTDIR" &>/dev/null
    sudo -HE chown -f "$SUDO_USER":"$SUDO_USER" "$DATADIR" "$INSTDIR" "$INSTDIR" &>/dev/null
    true
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
SET_ADDR="${HOST_LISTEN_ADDR//:*/}"
SET_PORT="${DOCKER_SET_PUBLISH//--publish /}"
if docker ps -a | grep -qs "$CONTAINER_NAME"; then
  printf_yellow "The DATADIR is in $DATADIR"
  printf_cyan "$APPNAME has been installed to $INSTDIR"
  if [ -z "$SET_PORT" ]; then
    printf_yellow "This container does not have services configured"
  else
    for service in $SET_PORT; do
      if [ "$service" != "--publish" ] && [ "$service" != " " ] && [ -n "$service" ]; then
        service="${service//\/*/}"
        set_listen="${service%:*}"
        set_service="${service//*:[^:]*:/}"
        listen="${set_listen//0.0.0.0/$SET_ADDR}"
        [ -z "$listen" ] || printf_cyan "Port $set_service is mapped to: $listen"
      fi
    done
  fi
  printf_yellow "The container name is: $CONTAINER_NAME"
  [ -z "$SET_USER_NAME" ] || printf_cyan "Username is:  $SET_USER_NAME"
  [ -z "$SET_USER_PASS" ] || printf_purple "Password is:  $SET_USER_PASS"
  __show_post_message
  [ -z "$POST_SHOW_FINISHED_MESSAGE" ] || printf_green "$POST_SHOW_FINISHED_MESSAGE"
else
  printf_cyan "The container $CONTAINER_NAME seems to have failed"
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
