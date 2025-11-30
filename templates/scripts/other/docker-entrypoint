#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202511301726-git
# @@Author           :  GEN_SCRIPT_REPLACE_AUTHOR
# @@Contact          :  GEN_SCRIPT_REPLACE_EMAIL
# @@License          :  GEN_SCRIPT_REPLACE_LICENSE
# @@ReadME           :  entrypoint.sh --help
# @@Copyright        :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @@Created          :  GEN_SCRIPT_REPLACE_DATE
# @@File             :  entrypoint.sh
# @@Description      :  Entrypoint file for GEN_SCRIPT_REPLACE_APPNAME
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  GEN_SCRIPT_REPLACE_TODO
# @@Other            :  GEN_SCRIPT_REPLACE_OTHER
# @@Resource         :  GEN_SCRIPT_REPLACE_RES
# @@Terminal App     :  GEN_SCRIPT_REPLACE_TERMINAL
# @@sudo/root        :  GEN_SCRIPT_REPLACE_SUDO
# @@Template         :  other/docker-entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
# run trap command on exit
trap '__trap_exit_handler' EXIT
trap '__trap_signal_handler' INT TERM PWR
# - - - - - - - - - - - - - - - - - - - - - - - - -
__trap_exit_handler() {
  local retVal=$?
  if [ "$SERVICE_IS_RUNNING" != "yes" ] && [ -f "$SERVICE_PID_FILE" ]; then
    rm -Rf "$SERVICE_PID_FILE" 2>/dev/null || true
  fi
  exit $retVal
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__trap_signal_handler() {
  local retVal=$?
  echo "Container received shutdown signal"
  if [ "$SERVICE_IS_RUNNING" != "yes" ] && [ -f "$SERVICE_PID_FILE" ]; then
    rm -Rf "$SERVICE_PID_FILE" 2>/dev/null || true
  fi
  exit $retVal
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# setup debugging - https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
if [ -f "/config/.debug" ] && [ -z "$DEBUGGER_OPTIONS" ]; then
  export DEBUGGER_OPTIONS="$(<"/config/.debug")"
else
  DEBUGGER_OPTIONS="${DEBUGGER_OPTIONS:-}"
fi
if [ "$DEBUGGER" = "on" ] || [ -f "/config/.debug" ]; then
  echo "Enabling debugging"
  set -o pipefail -x$DEBUGGER_OPTIONS
  export DEBUGGER="on"
else
  set -o pipefail
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
PATH="/usr/local/etc/docker/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
SCRIPT_FILE="$0"
CONTAINER_NAME="GEN_SCRIPT_REPLACE_APPNAME"
SCRIPT_NAME="$(basename -- "$SCRIPT_FILE" 2>/dev/null)"
CONTAINER_NAME="${ENV_CONTAINER_NAME:-$CONTAINER_NAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# remove whitespaces from beginning argument
while :; do
  if [ "$1" = " " ]; then
    shift 1
  else
    break
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$1" = "$SCRIPT_FILE" ] && shift 1
[ "$1" = "$SCRIPT_NAME" ] && shift 1
# - - - - - - - - - - - - - - - - - - - - - - - - -
# import the functions file
if [ -f "/usr/local/etc/docker/functions/entrypoint.sh" ]; then
  . "/usr/local/etc/docker/functions/entrypoint.sh"
else
  echo "Can not load functions from /usr/local/etc/docker/functions/entrypoint.sh"
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
case "$1" in
# Help message
-h | --help)
  shift 1
  echo 'Docker container for '$CONTAINER_NAME''
  echo "Usage: $CONTAINER_NAME [help tail cron exec start init shell certbot ssl procs ports healthcheck backup command]"
  echo ""
  exit 0
  ;;
-*)
  shift
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Create the default env files
__create_env_file "/config/env/default.sh" "/root/env.sh" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - -
# import variables from files
for set_env in "/root/env.sh" "/usr/local/etc/docker/env"/*.sh "/config/env"/*.sh; do
  [ -f "$set_env" ] && . "$set_env"
done
unset set_env
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User to use to launch service - IE: postgres
# normally root
RUNAS_USER="root"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set user and group from env
SERVICE_USER="${PUID:-$SERVICE_USER}"
SERVICE_GROUP="${PGID:-$SERVICE_GROUP}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Set user and group ID
# set the user id
SERVICE_UID="${SERVICE_UID:-0}"
# set the group id
SERVICE_GID="${SERVICE_GID:-0}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# User and group in which the service switches to - IE: nginx,apache,mysql,postgres
#SERVICE_USER="${SERVICE_USER:-GEN_SCRIPT_REPLACE_APPNAME}"   # execute command as another user
#SERVICE_GROUP="${SERVICE_GROUP:-GEN_SCRIPT_REPLACE_APPNAME}" # Set the service group
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Secondary ports
# specifiy other ports
SERVER_PORTS=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Primary server port- will be added to server ports
# port : 80,443
WEB_SERVER_PORT=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Healthcheck variables
# enable healthcheck [yes/no]
HEALTH_ENABLED="yes"
# comma separated list of processes for the healthcheck
SERVICES_LIST="tini"
# url endpoints: [http://localhost/health,http://localhost/test]
HEALTH_ENDPOINTS=""
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Update path var
export PATH RUNAS_USER SERVICE_USER SERVICE_GROUP SERVICE_UID SERVICE_GID WWW_ROOT_DIR DATABASE_DIR
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Custom variables

# - - - - - - - - - - - - - - - - - - - - - - - - -
# show message
__run_message() {

  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
################## END OF CONFIGURATION #####################
# Lets get containers ip address
IP4_ADDRESS="$(__get_ip4)"
IP6_ADDRESS="$(__get_ip6)"
CONTAINER_IP4_ADDRESS="${CONTAINER_IP4_ADDRESS:-$IP4_ADDRESS}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Startup variables
export INIT_DATE="${INIT_DATE:-$(date)}"
export CONTAINER_INIT="${CONTAINER_INIT:-no}"
export START_SERVICES="${START_SERVICES:-no}"
export ENTRYPOINT_MESSAGE="${ENTRYPOINT_MESSAGE:-yes}"
export ENTRYPOINT_FIRST_RUN="${ENTRYPOINT_FIRST_RUN:-yes}"
export DATA_DIR_INITIALIZED="${DATA_DIR_INITIALIZED:-no}"
export CONFIG_DIR_INITIALIZED="${CONFIG_DIR_INITIALIZED:-no}"
export CONTAINER_NAME="${ENV_CONTAINER_NAME:-$CONTAINER_NAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# System
export LANG="${LANG:-C.UTF-8}"
export LC_ALL="${LANG:-C.UTF-8}"
export TZ="${TZ:-${TIMEZONE:-America/New_York}}"
export HOSTNAME="$(hostname -s)"
export DOMAINNAME="$(hostname -d)"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Default directories
export SSL_DIR="${SSL_DIR:-/config/ssl}"
export SSL_CA="${SSL_CERT:-/config/ssl/ca.crt}"
export SSL_KEY="${SSL_KEY:-/config/ssl/localhost.pem}"
export SSL_CERT="${SSL_CERT:-/config/ssl/localhost.crt}"
export LOCAL_BIN_DIR="${LOCAL_BIN_DIR:-/usr/local/bin}"
export DEFAULT_DATA_DIR="${DEFAULT_DATA_DIR:-/usr/local/share/template-files/data}"
export DEFAULT_CONF_DIR="${DEFAULT_CONF_DIR:-/usr/local/share/template-files/config}"
export DEFAULT_TEMPLATE_DIR="${DEFAULT_TEMPLATE_DIR:-/usr/local/share/template-files/defaults}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Backup settings
export BACKUP_MAX_DAYS="${BACKUP_MAX_DAYS:-}"
export BACKUP_RUN_CRON="${BACKUP_RUN_CRON:-}"
export BACKUP_DIR="${BACKUP_DIR:-/data/backups}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional
export PHP_INI_DIR="${PHP_INI_DIR:-$(__find_php_ini)}"
export PHP_BIN_DIR="${PHP_BIN_DIR:-$(__find_php_bin)}"
export HTTPD_CONFIG_FILE="${HTTPD_CONFIG_FILE:-$(__find_httpd_conf)}"
export NGINX_CONFIG_FILE="${NGINX_CONFIG_FILE:-$(__find_nginx_conf)}"
export MYSQL_CONFIG_FILE="${MYSQL_CONFIG_FILE:-$(__find_mysql_conf)}"
export PGSQL_CONFIG_FILE="${PGSQL_CONFIG_FILE:-$(__find_pgsql_conf)}"
export MONGODB_CONFIG_FILE="${MONGODB_CONFIG_FILE:-$(__find_mongodb_conf)}"
export ENTRYPOINT_PID_FILE="${ENTRYPOINT_PID_FILE:-$ENTRYPOINT_PID_FILE}"
export ENTRYPOINT_INIT_FILE="${ENTRYPOINT_INIT_FILE:-/config/.entrypoint.done}"
export ENTRYPOINT_DATA_INIT_FILE="${ENTRYPOINT_DATA_INIT_FILE:-/data/.docker_has_run}"
export ENTRYPOINT_CONFIG_INIT_FILE="${ENTRYPOINT_CONFIG_INIT_FILE:-/config/.docker_has_run}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONTAINER_WEB_SERVER_WWW_REPO" ]; then
  www_temp_dir="/tmp/git/$(basename -- "$CONTAINER_WEB_SERVER_WWW_REPO")"
  rm -Rf "${WWW_ROOT_DIR:?}"/* "${www_temp_dir:?}"/* 2>/dev/null || true
  mkdir -p "$WWW_ROOT_DIR" "$www_temp_dir" 2>/dev/null || true
  git clone -q "$CONTAINER_WEB_SERVER_WWW_REPO" "$www_temp_dir" 2>/dev/null || true
  rm -Rf "$www_temp_dir/.git" "$www_temp_dir"/.git* 2>/dev/null || true
  rsync -ra "$www_temp_dir/" "$WWW_ROOT_DIR" --delete 2>/dev/null || true
  rm -Rf "$www_temp_dir" 2>/dev/null || true
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# variables based on env/files
if [ -f "/config/enable/ssl" ]; then SSL_ENABLED="yes"; fi
if [ -f "/config/enable/ssh" ]; then SSH_ENABLED="yes"; fi
if [ "$WEB_SERVER_PORT" = "443" ]; then SSL_ENABLED="yes"; fi
if [ "$CONTAINER_WEB_SERVER_PROTOCOL" = "https" ]; then SSL_ENABLED="yes"; fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# export variables

# - - - - - - - - - - - - - - - - - - - - - - - - -
# is already Initialized
if [ -f "$ENTRYPOINT_DATA_INIT_FILE" ]; then
  DATA_DIR_INITIALIZED="yes"
else
  DATA_DIR_INITIALIZED="no"
fi
if [ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ]; then
  CONFIG_DIR_INITIALIZED="yes"
else
  CONFIG_DIR_INITIALIZED="no"
fi
if [ -f "$ENTRYPOINT_PID_FILE" ] || [ -f "$ENTRYPOINT_INIT_FILE" ]; then
  ENTRYPOINT_FIRST_RUN="no"
else
  ENTRYPOINT_FIRST_RUN="yes"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# clean ENV_PORTS variables
ENV_PORTS="${ENV_PORTS//,/ }"  #
ENV_PORTS="${ENV_PORTS//\/*/}" #
# - - - - - - - - - - - - - - - - - - - - - - - - -
# clean SERVER_PORTS variables
SERVER_PORTS="${SERVER_PORTS//,/ }"  #
SERVER_PORTS="${SERVER_PORTS//\/*/}" #
# - - - - - - - - - - - - - - - - - - - - - - - - -
# clean WEB_SERVER_PORTS variables
WEB_SERVER_PORTS="${WEB_SERVER_PORT//\/*/}"                             #
WEB_SERVER_PORTS="${WEB_SERVER_PORTS//\/*/}"                            #
WEB_SERVER_PORTS="${WEB_SERVER_PORT//,/ } ${ENV_WEB_SERVER_PORTS//,/ }" #
# - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite and merge variables
ENV_PORTS="$(__format_variables "$ENV_PORTS" || false)"
WEB_SERVER_PORTS="$(__format_variables "$WEB_SERVER_PORTS" || false)"
ENV_PORTS="$(__format_variables "$SERVER_PORTS" "$WEB_SERVER_PORTS" "$ENV_PORTS" "$SERVER_PORTS" || false)"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Remove the commas from env
HEALTH_ENDPOINTS="${HEALTH_ENDPOINTS//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# create required directories
mkdir -p "/run" 2>/dev/null || true
mkdir -p "/tmp" 2>/dev/null || true
mkdir -p "/root" 2>/dev/null || true
mkdir -p "/var/run" 2>/dev/null || true
mkdir -p "/var/tmp" 2>/dev/null || true
mkdir -p "/run/cron" 2>/dev/null || true
mkdir -p "/data/logs" 2>/dev/null || true
mkdir -p "/run/init.d" 2>/dev/null || true
mkdir -p "/config/enable" 2>/dev/null || true
mkdir -p "/config/secure" 2>/dev/null || true
mkdir -p "/usr/local/etc/docker/exec" 2>/dev/null || true
# - - - - - - - - - - - - - - - - - - - - - - - - -
# create required files
touch "/data/logs/start.log" 2>/dev/null || true
touch "/data/logs/entrypoint.log" 2>/dev/null || true
# - - - - - - - - - - - - - - - - - - - - - - - - -
# fix permissions
chmod -f 777 "/run" 2>/dev/null || true
chmod -f 777 "/tmp" 2>/dev/null || true
chmod -f 700 "/root" 2>/dev/null || true
chmod -f 777 "/var/run" 2>/dev/null || true
chmod -f 777 "/var/tmp" 2>/dev/null || true
chmod -f 777 "/run/cron" 2>/dev/null || true
chmod -f 777 "/data/logs" 2>/dev/null || true
chmod -f 777 "/run/init.d" 2>/dev/null || true
chmod -f 777 "/config/enable" 2>/dev/null || true
chmod -f 777 "/config/secure" 2>/dev/null || true
chmod -f 777 "/data/logs/entrypoint.log" 2>/dev/null || true
chmod -f 777 "/usr/local/etc/docker/exec" 2>/dev/null || true
# - - - - - - - - - - - - - - - - - - - - - - - - -
# lets ensure everyone can write to std*
if [ -f "/dev/stdin" ]; then
  chmod -f 777 "/dev/stdin" 2>/dev/null || true
