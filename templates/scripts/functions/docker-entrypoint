#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202407241259-git
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC2016
# shellcheck disable=SC2031
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# shellcheck disable=SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup debugging - https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
[ -f "/config/.debug" ] && [ -z "$DEBUGGER_OPTIONS" ] && export DEBUGGER_OPTIONS="$(<"/config/.debug")" || DEBUGGER_OPTIONS="${DEBUGGER_OPTIONS:-}"
{ [ "$DEBUGGER" = "on" ] || [ -f "/config/.debug" ]; } && echo "Enabling debugging" && set -xo pipefail -x$DEBUGGER_OPTIONS && export DEBUGGER="on" || set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__remove_extra_spaces() { sed 's/\( \)*/\1/g;s|^ ||g'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__printf_space() {
  pad=$(printf '%0.1s' " "{1..60})
  padlength=$1
  string1="$2"
  string2="$3"
  printf '%s' "$string1"
  printf '%*.*s' 0 $((padlength - ${#string1} - ${#string2})) "$pad"
  printf '%s\n' "$string2"
  string2=${string2:1}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cd() { [ -d "$1" ] && builtin cd "$1" || return 1; }
__rm() { [ -n "$1" ] && [ -e "$1" ] && rm -Rf "${1:?}"; }
__grep_test() { grep -s "$1" "$2" | grep -qwF "${3:-$1}" || return 1; }
__netstat() { [ -f "$(type -P netstat)" ] && netstat "$@" || return 10; }
__is_in_file() { [ -e "$2" ] && grep -Rsq "$1" "$2" && return 0 || return 1; }
__curl() { curl -q -sfI --max-time 3 -k -o /dev/null "$@" &>/dev/null || return 10; }
__find() { find "$1" -mindepth 1 -type ${2:-f,d} 2>/dev/null | grep '^' || return 10; }
__pcheck() { [ -n "$(which pgrep 2>/dev/null)" ] && pgrep -o "$1" &>/dev/null || return 10; }
__file_exists_with_content() { [ -n "$1" ] && [ -f "$1" ] && [ -s "$1" ] && return 0 || return 2; }
__sed() { sed -i 's|'$1'|'$2'|g' "$3" &>/dev/null || sed -i "s|$1|$2|g" "$3" &>/dev/null || return 1; }
__ps() { [ -f "$(type -P ps)" ] && ps "$@" 2>/dev/null | grep -Fw " ${1:-$SERVICE_NAME}" || return 10; }
__pgrep() { __pcheck "${1:-SERVICE_NAME}" || __ps "${1:-$SERVICE_NAME}" | grep -qv ' grep' || return 10; }
__is_dir_empty() { if [ -n "$1" ]; then [ "$(ls -A "$1" 2>/dev/null | wc -l)" -eq 0 ] && return 0 || return 1; else return 1; fi; }
__get_ip6() { ip a 2>/dev/null | grep -w 'inet6' | awk '{print $2}' | grep -vE '^::1|^fe' | sed 's|/.*||g' | head -n1 | grep '^' || echo ''; }
__get_ip4() { ip a 2>/dev/null | grep -w 'inet' | awk '{print $2}' | grep -vE '^127.0.0' | sed 's|/.*||g' | head -n1 | grep '^' || echo '127.0.0.1'; }
__find_file_relative() { find "$1"/* -not -path '*env/*' -not -path '.git*' -type f 2>/dev/null | sed 's|'$1'/||g' | sort -u | grep -v '^$' | grep '^' || false; }
__find_directory_relative() { find "$1"/* -not -path '*env/*' -not -path '.git*' -type d 2>/dev/null | sed 's|'$1'/||g' | sort -u | grep -v '^$' | grep '^' || false; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__pid_exists() { ps -ax --no-header | sed 's/^[[:space:]]*//g' | awk -F' ' '{print $1}' | grep '[0-9]' | sort -uV | grep "^$1$" && return 0 || return 1; }
__is_running() { ps -eo args --no-header | awk '{print $1,$2,$3}' | sed 's|:||g' | sort -u | grep -vE 'grep|COMMAND|awk|tee|ps|sed|sort|tail' | grep "$1" | grep -q "${2:-^}" && return 0 || return 1; }
__get_pid() { ps -ax --no-header | sed 's/^[[:space:]]*//g;s|;||g;s|:||g' | awk '{print $1,$5}' | grep -v 'grep' | grep "$1$" | awk -F' ' '{print $1}' | grep '[0-9]' | sort -uV | head -n1 | grep '^' && return 0 || return 1; }
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
  [ -f "/run/no_exit.pid" ] || exec /bin/sh -c "trap 'sleep 1;rm -Rf /run/no_exit.pid;exit 0' TERM INT;(while true; do echo $$ >/run/no_exit.pid;tail -qf /data/logs/entrypoint.log /data/logs/*/*log 2>/dev/null||sleep 20; done) & wait"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__trim() {
  local var="${*//;/ }"
  var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
  var="$(echo "$var" | __remove_extra_spaces | sed "s| |; |g;s|;$| |g" | __remove_extra_spaces)"
  printf '%s' "$var" | sed 's|;||g' | grep -v '^$'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__banner() { printf '# - - - %-60s  - - - #\n' "$*"; }
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
  [ -f "/config/certbot/env.sh" ] && . "/config/certbot/env.sh"
  if [ -f "/config/certbot/setup.sh" ]; then
    eval "/config/certbot/setup.sh"
    statusCode=$?
  elif [ -f "/etc/named/certbot.sh" ]; then
    eval "/etc/named/certbot.sh"
    statusCode=$?
  elif [ -f "/config/certbot/certbot.conf" ]; then
    if certbot renew -n --dry-run --agree-tos --expand --dns-rfc2136 --dns-rfc2136-credentials /config/certbot/certbot.conf; then
      certbot renew -n --agree-tos --expand --dns-rfc2136 --dns-rfc2136-credentials /config/certbot/certbot.conf
    fi
    statusCode=$?
  elif [ -f "/config/named/certbot-update.conf" ]; then
    if certbot renew -n --dry-run --agree-tos --expand --dns-rfc2136 --dns-rfc2136-credentials /config/named/certbot-update.conf; then
      certbot renew -n --agree-tos --expand --dns-rfc2136 --dns-rfc2136-credentials /config/named/certbot-update.conf
    fi
    statusCode=$?
  else
    [ -n "$SSL_KEY" ] && mkdir -p "$(dirname "$SSL_KEY")" || { echo "The variable $SSL_KEY is not set" >&2 && return 1; }
    [ -n "$SSL_CERT" ] && mkdir -p "$(dirname "$SSL_CERT")" || { echo "The variable $SSL_CERT is not set" >&2 && return 1; }
    local options="${1:-create}" && shift 1
    domain_list="$DOMAINNAME www.$DOMAINNAME mail.$DOMAINNAME $CERTBOT_DOMAINS"
    [ -f "/config/env/ssl.sh" ] && . "/config/env/ssl.sh"
    [ "$CERT_BOT_ENABLED" = "true" ] || { export CERT_BOT_ENABLED="" && return 10; }
    [ -n "$DOMAINNAME" ] || { echo "The variable DOMAINNAME is not set" >&2 && return 1; }
    [ -n "$CERT_BOT_MAIL" ] || { echo "The variable CERT_BOT_MAIL is not set" >&2 && return 1; }
    for domain in $$CERTBOT_DOMAINS; do
      [ -n "$domain" ] && ADD_CERTBOT_DOMAINS="-d $domain $ADD_CERTBOT_DOMAINS"
    done
    if [ -n "$ADD_CERTBOT_DOMAINS" ]; then
      certbot $options --agree-tos -m $CERT_BOT_MAIL certonly \
        --webroot "${WWW_ROOT_DIR:-/usr/share/httpd/default}" \
        --key-path "$SSL_KEY" --fullchain-path "$SSL_CERT" \
        $ADD_CERTBOT_DOMAINS
      statusCode=$?
    else
      statusCode=1
    fi
  fi
  [ $statusCode -eq 0 ] && __update_ssl_certs
  return $statusCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_ssl_cert() {
  local SSL_DIR="${SSL_DIR:-/etc/ssl}"
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
  local etc_dir="/etc/${1:-nginx}"
  local conf_dir="/config/${1:-nginx}"
  local www_dir="${WWW_ROOT_DIR:-/data/htdocs}"
  local nginx_bin="$(type -P 'nginx')"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_php() {
  local etc_dir="/etc/${1:-php}"
  local conf_dir="/config/${1:-php}"
  local php_bin="${PHP_BIN_DIR:-$(__find_php_bin)}"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_mysql() {
  local db_dir="/data/db/mysql"
  local etc_dir="${home:-/etc/${1:-mysql}}"
  local db_user="${SERVICE_USER:-mysql}"
  local conf_dir="/config/${1:-mysql}"
  local user_pass="${MARIADB_PASSWORD:-$MARIADB_ROOT_PASSWORD}"
  local user_db="${MARIADB_DATABASE}" user_name="${MARIADB_USER:-root}"
  local root_pass="$MARIADB_ROOT_PASSWORD"
  local mysqld_bin="$(type -P 'mysqld')"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_mongodb() {
  local home="${MONGODB_CONFIG_FILE:-$(__find_mongodb_conf)}"
  local user_pass="${MONGO_INITDB_ROOT_PASSWORD:-$_ROOT_PASSWORD}"
  local user_name="${INITDB_ROOT_USERNAME:-root}"
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_postgres() {
  local home="${PGSQL_CONFIG_FILE:-$(__find_pgsql_conf)}"
  local user_pass="${POSTGRES_PASSWORD:-$POSTGRES_ROOT_PASSWORD}"
  local user_name="${POSTGRES_USER:-root}"
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_couchdb() {
  local home="${COUCHDB_CONFIG_FILE:-$(__find_couchdb_conf)}"
  local user_pass="${COUCHDB_PASSWORD:-$SET_RANDOM_PASS}"
  local user_name="${COUCHDB_USER:-root}"
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
  local command="$*"
  local cmd="${CRON_NAME:-$(echo "$command" | awk -F' ' '{print $1}')}"
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
  local search="$1" replace="$2" file="${3:-$2}"
  [ -e "$file" ] || return 1
  __sed "$search" "$replace" "$file" || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_replace() {
  local search="$1" replace="$2" file="${3:-$2}"
  [ -e "$file" ] || return 1
  find "$file" -type f -not -path '.git*' -exec sed -i "s|$search|$replace|g" {} \; 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# /config > /etc
__copy_templates() {
  local from="$1" to="$2"
  if [ -e "$from" ] && __is_dir_empty "$to"; then
    __file_copy "$from" "$to"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# /config/file > /etc/file
__symlink() {
  local from="$1" to="$2"
  if [ -e "$to" ]; then
    [ -e "$from" ] && rm -rf "$from"
    ln -sf "$to" "$from" && echo "Created symlink to $from > $to"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__file_copy() {
  local from="$1"
  local dest="$2"
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
    printf '%s\n' "$from does not exist"
    return 2
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__generate_random_uids() {
  local set_random_uid="$(seq 3000 5000 | sort -R | head -n 1)"
  while :; do
    if grep -qs "x:.*:$set_random_uid:" "/etc/group" && ! grep -sq "x:$set_random_uid:.*:" "/etc/passwd"; then
      set_random_uid=$((set_random_uid + 1))
    else
      echo "$set_random_uid"
      break
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__setup_directories() {
  # Setup WWW_ROOT_DIR
  if [ "$IS_WEB_SERVER" = "yes" ]; then
    APPLICATION_DIRS="$APPLICATION_DIRS $WWW_ROOT_DIR"
    __initialize_www_root
    (echo "Creating directory $WWW_ROOT_DIR with permissions 755" && mkdir -p "$WWW_ROOT_DIR" && find "$WWW_ROOT_DIR" -type d -exec chmod -f 755 {} \;) |& tee -p -a "$LOG_DIR/init.txt" &>/dev/null
  fi
  # Setup DATABASE_DIR
  if [ "$IS_DATABASE_SERVICE" = "yes" ]; then
    APPLICATION_DIRS="$APPLICATION_DIRS $DATABASE_DIR"
    if __is_dir_empty "$DATABASE_DIR" || [ ! -d "$DATABASE_DIR" ]; then
      (echo "Creating directory $DATABASE_DIR with permissions 777" && mkdir -p "$DATABASE_DIR" && chmod -f 777 "$DATABASE_DIR") |& tee -p -a "$LOG_DIR/init.txt" &>/dev/null
    fi
  fi
  # create default directories
  for filedirs in $ADD_APPLICATION_DIRS $APPLICATION_DIRS; do
    if [ -n "$filedirs" ] && [ ! -d "$filedirs" ]; then
      (
        echo "Creating directory $filedirs with permissions 777"
        mkdir -p "$filedirs" && chmod -f 777 "$filedirs"
      ) |& tee -p -a "$LOG_DIR/init.txt" &>/dev/null
    fi
  done
  # create default files
  for application_files in $ADD_APPLICATION_FILES $APPLICATION_FILES; do
    if [ -n "$application_files" ] && [ ! -e "$application_files" ]; then
      (
        echo "Creating file $application_files with permissions 777"
        touch "$application_files" && chmod -Rf 777 "$application_files"
      ) |& tee -p -a "$LOG_DIR/init.txt" &>/dev/null
    fi
  done
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__fix_permissions() {
  # set user on files/folders
  change_user="${1:-${SERVICE_USER:-root}}"
  change_group="${2:-${SERVICE_GROUP:-$change_user}}"
  [ -n "$RUNAS_USER" ] && [ "$RUNAS_USER" != "root" ] && change_user="$RUNAS_USER" && change_group="$change_user"
  if [ -n "$change_user" ] && [ "$change_user" != "root" ]; then
    if grep -sq "^$change_user:" "/etc/passwd"; then
      for permissions in $ADD_APPLICATION_DIRS $APPLICATION_DIRS; do
        if [ -n "$permissions" ] && [ -e "$permissions" ]; then
          (chown -Rf $change_user:$change_group "$permissions" && echo "changed ownership on $permissions to user:$change_user and group:$change_group") |& tee -p -a "$LOG_DIR/init.txt" &>/dev/null
        fi
      done
    fi
  fi
  if [ -n "$change_group" ] && [ "$change_group" != "root" ]; then
    if grep -sq "^$change_group:" "/etc/group"; then
      for permissions in $ADD_APPLICATION_DIRS $APPLICATION_DIRS; do
        if [ -n "$permissions" ] && [ -e "$permissions" ]; then
          (chgrp -Rf $change_group "$permissions" && echo "changed group ownership on $permissions to group $change_group") |& tee -p -a "$LOG_DIR/init.txt" &>/dev/null
        fi
      done
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__get_gid() { grep "^$1:" /etc/group | awk -F ':' '{print $3}' || false; }
__get_uid() { grep "^$1:" /etc/passwd | awk -F ':' '{print $3}' || false; }
__check_for_uid() { cat "/etc/passwd" 2>/dev/null | awk -F ':' '{print $3}' | sort -u | grep -q "^$1$" || false; }
__check_for_guid() { cat "/etc/group" 2>/dev/null | awk -F ':' '{print $3}' | sort -u | grep -q "^$1$" || false; }
__check_for_user() { cat "/etc/passwd" 2>/dev/null | awk -F ':' '{print $1}' | sort -u | grep -q "^$1$" || false; }
__check_for_group() { cat "/etc/group" 2>/dev/null | awk -F ':' '{print $1}' | sort -u | grep -q "^$1$" || false; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__set_user_group_id() {
  local exitStatus=0
  local set_user="${1:-$SERVICE_USER}"
  local set_uid="${2:-${SERVICE_UID:-1000}}"
  local set_gid="${3:-${SERVICE_GID:-1000}}"
  local random_id="$(__generate_random_uids)"
  set_uid="$(__get_uid "$set_user" || echo "$set_uid")"
  set_gid="$(__get_gid "$set_user" || echo "$set_gid")"
  grep -sq "^$create_user:" "/etc/passwd" "/etc/group" || return 0
  [ -n "$set_user" ] && [ "$set_user" != "root" ] || return
  if grep -sq "^$set_user:" "/etc/passwd" "/etc/group"; then
    if __check_for_guid "$set_gid"; then
      groupmod -g "${set_gid}" $set_user 2>/dev/stderr | tee -p -a "${LOG_DIR/tmp/}/init.txt" &>/dev/null &&
        chown -Rf ":$set_gid"
    fi
    if __check_for_uid "$set_uid"; then
      usermod -u "${set_uid}" -g "${set_gid}" $set_user 2>/dev/stderr | tee -p -a "${LOG_DIR/tmp/}/init.txt" &>/dev/null &&
        chown -Rf $set_uid:$set_gid
    fi
  fi
  export SERVICE_UID="$set_uid"
  export SERVICE_GID="$set_gid"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_service_user() {
  local exitStatus=0
  local set_home_dir=""
  local create_user="${1:-$SERVICE_USER}"
  local create_group="${2:-$SERVICE_GROUP}"
  local create_home_dir="${3:-${WORK_DIR:-/home/$create_user}}"
  local create_uid="${4:-${SERVICE_UID:-$USER_UID}}"
  local create_gid="${5:-${SERVICE_GID:-$USER_GID}}"
  local random_id="$(__generate_random_uids)"
  create_uid="$(__get_uid "$set_user" || echo "$create_uid")"
  create_gid="$(__get_gid "$set_user" || echo "$create_gid")"
  grep -sq "^$create_user:" "/etc/passwd" && grep -sq "^$create_group:" "/etc/group" && return
  [ "$create_user" != "root" ] || return 0
  [ -n "$create_uid" ] && [ "$create_uid" != "0" ] || create_uid="$random_id"
  [ -n "$create_gid" ] && [ "$create_gid" != "0" ] || create_gid="$random_id"
  while :; do
    if __check_for_uid "$create_uid" && __check_for_guid "$create_gid"; then
      create_uid=$(($random_id + 1))
      create_gid="$create_uid"
    else
      break
    fi
  done
  if ! __check_for_group "$create_group"; then
    echo "creating system group $create_group"
    groupadd -g $create_gid $create_group 2>/dev/stderr | tee -p -a "${LOG_DIR/tmp/}/init.txt" &>/dev/null
  fi
  if ! __check_for_user "$create_user"; then
    echo "creating system user $create_user"
    useradd -u $create_uid -g $create_gid -c "Account for $create_user" -d "$create_home_dir" -s /bin/false $create_user 2>/dev/stderr | tee -p -a "$LOG_DIR/tmp/init.txt" &>/dev/null
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
  local pre_exec="--login"
  prog_bin="$(echo "${arg[@]}" | tr ' ' '\n' | grep -v '^$' | head -n1 || echo '')"
  [ -n "$prog_bin" ] && prog="$(type -P "$prog_bin" 2>/dev/null || echo "$1")" || prog="bash"
  [ -n "$cmdExec" ] || cmdExec=""
  if [ -f "$prog" ]; then
    echo "${exec_message:-Executing command: $cmdExec}"
    [ "$prog" = "sh" ] || [ "$prog" = "bash" ] || pre_exec="-c"

    if [ -x "/bin/bash" ]; then
      eval bash $pre_exec $cmdExec || exitCode=1
    else
      eval sh $pre_exec $cmdExec || exitCode=1
    fi
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
  local retPID=""
  local basename=""
  local init_pids=""
  local retstatus="0"
  local initStatus="0"
  local init_dir="${1:-/usr/local/etc/docker/init.d}"
  local init_count="$(ls -A "$init_dir"/* 2>/dev/null | grep -v '\.sample' | wc -l)"
  touch /run/__start_init_scripts.pid
  mkdir -p "/tmp" "/run" "/run/init.d" "/usr/local/etc/docker/exec"
  chmod -R 777 "/tmp" "/run" "/run/init.d" "/usr/local/etc/docker/exec"
  if [ "$init_count" -eq 0 ] || [ ! -d "$init_dir" ]; then
    mkdir -p "/data/logs/init"
    while :; do echo "Running: $(date)" >"/data/logs/init/keep_alive" && sleep 3600; done &
  else
    if [ -d "$init_dir" ]; then
      chmod -Rf 755 "$init_dir/"
      [ -f "$init_dir/service.sample" ] && rm -Rf "$init_dir"/*.sample
      for init in "$init_dir"/*.sh; do
        if [ -f "$init" ]; then
          name="$(basename "$init")"
          service="$(printf '%s' "$name" | sed 's/^[^-]*-//;s|.sh$||g')"
          printf '# - - - executing file: %s\n' "$init"
          "$init"
          retPID=$(__get_pid "$service")
          if [ -n "$retPID" ]; then
            initStatus="0"
            sleep 20
            printf '# - - - %s has been started - pid: %s\n' "$service" "${retPID:-error}"
          else
            initStatus="1"
            sleep 10
            printf '# - - - %s has falied to start - check log %s\n' "$service" "docker log $CONTAINER_NAME"
          fi
          echo ""
        fi
        retstatus=$(($initStatus + $initStatus))
      done
    fi
  fi
  return $retstatus
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
  local www_dir="${1:-${WWW_ROOT_DIR:-/usr/share/httpd/default}}"
  [ $# -eq 1 ] && [ -d "$www_dir" ] || return 1
  if ! echo "$www_dir" | grep -q '/usr/share/httpd'; then
    [ -d "$www_dir/health" ] || mkdir -p "$www_dir/health"
    [ -f "$www_dir/health/index.txt" ] || echo 'OK' >"$www_dir/health/index.txt"
    [ -f "$www_dir/health/index.json" ] || echo '{ "status": "OK" }' >"$www_dir/health/index.json"
    __find_replace "REPLACE_CONTAINER_IP4" "${REPLACE_CONTAINER_IP4:-127.0.0.1}" "$www_dir"
    __find_replace "REPLACE_COPYRIGHT_FOOTER" "${COPYRIGHT_FOOTER:-Copyright 1999 - $(date +'%Y')}" "$www_dir"
    __find_replace "REPLACE_LAST_UPDATED_ON_MESSAGE" "${LAST_UPDATED_ON_MESSAGE:-$(date +'Last updated on: %Y-%m-%d at %H:%M:%S')}" "$www_dir"
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
    __find_replace "REPLACE_LOG_DIR" "${LOG_DIR:-/data/log/$SERVICE_NAME}" "$set_dir"
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
    [ -n "$SERVICE_PORT" ] && __find_replace "REPLACE_SERVER_PORT" "${SERVICE_PORT:-80}" "$set_dir"
    [ -n "$HOSTNAME" ] && __find_replace "REPLACE_SERVER_NAME" "${FULL_DOMAIN_NAME:-$HOSTNAME}" "$set_dir"
    [ -n "$CONTAINER_NAME" ] && __find_replace "REPLACE_SERVER_SOFTWARE" "${CONTAINER_NAME:-docker}" "$set_dir"
    [ -n "$WWW_ROOT_DIR" ] && __find_replace "REPLACE_SERVER_WWW_DIR" "${WWW_ROOT_DIR:-/usr/share/httpd/default}" "$set_dir"
  done
  mkdir -p "${TMP_DIR:-/tmp/$SERVICE_NAME}" "${RUN_DIR:-/run/$SERVICE_NAME}" "${LOG_DIR:-/data/log/$SERVICE_NAME}"
  chmod -f 777 "${TMP_DIR:-/tmp/$SERVICE_NAME}" "${RUN_DIR:-/run/$SERVICE_NAME}" "${LOG_DIR:-/data/log/$SERVICE_NAME}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_database() {
  [ "$IS_DATABASE_SERVICE" = "yes" ] || return 0
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
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_db_users() {
  [ "$IS_DATABASE_SERVICE" = "yes" ] || return 0
  db_normal_user="${DATABASE_USER_NORMAL:-$user_name}"
  db_normal_pass="${DATABASE_PASS_NORMAL:-$user_pass}"
  db_admin_user="${DATABASE_USER_ROOT:-$root_user_name}"
  db_admin_pass="${DATABASE_PASS_ROOT:-$root_user_pass}"
  export user_name="$db_normal_user" user_pass="$db_normal_pass" root_user_name="$db_admin_user" root_user_pass="$db_admin_pass"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_system_etc() {
  local conf_dir="$1"
  local dir=""
  local file=()
  local directories=()
  if [ -n "$conf_dir" ] && [ -e "$conf_dir" ]; then
    files=("$(find "$conf_dir"/* -not -path '*/env/*' -type f 2>/dev/null | sed 's|'/config/'||g' | sort -u | grep -v '^$' | grep '^' || false)")
    directories=("$(find "$conf_dir"/* -not -path '*/env/*' -type d 2>/dev/null | sed 's|'/config/'||g' | sort -u | grep -v '^$' | grep '^' || false)")
    echo "Copying config files to system: $conf_dir > /etc/${conf_dir//\/config\//}"
    if [ -n "${directories[*]}" ]; then
      for d in "${directories[@]}"; do
        dir="/etc/$d"
        echo "Creating directory: $dir"
        mkdir -p "$dir"
      done
    fi
    for f in "${files[@]}"; do
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
  local SET_USR_BIN=""
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
  find "$WWW_ROOT_DIR" -type d -exec chmod -f 777 {} \; 2>/dev/null
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
      php -S 0.0.0.0:$PHP_DEV_SERVER_PORT -t "/usr/share/httpd"
    fi
    if ! echo "$1" | grep -q "^/usr/share/httpd"; then
      find "$1" -type f -not -path '.git*' -iname '*.php' -exec sed -i 's|[<].*SERVER_ADDR.*[>]|'${CONTAINER_IP4_ADDRESS:-127.0.0.1}'|g' {} \; 2>/dev/null
      php -S 0.0.0.0:$PHP_DEV_SERVER_PORT -t "$1"
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set variables from function calls
export INIT_DATE="${INIT_DATE:-$(date)}"
export START_SERVICES="${START_SERVICES:-yes}"
export ENTRYPOINT_MESSAGE="${ENTRYPOINT_MESSAGE:-yes}"
export ENTRYPOINT_FIRST_RUN="${ENTRYPOINT_FIRST_RUN:-yes}"
export DATA_DIR_INITIALIZED="${DATA_DIR_INITIALIZED:-false}"
export CONFIG_DIR_INITIALIZED="${CONFIG_DIR_INITIALIZED:-false}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# System
export LANG="${LANG:-C.UTF-8}"
export LC_ALL="${LANG:-C.UTF-8}"
export TZ="${TZ:-${TIMEZONE:-America/New_York}}"
export HOSTNAME="${FULL_DOMAIN_NAME:-${SERVER_HOSTNAME:-$HOSTNAME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default directories
export SSL_DIR="${SSL_DIR:-/config/ssl}"
export SSL_CA="${SSL_CERT:-/config/ssl/ca.crt}"
export SSL_KEY="${SSL_KEY:-/config/ssl/localhost.pem}"
export SSL_CERT="${SSL_CERT:-/config/ssl/localhost.crt}"
export BACKUP_DIR="${BACKUP_DIR:-/data/backups}"
export LOCAL_BIN_DIR="${LOCAL_BIN_DIR:-/usr/local/bin}"
export DEFAULT_DATA_DIR="${DEFAULT_DATA_DIR:-/usr/local/share/template-files/data}"
export DEFAULT_CONF_DIR="${DEFAULT_CONF_DIR:-/usr/local/share/template-files/config}"
export DEFAULT_TEMPLATE_DIR="${DEFAULT_TEMPLATE_DIR:-/usr/local/share/template-files/defaults}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_IP4_ADDRESS="${CONTAINER_IP4_ADDRESS:-$(__get_ip4)}"
CONTAINER_IP6_ADDRESS="${CONTAINER_IP6_ADDRESS:-$(__get_ip6)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional
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
export ENTRYPOINT_PID_FILE="${ENTRYPOINT_PID_FILE:-/run/init.d/entrypoint.pid}"
export ENTRYPOINT_INIT_FILE="${ENTRYPOINT_INIT_FILE:-/config/.entrypoint.done}"
export ENTRYPOINT_DATA_INIT_FILE="${ENTRYPOINT_DATA_INIT_FILE:-/data/.docker_has_run}"
export ENTRYPOINT_CONFIG_INIT_FILE="${ENTRYPOINT_CONFIG_INIT_FILE:-/config/.docker_has_run}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# is already Initialized
[ -z "$DATA_DIR_INITIALIZED" ] && { [ -f "$ENTRYPOINT_DATA_INIT_FILE" ] && DATA_DIR_INITIALIZED="true" || DATA_DIR_INITIALIZED="false"; }
[ -z "$CONFIG_DIR_INITIALIZED" ] && { [ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ] && CONFIG_DIR_INITIALIZED="true" || CONFIG_DIR_INITIALIZED="false"; }
[ -z "$ENTRYPOINT_FIRST_RUN" ] && { { [ -f "$ENTRYPOINT_PID_FILE" ] || [ -f "$ENTRYPOINT_INIT_FILE" ]; } && ENTRYPOINT_FIRST_RUN="no" || ENTRYPOINT_FIRST_RUN="true"; }
export ENTRYPOINT_DATA_INIT_FILE DATA_DIR_INITIALIZED ENTRYPOINT_CONFIG_INIT_FILE CONFIG_DIR_INITIALIZED
export ENTRYPOINT_PID_FILE ENTRYPOINT_INIT_FILE ENTRYPOINT_FIRST_RUN
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export the functions
export -f __get_pid __start_init_scripts __is_running __certbot __update_ssl_certs __create_ssl_cert
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end of functions
