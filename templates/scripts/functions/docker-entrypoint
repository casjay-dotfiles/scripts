#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202606041215-git
# @@Author           :  Jason Hempstead
# @@Contact          :  git-admin@casjaysdev.pro
# @@License          :  LICENSE.md
# @@ReadME           :  docker-entrypoint --help
# @@Copyright        :  Copyright: (c) 2023 Jason Hempstead, Casjays Developments
# @@Created          :  Sunday, Sep 03, 2023 01:40 EDT
# @@File             :  docker-entrypoint
# @@Description      :  functions for my docker containers
# @@Changelog        :  newScript
# @@TODO             :  Refactor code
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  functions/docker-entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
# setup debugging - https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
if [ -f "/config/.debug" ] && [ -z "$DEBUGGER_OPTIONS" ]; then
  export DEBUGGER_OPTIONS="$(<"/config/.debug")"
fi
if [ "$DEBUGGER" = "on" ] || [ -f "/config/.debug" ]; then
  set -eo pipefail
  [ -n "$DEBUGGER_OPTIONS" ] && set -"$DEBUGGER_OPTIONS"
  export DEBUGGER="on"
else
  set -eo pipefail
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
__remove_extra_spaces() { sed -E 's/  +/ /g; s|^ ||'; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
__log_debug() {
  [ "$DEBUGGER" = "on" ] && echo "[DEBUG] $*" >&2
}
__log_info() {
  echo "[INFO] $*"
}
__log_warn() {
  echo "[WARN] $*" >&2
}
__log_error() {
  echo "[ERROR] $*" >&2
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__printf_space() {
  local pad=$(printf '%0.1s' " "{1..60})
  local padlength=$1
  local string1="$2"
  local string2="$3"
  local message
  message+="$(printf '%s' "$string1") "
  message+="$(printf '%*.*s' 0 $((padlength - ${#string1} - ${#string2})) "$pad") "
  message+="$(printf '%s\n' "$string2") "
  printf '%s\n' "$message"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__mkdir() {
  if [ -n "$1" ]; then
    if ! mkdir -p "$@" 2>/dev/null; then
      [ "$DEBUGGER" = "on" ] && echo "Warning: Failed to create directory: $*" >&2
      return 1
    fi
  fi
  return 0
}
__rm() {
  if [ -n "$1" ] && [ -e "$1" ]; then
    if ! rm -Rf "${1:?}" 2>/dev/null; then
      [ "$DEBUGGER" = "on" ] && echo "Warning: Failed to remove: $1" >&2
      return 1
    fi
  fi
  return 0
}
__grep_test() { grep -sh "$1" "$2" 2>/dev/null | grep -qwF "${3:-$1}"; }
__netstat() {
  command -v netstat &>/dev/null || {
    [ "$DEBUGGER" = "on" ] && echo "Warning: netstat command not found" >&2
    return 10
  }
  netstat "$@" 2>/dev/null
}
__cd() {
  [ -d "$1" ] || mkdir -p "$1" 2>/dev/null || return 1
  builtin cd "$1" || return 1
}
__is_in_file() { [ -e "$2" ] && grep -Rsq "$1" "$2" 2>/dev/null; }
__curl() { curl -q -sfI --max-time 3 -k -o /dev/null "$@" 2>/dev/null || return 10; }
__find() {
  local result
  result=$(find "$1" -mindepth 1 -type "${2:-f,d}" 2>/dev/null)
  [ -n "$result" ] || return 10
  printf '%s\n' "$result"
}
__pcheck() {
  command -v pgrep &>/dev/null && pgrep -x "$1" &>/dev/null || return 10
}
__file_exists_with_content() { [ -n "$1" ] && [ -f "$1" ] && [ -s "$1" ] || return 2; }
__sed() { sed -i "s|$1|$2|g" "$3" 2>/dev/null || return 1; }
__ps() {
  command -v ps &>/dev/null || return 10
  ps "$@" 2>/dev/null | sed 's|:||g' | grep -Fw " ${1:-$SERVICE_NAME}$" || return 10
}
__is_dir_empty() {
  [ -n "$1" ] && [ -d "$1" ] || return 1
  [ -z "$(ls -A "$1" 2>/dev/null)" ]
}
__get_ip6() {
  ip a 2>/dev/null | awk '/^[[:space:]]*inet6 / {
    split($2, a, "/"); ip = a[1]
    if (ip !~ /^::1$/ && ip !~ /^fe/) { print ip; exit }
  }'
}
__get_ip4() {
  local ip4
  ip4=$(ip a 2>/dev/null | awk '/^[[:space:]]*inet / {
    split($2, a, "/"); ip = a[1]
    if (ip !~ /^127\.0\.0/) { print ip; exit }
  }')
  echo "${ip4:-127.0.0.1}"
}
__find_and_remove() {
  find "${2:-/etc}" -iname "$1" -exec rm -Rfv {} \; 2>/dev/null || true
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__pgrep() {
  local srvc="$1" count=3
  [ -z "$srvc" ] && return 10
  while [ $count -ge 0 ]; do
    pgrep -x "$srvc" &>/dev/null && return 0
    pgrep -f "$srvc" &>/dev/null && return 0
    ps -eo comm 2>/dev/null | grep -qxF "$srvc" && return 0
    [ $count -gt 0 ] && sleep 1
    count=$((count - 1))
  done
  return 10
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__find_file_relative() {
  [ -e "$1" ] || return 0
  find "$1"/* -not -path '*env/*' -not -path '*/.git/*' -not -name '.git' -type f 2>/dev/null \
    | sort -u \
    | sed "s|^$1/||" || true
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__find_directory_relative() {
  [ -d "$1" ] || return 0
  find "$1"/* -not -path '*env/*' -not -path '*/.git/*' -not -name '.git' -type d 2>/dev/null \
    | sort -u \
    | sed "s|^$1/||" || true
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__pid_exists() { [ -n "$1" ] && [ -d "/proc/$1" ]; }
__is_running() {
  local pat="$1"
  [ -n "$2" ] && pat="$pat.*$2"
  if command -v pgrep &>/dev/null; then
    pgrep -f "$pat" &>/dev/null
  else
    ps -eo args 2>/dev/null | grep -v grep | grep -Eq "$pat"
  fi
}
__get_pid() {
  if [ -z "$1" ]; then
    [ "$DEBUGGER" = "on" ] && echo "Warning: __get_pid called without process name" >&2
    return 1
  fi
  local pid
  pid=$(pgrep -x -n "$1" 2>/dev/null)
  if [ -n "$pid" ]; then
    echo "$pid"
    return 0
  fi
  [ "$DEBUGGER" = "on" ] && echo "Debug: No PID found for process: $1" >&2
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__format_variables() {
  local input="${*//,/ }"
  [ -z "$input" ] && return 0
  printf '%s\n' $input | sort -Ru | tr '\n' ' '
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__clean_variables() {
  local var="$*"
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"
  while [[ $var == *"  "* ]]; do var="${var//  / }"; done
  [ -n "$var" ] && printf '%s' "$var"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__no_exit() {
  local monitor_interval="${SERVICE_MONITOR_INTERVAL:-60}"
  local failure_threshold="${SERVICE_FAILURE_THRESHOLD:-3}"
  local monitor_services="${SERVICES_LIST:-tini}"
  local failed_services=""
  local failure_count=0

  # only return early if the recorded PID is still alive; a leftover
  # pid file from a prior container life (docker restart) would otherwise
  # cause us to exit instead of entering the monitor loop.
  if [ -f "/run/.no_exit.pid" ]; then
    local no_exit_pid
    no_exit_pid=$(<"/run/.no_exit.pid") 2>/dev/null
    if [ -n "$no_exit_pid" ] && kill -0 "$no_exit_pid" 2>/dev/null; then
      return 0
    fi
    rm -f /run/.no_exit.pid 2>/dev/null || true
  fi

  exec bash -c "
    trap 'echo \"Container shutdown requested\"; rm -f /run/.no_exit.pid /run/*.pid; exit 0' TERM INT
    echo \$\$ > /run/.no_exit.pid
    failed_services=\"\"
    failure_count=0

    while true; do
      if [ -n \"$monitor_services\" ] && [ \"$monitor_services\" != \"tini\" ]; then
        for service in \$(echo \"$monitor_services\" | tr ',' ' '); do
          if [ \"\$service\" != \"tini\" ] && ! pgrep -x \"\$service\" >/dev/null 2>&1; then
            echo \"WARNING: Service \$service is not running\" >&2
            failed_services=\"\$failed_services \$service\"
            failure_count=\$((failure_count + 1))
          fi
        done

        if [ \$failure_count -ge $failure_threshold ]; then
          echo \"ERROR: Too many service failures (\$failure_count), exiting container\" >&2
          exit 1
        fi

        if [ -n \"\$failed_services\" ]; then
          echo \"WARNING: Failed services:\$failed_services\" >&2
          failed_services=\"\"
          failure_count=0
        fi
      fi

      sleep $monitor_interval & wait \$!
    done
  "
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__trim() {
  local var="${*//;/ }"
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"
  while [[ $var == *"  "* ]]; do var="${var//  / }"; done
  [ -n "$var" ] && printf '%s' "$var"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__banner() {
  local message="$*"
  local total_width=80
  # Account for "# - - - " and " - - - #"
  local content_width=$((total_width - 14))
  printf '# - - - %-*s - - - #\n' "$content_width" "$message"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__service_banner() {
  local icon="${1:-🔧}"
  local message="${2:-Processing}"
  local service="${3:-service}"
  local full_message="$message $service"
  local total_width=80
  # Account for "# - - - " and " - - - #"
  local content_width=$((total_width - 14))
  # Most emojis are 2 chars wide
  local icon_width=2
  # Account for both icons and spaces
  local text_width=$((content_width - icon_width * 2 - 2))
  printf '# - - - %s %-*s %s - - - #\n' "$icon" "$text_width" "$full_message" "$icon"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__find_php_bin() {
  command -v php-fpm &>/dev/null || command -v php &>/dev/null || return 0
  find -L '/usr'/*bin -maxdepth 4 -name 'php-fpm*' 2>/dev/null | head -n1
}
__find_php_ini() {
  command -v php &>/dev/null || return 0
  local f
  f=$(find -L '/etc' -maxdepth 4 -name 'php.ini' 2>/dev/null | head -n1)
  [ -n "$f" ] && printf '%s\n' "${f%/php.ini}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__find_nginx_conf() {
  command -v nginx &>/dev/null || return 0
  find -L '/etc' -maxdepth 4 -name 'nginx.conf' 2>/dev/null | head -n1
}
__find_caddy_conf() {
  command -v caddy &>/dev/null || return 0
  find -L '/etc' -maxdepth 4 -type f -iname 'caddy.conf' 2>/dev/null | head -n1
}
__find_lighttpd_conf() {
  command -v lighttpd &>/dev/null || return 0
  find -L '/etc' -maxdepth 4 -type f -iname 'lighttpd.conf' 2>/dev/null | head -n1
}
__find_cherokee_conf() {
  command -v cherokee &>/dev/null || command -v cherokee-admin &>/dev/null || return 0
  find -L '/etc' -maxdepth 4 -type f -iname 'cherokee.conf' 2>/dev/null | head -n1
}
__find_httpd_conf() {
  command -v httpd &>/dev/null || command -v apache2 &>/dev/null || return 0
  find -L '/etc' -maxdepth 4 -type f \( -iname 'httpd.conf' -o -iname 'apache2.conf' \) 2>/dev/null | head -n1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__find_mysql_conf() {
  command -v mysqld &>/dev/null || command -v mariadbd &>/dev/null || command -v mysql &>/dev/null || return 0
  find -L '/etc' -maxdepth 4 -type f -name 'my.cnf' 2>/dev/null | head -n1
}
__find_pgsql_conf() {
  command -v postgres &>/dev/null || command -v pg_ctl &>/dev/null || return 0
  find -L '/var/lib' '/etc' -maxdepth 8 -type f -name 'postgresql.conf' 2>/dev/null | head -n1
}
__find_couchdb_conf() {
  command -v couchdb &>/dev/null || return 0
  find -L '/opt/couchdb/etc' '/etc/couchdb' -maxdepth 4 -type f \( -name 'local.ini' -o -name 'default.ini' \) 2>/dev/null | head -n1
}
__find_mongodb_conf() {
  command -v mongod &>/dev/null || return 0
  find -L '/etc/mongodb' '/etc' -maxdepth 4 -type f \( -name 'mongod.conf' -o -name 'mongodb.conf' \) 2>/dev/null | head -n1
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__random_password() { tr -dc '0-9a-zA-Z' < /dev/urandom | head -c${1:-16} && echo ""; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_working_dir() {
  # get service name
  local service_name="$SERVICE_NAME"
  # expand variables
  local workdir="$(eval echo "${WORK_DIR:-}")"
  # expand variables
  local home="$(eval echo "${workdir//\/root/\/tmp\/docker}")"
  # set working directories
  [ "$home" = "$workdir" ] && workdir=""
  [ "$home" = "/root" ] && home="/tmp/$service_name"
  [ -z "$home" ] && home="${workdir:-/tmp/$service_name}"
  # Change to working directory
  [ -n "$WORK_DIR" ] && [ -n "$EXEC_CMD_BIN" ] && workdir="$WORK_DIR"
  [ -z "$WORK_DIR" ] && [ "$HOME" = "/root" ] && [ "$RUNAS_USER" != "root" ] && [ "$PWD" != "/tmp" ] && home="${workdir:-$home}"
  [ -z "$WORK_DIR" ] && [ "$HOME" = "/root" ] && [ "$SERVICE_USER" != "root" ] && [ "$PWD" != "/tmp" ] && home="${workdir:-$home}"
  # create needed directories
  if [ -n "$home" ]; then
    if [ ! -d "$home" ]; then
      mkdir -p "$home"
    fi
  fi
  if [ -n "$workdir" ]; then
    if [ ! -d "$workdir" ]; then
      mkdir -p "$workdir"
    fi
  fi
  if [ "$SERVICE_USER" != "root" ] && [ -d "$home" ]; then
    chmod -f 777 "$home"
  fi
  if [ "$SERVICE_USER" != "root" ] && [ -d "$workdir" ]; then
    chmod -f 777 "$workdir"
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # cd to dir
  __cd "${workdir:-$home}"
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  echo "Setting the working directory to: $PWD"
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  export WORK_DIR="$workdir" HOME="$home"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__exec_service() {
  local count=6
  echo "Starting $1"
  eval "$@" 2>>/dev/stderr >>/data/logs/start.log &
  while [ $count -ne 0 ]; do
    sleep 3
    if __pgrep "$1"; then
      touch "/run/init.d/$1.pid"
      break
    else
      count=$((count - 1))
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__update_ssl_certs() {
  [ -f "/config/env/ssl.sh" ] && . "/config/env/ssl.sh"
  if [ -f "$SSL_CERT" ] && [ -f "$SSL_KEY" ]; then
    mkdir -p /etc/ssl
    [ -f "$SSL_CA" ] && cp -Rf "$SSL_CA" "/etc/ssl/$SSL_CA"
    [ -f "$SSL_KEY" ] && cp -Rf "$SSL_KEY" "/etc/ssl/$SSL_KEY"
    [ -f "$SSL_CERT" ] && cp -Rf "$SSL_CERT" "/etc/ssl/$SSL_CERT"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__display_user_info() {
  if [ -n "$user_name" ] || [ -n "$user_pass" ] || [ -n "$root_user_name" ] || [ -n "$root_user_pass" ]; then
    __banner "User info"
    [ -n "$user_name" ] && __printf_space "40" "username:" "$user_name"
    if [ -n "$user_pass" ]; then
      if [ "${SHOW_PASSWORDS:-no}" = "yes" ]; then
        __printf_space "40" "password:" "$user_pass"
      else
        __printf_space "40" "password:" "saved to ${USER_FILE_PREFIX}/${SERVICE_NAME}_pass"
      fi
    fi
    [ -n "$root_user_name" ] && __printf_space "40" "root username:" "$root_user_name"
    if [ -n "$root_user_pass" ]; then
      if [ "${SHOW_PASSWORDS:-no}" = "yes" ]; then
        __printf_space "40" "root password:" "$root_user_pass"
      else
        __printf_space "40" "root password:" "saved to ${ROOT_FILE_PREFIX}/${SERVICE_NAME}_pass"
      fi
    fi
    __banner ""
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_config_etc() {
  local copy="no"
  local name="$SERVICE_NAME"
  local etc_dir="${ETC_DIR:-/etc/$name}"
  local conf_dir="${CONF_DIR:-/config/$name}"
  __is_dir_empty "$conf_dir" && copy=yes
  if [ "$copy" = "yes" ]; then
    if [ -d "$etc_dir" ]; then
      mkdir -p "$conf_dir"
      __copy_templates "$etc_dir/." "$conf_dir/"
    elif [ -f "$etc_dir" ]; then
      __copy_templates "$etc_dir" "$conf_dir"
    fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - -
}
__create_ssl_cert() {
  local SSL_DIR="${SSL_DIR:-/etc/ssl}"
  [ -f "/config/env/ssl.sh" ] && . "/config/env/ssl.sh"
  if [ -z "$SSL_DIR" ]; then
    echo "SSL_DIR is unset" >&2
    return 1
  fi
  [ -d "$SSL_DIR" ] || mkdir -p "$SSL_DIR"
  if [ -n "$FORCE_SSL" ] || [ ! -f "$SSL_CERT" ] || [ ! -f "$SSL_KEY" ]; then
    echo "Setting Country to $COUNTRY and Setting State/Province to $STATE and Setting City to $CITY"
    echo "Setting OU to $UNIT and Setting ORG to $ORG and Setting server to $CN"
    echo "All variables can be overwritten by creating a /config/.ssl.env and setting the variables there"
    echo "Creating ssl key and certificate in $SSL_DIR and will be valid for $((VALID_FOR / 365)) year[s]"
    openssl req \
      -new \
      -newkey rsa:$RSA \
      -days $VALID_FOR \
      -nodes \
      -x509 \
      -subj "/C=${COUNTRY// /\\ }/ST=${STATE// /\\ }/L=${CITY// /\\ }/O=${ORG// /\\ }/OU=${UNIT// /\\ }/CN=${CN// /\\ }" \
      -keyout "$SSL_KEY" \
      -out "$SSL_CERT"
  fi
  if [ -f "$SSL_CERT" ] && [ -f "$SSL_KEY" ]; then
    __update_ssl_certs
    return 0
  else
    return 2
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_service_conf() {
  # Seed /config/$svc/ from build-time baked /etc sources on first container start.
  # Copy only — no symlinks. Symlinking /etc back to /config/ is the service's own
  # responsibility, done inside __update_conf_files in each init.d/*.sh script so
  # each service controls its exact paths and variable substitution order.
  #
  # Usage: __init_service_conf <conf_dir> <primary_etc_dir> [extra_etc_path ...]
  #
  #   primary_etc_dir  directory  → contents copied into conf_dir/ when conf_dir is empty
  #   extra_etc_path   directory  → copied into conf_dir/<name>/ when that subdir is empty
  #   extra_etc_path   file       → copied to conf_dir/<filename> when absent
  local conf_dir="$1"
  local primary_etc="$2"
  shift 2
  local src name
  mkdir -p "$conf_dir"
  if [ -d "$primary_etc" ] && __is_dir_empty "$conf_dir"; then
    __copy_templates "$primary_etc/." "$conf_dir/"
  fi
  for src in "$@"; do
    [ -e "$src" ] || continue
    name="${src##*/}"
    if [ -d "$src" ] && __is_dir_empty "$conf_dir/$name"; then
      mkdir -p "$conf_dir/$name"
      __copy_templates "$src/." "$conf_dir/$name/"
    elif [ -f "$src" ] && [ ! -f "$conf_dir/$name" ]; then
      cp -f "$src" "$conf_dir/$name"
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_apache() {
  command -v httpd &>/dev/null || command -v apache2 &>/dev/null || return 0
  local svc="${1:-apache2}"
  __init_service_conf "/config/$svc" "/etc/$svc"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_nginx() {
  command -v nginx &>/dev/null || return 0
  local svc="${1:-nginx}"
  __init_service_conf "/config/$svc" "/etc/$svc"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_php() {
  command -v php &>/dev/null || return 0
  local php_etc="${PHP_INI_DIR:-$(__find_php_ini)}"
  __init_service_conf "/config/php" "${php_etc:-/etc/php}" \
    "/etc/php.ini" "/etc/php-fpm" "/etc/php-fpm.conf"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_mysql() {
  command -v mysqld &>/dev/null || command -v mariadbd &>/dev/null || return 0
  local svc="${1:-mysql}"
  __init_service_conf "/config/$svc" "/etc/$svc" "/etc/my.ini" "/etc/my.cnf"
  [ -d "${DATABASE_DIR:-/data/db/$svc}" ] || mkdir -p "${DATABASE_DIR:-/data/db/$svc}"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_mongodb() {
  command -v mongod &>/dev/null || return 0
  __init_service_conf "/config/mongodb" "/etc/mongodb" "/etc/mongod.conf"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_postgres() {
  command -v postgres &>/dev/null || command -v pg_ctl &>/dev/null || return 0
  local pg_etc
  pg_etc="${PGSQL_CONFIG_FILE:+${PGSQL_CONFIG_FILE%/*}}"
  [ -n "$pg_etc" ] || pg_etc="$(__find_pgsql_conf)"
  [ -n "$pg_etc" ] && pg_etc="${pg_etc%/*}"
  [ -n "$pg_etc" ] && __init_service_conf "/config/postgres" "$pg_etc"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__init_couchdb() {
  command -v couchdb &>/dev/null || return 0
  __init_service_conf "/config/couchdb" "/etc/couchdb"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Show available init functions
__init_help() {
  echo '
Config seeding (copy /etc → /config, no symlinks):
  __init_service_conf <conf_dir> <primary_etc_dir> [extra_etc_path ...]
  __init_apache   [svc]   seeds /config/apache2  from /etc/apache2
  __init_nginx    [svc]   seeds /config/nginx     from /etc/nginx
  __init_php              seeds /config/php       from /etc/php* + /etc/php.ini + /etc/php-fpm
  __init_mysql    [svc]   seeds /config/mysql     from /etc/mysql + /etc/my.{ini,cnf}
  __init_mongodb          seeds /config/mongodb   from /etc/mongodb + /etc/mongod.conf
  __init_postgres         seeds /config/postgres  from pg data dir
  __init_couchdb          seeds /config/couchdb   from /etc/couchdb

SSL:
  __update_ssl_certs
  __create_ssl_cert
'
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__run_once() {
  if [ "$CONFIG_DIR_INITIALIZED" = "no" ] || [ "$DATA_DIR_INITIALIZED" = "no" ] || [ ! -f "/config/.docker_has_run" ]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# run program ever n minutes
__cron() {
  local bin=""
  if [ "$1" = "--pid" ]; then
    pid="$2"
    shift 2
  else
    pid="$$"
  fi
  if test -n "$1" && test -z "${1//[0-9]/}"; then
    interval=$(($1 * 60))
    shift 1
  else
    interval="300"
  fi
  [ $# -eq 0 ] && echo "Usage: cron [interval] [command]" && exit 1
  local command="$*"
  bin="${CRON_NAME:-$1}"; bin="${bin##*/}"
  trap 'retVal=$?;[ -f "/run/cron/$bin.run" ] && rm -Rf "/run/cron/$bin.run";[ -f "/run/cron/$bin.pid" ] && rm -Rf "/run/cron/$bin.pid";exit ${retVal:-0}' SIGINT ERR EXIT
  [ -d "/run/cron" ] || mkdir -p "/run/cron"
  echo "$pid" >"/run/cron/$bin.pid"
  echo "$command" >"/run/cron/$bin.run"
  echo "Log is saved to /data/logs/cron.log"
  # eval is intentional: $command is operator-controlled input from this container's init
  while :; do
    eval "$command"
    sleep $interval
    [ -f "/run/cron/$bin.run" ] || break
  done 2>/dev/stderr >>"/data/logs/cron.log"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__replace() {
  local search="$1" replace="$2" file="${3:-$2}"
  [ -e "$file" ] || return 1
  __sed "$search" "$replace" "$file" || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__find_replace() {
  local search="$1" replace="$2" file="${3:-$2}"
  [ -e "$file" ] || return 1
  find "$file" -type f -not -path '*/.git/*' -not -name '.git' -exec sed -i "s|$search|$replace|g" {} + 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# /config > /etc
__copy_templates() {
  local from="$1" to="$2" is_link=""
  [ -L "$to" ] && is_link="$(readlink "$to")"
  [ "$from" != "$is_link" ] || return 0
  if [ -e "$from" ] && (! [ -d "$to" ] || __is_dir_empty "$to"); then
    __file_copy "$from" "$to"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# /config/file > /etc/file
__symlink() {
  local from="$1" to="$2"
  [ -e "$to" ] || return 0
  [ "$from" = "$to" ] && return 0
  __rm "$from"
  [ -d "${from%/*}" ] || mkdir -p "${from%/*}" 2>/dev/null
  ln -sf "$to" "$from" && echo "Created symlink to $from > $to"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__file_copy() {
  local from="$1"
  local dest="$2"
  local is_link=""
  [ -L "$dest" ] && is_link="$(readlink "$dest")"
  if [ "$from" != "$is_link" ]; then
    if [ -n "$from" ] && [ -e "$from" ] && [ -n "$dest" ]; then
      if [ -d "$from" ]; then
        if cp -Rf "$from/." "$dest/" &>/dev/null; then
          printf '%s\n' "Copied: $from > $dest"
          return 0
        else
          printf '%s\n' "Copy failed: $from < $dest" >&2
          return 1
        fi
      else
        if cp -Rf "$from" "$dest" &>/dev/null; then
          printf '%s\n' "Copied: $from > $dest"
          return 0
        else
          printf '%s\n' "Copy failed: $from < $dest" >&2
          return 1
        fi
      fi
    else
      printf '%s\n' "$from does not exist" >&2
      return 2
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__generate_random_uids() {
  local set_random_uid=$((100 + RANDOM % 900))
  while :; do
    if grep -shq "x:.*:$set_random_uid:" "/etc/group" && ! grep -shq "x:$set_random_uid:.*:" "/etc/passwd"; then
      set_random_uid=$((set_random_uid + 1))
    else
      echo "$set_random_uid"
      break
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__setup_directories() {
  APPLICATION_DIRS="${APPLICATION_DIRS//,/ }"
  APPLICATION_FILES="${APPLICATION_FILES//,/ }"
  ADD_APPLICATION_DIRS="${ADD_APPLICATION_DIRS//,/ }"
  ADD_APPLICATION_FILES="${ADD_APPLICATION_FILES//,/ }"
  [ -n "$ENV_WWW_ROOT_DIR" ] && export WWW_ROOT_DIR="$ENV_WWW_ROOT_DIR"
  # Setup WWW_ROOT_DIR
  if [ "$IS_WEB_SERVER" = "yes" ]; then
    APPLICATION_DIRS="$APPLICATION_DIRS $WWW_ROOT_DIR"
    __initialize_www_root
    (echo "Creating directory $WWW_ROOT_DIR with permissions 777" && mkdir -p "$WWW_ROOT_DIR" && find "$WWW_ROOT_DIR" -type d -exec chmod -f 777 {} \;) 2>/dev/stderr | tee -p -a "/data/logs/init.txt"
  fi
  # Setup DATABASE_DIR
  if [ "$IS_DATABASE_SERVICE" = "yes" ] || [ "$USES_DATABASE_SERVICE" = "yes" ]; then
    APPLICATION_DIRS="$APPLICATION_DIRS $DATABASE_DIR"
    if __is_dir_empty "$DATABASE_DIR" || [ ! -d "$DATABASE_DIR" ]; then
      (echo "Creating directory $DATABASE_DIR with permissions 777" && mkdir -p "$DATABASE_DIR" && chmod -f 777 "$DATABASE_DIR") 2>/dev/stderr | tee -p -a "/data/logs/init.txt"
    fi
  fi
  # create default directories
  for filedirs in $ADD_APPLICATION_DIRS $APPLICATION_DIRS; do
    if [ -n "$filedirs" ] && [ ! -d "$filedirs" ]; then
      (echo "Creating directory $filedirs with permissions 777" && mkdir -p "$filedirs" && chmod -f 777 "$filedirs") 2>/dev/stderr | tee -p -a "/data/logs/init.txt"
    fi
  done
  # create default files
  for application_files in $ADD_APPLICATION_FILES $APPLICATION_FILES; do
    if [ -n "$application_files" ] && [ ! -e "$application_files" ]; then
      (echo "Creating file $application_files with permissions 777" && touch "$application_files" && chmod -Rf 777 "$application_files") 2>/dev/stderr | tee -p -a "/data/logs/init.txt"
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# set user on files/folders
__fix_permissions() {
  change_user="${1:-${SERVICE_USER:-root}}"
  change_group="${2:-${SERVICE_GROUP:-$change_user}}"
  [ -n "$RUNAS_USER" ] && [ "$RUNAS_USER" != "root" ] && change_user="$RUNAS_USER" && change_group="$change_user"
  if [ -n "$change_user" ]; then
    if grep -shq "^$change_user:" "/etc/passwd"; then
      for permissions in $ADD_APPLICATION_DIRS $APPLICATION_DIRS; do
        if [ -n "$permissions" ] && [ -e "$permissions" ]; then
          (chown -Rf $change_user "$permissions" && echo "changed ownership on $permissions to user:$change_user") 2>/dev/stderr | tee -p -a "/data/logs/init.txt"
        fi
      done
    fi
  fi
  if [ -n "$change_group" ]; then
    if grep -shq "^$change_group:" "/etc/group"; then
      for permissions in $ADD_APPLICATION_DIRS $APPLICATION_DIRS; do
        if [ -n "$permissions" ] && [ -e "$permissions" ]; then
          (chgrp -Rf $change_group "$permissions" && echo "changed group ownership on $permissions to group $change_group") 2>/dev/stderr | tee -p -a "/data/logs/init.txt"
        fi
      done
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__get_gid() { awk -F: -v n="$1" '$1==n {print $3; found=1; exit} END {exit !found}' /etc/group 2>/dev/null; }
__get_uid() { awk -F: -v n="$1" '$1==n {print $3; found=1; exit} END {exit !found}' /etc/passwd 2>/dev/null; }
__check_for_uid() { awk -F: -v n="$1" '$3==n {found=1; exit} END {exit !found}' /etc/passwd 2>/dev/null; }
__check_for_guid() { awk -F: -v n="$1" '$3==n {found=1; exit} END {exit !found}' /etc/group 2>/dev/null; }
__check_for_user() { awk -F: -v n="$1" '$1==n {found=1; exit} END {exit !found}' /etc/passwd 2>/dev/null; }
__check_for_group() { awk -F: -v n="$1" '$1==n {found=1; exit} END {exit !found}' /etc/group 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - -
# check if process is already running
__proc_check() {
  # Skip process check for one-shot/configuration services
  if [ "$SERVICE_USES_PID" = "no" ]; then
    return 1
  fi
  local cmd_bin cmd_name check_result
  cmd_bin="$(type -P "${1:-$EXEC_CMD_BIN}" 2>/dev/null || echo "${1:-$EXEC_CMD_BIN}")"
  cmd_name="${cmd_bin:-${1:-$EXEC_CMD_NAME}}"; cmd_name="${cmd_name##*/}"
  if [ -z "$cmd_name" ] || [ "$cmd_name" = "." ]; then
    return 1
  fi
  check_result=1
  if [ -n "$cmd_bin" ] && __pgrep "$cmd_bin" 2>/dev/null; then
    check_result=0
  elif [ -n "$cmd_name" ] && __pgrep "$cmd_name" 2>/dev/null; then
    check_result=0
  elif [ -f "$SERVICE_PID_FILE" ]; then
    local pid_from_file
    pid_from_file=$(<"$SERVICE_PID_FILE") 2>/dev/null
    if [ -n "$pid_from_file" ] && kill -0 "$pid_from_file" 2>/dev/null; then
      check_result=0
    fi
  fi
  if [ $check_result -eq 0 ]; then
    SERVICE_IS_RUNNING="yes"
    pgrep -x -n "$cmd_name" >"$SERVICE_PID_FILE" 2>/dev/null || true
    return 0
  else
    return 1
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - -
__set_user_group_id() {
  local exitStatus=0
  local set_user="${1:-$SERVICE_USER}"
  local set_uid="${2:-${SERVICE_UID:-1000}}"
  local set_gid="${3:-${SERVICE_GID:-1000}}"
  local random_id="$(__generate_random_uids)"
  set_uid="$(__get_uid "$set_user" || echo "$set_uid")"
  set_gid="$(__get_gid "$set_user" || echo "$set_gid")"
  if ! grep -shq "^$set_user:" "/etc/passwd" "/etc/group"; then
    return 0
  fi
  if [ -z "$set_user" ] || [ "$set_user" = "root" ]; then
    return
  fi
  if grep -shq "^$set_user:" "/etc/passwd" "/etc/group"; then
    if __check_for_guid "$set_gid"; then
      groupmod -g "${set_gid}" $set_user 2>/dev/stderr | tee -p -a "/data/logs/init.txt" >/dev/null
    fi
    if __check_for_uid "$set_uid"; then
      usermod -u "${set_uid}" -g "${set_gid}" $set_user 2>/dev/stderr | tee -p -a "/data/logs/init.txt" >/dev/null
    fi
  fi
  export SERVICE_UID="$set_uid"
  export SERVICE_GID="$set_gid"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__create_service_user() {
  local exitStatus=0
  local max_attempts=100
  local attempt=0
  local create_user="${1:-$SERVICE_USER}"
  local create_group="${2:-${SERVICE_GROUP:-$create_user}}"
  local create_home_dir="${3:-$WORK_DIR}"
  local create_uid="${4:-${SERVICE_UID:-$USER_UID}}"
  local create_gid="${5:-${SERVICE_GID:-$USER_GID}}"
  local random_id="$(__generate_random_uids)"
  local create_home_dir="${create_home_dir:-/home/$create_user}"
  local log_file="/data/logs/init.txt"
  # Ensure log directory exists
  [ -d "$(dirname "$log_file")" ] || mkdir -p "$(dirname "$log_file")" 2>/dev/null
  # Validate that we have at least a user or group to create
  if [ -z "$create_user" ] && [ -z "$create_group" ]; then
    echo "No user or group specified to create" >&2
    return 0
  fi
  # Validate user/group name format (alphanumeric, underscore, hyphen; must start with letter or underscore)
  if [ -n "$create_user" ] && [[ ! "$create_user" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "Error: Invalid username format '$create_user' - must start with letter/underscore, contain only lowercase alphanumeric, underscore, or hyphen" >&2
    return 1
  fi
  if [ -n "$create_group" ] && [[ ! "$create_group" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "Error: Invalid group name format '$create_group' - must start with letter/underscore, contain only lowercase alphanumeric, underscore, or hyphen" >&2
    return 1
  fi
  # Check if user and group already exist
  if grep -shq "^$create_user:" "/etc/passwd" && grep -shq "^$create_group:" "/etc/group"; then
    return 0
  fi
  # Root user/group - nothing to create
  if [ "$create_user" = "root" ] && [ "$create_group" = "root" ]; then
    return 0
  fi
  # Override with RUNAS_USER if specified and not root
  if [ -n "$RUNAS_USER" ] && [ "$RUNAS_USER" != "root" ]; then
    create_user="$RUNAS_USER"
    create_group="$RUNAS_USER"
    create_uid="${create_uid:-1000}"
    create_gid="${create_gid:-1000}"
  fi
  # Get existing UID/GID or use provided values
  create_uid="$(__get_uid "$create_user" 2>/dev/null || echo "$create_uid")"
  create_gid="$(__get_gid "$create_user" 2>/dev/null || echo "$create_gid")"
  # Ensure we have valid non-root UID/GID
  if [ -z "$create_uid" ] || [ "$create_uid" = "0" ]; then
    create_uid="$random_id"
  fi
  if [ -z "$create_gid" ] || [ "$create_gid" = "0" ]; then
    create_gid="$random_id"
  fi
  # Validate UID/GID are numeric and within valid range
  if [[ ! "$create_uid" =~ ^[0-9]+$ ]] || [ "$create_uid" -lt 1 ] || [ "$create_uid" -gt 65534 ]; then
    echo "Error: Invalid UID '$create_uid' - must be a number between 1 and 65534" >&2
    return 1
  fi
  if [[ ! "$create_gid" =~ ^[0-9]+$ ]] || [ "$create_gid" -lt 1 ] || [ "$create_gid" -gt 65534 ]; then
    echo "Error: Invalid GID '$create_gid' - must be a number between 1 and 65534" >&2
    return 1
  fi
  # Find available UID/GID if current ones are taken (with loop protection)
  while __check_for_uid "$create_uid" || __check_for_guid "$create_gid"; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
      echo "Error: Could not find available UID/GID after $max_attempts attempts" >&2
      return 1
    fi
    random_id=$((random_id + 1))
    create_uid="$random_id"
    create_gid="$random_id"
  done
  # Create group if needed
  if [ -n "$create_group" ] && ! __check_for_group "$create_group"; then
    echo "Creating system group '$create_group' with GID $create_gid"
    if ! groupadd --force --system -g "$create_gid" "$create_group" 2>&1 | tee -a "$log_file"; then
      echo "Error: Failed to create group '$create_group'" >&2
      exitStatus=$((exitStatus + 1))
    elif ! grep -shq "^$create_group:" "/etc/group"; then
      echo "Error: Group '$create_group' not found in /etc/group after creation" >&2
      exitStatus=$((exitStatus + 1))
    fi
  fi
  # Create user if needed (only if group creation succeeded)
  if [ $exitStatus -eq 0 ] && [ -n "$create_user" ] && ! __check_for_user "$create_user"; then
    echo "Creating system user '$create_user' with UID $create_uid"
    if ! useradd --system --uid "$create_uid" --gid "$create_group" --comment "Account for $create_user" --home-dir "$create_home_dir" --shell /bin/false "$create_user" 2>&1 | tee -a "$log_file"; then
      echo "Error: Failed to create user '$create_user'" >&2
      exitStatus=$((exitStatus + 1))
    elif ! grep -shq "^$create_user:" "/etc/passwd"; then
      echo "Error: User '$create_user' not found in /etc/passwd after creation" >&2
      exitStatus=$((exitStatus + 1))
    fi
  fi
  # Setup user environment if creation succeeded
  if [ $exitStatus -eq 0 ] && [ -n "$create_group" ] && [ -n "$create_user" ]; then
    export WORK_DIR="${create_home_dir:-}"
    if [ -n "$WORK_DIR" ]; then
      if [ ! -d "$WORK_DIR" ]; then
        if ! mkdir -p "$WORK_DIR" 2>/dev/null; then
          echo "Warning: Failed to create home directory '$WORK_DIR'" >&2
        fi
      fi
      if [ -d "/etc/.skel" ] && [ -d "$WORK_DIR" ]; then
        cp -Rf /etc/.skel/. "$WORK_DIR/" 2>/dev/null || echo "Warning: Failed to copy skeleton files to '$WORK_DIR'" >&2
      fi
    fi
    # Setup sudo access
    if [ -d "/etc/sudoers.d" ]; then
      if [ ! -f "/etc/sudoers.d/$create_user" ]; then
        echo "$create_user ALL=(ALL)   NOPASSWD: ALL" >"/etc/sudoers.d/$create_user" 2>/dev/null || echo "Warning: Failed to create sudoers file for '$create_user'" >&2
        chmod 0440 "/etc/sudoers.d/$create_user" 2>/dev/null
      fi
    elif [ -f "/etc/sudoers" ] && ! grep -qs "^$create_user " "/etc/sudoers"; then
      echo "$create_user ALL=(ALL)   NOPASSWD: ALL" >>"/etc/sudoers" 2>/dev/null || echo "Warning: Failed to add '$create_user' to sudoers" >&2
    fi
    SERVICE_UID="$create_uid"
    SERVICE_GID="$create_gid"
    SERVICE_USER="$create_user"
    SERVICE_GROUP="$create_group"
  else
    echo "Warning: Falling back to root user due to creation errors" >&2
    SERVICE_UID=0
    SERVICE_GID=0
    SERVICE_USER=root
    SERVICE_GROUP=root
    exitStatus=2
  fi
  export SERVICE_UID SERVICE_GID SERVICE_USER SERVICE_GROUP
  return $exitStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__create_env_file() {
  local dir=""
  local envStatus=0
  local envFile=("${@:-}")
  local sample_file="/usr/local/etc/docker/env/default.sample"
  [ -f "$sample_file" ] || return 0
  for create_env in "/usr/local/etc/docker/env/default.sh" "${envFile[@]}"; do
    dir="$(dirname "$create_env")"
    [ -d "$dir" ] || mkdir -p "$dir"
    if [ -n "$create_env" ] && [ ! -f "$create_env" ]; then
      cp -f "$sample_file" "$create_env"
    fi
    [ -f "$create_env" ] || envStatus=$((1 + envStatus))
  done
  [ "$envStatus" -eq 0 ] && rm -f "$sample_file"
  return $envStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__exec_command() {
  local arg=("$@")
  local exitCode=0
  local cmdExec="${arg:-}"
  local pre_exec="--login -c"
  local shell bin prog
  shell=$(type -P bash || type -P dash || type -P ash || type -P sh) 2>/dev/null
  bin="${arg[0]:-bash}"
  prog="$(type -P "$bin" 2>/dev/null || echo "$bin")"
  if type -t "$bin" &>/dev/null; then
    echo "${exec_message:-Executing command: $cmdExec}"
    "$shell" $pre_exec "$cmdExec"
    exitCode=$?
  elif [ -f "$prog" ]; then
    echo "$prog is not executable"
    exitCode=98
  else
    echo "$prog does not exist"
    exitCode=99
  fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup the server init scripts
__start_init_scripts() {
  [ "$1" = " " ] && shift 1
  if [ "$DEBUGGER" = "on" ]; then
    echo "Enabling debugging"
    set -eo pipefail
    [ -n "$DEBUGGER_OPTIONS" ] && set -"$DEBUGGER_OPTIONS"
  else
    set -eo pipefail
  fi
  local retPID=""
  local basename=""
  local init_pids=""
  local retstatus="0"
  local initStatus="0"
  local critical_failures="0"
  local pidFile="/run/.start_init_scripts.pid"
  local init_dir="${1:-/usr/local/etc/docker/init.d}"
  local init_files=("$init_dir"/*.sh)
  local init_count=0
  [ -e "${init_files[0]}" ] && init_count=${#init_files[@]}
  local exit_on_failure="${EXIT_ON_SERVICE_FAILURE:-true}"

  # Clean stale PID files from previous runs
  if [ ! -f "/run/.start_init_scripts.pid" ]; then
    echo "🧹 Cleaning stale PID files from previous container run"
    rm -f /run/*.pid /run/init.d/*.pid 2>/dev/null || true
  fi

  touch "$pidFile"

  if [ "$init_count" -eq 0 ] || [ ! -d "$init_dir" ]; then
    mkdir -p "/data/logs/init"
    while :; do echo "Running: $(date)" >"/data/logs/init/keep_alive" && sleep 3600; done &
  else
    if [ -d "$init_dir" ]; then
      local sample
      for sample in "$init_dir"/*.sample; do
        [ -e "$sample" ] && __rm "$sample"
      done
      (shopt -s nullglob; chmod -Rf 755 "$init_dir"/*.sh 2>/dev/null || true)

      echo "🚀 Starting container services initialization"
      echo "📂 Init directory: $init_dir"
      echo "📊 Services to start: $init_count"
      echo "📋 Found $init_count service scripts to execute"
      echo ""

      for init in "$init_dir"/*.sh; do
        if [ -x "$init" ]; then
          touch "$pidFile"
          name="${init##*/}"
          service="${name#*-}"; service="${service%.sh}"
          __service_banner "🔧" "Executing service script:" "${init##*/}"
          # Execute the init script and capture the exit code (subshell isolates exit calls)
          if ( source "$init" ); then
            # Check if service was disabled first
            if [ -n "$SERVICE_DISABLED" ]; then
              initStatus="0"
              __service_banner "🚫" "Service $service is disabled -" "skipping"
              unset SERVICE_DISABLED
              # Continue to next service
            elif [ "$CONTAINER_INIT" = "yes" ]; then
              initStatus="0"
              __service_banner "✅" "Service $service completed successfully -" "configuration service"
            else
              # Allow some time for service to initialize
              sleep 1
              # Check for service success indicators
              local expected_pid_file="/run/init.d/$service.pid"
              set +e
              # Check if this is a configuration service (no daemon process expected)
              if [ "$SERVICE_USES_PID" = "no" ]; then
                # Configuration service - no daemon process expected
                initStatus="0"
                __service_banner "✅" "Service $service completed successfully -" "configuration service"
              else
                # Service uses PID tracking - verify actual running processes
                retPID=""
                local found_process=""
                # Try multiple name variants to find the process
                for name_variant in "$service" "${service}d" "${service//-/}"; do
                  if [ -z "$retPID" ]; then
                    retPID=$(__get_pid "$name_variant" 2>/dev/null || echo "")
                    if [ -n "$retPID" ] && [ "$retPID" != "0" ]; then
                      found_process="$name_variant"
                      break
                    fi
                  fi
                done
                if [ -n "$retPID" ] && [ "$retPID" != "0" ]; then
                  # Found actual running process
                  initStatus="0"
                  __service_banner "✅" "Service $service started successfully -" "PID: ${retPID} ($found_process)"
                elif [ -f "$expected_pid_file" ]; then
                  # No running process but PID file exists - verify PID is valid
                  file_pid=$(<"$expected_pid_file") 2>/dev/null
                  if [ -n "$file_pid" ] && kill -0 "$file_pid" 2>/dev/null; then
                    initStatus="0"
                    __service_banner "✅" "Service $service started successfully -" "PID: $file_pid (from file)"
                  else
                    # PID file exists but process isn't running - treat as warning, not failure
                    initStatus="0"
                    __service_banner "⚠️" "Service $service may not be running -" "no process found (non-critical)"
                  fi
                else
                  # No process and no PID file - likely a configuration-only service
                  initStatus="0"
                  __service_banner "✅" "Service $service completed successfully -" "configuration service"
                fi
              fi
              set -e
            fi
          else
            initStatus="1"
            critical_failures=$((critical_failures + 1))
            __service_banner "❌" "Service $service failed to start -" "check logs"
          fi
          echo ""
        fi
        retstatus=$((retstatus + initStatus))
      done

      # Summary
      echo ""
      if [ $critical_failures -gt 0 ]; then
        echo "⚠️ Warning: $critical_failures critical service(s) reported failures"
        if [ "$exit_on_failure" = "true" ] && [ $critical_failures -ge 2 ]; then
          echo "❌ Exiting due to multiple critical service failures (threshold: 2)"
          return 1
        else
          echo "ℹ️ Continuing with $critical_failures failure(s) - container may still be functional"
        fi
      else
        echo "✅ All service initializations completed successfully"
      fi
      echo ""
    fi
  fi

  printf '%s\n' "$SERVICE_NAME started on $(date)" >"/data/logs/start.log"
  return $retstatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__setup_mta() {
  [ -d "/etc/ssmtp" ] || [ -d "/etc/postfix" ] || return
  if [ ! -d "/config/ssmtp" ] || [ ! -d "/config/postfix" ]; then
    echo "Configuring smtp server"
  fi
  local exitCode=0
  local relay_port="${EMAIL_RELAY//*:/}"
  local relay_server="${EMAIL_RELAY//:*/}"
  local local_hostname="${FULL_DOMAIN_NAME:-}"
  local account_user="${SERVER_ADMIN//@*/}"
  local account_domain="${EMAIL_DOMAIN//*@/}"
  [[ $EMAIL_RELAY == *[0-9][0-9]* ]] || relay_port="465"
  ################# sSMTP relay setup
  if command -v ssmtp &>/dev/null; then
    [ -d "/config/ssmtp" ] || mkdir -p "/config/ssmtp"
    [ -f "/etc/ssmtp/ssmtp.conf" ] && __rm "/etc/ssmtp/ssmtp.conf"
    symlink_files="$(__find_file_relative "/config/ssmtp")"
    if [ ! -f "/config/ssmtp/ssmtp.conf" ]; then
      cat >"/config/ssmtp/ssmtp.conf" <<EOF
# ssmtp configuration.
root=${account_user:-root}@${account_domain:-$HOSTNAME}
mailhub=${relay_server:-172.17.0.1}:$relay_port
rewriteDomain=$local_hostname
hostname=$local_hostname
TLS_CA_FILE=/etc/ssl/certs/ca-certificates.crt
UseTLS=Yes
UseSTARTTLS=No
AuthMethod=LOGIN
FromLineOverride=yes
#AuthUser=username
#AuthPass=password

EOF
    fi
    if [ -f "/config/ssmtp/ssmtp.conf" ]; then
      for file in $symlink_files; do
        __symlink "/config/ssmtp/$file" "/etc/ssmtp/$file"
        __initialize_replace_variables "/etc/ssmtp/$file"
      done
      if [ -f "/etc/ssmtp/revaliases" ] && [ ! -f "/config/ssmtp/revaliases" ]; then
        mv -f "/etc/ssmtp/revaliases" "/config/ssmtp/revaliases"
        __symlink "/config/ssmtp/revaliases" "/etc/ssmtp/revaliases"
        __initialize_replace_variables "/etc/ssmtp/revaliases"
      else
        touch "/config/ssmtp/revaliases"
        __symlink "/config/ssmtp/revaliases" "/etc/ssmtp/revaliases"
        __initialize_replace_variables "/etc/ssmtp/revaliases"
      fi
      echo "Done setting up ssmtp"
    fi

    ################# postfix relay setup
  elif command -v postfix &>/dev/null; then
    [ -d "/etc/postfix" ] || mkdir -p "/etc/postfix"
    [ -d "/config/postfix" ] || mkdir -p "/config/postfix"
    [ -f "/etc/postfix/main.cf" ] && __rm "/etc/postfix/main.cf"
    symlink_files="$(__find_file_relative "/config/postfix")"
    if [ ! -f "/config/postfix/main.cf" ]; then
      cat >"/config/postfix/main.cf" <<EOF
# postfix configuration.
smtpd_banner = \$myhostname ESMTP email server
compatibility_level = 2
inet_protocols = ipv4
inet_interfaces = all
mydestination =
local_transport=error: local delivery disabled
mynetworks = /etc/postfix/mynetworks
alias_maps = hash:/etc/postfix/aliases
alias_database = hash:/etc/postfix/aliases
transport_maps = hash:/etc/postfix/transport
virtual_alias_maps = hash:/etc/postfix/virtual
relay_domains = hash:/etc/postfix/mydomains, regexp:/etc/postfix/mydomains.pcre
tls_random_source = dev:/dev/urandom
smtp_use_tls = yes
smtpd_use_tls = yes
smtpd_tls_session_cache_database = btree:/etc/postfix/smtpd_scache
smtpd_tls_exclude_ciphers = aNULL, eNULL, EXPORT, DES, RC4, MD5, PSK, aECDH, EDH-DSS-DES-CBC3-SHA, EDH-RSA-DES-CBC3-SHA, KRB5-DES, CBC3-SHA
smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, defer_unauth_destination
append_dot_mydomain = yes
myorigin = $local_hostname
myhostname = $local_hostname
relayhost = [$relay_server]:$relay_port

EOF
    fi
    if [ -d "/config/postfix" ]; then
      for f in $symlink_files; do
        __symlink "/config/postfix/$f" "/etc/postfix/$f"
      done
      __initialize_replace_variables "/etc/postfix"
      touch "/config/postfix/aliases" "/config/postfix/mynetworks" "/config/postfix/transport"
      touch "/config/postfix/mydomains.pcre" "/config/postfix/mydomains" "/config/postfix/virtual"
      postmap "/config/postfix/aliases" "/config/postfix/mynetworks" "/config/postfix/transport" &>/dev/null
      postmap "/config/postfix/mydomains.pcre" "/config/postfix/mydomains" "/config/postfix/virtual" &>/dev/null
    fi
    if [ -f "/etc/postfix/main.cf" ] && [ ! -f "/run/init.d/postfix.pid" ]; then
      SERVICES_LIST+="postfix "
      if [ ! -f "/run/init.d/postfix.pid" ]; then
        __exec_service postfix start
      fi
      echo "Done setting up postfix"
    fi
  fi
  [ -f "/root/dead.letter" ] && __rm "/root/dead.letter"
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_web_health() {
  local www_dir="${1:-${WWW_ROOT_DIR:-/usr/local/share/httpd/default}}"
  if [ -d "$www_dir" ]; then
    __find_replace "REPLACE_CONTAINER_IP4" "${REPLACE_CONTAINER_IP4:-127.0.0.1}" "/usr/local/share/httpd"
    __find_replace "REPLACE_COPYRIGHT_FOOTER" "${COPYRIGHT_FOOTER:-Copyright 1999 - $(date +'%Y')}" "/usr/local/share/httpd"
    __find_replace "REPLACE_LAST_UPDATED_ON_MESSAGE" "${LAST_UPDATED_ON_MESSAGE:-$(date +'Last updated on: %Y-%m-%d at %H:%M:%S')}" "/usr/local/share/httpd"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
#  file_dir
__initialize_replace_variables() {
  local set_dir="" get_dir="$*"
  [ $# -ne 0 ] || return 1
  for set_dir in $get_dir; do
    __find_replace "REPLACE_SSL_DIR" "${SSL_DIR:-/etc/ssl}" "$set_dir"
    __find_replace "REPLACE_RANDOM_ID" "$(__random_password 8)" "$set_dir"
    __find_replace "REPLACE_TZ" "${TZ:-${TIMEZONE:-America/New_York}}" "$set_dir"
    __find_replace "REPLACE_SERVER_PROTO" "${SERVICE_PROTOCOL:-http}" "$set_dir"
    __find_replace "REPLACE_SERVER_SITE_TITLE" "${SERVER_SITE_TITLE:-CasjaysDev - Docker Container}" "$set_dir"
    __find_replace "REPLACE_TMP_DIR" "${TMP_DIR:-/tmp/$SERVICE_NAME}" "$set_dir"
    __find_replace "REPLACE_RUN_DIR" "${RUN_DIR:-/run/$SERVICE_NAME}" "$set_dir"
    __find_replace "REPLACE_LOG_DIR" "${LOG_DIR:-/data/logs/$SERVICE_NAME}" "$set_dir"
    __find_replace "REPLACE_ETC_DIR" "${ETC_DIR:-/etc/$SERVICE_NAME}" "$set_dir"
    __find_replace "REPLACE_DATA_DIR" "${DATA_DIR:-/data/$SERVICE_NAME}" "$set_dir"
    __find_replace "REPLACE_CONFIG_DIR" "${CONF_DIR:-/config/$SERVICE_NAME}" "$set_dir"
    __find_replace "REPLACE_EMAIL_RELAY" "${EMAIL_RELAY:-172.17.0.1}" "$set_dir"
    __find_replace "REPLACE_SERVER_ADMIN" "${SERVER_ADMIN:-root@${EMAIL_DOMAIN:-${FULL_DOMAIN_NAME:-$HOSTNAME}}}" "$set_dir"
    __find_replace "REPLACE_APP_USER" "${SERVICE_USER:-${RUNAS_USER:-root}}" "$set_dir"
    __find_replace "REPLACE_WWW_USER" "${SERVICE_USER:-${RUNAS_USER:-root}}" "$set_dir"
    __find_replace "REPLACE_APP_GROUP" "${SERVICE_GROUP:-${SERVICE_USER:-${RUNAS_USER:-root}}}" "$set_dir"
    __find_replace "REPLACE_WWW_GROUP" "${SERVICE_GROUP:-${SERVICE_USER:-${RUNAS_USER:-root}}}" "$set_dir"
    __find_replace "REPLACE_SERVICE_USER" "${SERVICE_USER:-${RUNAS_USER:-root}}" "$set_dir"
    __find_replace "REPLACE_SERVICE_GROUP" "${SERVICE_GROUP:-${RUNAS_USER:-root}}" "$set_dir"
    __find_replace "REPLACE_SERVER_ADMIN_URL" "$SERVER_ADMIN_URL" "$set_dir"
    if [ -n "$VAR_DIR" ]; then
      mkdir -p "$VAR_DIR"
      __find_replace "REPLACE_VAR_DIR" "$VAR_DIR" "$set_dir"
    fi
    [ -n "$SERVICE_PORT" ] && __find_replace "REPLACE_SERVER_PORT" "${SERVICE_PORT:-80}" "$set_dir"
    [ -n "$HOSTNAME" ] && __find_replace "REPLACE_SERVER_NAME" "${FULL_DOMAIN_NAME:-$HOSTNAME}" "$set_dir"
    [ -n "$CONTAINER_NAME" ] && __find_replace "REPLACE_SERVER_SOFTWARE" "${CONTAINER_NAME:-docker}" "$set_dir"
    [ -n "$WWW_ROOT_DIR" ] && __find_replace "REPLACE_SERVER_WWW_DIR" "${WWW_ROOT_DIR:-/usr/local/share/httpd/default}" "$set_dir"
  done
  if [ -n "$WWW_ROOT_DIR" ] && [ "$set_dir" != "$WWW_ROOT_DIR" ] && [ -d "$WWW_ROOT_DIR" ]; then
    __find_replace "REPLACE_CONTAINER_IP4" "${REPLACE_CONTAINER_IP4:-127.0.0.1}" "$WWW_ROOT_DIR"
    __find_replace "REPLACE_COPYRIGHT_FOOTER" "${COPYRIGHT_FOOTER:-Copyright 1999 - $(date +'%Y')}" "$WWW_ROOT_DIR"
    __find_replace "REPLACE_LAST_UPDATED_ON_MESSAGE" "${LAST_UPDATED_ON_MESSAGE:-$(date +'Last updated on: %Y-%m-%d at %H:%M:%S')}" "$WWW_ROOT_DIR"
  fi
  mkdir -p "${TMP_DIR:-/tmp/$SERVICE_NAME}" "${RUN_DIR:-/run/$SERVICE_NAME}" "${LOG_DIR:-/data/logs/$SERVICE_NAME}"
  chmod -f 777 "${TMP_DIR:-/tmp/$SERVICE_NAME}" "${RUN_DIR:-/run/$SERVICE_NAME}" "${LOG_DIR:-/data/logs/$SERVICE_NAME}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_database() {
  [ "$IS_DATABASE_SERVICE" = "yes" ] || [ "$USES_DATABASE_SERVICE" = "yes" ] || return 0
  local dir="${1:-$ETC_DIR}"
  local db_normal_user="${DATABASE_USER_NORMAL:-$user_name}"
  local db_normal_pass="${DATABASE_PASS_NORMAL:-$user_pass}"
  local db_admin_user="${DATABASE_USER_ROOT:-$root_user_name}"
  local db_admin_pass="${DATABASE_PASS_ROOT:-$root_user_pass}"
  __find_replace "REPLACE_USER_NAME" "$db_normal_user" "$dir"
  __find_replace "REPLACE_USER_PASS" "$db_normal_pass" "$dir"
  __find_replace "REPLACE_DATABASE_USER" "$db_normal_user" "$dir"
  __find_replace "REPLACE_DATABASE_PASS" "$db_normal_pass" "$dir"
  __find_replace "REPLACE_ROOT_ADMIN" "$db_admin_user" "$dir"
  __find_replace "REPLACE_ROOT_PASS" "$db_admin_pass" "$dir"
  __find_replace "REPLACE_DATABASE_ROOT_USER" "$db_admin_user" "$dir"
  __find_replace "REPLACE_DATABASE_ROOT_PASS" "$db_admin_pass" "$dir"
  __find_replace "REPLACE_DATABASE_NAME" "$DATABASE_NAME" "$dir"
  __find_replace "REPLACE_DATABASE_DIR" "$DATABASE_DIR" "$dir"
  if [[ "$dir" == "/etc"* ]]; then
    __find_replace "REPLACE_USER_NAME" "$db_normal_user" "/etc"
    __find_replace "REPLACE_USER_PASS" "$db_normal_pass" "/etc"
    __find_replace "REPLACE_DATABASE_USER" "$db_normal_user" "/etc"
    __find_replace "REPLACE_DATABASE_PASS" "$db_normal_pass" "/etc"
    __find_replace "REPLACE_ROOT_ADMIN" "$db_admin_user" "/etc"
    __find_replace "REPLACE_ROOT_PASS" "$db_admin_pass" "/etc"
    __find_replace "REPLACE_DATABASE_ROOT_USER" "$db_admin_user" "/etc"
    __find_replace "REPLACE_DATABASE_ROOT_PASS" "$db_admin_pass" "/etc"
    __find_replace "REPLACE_DATABASE_NAME" "$DATABASE_NAME" "/etc"
    __find_replace "REPLACE_DATABASE_DIR" "$DATABASE_DIR" "/etc"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_db_users() {
  [ "$IS_DATABASE_SERVICE" = "yes" ] || [ "$USES_DATABASE_SERVICE" = "yes" ] || return 0
  db_normal_user="${DATABASE_USER_NORMAL:-$user_name}"
  db_normal_pass="${DATABASE_PASS_NORMAL:-$user_pass}"
  db_admin_user="${DATABASE_USER_ROOT:-$root_user_name}"
  db_admin_pass="${DATABASE_PASS_ROOT:-$root_user_pass}"
  export DATABASE_USER_NORMAL="$db_normal_user"
  export DATABASE_PASS_NORMAL="$db_normal_pass"
  export DATABASE_USER_ROOT="$db_admin_user"
  export DATABASE_PASS_ROOT="$db_admin_pass"
  export db_normal_user db_normal_pass db_admin_user db_admin_pass
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_system_etc() {
  local conf_dir="$1"
  local dir=""
  local files=""
  local directories=""
  if [ -n "$conf_dir" ] && [ -e "$conf_dir" ]; then
    files=$(find "$conf_dir"/* -not -path '*/env/*' -type f 2>/dev/null | sort -u | sed 's|/config/||')
    directories=$(find "$conf_dir"/* -not -path '*/env/*' -type d 2>/dev/null | sort -u | sed 's|/config/||')
    echo "Copying config files to system: $conf_dir > /etc/${conf_dir//\/config\//}"
    if [ -n "$directories" ]; then
      for d in $directories; do
        dir="/etc/$d"
        echo "Creating directory: $dir"
        mkdir -p "$dir"
      done
    fi
    for f in $files; do
      etc_file="/etc/$f"
      conf_file="/config/$f"
      [ -f "$etc_file" ] && __rm "$etc_file"
      __symlink "$etc_file" "$conf_file"
      __initialize_replace_variables "$conf_file" "$etc_file"
      [ -e "/data/$f" ] && __initialize_replace_variables "/data/$f"
    done
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_custom_bin_dir() {
  local SET_USR_BIN=""
  [ -d "/data/bin" ] && SET_USR_BIN+="$(__find /data/bin f) "
  [ -d "/config/bin" ] && SET_USR_BIN+="$(__find /config/bin f) "
  if [ -n "$SET_USR_BIN" ]; then
    echo "Setting up bin $SET_USR_BIN > $LOCAL_BIN_DIR"
    for create_bin_template in $SET_USR_BIN; do
      if [ -n "$create_bin_template" ]; then
        create_bin_name="${create_bin_template##*/}"
        if [ -e "$create_bin_template" ]; then
          ln -sf "$create_bin_template" "$LOCAL_BIN_DIR/$create_bin_name"
        fi
      fi
    done
    unset create_bin_template create_bin_name SET_USR_BIN
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_www_root() {
  local WWW_INIT=""
  local WWW_TEMPLATE=""
  [ -d "/usr/local/share/httpd/default" ] && WWW_TEMPLATE="/usr/local/share/httpd/default"
  [ "$WWW_ROOT_DIR" = "/app" ] && WWW_INIT="${WWW_INIT:-true}"
  [ "$WWW_ROOT_DIR" = "/data/htdocs" ] && WWW_INIT="${WWW_INIT:-true}"
  if __is_dir_empty "$WWW_ROOT_DIR/"; then
    WWW_INIT="true"
  else
    WWW_INIT="false"
  fi
  if [ "$WWW_INIT" = "true" ] && [ -d "$WWW_TEMPLATE" ]; then
    cp -Rf "$WWW_TEMPLATE/." "$WWW_ROOT_DIR/" 2>/dev/null
  fi
  __initialize_web_health "$WWW_ROOT_DIR"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__is_htdocs_mounted() {
  WWW_ROOT_DIR="${WWW_ROOT_DIR:-/data/htdocs}"
  [ -n "$ENV_WWW_ROOT_DIR" ] && WWW_ROOT_DIR="$ENV_WWW_ROOT_DIR"
  if [ -n "$IMPORT_FROM_GIT" ]; then
    if [[ ! "$IMPORT_FROM_GIT" =~ (https://|http://|git://|ssh://) ]]; then
      unset IMPORT_FROM_GIT
    fi
  fi
  if [ -n "$IMPORT_FROM_GIT" ] && command -v git &>/dev/null; then
    if __is_dir_empty "$WWW_ROOT_DIR"; then
      echo "Importing project from $IMPORT_FROM_GIT to $WWW_ROOT_DIR"
      git clone -q "$IMPORT_FROM_GIT" "$WWW_ROOT_DIR"
    elif [ -d "$WWW_ROOT_DIR" ]; then
      echo "Updating the project in $WWW_ROOT_DIR"
      git -C "$WWW_ROOT_DIR" pull -q
    fi
  elif [ -d "/app" ]; then
    WWW_ROOT_DIR="/app"
  elif [ -d "/data/htdocs/www" ]; then
    WWW_ROOT_DIR="/data/htdocs/www"
  elif [ -d "/data/htdocs/root" ]; then
    WWW_ROOT_DIR="/data/htdocs/root"
  elif [ -d "/data/htdocs" ]; then
    WWW_ROOT_DIR="/data/htdocs"
  elif [ -d "/data/wwwroot" ]; then
    WWW_ROOT_DIR="/data/wwwroot"
  fi
  [ -d "$WWW_ROOT_DIR" ] || mkdir -p "$WWW_ROOT_DIR"
  export WWW_ROOT_DIR="${WWW_ROOT_DIR:-/usr/local/share/httpd/default}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_ssl_certs() {
  [ -d "$SSL_DIR" ] || mkdir -p "$SSL_DIR"
  if [ "$SSL_ENABLED" = "yes" ]; then
    if [ -f "$SSL_CERT" ] && [ -f "$SSL_KEY" ]; then
      if [ -n "$SSL_CA" ] && [ -f "$SSL_CA" ]; then
        mkdir -p "$SSL_DIR/certs"
        cat "$SSL_CA" >>"/etc/ssl/certs/ca-certificates.crt"
      fi
      __update_ssl_certs
    else
      __create_ssl_cert
    fi
  fi
  type update-ca-certificates &>/dev/null && update-ca-certificates &>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__start_php_dev_server() {
  if [ "$2" = "yes" ]; then
    if [ -d "/usr/local/share/httpd" ]; then
      find "/usr/local/share/httpd" -type f -not -path '.git*' -iname '*.php' -exec sed -i 's|[<].*SERVER_ADDR.*[>]|'${CONTAINER_IP4_ADDRESS:-127.0.0.1}'|g' {} \; 2>/dev/null
      php -S 0.0.0.0:$PHP_DEV_SERVER_PORT -t "/usr/local/share/httpd"
    fi
    if [[ "$1" != "/usr/local/share/httpd"* ]]; then
      find "$1" -type f -not -path '.git*' -iname '*.php' -exec sed -i 's|[<].*SERVER_ADDR.*[>]|'${CONTAINER_IP4_ADDRESS:-127.0.0.1}'|g' {} \; 2>/dev/null
      php -S 0.0.0.0:$PHP_DEV_SERVER_PORT -t "$1"
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__check_service() {
  if [ "$1" = "check" ]; then
    shift $#
    __proc_check "$EXEC_CMD_NAME" || __proc_check "$EXEC_CMD_BIN"
    exit $?
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
__switch_to_user() {
  # Use SERVICE_USER if set, otherwise fall back to RUNAS_USER
  local switch_user="${SERVICE_USER:-$RUNAS_USER}"
  if [ "$switch_user" = "root" ]; then
    su_exec=""
    su_cmd() { eval "$@" || return 1; }
  elif command -v gosu &>/dev/null; then
    su_exec="gosu $switch_user"
    su_cmd() { $su_exec "$@" || return 1; }
  elif command -v runuser &>/dev/null; then
    su_exec="runuser -u $switch_user"
    su_cmd() { $su_exec "$@" || return 1; }
  elif command -v sudo &>/dev/null; then
    su_exec="sudo -u $switch_user"
    su_cmd() { $su_exec "$@" || return 1; }
  elif command -v su &>/dev/null; then
    su_exec="su -s /bin/sh - $switch_user"
    su_cmd() { $su_exec -c "$@" || return 1; }
  else
    su_exec=""
    su_cmd() {
      echo "Can not switch to $switch_user: attempting to run as root"
      if ! eval "$@"; then
        return 1
      fi
    }
  fi
  export su_exec
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# usage backup "days" "hours"
__backup() {
  local dirs="" backup_dir backup_name backup_exclude runTime cronTime maxDays
  if test -n "$1" && test -z "${1//[0-9]/}"; then
    maxDays="$1"
    shift 1
  else
    maxDays="7"
  fi
  if test -n "$1" && test -z "${1//[0-9]/}"; then
    cronTime="$1"
    shift 1
  else
    cronTime=""
  fi
  local exitCodeP=0
  local exitStatus=0
  local pidFile="/run/.backup.pid"
  local logDir="/data/log/backups"
  maxDays="${BACKUP_MAX_DAYS:-$maxDays}"
  cronTime="${BACKUP_RUN_CRON:-$cronTime}"
  backup_dir="$BACKUP_DIR/$(date +'%y/%m')"
  backup_name="$(date +'%d_%H-%M').tar.gz"
  backup_exclude="/data/logs $BACKUP_DIR $BACK_EXCLUDE_DIR"
  [ -d "/data" ] && dirs+="/data "
  [ -d "/config" ] && dirs+="/config "
  [ -d "$logDir" ] || mkdir -p "$logDir"
  [ -d "$backup_dir" ] || mkdir -p "$backup_dir"
  [ -z "$dirs" ] && echo "BACKUP_DIR is unset" >&2 && return 1
  [ -f "$pidFile" ] && echo "A backup job is already running" >&2 && return 1
  echo "$$" >"$pidFile"
  trap "rm -f '$pidFile'" EXIT INT TERM
  echo "Starting backup in $(date)" >>"$logDir/$CONTAINER_NAME"
  local tar_excludes=()
  for excl in $backup_exclude; do
    tar_excludes+=("--exclude=$excl")
  done
  tar "${tar_excludes[@]}" -cfvz "$backup_dir/$backup_name" $dirs 2>/dev/stderr >>"$logDir/$CONTAINER_NAME" || exitCodeP=1
  if [ $exitCodeP -eq 0 ]; then
    echo "Backup has completed and saved to: $backup_dir/$backup_name"
    printf '%s\n\n' "Backup has completed on $(date)" >>"$logDir/$CONTAINER_NAME"
  else
    __rm "${backup_dir:?}/$backup_name"
    echo "Backup has failed - log file saved to: $logDir/$CONTAINER_NAME" >&2
    printf '%s\n\n' "Backup has completed on $(date)" >>"$logDir/$CONTAINER_NAME"
    exitStatus=1
  fi
  [ -f "$pidFile" ] && __rm "$pidFile"
  [ -n "$maxDays" ] && find "$BACKUP_DIR" -mtime +"$maxDays" -exec rm -Rf {} \; >/dev/null 2>&1
  if [ -n "$cronTime" ]; then
    runTime=$((cronTime * 3600))
  else
    return $exitStatus
  fi
  sleep $runTime && __backup "$maxDays" "$cronTime"
}
# - - - - - - - - - - - - - - - - - - - - - - - - -
# set variables from function calls
export INIT_DATE="${INIT_DATE:-$(date)}"
export START_SERVICES="${START_SERVICES:-yes}"
export ENTRYPOINT_MESSAGE="${ENTRYPOINT_MESSAGE:-yes}"
export ENTRYPOINT_FIRST_RUN="${ENTRYPOINT_FIRST_RUN:-yes}"
export DATA_DIR_INITIALIZED="${DATA_DIR_INITIALIZED:-no}"
export CONFIG_DIR_INITIALIZED="${CONFIG_DIR_INITIALIZED:-no}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# System
export LANG="${LANG:-C.UTF-8}"
export LC_ALL="${LANG:-C.UTF-8}"
export TZ="${TZ:-${TIMEZONE:-America/New_York}}"
export HOSTNAME="${FULL_DOMAIN_NAME:-${SERVER_HOSTNAME:-$HOSTNAME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Default directories
export SSL_DIR="${SSL_DIR:-/config/ssl}"
export SSL_CA="${SSL_CA:-/config/ssl/ca.crt}"
export SSL_KEY="${SSL_KEY:-/config/ssl/localhost.pem}"
export SSL_CERT="${SSL_CERT:-/config/ssl/localhost.crt}"
export LOCAL_BIN_DIR="${LOCAL_BIN_DIR:-/usr/local/bin}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Backup settings
export BACKUP_MAX_DAYS="${BACKUP_MAX_DAYS:-}"
export BACKUP_RUN_CRON="${BACKUP_RUN_CRON:-}"
export BACKUP_DIR="${BACKUP_DIR:-/data/backups}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_IP4_ADDRESS="${CONTAINER_IP4_ADDRESS:-$(__get_ip4)}"
CONTAINER_IP6_ADDRESS="${CONTAINER_IP6_ADDRESS:-$(__get_ip6)}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional
export WORK_DIR="${ENV_WORK_DIR:-$WORK_DIR}"
export SET_RANDOM_PASS="${SET_RANDOM_PASS:-$(__random_password 16)}"
export PHP_INI_DIR="${PHP_INI_DIR:-$(__find_php_ini)}"
export PHP_BIN_DIR="${PHP_BIN_DIR:-$(__find_php_bin)}"
export HTTPD_CONFIG_FILE="${HTTPD_CONFIG_FILE:-$(__find_httpd_conf)}"
export NGINX_CONFIG_FILE="${NGINX_CONFIG_FILE:-$(__find_nginx_conf)}"
export MYSQL_CONFIG_FILE="${MYSQL_CONFIG_FILE:-$(__find_mysql_conf)}"
export PGSQL_CONFIG_FILE="${PGSQL_CONFIG_FILE:-$(__find_pgsql_conf)}"
export LIGHTTPD_CONFIG_FILE="${LIGHTTPD_CONFIG_FILE:-$(__find_lighttpd_conf)}"
export MARIADB_CONFIG_FILE="${MARIADB_CONFIG_FILE:-$(__find_mysql_conf)}"
export POSTGRES_CONFIG_FILE="${POSTGRES_CONFIG_FILE:-$(__find_pgsql_conf)}"
export MONGODB_CONFIG_FILE="${MONGODB_CONFIG_FILE:-$(__find_mongodb_conf)}"
export ENTRYPOINT_PID_FILE="${ENTRYPOINT_PID_FILE:-/run/.entrypoint.pid}"
export ENTRYPOINT_INIT_FILE="${ENTRYPOINT_INIT_FILE:-/config/.entrypoint.done}"
export ENTRYPOINT_DATA_INIT_FILE="${ENTRYPOINT_DATA_INIT_FILE:-/data/.docker_has_run}"
export ENTRYPOINT_CONFIG_INIT_FILE="${ENTRYPOINT_CONFIG_INIT_FILE:-/config/.docker_has_run}"
# - - - - - - - - - - - - - - - - - - - - - - - - -
# is already Initialized
if [ -z "$DATA_DIR_INITIALIZED" ]; then
  if [ -f "$ENTRYPOINT_DATA_INIT_FILE" ]; then
    DATA_DIR_INITIALIZED="yes"
  else
    DATA_DIR_INITIALIZED="no"
  fi
fi
if [ -z "$CONFIG_DIR_INITIALIZED" ]; then
  if [ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ]; then
    CONFIG_DIR_INITIALIZED="yes"
  else
    CONFIG_DIR_INITIALIZED="no"
  fi
fi
if [ -z "$ENTRYPOINT_FIRST_RUN" ]; then
  if [ -f "$ENTRYPOINT_PID_FILE" ] || [ -f "$ENTRYPOINT_INIT_FILE" ]; then
    ENTRYPOINT_FIRST_RUN="no"
  else
    ENTRYPOINT_FIRST_RUN="yes"
  fi
fi
export ENTRYPOINT_DATA_INIT_FILE DATA_DIR_INITIALIZED ENTRYPOINT_CONFIG_INIT_FILE CONFIG_DIR_INITIALIZED
export ENTRYPOINT_PID_FILE ENTRYPOINT_INIT_FILE ENTRYPOINT_FIRST_RUN
# - - - - - - - - - - - - - - - - - - - - - - - - -
# export the functions
export -f __get_pid __start_init_scripts __is_running __update_ssl_certs __create_ssl_cert
# - - - - - - - - - - - - - - - - - - - - - - - - -
# end of functions
