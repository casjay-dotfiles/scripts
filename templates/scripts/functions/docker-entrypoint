#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202308281453-git
# @@Author           :  Jason Hempstead
# @@Contact          :  git-admin@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  docker-entrypoint --help
# @@Copyright        :  Copyright: (c) 2023 Jason Hempstead, Casjays Developments
# @@Created          :  Monday, Aug 28, 2023 14:53 EDT
# @@File             :  docker-entrypoint
# @@Description      :  functions for my docker containers
# @@Changelog        :  newScript
# @@TODO             :  Refactor code
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  functions/docker-entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC2016
# shellcheck disable=SC2031
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# shellcheck disable=SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -o pipefail -x$DEBUGGER_OPTIONS || set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__printf_space() { printf "%-${1:-30}s%s\n" "${2}" "${3}"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cd() { [ -d "$1" ] && builtin cd "$1" || return 1; }
__rm() { [ -n "$1" ] && [ -e "$1" ] && rm -Rf "${1:?}"; }
__grep_test() { grep -s "$1" "$2" | grep -qwF "${3:-$1}" || return 1; }
__netstat() { [ -f "$(type -P netstat)" ] && netstat "$@" || return 10; }
__is_in_file() { [ -e "$2" ] && grep -Rsq "$1" "$2" && return 0 || return 1; }
__curl() { curl -q -sfI --max-time 3 -k -o /dev/null "$@" &>/dev/null || return 10; }
__find() { find "$1" -mindepth 1 -type ${2:-f,d} 2>/dev/null | grep '^' || return 10; }
__is_dir_empty() { [ "$(ls -A "$1" 2>/dev/null | wc -l)" -eq 0 ] && return 0 || return 1; }
__pcheck() { [ -n "$(which pgrep 2>/dev/null)" ] && pgrep -o "$1" &>/dev/null || return 10; }
__file_exists_with_content() { [ -n "$1" ] && [ -f "$1" ] && [ -s "$1" ] && return 0 || return 2; }
__sed() { sed -i 's|'$1'|'$2'|g' "$3" &>/dev/null || sed -i "s|$1|$2|g" "$3" &>/dev/null || return 1; }
__ps() { [ -f "$(type -P ps)" ] && ps "$@" 2>/dev/null | grep -Fw " ${1:-$GEN_SCRIPT_REPLACE_APPNAME}" || return 10; }
__pgrep() { __pcheck "${1:-GEN_SCRIPT_REPLACE_APPNAME}" || __ps "${1:-$GEN_SCRIPT_REPLACE_APPNAME}" | grep -qv ' grep' || return 10; }
__get_ip6() { ip a 2>/dev/null | grep -w 'inet6' | awk '{print $2}' | grep -vE '^::1|^fe' | sed 's|/.*||g' | head -n1 | grep '^' || echo ''; }
__get_ip4() { ip a 2>/dev/null | grep -w 'inet' | awk '{print $2}' | grep -vE '^127.0.0' | sed 's|/.*||g' | head -n1 | grep '^' || echo '127.0.0.1'; }
__find_file_relative() { find "$1"/* -not -path '*env/*' -not -path '.git*' -type f 2>/dev/null | sed 's|'$1'/||g' | sort -u | grep -v '^$' | grep '^' || false; }
__find_directory_relative() { find "$1"/* -not -path '*env/*' -not -path '.git*' -type d 2>/dev/null | sed 's|'$1'/||g' | sort -u | grep -v '^$' | grep '^' || false; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__format_variables() { printf '%s\n' "${@//,/ }" | tr ' ' '\n' | sort -RVu | grep -v '^$' | tr '\n' ' ' | __clean_variables | grep '^' || return 3; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__clean_variables() {
  local var="$*"
  var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
  var="$(printf '%s\n' "$var" | sed 's/\( \)*/\1/g;s|^ ||g')"
  printf '%s' "$var" | grep -v '^$'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__no_exit() {
  [ -f "/run/no_exit.pid" ] && return
  exec /bin/sh -c "trap 'sleep 1;rm -Rf /run/no_exit.pid;exit 0' TERM INT;(while true; do echo $!>/run/no_exit.pid;tail -qf /data/logs/entrypoint.log /data/logs/*/*log 2>/dev/null||sleep 20; done) & wait"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_php_bin() { find -L '/usr'/*bin -maxdepth 4 -name 'php-fpm*' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_php_ini() { find -L '/etc' -maxdepth 4 -name 'php.ini' 2>/dev/null | head -n1 | sed 's|/php.ini||g' | grep '^' || echo ''; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_nginx_conf() { find -L '/etc' -maxdepth 4 -name 'nginx.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_caddy_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'caddy.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_lighttpd_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'lighttpd.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_cherokee_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'cherokee.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_httpd_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'httpd.conf' -o -iname 'apache2.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_mysql_conf() { find -L '/etc' -maxdepth 4 -type f -name 'my.cnf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_pgsql_conf() { find -L '/var/lib' '/etc' -maxdepth 8 -type f -name 'postgresql.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_couchdb_conf() { return; }
__find_mongodb_conf() { return; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__random_password() { cat "/dev/urandom" | tr -dc '0-9a-zA-Z' | head -c${1:-16} && echo ""; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__exec_service() {
  echo "Starting $1"
  eval "$@" 2>>/dev/stderr &
  [ $? -eq 0 ] && touch "/run/init.d/$1.pid" || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__update_ssl_certs() {
  [ -f "/config/env/ssl.sh" ] && . "/config/env/ssl.sh"
  if [ -f "$SSL_CERT" ] && [ -f "$SSL_KEY" ]; then
    mkdir -p /etc/ssl
    [ -f "$SSL_CA" ] && cp -Rf "$SSL_CA" "/etc/ssl/$SSL_CA"
    [ -f "$SSL_KEY" ] && cp -Rf "$SSL_KEY" "/etc/ssl/$SSL_KEY"
    [ -f "$SSL_CERT" ] && cp -Rf "$SSL_CERT" "/etc/ssl/$SSL_CERT"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__certbot() {
  local statusCode=0
  CERTBOT_DOMAINS="${CERTBOT_DOMAINS:-$HOSTNAME}"
  [ -n "$(type -P 'certbot')" ] || return 1
  if [ -f "/config/certbot/env.sh" ]; then
    . "/config/certbot/env.sh"
  fi
  if [ -f "/config/certbot/setup.sh" ]; then
    eval "/config/certbot/setup.sh"
    statusCode=$?
  elif [ -f "/etc/named/certbot.sh" ]; then
    eval "/etc/named/certbot.sh"
    statusCode=$?
  elif [ -f "/config/named/certbot-update.conf" ]; then
    if certbot renew -n --dry-run --agree-tos --expand --dns-rfc2136 --dns-rfc2136-credentials /config/named/certbot-update.conf; then
      certbot renew -n --agree-tos --expand --dns-rfc2136 --dns-rfc2136-credentials /config/named/certbot-update.conf
    fi
    statusCode=$?
  else
    local options="${1:-create}" && shift 1
    domain_list="$DOMAINNAME www.$DOMAINNAME mail.$DOMAINNAME $CERTBOT_DOMAINS"
    [ -f "/config/env/ssl.sh" ] && . "/config/env/ssl.sh"
    [ "$CERT_BOT_ENABLED" = "true" ] || { export CERT_BOT_ENABLED="" && return 10; }
    [ -n "$CERT_BOT_MAIL" ] || echo "The variable CERT_BOT_MAIL is not set" && return 1
    [ -n "$DOMAINNAME" ] || echo "The variable DOMAINNAME is not set" && return 1
    for domain in $$CERTBOT_DOMAINS; do
      [ -n "$domain" ] && ADD_CERTBOT_DOMAINS="-d $domain "
    done
    certbot $options --agree-tos -m $CERT_BOT_MAIL certonly --webroot \
      -w "${WWW_ROOT_DIR:-/usr/share/httpd/default}" $ADD_CERTBOT_DOMAINS \
      --key-path "$SSL_KEY" --fullchain-path "$SSL_CERT"
    statusCode=$?
  fi
  [ $statusCode -eq 0 ] && __update_ssl_certs
  return $statusCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_ssl_cert() {
  if ! __certbot create; then
    [ -f "/config/env/ssl.sh" ] && . "/config/env/ssl.sh"
    [ -n "$SSL_DIR" ] || { echo "SSL_DIR is unset" && return 1; }
    [ -d "$SSL_DIR" ] || mkdir -p "$SSL_DIR"
    if [ -n "$FORCE_SSL" ] || [ ! -f "$SSL_CERT" ] || [ ! -f "$SSL_KEY" ]; then
      echo "Setting Country to $COUNTRY and Setting State/Province to $STATE and Setting City to $CITY"
      echo "Setting OU to $UNIT and Setting ORG to $ORG and Setting server to $CN"
      echo "All variables can be overwritten by creating a /config/.ssl.env and setting the variables there"
      echo "Creating ssl key and certificate in $SSL_DIR and will be valid for $((VALID_FOR / 365)) year[s]"
      #
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
  fi
  if [ -f "$SSL_CERT" ] && [ -f "$SSL_KEY" ]; then
    __update_ssl_certs
    return 0
  else
    return 2
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_apache() {
  local etc_dir="" conf_dir="" conf_dir="" www_dir="" apache_bin=""
  etc_dir="/etc/${1:-apache2}"
  conf_dir="/config/${1:-apache2}"
  www_dir="${WWW_ROOT_DIR:-/data/htdocs}"
  apache_bin="$(type -P 'httpd' || type -P 'apache2')"
  #
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_nginx() {
  local etc_dir="" conf_dir="" www_dir="" nginx_bin=""
  etc_dir="/etc/${1:-nginx}"
  conf_dir="/config/${1:-nginx}"
  www_dir="${WWW_ROOT_DIR:-/data/htdocs}"
  nginx_bin="$(type -P 'nginx')"
  #
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_php() {
  local etc_dir="/etc/${1:-php}"
  local conf_dir="/config/${1:-php}"
  local php_bin="${PHP_BIN_DIR:-$(__find_php_bin)}"
  #
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_mysql() {
  local db_dir="" etc_dir="" db_user="" conf_dir="" user_pass="" user_db="" root_pass="" mysqld_bin=""
  db_dir="/data/db/mysql"
  etc_dir="${home:-/etc/${1:-mysql}}"
  db_user="${SERVICE_USER:-mysql}"
  conf_dir="/config/${1:-mysql}"
  user_pass="${MARIADB_PASSWORD:-$MARIADB_ROOT_PASSWORD}"
  user_db="${MARIADB_DATABASE}" user_name="${MARIADB_USER:-root}"
  root_pass="$MARIADB_ROOT_PASSWORD"
  mysqld_bin="$(type -P 'mysqld')"
  #
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_mongodb() {
  local home="${MONGODB_CONFIG_FILE:-$(__find_mongodb_conf)}"
  local user_pass="${MONGO_INITDB_ROOT_PASSWORD:-$_ROOT_PASSWORD}"
  local user_name="${INITDB_ROOT_USERNAME:-root}"
  #
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_postgres() {
  local home="${PGSQL_CONFIG_FILE:-$(__find_pgsql_conf)}"
  local user_pass="${POSTGRES_PASSWORD:-$POSTGRES_ROOT_PASSWORD}"
  local user_name="${POSTGRES_USER:-root}"
  #
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_couchdb() {
  local home="${COUCHDB_CONFIG_FILE:-$(__find_couchdb_conf)}"
  local user_pass="${COUCHDB_PASSWORD:-$SET_RANDOM_PASS}"
  local user_name="${COUCHDB_USER:-root}"
  #
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show available init functions
__init_help() {
  echo '
__certbot
__update_ssl_certs
__create_ssl_cert
'
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_once() {
  if [ "$CONFIG_DIR_INITIALIZED" = "false" ] || [ "$DATA_DIR_INITIALIZED" = "false" ] || [ ! -f "/config/.docker_has_run" ]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run program ever n minutes
__cron() {
  trap '[ -f "/run/cron/$cmd" ] && rm -Rf "/run/cron/$cmd";exit 0' SIGINT ERR EXIT
  test -n "$1" && test -z "${1//[0-9]/}" && interval=$(($1 * 60)) && shift 1 || interval="5"
  [ $# -eq 0 ] && echo "Usage: cron [interval] [command]" && exit 1
  command="$*"
  cmd="${CRON_NAME:-$(echo "$command" | awk -F' ' '{print $1}')}"
  [ -d "/run/cron" ] || mkdir -p "/run/cron"
  echo "$command" >"/run/cron/$cmd"
  while :; do
    eval "$command"
    sleep $interval
    [ -f "/run/cron/$cmd" ] || break
  done |& tee -p /data/logs/cron.log
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__replace() {
  [ $# -eq 3 ] && [ -e "$3" ] || return 1
  grep -s -qR "$1" "$3" &>/dev/null && __sed "$1" "$2" "$3" || return 0
  grep -s -qR "$2" "$3" && printf '%s\n' "Changed $1 to $2 in $3" && return 0 || {
    printf '%s\n' "Failed to change $1 in $3" >&2 && return 2
  }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_replace() {
  [ $# -eq 3 ] && [ -e "$3" ] || return 1
  grep -s -qR "$1" "$3" &>/dev/null || return 0
  find "$3" -type f -not -path '.git*' -exec sed -i "s|$1|$2|g" {} \;
  grep -s -qR "$2" "$3" && printf '%s\n' "Changed $1 to $2 in $3" && return 0 || {
    printf '%s\n' "Failed to change $1 in $3" >&2 && return 2
  }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# /config > /etc
__copy_templates() {
  if [ -e "$1" ] && __is_dir_empty "$2"; then
    __file_copy "$1" "$2"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# /config/file > /etc/file
__symlink() {
  if [ -e "$2" ]; then
    [ -e "$1" ] && rm -rf "$1"
    ln -sf "$2" "$1" && echo "Created symlink to $1 > $2"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__file_copy() {
  if [ -n "$1" ] && [ -e "$1" ] && [ -n "$2" ]; then
    if [ -d "$1" ]; then
      if cp -Rf "$1/." "$2/" &>/dev/null; then
        printf '%s\n' "Copied: $1 > $2"
        return 0
      else
        printf '%s\n' "Copy failed: $1 < $2" >&2
        return 1
      fi
    else
      if cp -Rf "$1" "$2" &>/dev/null; then
        printf '%s\n' "Copied: $1 > $2"
        return 0
      else
        printf '%s\n' "Copy failed: $1 < $2" >&2
        return 1
      fi
    fi
  else
    printf '%s\n' "$1 does not exist"
    return 2
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__generate_random_uids() {
  local set_random_uid="$(seq 3000 50000 | sort -R | head -n 1)"
  while :; do
    if ! grep -qs "x:.*:$set_random_uid:" "/etc/group" && ! grep -sq "x:$set_random_uid:.*:" "/etc/passwd"; then
      echo "$set_random_uid"
      break
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__set_user_group_id() {
  local set_user="${1:-$SERVICE_USER}"
  local set_uid="${2:-${SERVICE_UID:-10000}}"
  local set_gid="${3:-${SERVICE_GID:-10000}}"
  local random_id="$(__generate_random_uids)"
  local exitStatus=0
  [ -n "$set_user" ] && [ -n "$set_uid" ] && [ -n "$set_gid" ] || return
  [ -n "$set_user" ] && [ "$set_user" != "root" ] || return
  if [ -z "$set_uid" ] || [ "$set_uid" = "0" ]; then
    set_uid="$random_id"
  fi
  if [ -z "$set_gid" ] || [ "$set_gid" = "0" ]; then
    set_gid="$random_id"
  fi
  if grep -sq "^$set_user:" "/etc/passwd" "/etc/group"; then
    if ! grep -sq "x:.*:$set_gid:" "/etc/group"; then
      groupmod -g "${set_gid}" $set_user | tee -p -a "${LOG_DIR/tmp/}/init.txt" &>/dev/null
    fi
    if ! grep -sq "x:$set_uid:.*:" "/etc/passwd"; then
      usermod -u "${set_uid}" -g "${set_gid}" $set_user | tee -p -a "${LOG_DIR/tmp/}/init.txt" &>/dev/null
    fi
  fi
  export SERVICE_UID="$set_uid"
  export SERVICE_GID="$set_gid"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_service_user() {
  local create_user="${1:-$SERVICE_USER}"
  local create_group="${2:-$SERVICE_GROUP}"
  local create_home_dir="${3:-${WORK_DIR:-/home/$create_user}}"
  local create_uid="${SERVICE_UID:-${USER_UID:-${4:-10000}}}"
  local create_gid="${SERVICE_GID:-${USER_GID:-${5:-10000}}}"
  local random_id="$(__generate_random_uids)"
  local set_home_dir=""
  local exitStatus=0
  [ -n "$create_user" ] && [ -n "$create_group" ] && [ "$create_user" != "root" ] || return 0
  if [ -z "$create_uid" ] || [ "$create_uid" = "0" ]; then
    create_uid="$random_id"
  fi
  if [ -z "$create_gid" ] || [ "$create_gid" = "0" ]; then
    create_gid="$random_id"
  fi
  if ! grep -sq "$create_group" "/etc/group"; then
    echo "creating system group $create_group"
    groupadd -g $create_gid $create_group | tee -p -a "${LOG_DIR/tmp/}/init.txt" &>/dev/null
  fi
  if ! grep -sq "$create_user" "/etc/passwd"; then
    echo "creating system user $create_user"
    useradd -u $create_uid -g $create_gid -c "Account for $create_user" -d "$create_home_dir" -s /bin/false $create_user | tee -p -a "$LOG_DIR/tmp/init.txt" &>/dev/null
  fi
  grep -qs "$create_group" "/etc/group" || exitStatus=$((exitCode + 1))
  grep -qs "$create_user" "/etc/passwd" || exitStatus=$((exitCode + 1))
  [ $exitStatus -eq 0 ] && export WORK_DIR="${set_home_dir:-}"
  export SERVICE_UID="$create_uid"
  export SERVICE_GID="$create_gid"
  return $exitStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
      cat <<EOF | tee -p "$create_env" &>/dev/null
$(<"$sample_file")
EOF
    fi
    [ -f "$create_env" ] || envStatus=$((1 + envStatus))
  done
  rm -f "$sample_file"
  return $envStatus
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__exec_command() {
  local arg=("$@")
  local prog_bin=""
  local exitCode="0"
  local cmdExec="${arg:-}"
  prog_bin="$(echo "${arg[@]}" | tr ' ' '\n' | grep -v '^$' | head -n1 || echo '')"
  [ -n "$prog_bin" ] && prog="$(type -P "${prog_bin}" 2>/dev/null || echo ':ERROR:')" || prog="bash"
  if [ -f "$prog" ]; then
    echo "${exec_message:-Executing command: $cmdExec}"
    eval $cmdExec || exitCode=1
    [ "$exitCode" = 0 ] || exitCode=10
  elif [ -f "$prog" ] && [ ! -x "$prog" ]; then
    echo "$prog is not executable"
    exitCode=4
  else
    echo "$prog does not exist"
    exitCode=5
  fi
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup the server init scripts
__start_init_scripts() {
  [ "$1" = " " ] && shift 1
  [ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -o pipefail -x$DEBUGGER_OPTIONS || set -o pipefail
  local basename=""
  local init_pids=""
  local init_dir="${1:-/usr/local/etc/docker/init.d}"
  local init_count="$(ls -A "$init_dir"/* 2>/dev/null | grep -v '\.sample' | wc -l)"
  mkdir -p "/tmp" "/run" "/run/init.d"
  chmod -R 777 "/tmp" "/run" "/run/init.d"
  if [ "$init_count" -eq 0 ] || [ ! -d "$init_dir" ]; then
    mkdir -p "/data/logs/init"
    while :; do echo "Running" >"/data/logs/init/keep_alive" && sleep 3600; done &
  else
    if [ -d "$init_dir" ]; then
      chmod -Rf 755 "$init_dir/"
      [ -f "$init_dir/service.sample" ] && rm -Rf "$init_dir/service.sample"
      for init in "$init_dir"/*.sh; do
        if [ -f "$init" ]; then
          name="$(basename "$init")"
          (eval "$init" &)
          initStatus=$(($? + initStatus))
          sleep 10
          echo ""
        fi
      done
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
  echo "$EMAIL_RELAY" | grep '[0-9][0-9]' || relay_port="465"
  ################# sSMTP relay setup
  if [ -n "$(type -P 'ssmtp')" ]; then
    [ -d "/config/ssmtp" ] || mkdir -p "/config/ssmtp"
    [ -f "/etc/ssmtp/ssmtp.conf" ] && rm -Rf "/etc/ssmtp/ssmtp.conf"
    symlink_files="$(__find_file_relative "/config/ssmtp")"
    if [ ! -f "/config/ssmtp/ssmtp.conf" ]; then
      cat <<EOF | tee -p "/config/ssmtp/ssmtp.conf" &>/dev/null
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
      echo "Done setting up ssmtp"
    fi

    ################# postfix relay setup
  elif [ -n "$(type -P 'postfix')" ]; then
    [ -d "/etc/postfix" ] || mkdir -p "/etc/postfix"
    [ -d "/config/postfix" ] || mkdir -p "/config/postfix"
    [ -f "/etc/postfix/main.cf" ] && rm -Rf "/etc/postfix/main.cf"
    symlink_files="$(__find_file_relative "/config/postfix")"
    if [ ! -f "/config/postfix/main.cf" ]; then
      cat <<EOF | tee -p "/config/postfix/main.cf" &>/dev/null
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
      touch "/config/postfix/aliases" "/config/postfix/mynetworks" "/config/postfix/transport"
      touch "/config/postfix/mydomains.pcre" "/config/postfix/mydomains" "/config/postfix/virtual"
      postmap "/config/aliases" "/config/mynetworks" "/config/transport" &>/dev/null
      postmap "/config/mydomains.pcre" "/config/mydomains" "/config/virtual" &>/dev/null
      for f in $symlink_files; do
        __symlink "/config/postfix/$f" "/etc/postfix/$f"
        __initialize_replace_variables "/etc/postfix/$f"
      done
    fi
    if [ -f "/etc/postfix/main.cf" ] && [ ! -f "/run/init.d/postfix.pid" ]; then
      SERVICES_LIST+="postfix "
      if [ ! -f "/run/init.d/postfix.pid" ]; then
        __exec_service postfix start
      fi
      echo "Done setting up postfix"
    fi
  fi
  [ -f "/root/dead.letter" ] && rm -Rf "/root/dead.letter"
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_web_health() {
  [ $# -eq 1 ] && [ -d "$1" ] || return 1
  if ! echo "$1" | grep -q '/usr/share/httpd'; then
    [ -d "$1/health" ] || mkdir -p "$1/health"
    [ -f "$1/health/index.txt" ] || echo 'OK' >"$1/health/index.txt"
    [ -f "$1/health/index.json" ] || echo '{ "status": "OK" }' >"$1/health/index.json"
    __find_replace "REPLACE_CONTAINER_IP4" "${REPLACE_CONTAINER_IP4:-127.0.0.1}" "$1"
    __find_replace "REPLACE_COPYRIGHT_FOOTER" "${COPYRIGHT_FOOTER:-Copyright 1999 - $(date +'%Y')}" "$1"
    __find_replace "REPLACE_LAST_UPDATED_ON_MESSAGE" "${LAST_UPDATED_ON_MESSAGE:-$(date +'Last updated on: %Y-%m-%d at %H:%M:%S')}" "$1"
  fi
  if [ -d "/usr/share/httpd" ]; then
    __find_replace "REPLACE_CONTAINER_IP4" "${REPLACE_CONTAINER_IP4:-127.0.0.1}" "/usr/share/httpd"
    __find_replace "REPLACE_COPYRIGHT_FOOTER" "${COPYRIGHT_FOOTER:-Copyright 1999 - $(date +'%Y')}" "/usr/share/httpd"
    __find_replace "REPLACE_LAST_UPDATED_ON_MESSAGE" "${LAST_UPDATED_ON_MESSAGE:-$(date +'Last updated on: %Y-%m-%d at %H:%M:%S')}" "/usr/share/httpd"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  file_dir
__initialize_replace_variables() {
  [ $# -ne 0 ] || return 1 # REPLACE_GITEA_PROTO
  __find_replace "REPLACE_SSL_DIR" "${SSL_DIR:-/etc/ssl}" "$1"
  __find_replace "REPLACE_RANDOM_ID" "$(__random_password 8)" "$1"
  __find_replace "REPLACE_TZ" "${TZ:-${TIMEZONE:-America/New_York}}" "$1"
  __find_replace "REPLACE_SERVER_PROTO" "${SERVICE_PROTOCOL:-http}" "$1"
  __find_replace "REPLACE_SERVER_SITE_TITLE" "${SERVER_SITE_TITLE:-CasjaysDev - Docker Container}" "$1"
  __find_replace "REPLACE_TMP_DIR" "${TMP_DIR:-/tmp/$SERVICE_NAME}" "$1"
  __find_replace "REPLACE_RUN_DIR" "${RUN_DIR:-/run/$SERVICE_NAME}" "$1"
  __find_replace "REPLACE_LOG_DIR" "${LOG_DIR:-/data/log/$SERVICE_NAME}" "$1"
  __find_replace "REPLACE_ETC_DIR" "${ETC_DIR:-/etc/$SERVICE_NAME}" "$1"
  __find_replace "REPLACE_DATA_DIR" "${DATA_DIR:-/data/$SERVICE_NAME}" "$1"
  __find_replace "REPLACE_CONFIG_DIR" "${CONF_DIR:-/config/$SERVICE_NAME}" "$1"
  __find_replace "REPLACE_EMAIL_RELAY" "${EMAIL_RELAY:-172.17.0.1}" "$1"
  __find_replace "REPLACE_SERVER_ADMIN" "${SERVER_ADMIN:-root@${EMAIL_DOMAIN:-${FULL_DOMAIN_NAME:-$HOSTNAME}}}" "$1"
  __find_replace "REPLACE_WWW_USER" "${SERVICE_USER:-${RUNAS_USER:-root}}" "$1"
  __find_replace "REPLACE_APP_USER" "${SERVICE_USER:-${RUNAS_USER:-root}}" "$1"
  __find_replace "REPLACE_WWW_GROUP" "${SERVICE_GROUP:-${SERVICE_USER:-${RUNAS_USER:-root}}}" "$1"
  __find_replace "REPLACE_APP_GROUP" "${SERVICE_GROUP:-${SERVICE_USER:-${RUNAS_USER:-root}}}" "$1"
  [ -n "$SERVICE_PORT" ] && __find_replace "REPLACE_SERVER_PORT" "${SERVICE_PORT:-80}" "$1"             # ||{ [ "$DEBUGGER" = "on" ] && echo "SERVICE_PORT is not set": }
  [ -n "$HOSTNAME" ] && __find_replace "REPLACE_SERVER_NAME" "${FULL_DOMAIN_NAME:-$HOSTNAME}" "$1"      # ||{ [ "$DEBUGGER" = "on" ] && echo "HOSTNAME is not set": }
  [ -n "$CONTAINER_NAME" ] && __find_replace "REPLACE_SERVER_SOFTWARE" "${CONTAINER_NAME:-docker}" "$1" # ||{ [ "$DEBUGGER" = "on" ] && echo "CONTAINER_NAME is not set": }
  [ -n "$WWW_ROOT_DIR" ] && __find_replace "REPLACE_SERVER_WWW_DIR" "${WWW_ROOT_DIR:-/usr/share/httpd/default}" "$1"
  mkdir -p "${TMP_DIR:-/tmp/$SERVICE_NAME}" "${RUN_DIR:-/run/$SERVICE_NAME}" "${LOG_DIR:-/data/log/$SERVICE_NAME}"
  chmod -f 777 "${TMP_DIR:-/tmp/$SERVICE_NAME}" "${RUN_DIR:-/run/$SERVICE_NAME}" "${LOG_DIR:-/data/log/$SERVICE_NAME}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_database() {
  [ -n "$user_name" ] && __replace "REPLACE_USER_NAME" "$user_name" "$1"
  [ -n "$user_pass" ] && __replace "REPLACE_USER_PASS" "$user_pass" "$1"
  [ -n "$user_name" ] && __replace "REPLACE_DATABASE_USER" "$user_name" "$1"
  [ -n "$user_pass" ] && __replace "REPLACE_DATABASE_PASS" "$user_pass" "$1"
  [ -n "$root_user_name" ] && __replace "REPLACE_ROOT_ADMIN" "$root_user_name" "$1"
  [ -n "$root_user_pass" ] && __replace "REPLACE_ROOT_PASS" "$root_user_pass" "$1"
  [ -n "$root_user_name" ] && __replace "REPLACE_DATABASE_ROOT_USER" "$root_user_name" "$1"
  [ -n "$root_user_pass" ] && __replace "REPLACE_DATABASE_ROOT_PASS" "$root_user_pass" "$1"
  [ -n "$DATABASE_NAME" ] && __replace "REPLACE_DATABASE_NAME" "$DATABASE_NAME" "$1"
  [ -n "$DATABASE_DIR" ] && __replace "REPLACE_DATABASE_DIR" "$DATABASE_DIR" "$1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_system_etc() {
  local conf_dir="$1"
  local file="" directories=""
  if [ -n "$conf_dir" ] && [ -e "$conf_dir" ]; then
    files="$(find "$conf_dir"/* -not -path '*/env/*' -type f 2>/dev/null | sed 's|'/config/'||g' | sort -u | grep -v '^$' | grep '^' || false)"
    directories="$(find "$conf_dir"/* -not -path '*/env/*' -type d 2>/dev/null | sed 's|'/config/'||g' | sort -u | grep -v '^$' | grep '^' || false)"
    echo "Copying config files to system: $conf_dir > /etc/${conf_dir//\/config\//}"
    if [ -n "$directories" ]; then
      for d in $directories; do
        echo "Creating directory: /etc/$d"
        mkdir -p "/etc/$directories"
      done
    fi
    for f in $files; do
      etc_file="/etc/$f"
      conf_file="/config/$f"
      [ -f "$etc_file" ] && rm -Rf "$etc_file"
      __symlink "$etc_file" "$conf_file"
      __initialize_replace_variables "$etc_file"
    done
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_custom_bin_dir() {
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
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_default_templates() {
  if [ -n "$DEFAULT_TEMPLATE_DIR" ]; then
    if [ "$CONFIG_DIR_INITIALIZED" = "false" ] && [ -d "/config" ]; then
      echo "Copying default config files $DEFAULT_TEMPLATE_DIR > /config"
      for create_config_template in "$DEFAULT_TEMPLATE_DIR"/*; do
        if [ -n "$create_config_template" ]; then
          create_template_name="$(basename "$create_config_template")"
          if [ -d "$create_config_template" ]; then
            mkdir -p "/config/$create_template_name/"
            __is_dir_empty "/config/$create_template_name" && cp -Rf "$create_config_template/." "/config/$create_template_name/" 2>/dev/null
          elif [ -e "$create_config_template" ]; then
            [ -e "/config/$create_template_name" ] || cp -Rf "$create_config_template" "/config/$create_template_name" 2>/dev/null
          fi
        fi
      done
      unset create_config_template create_template_name
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_config_dir() {
  if [ -n "$DEFAULT_CONF_DIR" ]; then
    if [ "$CONFIG_DIR_INITIALIZED" = "false" ] && [ -d "/config" ]; then
      echo "Copying custom config files: $DEFAULT_CONF_DIR > /config"
      for create_config_template in "$DEFAULT_CONF_DIR"/*; do
        create_config_name="$(basename "$create_config_template")"
        if [ -n "$create_config_template" ]; then
          if [ -d "$create_config_template" ]; then
            mkdir -p "/config/$create_config_name"
            __is_dir_empty "/config/$create_config_name" && cp -Rf "$create_config_template/." "/config/$create_config_name/" 2>/dev/null
          elif [ -e "$create_config_template" ]; then
            [ -e "/config/$create_config_name" ] || cp -Rf "$create_config_template" "/config/$create_config_name" 2>/dev/null
          fi
        fi
      done
      unset create_config_template create_config_name
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_data_dir() {
  if [ -d "/data" ]; then
    if [ "$DATA_DIR_INITIALIZED" = "false" ] && [ -n "$DEFAULT_DATA_DIR" ]; then
      echo "Copying data files $DEFAULT_DATA_DIR > /data"
      for create_data_template in "$DEFAULT_DATA_DIR"/*; do
        create_data_name="$(basename "$create_data_template")"
        if [ -n "$create_data_template" ]; then
          if [ -d "$create_data_template" ]; then
            mkdir -p "/data/$create_data_name"
            __is_dir_empty "/data/$create_data_name" && cp -Rf "$create_data_template/." "/data/$create_data_name/" 2>/dev/null
          elif [ -e "$create_data_template" ]; then
            [ -e "/data/$create_data_name" ] || cp -Rf "$create_data_template" "/data/$create_data_name" 2>/dev/null
          fi
        fi
      done
      unset create_template
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_www_root() {
  local WWW_INIT=""
  local WWW_TEMPLATE=""
  [ -d "/usr/share/httpd/default" ] && WWW_TEMPLATE="/usr/share/httpd/default"
  [ "$WWW_ROOT_DIR" = "/app" ] && WWW_INIT="${WWW_INIT:-true}"
  [ "$WWW_ROOT_DIR" = "/data/htdocs" ] && WWW_INIT="${WWW_INIT:-true}"
  __is_dir_empty "$WWW_ROOT_DIR/" && WWW_INIT="true" || WWW_INIT="false"
  if [ "$WWW_INIT" = "true" ] && [ -d "$WWW_TEMPLATE" ]; then
    cp -Rf "$DEFAULT_DATA_DIR/data/htdocs/." "$WWW_ROOT_DIR/" 2>/dev/null
  fi
  __initialize_web_health "$WWW_ROOT_DIR"
  find "$WWW_ROOT_DIR" -type d -exec chmod -f 777 {} \;
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__is_htdocs_mounted() {
  echo "$IMPORT_FROM_GIT" | grep -qE 'https://|http://|git://|ssh://' || unset IMPORT_FROM_GIT
  if [ -n "$IMPORT_FROM_GIT" ] && [ "$(command -v "git")" ]; then
    export WWW_ROOT_DIR="/data/htdocs"
    __is_dir_empty "$WWW_ROOT_DIR" || WWW_ROOT_DIR="/data/wwwroot"
    echo "Importing project from $IMPORT_FROM_GIT to $WWW_ROOT_DIR"
    git clone -q "$IMPORT_FROM_GIT" "$WWW_ROOT_DIR"
  elif [ -d "/app" ]; then
    export WWW_ROOT_DIR="/app"
  elif [ -d "/data/htdocs" ]; then
    export WWW_ROOT_DIR="/data/htdocs"
  elif [ -d "/data/wwwroot" ]; then
    export WWW_ROOT_DIR="/data/wwwroot"
  else
    WWW_ROOT_DIR="${ENV_WWW_ROOT_DIR:-$WWW_ROOT_DIR}"
    export WWW_ROOT_DIR="${WWW_ROOT_DIR:-/usr/share/httpd/default}"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_ssl_certs() {
  [ -d "$SSL_DIR" ] || mkdir -p "$SSL_DIR"
  if [ "$SSL_ENABLED" = "true" ] || [ "$SSL_ENABLED" = "yes" ]; then
    if [ -f "$SSL_CERT" ] && [ -f "$SSL_KEY" ]; then
      SSL_ENABLED="true"
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
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__start_php_dev_server() {
  if [ "$2" = "yes" ]; then
    if [ -d "/usr/share/httpd" ]; then
      find "/usr/share/httpd" -type f -not -path '.git*' -iname '*.php' -exec sed -i 's|[<].*SERVER_ADDR.*[>]|'${CONTAINER_IP4_ADDRESS:-127.0.0.1}'|g' {} \; 2>/dev/null
    fi
    if ! echo "$1" | grep -q "^/usr/share/httpd"; then
      find "$1" -type f -not -path '.git*' -iname '*.php' -exec sed -i 's|[<].*SERVER_ADDR.*[>]|'${CONTAINER_IP4_ADDRESS:-127.0.0.1}'|g' {} \; 2>/dev/null
    fi
    php -S 0.0.0.0:$PHP_DEV_SERVER_PORT -t "$1"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set variables from function calls
SET_RANDOM_PASS="${SET_RANDOM_PASS:-$(__random_password 16)}"
CONTAINER_IP4_ADDRESS="${CONTAINER_IP4_ADDRESS:-$(__get_ip4)}"
CONTAINER_IP6_ADDRESS="${CONTAINER_IP6_ADDRESS:-$(__get_ip6)}"
PHP_INI_DIR="${PHP_INI_DIR:-$(__find_php_ini)}"
PHP_BIN_DIR="${PHP_BIN_DIR:-$(__find_php_bin)}"
HTTPD_CONFIG_FILE="${HTTPD_CONFIG_FILE:-$(__find_httpd_conf)}"
NGINX_CONFIG_FILE="${NGINX_CONFIG_FILE:-$(__find_nginx_conf)}"
LIGHTTPD_CONFIG_FILE="${LIGHTTPD_CONFIG_FILE:-$(__find_lighttpd_conf)}"
MARIADB_CONFIG_FILE="${MARIADB_CONFIG_FILE:-$(__find_mysql_conf)}"
POSTGRES_CONFIG_FILE="${POSTGRES_CONFIG_FILE:-$(__find_pgsql_conf)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export the functions
export -f __start_init_scripts
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end of functions
