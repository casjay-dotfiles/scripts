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
# @@Description      :  entrypoint point for GEN_SCRIPT_REPLACE_APPNAME
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  GEN_SCRIPT_REPLACE_TODO
# @@Other            :  GEN_SCRIPT_REPLACE_OTHER
# @@Resource         :  GEN_SCRIPT_REPLACE_RES
# @@Terminal App     :  GEN_SCRIPT_REPLACE_TERMINAL
# @@sudo/root        :  GEN_SCRIPT_REPLACE_SUDO
# @@Template         :  other/docker-entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -o pipefail -x$DEBUGGER_OPTIONS || set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# remove whitespaces from beginning argument
while :; do [ "$1" = " " ] && shift 1 || break; done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import the functions file
if [ -f "/usr/local/etc/docker/functions/entrypoint.sh" ]; then
  . "/usr/local/etc/docker/functions/entrypoint.sh"
else
  echo "Can not load functions from /usr/local/etc/docker/functions/entrypoint.sh"
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create the default env file and import it
[ ! -f "/root/env.sh" ] && [ -f "/usr/local/etc/docker/env/default.sample" ] &&
  mv -f "/usr/local/etc/docker/env/default.sample" "/root/env.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import variables from files
for set_env in "/root/env.sh" "/usr/local/etc/docker/env"/*.sh "/config/env"/*.sh; do
  [ -f "$set_env" ] && . "$set_env"
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define script variables
SERVICE_USER="root" PHP_INI_DIR="$(__find_php_ini)"
PHP_BIN_DIR="$(__find_php_bin)"
# execute command as another user
SERVICE_UID="0"       # set the user id for creation of user
SERVICE_PORT=""       # specifiy port which service is listening on
SERVICES_LIST="tini " # comma seperated list of processes for the healthcheck
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Healthcheck variables
HEALTH_ENABLED="${HEALTH_ENABLED:-}"     #
SERVICES_LIST="${SERVICES_LIST:-}"       #
WEB_SERVER_PORTS="${WEB_SERVER_PORTS:-}" # ports : 80 443
HEALTH_ENDPOINTS="${HEALTH_ENDPOINTS:-}" # url endpoints: http://localhost/test
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional
PHP_INI_DIR="$(__find_php_ini)"
PHP_BIN_DIR="$(__find_php_bin)"
HTTPD_CONFIG_FILE="$(__find_httpd_conf)"
NGINX_CONFIG_FILE="$(__find_nginx_conf)"
MYSQL_CONFIG_FILE="$(__find_mysql_conf)"
PGSQL_CONFIG_FILE="$(__find_pgsql_conf)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Overwrite variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Last thing to run before options
__run_pre() {
  if [ "$ENTRYPOINT_FIRST_RUN" = "false" ]; then # Run on initial creation
    true
  fi
  if [ "$CONFIG_DIR_INITIALIZED" = "false" ]; then # Initial config
    true
  fi
  if [ "$DATA_DIR_INITIALIZED" = "false" ]; then
    true
  fi
  # End Initial config
  if [ "$START_SERVICES" = "yes" ]; then # only run on start
    true
  fi # end run on start
  # Run everytime container starts
  # __certbot
  # __create_ssl_cert
  # __init_apache
  # __init_nginx
  # __init_php
  # __init_mysql
  # __init_mongodb
  # __init_postgres
  # __init_couchdb
  # __setup_ssl
  # end
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_message() {
  if [ "$ENTRYPOINT_MESSAGE" = "yes" ]; then
    echo "Container ip address is: $CONTAINER_IP4_ADDRESS"

  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export variables
export PHP_INI_DIR PHP_BIN_DIR HTTPD_CONFIG_FILE
export NGINX_CONFIG_FILE MYSQL_CONFIG_FILE PGSQL_CONFIG_FILE
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default directories
export BACKUP_DIR="${BACKUP_DIR:-/data/backups}"
export WWW_ROOT_DIR="${WWW_ROOT_DIR:-/data/htdocs}"
export LOCAL_BIN_DIR="${LOCAL_BIN_DIR:-/usr/local/bin}"
export DEFAULT_DATA_DIR="${DEFAULT_DATA_DIR:-/usr/local/share/template-files/data}"
export DEFAULT_CONF_DIR="${DEFAULT_CONF_DIR:-/usr/local/share/template-files/config}"
export DEFAULT_TEMPLATE_DIR="${DEFAULT_TEMPLATE_DIR:-/usr/local/share/template-files/defaults}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create the backup dir
[ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ] || mkdir -p "$BACKUP_DIR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create required directories
mkdir -p "/run/init.d"
mkdir -p "/config/secure"
mkdir -p "/run" && chmod -f 777 "/run" "/run/init.d"
mkdir -p "/tmp" && chmod -f 755 "/tmp"
mkdir -p "/root" && chmod -f 700 "/root"
[ -f "/config/.enable_ssh" ] && export SSL_ENABLED="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create the default env files
__create_env "/config/env/default.sh" "/root/env.sh" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$WEB_SERVER_PORT" = "443" ] && SSL_ENABLED="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show start message
if [ "$CONFIG_DIR_INITIALIZED" = "false" ] || [ "$DATA_DIR_INITIALIZED" = "false" ]; then
  [ "$ENTRYPOINT_MESSAGE" = "yes" ] && echo "Executing entrypoint script for GEN_SCRIPT_REPLACE_APPNAME"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set timezone
[ -n "$TZ" ] && [ -w "/etc/timezone" ] && echo "$TZ" >"/etc/timezone"
[ -f "/usr/share/zoneinfo/$TZ" ] && [ -w "/etc/localtime" ] && ln -sf "/usr/share/zoneinfo/$TZ" "/etc/localtime"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure localhost exists
if [ -w "/etc/hosts" ] && ! grep -q '127.0.0.1' /etc/hosts; then
  echo "127.0.0.1       localhost" >"/etc/hosts"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set containers hostname
[ -n "$HOSTNAME" ] && [ -w "/etc/timezone" ] && echo "$HOSTNAME" >"/etc/hostname"
if [ -w "/etc/hosts" ] && [ -n "$HOSTNAME" ]; then
  echo "${CONTAINER_IP4_ADDRESS:-127.0.0.1}    $HOSTNAME $HOSTNAME.local" >>"/etc/hosts"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add domain to hosts file
[ -n "$DOMAINNAME" ] && [ -w "/etc/timezone" ] && echo "$HOSTNAME.${DOMAINNAME:-local}" >"/etc/hostname"
if [ -w "/etc/hosts" ] && [ -n "$DOMAINNAME" ]; then
  echo "${CONTAINER_IP4_ADDRESS:-127.0.0.1}    $HOSTNAME.${DOMAINNAME:-local}" >"/etc/hosts"
  echo "${CONTAINER_IP4_ADDRESS:-127.0.0.1}    $HOSTNAME.$DOMAINNAME" >>"/etc/hosts"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete any gitkeep files
[ -d "/data" ] && rm -Rf "/data/.gitkeep" "/data"/*/*.gitkeep
[ -d "/config" ] && rm -Rf "/config/.gitkeep" "/config"/*/*.gitkeep
[ -f "/usr/local/bin/.gitkeep" ] && rm -Rf "/usr/local/bin/.gitkeep"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import hosts file into container
[ -f "/usr/local/etc/hosts" ] && [ -w "/etc/hosts" ] && cat "/usr/local/etc/hosts" >>"/etc/hosts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup bin directory
SET_USR_BIN=""
[ -d "/data/bin" ] && SET_USR_BIN+="$(__find /data/bin f) "
[ -d "/config/bin" ] && SET_USR_BIN+="$(__find /config/bin f) "
if [ -n "$SET_USR_BIN" ]; then
  echo "Setting up bin $SET_USR_BIN > $LOCAL_BIN_DIR"
  for create_bin_template in $SET_USR_BIN; do
    if [ -n "$create_bin_template" ]; then
      create_bin_name="$(basename "$create_bin_template")"
      if [ -e "$create_bin_template" ]; then
        ln -sf "$create_bin_template" "$LOCAL_BIN_DIR/$create_bin_name"
      fi
    fi
  done
  unset create_bin_template create_bin_name SET_USR_BIN
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy default config
if [ -n "$DEFAULT_TEMPLATE_DIR" ]; then
  if [ "$CONFIG_DIR_INITIALIZED" = "false" ] && [ -d "/config" ]; then
    echo "Copying default config files $DEFAULT_TEMPLATE_DIR > /config"
    for create_config_template in "$DEFAULT_TEMPLATE_DIR"/*; do
      if [ -n "$create_config_template" ]; then
        create_template_name="$(basename "$create_config_template")"
        if [ -d "$create_config_template" ]; then
          mkdir -p "/config/$create_template_name/"
          cp -Rf "$create_config_template/." "/config/$create_template_name/" 2>/dev/null
        elif [ -e "$create_config_template" ]; then
          cp -Rf "$create_config_template" "/config/$create_template_name" 2>/dev/null
        fi
      fi
    done
    unset create_config_template create_template_name
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy custom config files
if [ -n "$DEFAULT_CONF_DIR" ]; then
  if [ "$CONFIG_DIR_INITIALIZED" = "false" ] && [ -d "/config" ]; then
    echo "Copying custom config files: $DEFAULT_CONF_DIR > /config"
    for create_config_template in "$DEFAULT_CONF_DIR"/*; do
      create_config_name="$(basename "$create_config_template")"
      if [ -n "$create_config_template" ]; then
        if [ -d "$create_config_template" ]; then
          mkdir -p "/config/$create_config_name"
          cp -Rf "$create_config_template/." "/config/$create_config_name/" 2>/dev/null
        elif [ -e "$create_config_template" ]; then
          cp -Rf "$create_config_template" "/config/$create_config_name" 2>/dev/null
        fi
      fi
    done
    unset create_config_template create_config_name
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy custom data files
if [ -d "/data" ]; then
  if [ "$DATA_DIR_INITIALIZED" = "false" ] && [ -n "$DEFAULT_DATA_DIR" ]; then
    echo "Copying data files $DEFAULT_DATA_DIR > /data"
    for create_data_template in "$DEFAULT_DATA_DIR"/*; do
      create_data_name="$(basename "$create_data_template")"
      if [ -n "$create_data_template" ]; then
        if [ -d "$create_data_template" ]; then
          mkdir -p "/data/$create_data_name"
          cp -Rf "$create_data_template/." "/data/$create_data_name/" 2>/dev/null
        elif [ -e "$create_data_template" ]; then
          cp -Rf "$create_data_template" "/data/$create_data_name" 2>/dev/null
        fi
      fi
    done
    unset create_template
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy /config to /etc
if [ -d "/config" ]; then
  if [ "$CONFIG_DIR_INITIALIZED" = "false" ]; then
    echo "Copy config files to system: /config > /etc"
    for create_config_name in /config/*; do
      if [ -n "$create_config_name" ]; then
        create_conf_name="$(basename "$create_config_name")"
        if [ -d "/etc/$create_conf_name" ] && [ -d "$create_config_name" ]; then
          mkdir -p "/etc/$create_conf_name/"
          cp -Rf "$create_config_name/." "/etc/$create_conf_name/" 2>/dev/null
        elif [ -e "/etc/$create_conf_name" ] && [ -e "$create_config_name" ]; then
          cp -Rf "$create_config_name" "/etc/$create_conf_name" 2>/dev/null
        fi
      fi
    done
    unset create_config_name create_conf_name
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy html files
if [ "$DATA_DIR_INITIALIZED" = "false" ] && [ -d "$DEFAULT_DATA_DIR/data/htdocs" ]; then
  cp -Rf "$DEFAULT_DATA_DIR/data/htdocs/." "$WWW_ROOT_DIR/" 2>/dev/null
fi
if [ -d "$DEFAULT_DATA_DIR/htdocs/www" ] && [ ! -d "$WWW_ROOT_DIR" ]; then
  mkdir -p "$WWW_ROOT_DIR"
  cp -Rf "$DEFAULT_DATA_DIR/htdocs/www/" "$WWW_ROOT_DIR"
  [ -f "$WWW_ROOT_DIR/htdocs/www/server-health" ] || echo "OK" >"$WWW_ROOT_DIR/htdocs/www/server-health"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -d "$SSL_DIR" ] || mkdir -p "$SSL_DIR"
if [ "$SSL_ENABLED" = "true" ] || [ "$SSL_ENABLED" = "yes" ]; then
  if [ -f "$SSL_CERT" ] && [ -f "$SSL_KEY" ]; then
    export SSL_ENABLED="true"
    if [ -n "$SSL_CA" ] && [ -f "$SSL_CA" ]; then
      mkdir -p "$SSL_DIR/certs"
      cat "$SSL_CA" >>"/etc/ssl/certs/ca-certificates.crt"
      cp -Rf "/." "$SSL_DIR/"
    fi
  else
    [ -d "$SSL_DIR" ] || mkdir -p "$SSL_DIR"
    __create_ssl_cert
  fi
  type update-ca-certificates &>/dev/null && update-ca-certificates
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup the smtp server
__setup_mta
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__setup_ssl
__run_pre
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show message
__run_message
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ]; then
  ENTRYPOINT_FIRST_RUN="no"
elif [ -d "/config" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_CONFIG_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if this is a new container
if [ -f "$ENTRYPOINT_DATA_INIT_FILE" ]; then
  DATA_DIR_INITIALIZED="true"
elif [ -d "/data" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_DATA_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ]; then
  CONFIG_DIR_INITIALIZED="true"
elif [ -d "/config" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_CONFIG_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_PID_FILE" ]; then
  START_SERVICES="no"
  ENTRYPOINT_MESSAGE="no"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export DATA_DIR_INITIALIZED CONFIG_DIR_INITIALIZED START_SERVICES ENTRYPOINT_MESSAGE
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show configured listing processes
if [ -n "$ENV_PORTS" ]; then
  show_port=""
  for port in $ENV_PORTS; do [ -n "$port" ] && show_port+="$(printf '%s ' "$port") "; done
  printf '%s\n' "The following ports are open: $show_port"
  unset port show_port
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Just start services
START_SERVICES="${START_SERVICES:-SYSTEM_INIT}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Begin options
case "$1" in
--help) # Help message
  echo 'Docker container for '$APPNAME''
  echo "Usage: $APPNAME [exec start init shell certbot ssl procs ports healthcheck backup command]"
  echo ""
  exit 0
  ;;

backup) # backup data and config dirs
  shift 1
  save="${1:-$BACKUP_DIR}"
  backupExit=0
  date="$(date '+%Y%m%d-%H%M')"
  file="$save/$date.tar.gz"
  echo "Backing up /data /config to $file"
  sleep 1
  tar cfvz "$file" --exclude="$save" "/data" "/config" || backupExit=1
  backupExit=$?
  [ $backupExit -eq 0 ] && echo "Backed up /data /config has finished" || echo "Backup of /data /config has failed"
  exit $backupExit
  ;;

healthcheck) # Docker healthcheck
  healthStatus=0
  services="${SERVICES_LIST:-$@}"
  healthEnabled="${HEALTH_ENABLED:-}"
  healthPorts="${WEB_SERVER_PORTS:-}"
  healthEndPoints="${HEALTH_ENDPOINTS:-}"
  healthMessage="Everything seems to be running"
  services="${services//,/ }"
  for proc in $services; do
    if [ -n "$proc" ]; then
      if ! __pgrep "$proc"; then
        echo "$proc is not running" >&2
        status=$((status + 1))
      fi
    fi
  done
  for port in $ports; do
    if [ -n "$(type -P netstat)" ] && [ -n "$port" ]; then
      netstat -taupln | grep -q ":$port " || healthStatus=$((healthStatus + 1))
    fi
  done
  for endpoint in $healthEndPoints; do
    if [ -n "$endpoint" ]; then
      __curl "$endpoint" || healthStatus=$((healthStatus + 1))
    fi
  done
  if [ -n "$healthEnabled" ]; then
    __curl "${HEALTH_URL:-http://localhost:$port/server-health}" || healthStatus=$((healthStatus + 1))
  fi
  [ "$healthStatus" -eq 0 ] || healthMessage="Errors reported see: docker logs --follow $CONTAINER_NAME"
  [ -n "$healthMessage" ] && echo "$healthMessage"
  exit $healthStatus
  ;;

ports) # show open ports
  shift 1
  ports="$(__netstat -taupln | awk -F ' ' '{print $4}' | awk -F ':' '{print $2}' | sort --unique --version-sort | grep -v '^$' | grep '^' || echo '')"
  [ -n "$ports" ] && printf '%s\n%s\n' "The followinf are servers:" "$ports"
  exit $?
  ;;

procs) # show running processes
  shift 1
  ps="$(__ps axco command | grep -vE 'COMMAND|grep|ps' | sort -u || grep '^' || echo '')"
  [ -n "$ps" ] && printf '%s\n%s\n' "Found the following processes" "$ps"
  exit $?
  ;;

ssl) # setup ssl
  shift 1
  __create_ssl_cert
  exit $?
  ;;

certbot) # manage ssl certificate
  shift 1
  SSL_CERT_BOT="true"
  if [ "$1" = "create" ]; then
    shift 1
    __certbot
  elif [ "$1" = "renew" ]; then
    shift 1
    __certbot "renew certonly --force-renew"
  else
    __exec_command "certbot" "$@"
  fi
  exit $?
  ;;

*/bin/sh | */bin/bash | bash | sh | shell) # Launch shell
  shift 1
  __exec_command "${@:-/bin/bash}"
  exit $?
  ;;