fi
if [ -f "/dev/stderr" ]; then
  chmod -f 777 "/dev/stderr" 2>/dev/null || true
fi
if [ -f "/dev/stdout" ]; then
  chmod -f 777 "/dev/stdout" 2>/dev/null || true
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
cat <<EOF 2>/dev/null | tee /etc/profile.d/locales.shadow /etc/profile.d/locales.sh >/dev/null 2>&1 || true
export LANG="\${LANG:-C.UTF-8}"
export LC_ALL="\${LANG:-C.UTF-8}"
export TZ="\${TZ:-\${TIMEZONE:-America/New_York}}"
EOF
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Create the backup dir
if [ -n "$BACKUP_DIR" ]; then
  if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR" 2>/dev/null || true
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_INIT_FILE" ]; then
  ENTRYPOINT_MESSAGE="no" ENTRYPOINT_FIRST_RUN="no"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$ENTRYPOINT_FIRST_RUN" != "no" ]; then
  if [ "$CONFIG_DIR_INITIALIZED" = "no" ] || [ "$DATA_DIR_INITIALIZED" = "no" ]; then
    if [ "$ENTRYPOINT_MESSAGE" = "yes" ]; then
      echo "Executing entrypoint script for GEN_SCRIPT_REPLACE_APPNAME"
    fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # Set reusable variables
  if [ -w "/etc" ] && [ ! -f "/etc/hosts" ]; then
    UPDATE_FILE_HOSTS="yes"
    touch "/etc/hosts"
  elif [ -w "/etc/hosts" ]; then
    UPDATE_FILE_HOSTS="yes"
    touch "/etc/hosts"
  fi
  if [ -w "/etc" ] && [ ! -f "/etc/timezone" ]; then
    UPDATE_FILE_TZ="yes"
    touch "/etc/timezone"
  elif [ -w "/etc/timezone" ]; then
    UPDATE_FILE_TZ="yes"
    touch "/etc/timezone"
  fi
  if [ -w "/etc" ] && [ ! -f "/etc/resolv.conf" ]; then
    UPDATE_FILE_RESOLV="yes"
    touch "/etc/resolv.conf"
  elif [ -w "/etc/resolv.conf" ]; then
    UPDATE_FILE_RESOLV="yes"
    touch "/etc/resolv.conf"
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # Set timezone
  if [ -n "$TZ" ] && [ "$UPDATE_FILE_TZ" = "yes" ]; then
    echo "$TZ" >"/etc/timezone" 2>/dev/null || true
  fi
  if [ -f "/usr/share/zoneinfo/$TZ" ] && [ "$UPDATE_FILE_TZ" = "yes" ]; then
    ln -sf "/usr/share/zoneinfo/$TZ" "/etc/localtime" 2>/dev/null || true
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # if ipv6 add it to /etc/hosts
  if [ "$UPDATE_FILE_HOSTS" = "yes" ]; then
    echo "# known hostname mappings" >"/etc/hosts" 2>/dev/null || true
    if [ -n "$(ip a 2>/dev/null | grep 'inet6.*::' || ifconfig 2>/dev/null | grep 'inet6.*::')" ]; then
      __printf_space "40" "::1" "localhost" >>"/etc/hosts" 2>/dev/null || true
      __printf_space "40" "127.0.0.1" "localhost" >>"/etc/hosts" 2>/dev/null || true
    else
      __printf_space "40" "127.0.0.1" "localhost" >>"/etc/hosts" 2>/dev/null || true
    fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # add .internal domain
  if [ "$UPDATE_FILE_HOSTS" = "yes" ] && [ -n "$HOSTNAME" ]; then
    if ! __grep_test " $HOSTNAME" "/etc/hosts"; then
      __printf_space "40" "${CONTAINER_IP4_ADDRESS:-127.0.0.1}" "$HOSTNAME" >>"/etc/hosts" 2>/dev/null || true
    fi
    if ! __grep_test " ${HOSTNAME%%.*}.internal" "/etc/hosts"; then
      __printf_space "40" "${CONTAINER_IP4_ADDRESS:-127.0.0.1}" "${HOSTNAME%%.*}.internal" >>"/etc/hosts" 2>/dev/null || true
    fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # add domainname
  if [ "$UPDATE_FILE_HOSTS" = "yes" ] && [ "$DOMAINNAME" != "internal" ] && [ -n "$DOMAINNAME" ] && [ "$HOSTNAME.$DOMAINNAME" != "$DOMAINNAME" ]; then
    if ! __grep_test " ${HOSTNAME%%.*}.$DOMAINNAME" "/etc/hosts"; then
      __printf_space "40" "${CONTAINER_IP4_ADDRESS:-127.0.0.1}" "${HOSTNAME%%.*}.$DOMAINNAME" >>"/etc/hosts" 2>/dev/null || true
    fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # Set containers hostname
  if [ -n "$HOSTNAME" ] && [ "$UPDATE_FILE_HOSTS" = "yes" ]; then
    echo "$HOSTNAME" >"/etc/hostname" 2>/dev/null || true
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  if [ -f "/etc/hostname" ]; then
    if [ -n "$(type -P hostname 2>/dev/null)" ]; then
      hostname -F "/etc/hostname" 2>/dev/null || true
    else
      HOSTNAME="$(<"/etc/hostname")" 2>/dev/null || true
    fi
    export HOSTNAME
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # import hosts file into container
  if [ -f "/usr/local/etc/hosts" ] && [ "$UPDATE_FILE_HOSTS" = "yes" ]; then
    cat "/usr/local/etc/hosts" 2>/dev/null | grep -vF "$HOSTNAME" >>"/etc/hosts" 2>/dev/null || true
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # import resolv.conf file into container
  if [ "$CUSTOM_DNS" != "yes" ] && [ -f "/usr/local/etc/resolv.conf" ] && [ "$UPDATE_FILE_RESOLV" = "yes" ]; then
    cat "/usr/local/etc/resolv.conf" >"/etc/resolv.conf" 2>/dev/null || true
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  if [ -n "$HOME" ] && [ -d "/usr/local/etc/skel" ]; then
    if [ -d "$HOME" ]; then
      cp -Rf "/usr/local/etc/skel/." "$HOME/" 2>/dev/null || true
    fi
  fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete any .gitkeep files
