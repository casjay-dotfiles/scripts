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
# shell check options
# shellcheck disable=SC1003
# shellcheck disable=SC2001
# shellcheck disable=SC2016
# shellcheck disable=SC2031
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# shellcheck disable=SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export APPNAME="GEN_SCRIPT_REPLACE_APPNAME"
export VERSION="GEN_SCRIPT_REPLACE_VERSION"
export REPO_BRANCH="${GIT_REPO_BRANCH:-main}"
export USER="${SUDO_USER:-$USER}"
export RUN_USER="${RUN_USER:-$USER}"
export USER_HOME="${USER_HOME:-$HOME}"
export SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
export SCRIPTS_PREFIX="dockermgr"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
trap 'retVal=$?;trap_exit' ERR EXIT SIGINT
[ "$1" = "--debug" ] && set -x && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[ "$1" = "--raw" ] && export SHOW_RAW="true"
set -o pipefail -o noglob
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-mgr-installers.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/$SCRIPTS_PREFIX/installer/raw/main/functions}"
connect_test() { curl -q -ILSsf --retry 1 --max-time 2 "https://1.1.1.1" 2>&1 | grep -iq 'server:*.cloudflare' || return 1; }
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
# Setup application options
setopts=$(getopt -o "i,s:,h:,d:,e:,m:,p:" --long "init,server:,host:,domain:,env:,mount:,port:" -n "$APPNAME" -- "$@" 2>/dev/null)
set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in #
  --debug | --raw) shift 1 ;;
  -a | --name) APPNAME="$2" && shift 2 ;;
  -i | --init) ENV_INIT_SCRIPT_ONLY="yes" && shift 1 ;;
  -s | --server) CONTAINER_FULL_HOST="$2" && shift 2 ;;
  -h | --host) CONTAINER_OPT_HOSTNAME="$2" && shift 2 ;;
  -d | --domain) CONTAINER_OPT_DOMAINNAME="$2" && shift 2 ;;
  -e | --env) CONTAINER_OPT_ENV_VAR="$2 $CONTAINER_OPT_ENV_VAR" && shift 2 ;;
  -m | --mount) CONTAINER_OPT_MOUNT_VAR="$2 $CONTAINER_OPT_MOUNT_VAR" && shift 2 ;;
  -p | --port) CONTAINER_OPT_PORT_VAR="$2 $CONTAINER_OPT_PORT_VAR" && shift 2 ;;
  --) shift 1 && break ;;
  *) break ;;
  esac
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# image tag - [docker pull DOCKER_HUB_IMAGE_URL:tag]
DOCKER_HUB_IMAGE_TAG="latest"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# docker registry settings
DOCKER_REGISTRY_URL="docker.io"
DOCKER_REGISTRY_REPO_NAME="GEN_SCRIPT_REPLACE_APPNAME"
DOCKER_REGISTRY_USER_NAME="casjaysdevdocker"
DOCKER_REGISTRY_IMAGE_TAG="$DOCKER_HUB_IMAGE_TAG"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# URL to container image - docker pull - [URL]
DOCKER_HUB_IMAGE_URL="$DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_USER_NAME/$DOCKER_REGISTRY_REPO_NAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_CONTAINER_NAME="${DOCKER_REGISTRY_USER_NAME}-${DOCKER_REGISTRY_REPO_NAME}-${DOCKER_HUB_IMAGE_TAG}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Repository variables
REPO="${DOCKERMGRREPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME"
APPVERSION="$(__appversion "$REPO/raw/$REPO_BRANCH/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults variables
DOCKERMGR_CONFIG_DIR="$HOME/.config/myscripts/$SCRIPTS_PREFIX"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_INSTDIR="$HOME/.local/share/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set default docker home for containers - $SET_APPDIR/$CONTAINER_NAME [APPDIR]
SET_APPDIR="/var/lib/srv/$USER/docker/$DOCKER_REGISTRY_USER_NAME/$DOCKER_REGISTRY_REPO_NAME/$DOCKER_HUB_IMAGE_TAG"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the base data directory - mounted files live in $SET_DATADIR/$CONTAINER_NAME/rootfs [DATADIR]
SET_DATADIR="/var/lib/srv/$USER/docker/$DOCKER_REGISTRY_USER_NAME/$DOCKER_REGISTRY_REPO_NAME/$DOCKER_HUB_IMAGE_TAG"
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
__sudo_root() { [ "$DOCKERMGR_USER_CAN_SUDO" = "true" ] && sudo "$@" || { [ "$USER" = "root" ] && eval "$*"; } || eval "$*" 2>/dev/null || return 1; }
__sudo_exec() { [ "$DOCKERMGR_USER_CAN_SUDO" = "true" ] && sudo -HE "$@" || { [ "$USER" = "root" ] && eval "$*"; } || eval "$*" 2>/dev/null || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
__test_public_reachable() {
  local exitCode=0
  local port="${1:-$(__port)}"
  local nc="$(builtin type -P nc || builtin type -P netcat || false)"
  if [ -n "$nc" ]; then
    (timeout 20 $nc -l $port &) &>/dev/null
    curl -q -LSsf -4 "https://ifconfig.co/port/$port" | jq -rc '.reachable' | grep -q 'true' || exitCode=1
  else
    exitCode=1
  fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# printf_space spacing color message value
__printf_space() {
  local color padlength
  test -n "$1" && test -z "${1//[0-9]/}" && color="$1" && shift 1 || color="7"
  test -n "$1" && test -z "${1//[0-9]/}" && padlength="$1" && shift 1 || padlength="40"
  printf '%b%s   %s%b' "$(tput setaf "$color" 2>/dev/null)" "$1" "$2" "$(tput sgr0 2>/dev/null)"
  printf '\n'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__printf_spacing_file() { __printf_space "7" "40" "$1" "$2"; }
__printf_spacing_color() { __printf_space "$1" "40" "$2" "$3"; }
__printf_color() { printf "%b" "$(tput setaf "$1" 2>/dev/null)" "$2" "$(tput sgr0 2>/dev/null)" && printf '\n'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cmd_exists() { type -p $1 &>/dev/null || return 1; }
__grep_char() { grep '[a-zA-Z0-9].[a-zA-Z0-9]' | grep '^' || return 1; }
__docker_check() { [ -n "$(type -p docker 2>/dev/null)" ] || return 1; }
__remove_extra_spaces() { sed 's/\( \)*/\1/g;s|^ ||g' | sed 's/^[ \t]*//'; }
__set_vhost_alias() { echo "$1" | __remove_extra_spaces | grep "$2$" | sed "s|$2$|$3|g"; }
__docker_ps_all() { docker ps -a 2>&1 | grep -i ${1:-} "$CONTAINER_NAME" && return 0 || return 1; }
__password() { head -n1000 -c 10000 "/dev/urandom" | tr -dc '0-9a-zA-Z' | head -c${1:-16} && echo ""; }
__total_memory() { mem="$(free | grep -i 'mem: ' | awk -F ' ' '{print $2}')" && echo $((mem / 1000)); }
__docker_is_running() { ps aux 2>/dev/null | grep 'dockerd' | grep -v ' grep ' | grep -q '^' || return 1; }
__container_name() { echo "$DOCKER_REGISTRY_USER_NAME-$DOCKER_REGISTRY_REPO_NAME-$DOCKER_HUB_IMAGE_TAG" | sed 's|/|-|g' | grep '^' || return 1; }
__is_server() { echo "${SET_HOST_FULL_NAME:-$HOSTNAME}" | grep -q '^server\..*\..*[a-zA-Z0-9][a-zA-Z0-9]$' || return 1; }
__host_name() { hostname -f 2>/dev/null | grep -F '.' | grep '^' || hostname -f 2>/dev/null | grep '^' || echo "$HOSTNAME"; }
__container_is_running() { docker ps 2>&1 | grep -i "$CONTAINER_NAME" | grep -qi 'ago.* Up.* [0-9].* ' && return 0 || return 1; }
__docker_init() { [ -n "$(type -p dockermgr 2>/dev/null)" ] && dockermgr init || printf_exit "Failed to Initialize the docker installer"; }
__netstat() { netstat -taupln 2>/dev/null | grep -vE 'WAIT|ESTABLISHED|docker-pro' | awk -F ' ' '{print $4}' | sed 's|.*:||g' | grep -E '[0-9]' | sort -Vu | grep "^${1:-.*}$" || return 1; }
__retrieve_custom_env() { [ -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.${1:-custom}.conf" ] && cat "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.${1:-custom}.conf" | grep -Ev '^$|^#' | grep '=' | grep '^' || __custom_docker_env | grep -Ev '^$|^#' | grep '=' | grep '^' || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__get_user_id() { grep -s "^$1:" /etc/passwd | awk -F: '{print $3}' | grep '^[0-9]' || echo "$(id -u)"; }
__get_group_id() { grep -s "^$1:" /etc/group | awk -F: '{print $3}' | grep '^[0-9]' || echo "$(id -g)"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__get_proxy_url() { echo "${1//\/*{/}" | grep -q '[0-9]:.*:[0-9]' && echo "${1%:*}" || echo "$1"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__ping_host() { ping -c1 -i1 -w1 "${1:-$CONTAINER_HOSTNAME}" >/dev/null 2>&1 || return 1; }
__domain_name() { hostname -d 2>/dev/null | grep -vF '(none)' | grep -F '.' | grep '^' || hostname -f 2>/dev/null | sed 's/^[^.:]*[.:]//' | __grep_char || return 1; }
__get_records() { __cmd_exists dig && dig $SET_LONG_HOSTNAME 2>&1 | grep -E 'A|AAAA|CNAME' | grep -E '[0-9]\.|[0-9]:' | awk '{print $NF}' | head -n1 | grep '^' || return 1; }
__docker_gateway_ip() { sudo docker network inspect -f '{{json .IPAM.Config}}' ${HOST_DOCKER_NETWORK:-bridge} 2>/dev/null | jq -r '.[].Gateway' | grep -Ev '^$|null' | head -n1 | grep '^' || return 1; }
__docker_net_create() { __docker_net_ls | grep -q "$HOST_DOCKER_NETWORK" && return 0 || { docker network create -d bridge --attachable $HOST_DOCKER_NETWORK &>/dev/null && __docker_net_ls | grep -q "$HOST_DOCKER_NETWORK" && echo "$HOST_DOCKER_NETWORK" && return 0 || return 1; }; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__ifconfig() { [ -n "$(type -P ifconfig)" ] && eval ifconfig "$*" 2>/dev/null || return 1; }
__docker_net_ls() { docker network ls 2>&1 | grep -v 'NETWORK ID' | awk -F ' ' '{print $2}'; }
__route() { [ -n "$(type -P ip)" ] && eval ip route 2>/dev/null | grep "${1:-default}" | grep -v '^$' | head -n1 || return 1; }
__is_private_ip() { grep -E '192\.168\.[0-255]\.[0-255]|10\.[0-255]\.[0-255]\.[0-255]|172\.[10-32]|172\.[10-15]' 2>/dev/null | grep -vE '127\.[0-255]\.[0-255]\.[0-255]|172\.17'; }
__public_ip() { curl -q -LSsf ${1:--4} "http://ifconfig.co" | grep -v '^$' | head -n1 | grep '^'; }
__local_lan_ip() { __ifconfig $SET_LAN_DEV | grep -w 'inet' | awk -F ' ' '{print $2}' | __is_private_ip | head -n1 | grep '^' || ip address show $SET_LAN_DEV 2>&1 | grep 'inet ' | awk -F ' ' '{print $2}' | sed 's|/.*||g' | __is_private_ip | grep -v '^$' | head -n1 | grep '^' || echo "$CURRENT_IP_4" | grep '^' || return 1; }
__my_default_lan_address() { __ifconfig $SET_LAN_DEV | grep -w 'inet' | awk -F ' ' '{print $2}' | head -n1 | grep '^' || ip address show $SET_LAN_DEV 2>&1 | grep 'inet ' | awk -F ' ' '{print $2}' | sed 's|/.*||g' | grep -v '^$' | head -n1 | grep '^' || echo "$CURRENT_IP_4" | grep '^' || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__get_device_ip_6() { ip a show "${1:-docker0}" 2>/dev/null | grep 'inet6' | awk -F ' ' '{print $2}' | sed 's|/[0-9].*||g' | head -n1 | grep '^' || false; }
__get_device_ip_4() { ip a show "${1:-docker0}" 2>/dev/null | grep -v 'inet6' | grep 'inet' | awk -F ' ' '{print $2}' | sed 's|/[0-9].*||g' | head -n1 | grep '^' || false; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__port() { echo "$((50000 + $RANDOM % 1000))" | grep '^' || return 1; }
__port_in_use() { if { [ -d "/etc/nginx/vhosts.d" ] && grep -wRsq "${1:-443}" "/etc/nginx/vhosts.d" || __netstat | grep -q "${1:-443}"; }; then return 1; else return 0; fi; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__if_file_contains() { grep -sR "$1" "$2" | grep -Ev '#|^$' | grep -q '^' || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__enable_ssl() { { [ "$SSL_ENABLED" = "yes" ] || [ "$SSL_ENABLED" = "true" ]; } && return 0 || return 1; }
__ssl_certs() { [ -f "$HOST_SSL_CA" ] && [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ] && return 0 || return 1; }
__check_ssl_cert() { if curl -q -viLSsf "${1:-$CONTAINER_HOSTNAME}" 2>&1 | grep -qE 'SSL certificate problem|does not match'; then return 0; else return 1; fi; }
__create_cert() { if __cmd_exists certbot && [ -f "/etc/certbot/dns.conf" ]; then certbot certonly -vvvv --agree-tos --email ssl-admin@$HOSTNAME -n --expand --dns-rfc2136 --dns-rfc2136-credentials "/etc/certbot/dns.conf" -d "$CONTAINER_HOSTNAME" -d "*.$CONTAINER_HOSTNAME" >/dev/null 2>&1 || return 2; fi; }
__get_service_port() { __sudo netstat -taupln | grep 'LISTEN' | awk '{print $4","$7}' | sed 's|:$||g;s|,.*/|,|g' | awk -F ':' '{print $NF}' | grep -v 'docker-proxy' | awk -F ',' '{print $2","$1}' | sort -u | grep "$1" || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure docker is installed and running
__docker_check || __docker_init
__docker_is_running || printf_exit "Docker is not running"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_password() { __password "${1:-16}"; }
__create_api_key() { __password "${1:-32}"; }
__create_secret_key() { __cmd_exists openssl && openssl rand -hex ${1:-64} || __create_api_key "${1:-64}"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# hash the password
__hash_password() { __cmd_exists htpasswd && htpasswd -bnBC 10 "" "$1" | tr -d ':\n' | sed 's/$2y/$2a/' || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__disable_service_if_port() {
  local port service exitCode=1
  for port in "$@"; do
    service="$(__get_service_port "$port")"
    if [ -n "$service" ]; then
      service="$(echo "$service" | awk -F ',' '{print $1}')"
      __sudo systemctl disable --now "$service" >/dev/null 2>&1 && exitCode=$((exitCode++))
    fi
  done
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define any pre-install scripts
__run_pre_install() {

  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__pre_docker_install_commands() {

  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define any post-install scripts
run_post_install() {

  return 0
}
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define any post-install scripts
run_post_custom() {

  return 0
}
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__show_post_message() {

  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -n "$(type -P sudo)" ] && sudo -n true && sudo true && DOCKERMGR_USER_CAN_SUDO="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set system options
SET_HOST_CORES="$({ [ -n "$(type -P getconf 2>/dev/null)" ] && getconf _NPROCESSORS_ONLN 2>/dev/null || getconf NPROCESSORS_ONLN 2>/dev/null; } || grep -shhc ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "${NUMBER_OF_PROCESSORS:-1}")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup networking
SET_LAN_DEV=$(__route | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}' | grep '^' || echo 'eth0')
SET_DOCKER_IP="$(__docker_gateway_ip || echo '172.17.0.1')"
SET_LAN_IP=$(__local_lan_ip || echo '127.0.0.1')
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get variables from env
ENV_HOSTNAME="${CONTAINER_OPT_HOSTNAME:-$ENV_HOSTNAME}"
ENV_DOMAINNAME="${CONTAINER_OPT_DOMAINNAME:-$ENV_DOMAINNAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get variables from host
SET_DOMAIN_NAME=$(__domain_name)
SET_SHORT_HOSTNAME=$(hostname -s 2>/dev/null | grep '^')
SET_LONG_HOSTNAME="$(hostname -f 2>/dev/null | grep -F '.' || echo "$HOSTNAME" | grep -F "$SET_SHORT_HOSTNAME." || echo "$SET_SHORT_HOSTNAME.$SET_DOMAIN_NAME")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set hostname and domain
SET_HOST_FULL_NAME="${ENV_HOSTNAME:-$SET_LONG_HOSTNAME}"
SET_HOST_FULL_DOMAIN="${ENV_DOMAINNAME:-$SET_DOMAIN_NAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup server mounts - [/etc/ssl/CA/certs/ca.crt] [/etc/ssl/CA/certs/host.crt] [/etc/ssl/CA/certs/host.key]
HOST_SSL_CA=""
HOST_SSL_CRT=""
HOST_SSL_KEY=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup container mounts - [/config/ssl/ca.crt] [/config/ssl/localhost.crt] [/config/ssl/localhost.key]
CONTAINER_SSL_CA=""
CONTAINER_SSL_CRT=""
CONTAINER_SSL_KEY=""
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
# Set container user and group ID - [yes/no] [id] [id]
USER_ID_ENABLED="no"
CONTAINER_USER_ID=""
CONTAINER_GROUP_ID=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set user to docker run --user [userName]
DOCKER_ADD_USER=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set group to docker run --group-add [groupName]
DOCKER_ADD_GROUP=""
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
# Set - default yes - [yes/no]
CONTAINER_PROXY_SIGNAL="yes"
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
HOST_ETC_RESOLVE_INIT_FILE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable hosts /etc/hosts file - [yes/no] [/etc/hosts]
HOST_ETC_HOSTS_ENABLED="no"
HOST_ETC_HOSTS_INIT_FILE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker socket - [yes/no] [yes/no] [/var/run/docker.sock] [/var/run/docker.sock]
DOCKER_SOCKET_ENABLED="no"
DOCKER_SOCKER_READONLY="yes"
HOST_DOCKER_SOCKET_MOUNT=""
CONTAINER_DOCKER_SOCKET_MOUNT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Will set --env-file "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env" to docker run [yes/no]
DOCKER_ENV_FILE_ENABLED=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker config - [yes/no] [~/.docker/config.json] [/root/.docker/config.json]
DOCKER_CONFIG_ENABLED="no"
HOST_DOCKER_CONFIG_FILE=""
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
# /dev /sys /proc /lib/modules mounts
HOST_DEV_MOUNT_ENABLED="no"
HOST_SYS_MOUNT_ENABLED="no"
HOST_PROC_MOUNT_ENABLED="no"
HOST_MODULES_MOUNT_ENABLED="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set Container name - Default $DOCKER_REGISTRY_USER_NAME=$APPNAME-$DOCKER_HUB_IMAGE_TAG
CONTAINER_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container hostname and domain - Default: [$APPNAME.$SET_HOST_FULL_NAME] [$SET_HOST_FULL_DOMAIN] or [hostname]
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
# Set docker Security options [unconfined]
HOST_DOCKER_SECOPT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set this to the protocol the the container will use - [http/https/git/ftp/postgres/mysql/mongodb]
CONTAINER_PROTOCOL="http"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set containers dns [127.0.0.1,1.1.1.1,8.8.8.8]
CONTAINER_DNS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup nginx proxy variables - [yes/no] [yes/no] [http] [https] [yes/no] [ip_address]
HOST_NGINX_ENABLED="yes"
HOST_NGINX_SSL_ENABLED="yes"
HOST_NGINX_HTTP_PORT="80"
HOST_NGINX_HTTPS_PORT="443"
HOST_NGINX_UPDATE_CONF="yes"
HOST_NGINX_EXTERNAL_DOMAIN=""
HOST_NGINX_INTERNAL_DOMAIN=""
HOST_NGINX_INTERNAL_HOST=""
HOST_NGINX_LISTEN_ON_IP_ADDRESS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the nginx virtualhost config name - Default $CONTAINER_HOSTNAME
HOST_NGINX_VHOST_CONFIG_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable this if container is running a webserver - [yes/no] [internalPort] [yes/no] [yes/no] [listen]
CONTAINER_WEB_SERVER_ENABLED="no"
CONTAINER_WEB_SERVER_INT_PORT="80"
CONTAINER_WEB_SERVER_SSL_ENABLED="no"
CONTAINER_WEB_SERVER_AUTH_ENABLED="no"
CONTAINER_WEB_SERVER_LISTEN_ON="docker"
CONTAINER_WEB_SERVER_INT_PATH="/"
CONTAINER_WEB_SERVER_EXT_PATH="/"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the html dir - [ENV_WWW_ROOT_DIR] [/data/www/html] [url/to/my/repo]
CONTAINER_WEB_SERVER_WWW_ENV=""
CONTAINER_WEB_SERVER_WWW_DIR=""
CONTAINER_WEB_SERVER_WWW_REPO=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Specify custom nginx vhosts - autoconfigure: [all.name/name.all/name.mydomain/name.myhost] - [virtualhost,othervhostdom]
CONTAINER_WEB_SERVER_VHOSTS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add random portmapping - [port,otherport] or [proxy|/location|port]
CONTAINER_ADD_RANDOM_PORTS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add custom port -  [exter:inter] or [.all:exter:inter/[tcp,udp] [listen:exter:inter/[tcp,udp]] random:[inter]
CONTAINER_ADD_CUSTOM_PORT=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create a single port mapping [listen]:[externalPort/random]:[internalPort]
CONTAINER_ADD_CUSTOM_SINGLE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# mail settings - [yes/no] [user] [domainname] [server]
CONTAINER_EMAIL_ENABLED=""
CONTAINER_EMAIL_USER=""
CONTAINER_EMAIL_DOMAIN=""
CONTAINER_EMAIL_RELAY_SERVER=""
CONTAINER_EMAIL_RELAY_PORT="587"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Easy setup for services - [no/yes]
CONTAINER_SERVICE_PUBLIC="yes"
CONTAINER_IS_DNS_SERVER="no"
CONTAINER_IS_DHCP_SERVER="no"
CONTAINER_IS_TFTP_SERVER="no"
CONTAINER_IS_SMTP_SERVER="no"
CONTAINER_IS_POP3_SERVER="no"
CONTAINER_IS_IMAP_SERVER="no"
CONTAINER_IS_TIME_SERVER="no"
CONTAINER_IS_NEWS_SERVER="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create a database database - [name]
CONTAINER_DATABASE_CREATE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Database settings - [listen] [yes/no]
CONTAINER_DATABASE_LISTEN=""
CONTAINER_REDIS_ENABLED="no"
CONTAINER_SQLITE_ENABLED="yes"
CONTAINER_MARIADB_ENABLED="no"
CONTAINER_MONGODB_ENABLED="no"
CONTAINER_COUCHDB_ENABLED="no"
CONTAINER_POSTGRES_ENABLED="no"
CONTAINER_SUPABASE_ENABLED="no"
CONTAINER_DEFAULT_DATABASE_TYPE="sqlite"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Should I set the create database variable? [name]
CONTAINER_CREATE_DATABASE_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Custom database setup - [yes/no] [db_name] [port] [/data/db/$CONTAINER_CUSTOM_DATABASE_NAME] [msql]
CONTAINER_CUSTOM_DATABASE_ENABLED=""
CONTAINER_CUSTOM_DATABASE_NAME=""
CONTAINER_CUSTOM_DATABASE_PORT=""
CONTAINER_CUSTOM_DATABASE_DIR=""
CONTAINER_CUSTOM_DATABASE_PROTOCOL=""
CONTAINER_CUSTOM_DATABASE_ADMIN_WWW_ROOT="/usr/local/share/httpd/admin/custom"
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
# Set the database mount point [/app/db] [$HOST_DATA_DIR/db/custom/$CONTAINER_NAME]
CONTAINER_DATABASE_DIR=""
HOST_MOUNT_DATABASE_DIR=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set a username and password - [user] [pass/random]
CONTAINER_USER_NAME=""
CONTAINER_USER_PASS=""
CONTAINER_PASS_LENGTH="24"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set container username and password enviroment name - [CONTAINER_ENV_USER_NAME=$CONTAINER_USER_NAME] [CONTAINER_ENV_PASS_NAME=$CONTAINER_USER_PASS]
CONTAINER_ENV_USER_NAME=""
CONTAINER_ENV_PASS_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# If container has an api token set it here - [ENV_NAME] [token/random]
CONTAINER_API_KEY_NAME=""
CONTAINER_API_KEY_TOKEN="random"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# If container has an secret key set it here - [ENV_NAME] [token/random]
CONTAINER_SECRET_KEY_NAME=""
CONTAINER_SECRET_KEY_TOKEN="random"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# If container has an admin password that needs to be hashed then set it here - [pass/random]
CONTAINER_USER_ADMIN_HASH_ENV=""
CONTAINER_USER_ADMIN_HASH_PASS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# If container requires a db connection string variable set it here
CONTAINER_DB_ENV_NAME=""
CONTAINER_DB_ENV_STRING=""
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
# Define additional mounts - add HOST/ to use $DATA_DIR/rootfs - [/dir:/dir,/otherdir:/otherdir]
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
# set the max log file - [0-9][k|m|g]
DOCKER_MAX_LOG_FILE="10m"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom capabilites - [NAME]
DOCKER_CUSTOM_CAP=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set capabilites - [yes/no]
DOCKER_CAP_SYS_TIME="yes"
DOCKER_CAP_SYS_ADMIN="yes"
DOCKER_CAP_CHOWN="yes"
DOCKER_CAP_NET_RAW="no"
DOCKER_CAP_SYS_NICE="no"
DOCKER_CAP_NET_ADMIN="no"
DOCKER_CAP_SYS_MODULE="no"
DOCKER_CAP_NET_BIND_SERVICE="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define labels - [traefik.enable=true,label=label,otherlabel=label2]
CONTAINER_LABELS=""
CONTAINER_LABELS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Specify container arguments - will run in container - [/path/to/script]
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
CONTAINER_CREATE_DIRECTORY="/data/$APPNAME,/data/logs/$APPNAME,/config/$APPNAME "
CONTAINER_CREATE_DIRECTORY+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# enable the health check - creates a cron script - [yes/no] [/health] [$CONTAINER_NGINX_PROXY_URL]
HOST_SERVER_HEALTH_CHECK_ENABLED=""
HOST_SERVER_HEALTH_CHECK_SERVER_URI=""
HOST_SERVER_HEALTH_CHECK_SERVER_NAME=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Containers default username/password
CONTAINER_DEFAULT_USERNAME=""
CONTAINER_DEFAULT_PASSWORD=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show post install message
POST_SHOW_FINISHED_MESSAGE=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run the script if it exists [yes/no]
DOCKERMGR_ENABLE_INSTALL_SCRIPT="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Init only - This should be no [yes/no]
INIT_SCRIPT_ONLY="no"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# enable cron jobs [yes/no] [user] [command_to_execute] [[0-59] [0-23] [0-6] [1-31] [1-12] [file] or [@hourly/@daily/@monthly/@yearly]]
__setup_cron() {
  HOST_CRON_ENABLED="no"
  HOST_CRON_COMMAND=""
  HOST_CRON_USER="root"
  HOST_CRON_MIN='30'
  HOST_CRON_HOUR='0'
  HOST_CRON_WEEK_DAY='*'
  HOST_CRON_MONTH_DAY='*'
  HOST_CRON_MONTH_NAME='*'
  HOST_CRON_LOG_FILE="/dev/null"
  # [@hourly/@daily/@monthly/@yearly]
  HOST_CRON_AT_SCHEDULE=''
  # NO NEED TO CHANGE
  if [ -n "$HOST_CRON_AT_SCHEDULE" ]; then
    HOST_CRON_SCHEDULE="$(__trim "$HOST_CRON_AT_SCHEDULE")"
  else
    HOST_CRON_SCHEDULE="$(__trim "$HOST_CRON_MIN $HOST_CRON_HOUR $HOST_CRON_MONTH_DAY $HOST_CRON_MONTH_NAME $HOST_CRON_MONTH_DAY")"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom container enviroment variables - [MYVAR="VAR"]
__custom_docker_env() {
  cat <<EOF | tee -p | grep -v '^$'

EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom script - saves to /config/env/GEN_SCRIPT_REPLACE_APPNAME.script.sh
__custom_docker_script() {
  cat <<EOF | tee -p | grep -v '^$'

# Database settings
ENV_DATABASE_CREATE="${CONTAINER_DATABASE_CREATE:-}"
ENV_DATABASE_USER="${CONTAINER_DATABASE_USER_NORMAL:-}"
ENV_DATABASE_PASSWORD="${CONTAINER_DATABASE_PASS_NORMAL:-}"
ENV_DATABASE_ROOT_USER="${CONTAINER_DATABASE_USER_ROOT:-}"
ENV_DATABASE_ROOT_PASSWORD="${CONTAINER_DATABASE_PASS_ROOT:-}"
EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# this function will create an env file in the containers filesystem - see CONTAINER_ENV_FILE_ENABLED
__container_import_variables() {
  [ "$CONTAINER_ENV_FILE_ENABLED" = "yes" ] || return 0
  local base_dir="" base_file="$1"
  base_dir="$(realpath "$DATADIR")/$(dirname "$base_file")"
  [ -d "$base_dir" ] || mkdir -p "$base_dir"
  [ -f "$base_dir/$base_file" ] && return
  cat <<EOF | __remove_extra_spaces | tee -p "$base_dir/$base_file" &>/dev/null

EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__dockermgr_variables() {
  [ -d "$DOCKERMGR_CONFIG_DIR/env" ] || mkdir -p "$DOCKERMGR_CONFIG_DIR/env"
  cat <<EOF | tee -p | tr '|' '\n' | __remove_extra_spaces
# Enviroment variables for $CONTAINER_NAME
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENV_CONTAINER_NAME="\${ENV_CONTAINER_NAME:-${CONTAINER_NAME:-$APPNAME}}"
ENV_DOCKER_HUB_IMAGE_TAG="\${ENV_DOCKER_HUB_IMAGE_TAG:-$DOCKER_HUB_IMAGE_TAG}"
ENV_DOCKER_REGISTRY_URL="\${ENV_DOCKER_REGISTRY_URL:-$DOCKER_REGISTRY_URL}"
ENV_DOCKER_REGISTRY_REPO_NAME="\${ENV_DOCKER_REGISTRY_REPO_NAME:-$DOCKER_REGISTRY_REPO_NAME}"
ENV_DOCKER_REGISTRY_USER_NAME="\${ENV_DOCKER_REGISTRY_USER_NAME:-$DOCKER_REGISTRY_USER_NAME}"
ENV_DOCKER_REGISTRY_IMAGE_TAG="\${ENV_DOCKER_REGISTRY_IMAGE_TAG:-$DOCKER_REGISTRY_IMAGE_TAG}"
ENV_DOCKER_HUB_IMAGE_URL="\${ENV_DOCKER_HUB_IMAGE_URL:-$DOCKER_HUB_IMAGE_URL}"
ENV_SET_CONTAINER_NAME="\${ENV_SET_CONTAINER_NAME:-$SET_CONTAINER_NAME}"
ENV_REPO="\${ENV_REPO:-$REPO}"
ENV_APPVERSION="\${ENV_APPVERSION:-$APPVERSION}"
ENV_DOCKERMGR_CONFIG_DIR="\${ENV_DOCKERMGR_CONFIG_DIR:-$DOCKERMGR_CONFIG_DIR}"
ENV_SET_INSTDIR="\${ENV_SET_INSTDIR:-$SET_INSTDIR}"
ENV_SET_APPDIR="\${ENV_SET_APPDIR:-$SET_APPDIR}"
ENV_SET_DATADIR="\${ENV_SET_DATADIR:-$SET_DATADIR}"
ENV_SETOPTS="\${ENV_SETOPTS:-$SETOPTS}"
ENV_SET_HOST_CORES="\${ENV_SET_HOST_CORES:-$SET_HOST_CORES}"
ENV_SET_LAN_DEV="\${ENV_SET_LAN_DEV:-$SET_LAN_DEV}"
ENV_SET_DOCKER_IP="\${ENV_SET_DOCKER_IP:-$SET_DOCKER_IP}"
ENV_SET_LAN_IP="\${ENV_SET_LAN_IP:-$SET_LAN_IP}"
ENV_ENV_HOSTNAME="\${ENV_ENV_HOSTNAME:-$ENV_HOSTNAME}"
ENV_ENV_DOMAINNAME="\${ENV_ENV_DOMAINNAME:-$ENV_DOMAINNAME}"
ENV_SET_DOMAIN_NAME="\${ENV_SET_DOMAIN_NAME:-$SET_DOMAIN_NAME}"
ENV_SET_SHORT_HOSTNAME="\${ENV_SET_SHORT_HOSTNAME:-$SET_SHORT_HOSTNAME}"
ENV_SET_LONG_HOSTNAME="\${ENV_SET_LONG_HOSTNAME:-$SET_LONG_HOSTNAME}"
ENV_SET_HOST_FULL_NAME="\${ENV_SET_HOST_FULL_NAME:-$SET_HOST_FULL_NAME}"
ENV_SET_HOST_FULL_DOMAIN="\${ENV_SET_HOST_FULL_DOMAIN:-$SET_HOST_FULL_DOMAIN}"
ENV_HOST_SSL_CA="\${ENV_HOST_SSL_CA:-$HOST_SSL_CA}"
ENV_HOST_SSL_CRT="\${ENV_HOST_SSL_CRT:-$HOST_SSL_CRT}"
ENV_HOST_SSL_KEY="\${ENV_HOST_SSL_KEY:-$HOST_SSL_KEY}"
ENV_CONTAINER_SSL_CA="\${ENV_CONTAINER_SSL_CA:-$CONTAINER_SSL_CA}"
ENV_CONTAINER_SSL_CRT="\${ENV_CONTAINER_SSL_CRT:-$CONTAINER_SSL_CRT}"
ENV_CONTAINER_SSL_KEY="\${ENV_CONTAINER_SSL_KEY:-$CONTAINER_SSL_KEY}"
ENV_CONTAINER_REQUIRES="\${ENV_CONTAINER_REQUIRES:-$CONTAINER_REQUIRES}"
ENV_CONTAINER_TIMEZONE="\${ENV_CONTAINER_TIMEZONE:-$CONTAINER_TIMEZONE}"
ENV_CONTAINER_WORK_DIR="\${ENV_CONTAINER_WORK_DIR:-$CONTAINER_WORK_DIR}"
ENV_USER_ID_ENABLED="\${ENV_USER_ID_ENABLED:-$USER_ID_ENABLED}"
ENV_CONTAINER_USER_ID="\${ENV_CONTAINER_USER_ID:-$CONTAINER_USER_ID}"
ENV_CONTAINER_GROUP_ID="\${ENV_CONTAINER_GROUP_ID:-$CONTAINER_GROUP_ID}"
ENV_DOCKER_ADD_USER="\${ENV_DOCKER_ADD_USER:-$DOCKER_ADD_USER}}"
ENV_DOCKER_ADD_GROUP="\${ENV_DOCKER_ADD_GROUP:-$DOCKER_ADD_GROUP}}"
ENV_CONTAINER_USER_RUN="\${ENV_CONTAINER_USER_RUN:-$CONTAINER_USER_RUN}"
ENV_CONTAINER_PRIVILEGED_ENABLED="\${ENV_CONTAINER_PRIVILEGED_ENABLED:-$CONTAINER_PRIVILEGED_ENABLED}"
ENV_CONTAINER_SHM_SIZE="\${ENV_CONTAINER_SHM_SIZE:-$CONTAINER_SHM_SIZE}"
ENV_CONTAINER_RAM_SIZE="\${ENV_CONTAINER_RAM_SIZE:-$CONTAINER_RAM_SIZE}"
ENV_CONTAINER_SWAP_SIZE="\${ENV_CONTAINER_SWAP_SIZE:-$CONTAINER_SWAP_SIZE}"
ENV_CONTAINER_CPU_COUNT="\${ENV_CONTAINER_CPU_COUNT:-$CONTAINER_CPU_COUNT}"
ENV_CONTAINER_PROXY_SIGNAL="\${ENV_CONTAINER_PROXY_SIGNAL:-$CONTAINER_PROXY_SIGNAL}"
ENV_CONTAINER_AUTO_RESTART="\${ENV_CONTAINER_AUTO_RESTART:-$CONTAINER_AUTO_RESTART}"
ENV_CONTAINER_AUTO_DELETE="\${ENV_CONTAINER_AUTO_DELETE:-$CONTAINER_AUTO_DELETE}"
ENV_CONTAINER_TTY_ENABLED="\${ENV_CONTAINER_TTY_ENABLED:-$CONTAINER_TTY_ENABLED}"
ENV_CONTAINER_INTERACTIVE_ENABLED="\${ENV_CONTAINER_INTERACTIVE_ENABLED:-$CONTAINER_INTERACTIVE_ENABLED}"
ENV_CONTAINER_ENV_FILE_ENABLED="\${ENV_CONTAINER_ENV_FILE_ENABLED:-$CONTAINER_ENV_FILE_ENABLED}"
ENV_CONTAINER_ENV_FILE_MOUNT="\${ENV_CONTAINER_ENV_FILE_MOUNT:-$CONTAINER_ENV_FILE_MOUNT}"
ENV_CGROUPS_ENABLED="\${ENV_CGROUPS_ENABLED:-$CGROUPS_ENABLED}"
ENV_CGROUPS_MOUNTS="\${ENV_CGROUPS_MOUNTS:-$CGROUPS_MOUNTS}"
ENV_HOST_RESOLVE_ENABLED="\${ENV_HOST_RESOLVE_ENABLED:-$HOST_RESOLVE_ENABLED}"
ENV_HOST_ETC_RESOLVE_INIT_FILE="\${ENV_HOST_ETC_RESOLVE_INIT_FILE:-$HOST_ETC_RESOLVE_INIT_FILE}"
ENV_HOST_ETC_HOSTS_ENABLED="\${ENV_HOST_ETC_HOSTS_ENABLED:-$HOST_ETC_HOSTS_ENABLED}"
ENV_HOST_ETC_HOSTS_INIT_FILE="\${ENV_HOST_ETC_HOSTS_INIT_FILE:-$HOST_ETC_HOSTS_INIT_FILE}"
ENV_DOCKER_SOCKET_ENABLED="\${ENV_DOCKER_SOCKET_ENABLED:-$DOCKER_SOCKET_ENABLED}"
ENV_DOCKER_SOCKER_READONLY="\${ENV_DOCKER_SOCKER_READONLY:-$DOCKER_SOCKER_READONLY}"
ENV_HOST_DOCKER_SOCKET_MOUNT="\${ENV_HOST_DOCKER_SOCKET_MOUNT:-$HOST_DOCKER_SOCKET_MOUNT}"
ENV_CONTAINER_DOCKER_SOCKET_MOUNT="\${ENV_CONTAINER_DOCKER_SOCKET_MOUNT:-$CONTAINER_DOCKER_SOCKET_MOUNT}"
ENV_DOCKER_ENV_FILE_ENABLED="\${ENV_DOCKER_ENV_FILE_ENABLED:-$DOCKER_ENV_FILE_ENABLED}"
ENV_DOCKER_CONFIG_ENABLED="\${ENV_DOCKER_CONFIG_ENABLED:-$DOCKER_CONFIG_ENABLED}"
ENV_HOST_DOCKER_CONFIG="\${ENV_HOST_DOCKER_CONFIG:-$HOST_DOCKER_CONFIG_FILE}"
ENV_CONTAINER_DOCKER_CONFIG_FILE="\${ENV_CONTAINER_DOCKER_CONFIG_FILE:-$CONTAINER_DOCKER_CONFIG_FILE}"
ENV_DOCKER_SOUND_ENABLED="\${ENV_DOCKER_SOUND_ENABLED:-$DOCKER_SOUND_ENABLED}"
ENV_HOST_SOUND_DEVICE="\${ENV_HOST_SOUND_DEVICE:-$HOST_SOUND_DEVICE}"
ENV_CONTAINER_SOUND_DEVICE_FILE="\${ENV_CONTAINER_SOUND_DEVICE_FILE:-$CONTAINER_SOUND_DEVICE_FILE}"
ENV_CONTAINER_X11_ENABLED="\${ENV_CONTAINER_X11_ENABLED:-$CONTAINER_X11_ENABLED}"
ENV_HOST_X11_DISPLAY="\${ENV_HOST_X11_DISPLAY:-$HOST_X11_DISPLAY}"
ENV_HOST_X11_SOCKET="\${ENV_HOST_X11_SOCKET:-$HOST_X11_SOCKET}"
ENV_HOST_X11_XAUTH="\${ENV_HOST_X11_XAUTH:-$HOST_X11_XAUTH}"
ENV_CONTAINER_X11_SOCKET="\${ENV_CONTAINER_X11_SOCKET:-$CONTAINER_X11_SOCKET}"
ENV_CONTAINER_X11_XAUTH="\${ENV_CONTAINER_X11_XAUTH:-$CONTAINER_X11_XAUTH}"
ENV_HOST_DEV_MOUNT_ENABLED="\${ENV_HOST_DEV_MOUNT_ENABLED:-$HOST_DEV_MOUNT_ENABLED}"
ENV_HOST_SYS_MOUNT_ENABLED="\${ENV_HOST_SYS_MOUNT_ENABLED:-$HOST_SYS_MOUNT_ENABLED}"
ENV_HOST_PROC_MOUNT_ENABLED="\${ENV_HOST_PROC_MOUNT_ENABLED:-$HOST_PROC_MOUNT_ENABLED}"
ENV_HOST_MODULES_MOUNT_ENABLED="\${ENV_HOST_MODULES_MOUNT_ENABLED:-$HOST_MODULES_MOUNT_ENABLED}"
ENV_CONTAINER_HOSTNAME="\${ENV_CONTAINER_HOSTNAME:-$CONTAINER_HOSTNAME}"
ENV_CONTAINER_DOMAINNAME="\${ENV_CONTAINER_DOMAINNAME:-$CONTAINER_DOMAINNAME}"
ENV_HOST_DOCKER_NETWORK="\${ENV_HOST_DOCKER_NETWORK:-$HOST_DOCKER_NETWORK}"
ENV_HOST_DOCKER_LINK="\${ENV_HOST_DOCKER_LINK:-$HOST_DOCKER_LINK}"
ENV_HOST_NETWORK_ADDR="\${ENV_HOST_NETWORK_ADDR:-$HOST_NETWORK_ADDR}"
ENV_HOST_DOCKER_SECOPT="\${ENV_HOST_DOCKER_SECOPT:-$HOST_DOCKER_SECOPT}"
ENV_CONTAINER_PROTOCOL="\${ENV_CONTAINER_PROTOCOL:-$CONTAINER_PROTOCOL}"
ENV_CONTAINER_DNS="\${ENV_CONTAINER_DNS:-$CONTAINER_DNS}"
ENV_HOST_NGINX_ENABLED="\${ENV_HOST_NGINX_ENABLED:-$HOST_NGINX_ENABLED}"
ENV_HOST_NGINX_SSL_ENABLED="\${ENV_HOST_NGINX_SSL_ENABLED:-$HOST_NGINX_SSL_ENABLED}"
ENV_HOST_NGINX_HTTP_PORT="\${ENV_HOST_NGINX_HTTP_PORT:-$HOST_NGINX_HTTP_PORT}"
ENV_HOST_NGINX_HTTPS_PORT="\${ENV_HOST_NGINX_HTTPS_PORT:-$HOST_NGINX_HTTPS_PORT}"
ENV_HOST_NGINX_UPDATE_CONF="\${ENV_HOST_NGINX_UPDATE_CONF:-$HOST_NGINX_UPDATE_CONF}"
ENV_HOST_NGINX_EXTERNAL_DOMAIN="\${ENV_HOST_NGINX_EXTERNAL_DOMAIN:-$HOST_NGINX_EXTERNAL_DOMAIN}"
ENV_HOST_NGINX_INTERNAL_DOMAIN="\${ENV_HOST_NGINX_INTERNAL_DOMAIN:-$HOST_NGINX_INTERNAL_DOMAIN}"
ENV_HOST_NGINX_INTERNAL_HOST="\${ENV_HOST_NGINX_INTERNAL_HOST:-$HOST_NGINX_INTERNAL_HOST}"
ENV_HOST_NGINX_LISTEN_ON_IP_ADDRESS="\${ENV_HOST_NGINX_LISTEN_ON_IP_ADDRESS:-$HOST_NGINX_LISTEN_ON_IP_ADDRESS}"
ENV_HOST_NGINX_VHOST_CONFIG_NAME="\${ENV_HOST_NGINX_VHOST_CONFIG_NAME:-$HOST_NGINX_VHOST_CONFIG_NAME}"
ENV_CONTAINER_WEB_SERVER_ENABLED="\${ENV_CONTAINER_WEB_SERVER_ENABLED:-$CONTAINER_WEB_SERVER_ENABLED}"
ENV_CONTAINER_WEB_SERVER_INT_PORT="\${ENV_CONTAINER_WEB_SERVER_INT_PORT:-$CONTAINER_WEB_SERVER_INT_PORT}"
ENV_CONTAINER_WEB_SERVER_SSL_ENABLED="\${ENV_CONTAINER_WEB_SERVER_SSL_ENABLED:-$CONTAINER_WEB_SERVER_SSL_ENABLED}"
ENV_CONTAINER_WEB_SERVER_AUTH_ENABLED="\${ENV_CONTAINER_WEB_SERVER_AUTH_ENABLED:-$CONTAINER_WEB_SERVER_AUTH_ENABLED}"
ENV_CONTAINER_WEB_SERVER_LISTEN_ON="\${ENV_CONTAINER_WEB_SERVER_LISTEN_ON:-$CONTAINER_WEB_SERVER_LISTEN_ON}"
ENV_CONTAINER_WEB_SERVER_INT_PATH="\${ENV_CONTAINER_WEB_SERVER_INT_PATH:-$CONTAINER_WEB_SERVER_INT_PATH}"
ENV_CONTAINER_WEB_SERVER_EXT_PATH="\${ENV_CONTAINER_WEB_SERVER_EXT_PATH:-$CONTAINER_WEB_SERVER_EXT_PATH}"
ENV_CONTAINER_WEB_SERVER_WWW_ENV="\${ENV_CONTAINER_WEB_SERVER_WWW_ENV:-$CONTAINER_WEB_SERVER_WWW_ENV}"
ENV_CONTAINER_WEB_SERVER_WWW_DIR="\${ENV_CONTAINER_WEB_SERVER_WWW_DIR:-$CONTAINER_WEB_SERVER_WWW_DIR}"
ENV_CONTAINER_WEB_SERVER_WWW_REPO="\${ENV_CONTAINER_WEB_SERVER_WWW_REPO:-$CONTAINER_WEB_SERVER_WWW_REPO}"
ENV_CONTAINER_WEB_SERVER_VHOSTS="\${ENV_CONTAINER_WEB_SERVER_VHOSTS:-$CONTAINER_WEB_SERVER_VHOSTS}"
ENV_CONTAINER_ADD_RANDOM_PORTS="\${ENV_CONTAINER_ADD_RANDOM_PORTS:-$CONTAINER_ADD_RANDOM_PORTS}"
ENV_CONTAINER_ADD_CUSTOM_PORT="\${ENV_CONTAINER_ADD_CUSTOM_PORT:-$CONTAINER_ADD_CUSTOM_PORT}"
ENV_CONTAINER_ADD_CUSTOM_SINGLE="\${ENV_CONTAINER_ADD_CUSTOM_SINGLE:-$CONTAINER_ADD_CUSTOM_SINGLE}"
ENV_CONTAINER_EMAIL_ENABLED="\${ENV_CONTAINER_EMAIL_ENABLED:-$CONTAINER_EMAIL_ENABLED}"
ENV_CONTAINER_EMAIL_USER="\${ENV_CONTAINER_EMAIL_USER:-$CONTAINER_EMAIL_USER}"
ENV_CONTAINER_EMAIL_DOMAIN="\${ENV_CONTAINER_EMAIL_DOMAIN:-$CONTAINER_EMAIL_DOMAIN}"
ENV_CONTAINER_EMAIL_RELAY_SERVER="\${ENV_CONTAINER_EMAIL_RELAY_SERVER:-$CONTAINER_EMAIL_RELAY_SERVER}"
ENV_CONTAINER_EMAIL_RELAY_PORT="\${ENV_CONTAINER_EMAIL_RELAY_PORT:-$CONTAINER_EMAIL_RELAY_PORT}"
ENV_CONTAINER_SERVICE_PUBLIC="\${ENV_CONTAINER_SERVICE_PUBLIC:-$CONTAINER_SERVICE_PUBLIC}"
ENV_CONTAINER_IS_DNS_SERVER="\${ENV_CONTAINER_IS_DNS_SERVER:-$CONTAINER_IS_DNS_SERVER}"
ENV_CONTAINER_IS_DHCP_SERVER="\${ENV_CONTAINER_IS_DHCP_SERVER:-$CONTAINER_IS_DHCP_SERVER}"
ENV_CONTAINER_IS_TFTP_SERVER="\${ENV_CONTAINER_IS_TFTP_SERVER:-$CONTAINER_IS_TFTP_SERVER}"
ENV_CONTAINER_IS_SMTP_SERVER="\${ENV_CONTAINER_IS_SMTP_SERVER:-$CONTAINER_IS_SMTP_SERVER}"
ENV_CONTAINER_IS_POP3_SERVER="\${ENV_CONTAINER_IS_POP3_SERVER:-$CONTAINER_IS_POP3_SERVER}"
ENV_CONTAINER_IS_IMAP_SERVER="\${ENV_CONTAINER_IS_IMAP_SERVER:-$CONTAINER_IS_IMAP_SERVER}"
ENV_CONTAINER_IS_TIME_SERVER="\${ENV_CONTAINER_IS_TIME_SERVER:-$CONTAINER_IS_TIME_SERVER}"
ENV_CONTAINER_IS_NEWS_SERVER="\${ENV_CONTAINER_IS_NEWS_SERVER:-$CONTAINER_IS_NEWS_SERVER}"
ENV_CONTAINER_DATABASE_CREATE="\${ENV_CONTAINER_DATABASE_CREATE:-$CONTAINER_DATABASE_CREATE}"
ENV_CONTAINER_DATABASE_LISTEN="\${ENV_CONTAINER_DATABASE_LISTEN:-$CONTAINER_DATABASE_LISTEN}"
ENV_CONTAINER_REDIS_ENABLED="\${ENV_CONTAINER_REDIS_ENABLED:-$CONTAINER_REDIS_ENABLED}"
ENV_CONTAINER_SQLITE_ENABLED="\${ENV_CONTAINER_SQLITE_ENABLED:-$CONTAINER_SQLITE_ENABLED}"
ENV_CONTAINER_MARIADB_ENABLED="\${ENV_CONTAINER_MARIADB_ENABLED:-$CONTAINER_MARIADB_ENABLED}"
ENV_CONTAINER_MONGODB_ENABLED="\${ENV_CONTAINER_MONGODB_ENABLED:-$CONTAINER_MONGODB_ENABLED}"
ENV_CONTAINER_COUCHDB_ENABLED="\${ENV_CONTAINER_COUCHDB_ENABLED:-$CONTAINER_COUCHDB_ENABLED}"
ENV_CONTAINER_POSTGRES_ENABLED="\${ENV_CONTAINER_POSTGRES_ENABLED:-$CONTAINER_POSTGRES_ENABLED}"
ENV_CONTAINER_SUPABASE_ENABLED="\${ENV_CONTAINER_SUPABASE_ENABLED:-$CONTAINER_SUPABASE_ENABLED}"
ENV_CONTAINER_DEFAULT_DATABASE_TYPE="\${ENV_CONTAINER_DEFAULT_DATABASE_TYPE:-$CONTAINER_DEFAULT_DATABASE_TYPE}"
ENV_CONTAINER_CREATE_DATABASE_NAME="\${ENV_CONTAINER_CREATE_DATABASE_NAME:-$CONTAINER_CREATE_DATABASE_NAME}"
ENV_CONTAINER_CUSTOM_DATABASE_ENABLED="\${ENV_CONTAINER_CUSTOM_DATABASE_ENABLED:-$CONTAINER_CUSTOM_DATABASE_ENABLED}"
ENV_CONTAINER_CUSTOM_DATABASE_NAME="\${ENV_CONTAINER_CUSTOM_DATABASE_NAME:-$CONTAINER_CUSTOM_DATABASE_NAME}"
ENV_CONTAINER_CUSTOM_DATABASE_PORT="\${ENV_CONTAINER_CUSTOM_DATABASE_PORT:-$CONTAINER_CUSTOM_DATABASE_PORT}"
ENV_CONTAINER_CUSTOM_DATABASE_DIR="\${ENV_CONTAINER_CUSTOM_DATABASE_DIR:-$CONTAINER_CUSTOM_DATABASE_DIR}"
ENV_CONTAINER_CUSTOM_DATABASE_PROTOCOL="\${ENV_CONTAINER_CUSTOM_DATABASE_PROTOCOL:-$CONTAINER_CUSTOM_DATABASE_PROTOCOL}"
ENV_CONTAINER_CUSTOM_DATABASE_ADMIN_WWW_ROOT="\${ENV_CONTAINER_CUSTOM_DATABASE_ADMIN_WWW_ROOT:-$CONTAINER_CUSTOM_DATABASE_ADMIN_WWW_ROOT}"
ENV_CONTAINER_DATABASE_USER_ROOT="\${ENV_CONTAINER_DATABASE_USER_ROOT:-$CONTAINER_DATABASE_USER_ROOT}"
ENV_CONTAINER_DATABASE_LENGTH_ROOT="\${ENV_CONTAINER_DATABASE_LENGTH_ROOT:-$CONTAINER_DATABASE_LENGTH_ROOT}"
ENV_CONTAINER_DATABASE_USER_NORMAL="\${ENV_CONTAINER_DATABASE_USER_NORMAL:-$CONTAINER_DATABASE_USER_NORMAL}"
ENV_CONTAINER_DATABASE_LENGTH_NORMAL="\${ENV_CONTAINER_DATABASE_LENGTH_NORMAL:-$CONTAINER_DATABASE_LENGTH_NORMAL}"
ENV_CONTAINER_DATABASE_DIR="\${ENV_CONTAINER_DATABASE_DIR:-$CONTAINER_DATABASE_DIR}"
ENV_HOST_MOUNT_DATABASE_DIR="\${ENV_HOST_MOUNT_DATABASE_DIR:-$HOST_MOUNT_DATABASE_DIR}"
ENV_CONTAINER_USER_NAME="\${ENV_CONTAINER_USER_NAME:-$CONTAINER_USER_NAME}"
ENV_CONTAINER_PASS_LENGTH="\${ENV_CONTAINER_PASS_LENGTH:-$CONTAINER_PASS_LENGTH}"
ENV_CONTAINER_ENV_USER_NAME="\${ENV_CONTAINER_ENV_USER_NAME:-$CONTAINER_ENV_USER_NAME}"
ENV_CONTAINER_ENV_PASS_NAME="\${ENV_CONTAINER_ENV_PASS_NAME:-$CONTAINER_ENV_PASS_NAME}"
ENV_CONTAINER_API_KEY_NAME="\${ENV_CONTAINER_API_KEY_NAME:-$CONTAINER_API_KEY_NAME}"
ENV_CONTAINER_SECRET_KEY_NAME="\${ENV_CONTAINER_SECRET_KEY_NAME:-$CONTAINER_SECRET_KEY_NAME}"
ENV_CONTAINER_USER_ADMIN_HASH_ENV="\${ENV_CONTAINER_USER_ADMIN_HASH_ENV:-$CONTAINER_USER_ADMIN_HASH_ENV}"
ENV_CONTAINER_SERVICES_LIST="\${ENV_CONTAINER_SERVICES_LIST:-$CONTAINER_SERVICES_LIST}"
ENV_CONTAINER_MOUNT_DATA_ENABLED="\${ENV_CONTAINER_MOUNT_DATA_ENABLED:-$CONTAINER_MOUNT_DATA_ENABLED}"
ENV_CONTAINER_MOUNT_DATA_MOUNT_DIR="\${ENV_CONTAINER_MOUNT_DATA_MOUNT_DIR:-$CONTAINER_MOUNT_DATA_MOUNT_DIR}"
ENV_CONTAINER_MOUNT_CONFIG_ENABLED="\${ENV_CONTAINER_MOUNT_CONFIG_ENABLED:-$CONTAINER_MOUNT_CONFIG_ENABLED}"
ENV_CONTAINER_MOUNT_CONFIG_MOUNT_DIR="\${ENV_CONTAINER_MOUNT_CONFIG_MOUNT_DIR:-$CONTAINER_MOUNT_CONFIG_MOUNT_DIR}"
ENV_CONTAINER_MOUNTS="\${ENV_CONTAINER_MOUNTS:-$CONTAINER_MOUNTS}"
ENV_CONTAINER_DEVICES="\${ENV_CONTAINER_DEVICES:-$CONTAINER_DEVICES}"
ENV_CONTAINER_ENV="\${ENV_CONTAINER_ENV:-$CONTAINER_ENV}"
ENV_CONTAINER_SYSCTL="\${ENV_CONTAINER_SYSCTL:-$CONTAINER_SYSCTL}"
ENV_DOCKER_MAX_LOG_FILE="\${ENV_DOCKER_MAX_LOG_FILE:-$DOCKER_MAX_LOG_FILE}"
ENV_DOCKER_CUSTOM_CAP="\${ENV_DOCKER_CUSTOM_CAP:-$DOCKER_CUSTOM_CAP}"
ENV_DOCKER_CAP_SYS_TIME="\${ENV_DOCKER_CAP_SYS_TIME:-$DOCKER_CAP_SYS_TIME}"
ENV_DOCKER_CAP_SYS_ADMIN="\${ENV_DOCKER_CAP_SYS_ADMIN:-$DOCKER_CAP_SYS_ADMIN}"
ENV_DOCKER_CAP_CHOWN="\${ENV_DOCKER_CAP_CHOWN:-$DOCKER_CAP_CHOWN}"
ENV_DOCKER_CAP_NET_RAW="\${ENV_DOCKER_CAP_NET_RAW:-$DOCKER_CAP_NET_RAW}"
ENV_DOCKER_CAP_SYS_NICE="\${ENV_DOCKER_CAP_SYS_NICE:-$DOCKER_CAP_SYS_NICE}"
ENV_DOCKER_CAP_NET_ADMIN="\${ENV_DOCKER_CAP_NET_ADMIN:-$DOCKER_CAP_NET_ADMIN}"
ENV_DOCKER_CAP_SYS_MODULE="\${ENV_DOCKER_CAP_SYS_MODULE:-$DOCKER_CAP_SYS_MODULE}"
ENV_DOCKER_CAP_NET_BIND_SERVICE="\${ENV_DOCKER_CAP_NET_BIND_SERVICE:-$DOCKER_CAP_NET_BIND_SERVICE}"
ENV_CONTAINER_LABELS="\${ENV_CONTAINER_LABELS:-$CONTAINER_LABELS}"
ENV_CONTAINER_COMMANDS="\${ENV_CONTAINER_COMMANDS:-$CONTAINER_COMMANDS}"
ENV_DOCKER_CUSTOM_ARGUMENTS="\${ENV_DOCKER_CUSTOM_ARGUMENTS:-$DOCKER_CUSTOM_ARGUMENTS}"
ENV_CONTAINER_DEBUG_ENABLED="\${ENV_CONTAINER_DEBUG_ENABLED:-$CONTAINER_DEBUG_ENABLED}"
ENV_CONTAINER_DEBUG_OPTIONS="\${ENV_CONTAINER_DEBUG_OPTIONS:-$CONTAINER_DEBUG_OPTIONS}"
ENV_CONTAINER_CREATE_DIRECTORY="\${ENV_CONTAINER_CREATE_DIRECTORY:-$CONTAINER_CREATE_DIRECTORY}"
ENV_HOST_SERVER_HEALTH_CHECK_ENABLED="\${ENV_HOST_SERVER_HEALTH_CHECK_ENABLED:-$HOST_SERVER_HEALTH_CHECK_ENABLED}"
ENV_HOST_SERVER_HEALTH_CHECK_SERVER_URI="\${ENV_HOST_SERVER_HEALTH_CHECK_SERVER_URI:-$HOST_SERVER_HEALTH_CHECK_SERVER_URI}"
ENV_HOST_SERVER_HEALTH_CHECK_SERVER_NAME="\${ENV_HOST_SERVER_HEALTH_CHECK_SERVER_NAME:-$HOST_SERVER_HEALTH_CHECK_SERVER_NAME}"
ENV_CONTAINER_DEFAULT_USERNAME="\${ENV_CONTAINER_DEFAULT_USERNAME:-$CONTAINER_DEFAULT_USERNAME}"
ENV_POST_SHOW_FINISHED_MESSAGE="\${ENV_POST_SHOW_FINISHED_MESSAGE:-$POST_SHOW_FINISHED_MESSAGE}"
ENV_DOCKERMGR_ENABLE_INSTALL_SCRIPT="\${ENV_DOCKERMGR_ENABLE_INSTALL_SCRIPT:-$DOCKERMGR_ENABLE_INSTALL_SCRIPT}"
ENV_INIT_SCRIPT_ONLY="\${ENV_INIT_SCRIPT_ONLY:-$INIT_SCRIPT_ONLY}"
ENV_HOST_CRON_ENABLED="\${ENV_HOST_CRON_ENABLED:-$HOST_CRON_ENABLED}"
ENV_HOST_CRON_COMMAND="\${ENV_HOST_CRON_COMMAND:-$HOST_CRON_COMMAND}"
ENV_HOST_CRON_USER="\${ENV_HOST_CRON_USER:-$HOST_CRON_USER}"
ENV_HOST_CRON_MIN="\${ENV_HOST_CRON_MIN:-$HOST_CRON_MIN}"
ENV_HOST_CRON_HOUR="\${ENV_HOST_CRON_HOUR:-$HOST_CRON_HOUR}"
ENV_HOST_CRON_WEEK_DAY="\${ENV_HOST_CRON_WEEK_DAY:-$HOST_CRON_WEEK_DAY}"
ENV_HOST_CRON_MONTH_DAY="\${ENV_HOST_CRON_MONTH_DAY:-$HOST_CRON_MONTH_DAY}"
ENV_HOST_CRON_MONTH_NAME="\${ENV_HOST_CRON_MONTH_NAME:-$HOST_CRON_MONTH_NAME}"
ENV_HOST_CRON_LOG_FILE="\${ENV_HOST_CRON_LOG_FILE:-$HOST_CRON_LOG_FILE}"
ENV_HOST_CRON_AT_SCHEDULE="\${ENV_HOST_CRON_AT_SCHEDULE:-$HOST_CRON_AT_SCHEDULE}"
ENV_HOST_CRON_SCHEDULE="\${ENV_HOST_CRON_SCHEDULE:-$HOST_CRON_SCHEDULE}"
ENV_CONTAINER_PUBLISHED_PORT="\${ENV_CONTAINER_PUBLISHED_PORT:-$CONTAINER_PUBLISHED_PORT}"
ENV_HOST_NGINX_PROXY_URL="\${ENV_HOST_NGINX_PROXY_URL:-$HOST_NGINX_PROXY_URL}"
ENV_CONTAINER_NGINX_PROXY_URL="\${ENV_CONTAINER_NGINX_PROXY_URL:-$NGINX_PROXY_URL}"
EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__dockermgr_password_variables() {
  [ -d "$DOCKERMGR_CONFIG_DIR/secure" ] || mkdir -p "$DOCKERMGR_CONFIG_DIR/secure"
  cat <<EOF | tee -p | tr '|' '\n' | __remove_extra_spaces
# Password Enviroment variables for $CONTAINER_NAME
ENV_CONTAINER_DATABASE_PASS_ROOT="\${ENV_CONTAINER_DATABASE_PASS_ROOT:-$CONTAINER_DATABASE_PASS_ROOT}"
ENV_CONTAINER_DATABASE_PASS_NORMAL="\${ENV_CONTAINER_DATABASE_PASS_NORMAL:-$CONTAINER_DATABASE_PASS_NORMAL}"
ENV_CONTAINER_USER_PASS="\${ENV_CONTAINER_USER_PASS:-$CONTAINER_USER_PASS}"
ENV_CONTAINER_API_KEY_TOKEN="\${ENV_CONTAINER_API_KEY_TOKEN:-$CONTAINER_API_KEY_TOKEN}"
ENV_CONTAINER_SECRET_KEY_TOKEN="\${ENV_CONTAINER_SECRET_KEY_TOKEN:-$CONTAINER_SECRET_KEY_TOKEN}"
ENV_CONTAINER_USER_ADMIN_HASH_PASS="\${ENV_CONTAINER_USER_ADMIN_HASH_PASS:-$CONTAINER_USER_ADMIN_HASH_PASS}"
ENV_CONTAINER_DEFAULT_PASSWORD="\${ENV_CONTAINER_DEFAULT_PASSWORD:-$CONTAINER_DEFAULT_PASSWORD}"

EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_uninstall() {
  NGINX_FILES="$(echo "$NGINX_CONF_FILE $NGINX_INC_CONFIG $NGINX_VHOST_CONFIG $NGINX_INTERNAL_IS_SET" | tr ' ' '\n' | grep -v '^$' | sort -u | tr '\n' ' ')"
  mkdir -p "$DOCKERMGR_CONFIG_DIR/uninstall"
  cat <<EOF >"$DOCKERMGR_CONFIG_DIR/uninstall/$APPNAME"
# Uninstaller for $CONTAINER_NAME
INSTDIR="$INSTDIR"
APPDIR="$APPDIR"
DATADIR="$DATADIR"
ROOTFS_DIR="$ROOTFS_DIR"
DOCKERMGR_CONFIG_DIR="$DOCKERMGR_CONFIG_DIR"
CONTAINER_NAME="$CONTAINER_NAME"
DOCKER_NAME="$CONTAINER_NAME"
DOCKER_REGISTRY_USER_NAME="$DOCKER_REGISTRY_USER_NAME"
DOCKER_REGISTRY_REPO_NAME="$DOCKER_REGISTRY_REPO_NAME"
DOCKER_REGISTRY_URL="$DOCKER_REGISTRY_URL"
ADD_REMOVE_FILES="$DOCKERMGR_CONFIG_DIR/*/$CONTAINER_NAME*"
NGINX_FILES="$(__trim "$NGINX_FILES")"
DATABASE_BASE_DIR="$LOCAL_DATA_DIR/$DATABASE_BASE_DIR"
CONTAINER_INFO="$DOCKERMGR_CONFIG_DIR/installed/$APPNAME"
EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define extra functions
__custom_docker_clean_env() { grep -Ev '^$|^#' | sed 's|^|--env |g' | grep '\--' | grep -v '\--env \\' | tr '\n' ' ' | __remove_extra_spaces; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__trim() {
  local var="$*"
  var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
  printf '%s' "$var" | grep -v '^$' | sort -u | __remove_extra_spaces
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_docker_script() {
  [ -n "$EXECUTE_DOCKER_CMD" ] || return
  local replace_with exec_docker_cmd create_docker_script_message_pre create_docker_script_message_post
  replace_with="$DOCKER_HUB_IMAGE_URL:$DOCKER_HUB_IMAGE_TAG $CONTAINER_COMMANDS"
  exec_docker_cmd="$(echo "$EXECUTE_DOCKER_CMD" | grep -v '^$' | sed 's/ --/\n  --/g;s| -d| -d \\|g' | grep -v '^$' | sed '/  --/ s/$/ \\/' | grep '^')"
  create_docker_script_message_pre="${create_docker_script_message_pre:-Failed to execute $EXECUTE_PRE_INSTALL}"
  create_docker_script_message_post="${create_docker_script_message_post:-Failed to create $CONTAINER_NAME}"
  cat <<EOF | tee -p "$DOCKERMGR_INSTALL_SCRIPT" >/dev/null
#!/usr/bin/env bash
# Install script for $CONTAINER_NAME
statusCode=0
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$EXECUTE_PRE_INSTALL
statusCode=\$?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ \$statusCode -ne 0 ]; then
  echo "$create_docker_script_message_pre" >&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$exec_docker_cmd
  $DOCKER_HUB_IMAGE_URL:$DOCKER_HUB_IMAGE_TAG $CONTAINER_COMMANDS
statusCode=\$?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ \$statusCode -ne 0 ]; then
  echo "$create_docker_script_message_post" >&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if ! docker ps -a 2>&1 | grep -qi "$CONTAINER_NAME"; then
echo "$CONTAINER_NAME is not running" >&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit 0
# end script

EOF
  [ -f "$DOCKERMGR_INSTALL_SCRIPT" ] || return 1
  sed -i 's| '$DOCKER_HUB_IMAGE_URL':'$DOCKER_HUB_IMAGE_TAG' .*\\| \\|g' "$DOCKERMGR_INSTALL_SCRIPT"
  chmod -Rf 755 "$DOCKERMGR_INSTALL_SCRIPT"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$DOCKER_HUB_IMAGE_URL" ] || [ "$DOCKER_HUB_IMAGE_URL" = " " ]; then
  printf_exit "Please set the url to the containers image"
elif echo "$DOCKER_HUB_IMAGE_URL" | grep -q ':'; then
  DOCKER_HUB_IMAGE_URL="$(echo "$DOCKER_HUB_IMAGE_URL" | awk -F':' '{print $1}')"
  DOCKER_HUB_IMAGE_TAG="${DOCKER_HUB_IMAGE_TAG:-$(echo "$DOCKER_HUB_IMAGE_URL" | awk -F':' '{print $2}')}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure that the image has a tag
[ -n "$DOCKER_HUB_IMAGE_TAG" ] || DOCKER_HUB_IMAGE_TAG="latest"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cleanup registry variables
DOCKER_HUB_IMAGE_TAG="${DOCKER_HUB_IMAGE_TAG//*:/}"
DOCKER_HUB_IMAGE_URL="${DOCKER_HUB_IMAGE_URL//*:\/\//}"
DOCKER_HUB_IMAGE_URL="${DOCKER_HUB_IMAGE_URL//:*/}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set containers name
CONTAINER_NAME="${CONTAINER_NAME:-$SET_CONTAINER_NAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define folders
export APPDIR="$SET_APPDIR"
export DATADIR="$SET_DATADIR"
export INSTDIR="$SET_INSTDIR"
export HOST_ROOTFS_DIR="$SET_DATADIR/rootfs"
export HOST_DATA_DIR="$HOST_ROOTFS_DIR/data"
export HOST_CONFIG_DIR="$HOST_ROOTFS_DIR/config"
export LOCAL_DATA_DIR="${LOCAL_DATA_DIR:-$HOST_DATA_DIR}"
export LOCAL_CONFIG_DIR="${LOCAL_CONFIG_DIR:-$HOST_CONFIG_DIR}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import variables from a file
[ -f "$INSTDIR/env.sh" ] && . "$INSTDIR/env.sh"
[ -f "$APPDIR/env.sh" ] && . "$APPDIR/env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/.env.sh" ] && . "$DOCKERMGR_CONFIG_DIR/.env.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env.conf" ] && . "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env.conf"
[ -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.script.sh" ] && . "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.script.sh"
[ -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.custom.conf" ] && . "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.custom.conf"
[ -r "$DOCKERMGR_CONFIG_DIR/secure/$CONTAINER_NAME" ] && . "$DOCKERMGR_CONFIG_DIR/secure/$CONTAINER_NAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Update the variables for the installer
dockermgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Initialize the installer
dockermgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run pre-install commands
execute "__run_pre_install" "Running pre-installation commands"
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
# verify required file exists
if [ -n "$CONTAINER_REQUIRES" ]; then
  CONTAINER_REQUIRES="${CONTAINER_REQUIRES//,/}"
  for required in $CONTAINER_REQUIRES; do
    if [ -n "$(type "$required" 2>/dev/null)" ] || [ -n "$(type -P "$required" 2>/dev/null)" ] || [ -e "$required" ]; then
      required=""
    else
      __printf_color "6" "Installing required: $required" && pkmgr silent install $required &>/dev/null && required="" || required_missing="$required $required_missing"
    fi
  done
  [ "$required_missing" != " " ] || unset required_missing
  if [ -n "$required_missing" ]; then
    echo "Missing required: $required_missing"
    exit 1
  fi
fi
if [ "$CONTAINER_PROTOCOL" = "http" ]; then
  CONTAINER_WEB_SERVER_PROTOCOL="http"
elif [ "$CONTAINER_PROTOCOL" = "https" ]; then
  CONTAINER_WEB_SERVER_PROTOCOL="https"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$CONTAINER_WEB_SERVER_LISTEN_ON" = "docker" ]; then
  CONTAINER_WEB_SERVER_LISTEN_ON="$(__get_device_ip_4 || echo '172.17.0.1')"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup containers hostname
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -n "$ENV_HOSTNAME" ] && CONTAINER_HOSTNAME="$ENV_HOSTNAME"
[ -n "$ENV_DOMAINNAME" ] && CONTAINER_DOMAINNAME="$ENV_DOMAINNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$CONTAINER_HOSTNAME" = "hostname" ] || [ "$CONTAINER_DOMAINNAME" = "hostname" ]; then
  CONTAINER_HOSTNAME="$(hostname -s)"
  CONTAINER_DOMAINNAME="${HOSTNAME//$CONTAINER_HOSTNAME./}"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$CONTAINER_HOSTNAME" ]; then
  if [ "$(hostname -s)" = "testing" ]; then
    CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-$APPNAME}"
    CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-$HOSTNAME}"
  else
    CONTAINER_HOSTNAME="$APPNAME"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$CONTAINER_DOMAINNAME" ]; then
  IS_SAME_SERVER="$(__ping_host '1.1.1.1' && [ "$(__get_records)" = "$(__public_ip)" ] && echo "yes" || false)"
  if [ "$IS_SAME_SERVER" = "yes" ]; then
    CONTAINER_DOMAINNAME="$SET_HOST_FULL_DOMAIN"
  else
    CONTAINER_DOMAINNAME="$HOSTNAME"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Clean and create full hostname
if [ -n "$CONTAINER_FULL_HOST" ]; then
  CONTAINER_HOSTNAME="$CONTAINER_FULL_HOST"
  CONTAINER_DOMAINNAME=$(echo "$CONTAINER_FULL_HOST" | sed 's/^[^.:]*[.:]//')
else
  CONTAINER_HOSTNAME="$(echo "$CONTAINER_HOSTNAME" | sed 's/[.].*$//')"
  CONTAINER_HOSTNAME="$CONTAINER_HOSTNAME.$CONTAINER_DOMAINNAME"
fi
echo "$CONTAINER_HOSTNAME" | grep -qF '.' || CONTAINER_HOSTNAME="$CONTAINER_HOSTNAME.$CONTAINER_DOMAINNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup container mounts
CONTAINER_SSL_DIR="${CONTAINER_SSL_DIR:-/config/ssl}"
CONTAINER_SSL_CA="${CONTAINER_SSL_CA:-$CONTAINER_SSL_DIR/ca.crt}"
CONTAINER_SSL_CRT="${CONTAINER_SSL_CRT:-$CONTAINER_SSL_DIR/localhost.crt}"
CONTAINER_SSL_KEY="${CONTAINER_SSL_KEY:-$CONTAINER_SSL_DIR/localhost.key}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup ssl certs
if [ "$CONTAINER_WEB_SERVER_SSL_ENABLED" = "true" ]; then
  if [ -z "$HOST_SSL_CA" ]; then
    if [ -f "/etc/ssl/cert.pem" ]; then
      HOST_SSL_CA="/etc/ssl/cert.pem"
    elif [ -f "/etc/ssl/certs/ca-bundle.crt" ]; then
      HOST_SSL_CA="/etc/ssl/certs/ca-bundle.crt"
    elif [ -f "/etc/ssl/CA/CasjaysDev/certs/ca.crt" ]; then
      HOST_SSL_CA="/etc/ssl/CA/CasjaysDev/certs/ca.crt"
    fi
  fi
  if [ -z "$HOST_SSL_CRT" ]; then
    if [ -f "/etc/letsencrypt/live/domain/fullchain.pem" ]; then
      HOST_SSL_CRT="/etc/letsencrypt/live/domain/fullchain.pem"
    elif [ -f "/etc/ssl/CA/CasjaysDev/certs/localhost.crt" ]; then
      HOST_SSL_CRT="/etc/ssl/CA/CasjaysDev/certs/localhost.crt"
    fi
  fi
  if [ -z "$HOST_SSL_KEY" ]; then
    if [ -f "/etc/letsencrypt/live/domain/privkey.pem" ]; then
      HOST_SSL_KEY="/etc/letsencrypt/live/domain/privkey.pem"
    elif [ -f "/etc/ssl/CA/CasjaysDev/private/localhost.key" ]; then
      HOST_SSL_KEY="/etc/ssl/CA/CasjaysDev/private/localhost.key"
    fi
  fi
  if [ -n "$HOST_SSL_CA" ]; then
    HOST_SSL_CA="$(realpath "$HOST_SSL_CA")"
  fi
  if [ -n "$HOST_SSL_CRT" ]; then
    HOST_SSL_CRT="$(realpath "$HOST_SSL_CRT")"
  fi
  if [ -n "$HOST_SSL_KEY" ]; then
    HOST_SSL_KEY="$(realpath "$HOST_SSL_KEY")"
  fi
  SSL_ENABLED="yes"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite variables from env file
CONTAINER_NAME="${ENV_CONTAINER_NAME:-${CONTAINER_NAME:-$APPNAME}}"
DOCKER_HUB_IMAGE_TAG="${ENV_DOCKER_HUB_IMAGE_TAG:-$DOCKER_HUB_IMAGE_TAG}"
DOCKER_REGISTRY_URL="${ENV_DOCKER_REGISTRY_URL:-$DOCKER_REGISTRY_URL}"
DOCKER_REGISTRY_REPO_NAME="${ENV_DOCKER_REGISTRY_REPO_NAME:-$DOCKER_REGISTRY_REPO_NAME}"
DOCKER_REGISTRY_USER_NAME="${ENV_DOCKER_REGISTRY_USER_NAME:-$DOCKER_REGISTRY_USER_NAME}"
DOCKER_REGISTRY_IMAGE_TAG="${ENV_DOCKER_REGISTRY_IMAGE_TAG:-$DOCKER_REGISTRY_IMAGE_TAG}"
DOCKER_HUB_IMAGE_URL="${ENV_DOCKER_HUB_IMAGE_URL:-$DOCKER_HUB_IMAGE_URL}"
SET_CONTAINER_NAME="${ENV_SET_CONTAINER_NAME:-$SET_CONTAINER_NAME}"
REPO="${ENV_REPO:-$REPO}"
APPVERSION="${ENV_APPVERSION:-$APPVERSION}"
DOCKERMGR_CONFIG_DIR="${ENV_DOCKERMGR_CONFIG_DIR:-$DOCKERMGR_CONFIG_DIR}"
SET_INSTDIR="${ENV_SET_INSTDIR:-$SET_INSTDIR}"
SET_APPDIR="${ENV_SET_APPDIR:-$SET_APPDIR}"
SET_DATADIR="${ENV_SET_DATADIR:-$SET_DATADIR}"
SETOPTS="${ENV_SETOPTS:-$SETOPTS}"
SET_HOST_CORES="${ENV_SET_HOST_CORES:-$SET_HOST_CORES}"
SET_LAN_DEV="${ENV_SET_LAN_DEV:-$SET_LAN_DEV}"
SET_DOCKER_IP="${ENV_SET_DOCKER_IP:-$SET_DOCKER_IP}"
SET_LAN_IP="${ENV_SET_LAN_IP:-$SET_LAN_IP}"
ENV_HOSTNAME="${ENV_ENV_HOSTNAME:-$ENV_HOSTNAME}"
ENV_DOMAINNAME="${ENV_ENV_DOMAINNAME:-$ENV_DOMAINNAME}"
SET_DOMAIN_NAME="${ENV_SET_DOMAIN_NAME:-$SET_DOMAIN_NAME}"
SET_SHORT_HOSTNAME="${ENV_SET_SHORT_HOSTNAME:-$SET_SHORT_HOSTNAME}"
SET_LONG_HOSTNAME="${ENV_SET_LONG_HOSTNAME:-$SET_LONG_HOSTNAME}"
SET_HOST_FULL_NAME="${ENV_SET_HOST_FULL_NAME:-$SET_HOST_FULL_NAME}"
SET_HOST_FULL_DOMAIN="${ENV_SET_HOST_FULL_DOMAIN:-$SET_HOST_FULL_DOMAIN}"
HOST_SSL_CA="${ENV_HOST_SSL_CA:-$HOST_SSL_CA}"
HOST_SSL_CRT="${ENV_HOST_SSL_CRT:-$HOST_SSL_CRT}"
HOST_SSL_KEY="${ENV_HOST_SSL_KEY:-$HOST_SSL_KEY}"
CONTAINER_SSL_CA="${ENV_CONTAINER_SSL_CA:-$CONTAINER_SSL_CA}"
CONTAINER_SSL_CRT="${ENV_CONTAINER_SSL_CRT:-$CONTAINER_SSL_CRT}"
CONTAINER_SSL_KEY="${ENV_CONTAINER_SSL_KEY:-$CONTAINER_SSL_KEY}"
CONTAINER_REQUIRES="${ENV_CONTAINER_REQUIRES:-$CONTAINER_REQUIRES}"
CONTAINER_TIMEZONE="${ENV_CONTAINER_TIMEZONE:-$CONTAINER_TIMEZONE}"
CONTAINER_WORK_DIR="${ENV_CONTAINER_WORK_DIR:-$CONTAINER_WORK_DIR}"
USER_ID_ENABLED="${ENV_USER_ID_ENABLED:-$USER_ID_ENABLED}"
CONTAINER_USER_ID="${ENV_CONTAINER_USER_ID:-$CONTAINER_USER_ID}"
CONTAINER_GROUP_ID="${ENV_CONTAINER_GROUP_ID:-$CONTAINER_GROUP_ID}"
DOCKER_ADD_USER="${ENV_DOCKER_ADD_USER:-$DOCKER_ADD_USER}}"
DOCKER_ADD_GROUP="${ENV_DOCKER_ADD_GROUP:-$DOCKER_ADD_GROUP}}"
CONTAINER_USER_RUN="${ENV_CONTAINER_USER_RUN:-$CONTAINER_USER_RUN}"
CONTAINER_PRIVILEGED_ENABLED="${ENV_CONTAINER_PRIVILEGED_ENABLED:-$CONTAINER_PRIVILEGED_ENABLED}"
CONTAINER_SHM_SIZE="${ENV_CONTAINER_SHM_SIZE:-$CONTAINER_SHM_SIZE}"
CONTAINER_RAM_SIZE="${ENV_CONTAINER_RAM_SIZE:-$CONTAINER_RAM_SIZE}"
CONTAINER_SWAP_SIZE="${ENV_CONTAINER_SWAP_SIZE:-$CONTAINER_SWAP_SIZE}"
CONTAINER_CPU_COUNT="${ENV_CONTAINER_CPU_COUNT:-$CONTAINER_CPU_COUNT}"
CONTAINER_PROXY_SIGNAL="${ENV_CONTAINER_PROXY_SIGNAL:-$CONTAINER_PROXY_SIGNAL}"
CONTAINER_AUTO_RESTART="${ENV_CONTAINER_AUTO_RESTART:-$CONTAINER_AUTO_RESTART}"
CONTAINER_AUTO_DELETE="${ENV_CONTAINER_AUTO_DELETE:-$CONTAINER_AUTO_DELETE}"
CONTAINER_TTY_ENABLED="${ENV_CONTAINER_TTY_ENABLED:-$CONTAINER_TTY_ENABLED}"
CONTAINER_INTERACTIVE_ENABLED="${ENV_CONTAINER_INTERACTIVE_ENABLED:-$CONTAINER_INTERACTIVE_ENABLED}"
CONTAINER_ENV_FILE_ENABLED="${ENV_CONTAINER_ENV_FILE_ENABLED:-$CONTAINER_ENV_FILE_ENABLED}"
CONTAINER_ENV_FILE_MOUNT="${ENV_CONTAINER_ENV_FILE_MOUNT:-$CONTAINER_ENV_FILE_MOUNT}"
CGROUPS_ENABLED="${ENV_CGROUPS_ENABLED:-$CGROUPS_ENABLED}"
CGROUPS_MOUNTS="${ENV_CGROUPS_MOUNTS:-$CGROUPS_MOUNTS}"
HOST_RESOLVE_ENABLED="${ENV_HOST_RESOLVE_ENABLED:-$HOST_RESOLVE_ENABLED}"
HOST_ETC_RESOLVE_INIT_FILE="${ENV_HOST_ETC_RESOLVE_INIT_FILE:-$HOST_ETC_RESOLVE_INIT_FILE}"
HOST_ETC_HOSTS_ENABLED="${ENV_HOST_ETC_HOSTS_ENABLED:-$HOST_ETC_HOSTS_ENABLED}"
HOST_ETC_HOSTS_INIT_FILE="${ENV_HOST_ETC_HOSTS_INIT_FILE:-$HOST_ETC_HOSTS_INIT_FILE}"
DOCKER_SOCKET_ENABLED="${ENV_DOCKER_SOCKET_ENABLED:-$DOCKER_SOCKET_ENABLED}"
DOCKER_SOCKER_READONLY="${ENV_DOCKER_SOCKER_READONLY:-$DOCKER_SOCKER_READONLY}"
HOST_DOCKER_SOCKET_MOUNT="${ENV_HOST_DOCKER_SOCKET_MOUNT:-$HOST_DOCKER_SOCKET_MOUNT}"
CONTAINER_DOCKER_SOCKET_MOUNT="${ENV_CONTAINER_DOCKER_SOCKET_MOUNT:-$CONTAINER_DOCKER_SOCKET_MOUNT}"
DOCKER_ENV_FILE_ENABLED="${ENV_DOCKER_ENV_FILE_ENABLED:-$DOCKER_ENV_FILE_ENABLED}"
DOCKER_CONFIG_ENABLED="${ENV_DOCKER_CONFIG_ENABLED:-$DOCKER_CONFIG_ENABLED}"
HOST_DOCKER_CONFIG_FILE="${ENV_HOST_DOCKER_CONFIG:-$HOST_DOCKER_CONFIG_FILE}"
CONTAINER_DOCKER_CONFIG_FILE="${ENV_CONTAINER_DOCKER_CONFIG_FILE:-$CONTAINER_DOCKER_CONFIG_FILE}"
DOCKER_SOUND_ENABLED="${ENV_DOCKER_SOUND_ENABLED:-$DOCKER_SOUND_ENABLED}"
HOST_SOUND_DEVICE="${ENV_HOST_SOUND_DEVICE:-$HOST_SOUND_DEVICE}"
CONTAINER_SOUND_DEVICE_FILE="${ENV_CONTAINER_SOUND_DEVICE_FILE:-$CONTAINER_SOUND_DEVICE_FILE}"
CONTAINER_X11_ENABLED="${ENV_CONTAINER_X11_ENABLED:-$CONTAINER_X11_ENABLED}"
HOST_X11_DISPLAY="${ENV_HOST_X11_DISPLAY:-$HOST_X11_DISPLAY}"
HOST_X11_SOCKET="${ENV_HOST_X11_SOCKET:-$HOST_X11_SOCKET}"
HOST_X11_XAUTH="${ENV_HOST_X11_XAUTH:-$HOST_X11_XAUTH}"
CONTAINER_X11_SOCKET="${ENV_CONTAINER_X11_SOCKET:-$CONTAINER_X11_SOCKET}"
CONTAINER_X11_XAUTH="${ENV_CONTAINER_X11_XAUTH:-$CONTAINER_X11_XAUTH}"
HOST_DEV_MOUNT_ENABLED="${ENV_HOST_DEV_MOUNT_ENABLED:-$HOST_DEV_MOUNT_ENABLED}"
HOST_SYS_MOUNT_ENABLED="${ENV_HOST_SYS_MOUNT_ENABLED:-$HOST_SYS_MOUNT_ENABLED}"
HOST_PROC_MOUNT_ENABLED="${ENV_HOST_PROC_MOUNT_ENABLED:-$HOST_PROC_MOUNT_ENABLED}"
HOST_MODULES_MOUNT_ENABLED="${ENV_HOST_MODULES_MOUNT_ENABLED:-$HOST_MODULES_MOUNT_ENABLED}"
CONTAINER_HOSTNAME="${ENV_CONTAINER_HOSTNAME:-$CONTAINER_HOSTNAME}"
CONTAINER_DOMAINNAME="${ENV_CONTAINER_DOMAINNAME:-$CONTAINER_DOMAINNAME}"
HOST_DOCKER_NETWORK="${ENV_HOST_DOCKER_NETWORK:-$HOST_DOCKER_NETWORK}"
HOST_DOCKER_LINK="${ENV_HOST_DOCKER_LINK:-$HOST_DOCKER_LINK}"
HOST_NETWORK_ADDR="${ENV_HOST_NETWORK_ADDR:-$HOST_NETWORK_ADDR}"
HOST_DOCKER_SECOPT="${ENV_HOST_DOCKER_SECOPT:-$HOST_DOCKER_SECOPT}"
CONTAINER_PROTOCOL="${ENV_CONTAINER_PROTOCOL:-$CONTAINER_PROTOCOL}"
CONTAINER_DNS="${ENV_CONTAINER_DNS:-$CONTAINER_DNS}"
HOST_NGINX_ENABLED="${ENV_HOST_NGINX_ENABLED:-$HOST_NGINX_ENABLED}"
HOST_NGINX_SSL_ENABLED="${ENV_HOST_NGINX_SSL_ENABLED:-$HOST_NGINX_SSL_ENABLED}"
HOST_NGINX_HTTP_PORT="${ENV_HOST_NGINX_HTTP_PORT:-$HOST_NGINX_HTTP_PORT}"
HOST_NGINX_HTTPS_PORT="${ENV_HOST_NGINX_HTTPS_PORT:-$HOST_NGINX_HTTPS_PORT}"
HOST_NGINX_UPDATE_CONF="${ENV_HOST_NGINX_UPDATE_CONF:-$HOST_NGINX_UPDATE_CONF}"
HOST_NGINX_EXTERNAL_DOMAIN="${ENV_HOST_NGINX_EXTERNAL_DOMAIN:-$HOST_NGINX_EXTERNAL_DOMAIN}"
HOST_NGINX_INTERNAL_DOMAIN="${ENV_HOST_NGINX_INTERNAL_DOMAIN:-$HOST_NGINX_INTERNAL_DOMAIN}"
HOST_NGINX_INTERNAL_HOST="${ENV_HOST_NGINX_INTERNAL_HOST:-$HOST_NGINX_INTERNAL_HOST}"
HOST_NGINX_LISTEN_ON_IP_ADDRESS="${ENV_HOST_NGINX_LISTEN_ON_IP_ADDRESS:-$HOST_NGINX_LISTEN_ON_IP_ADDRESS}"
HOST_NGINX_VHOST_CONFIG_NAME="${ENV_HOST_NGINX_VHOST_CONFIG_NAME:-$HOST_NGINX_VHOST_CONFIG_NAME}"
CONTAINER_WEB_SERVER_ENABLED="${ENV_CONTAINER_WEB_SERVER_ENABLED:-$CONTAINER_WEB_SERVER_ENABLED}"
CONTAINER_WEB_SERVER_INT_PORT="${ENV_CONTAINER_WEB_SERVER_INT_PORT:-$CONTAINER_WEB_SERVER_INT_PORT}"
CONTAINER_WEB_SERVER_SSL_ENABLED="${ENV_CONTAINER_WEB_SERVER_SSL_ENABLED:-$CONTAINER_WEB_SERVER_SSL_ENABLED}"
CONTAINER_WEB_SERVER_AUTH_ENABLED="${ENV_CONTAINER_WEB_SERVER_AUTH_ENABLED:-$CONTAINER_WEB_SERVER_AUTH_ENABLED}"
CONTAINER_WEB_SERVER_LISTEN_ON="${ENV_CONTAINER_WEB_SERVER_LISTEN_ON:-$CONTAINER_WEB_SERVER_LISTEN_ON}"
CONTAINER_WEB_SERVER_INT_PATH="${ENV_CONTAINER_WEB_SERVER_INT_PATH:-$CONTAINER_WEB_SERVER_INT_PATH}"
CONTAINER_WEB_SERVER_EXT_PATH="${ENV_CONTAINER_WEB_SERVER_EXT_PATH:-$CONTAINER_WEB_SERVER_EXT_PATH}"
CONTAINER_WEB_SERVER_WWW_ENV="${ENV_CONTAINER_WEB_SERVER_WWW_ENV:-$CONTAINER_WEB_SERVER_WWW_ENV}"
CONTAINER_WEB_SERVER_WWW_DIR="${ENV_CONTAINER_WEB_SERVER_WWW_DIR:-$CONTAINER_WEB_SERVER_WWW_DIR}"
CONTAINER_WEB_SERVER_WWW_REPO="${ENV_CONTAINER_WEB_SERVER_WWW_REPO:-$CONTAINER_WEB_SERVER_WWW_REPO}"
CONTAINER_WEB_SERVER_VHOSTS="${ENV_CONTAINER_WEB_SERVER_VHOSTS:-$CONTAINER_WEB_SERVER_VHOSTS}"
CONTAINER_ADD_RANDOM_PORTS="${ENV_CONTAINER_ADD_RANDOM_PORTS:-$CONTAINER_ADD_RANDOM_PORTS}"
CONTAINER_ADD_CUSTOM_PORT="${ENV_CONTAINER_ADD_CUSTOM_PORT:-$CONTAINER_ADD_CUSTOM_PORT}"
CONTAINER_ADD_CUSTOM_SINGLE="${ENV_CONTAINER_ADD_CUSTOM_SINGLE:-$CONTAINER_ADD_CUSTOM_SINGLE}"
CONTAINER_EMAIL_ENABLED="${ENV_CONTAINER_EMAIL_ENABLED:-$CONTAINER_EMAIL_ENABLED}"
CONTAINER_EMAIL_USER="${ENV_CONTAINER_EMAIL_USER:-$CONTAINER_EMAIL_USER}"
CONTAINER_EMAIL_DOMAIN="${ENV_CONTAINER_EMAIL_DOMAIN:-$CONTAINER_EMAIL_DOMAIN}"
CONTAINER_EMAIL_RELAY_SERVER="${ENV_CONTAINER_EMAIL_RELAY_SERVER:-$CONTAINER_EMAIL_RELAY_SERVER}"
CONTAINER_EMAIL_RELAY_PORT="${ENV_CONTAINER_EMAIL_RELAY_PORT:-$CONTAINER_EMAIL_RELAY_PORT}"
CONTAINER_SERVICE_PUBLIC="${ENV_CONTAINER_SERVICE_PUBLIC:-$CONTAINER_SERVICE_PUBLIC}"
CONTAINER_IS_DNS_SERVER="${ENV_CONTAINER_IS_DNS_SERVER:-$CONTAINER_IS_DNS_SERVER}"
CONTAINER_IS_DHCP_SERVER="${ENV_CONTAINER_IS_DHCP_SERVER:-$CONTAINER_IS_DHCP_SERVER}"
CONTAINER_IS_TFTP_SERVER="${ENV_CONTAINER_IS_TFTP_SERVER:-$CONTAINER_IS_TFTP_SERVER}"
CONTAINER_IS_SMTP_SERVER="${ENV_CONTAINER_IS_SMTP_SERVER:-$CONTAINER_IS_SMTP_SERVER}"
CONTAINER_IS_POP3_SERVER="${ENV_CONTAINER_IS_POP3_SERVER:-$CONTAINER_IS_POP3_SERVER}"
CONTAINER_IS_IMAP_SERVER="${ENV_CONTAINER_IS_IMAP_SERVER:-$CONTAINER_IS_IMAP_SERVER}"
CONTAINER_IS_TIME_SERVER="${ENV_CONTAINER_IS_TIME_SERVER:-$CONTAINER_IS_TIME_SERVER}"
CONTAINER_IS_NEWS_SERVER="${ENV_CONTAINER_IS_NEWS_SERVER:-$CONTAINER_IS_NEWS_SERVER}"
CONTAINER_DATABASE_CREATE="${ENV_CONTAINER_DATABASE_CREATE:-$CONTAINER_DATABASE_CREATE}"
CONTAINER_DATABASE_LISTEN="${ENV_CONTAINER_DATABASE_LISTEN:-$CONTAINER_DATABASE_LISTEN}"
CONTAINER_REDIS_ENABLED="${ENV_CONTAINER_REDIS_ENABLED:-$CONTAINER_REDIS_ENABLED}"
CONTAINER_SQLITE_ENABLED="${ENV_CONTAINER_SQLITE_ENABLED:-$CONTAINER_SQLITE_ENABLED}"
CONTAINER_MARIADB_ENABLED="${ENV_CONTAINER_MARIADB_ENABLED:-$CONTAINER_MARIADB_ENABLED}"
CONTAINER_MONGODB_ENABLED="${ENV_CONTAINER_MONGODB_ENABLED:-$CONTAINER_MONGODB_ENABLED}"
CONTAINER_COUCHDB_ENABLED="${ENV_CONTAINER_COUCHDB_ENABLED:-$CONTAINER_COUCHDB_ENABLED}"
CONTAINER_POSTGRES_ENABLED="${ENV_CONTAINER_POSTGRES_ENABLED:-$CONTAINER_POSTGRES_ENABLED}"
CONTAINER_SUPABASE_ENABLED="${ENV_CONTAINER_SUPABASE_ENABLED:-$CONTAINER_SUPABASE_ENABLED}"
CONTAINER_DEFAULT_DATABASE_TYPE="${ENV_CONTAINER_DEFAULT_DATABASE_TYPE:-$CONTAINER_DEFAULT_DATABASE_TYPE}"
CONTAINER_CREATE_DATABASE_NAME="${ENV_CONTAINER_CREATE_DATABASE_NAME:-$CONTAINER_CREATE_DATABASE_NAME}"
CONTAINER_CUSTOM_DATABASE_ENABLED="${ENV_CONTAINER_CUSTOM_DATABASE_ENABLED:-$CONTAINER_CUSTOM_DATABASE_ENABLED}"
CONTAINER_CUSTOM_DATABASE_NAME="${ENV_CONTAINER_CUSTOM_DATABASE_NAME:-$CONTAINER_CUSTOM_DATABASE_NAME}"
CONTAINER_CUSTOM_DATABASE_PORT="${ENV_CONTAINER_CUSTOM_DATABASE_PORT:-$CONTAINER_CUSTOM_DATABASE_PORT}"
CONTAINER_CUSTOM_DATABASE_DIR="${ENV_CONTAINER_CUSTOM_DATABASE_DIR:-$CONTAINER_CUSTOM_DATABASE_DIR}"
CONTAINER_CUSTOM_DATABASE_PROTOCOL="${ENV_CONTAINER_CUSTOM_DATABASE_PROTOCOL:-$CONTAINER_CUSTOM_DATABASE_PROTOCOL}"
CONTAINER_CUSTOM_DATABASE_ADMIN_WWW_ROOT="${ENV_CONTAINER_CUSTOM_DATABASE_ADMIN_WWW_ROOT:-$CONTAINER_CUSTOM_DATABASE_ADMIN_WWW_ROOT}"
CONTAINER_DATABASE_USER_ROOT="${ENV_CONTAINER_DATABASE_USER_ROOT:-$CONTAINER_DATABASE_USER_ROOT}"
CONTAINER_DATABASE_LENGTH_ROOT="${ENV_CONTAINER_DATABASE_LENGTH_ROOT:-$CONTAINER_DATABASE_LENGTH_ROOT}"
CONTAINER_DATABASE_USER_NORMAL="${ENV_CONTAINER_DATABASE_USER_NORMAL:-$CONTAINER_DATABASE_USER_NORMAL}"
CONTAINER_DATABASE_LENGTH_NORMAL="${ENV_CONTAINER_DATABASE_LENGTH_NORMAL:-$CONTAINER_DATABASE_LENGTH_NORMAL}"
CONTAINER_DATABASE_DIR="${ENV_CONTAINER_DATABASE_DIR:-$CONTAINER_DATABASE_DIR}"
HOST_MOUNT_DATABASE_DIR="${ENV_HOST_MOUNT_DATABASE_DIR:-$HOST_MOUNT_DATABASE_DIR}"
CONTAINER_USER_NAME="${ENV_CONTAINER_USER_NAME:-$CONTAINER_USER_NAME}"
CONTAINER_PASS_LENGTH="${ENV_CONTAINER_PASS_LENGTH:-$CONTAINER_PASS_LENGTH}"
CONTAINER_ENV_USER_NAME="${ENV_CONTAINER_ENV_USER_NAME:-$CONTAINER_ENV_USER_NAME}"
CONTAINER_ENV_PASS_NAME="${ENV_CONTAINER_ENV_PASS_NAME:-$CONTAINER_ENV_PASS_NAME}"
CONTAINER_API_KEY_NAME="${ENV_CONTAINER_API_KEY_NAME:-$CONTAINER_API_KEY_NAME}"
CONTAINER_SECRET_KEY_NAME="${ENV_CONTAINER_SECRET_KEY_NAME:-$CONTAINER_SECRET_KEY_NAME}"
CONTAINER_USER_ADMIN_HASH_ENV="${ENV_CONTAINER_USER_ADMIN_HASH_ENV:-$CONTAINER_USER_ADMIN_HASH_ENV}"
CONTAINER_SERVICES_LIST="${ENV_CONTAINER_SERVICES_LIST:-$CONTAINER_SERVICES_LIST}"
CONTAINER_MOUNT_DATA_ENABLED="${ENV_CONTAINER_MOUNT_DATA_ENABLED:-$CONTAINER_MOUNT_DATA_ENABLED}"
CONTAINER_MOUNT_DATA_MOUNT_DIR="${ENV_CONTAINER_MOUNT_DATA_MOUNT_DIR:-$CONTAINER_MOUNT_DATA_MOUNT_DIR}"
CONTAINER_MOUNT_CONFIG_ENABLED="${ENV_CONTAINER_MOUNT_CONFIG_ENABLED:-$CONTAINER_MOUNT_CONFIG_ENABLED}"
CONTAINER_MOUNT_CONFIG_MOUNT_DIR="${ENV_CONTAINER_MOUNT_CONFIG_MOUNT_DIR:-$CONTAINER_MOUNT_CONFIG_MOUNT_DIR}"
CONTAINER_MOUNTS="${ENV_CONTAINER_MOUNTS:-$CONTAINER_MOUNTS}"
CONTAINER_DEVICES="${ENV_CONTAINER_DEVICES:-$CONTAINER_DEVICES}"
CONTAINER_ENV="${ENV_CONTAINER_ENV:-$CONTAINER_ENV}"
CONTAINER_SYSCTL="${ENV_CONTAINER_SYSCTL:-$CONTAINER_SYSCTL}"
DOCKER_MAX_LOG_FILE="${ENV_DOCKER_MAX_LOG_FILE:-$DOCKER_MAX_LOG_FILE}"
DOCKER_CUSTOM_CAP="${ENV_DOCKER_CUSTOM_CAP:-$DOCKER_CUSTOM_CAP}"
DOCKER_CAP_SYS_TIME="${ENV_DOCKER_CAP_SYS_TIME:-$DOCKER_CAP_SYS_TIME}"
DOCKER_CAP_SYS_ADMIN="${ENV_DOCKER_CAP_SYS_ADMIN:-$DOCKER_CAP_SYS_ADMIN}"
DOCKER_CAP_CHOWN="${ENV_DOCKER_CAP_CHOWN:-$DOCKER_CAP_CHOWN}"
DOCKER_CAP_NET_RAW="${ENV_DOCKER_CAP_NET_RAW:-$DOCKER_CAP_NET_RAW}"
DOCKER_CAP_SYS_NICE="${ENV_DOCKER_CAP_SYS_NICE:-$DOCKER_CAP_SYS_NICE}"
DOCKER_CAP_NET_ADMIN="${ENV_DOCKER_CAP_NET_ADMIN:-$DOCKER_CAP_NET_ADMIN}"
DOCKER_CAP_SYS_MODULE="${ENV_DOCKER_CAP_SYS_MODULE:-$DOCKER_CAP_SYS_MODULE}"
DOCKER_CAP_NET_BIND_SERVICE="${ENV_DOCKER_CAP_NET_BIND_SERVICE:-$DOCKER_CAP_NET_BIND_SERVICE}"
CONTAINER_LABELS="${ENV_CONTAINER_LABELS:-$CONTAINER_LABELS}"
CONTAINER_COMMANDS="${ENV_CONTAINER_COMMANDS:-$CONTAINER_COMMANDS}"
DOCKER_CUSTOM_ARGUMENTS="${ENV_DOCKER_CUSTOM_ARGUMENTS:-$DOCKER_CUSTOM_ARGUMENTS}"
CONTAINER_DEBUG_ENABLED="${ENV_CONTAINER_DEBUG_ENABLED:-$CONTAINER_DEBUG_ENABLED}"
CONTAINER_DEBUG_OPTIONS="${ENV_CONTAINER_DEBUG_OPTIONS:-$CONTAINER_DEBUG_OPTIONS}"
CONTAINER_CREATE_DIRECTORY="${ENV_CONTAINER_CREATE_DIRECTORY:-$CONTAINER_CREATE_DIRECTORY}"
HOST_SERVER_HEALTH_CHECK_ENABLED="${ENV_HOST_SERVER_HEALTH_CHECK_ENABLED:-$HOST_SERVER_HEALTH_CHECK_ENABLED}"
HOST_SERVER_HEALTH_CHECK_SERVER_URI="${ENV_HOST_SERVER_HEALTH_CHECK_SERVER_URI:-$HOST_SERVER_HEALTH_CHECK_SERVER_URI}"
HOST_SERVER_HEALTH_CHECK_SERVER_NAME="${ENV_HOST_SERVER_HEALTH_CHECK_SERVER_NAME:-$HOST_SERVER_HEALTH_CHECK_SERVER_NAME}"
CONTAINER_DEFAULT_USERNAME="${ENV_CONTAINER_DEFAULT_USERNAME:-$CONTAINER_DEFAULT_USERNAME}"
POST_SHOW_FINISHED_MESSAGE="${ENV_POST_SHOW_FINISHED_MESSAGE:-$POST_SHOW_FINISHED_MESSAGE}"
DOCKERMGR_ENABLE_INSTALL_SCRIPT="${ENV_DOCKERMGR_ENABLE_INSTALL_SCRIPT:-$DOCKERMGR_ENABLE_INSTALL_SCRIPT}"
INIT_SCRIPT_ONLY="${ENV_INIT_SCRIPT_ONLY:-$INIT_SCRIPT_ONLY}"
HOST_CRON_ENABLED="${ENV_HOST_CRON_ENABLED:-$HOST_CRON_ENABLED}"
HOST_CRON_COMMAND="${ENV_HOST_CRON_COMMAND:-$HOST_CRON_COMMAND}"
HOST_CRON_USER="${ENV_HOST_CRON_USER:-$HOST_CRON_USER}"
HOST_CRON_MIN="${ENV_HOST_CRON_MIN:-$HOST_CRON_MIN}"
HOST_CRON_HOUR="${ENV_HOST_CRON_HOUR:-$HOST_CRON_HOUR}"
HOST_CRON_WEEK_DAY="${ENV_HOST_CRON_WEEK_DAY:-$HOST_CRON_WEEK_DAY}"
HOST_CRON_MONTH_DAY="${ENV_HOST_CRON_MONTH_DAY:-$HOST_CRON_MONTH_DAY}"
HOST_CRON_MONTH_NAME="${ENV_HOST_CRON_MONTH_NAME:-$HOST_CRON_MONTH_NAME}"
HOST_CRON_LOG_FILE="${ENV_HOST_CRON_LOG_FILE:-$HOST_CRON_LOG_FILE}"
HOST_CRON_AT_SCHEDULE="${ENV_HOST_CRON_AT_SCHEDULE:-$HOST_CRON_AT_SCHEDULE}"
HOST_CRON_SCHEDULE="${ENV_HOST_CRON_SCHEDULE:-$HOST_CRON_SCHEDULE}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets reuse settings
CONTAINER_PUBLISHED_PORT="${ENV_CONTAINER_PUBLISHED_PORT:-$CONTAINER_PUBLISHED_PORT}"
HOST_NGINX_PROXY_URL="${ENV_HOST_NGINX_PROXY_URL:-$HOST_NGINX_PROXY_URL}"
CONTAINER_NGINX_PROXY_URL="${ENV_CONTAINER_NGINX_PROXY_URL:-$NGINX_PROXY_URL}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
CONTAINER_DATABASE_PASS_ROOT="${ENV_CONTAINER_DATABASE_PASS_ROOT:-$CONTAINER_DATABASE_PASS_ROOT}"
CONTAINER_DATABASE_PASS_NORMAL="${ENV_CONTAINER_DATABASE_PASS_NORMAL:-$CONTAINER_DATABASE_PASS_NORMAL}"
CONTAINER_USER_PASS="${ENV_CONTAINER_USER_PASS:-$CONTAINER_USER_PASS}"
CONTAINER_API_KEY_TOKEN="${ENV_CONTAINER_API_KEY_TOKEN:-$CONTAINER_API_KEY_TOKEN}"
CONTAINER_SECRET_KEY_TOKEN="${ENV_CONTAINER_SECRET_KEY_TOKEN:-$CONTAINER_SECRET_KEY_TOKEN}"
CONTAINER_USER_ADMIN_HASH_PASS="${ENV_CONTAINER_USER_ADMIN_HASH_PASS:-$CONTAINER_USER_ADMIN_HASH_PASS}"
CONTAINER_DEFAULT_PASSWORD="${ENV_CONTAINER_DEFAULT_PASSWORD:-$CONTAINER_DEFAULT_PASSWORD}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup arrays/empty variables
PRETTY_PORT=""
SET_WEB_PORT_TMP=()
SET_CAPABILITIES=()
DOCKER_SET_OPTIONS_ENV=()
DOCKER_SET_OPTIONS_VOLUME=()
DOCKER_SET_OPTIONS_DEFAULT=()
CONTAINER_ENV_PORTS=()
DOCKER_SET_TMP_PUBLISH=()
NGINX_REPLACE_INCLUDE=""
CONTAINER_EMAIL_PORTS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_SET_OPTIONS_DEFAULT+=("--name=$CONTAINER_NAME")
DOCKER_SET_OPTIONS_ENV+=("--env CONTAINER_NAME=$CONTAINER_NAME")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup time zone
if [ -z "$CONTAINER_TIMEZONE" ]; then
  CONTAINER_TIMEZONE="America/New_York"
fi
DOCKER_SET_OPTIONS_ENV+=("--env TZ=$CONTAINER_TIMEZONE")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set working dir
if [ -n "$CONTAINER_WORK_DIR" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--workdir $CONTAINER_WORK_DIR")
  DOCKER_SET_OPTIONS_ENV+=("--env ENV_WORK_DIR=$CONTAINER_WORK_DIR")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the html directory
if [ -n "$CONTAINER_WEB_SERVER_WWW_DIR" ]; then
  if [ -z "$CONTAINER_WEB_SERVER_WWW_ENV" ]; then
    CONTAINER_WEB_SERVER_WWW_ENV="ENV_WWW_ROOT_DIR"
  fi
  DOCKER_SET_OPTIONS_ENV+=("--env $CONTAINER_WEB_SERVER_WWW_ENV=$CONTAINER_WEB_SERVER_WWW_DIR")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set user ID
if [ "$USER_ID_ENABLED" = "yes" ]; then
  if [ -z "$CONTAINER_USER_ID" ]; then
    CONTAINER_USER_ID="$(__get_user_id "$USER")"
  fi
  if [ -z "$CONTAINER_GROUP_ID" ]; then
    CONTAINER_GROUP_ID="$(__get_group_id $USER)"
  fi
  DOCKER_SET_OPTIONS_ENV+=("--env PUID=$CONTAINER_USER_ID")
  DOCKER_SET_OPTIONS_ENV+=("--env PGID=$CONTAINER_GROUP_ID")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$DOCKER_ADD_USER" ]; then
  DOCKER_ADD_USER="$(__get_user_id "$DOCKER_ADD_USER")"
  DOCKER_SET_OPTIONS_DEFAULT+=("--user $DOCKER_ADD_USER")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$DOCKER_ADD_GROUP" ]; then
  DOCKER_ADD_GROUP="$(__get_group_id "$DOCKER_ADD_GROUP")"
  DOCKER_SET_OPTIONS_DEFAULT+=("--group-add $DOCKER_ADD_GROUP")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the process owner
if [ -n "$CONTAINER_USER_RUN" ]; then
  DOCKER_SET_OPTIONS_ENV+=("--env USER=$CONTAINER_USER_RUN")
  DOCKER_SET_OPTIONS_ENV+=("--env SERVICE_USER=$CONTAINER_USER_RUN")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run the container privileged
if [ "$CONTAINER_PRIVILEGED_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--privileged")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$DOCKER_MAX_LOG_FILE" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--log-opt max-size=$DOCKER_MAX_LOG_FILE")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set ram size
if [ -n "$CONTAINER_RAM_SIZE" ]; then
  CONTAINER_RAM_SIZE=$((1024 * 1024 * $CONTAINER_RAM_SIZE))
  DOCKER_SET_OPTIONS_DEFAULT+=("--memory $CONTAINER_RAM_SIZE")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set swap size
if [ -n "$CONTAINER_SWAP_SIZE" ]; then
  CONTAINER_SWAP_SIZE=$((1024 * 1024 * $CONTAINER_SWAP_SIZE))
  DOCKER_SET_OPTIONS_DEFAULT+=("--memory-swap $CONTAINER_SWAP_SIZE")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set CPU count
if [ -z "$CONTAINER_CPU_COUNT" ]; then
  CONTAINER_CPU_COUNT="${SET_HOST_CORES:-$([ -f "/proc/cpuinfo" ] && grep -c '^processor' /proc/cpuinfo || echo '1')}"
fi
if [ -n "$CONTAINER_CPU_COUNT" ] && [ "$SET_HOST_CORES" -le "$CONTAINER_CPU_COUNT" ]; then
  CONTAINER_CPU_COUNT="$SET_HOST_CORES"
fi
if [ -n "$CONTAINER_CPU_COUNT" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--cpus $CONTAINER_CPU_COUNT")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if [ "$CONTAINER_PROXY_SIGNAL" = "no" ] || [ "$CONTAINER_PROXY_SIGNAL" = "false" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--sig-proxy=false")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if [ -n "$HOST_DOCKER_SECOPT" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--security-opt seccomp=$HOST_DOCKER_SECOPT")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the containers SHM size
if [ -z "$CONTAINER_SHM_SIZE" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--shm-size=128M")
else
  DOCKER_SET_OPTIONS_DEFAULT+=("--shm-size=$CONTAINER_SHM_SIZE")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Auto restart the container
if [ -z "$CONTAINER_AUTO_RESTART" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--restart unless-stopped")
else
  DOCKER_SET_OPTIONS_DEFAULT+=("--restart=$CONTAINER_AUTO_RESTART")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Only run the container to execute command and then delete
if [ "$CONTAINER_AUTO_DELETE" = "yes" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--rm")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Enable the tty
if [ "$CONTAINER_TTY_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--tty")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run in interactive mode
if [ "$CONTAINER_INTERACTIVE_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--interactive")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount cgroups in the container
if [ -e "$CGROUPS_MOUNTS" ] || [ -e "/sys/fs/cgroup" ]; then
  if [ "$CGROUPS_ENABLED" = "yes" ]; then
    if [ -z "$CGROUPS_MOUNTS" ]; then
      DOCKER_SET_OPTIONS_VOLUME+=("--volume /sys/fs/cgroup:/sys/fs/cgroup:rw")
    else
      DOCKER_SET_OPTIONS_VOLUME+=("--volume $CGROUPS_MOUNTS")
    fi
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_DATABASE_DIR" ]; then
  if [ -z "$HOST_MOUNT_DATABASE_DIR" ]; then
    HOST_MOUNT_DATABASE_DIR="$HOST_DATA_DIR/db/custom/$CONTAINER_NAME"
  fi
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $HOST_MOUNT_DATABASE_DIR:$CONTAINER_DATABASE_DIR")
  [ -d "$HOST_MOUNT_DATABASE_DIR" ] || { mkdir -p "$HOST_MOUNT_DATABASE_DIR" && chmod 777 "$HOST_MOUNT_DATABASE_DIR"; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount the docker socket
if [ "$DOCKER_SOCKET_ENABLED" = "yes" ]; then
  if [ -z "$HOST_DOCKER_SOCKET_MOUNT" ]; then
    HOST_DOCKER_SOCKET_MOUNT="/var/run/docker.sock"
  fi
  if [ -z "$CONTAINER_DOCKER_SOCKET_MOUNT" ]; then
    CONTAINER_DOCKER_SOCKET_MOUNT="/var/run/docker.sock"
  fi
  if [ "$DOCKER_SOCKER_READONLY" = "yes" ]; then
    DOCKER_SOCKET_TMP_MOUNT="$HOST_DOCKER_SOCKET_MOUNT:$CONTAINER_DOCKER_SOCKET_MOUNT:ro"
  else
    DOCKER_SOCKET_TMP_MOUNT="$HOST_DOCKER_SOCKET_MOUNT:$CONTAINER_DOCKER_SOCKET_MOUNT"
  fi
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $DOCKER_SOCKET_TMP_MOUNT")
  unset DOCKER_SOCKET_TMP_MOUNT
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount docker config in the container
if [ -r "$CONTAINER_DOCKER_CONFIG_FILE" ] || [ -r "$HOME/.docker/config.json" ]; then
  if [ "$DOCKER_CONFIG_ENABLED" = "yes" ]; then
    if [ -z "$CONTAINER_DOCKER_CONFIG_FILE" ]; then
      CONTAINER_DOCKER_CONFIG_FILE="/root/.docker/config.json"
    fi
    if [ -n "$HOST_DOCKER_CONFIG_FILE" ]; then
      DOCKER_SET_OPTIONS_VOLUME+=("--volume $HOST_DOCKER_CONFIG_FILE:$CONTAINER_DOCKER_CONFIG_FILE:ro")
    elif [ -f "$HOME/.docker/config.json" ]; then
      DOCKER_SET_OPTIONS_VOLUME+=("--volume $HOME/.docker/config.json:$CONTAINER_DOCKER_CONFIG_FILE:ro")
    fi
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount sound card in container
if [ -e "$HOST_SOUND_DEVICE_FILE" ] || [ -e "/dev/snd" ]; then
  if [ "$DOCKER_SOUND_ENABLED" = "yes" ]; then
    if [ -z "$HOST_SOUND_DEVICE_FILE" ]; then
      HOST_SOUND_DEVICE_FILE="/dev/snd"
    fi
    if [ -z "$CONTAINER_SOUND_DEVICE_FILE" ]; then
      CONTAINER_SOUND_DEVICE_FILE="/dev/snd"
    fi
    if [ -n "$HOST_SOUND_DEVICE_FILE" ] && [ -n "$CONTAINER_SOUND_DEVICE_FILE" ]; then
      DOCKER_SET_OPTIONS_DEFAULT+=("--device $HOST_SOUND_DEVICE_FILE:$CONTAINER_SOUND_DEVICE_FILE")
    fi
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# /lib/modules /proc /sys /dev mounts
if [ "$HOST_DEV_MOUNT_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS_VOLUME+=("--volume /dev:/dev:z")
fi
if [ "$HOST_PROC_MOUNT_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS_VOLUME+=("--volume /proc:/proc:z")
fi
if [ "$HOST_SYS_MOUNT_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS_VOLUME+=("--volume /sys:/sys:z")
fi
if [ "$HOST_MODULES_MOUNT_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS_VOLUME+=("--volume /lib/modules:/lib/modules:z")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set password length
if [ -n "$CONTAINER_USER_ADMIN_HASH_PASS" ]; then
  if [ "$CONTAINER_USER_ADMIN_HASH_PASS" = "random" ]; then
    CONTAINER_USER_ADMIN_PASS_RAW="$(__create_password 32)"
    CONTAINER_USER_ADMIN_HASH_PASS="$(__hash_password $CONTAINER_USER_ADMIN_PASS_RAW)"
  fi
  CONTAINER_USER_ADMIN_PASS_RAW="${CONTAINER_USER_ADMIN_PASS_RAW:-$CONTAINER_USER_ADMIN_HASH_PASS}"
  CONTAINER_USER_ADMIN_HASH_PASS="${CONTAINER_USER_ADMIN_HASH_PASS:-$(__hash_password $CONTAINER_USER_ADMIN_PASS_RAW)}"
  if [ -n "$CONTAINER_USER_ADMIN_HASH_ENV" ]; then
    DOCKER_SET_OPTIONS_ENV+=("--env $CONTAINER_USER_ADMIN_HASH_ENV=${CONTAINER_USER_ADMIN_HASH_PASS}")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_API_KEY_NAME" ]; then
  if [ "$CONTAINER_API_KEY_TOKEN" = "random" ]; then
    CONTAINER_API_KEY_TOKEN="$(__create_api_key 48)"
  elif [ -z "$CONTAINER_API_KEY_TOKEN" ]; then
    CONTAINER_API_KEY_TOKEN="$(__create_api_key 48)"
  fi
  DOCKER_SET_OPTIONS_ENV+=("--env $CONTAINER_API_KEY_NAME=${CONTAINER_API_KEY_TOKEN}")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_SECRET_KEY_NAME" ]; then
  if [ "$CONTAINER_SECRET_KEY_TOKEN" = "random" ]; then
    CONTAINER_SECRET_KEY_TOKEN="$(__create_secret_key 64)"
  elif [ -z "$CONTAINER_SECRET_KEY_TOKEN" ]; then
    CONTAINER_SECRET_KEY_TOKEN="$(__create_secret_key 64)"
  fi
  DOCKER_SET_OPTIONS_ENV+=("--env $CONTAINER_SECRET_KEY_NAME=${CONTAINER_SECRET_KEY_TOKEN}")
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
  [ -f "/tmp/.X11-unix" ] || unset HOST_X11_SOCKET
  [ -f "$HOME/.Xauthority" ] || unset HOST_X11_XAUTH
  if [ -n "$HOST_X11_DISPLAY" ] && [ -n "$HOST_X11_SOCKET" ] && [ -n "$HOST_X11_XAUTH" ]; then
    DOCKER_SET_OPTIONS_ENV+=("--env DISPLAY=:$HOST_X11_DISPLAY")
    DOCKER_SET_OPTIONS_VOLUME+=("--volume $HOST_X11_SOCKET:${CONTAINER_X11_SOCKET:-/tmp/.X11-unix}")
    DOCKER_SET_OPTIONS_VOLUME+=("--volume $HOST_X11_XAUTH:${CONTAINER_X11_XAUTH:-/home/x11user/.Xauthority}")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_HOSTNAME" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--hostname $CONTAINER_HOSTNAME")
  DOCKER_SET_OPTIONS_ENV+=("--env HOSTNAME=$CONTAINER_HOSTNAME")
else
  DOCKER_SET_OPTIONS_DEFAULT+=("--hostname $CONTAINER_NAME")
  DOCKER_SET_OPTIONS_ENV+=("--env HOSTNAME=$CONTAINER_NAME")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the domain name
if [ -n "$CONTAINER_DOMAINNAME" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--domainname $CONTAINER_DOMAINNAME")
  DOCKER_SET_OPTIONS_ENV+=("--env DOMAINNAME=$CONTAINER_DOMAINNAME")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the docker network
if [ "$HOST_DOCKER_NETWORK" = "host" ]; then
  DOCKER_SET_OPTIONS_DEFAULT+=("--net-host")
else
  if [ -z "$HOST_DOCKER_NETWORK" ]; then
    HOST_DOCKER_NETWORK="bridge"
  fi
  DOCKER_SET_OPTIONS_DEFAULT+=("--network $HOST_DOCKER_NETWORK")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create network if needed
DOCKER_CREATE_NET="$(__docker_net_create)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set nginx directory
if [ -z "$NGINX_DIR" ]; then
  NGINX_DIR="$HOME/.config/nginx"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Container listen address [address:extPort:intPort]
HOST_DEFAULT_IP="${SET_LOCAL_IP:-$SET_LAN_IP}"
HOST_LISTEN_ADDR="${HOST_LISTEN_ADDR:-$SET_LAN_IP}"
if [ "$HOST_NETWORK_ADDR" = "yes" ] || [ "$HOST_NETWORK_ADDR" = "lan" ]; then
  HOST_DEFINE_LISTEN="$SET_LAN_IP"
  HOST_LISTEN_ADDR="$SET_LAN_IP"
elif [ "$HOST_NETWORK_ADDR" = "public" ] || [ "$HOST_NETWORK_ADDR" = "all" ]; then
  if connect_test && __test_public_reachable; then
    HOST_DEFINE_LISTEN="0.0.0.0"
    HOST_LISTEN_ADDR=$(__public_ip -4)
  else
    HOST_DEFINE_LISTEN="$HOST_DEFAULT_IP"
    HOST_LISTEN_ADDR="$HOST_DEFAULT_IP"
  fi
elif [ "$HOST_NETWORK_ADDR" = "docker" ]; then
  HOST_DEFINE_LISTEN="$SET_DOCKER_IP"
  HOST_LISTEN_ADDR="$SET_DOCKER_IP"
elif [ "$HOST_NETWORK_ADDR" = "local" ]; then
  HOST_DEFINE_LISTEN="127.0.0.1"
  HOST_LISTEN_ADDR="127.0.0.1"
  CONTAINER_PRIVATE="yes"
else
  HOST_DEFINE_LISTEN="0.0.0.0"
  HOST_LISTEN_ADDR="$HOST_DEFAULT_IP"
fi
HOST_DEFINE_LISTEN="${HOST_DEFINE_LISTEN:-0.0.0.0}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup the listen address
if [ -n "$HOST_DEFINE_LISTEN" ]; then
  HOST_LISTEN_ADDR="${HOST_DEFINE_LISTEN//:*/}"
fi
HOST_LISTEN_ADDR="${HOST_LISTEN_ADDR:-$HOST_DEFINE_LISTEN}"
HOST_LISTEN_ADDR="${HOST_LISTEN_ADDR//0.0.0.0/$SET_LAN_IP}"
HOST_LISTEN_ADDR="${HOST_LISTEN_ADDR//:*/}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# # nginx
NGINX_VHOSTS_CONF_FILE_TMP="/tmp/$$.$APPNAME.conf"
NGINX_VHOSTS_INC_FILE_TMP="/tmp/$$.$APPNAME.inc.conf"
NGINX_VHOSTS_PROXY_FILE_TMP="/tmp/$$.$APPNAME.custom.conf"
NGINX_TMP_FILES="$(__trim "$NGINX_VHOSTS_CONF_FILE_TMP" "$NGINX_VHOSTS_INC_FILE_TMP" "$NGINX_VHOSTS_PROXY_FILE_TMP")"
NINGX_WRITABLE="$(sudo -n true && sudo bash -c '[ -w "/etc/nginx" ] && echo "true" || false' || echo 'false')"
if [ "$HOST_NGINX_ENABLED" = "yes" ] && [ "$CONTAINER_WEB_SERVER_ENABLED" = "yes" ]; then
  if [ -f "/etc/nginx/nginx.conf" ] && [ "$NINGX_WRITABLE" = "true" ]; then
    NGINX_DIR="/etc/nginx"
  else
    NGINX_DIR="$HOME/.config/nginx"
  fi
  if [ -n "$HOST_NGINX_HTTPS_PORT" ]; then
    NGINX_LISTEN_OPTS="ssl"
    NGINX_PORT="${HOST_NGINX_HTTPS_PORT:-443}"
  else
    NGINX_PORT="${HOST_NGINX_HTTP_PORT:-80}"
  fi
  [ -n "$HOST_NGINX_LISTEN_ON_IP_ADDRESS" ] && HOST_NGINX_HTTP_PORT="$HOST_NGINX_LISTEN_ON_IP_ADDRESS:$NGINX_PORT" && NGINX_PORT="$HOST_NGINX_LISTEN_ON_IP_ADDRESS:$NGINX_PORT"
  if [ "$CONTAINER_WEB_SERVER_AUTH_ENABLED" = "yes" ]; then
    NGINX_AUTH_DIR="$NGINX_DIR/auth"
    CONTAINER_USER_NAME="${CONTAINER_USER_NAME:-root}"
    CONTAINER_USER_PASS="${CONTAINER_USER_PASS:-$RANDOM_PASS}"
    if [ ! -d "$NGINX_AUTH_DIR" ]; then
      mkdir -p "$NGINX_AUTH_DIR"
    fi
    if [ -n "$(builtin type -P htpasswd)" ]; then
      if ! grep -q "$CONTAINER_USER_NAME"; then
        __printf_color "3" "Creating auth $NGINX_AUTH_DIR/$CONTAINER_NAME"
        if [ -f "$NGINX_AUTH_DIR/$CONTAINER_NAME" ]; then
          htpasswd -b "$NGINX_AUTH_DIR/$CONTAINER_NAME" "$CONTAINER_USER_NAME" "$CONTAINER_USER_PASS" &>/dev/null
        else
          htpasswd -b -c "$NGINX_AUTH_DIR/$CONTAINER_NAME" "$CONTAINER_USER_NAME" "$CONTAINER_USER_PASS" &>/dev/null
        fi
      fi
    fi
  fi
  if [ "$HOST_NGINX_UPDATE_CONF" = "yes" ]; then
    mkdir -p "$NGINX_DIR/vhosts.d"
  fi
  if [ ! -f "$NGINX_MAIN_CONFIG" ]; then
    HOST_NGINX_UPDATE_CONF="yes"
  fi
else
  for nginx_tmp in $NGINX_TMP_FILES; do
    [ -f "$nginx_tmp" ] && rm -Rf "$nginx_tmp"
  done
fi
unset nginx_tmp
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup containers web server
if [ "$CONTAINER_WEB_SERVER_ENABLED" = "yes" ]; then
  if [ "$NGINX_PROXY_ADDRESS" = "0.0.0.0" ]; then
    NGINX_PROXY_ADDRESS="127.0.0.1"
  else
    NGINX_PROXY_ADDRESS="${CONTAINER_WEB_SERVER_LISTEN_ON:-$HOST_LISTEN_ADDR}"
  fi
  if [ "$CONTAINER_WEB_SERVER_SSL_ENABLED" = "yes" ] || [ "$SSL_ENABLED" = "yes" ]; then
    CONTAINER_WEB_SERVER_PROTOCOL="https"
    DOCKER_SET_OPTIONS_ENV+=("--env SSL_ENABLED=true")
  fi
  if [ -n "$CONTAINER_WEB_SERVER_INT_PORT" ]; then
    CONTAINER_WEB_SERVER_INT_PORT="${CONTAINER_WEB_SERVER_INT_PORT//,/ }"
    DOCKER_SET_OPTIONS_ENV+=("--env WEB_PORT=\"$CONTAINER_WEB_SERVER_INT_PORT\"")
  fi
  if [ -z "$CONTAINER_WEB_SERVER_LISTEN_ON" ]; then
    CONTAINER_WEB_SERVER_LISTEN_ON="$HOST_LISTEN_ADDR"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -z "$CONTAINER_PROTOCOL" ] || DOCKER_SET_OPTIONS_ENV+=("--env CONTAINER_PROTOCOL=$CONTAINER_PROTOCOL")
[ -z "$CONTAINER_WEB_SERVER_PROTOCOL" ] || DOCKER_SET_OPTIONS_ENV+=("--env CONTAINER_WEB_SERVER_PROTOCOL=$CONTAINER_WEB_SERVER_PROTOCOL")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup easy port settings
if [ "$CONTAINER_SERVICE_PUBLIC" = "yes" ] || [ "$CONTAINER_SERVICE_PUBLIC" = "0.0.0.0" ]; then
  CONTAINER_SERVICE_PUBLIC="0.0.0.0"
elif ! echo "$CONTAINER_SERVICE_PUBLIC" | grep -q '[0-9].*\.[0-9].*\.[0-9].*\.[0-9]'; then
  CONTAINER_SERVICE_PUBLIC="127.0.0.1"
fi
if [ "$CONTAINER_IS_DNS_SERVER" = "yes" ]; then
  service_port="$(__netstat "53" | grep -v 'docker' && __port || echo "53")"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:53/udp")
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:53/tcp")
  unset service_port
fi
if [ "$CONTAINER_IS_DHCP_SERVER" = "yes" ]; then
  service_port="$(__netstat "67" | grep -v 'docker' && __port || echo "67")"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:67/udp")
  service_port="$(__netstat "68" | grep -v 'docker' && __port || echo "68")"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:68/udp")
  unset service_port
fi
if [ "$CONTAINER_IS_TFTP_SERVER" = "yes" ]; then
  service_port="$(__netstat "69" | grep -v 'docker' && __port || echo "69")"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:69/udp")
  unset service_port
fi
if [ "$CONTAINER_IS_SMTP_SERVER" = "yes" ]; then
  service_port="$(__netstat "25" | grep -v 'docker' && __port || echo "25")"
  CONTAINER_EMAIL_PORTS+="$service_port"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:25/tcp")
  service_port="$(__netstat "465" | grep -v 'docker' && __port || echo "465")"
  CONTAINER_EMAIL_PORTS+="$service_port"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:465/tcp")
  service_port="$(__netstat "587" | grep -v 'docker' && __port || echo "587")"
  CONTAINER_EMAIL_PORTS+="$service_port"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:587/tcp")
  unset service_port
fi
if [ "$CONTAINER_IS_POP3_SERVER" = "yes" ]; then
  service_port="$(__netstat "110" | grep -v 'docker' && __port || echo "110")"
  CONTAINER_EMAIL_PORTS+="$service_port"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:110/tcp")
  service_port="$(__netstat "995" | grep -v 'docker' && __port || echo "995")"
  CONTAINER_EMAIL_PORTS+="$service_port"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:995/tcp")
  unset service_port
fi
if [ "$CONTAINER_IS_IMAP_SERVER" = "yes" ]; then
  service_port="$(__netstat "143" | grep -v 'docker' && __port || echo "143")"
  CONTAINER_EMAIL_PORTS+="$service_port"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:143/tcp")
  service_port="$(__netstat "993" | grep -v 'docker' && __port || echo "993")"
  CONTAINER_EMAIL_PORTS+="$service_port"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:993/tcp")
  unset service_port
fi
if [ "$CONTAINER_IS_TIME_SERVER" = "yes" ]; then
  service_port="$(__netstat "123" | grep -v 'docker' && __port || echo "123")"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:123/udp")
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:123/tcp")
  unset service_port
fi
if [ "$CONTAINER_IS_TIME_SERVER" = "yes" ]; then
  service_port="$(__netstat "119" | grep -v 'docker' && __port || echo "119")"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:119/tcp")
  service_port="$(__netstat "433" | grep -v 'docker' && __port || echo "433")"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_SERVICE_PUBLIC:$service_port:433/tcp")
  unset service_port
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_ADD_CUSTOM_SINGLE" ]; then
  if echo "$CONTAINER_ADD_CUSTOM_SINGLE" | grep -q ":random:"; then
    CONTAINER_ADD_CUSTOM_SINGLE="${CONTAINER_ADD_CUSTOM_SINGLE//:random:/:$(__rport):}"
  fi
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_ADD_CUSTOM_SINGLE")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Database setup
if [ -n "$CONTAINER_CREATE_DATABASE_NAME" ]; then
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_CREATE=$CONTAINER_CREATE_DATABASE_NAME")
fi
if [ -n "$CONTAINER_DEFAULT_DATABASE_TYPE" ]; then
  DOCKER_SET_OPTIONS_ENV+=("--env CONTAINER_DEFAULT_DATABASE_TYPE=$CONTAINER_DEFAULT_DATABASE_TYPE")
fi
if [ -z "$CONTAINER_DATABASE_LISTEN" ]; then
  CONTAINER_DATABASE_LISTEN="0.0.0.0"
fi
if [ -z "$DATABASE_BASE_DIR" ]; then
  DATABASE_BASE_DIR="/data/db"
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_BASE_DIR=$DATABASE_BASE_DIR")
fi
if [ "$CONTAINER_CUSTOM_DATABASE_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  CONTAINER_CUSTOM_DATABASE_NAME="${CONTAINER_CUSTOM_DATABASE_NAME:-custom}"
  DATABASE_DIR_CUSTOM="${DATABASE_DIR_CUSTOM:-$DATABASE_BASE_DIR/$CONTAINER_CUSTOM_DATABASE_NAME}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/$DATABASE_DIR_CUSTOM:$DATABASE_DIR_CUSTOM:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_CUSTOM=$DATABASE_DIR_CUSTOM")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_CUSTOM=$CONTAINER_CUSTOM_DATABASE_ADMIN_WWW_ROOT")
  CONTAINER_CUSTOM_DATABASE_PROTOCOL="${CONTAINER_CUSTOM_DATABASE_PROTOCOL:-file}"
  if echo "$CONTAINER_CUSTOM_DATABASE_PORT" | grep -q "^[0-9][0-9]"; then
    CONTAINER_DATABASE_PROTO="$CONTAINER_CUSTOM_DATABASE_PROTOCOL://$HOST_LISTEN_ADDR:$CONTAINER_CUSTOM_DATABASE_PORT"
  else
    CONTAINER_DATABASE_PROTO="file:///$DATABASE_DIR_CUSTOM/"
  fi
  MESSAGE_CONTAINER_DATABASE="true"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:$CONTAINER_CUSTOM_DATABASE_PORT:$CONTAINER_CUSTOM_DATABASE_PORT")
fi
if [ "$CONTAINER_SQLITE_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  DATABASE_DIR_SQLITE="${DATABASE_DIR_SQLITE:-$DATABASE_BASE_DIR/sqlite}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/db/sqlite:$DATABASE_DIR_SQLITE:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_SQLITE=$DATABASE_DIR_SQLITE")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_SQLITE=/usr/local/share/httpd/admin/sqlite")
  CONTAINER_DATABASE_PROTO="sqlite://$DATABASE_DIR_SQLITE"
  if [ ! -d "$LOCAL_DATA_DIR/db/sqlite" ]; then
    mkdir -p "$LOCAL_DATA_DIR/db/sqlite"
    chmod -Rf 777 $LOCAL_DATA_DIR/db
  fi
  MESSAGE_SQLITE="true"
fi
if [ "$CONTAINER_REDIS_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  CONTAINER_DATABASE_PROTO="redis://$HOST_LISTEN_ADDR:6379"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:6379:6379")
  DATABASE_DIR_REDIS="${DATABASE_DIR_REDIS:-$DATABASE_BASE_DIR/redis}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/db/redis:$DATABASE_DIR_REDIS:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_REDIS=$DATABASE_DIR_REDIS")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_REDIS=/usr/local/share/httpd/admin/redis")
  MESSAGE_REDIS="true"
fi
if [ "$CONTAINER_POSTGRES_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:5432:5432")
  DATABASE_DIR_POSTGRES="${DATABASE_DIR_POSTGRES:-$DATABASE_BASE_DIR/postgres}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/db/postgres:$DATABASE_DIR_POSTGRES:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_POSTGRES=$DATABASE_DIR_POSTGRES")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_POSTGRES=/usr/local/share/httpd/admin/postgres")
  CONTAINER_DATABASE_PROTO="postgresql://$HOST_LISTEN_ADDR:5432"
  MESSAGE_PGSQL="true"
fi
if [ "$CONTAINER_MYSQL_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:3306:3306")
  DATABASE_DIR_MYSQL="${DATABASE_DIR_MYSQL:-$DATABASE_BASE_DIR/mysql}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/db/mysql:$DATABASE_DIR_MYSQL:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_MYSQL=$DATABASE_DIR_MYSQL")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_MYSQL=/usr/local/share/httpd/admin/mysql")
  CONTAINER_DATABASE_PROTO="mysql://$HOST_LISTEN_ADDR:3306"
  MESSAGE_MARIADB="true"
fi
if [ "$CONTAINER_MARIADB_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:3306:3306")
  DATABASE_DIR_MARIADB="${DATABASE_DIR_MARIADB:-$DATABASE_BASE_DIR/mysql}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/db/mysql:$DATABASE_DIR_MARIADB:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_MARIADB=$DATABASE_DIR_MARIADB")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_MARIADB=/usr/local/share/httpd/admin/mysql")
  CONTAINER_DATABASE_PROTO="mysql://$HOST_LISTEN_ADDR:3306"
  MESSAGE_MARIADB="true"
fi
if [ "$CONTAINER_COUCHDB_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:5984:5984")
  DATABASE_DIR_COUCHDB="${DATABASE_DIR_COUCHDB:-$DATABASE_BASE_DIR/couchdb}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/db/couchdb:$DATABASE_DIR_COUCHDB:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_COUCHDB=/usr/local/share/httpd/admin/couchdb")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_COUCHDB=$DATABASE_DIR_COUCHDB")
  CONTAINER_DATABASE_PROTO="http://$HOST_LISTEN_ADDR:5984"
  MESSAGE_COUCHDB="true"
fi
if [ "$CONTAINER_MONGODB_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:27017:27017")
  DATABASE_DIR_MONGODB="${DATABASE_DIR_MONGODB:-$DATABASE_BASE_DIR/mongodb}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/db/mongodb:$DATABASE_DIR_MONGODB:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_MONGODB=$DATABASE_DIR_MONGODB")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_MONGODB=/usr/local/share/httpd/admin/mongodb")
  CONTAINER_DATABASE_PROTO="mongodb://$HOST_LISTEN_ADDR:27017"
  MESSAGE_MONGODB="true"
fi
if [ "$CONTAINER_SUPABASE_ENABLED" = "yes" ]; then
  SHOW_DATABASE_INFO="true"
  CONTAINER_DATABASE_ENABLED="yes"
  CONTAINER_DATABASE_PROTO="http://$HOST_LISTEN_ADDR:8000"
  DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_DATABASE_LISTEN:5432:5432")
  DATABASE_DIR_SUPABASE="${DATABASE_DIR_SUPABASE:-$DATABASE_BASE_DIR/supabase}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR/db/supabase:$DATABASE_DIR_SUPABASE:z")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_DIR_SUPABASE=$DATABASE_DIR_SUPABASE")
  DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_ADMIN_WWW_ROOT_SUPABASE=/usr/local/share/httpd/admin/supabase")
  MESSAGE_SUPABASE="true"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_DB_ENV_NAME" ] && [ -n "$CONTAINER_DB_ENV_STRING" ]; then
  DOCKER_SET_OPTIONS_ENV+=("--env $CONTAINER_DB_ENV_NAME=$CONTAINER_DB_ENV_STRING")
  SHOW_DATABASE_CONNECTION_STRING="yes"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if [ "$CONTAINER_DATABASE_ENABLED" = "yes" ]; then
  if [ -n "$CONTAINER_DATABASE_USER_ROOT" ]; then
    SET_DB_ROOT_PASS="yes"
    CONTAINER_DATABASE_PASS_ROOT="${CONTAINER_DATABASE_PASS_ROOT:-random}"
    DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_USER_ROOT=${CONTAINER_DATABASE_USER_ROOT:-root}")
  fi
  if [ "$SET_DB_ROOT_PASS" = "yes" ] || [ -n "$CONTAINER_DATABASE_PASS_ROOT" ]; then
    if [ "$CONTAINER_DATABASE_PASS_ROOT" = "random" ]; then
      CONTAINER_DATABASE_PASS_ROOT="$(__create_password "${CONTAINER_DATABASE_LENGTH_ROOT:-12}")"
    fi
    DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_PASS_ROOT=$CONTAINER_DATABASE_PASS_ROOT")
  fi
  if [ -n "$CONTAINER_DATABASE_USER_NORMAL" ]; then
    SET_DB_NORMAL_PASS="yes"
    CONTAINER_DATABASE_PASS_NORMAL="${CONTAINER_DATABASE_PASS_NORMAL:-random}"
    DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_USER_NORMAL=${CONTAINER_DATABASE_USER_NORMAL:-$USER}")
  fi
  if [ "$SET_DB_NORMAL_PASS" = "yes" ] || [ -n "$CONTAINER_DATABASE_PASS_NORMAL" ]; then
    if [ "$CONTAINER_DATABASE_PASS_NORMAL" = "random" ]; then
      CONTAINER_DATABASE_PASS_NORMAL="$(__create_password "${CONTAINER_DATABASE_LENGTH_NORMAL:-12}")"
    fi
    DOCKER_SET_OPTIONS_ENV+=("--env DATABASE_PASS_NORMAL=$CONTAINER_DATABASE_PASS_NORMAL")
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
    DOCKER_SET_OPTIONS_ENV+=("--env ${CONTAINER_ENV_USER_NAME:-username}=\"$CONTAINER_USER_NAME\"")
  fi
fi
if [ -n "$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD" ]; then
  CONTAINER_USER_PASS="$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD"
fi
if [ -n "$CONTAINER_USER_PASS" ]; then
  if [ "$CONTAINER_USER_PASS" = "random" ]; then
    CONTAINER_USER_PASS="$(__create_password "${CONTAINER_PASS_LENGTH:-16}")"
  fi
  CONTAINER_USER_PASS="${GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD:-${CONTAINER_USER_PASS:-$DEFAULT_PASSWORD}}"
fi
if [ -n "$CONTAINER_USER_PASS" ]; then
  if [ -n "$CONTAINER_ENV_PASS_NAME" ]; then
    DOCKER_SET_OPTIONS_ENV+=("--env ${CONTAINER_ENV_PASS_NAME:-PASSWORD}=\"$CONTAINER_USER_PASS\"")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup email variables
if [ "$CONTAINER_EMAIL_ENABLED" = "yes" ]; then
  if [ -n "$CONTAINER_EMAIL_DOMAIN" ]; then
    DOCKER_SET_OPTIONS_ENV+=("--env EMAIL_DOMAIN=$CONTAINER_EMAIL_DOMAIN")
  fi
  if [ -n "$CONTAINER_EMAIL_RELAY_SERVER" ]; then
    DOCKER_SET_OPTIONS_ENV+=("--env CONTAINER_EMAIL_RELAY_SERVER=$CONTAINER_EMAIL_RELAY_SERVER")
  fi
  if [ -n "$CONTAINER_EMAIL_RELAY_PORT" ]; then
    DOCKER_SET_OPTIONS_ENV+=("--env CONTAINER_EMAIL_RELAY_PORT=$CONTAINER_EMAIL_RELAY_PORT")
  fi
  if [ -n "$CONTAINER_EMAIL_USER" ]; then
    DOCKER_SET_OPTIONS_ENV+=("--env EMAIL_ADMIN=$CONTAINER_EMAIL_USER@")
  fi
  if [ -n "$CONTAINER_EMAIL_PORTS" ]; then
    CONTAINER_EMAIL_PORTS="$(echo "${CONTAINER_EMAIL_PORTS//,/ }" | tr ' ' '\n')"
    for port in $CONTAINER_EMAIL_PORTS; do
      DOCKER_SET_TMP_PUBLISH+=("--publish $HOST_LISTEN_ADDR:$port:$port")
    done
  fi
  DOCKER_SET_OPTIONS_ENV+=("--env EMAIL_ENABLED=$CONTAINER_EMAIL_ENABLED")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# process list
if [ -n "$CONTAINER_SERVICES_LIST" ]; then
  DOCKER_SET_OPTIONS_ENV+=("--env PROCS_LIST=${CONTAINER_SERVICES_LIST// /,}")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup data mount point
if [ "$CONTAINER_MOUNT_DATA_ENABLED" = "yes" ]; then
  if [ -z "$CONTAINER_MOUNT_DATA_MOUNT_DIR" ]; then
    CONTAINER_MOUNT_DATA_MOUNT_DIR="/data"
  fi
  CONTAINER_MOUNT_DATA_MOUNT_DIR="${CONTAINER_MOUNT_DATA_MOUNT_DIR//:*/}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_DATA_DIR:$CONTAINER_MOUNT_DATA_MOUNT_DIR:z")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set config mount point
if [ "$CONTAINER_MOUNT_CONFIG_ENABLED" = "yes" ]; then
  if [ -z "$CONTAINER_MOUNT_CONFIG_MOUNT_DIR" ]; then
    CONTAINER_MOUNT_CONFIG_MOUNT_DIR="/config"
  fi
  CONTAINER_MOUNT_CONFIG_MOUNT_DIR="${CONTAINER_MOUNT_CONFIG_MOUNT_DIR//:*/}"
  DOCKER_SET_OPTIONS_VOLUME+=("--volume $LOCAL_CONFIG_DIR:$CONTAINER_MOUNT_CONFIG_MOUNT_DIR:z")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# additional docker arguments
if [ -n "$DOCKER_CUSTOM_ARGUMENTS" ]; then
  DOCKER_CUSTOM_ARGUMENTS="${DOCKER_CUSTOM_ARGUMENTS//,/ }"
  DOCKER_SET_OPTIONS_DEFAULT+=("$DOCKER_CUSTOM_ARGUMENTS")
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# debugging
if [ "$CONTAINER_DEBUG_ENABLED" = "yes" ]; then
  DOCKER_SET_OPTIONS_ENV+=("--env DEBUGGER=on")
  if [ -n "$CONTAINER_DEBUG_OPTIONS" ]; then
    DOCKER_SET_OPTIONS_ENV+=("--env DEBUGGER_OPTIONS=$CONTAINER_DEBUG_OPTIONS")
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
  unset link
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup dns
if [ -n "$CONTAINER_DNS" ]; then
  DOCKER_SET_DNS=""
  DOCKER_SET_OPTIONS_ENV+=("--env CUSTOM_DNS=true")
  CONTAINER_DNS="${CONTAINER_DNS//,/ }"
  for dns in $CONTAINER_DNS; do
    if [ "$dns" != "" ] && [ "$dns" != " " ]; then
      DOCKER_SET_DNS+="--dns $dns "
    fi
  done
  unset dns
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup mounts
if [ -n "$CONTAINER_MOUNTS" ]; then
  DOCKER_SET_MNT=""
  CONTAINER_MOUNTS="${CONTAINER_MOUNTS//,/ }"
  for mnt in $CONTAINER_MOUNTS; do
    if [ "$mnt" != "" ] && [ "$mnt" != " " ]; then
      if echo "$mnt" | grep -q '^HOST/'; then
        mnt="${mnt//HOST\//}"
        host_mnt="${mnt//:*/}"
        cont_mnt="${mnt//*:/}"
        [ -n "$cont_mnt" ] && mnt="$HOST_ROOTFS_DIR/$host_mnt:$cont_mnt" || mnt="$HOST_ROOTFS_DIR/$host_mnt:$host_mnt"
      fi
      echo "$mnt" | grep -q ':' || mnt="$mnt:$mnt"
      DOCKER_SET_MNT+="--volume $mnt "
    fi
  done
  unset mnt host_mnt cont_mnt
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
  unset mnt
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
  unset dev
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup enviroment variables
if [ -n "$CONTAINER_ENV" ]; then
  DOCKER_SET_ENV_VAR=""
  CONTAINER_ENV="${CONTAINER_ENV//,/ }"
  for env in $CONTAINER_ENV; do
    if [ "$env" != "" ] && [ "$env" != " " ]; then
      DOCKER_SET_ENV_VAR+="--env $env "
    fi
  done
  unset env
fi
if [ -n "$CONTAINER_OPT_ENV_VAR" ]; then
  CONTAINER_OPT_ENV_VAR="${CONTAINER_OPT_ENV_VAR//,/ }"
  for env in $CONTAINER_OPT_ENV_VAR; do
    if [ "$env" != "" ] && [ "$env" != " " ]; then
      DOCKER_SET_ENV_VAR+="--env $env "
    fi
  done
  unset env
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup capabilites
[ "$DOCKER_CAP_CHOWN" = "yes" ] && SET_CAPABILITIES+=("CHOWN")
[ "$DOCKER_CAP_NET_RAW" = "yes" ] && SET_CAPABILITIES+=("NET_RAW")
[ "$DOCKER_CAP_NET_ADMIN" = "yes" ] && SET_CAPABILITIES+=("NET_ADMIN")
[ "$DOCKER_CAP_SYS_NICE" = "yes" ] && SET_CAPABILITIES+=("SYS_NICE")
[ "$DOCKER_CAP_SYS_TIME" = "yes" ] && SET_CAPABILITIES+=("SYS_TIME")
[ "$DOCKER_CAP_SYS_ADMIN" = "yes" ] && SET_CAPABILITIES+=("SYS_ADMIN")
[ "$DOCKER_CAP_SYS_MODULE" = "yes" ] && SET_CAPABILITIES+=("SYS_MODULE")
[ "$DOCKER_CAP_NET_BIND_SERVICE" = "yes" ] && SET_CAPABILITIES+=("NET_BIND_SERVICE")
[ -n "${SET_CAPABILITIES[*]}" ] && CONTAINER_CAPABILITIES="${SET_CAPABILITIES[*]}"
if [ -n "$CONTAINER_CAPABILITIES" ]; then
  DOCKER_SET_CAP=""
  CONTAINER_CAPABILITIES="${CONTAINER_CAPABILITIES//,/ } ${DOCKER_CUSTOM_CAP//,/ }"
  for cap in $CONTAINER_CAPABILITIES; do
    if [ "$cap" != "" ] && [ "$cap" != " " ]; then
      DOCKER_SET_CAP+="--cap-add $cap "
    fi
  done
  unset cap
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup sysctl
if [ -n "$CONTAINER_SYSCTL" ]; then
  DOCKER_SET_SYSCTL=""
  CONTAINER_SYSCTL="${CONTAINER_SYSCTL//,/ }"
  for sysctl in $CONTAINER_SYSCTL; do
    if [ "$sysctl" != "" ] && [ "$sysctl" != " " ]; then
      DOCKER_SET_SYSCTL+="--sysctl \"$sysctl\" "
    fi
  done
  unset sysctl
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
  unset label
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup custom port mappings
SET_TEMP_LISTEN="${HOST_DEFINE_LISTEN//:*/}"
SET_TEMP_ADDR="${HOST_LISTEN_ADDR:-127.0.0.1}"
if [ -n "$CONTAINER_OPT_PORT_VAR" ] || [ -n "$CONTAINER_ADD_CUSTOM_PORT" ]; then
  SET_TEMP_PUBLISH=""
  CONTAINER_LISTEN_ON="${SET_TEMP_LISTEN:-$SET_TEMP_ADDR}"
  CONTAINER_OPT_PORT_VAR="${CONTAINER_OPT_PORT_VAR//,/ }"
  CONTAINER_ADD_CUSTOM_PORT="${CONTAINER_ADD_CUSTOM_PORT//,/ }"
  for set_port in $CONTAINER_ADD_CUSTOM_PORT $CONTAINER_OPT_PORT_VAR; do
    if [ "$set_port" != " " ] && [ -n "$set_port" ]; then
      new_port="${set_port//\/*/}"
      TYPE="$(echo "$set_port" | grep '/' | awk -F '/' '{print $NF}' | head -n1 | grep '^' || echo '')"
      if echo "$new_port" | grep -q 'random:'; then
        random_port="$(__rport)"
        new_port="${new_port//random:/}"
        port="$random_port:${new_port//*:/}"
      elif echo "$new_port" | grep -q '\.all:[0-9]'; then
        set_listen_on_all="yes"
        new_port="${new_port//.all:/}"
        if echo "$new_port" | grep -q '^.*[0-9]:[0-9]'; then
          port="$new_port"
        else
          port="$new_port:$new_port"
        fi
        set_listen_addr="false"
        set_listen_port="$port $set_listen_port"
      elif echo "$new_port" | grep -q ':.*[0-9]:[0-9]'; then
        new_port="${new_port//.all:/}"
        port=$new_port
        set_listen_addr="false"
      elif echo "$new_port" | grep -q '^.*[0-9]:[0-9]'; then
        new_port="${new_port//.all:/}"
        port=$new_port
      elif echo "$new_port" | grep -q ':.*[0-9]:[0-9]'; then
        port="$new_port"
        set_listen_addr="false"
      elif echo "$new_port" | grep -q ':'; then
        port="$new_port"
        set_listen_addr="true"
      else
        port="$new_port:$new_port"
        set_listen_addr="false"
      fi
      if [ "$CONTAINER_PRIVATE" = "yes" ]; then
        port="$SET_ADDR:$port"
      elif [ "$set_listen_addr" = "true" ]; then
        port="$CONTAINER_LISTEN_ON:$port"
      fi
      [ -z "$TYPE" ] && SET_TEMP_PUBLISH="$port" || SET_TEMP_PUBLISH="$port/$TYPE"
      DOCKER_SET_TMP_PUBLISH+=("--publish $SET_TEMP_PUBLISH")
    fi
  done
  unset set_port SET_TEMP_LISTEN SET_TEMP_ADDR SET_TEMP_PUBLISH
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# container web server configuration proxy|/location|port
if [ "$CONTAINER_WEB_SERVER_ENABLED" = "yes" ] && { [ -n "$CONTAINER_ADD_RANDOM_PORTS" ] || [ -n "$CONTAINER_WEB_SERVER_INT_PORT" ]; }; then
  internal_path="/${CONTAINER_WEB_SERVER_INT_PATH//\/\//\/}"
  external_path="/${CONTAINER_WEB_SERVER_EXT_PATH//\/\//\/}"
  CONTAINER_WEB_SERVER_LISTEN_ON="${CONTAINER_WEB_SERVER_LISTEN_ON:-}"
  CONTAINER_ADD_RANDOM_PORTS="${CONTAINER_ADD_RANDOM_PORTS//,/ }"
  CONTAINER_WEB_SERVER_INT_PORT="${CONTAINER_WEB_SERVER_INT_PORT//,/ }"
  for set_port in $CONTAINER_WEB_SERVER_INT_PORT $CONTAINER_ADD_RANDOM_PORTS; do
    if [ "$set_port" != " " ] && [ -n "$set_port" ]; then
      proxy_url=""
      proxy_location=""
      proxy_info="$set_port"
      get_port="${set_port//*|*|/}"
      port=${get_port//\/*/}
      port="${port//*:/}"
      random_port="$(__rport)"
      set_hostname="${proxy_info//|*/}"
      SET_WEB_PORT_TMP+=("$CONTAINER_WEB_SERVER_LISTEN_ON:$random_port")
      DOCKER_SET_TMP_PUBLISH+=("--publish $CONTAINER_WEB_SERVER_LISTEN_ON:$random_port:$port")
      if echo "$proxy_info" | grep -q '[a-zA-Z0-9]|/.*|[0-9]'; then
        NGINX_REPLACE_INCLUDE="yes"
        set_hostname="$(echo "$set_hostname" | grep -v 'proxy$' | grep '^' || false)"
        proxy_location="$(echo "$proxy_info" | awk -F '|' '{print $2}' | grep '^' || false)"
        proxy_url="$CONTAINER_WEB_SERVER_LISTEN_ON:$random_port"
        proxy_url="${proxy_url//\/\//\/}"
        echo "$CONTAINER_WEB_SERVER_PROTOCOL" | grep -q "^http" && nginx_proto="${CONTAINER_WEB_SERVER_PROTOCOL:-http}" || nginx_proto="http"
        if [ -n "$proxy_url" ] && [ -n "$proxy_location" ]; then
          if [ -n "$set_hostname" ]; then
            NGINX_CUSTOM_CONFIG="true"
            echo "$set_hostname" | grep -qF '.' || set_hostname="$set_hostname.$CONTAINER_HOSTNAME"
            cat <<EOF | tee -p -a "$NGINX_VHOSTS_PROXY_FILE_TMP" &>/dev/null
server {
  listen                                    443 ssl;
  listen                                    [::]:443 ssl;
  server_name                               $set_hostname;
  access_log                                /var/log/nginx/access.$set_hostname.log;
  error_log                                 /var/log/nginx/error.$set_hostname.log info;
  keepalive_timeout                         75 75;
  client_max_body_size                      0;
  chunked_transfer_encoding                 on;
  add_header Strict-Transport-Security      "max-age=7200";
  ssl_protocols                             TLSv1.1 TLSv1.2;
  ssl_ciphers                               'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
  ssl_prefer_server_ciphers                 on;
  ssl_session_cache                         shared:SSL:10m;
  ssl_session_timeout                       1d;
  ssl_certificate                           /etc/letsencrypt/live/domain/fullchain.pem;
  ssl_certificate_key                       /etc/letsencrypt/live/domain/privkey.pem;

  include                                   /etc/nginx/global.d/nginx-defaults.conf;

  location ${external_path:-$proxy_location/} {
    send_timeout                            3600;
    proxy_ssl_verify                        off;
    proxy_http_version                      1.1;
    proxy_connect_timeout                   3600;
    proxy_send_timeout                      3600;
    proxy_read_timeout                      3600;
    proxy_request_buffering                 off;
    proxy_buffering                         off;
    proxy_set_header                        Host               \$http_host;
    proxy_set_header                        X-Real-IP          \$remote_addr;
    proxy_set_header                        X-Forwarded-For    \$remote_addr;
    proxy_set_header                        X-Forwarded-Proto  \$scheme;
    proxy_set_header                        Upgrade            \$http_upgrade;
    proxy_set_header                        Connection         \$connection_upgrade;
    proxy_redirect                          http:// https://;
    proxy_pass                              $nginx_proto://$proxy_url$internal_path;
  }

}

EOF
          else
            cat <<EOF | tee -p -a "$NGINX_VHOSTS_INC_FILE_TMP" &>/dev/null
  location ${external_path:-$proxy_location} {
    send_timeout                            3600;
    proxy_ssl_verify                        off;
    proxy_http_version                      1.1;
    proxy_connect_timeout                   3600;
    proxy_send_timeout                      3600;
    proxy_read_timeout                      3600;
    proxy_request_buffering                 off;
    proxy_buffering                         off;
    proxy_set_header                        Host              \$http_host;
    proxy_set_header                        X-Real-IP         \$remote_addr;
    proxy_set_header                        X-Forwarded-For   \$remote_addr;
    proxy_set_header                        X-Forwarded-Proto \$scheme;
    proxy_set_header                        Upgrade           \$http_upgrade;
    proxy_set_header                        Connection        \$connection_upgrade;
    proxy_redirect                          http:// https://;
    proxy_pass                              $nginx_proto://$proxy_url/$internal_path;
  }

EOF
          fi
        fi
        HOST_SERVER_HEALTH_CHECK_SERVER_NAME="${HOST_SERVER_HEALTH_CHECK_SERVER_NAME:-$nginx_proto://$proxy_url$internal_path}"
        unset proxy_info proxy_location proxy_url set_hostname
      fi
    fi
  done
  [ "$CONTAINER_WEB_SERVER_ENABLED" = "yes" ] || rm -Rf "$NGINX_VHOSTS_PROXY_FILE_TMP"
  [ -n "$CONTAINER_PUBLISHED_PORT" ] && DOCKER_SET_TMP_PUBLISH=("${CONTAINER_PUBLISHED_PORT//--publish,/}")
  CONTAINER_PUBLISHED_PORT="${DOCKER_SET_TMP_PUBLISH[*]}"
  CONTAINER_PUBLISHED_PORT="${CONTAINER_PUBLISHED_PORT// /,}"
  CONTAINER_PUBLISHED_PORT="${CONTAINER_PUBLISHED_PORT//--publish,/}"
  unset set_port CONTAINER_ADD_RANDOM_PORTS
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# reuse existing ports
if [ -n "$CONTAINER_PUBLISHED_PORT" ]; then
  publish_temp=()
  CONTAINER_PUBLISHED_PORT="${CONTAINER_PUBLISHED_PORT//,/ }"
  for publish_port in $CONTAINER_PUBLISHED_PORT; do
    publish_temp+=("--publish $publish_port ")
  done
  DOCKER_SET_TMP_PUBLISH=("${publish_temp[*]}")
  unset CONTAINER_ADD_RANDOM_PORTS publish_port publish_temp
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fix/create port
SET_WEB_PORT="$(__trim "${SET_WEB_PORT_TMP[*]}")"
SET_NGINX_PROXY_PORT="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | grep -v '^$' | head -n1 | grep '^' || echo '')"
if [ -n "$SET_NGINX_PROXY_PORT" ]; then
  CLEANUP_PORT="${SET_NGINX_PROXY_PORT//\/*/}"
  NGINX_PROXY_PORT="${CLEANUP_PORT//$NGINX_PROXY_ADDRESS:/}"
fi
unset SET_PRETTY_PORT SET_NGINX_PROXY_PORT SET_WEB_PORT_TMP CLEANUP_PORT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL setup
if [ "$NGINX_SSL" = "yes" ]; then
  if [ "$SSL_ENABLED" = "yes" ]; then
    CONTAINER_WEB_SERVER_PROTOCOL="https"
  fi
fi
if [ -n "$NGINX_PROXY_ADDRESS" ] && [ -n "$NGINX_PROXY_PORT" ]; then
  NGINX_PROXY_URL="$CONTAINER_WEB_SERVER_PROTOCOL://$NGINX_PROXY_ADDRESS:$NGINX_PROXY_PORT"
  NGINX_PROXY_URL="${NGINX_PROXY_URL// /}$CONTAINER_WEB_SERVER_EXT_PATH"
else
  unset NGINX_PROXY_URL
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set temp env for PORTS ENV variable
CONTAINER_ENV_PORTS=("${DOCKER_SET_TMP_PUBLISH[@]//--publish/}")
SET_PORTS_ENV_TMP="$(__trim "${CONTAINER_ENV_PORTS[*]}")"
DOCKER_SET_PORTS_ENV_TMP="$(echo "${SET_PORTS_ENV_TMP//,/ }" | tr ' ' '\n' | grep ':' | awk -F ':' '{print $NF}' | grep '^')"
DOCKER_SET_PORTS_ENV_TMP="$(echo "$DOCKER_SET_PORTS_ENV_TMP" | grep '[0-9]' | sed 's|/.*||g' | sort -uV | grep -v '^$' | tr '\n' ' ' | grep '^' || echo '')"
ENV_PORTS="${DOCKER_SET_PORTS_ENV_TMP[*]}"
ENV_PORTS="$(__trim "${ENV_PORTS[*]}")"
if [ -n "$ENV_PORTS" ]; then
  DOCKER_SET_OPTIONS_ENV+=("--env ENV_PORTS=\"${ENV_PORTS[*]}\"")
fi
unset DOCKER_SET_PORTS_ENV_TMP ENV_PORTS SET_PORTS_ENV_TMP
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reset variables if the .env file exists
if [ "$DOCKER_ENV_FILE_ENABLED" = "yes" ]; then
  for get_env in $DOCKER_SET_ENV_VAR; do
    set_env="${get-env//--env/}"
    set_env="$(__trim "$set_env")"
    echo "$set_env" >>"$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env"
  done
  DOCKER_SET_ENV_VAR="${DOCKER_SET_ENV_VAR//$get_env/}"
  DOCKER_SET_ENV_FILE="--env-file $DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env"
fi
DOCKER_SET_ENV_VAR="${DOCKER_SET_ENV_FILE:-$DOCKER_SET_ENV_VAR}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKER_CUSTOM_ARRAY="$(__retrieve_custom_env | __custom_docker_clean_env)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Clean up variables
DOCKER_SET_PUBLISH="$(printf '%s\n' "${DOCKER_SET_TMP_PUBLISH[@]}" | sort -Vu | tr '\n' ' ')" # ensure only one
DOCKER_HUB_IMAGE_URL="$(__trim "${DOCKER_HUB_IMAGE_URL[*]:-}")"                               # image url
DOCKER_HUB_IMAGE_TAG="$(__trim "${DOCKER_HUB_IMAGE_TAG[*]:-}")"                               # image tag
DOCKER_GET_CUSTOM="$(__trim "${DOCKER_CUSTOM_ARRAY[*]:-}")"                                   # --tty --rm --interactive
DOCKER_GET_OPTIONS="$(__trim "${DOCKER_SET_OPTIONS_DEFAULT[*]:-}")"                           # --hostname --domain
DOCKER_GET_CAP="$(__trim "${DOCKER_SET_CAP[*]:-}")"                                           # --capabilites
DOCKER_GET_SYSCTL="$(__trim "${DOCKER_SET_SYSCTL[*]:-}")"                                     # --sysctl
DOCKER_GET_ENV="$(__trim "${DOCKER_SET_ENV_VAR[*]:-}")"                                       # --env
DOCKER_GET_DEV="$(__trim "${DOCKER_SET_DEV[*]:-}")"                                           # --device
DOCKER_GET_DNS="$(__trim "${DOCKER_SET_DNS[*]:-}")"                                           # --dns
DOCKER_GET_LINK="$(__trim "${DOCKER_SET_LINK[*]:-}")"                                         # --link
DOCKER_GET_LABELS="$(__trim "${DOCKER_SET_LABELS[*]:-}")"                                     # --labels
DOCKER_GET_DOCKER_ENV="$(__trim "${DOCKER_SET_OPTIONS_ENV[*]:-}")"                            # --hostname --domain
DOCKER_GET_DOCKER_VOLUME="$(__trim "${DOCKER_SET_OPTIONS_VOLUME[*]:-}")"                      # --hostname --domain
DOCKER_GET_MNT="$(__trim "${DOCKER_SET_MNT[*]:-}")"                                           # --volume
DOCKER_GET_PUBLISH="$(__trim "${DOCKER_SET_PUBLISH[*]:-}")"                                   # --publish ports
CONTAINER_COMMANDS="$(__trim "${CONTAINER_COMMANDS[*]:-}")"                                   # pass command to container
[ -n "$CONTAINER_COMMANDS" ] || CONTAINER_COMMANDS="    "
DOCKER_GET_ENV="$(__trim "$DOCKER_GET_ENV" "$DOCKER_GET_DOCKER_ENV")"
DOCKER_GET_MNT="$(__trim "$DOCKER_GET_MNT" "$DOCKER_GET_DOCKER_VOLUME")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set docker commands - script creation - execute command #
SET_EXECUTE_PRE_INSTALL="$(echo "docker stop $CONTAINER_NAME &>/dev/null;docker rm -f $CONTAINER_NAME &>/dev/null;docker pull -q $DOCKER_HUB_IMAGE_URL:$DOCKER_HUB_IMAGE_TAG")"
SET_EXECUTE_DOCKER_CMD="$(echo "docker run -d $DOCKER_GET_OPTIONS $DOCKER_GET_CUSTOM $DOCKER_GET_LINK $DOCKER_GET_LABELS $DOCKER_GET_CAP $DOCKER_GET_SYSCTL $DOCKER_GET_DEV $DOCKER_SET_DNS $DOCKER_GET_ENV $DOCKER_GET_MNT $DOCKER_GET_PUBLISH $DOCKER_HUB_IMAGE_URL:$DOCKER_HUB_IMAGE_TAG")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run functions
__container_import_variables "$CONTAINER_ENV_FILE_MOUNT"
__dockermgr_variables >"$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env.conf"
__custom_docker_script >"$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.script.sh"
__dockermgr_password_variables >"$DOCKERMGR_CONFIG_DIR/secure/$CONTAINER_NAME"
chmod -f 600 "$DOCKERMGR_CONFIG_DIR/secure/$CONTAINER_NAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
if [ ! -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.custom.conf" ]; then
  __custom_docker_env | sed 's|^--.* ||g' >"$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.custom.conf"
  echo "" >>"$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.custom.conf"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main progam
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -d "$APPDIR/files" ] && { [ ! -d "$HOST_ROOTFS_DIR" ] && mv -f "$APPDIR/files" "$HOST_ROOTFS_DIR"; }
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
if [ ! -d "$DATADIR" ]; then
  mkdir -p "$DATADIR"
  chmod -f 777 "$DATADIR"
  chown -Rf $USER:$USER "$DATADIR"
fi
if [ ! -d "$LOCAL_DATA_DIR" ]; then
  mkdir -p "$LOCAL_DATA_DIR"
  chmod -f 777 "$LOCAL_DATA_DIR"
  chown -Rf $USER:$USER "$LOCAL_DATA_DIR"
fi
if [ ! -d "$LOCAL_CONFIG_DIR" ]; then
  mkdir -p "$LOCAL_CONFIG_DIR"
  chmod -f 777 "$LOCAL_CONFIG_DIR"
  chown -Rf $USER:$USER "$LOCAL_CONFIG_DIR"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_CREATE_DIRECTORY="${CONTAINER_CREATE_DIRECTORY//,/ }"
CONTAINER_CREATE_DIRECTORY="$(__trim "$CONTAINER_CREATE_DIRECTORY")"
if [ -n "$CONTAINER_CREATE_DIRECTORY" ]; then
  CONTAINER_CREATE_DIRECTORY="${CONTAINER_CREATE_DIRECTORY//, /}"
  for dir in $CONTAINER_CREATE_DIRECTORY; do
    if [ -n "$dir" ] && [ ! -d "$HOST_ROOTFS_DIR/$dir" ]; then
      mkdir -p "$HOST_ROOTFS_DIR/$dir"
      chmod -f 777 "$HOST_ROOTFS_DIR/$dir"
      chown -Rf $USER:$USER "$HOST_ROOTFS_DIR/$dir"
    fi
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy over data files - keep the same stucture as -v HOST_ROOTFS_DIR/mnt:/mnt
INSTALLED_FILE_NAME="$APPDIR/.installed"
if [ -d "$INSTDIR/rootfs" ] && [ ! -f "$INSTALLED_FILE_NAME" ]; then
  __printf_color "3" "Copying files to $HOST_ROOTFS_DIR"
  __sudo_exec rsync -avhP "$INSTDIR/rootfs/." "$HOST_ROOTFS_DIR/" &>/dev/null
  find "$DATADIR" -name ".gitkeep" -type f -exec rm -rf {} \; &>/dev/null
fi
if [ -f "$INSTALLED_FILE_NAME" ]; then
  __sudo_exec date +'Updated on %Y-%m-%d at %H:%M' | tee -p "$INSTALLED_FILE_NAME" &>/dev/null
else
  __sudo_exec chown -f "$USER":"$USER" "$INSTDIR" "$INSTDIR" &>/dev/null
  __sudo_exec chown -Rf "$USER":"$USER" "$DOCKERMGR_CONFIG_DIR" &>/dev/null
  __sudo_exec date +'installed on %Y-%m-%d at %H:%M' | tee -p "$INSTALLED_FILE_NAME" &>/dev/null
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount /etc/resolv.conf file in the container
if [ "$HOST_RESOLVE_ENABLED" = "yes" ]; then
  mkdir -p "$INSTDIR/rootfs/etc"
  [ -n "$HOST_ETC_RESOLVE_INIT_FILE" ] || HOST_ETC_RESOLVE_INIT_FILE="/etc/resolv.conf"
  if [ ! -f "$INSTDIR/rootfs/etc/resolv.conf" ]; then
    cp -Rf "$HOST_ETC_RESOLVE_INIT_FILE" "$INSTDIR/rootfs/etc/resolv.conf"
  fi
  touch "$INSTDIR/rootfs/etc/resolv.conf"
  if [ "$HOST_ETC_RESOLVE_INIT_FILE" = "/usr/local/etc/resolv.conf" ]; then
    DOCKER_SET_OPTIONS_VOLUME+=("--volume $INSTDIR/rootfs/etc/resolv.conf:/usr/local/etc/resolv.conf")
  else
    DOCKER_SET_OPTIONS_VOLUME+=("--volume $INSTDIR/rootfs/etc/resolv.conf:/etc/resolv.conf")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mount /etc/hosts file in the container
if [ "$HOST_ETC_HOSTS_ENABLED" = "yes" ]; then
  mkdir -p "$INSTDIR/rootfs/etc"
  [ -n "$HOST_ETC_HOSTS_INIT_FILE" ] || HOST_ETC_HOSTS_INIT_FILE="/etc/hosts"
  if [ ! -f "$INSTDIR/rootfs/etc/hosts" ]; then
    cp -Rf "$HOST_ETC_HOSTS_INIT_FILE" "$INSTDIR/rootfs/etc/hosts"
  fi
  touch "$INSTDIR/rootfs/etc/hosts"
  if [ "$HOST_ETC_HOSTS_INIT_FILE" = "/usr/local/etc/hosts" ]; then
    DOCKER_SET_OPTIONS_VOLUME+=("--volume $INSTDIR/rootfs/etc/hosts:/usr/local/etc/hosts")
  else
    DOCKER_SET_OPTIONS_VOLUME+=("--volume $INSTDIR/rootfs/etc/hosts:/etc/hosts")
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DOCKERMGR_INSTALL_SCRIPT="$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup the container
unset EXECUTE_DOCKER_SCRIPT
EXECUTE_DOCKER_CMD="$(__trim "${SET_EXECUTE_DOCKER_CMD[*]}")"
EXECUTE_PRE_INSTALL="$(__trim "${SET_EXECUTE_PRE_INSTALL[*]}")"
DOCKER_COMPOSE_CMD="$(docker compose 2>&1 | grep -q 'is not a docker command.' || echo "true")"
if [ -f "$INSTDIR/docker-compose.yml" ] && [ "$DOCKER_COMPOSE_CMD" = "true" ]; then
  __printf_color "3" "Installing containers using docker-compose"
  sed -i 's|REPLACE_DATADIR|'$HOST_ROOTFS_DIR'' "$INSTDIR/docker-compose.yml" &>/dev/null
  if cd "$INSTDIR"; then
    docker compose pull &>/dev/null
    docker compose up -d &>/dev/null
    CONTAINER_INSTALLED="true"
    create_docker_script_message_pre="Failed to cd into $INSTDIR"
    create_docker_script_message_post="Failed to bring up containers"
    EXECUTE_PRE_INSTALL="$(echo 'cd "'$INSTDIR'"')"
    EXECUTE_DOCKER_CMD="$(echo 'docker compose pull && docker compose up -d')"
  fi
elif [ -f "$INSTDIR/docker-compose.yml" ] && [ -n "$(type -P docker-compose)" ]; then
  __printf_color "3" "Installing containers using docker-compose"
  sed -i 's|REPLACE_DATADIR|'$HOST_ROOTFS_DIR'' "$INSTDIR/docker-compose.yml" &>/dev/null
  if cd "$INSTDIR"; then
    docker-compose pull &>/dev/null
    docker-compose up -d &>/dev/null
    CONTAINER_INSTALLED="true"
    create_docker_script_message_pre="Failed to cd into $INSTDIR"
    create_docker_script_message_post="Failed to bring up containers"
    EXECUTE_PRE_INSTALL="$(echo 'cd "'$INSTDIR'"')"
    EXECUTE_DOCKER_CMD="$(echo 'docker-compose pull && docker-compose up -d')"
  fi
fi
if [ -x "$DOCKERMGR_INSTALL_SCRIPT" ]; then
  printf_cyan "Executing: $DOCKERMGR_INSTALL_SCRIPT"
  eval "$DOCKERMGR_INSTALL_SCRIPT" 2>"${TMP:-/tmp}/$APPNAME.err.log" >/dev/null
  __container_is_running && exitCode=0 || exitCode=1
  if [ $exitCode = 0 ]; then
    printf_green "Your container has been installed"
  else
    printf_red "Failed to reinstall the container"
    __printf_color "3" "Errors logged to: ${TMP:-/tmp}/$APPNAME.err.log"
    [ -f "$DOCKERMGR_INSTALL_SCRIPT" ] && mv -f "$DOCKERMGR_INSTALL_SCRIPT" "${DOCKERMGR_INSTALL_SCRIPT//.sh/.$$.bak.sh}"
    [ -f "${DOCKERMGR_INSTALL_SCRIPT//.sh/.$$.bak.sh}" ] && printf_yellow "Script moved to: ${DOCKERMGR_INSTALL_SCRIPT//.sh/.$$.bak.sh}"
  fi
  exit $exitCode
else
  __pre_docker_install_commands
  __create_docker_script
  EXECUTE_DOCKER_SCRIPT="$EXECUTE_DOCKER_CMD"
  if [ "$INIT_SCRIPT_ONLY" = "no" ] && [ -n "$EXECUTE_DOCKER_SCRIPT" ]; then
    EXECUTE_PRE_INSTALL="$(__trim "${EXECUTE_PRE_INSTALL//||*/}")"
    EXECUTE_DOCKER_SCRIPT="$(__trim "${EXECUTE_DOCKER_SCRIPT//||*/}")"
    __printf_color "6" "Updating the image from $DOCKER_HUB_IMAGE_URL with tag $DOCKER_HUB_IMAGE_TAG"
    if [ -n "$EXECUTE_PRE_INSTALL" ]; then
      __printf_color "6" "Executing pre-install command"
      eval "$EXECUTE_PRE_INSTALL" 2>"${TMP:-/tmp}/$APPNAME.err.log" >/dev/null
    fi
    __printf_color "6" "Creating container $CONTAINER_NAME"
    if eval $EXECUTE_DOCKER_SCRIPT $CONTAINER_COMMANDS 2>"${TMP:-/tmp}/$APPNAME.err.log" >/dev/null; then
      sleep 10
      if { __container_is_running || __docker_ps_all -q || __sudo_exec docker start $CONTAINER_NAME &>/dev/null; }; then
        rm -Rf "${TMP:-/tmp}/$APPNAME.err.log"
        echo "$CONTAINER_NAME" >"$DOCKERMGR_CONFIG_DIR/containers/$CONTAINER_NAME"
        __docker_ps_all -q && CONTAINER_INSTALLED="true"
      else
        ERROR_LOG="true"
      fi
    fi
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
if [ "$USER" = "root" ]; then
  [ -d "$NGINX_DIR" ] && NINGX_VHOSTS_WRITABLE="true"
else
  NINGX_VHOSTS_WRITABLE="$(sudo -n true && NGINX_DIR="$NGINX_DIR" sudo -E bash -c '[ -w "$NGINX_DIR" ] && echo true' || false)"
fi
if [ "$NINGX_VHOSTS_WRITABLE" = "true" ]; then
  NGINX_VHOST_TMP_NAMES=()
  NGINX_VHOST_ENABLED="true"
  NGINX_VHOST_SET_NAMES="${CONTAINER_WEB_SERVER_VHOSTS//,/ }"
  HOST_NGINX_VHOST_CONFIG_NAME="${HOST_NGINX_VHOST_CONFIG_NAME:-$CONTAINER_HOSTNAME}"
  NGINX_CONFIG_NAME="${CONTAINER_WEB_SERVER_CONFIG_NAME:-$HOST_NGINX_VHOST_CONFIG_NAME}"
  NGINX_MAIN_CONFIG="$NGINX_DIR/vhosts.d/$NGINX_CONFIG_NAME.conf"
  NGINX_VHOST_CONFIG="$NGINX_DIR/vhosts.d/$NGINX_CONFIG_NAME.custom.conf"
  NGINX_INC_CONFIG="$NGINX_DIR/conf.d/vhosts/$NGINX_CONFIG_NAME.conf"
  if [ "$NGINX_DIR" = "/etc/nginx/vhosts.d" ]; then
    [ -d "$NGINX_DIR/vhosts.d" ] || __sudo_root mkdir -p "$NGINX_DIR/vhosts.d"
    [ -d "$NGINX_DIR/global.d" ] || __sudo_root mkdir -p "$NGINX_DIR/global.d"
    [ -d "$NGINX_DIR/conf.d/vhosts.d" ] || __sudo_root mkdir -p "$NGINX_DIR/conf.d/vhosts.d"
    [ -f "$NGINX_DIR/global.d/nginx-defaults.conf" ] || __sudo_root touch "$NGINX_DIR/global.d/nginx-defaults.conf"
    __sudo_root chmod 777 "$NGINX_DIR/vhosts.d" "$NGINX_DIR/conf.d/vhosts.d"
  else
    [ -d "$NGINX_DIR/vhosts.d" ] || mkdir -p "$NGINX_DIR/vhosts.d"
    [ -d "$NGINX_DIR/global.d" ] || mkdir -p "$NGINX_DIR/global.d"
    [ -d "$NGINX_DIR/conf.d/vhosts.d" ] || mkdir -p "$NGINX_DIR/conf.d/vhosts.d"
    [ -f "$NGINX_DIR/global.d/nginx-defaults.conf" ] || touch "$NGINX_DIR/global.d/nginx-defaults.conf"
  fi
  if [ "$HOST_NGINX_UPDATE_CONF" = "yes" ] && [ -f "$INSTDIR/nginx/proxy.conf" ]; then
    for vhost in $NGINX_VHOST_SET_NAMES; do
      if [ -n "$vhost" ]; then
        set_vhost="${vhost// /}"
        if echo "$set_vhost" | grep -q "[.]all$"; then # map to vhost.*
          vhost="$(__set_vhost_alias "$set_vhost" ".all" ".*")"
          NGINX_VHOST_TMP_NAMES+=("$vhost")
          set_vhost=""
        elif echo "$set_vhost" | grep -q "^all[.]"; then # map to *.vhost
          vhost="$(__set_vhost_alias "$set_vhost" "all." "*.")"
          NGINX_VHOST_TMP_NAMES+=("$vhost")
          set_vhost=""
        elif echo "$set_vhost" | grep -q '[.]myhost$'; then # map to vhost.hostname
          vhost="$(__set_vhost_alias "$set_vhost" ".myhost" "")"
          NGINX_VHOST_TMP_NAMES+=("$vhost.$HOSTNAME")
          set_vhost=""
        elif echo "$set_vhost" | grep -q '[.]mydomain$'; then # map to vhost.domain or map to vhost.hostname
          vhost="$(__set_vhost_alias "$set_vhost" ".mydomain" "")"
          NGINX_VHOST_TMP_NAMES+=("$vhost.$CONTAINER_DOMAINNAME")
          set_vhost=""
        elif echo "$set_vhost" | grep -q '.*[a-zA-Z0-9]\.\*$'; then # map to vhost.*
          NGINX_VHOST_TMP_NAMES+=("$set_vhost")
          set_vhost=""
        else
          NGINX_VHOST_TMP_NAMES+=("${set_vhost:-$vhost}")
        fi
      fi
    done
    if [ -n "${NGINX_VHOST_TMP_NAMES[*]}" ]; then
      NGINX_VHOST_NAMES="$(__trim "${NGINX_VHOST_TMP_NAMES[*]}")"
      CONTAINER_WEB_SERVER_VHOSTS="${NGINX_VHOST_NAMES//\'/}"
      unset NGINX_VHOST_TMP_NAMES
    else
      NGINX_VHOST_NAMES="${NGINX_VHOST_NAMES:-}"
    fi
    cp -f "$INSTDIR/nginx/proxy.conf" "$NGINX_VHOSTS_CONF_FILE_TMP"
    if __if_file_contains "proxy_intercept_errors" "$NGINX_VHOSTS_CONF_FILE_TMP" && __if_file_contains "proxy_intercept_errors" "/etc/nginx/global.d"; then
      sed -i '/.*proxy_intercept_errors.*/d' "$NGINX_VHOSTS_CONF_FILE_TMP"
    fi
    sed -i "s|REPLACE_APPNAME|$APPNAME|g" "$NGINX_VHOSTS_CONF_FILE_TMP" &>/dev/null
    sed -i "s|REPLACE_NGINX_PORT|$NGINX_PORT|g" "$NGINX_VHOSTS_CONF_FILE_TMP" &>/dev/null
    sed -i "s|REPLACE_HOST_PROXY|$NGINX_PROXY_URL|g" "$NGINX_VHOSTS_CONF_FILE_TMP" &>/dev/null
    sed -i "s|REPLACE_NGINX_HOST|$CONTAINER_HOSTNAME|g" "$NGINX_VHOSTS_CONF_FILE_TMP" &>/dev/null
    sed -i "s|REPLACE_NGINX_VHOSTS|$NGINX_VHOST_NAMES|g" "$NGINX_VHOSTS_CONF_FILE_TMP" &>/dev/null
    sed -i "s|REPLACE_SERVER_LISTEN_OPTS|$NGINX_LISTEN_OPTS|g" "$NGINX_VHOSTS_CONF_FILE_TMP" &>/dev/null
    if [ -d "$NGINX_DIR/vhosts.d" ]; then
      if [ -f "$NGINX_VHOSTS_INC_FILE_TMP" ]; then
        sed -i "s|REPLACE_NGINX_INCLUDE|$NGINX_INC_CONFIG|g" "$NGINX_VHOSTS_CONF_FILE_TMP"
        __sudo_root mv -f "$NGINX_VHOSTS_INC_FILE_TMP" "$NGINX_INC_CONFIG"
      elif [ -f "$INSTDIR/nginx/conf.d/vhosts/include.conf" ]; then
        cat "$INSTDIR/nginx/conf.d/vhosts/include.conf" | tee -p "$NGINX_VHOSTS_INC_FILE_TMP" &>/dev/null
        sed -i "s|REPLACE_NGINX_INCLUDE|$NGINX_INC_CONFIG|g" "$NGINX_VHOSTS_CONF_FILE_TMP"
        __sudo_root mv -f "$NGINX_VHOSTS_INC_FILE_TMP" "$NGINX_INC_CONFIG"
      fi
      if [ -f "$NGINX_VHOSTS_PROXY_FILE_TMP" ] && [ "$NGINX_CUSTOM_CONFIG" = "true" ]; then
        __sudo_root mv -f "$NGINX_VHOSTS_PROXY_FILE_TMP" "$NGINX_VHOST_CONFIG"
      fi
      if [ ! -f "$NGINX_INC_CONFIG" ]; then
        sed -i "s|include.*REPLACE_NGINX_INCLUDE;||g" "$NGINX_VHOSTS_CONF_FILE_TMP"
      fi
      __sudo_root mv -f "$NGINX_VHOSTS_CONF_FILE_TMP" "$NGINX_MAIN_CONFIG"
      if [ -f "$NGINX_MAIN_CONFIG" ]; then
        NGINX_IS_INSTALLED="yes"
        NGINX_CONF_FILE="$NGINX_MAIN_CONFIG"
      fi
      if [ -f "/etc/nginx/nginx.conf" ]; then
        systemctl status nginx 2>/dev/null | grep -q enabled &>/dev/null && __sudo_root systemctl reload nginx &>/dev/null
      fi
    else
      mv -f "$NGINX_VHOSTS_CONF_FILE_TMP" "$INSTDIR/nginx/$NGINX_CONFIG_NAME.conf" &>/dev/null
    fi
  else
    NGINX_PROXY_URL=""
  fi
  [ -f "$NGINX_MAIN_CONFIG" ] && NGINX_PROXY_URL="$CONTAINER_WEB_SERVER_PROTOCOL://$CONTAINER_HOSTNAME"
fi
if [ "$NGINX_VHOST_NAMES" = "" ] || [ "$NGINX_VHOST_NAMES" = " " ]; then
  unset NGINX_VHOST_NAMES
else
  NGINX_VHOST_NAMES="${NGINX_VHOST_NAMES//,/ }"
fi
HOST_NGINX_PROXY_URL="${HOST_NGINX_PROXY_URL:-${NGNIX_REVERSE_ADDRESS:-$NGINX_PROXY_URL}}"
NGNIX_REVERSE_ADDRESS="${CONTAINER_NGINX_PROXY_URL:-${NGNIX_REVERSE_ADDRESS:-$HOST_NGINX_PROXY_URL}}"
CONTAINER_NGINX_PROXY_URL="${CONTAINER_NGINX_PROXY_URL:-$NGNIX_REVERSE_ADDRESS}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup an internal host
HOST_SERVER_HEALTH_CHECK_SERVER_NAME="${HOST_SERVER_HEALTH_CHECK_SERVER_NAME:-$CONTAINER_NGINX_PROXY_URL}"
NGINX_VHOSTS_PROXY_INT_TMP="/tmp/$$.$HOST_NGINX_INTERNAL_HOST.$HOST_NGINX_INTERNAL_DOMAIN"
if [ -n "$NGNIX_REVERSE_ADDRESS" ] && [ -n "$HOST_NGINX_INTERNAL_DOMAIN" ]; then
  HOST_NGINX_INTERNAL_DOMAIN="$HOST_NGINX_INTERNAL_HOST.$HOST_NGINX_INTERNAL_DOMAIN"
  cat <<EOF | tee -p "$NGINX_VHOSTS_PROXY_INT_TMP" &>/dev/null
server {
  listen                                    $HOST_NGINX_HTTP_PORT;
  listen                                    [::]:$HOST_NGINX_HTTP_PORT;
  server_name                               $HOST_NGINX_INTERNAL_DOMAIN;
  access_log                                /var/log/nginx/access.$HOST_NGINX_INTERNAL_DOMAIN.log;
  error_log                                 /var/log/nginx/error.$HOST_NGINX_INTERNAL_DOMAIN.log info;
  keepalive_timeout                         75 75;
  client_max_body_size                      0;
  chunked_transfer_encoding                 on;
  add_header Strict-Transport-Security      "max-age=7200";

  include                                   /etc/nginx/global.d/nginx-defaults.conf;

  location / {
    send_timeout                            3600;
    proxy_http_version                      1.1;
    proxy_connect_timeout                   3600;
    proxy_send_timeout                      3600;
    proxy_read_timeout                      3600;
    proxy_buffering                         off;
    proxy_request_buffering                 off;
    proxy_set_header                        Host               \$http_host;
    proxy_set_header                        X-Real-IP          \$remote_addr;
    proxy_set_header                        X-Forwarded-For    \$remote_addr;
    proxy_set_header                        X-Forwarded-Proto  \$scheme;
    proxy_pass                              $NGNIX_REVERSE_ADDRESS;
  }
}

EOF
  if [ -f "$NGINX_VHOSTS_PROXY_INT_TMP" ]; then
    if __if_file_contains "proxy_intercept_errors" "$NGINX_VHOSTS_PROXY_INT_TMP" && __if_file_contains "proxy_intercept_errors" "/etc/nginx/global.d"; then
      sed -i '/.*proxy_intercept_errors.*/d' "$NGINX_VHOSTS_PROXY_INT_TMP"
    fi
    if [ -f "/etc/nginx/nginx.conf" ]; then
      [ -d "$NGINX_DIR/vhosts.d" ] || __sudo_root mkdir -p "$NGINX_DIR/vhosts.d"
      __sudo_root mv -f "$NGINX_VHOSTS_PROXY_INT_TMP" "$NGINX_DIR/vhosts.d/$HOST_NGINX_INTERNAL_DOMAIN.conf"
      systemctl status nginx 2>/dev/null | grep -q enabled &>/dev/null && __sudo_root systemctl reload nginx &>/dev/null
    else
      [ -d "$NGINX_DIR" ] || mkdir -p "$NGINX_DIR/vhosts.d" 2>/dev/null
      [ -w "$NGINX_DIR" ] && mv -f "$NGINX_VHOSTS_PROXY_INT_TMP" "$NGINX_DIR/vhosts.d/$HOST_NGINX_INTERNAL_DOMAIN.conf" &>/dev/null
    fi
  fi
  NGINX_VHOST_NAMES="$NGINX_VHOST_NAMES $HOST_NGINX_INTERNAL_DOMAIN"
  [ -f "$NGINX_DIR/vhosts.d/$HOST_NGINX_INTERNAL_DOMAIN.conf" ] && NGINX_INTERNAL_IS_SET="$NGINX_DIR/vhosts.d/$HOST_NGINX_INTERNAL_DOMAIN.conf"
fi
CONTAINER_WEB_SERVER_VHOSTS="${CONTAINER_WEB_SERVER_VHOSTS:-$NGINX_VHOST_NAMES}"
CONTAINER_WEB_SERVER_VHOSTS="${CONTAINER_WEB_SERVER_VHOSTS//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# finalize
__setup_cron
if [ "$CONTAINER_INSTALLED" = "true" ] || __docker_ps_all -q; then
  DOCKER_PORTS="$(__trim "${DOCKER_GET_PUBLISH//--publish/}")"
  SET_PORT="$(echo "$DOCKER_PORTS" | tr ' ' '\n' | grep -vE '^$|--' | sort -V | awk -F ':' '{print $1":"$3":"$2}' | grep '^')"
  HOSTS_WRITABLE="$(sudo -n true && sudo bash -c '[ -w "/etc/hosts" ] && echo "true" || false' || echo 'false')"
  printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  if [ "$HOSTS_WRITABLE" = "true" ]; then
    if [ -n "$CONTAINER_WEB_SERVER_VHOSTS" ] && [ "$CONTAINER_WEB_SERVER_VHOSTS" != " " ]; then
      for vhost in $CONTAINER_WEB_SERVER_VHOSTS; do
        if ! grep -shhq " $vhost$" "/etc/hosts"; then
          if echo "$vhost" | grep -qFv '*'; then
            __printf_spacing_color "40" "Adding to /etc/hosts:" "$vhost $CONTAINER_WEB_SERVER_LISTEN_ON"
            __printf_spacing_file "$CONTAINER_WEB_SERVER_LISTEN_ON" "$vhost" | sudo tee -p -a "/etc/hosts" &>/dev/null
          fi
        fi
      done
      show_hosts_message_banner="true"
    fi
    if [ -n "$HOST_NGINX_INTERNAL_DOMAIN" ]; then
      if ! grep -shhq " $HOST_NGINX_INTERNAL_DOMAIN$" "/etc/hosts"; then
        __printf_spacing_color "40" "Adding to /etc/hosts:" "$HOST_NGINX_INTERNAL_DOMAIN $HOST_LISTEN_ADDR"
        __printf_spacing_file "$HOST_LISTEN_ADDR" "$HOST_NGINX_INTERNAL_DOMAIN" | sudo tee -p -a "/etc/hosts" &>/dev/null
      fi
    fi
    if ! grep -shhq " $CONTAINER_HOSTNAME$" "/etc/hosts"; then
      __printf_spacing_color "40" "Adding to /etc/hosts:" "$CONTAINER_HOSTNAME $HOST_LISTEN_ADDR"
      __printf_spacing_file "$HOST_LISTEN_ADDR" "$CONTAINER_HOSTNAME" | sudo tee -p -a "/etc/hosts" &>/dev/null
    fi
    show_hosts_message_banner="true"
    [ "$show_hosts_message_banner" = "true" ] && printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
    unset show_hosts_message_banner
  fi
  __printf_spacing_color "3" "The container name is:" "$CONTAINER_NAME"
  __printf_spacing_color "3" "Containers data is saved in:" "$HOST_ROOTFS_DIR"
  __printf_spacing_color "3" "The container is listening on:" "$HOST_LISTEN_ADDR"
  __printf_spacing_color "3" "The domain name is set to:" "$CONTAINER_DOMAINNAME"
  __printf_spacing_color "3" "The hostname name is set to:" "$CONTAINER_HOSTNAME"
  if [ -n "$HOST_NGINX_INTERNAL_DOMAIN" ]; then
    __printf_spacing_color "3" "The internal name is set to:" "$HOST_NGINX_INTERNAL_DOMAIN"
  fi
  printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  if [ -n "$HOST_SERVER_HEALTH_CHECK_SERVER_NAME" ] && [ "$HOST_SERVER_HEALTH_CHECK_ENABLED" = "yes" ] && [ -n "$HOST_SERVER_HEALTH_CHECK_SERVER_URI" ]; then
    __printf_spacing_color "6" "Setting health check command to:" "dockermgr server_status $HOST_SERVER_HEALTH_CHECK_SERVER_NAME/$HOST_SERVER_HEALTH_CHECK_SERVER_URI"
    __printf_spacing_color "3" "Saving cron job to: /etc/cron.d/${CONTAINER_NAME}_health"
    __printf_spacing_color "3" "server test file saved to" "$cron_file_name"
    echo '*/90 * * * * root dockermgr server_status "'$HOST_SERVER_HEALTH_CHECK_SERVER_NAME/$HOST_SERVER_HEALTH_CHECK_SERVER_URI'" "'$CONTAINER_NAME'" "'$DOCKERMGR_INSTALL_SCRIPT'"' >"/etc/cron.d/${CONTAINER_NAME}_health"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ "$HOST_CRON_ENABLED" = "yes" ] && [ -n "$HOST_CRON_COMMAND" ]; then
    [ -n "$HOST_CRON_USER" ] || HOST_CRON_USER="root"
    [ -n "$HOST_CRON_SCHEDULE" ] || HOST_CRON_SCHEDULE="30 0 * * *"
    __printf_spacing_color "6" "Setting cron user to:" "$HOST_CRON_USER"
    __printf_spacing_color "6" "Setting schedule to:" "$HOST_CRON_SCHEDULE"
    __printf_spacing_color "3" "Saving cron job to: /etc/cron.d/${CONTAINER_NAME}_cron"
    echo "$HOST_CRON_SCHEDULE $HOST_CRON_USER $HOST_CRON_COMMAND >$HOST_CRON_LOG_FILE 2>&1" | sudo tee -p "/etc/cron.d/${CONTAINER_NAME}_cron" &>/dev/null
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if __ssl_certs; then
    mkdir -p "$CONTAINER_SSL_DIR"
    __sudo_exec chmod -f 777 "$CONTAINER_SSL_DIR"
    if __sudo_exec cp -Rf "$HOST_SSL_CA" "$CONTAINER_SSL_CA"; then
      __sudo_exec chmod -Rf 666 "$CONTAINER_SSL_CA"
      __printf_spacing_color "3" "Copied CA Cert to:" "$CONTAINER_SSL_CA"
    fi
    if __sudo_exec cp -Rf "$HOST_SSL_CRT" "$CONTAINER_SSL_CRT"; then
      __sudo_exec chmod -Rf 666 "$CONTAINER_SSL_DIR"
      __printf_spacing_color "3" "Copied certificate to:" "$CONTAINER_SSL_CRT"
    fi
    if __sudo_exec cp -Rf "$HOST_SSL_KEY" "$CONTAINER_SSL_KEY"; then
      __sudo_exec chmod -Rf 666 "$CONTAINER_SSL_DIR"
      __printf_spacing_color "3" "Copied private key to:" "$CONTAINER_SSL_KEY"
    fi
    __sudo_exec chown -Rf "$USER":"$USER" "$CONTAINER_SSL_DIR" &>/dev/null
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ "$DOCKER_CREATE_NET" ]; then
    __printf_spacing_color "5" "Created docker network:" "$HOST_DOCKER_NETWORK"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ "$NGINX_IS_INSTALLED" = "yes" ]; then
    __printf_spacing_color "6" "nginx vhost name:" "$CONTAINER_HOSTNAME"
    __printf_spacing_color "6" "nginx website:" "$NGINX_PROXY_URL"
    if [ -n "$CONTAINER_NGINX_PROXY_URL" ]; then
      __printf_spacing_color "6" "nginx reverse proxy" "$CONTAINER_NGINX_PROXY_URL"
    fi
    if [ -f "$NGINX_CONF_FILE" ]; then
      __printf_spacing_color "6" "nginx config file installed to:" "$NGINX_CONF_FILE"
    fi
    if [ -f "$NGINX_INC_CONFIG" ]; then
      __printf_spacing_color "6" "nginx vhost file installed to:" "$NGINX_INC_CONFIG"
    fi
    if [ -f "$NGINX_VHOST_CONFIG" ]; then
      __printf_spacing_color "6" "nginx custom vhost file installed to:" "$NGINX_VHOST_CONFIG"
    fi
    if [ -n "$NGINX_INTERNAL_IS_SET" ]; then
      __printf_spacing_color "6" "nginx internal vhost file installed to:" "$NGINX_INTERNAL_IS_SET"
    fi
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -n "$SET_PORT" ] && [ -n "$NGINX_PROXY_URL" ]; then
    MESSAGE="true"
    __printf_spacing_color "33" "Server address:" "$NGINX_PROXY_URL"
    if [ -n "$NGINX_VHOST_NAMES" ]; then
      NGINX_VHOST_NAMES="${NGINX_VHOST_NAMES//,/ }"
      for vhost in $NGINX_VHOST_NAMES; do
        __printf_spacing_color "33" "vhost name:" "$vhost"
      done
    fi
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -n "$CONTAINER_USER_ADMIN_HASH_PASS" ]; then
    show_user_footer="true"
    __printf_spacing_color "6" "raw password is:" "$CONTAINER_USER_ADMIN_PASS_RAW"
    if [ "$CONTAINER_USER_ADMIN_PASS_RAW" != "$CONTAINER_USER_ADMIN_HASH_PASS" ]; then
      __printf_spacing_color "6" "hashed password is:" "$CONTAINER_USER_ADMIN_HASH_PASS"
    fi
  fi
  if [ -n "$CONTAINER_USER_NAME" ]; then
    show_user_footer="true"
    __printf_spacing_color "6" "Username is:" "$CONTAINER_USER_NAME"
  fi
  if [ -n "$CONTAINER_USER_PASS" ]; then
    show_user_footer="true"
    __printf_spacing_color "33" "Password is:" "$CONTAINER_USER_PASS"
  fi
  if [ -n "$CONTAINER_API_KEY_NAME" ] && [ -n "$CONTAINER_API_KEY_TOKEN" ]; then
    show_user_footer="true"
    __printf_spacing_color "33" "$CONTAINER_API_KEY_NAME is:" "$CONTAINER_API_KEY_TOKEN"
  fi
  if [ -n "$CONTAINER_SECRET_KEY_NAME" ] && [ -n "$CONTAINER_SECRET_KEY_TOKEN" ]; then
    show_user_footer="true"
    __printf_spacing_color "33" "$CONTAINER_SECRET_KEY_NAME is:" "$CONTAINER_SECRET_KEY_NAME"
  fi
  if [ "$CONTAINER_DATABASE_USER_ROOT" ]; then
    show_user_footer="true"
    __printf_spacing_color "33" "Database root user:" "$CONTAINER_DATABASE_USER_ROOT"
  fi
  if [ "$CONTAINER_DATABASE_PASS_ROOT" ]; then
    show_user_footer="true"
    __printf_spacing_color "33" "Database root password:" "$CONTAINER_DATABASE_PASS_ROOT"
  fi
  if [ "$CONTAINER_DATABASE_USER_NORMAL" ]; then
    show_user_footer="true"
    __printf_spacing_color "33" "Database user:" "$CONTAINER_DATABASE_USER_NORMAL"
  fi
  if [ "$CONTAINER_DATABASE_PASS_NORMAL" ]; then
    show_user_footer="true"
    __printf_spacing_color "33" "Database password:" "$CONTAINER_DATABASE_PASS_NORMAL"
  fi
  [ "$show_user_footer" = "true" ] && printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  if [ "$SHOW_DATABASE_INFO" = "true" ]; then
    __printf_spacing_color "3" "Database is running on:" "$CONTAINER_DATABASE_PROTO"
    if [ -n "$MESSAGE_CONTAINER_DATABASE" ]; then
      __printf_spacing_color "6" "$MESSAGE_CONTAINER_DATABASE"
    fi
    if [ -n "$MESSAGE_COUCHDB" ]; then
      __printf_spacing_color "6" "Database files are saved to:" "$DATABASE_DIR_COUCHDB"
    fi
    if [ -n "$MESSAGE_SQLITE" ]; then
      __printf_spacing_color "6" "Database files are saved to:" "$DATABASE_DIR_SQLITE"
    fi
    if [ -n "$MESSAGE_MARIADB" ]; then
      __printf_spacing_color "6" "Database files are saved to:" "$DATABASE_DIR_MARIADB"
    fi
    if [ -n "$MESSAGE_MONGODB" ]; then
      __printf_spacing_color "6" "Database files are saved to:" "$DATABASE_DIR_MONGODB"
    fi
    if [ -n "$MESSAGE_PGSQL" ]; then
      __printf_spacing_color "6" "Database files are saved to:" "$DATABASE_DIR_POSTGRES"
    fi
    if [ -n "$MESSAGE_REDIS" ]; then
      __printf_spacing_color "6" "Database files are saved to:" "$DATABASE_DIR_REDIS"
    fi
    if [ -n "$MESSAGE_SUPABASE" ]; then
      __printf_spacing_color "6" "Database files are saved to:" "$DATABASE_DIR_SUPABASE"
    fi
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -n "$CONTAINER_DB_ENV_NAME" ] && [ -n "$CONTAINER_DB_ENV_STRING" ]; then
    __printf_spacing_color 130 "$CONTAINER_DB_ENV_NAME:" "$CONTAINER_DB_ENV_STRING"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -f "$HOST_ROOTFS_DIR/config/auth/htpasswd" ]; then
    MESSAGE="true"
    __printf_spacing_color "5" "Username:" "root"
    __printf_spacing_color "5" "Password:" "${SET_USER_PASS:-toor}"
    __printf_spacing_color "5" "htpasswd File:" "/config/auth/htpasswd"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -z "$SET_PORT" ]; then
    if [ -n "$CONTAINER_ADD_CUSTOM_SINGLE" ]; then
      __printf_spacing_color "6" "Custom port mapping:" "$CONTAINER_ADD_CUSTOM_SINGLE"
    else
      intf_spacing_color "3" "This container does not have services configured"
    fi
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  else
    for create_service in $SET_PORT; do
      if [ "$create_service" != "--publish" ] && [ "$create_service" != " " ]; then
        if [ "$set_listen_on_all" = "yes" ]; then
          for custom_port in $set_listen_port; do
            if echo "$custom_port" | grep -q ":[0-9].*:"; then
              set_custom_port="$(echo "$custom_port" | awk -F ':' '{print $3}' | grep '^')"
              set_custom_service="$(echo "$custom_port" | awk -F ':' '{print $2}' | grep '^')"
              if [ -n "$set_custom_port" ] && [ -n "$set_custom_service" ]; then
                __printf_spacing_color "6" "Port $set_custom_service is mapped to:" "$set_custom_port"
              fi
            elif echo "$custom_port" | grep -q "[0-9]:[0-9]"; then
              set_custom_port="$(echo "$custom_port" | awk -F ':' '{print $2}' | grep '^')"
              set_custom_service="$(echo "$custom_port" | awk -F ':' '{print $1}' | grep '^')"
              if [ -n "$set_custom_port" ] && [ -n "$set_custom_service" ]; then
                __printf_spacing_color "6" "Port $set_custom_service is mapped to:" "$set_custom_port"
              fi
            elif echo "$custom_port" | grep -q "[0-9]"; then
              set_custom_port="$(echo "$custom_port" | awk -F ':' '{print $1}' | grep '^')"
              set_custom_service="$(echo "$custom_port" | awk -F ':' '{print $1}' | grep '^')"
              if [ -n "$set_custom_port" ] && [ -n "$set_custom_service" ]; then
                __printf_spacing_color "6" "Port $set_custom_service is mapped to:" "$set_custom_port"
              fi
            fi
            create_service="${create_service//$set_custom_service/}"
            create_service="${create_service//$set_custom_port/} "
            create_service="${create_service//:/}"
          done
        fi
        service="$create_service"
        if [ -n "$service" ] && [ "$service" != " " ]; then
          if echo "$service" | grep -q ":.*.:"; then
            set_host="$(echo "$service" | awk -F ':' '{print $1}')"
            set_port="$(echo "$service" | awk -F ':' '{print $3}')"
            set_service="$(echo "$service" | awk -F ':' '{print $2}')"
          elif [ -n "$service" ] && [ "$service" != " " ]; then
            set_host="$SET_LISTEN"
            set_port="$(echo "$service" | awk -F ':' '{print $1}')"
            set_service="$(echo "$service" | awk -F ':' '{print $2}')"
          fi
          if [ -n "$set_port" ] && [ -n "$set_port" ]; then
            get_servive="$set_service"
            set_service="${set_service//\/*/}"
            listen="${set_host//0.0.0.0/$HOST_LISTEN_ADDR}:$set_port"
            echo "$get_servive" | grep -qE '[0-9]/tcp|[0-9]/udp' && type="${get_servive//*\//}" || unset type
            [ -n "$type" ] && get_listen="$listen/$type" || get_listen="$listen"
            set_listen=$(printf '%s' "$get_listen")
            if [ -n "$listen" ]; then
              __printf_spacing_color "6" "Port $set_service is mapped to:" "$set_listen"
            fi
          fi
        fi
      fi
      unset get_listen type
    done
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -f "$DOCKERMGR_INSTALL_SCRIPT" ]; then
    __printf_spacing_color "3" "Script saved to:" "$DOCKERMGR_INSTALL_SCRIPT"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env.conf" ] || [ -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.custom.conf" ]; then
    if [ -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env.conf" ]; then
      __printf_spacing_color "2" "variables saved to:" "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.env.conf"
    fi
    if [ -f "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.custom.conf" ]; then
      __printf_spacing_color "2" "Container variables saved to:" "$DOCKERMGR_CONFIG_DIR/env/$CONTAINER_NAME.custom.conf"
    fi
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -n "$CONTAINER_DEFAULT_USERNAME" ] || [ -n "$CONTAINER_DEFAULT_PASSWORD" ]; then
    [ -n "$CONTAINER_DEFAULT_USERNAME" ] && __printf_spacing_color "6" "Containers default username is:" "$CONTAINER_DEFAULT_USERNAME"
    [ -n "$CONTAINER_DEFAULT_PASSWORD" ] && __printf_spacing_color "6" "Containers default password is:" "$CONTAINER_DEFAULT_PASSWORD"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  if [ -n "$POST_SHOW_FINISHED_MESSAGE" ]; then
    __printf_color "2" "$POST_SHOW_FINISHED_MESSAGE"
    printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n'
  fi
  __printf_color "6" "$APPNAME has been installed to: $APPDIR"
  printf '# - - - - - - - - - - - - - - - - - - - - - - - - - -\n\n'
  __show_post_message
else
  __printf_color "6" "The container $CONTAINER_NAME seems to have failed"
  if [ "$ERROR_LOG" = "true" ]; then
    __printf_color "3" "Errors logged to:" "${TMP:-/tmp}/$APPNAME.err.log"
    [ -f "$DOCKERMGR_INSTALL_SCRIPT" ] && mv -f "$DOCKERMGR_INSTALL_SCRIPT" "${DOCKERMGR_INSTALL_SCRIPT//.sh/.$$.bak.sh}"
    [ -f "${DOCKERMGR_INSTALL_SCRIPT//.sh/.$$.bak.sh}" ] && printf_yellow "Script moved to: ${DOCKERMGR_INSTALL_SCRIPT//.sh/.$$.bak.sh}"
  else
    printf_red "Something seems to have gone wrong with the install"
  fi
  if [ -f "$DOCKERMGR_INSTALL_SCRIPT" ]; then
    __printf_color "3" "Script: $DOCKERMGR_INSTALL_SCRIPT"
  fi
  exit 10
fi
if [ "$USER" != "root" ] && [ -n "$USER" ]; then
  __sudo_exec chown -f "$USER":"$USER" "$DATADIR" "$INSTDIR" &>/dev/null
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if __check_ssl_cert; then __printf_color "5" "Creating certificate for $CONTAINER_HOSTNAME" && __create_cert; fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_uninstall
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
run_postinst() {
  dockermgr_run_post
  run_post_install &>/dev/null
}
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
execute "run_postinst" "Running post install scripts" 1>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Output post install message
run_post_custom
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
exit ${EXIT:-${exitCode:-0}}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ex: ts=2 sw=2 et filetype=sh