init) # show/execute init functions
  shift 1
  __init_${1:-help}
  exit $?
  ;;

start) # show/start an init script
  shift 1
  PATH="/usr/local/etc/docker/init.d:$PATH"
  if [ $# -eq 0 ]; then
    scripts="$(ls -A "/usr/local/etc/docker/init.d")"
    [ -n "$scripts" ] && echo "$scripts" || echo "No scripts found in: /usr/local/etc/docker/init.d"
  elif [ -f "/usr/local/etc/docker/init.d/$1" ]; then
    exec "/usr/local/etc/docker/init.d/$1"
  fi
  exit $?
  ;;

exec) # execute commands
  shift 1
  __exec_command "${@:-/bin/bash}"
  exit $?
  ;;

*) # Execute primary command
  if [ "$START_SERVICES" = "yes" ] && [ ! -f "/run/init.d/entrypoint.pid" ]; then
    echo "$$" >"/run/init.d/entrypoint.pid"
    __start_init_scripts "/usr/local/etc/docker/init.d" && sleep 3 || sleep 1
    [ -n "$1" ] && exec "$*" || exec "${SHELL:-bash -l}"
    exit 0
  else
    __exec_command "$@"
    exit $?
  fi
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end of entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ex: ts=2 sw=2 et filetype=sh