if [ -d "/data" ]; then
  rm -Rf "/data/.gitkeep" "/data"/*/*.gitkeep 2>/dev/null || true
fi
if [ -d "/config" ]; then
  rm -Rf "/config/.gitkeep" "/config"/*/*.gitkeep 2>/dev/null || true
fi
if [ -f "/usr/local/bin/.gitkeep" ]; then
  rm -Rf "/usr/local/bin/.gitkeep" 2>/dev/null || true
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup bin directory - /config/bin > /usr/local/bin
__initialize_custom_bin_dir
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy default system configs - /usr/local/share/template-files/defaults > /config/
__initialize_default_templates
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy custom config files - /usr/local/share/template-files/config > /config/
__initialize_config_dir
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy custom data files - /usr/local/share/template-files/data > /data/
__initialize_data_dir
# - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_ssl_certs
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_INIT_FILE" ]; then
  ENTRYPOINT_FIRST_RUN="no"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -d "/config" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_INIT_FILE" 2>/dev/null || true
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if this is a new container
if [ -f "$ENTRYPOINT_DATA_INIT_FILE" ]; then
  DATA_DIR_INITIALIZED="yes"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -d "/data" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_DATA_INIT_FILE" 2>/dev/null || true
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ]; then
  CONFIG_DIR_INITIALIZED="yes"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -d "/config" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_CONFIG_INIT_FILE" 2>/dev/null || true
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$ENTRYPOINT_FIRST_RUN" != "no" ]; then
  # setup the smtp server
  __setup_mta
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# if no pid assume container restart - clean stale files on restart
if [ -f "$ENTRYPOINT_PID_FILE" ]; then
  START_SERVICES="no"
  touch "$ENTRYPOINT_PID_FILE"
else
  START_SERVICES=yes
  # Clean any stale PID files on first run
  rm -f /run/__start_init_scripts.pid /run/init.d/*.pid /run/*.pid 2>/dev/null || true
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$ENTRYPOINT_MESSAGE" = "yes" ]; then
  __printf_space "40" "The containers ip address is:" "$CONTAINER_IP4_ADDRESS"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Show configured listing processes
if [ "$ENTRYPOINT_MESSAGE" = "yes" ] && [ -n "$ENV_PORTS" ]; then
  show_port=""
  for port in $ENV_PORTS; do
    if [ -n "$port" ]; then
      show_port+="$(printf '%s ' "${port// /}") "
    fi
  done
  __printf_space "40" "The following ports are open:" "$show_port"
  unset port show_port
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# execute init script
if [ -f "/tmp/init" ]; then sh "/tmp/init"; fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
# create user if needed
__create_service_user "$SERVICE_USER" "$SERVICE_GROUP" "${WORK_DIR:-/home/$SERVICE_USER}" "${SERVICE_UID:-}" "${SERVICE_GID:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Modify user if needed
__set_user_group_id $SERVICE_USER ${SERVICE_UID:-} ${SERVICE_GID:-}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Show message
__run_message
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Just start services
START_SERVICES="${START_SERVICES:-SYSTEM_INIT}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Determine if we should start services based on command
# Only skip service start for the 'init' command
SKIP_SERVICE_START="no"
[ "$1" = "init" ] && SKIP_SERVICE_START="yes" && CONTAINER_INIT="yes"
[ "$2" = "init" ] && SKIP_SERVICE_START="yes" && CONTAINER_INIT="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Start all services if no pidfile and not skipping
if [ "$START_SERVICES" = "yes" ] || [ -z "$1" ]; then
  if [ "$SKIP_SERVICE_START" = "no" ]; then
    [ "$1" = "start" ] && shift 1
    [ "$1" = "all" ] && shift 1
    rm -Rf "/run"/*/*pid 2>/dev/null || true
    echo "$$" >"$ENTRYPOINT_PID_FILE"
    __start_init_scripts "/usr/local/etc/docker/init.d"
    CONTAINER_INIT="${CONTAINER_INIT:-no}"
  fi
  START_SERVICES="no"
fi
export START_SERVICES CONTAINER_INIT ENTRYPOINT_PID_FILE
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Begin options
case "$1" in
init)
  shift 1
  echo "Container has been Initialized"
  exit 0
  ;;
tail)
  shift 1
  case "$1" in
  null)
    shift $#
    tail -F "/dev/null"
    ;;
  app)
    shift $#
    tail -F /data/logs/*/*.log
    ;;
  -*)
    tail "$@"
    ;;
  *)
    tail -F "${@:-/dev/null}"
    ;;
  esac
  ;;
logs)
  shift 1
  case "$1" in
  follow)
    tail -Fq /data/logs/*/*
    ;;
  clean)
    log_files="$(find "/data/logs" -type f)"
    for log in "${log_files[@]}"; do
      echo "clearing $log"
      printf '' >$log
    done
    ;;
  *)
    echo "Usage: logs [follow,clean]"
    exit 0
    ;;
  esac
  ;;
cron)
  shift 1
  __cron "$@" &
  echo "cron script is running with pid: $!"
  exit
  ;;
# backup data and config dirs
backup)
  shift 1
  __backup $BACKUP_MAX_DAYS $1
  exit $?
  ;;
# Docker healthcheck
healthcheck)
  shift 1
  case "$1" in
  init | test)
    exit 0
    ;;
  *)
    arguments="$*"
    healthStatus=0
    healthEnabled="${HEALTH_ENABLED:-}"
    healthPorts="${WEB_SERVER_PORTS:-}"
    healthEndPoints="${HEALTH_ENDPOINTS:-}"
    SERVICES_LIST="${arguments:-$SERVICES_LIST}"
    services="$(echo "${SERVICES_LIST//,/ }")"
    healthMessage="Everything seems to be running"
    [ "$healthEnabled" = "yes" ] || exit 0
    if [ -d "/run/healthcheck" ] && [ "$(ls -A "/run/healthcheck" | wc -l)" -ne 0 ]; then
      for service in /run/healthcheck/*; do
        name=$(basename -- $service)
        services+="$name "
      done
    fi
    services="$(echo "$services" | tr ' ' '\n' | sort -u | grep -v '^$')"
    for proc in $services; do
      if [ -n "$proc" ]; then
        if ! __pgrep "$proc"; then
          echo "$proc is not running" >&2
          healthStatus=$((healthStatus + 1))
        fi
      fi
    done
    for port in $ports; do
      if [ -n "$(type -P netstat)" ] && [ -n "$port" ]; then
        if ! netstat -taupln | grep -q ":$port "; then
          echo "$port isn't open" >&2
          healthStatus=$((healthStatus + 1))
        fi
      fi
    done
    for endpoint in $healthEndPoints; do
      if [ -n "$endpoint" ]; then
        if ! __curl "$endpoint"; then
          echo "Can not connect to $endpoint" >&2
          healthStatus=$((healthStatus + 1))
        fi
      fi
    done
    [ "$healthStatus" -eq 0 ] || healthMessage="Errors reported see: docker logs --follow $CONTAINER_NAME"
    [ -n "$healthMessage" ] && echo "$healthMessage"
    exit $healthStatus
    ;;
  esac
  ;;
  # show open ports
ports)
  shift 1
  ports="$(__netstat -taupln | awk -F ' ' '{print $4}' | awk -F ':' '{print $2}' | sort --unique --version-sort | grep -v '^$' | grep '^' || echo '')"
  [ -n "$ports" ] && printf '%s\n%s\n' "The following are servers:" "$ports" | tr '\n' ' '
  exit $?
  ;;
  # show running processes
procs)
  shift 1
  ps="$(__ps axco command | grep -vE 'COMMAND|grep|ps' | sort -u || grep '^' || echo '')"
  [ -n "$ps" ] && printf '%s\n%s\n' "Found the following processes" "$ps" | tr '\n' ' '
  exit $?
  ;;
  # setup ssl
ssl)
  shift 1
  __create_ssl_cert
  exit $?
  ;;
# manage ssl certificate
certbot)
  shift 1
  CERT_BOT_ENABLED="yes"
  if [ "$1" = "create" ]; then
    shift 1
    __certbot "create"
  elif [ "$1" = "renew" ]; then
    shift 1
    __certbot "renew certonly --force-renew"
  else
    __exec_command "certbot" "$@"
  fi
  exit $?
  ;;
# Launch shell
*/bin/sh | */bin/bash | bash | sh | shell)
  shift 1
  __exec_command "${@:-/bin/bash -l}"
  exit $?
  ;;
# execute commands
exec)
  shift 1
  __exec_command "${@:-echo "No commands given"}"
  exit $?
  ;;
# show/start init scripts
start)
  shift 1
  export PATH="/usr/local/etc/docker/init.d:$PATH"
  if [ $# -eq 0 ]; then
    scripts="$(ls -A "/usr/local/etc/docker/init.d")"
    if [ -n "$scripts" ]; then
      echo "$scripts"
    else
      echo "No scripts found in: /usr/local/etc/docker/init.d"
    fi
    exit
  elif [ "$1" = "all" ]; then
    shift $#
    if [ "$START_SERVICES" = "yes" ]; then
      echo "$$" >"$ENTRYPOINT_PID_FILE"
      __start_init_scripts "/usr/local/etc/docker/init.d"
      __no_exit
    elif [ -f "/usr/local/etc/docker/init.d/$1" ]; then
      eval "/usr/local/etc/docker/init.d/$1" &
      __no_exit
    fi
  fi
  ;;
# Execute primary command
*)
  if [ $# -eq 0 ]; then
    if [ ! -f "$ENTRYPOINT_PID_FILE" ]; then
      echo "$$" >"$ENTRYPOINT_PID_FILE"
      if [ "$START_SERVICES" = "no" ] && [ "$CONTAINER_INIT" = "yes" ]; then
        :
      else
        __start_init_scripts "/usr/local/etc/docker/init.d"
      fi
    fi
    __no_exit
  else
    __exec_command "$@"
  fi
  exit $?
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - -
# end of entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - -

# ex: ts=2 sw=2 et filetype=sh
