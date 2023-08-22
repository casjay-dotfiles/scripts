#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  GEN_SCRIPT_REPLACE_VERSION
# @@Author           :  GEN_SCRIPT_REPLACE_AUTHOR
# @@Contact          :  GEN_SCRIPT_REPLACE_EMAIL
# @@License          :  GEN_SCRIPT_REPLACE_LICENSE
# @@ReadME           :  docker-entrypoint
# @@Copyright        :  GEN_SCRIPT_REPLACE_COPYRIGHT
# @@Created          :  GEN_SCRIPT_REPLACE_DATE
# @@File             :  docker-entrypoint
# @@Description      :  GEN_SCRIPT_REPLACE_DESC
# @@Changelog        :  GEN_SCRIPT_REPLACE_CHANGELOG
# @@TODO             :  GEN_SCRIPT_REPLACE_TODO
# @@Other            :  GEN_SCRIPT_REPLACE_OTHER
# @@Resource         :  GEN_SCRIPT_REPLACE_RES
# @@Terminal App     :  GEN_SCRIPT_REPLACE_TERMINAL
# @@sudo/root        :  GEN_SCRIPT_REPLACE_SUDO
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
__cd() { [ -d "$1" ] && builtin cd "$1" || return 1; }
__rm() { [ -n "$1" ] && [ -e "$1" ] && rm -Rf "${1:?}"; }
__grep_test() { grep -s "$1" "$2" | grep -qwF "${3:-$1}" || return 1; }
__netstat() { [ -f "$(type -P netstat)" ] && netstat "$@" || return 10; }
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
__no_exit() { exec /bin/sh -c "trap : TERM INT; (while true; do tail -qf /data/logs/entrypoint.log /data/logs/*/*log 2>/dev/null||sleep 20; done) & wait"; }
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
      -w "${WWW_ROOT_DIR:-/data/htdocs/www}" $ADD_CERTBOT_DOMAINS \
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
  for arg in "$@"; do
    if [ -n "$(command -v "$arg" 2>/dev/null)" ]; then
      $arg
    fi
  done
  # end
  return 0
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
  cmd="$(echo "$command" | awk -F' ' '{print $1}')"
  [ -d "/run/cron" ] || mkdir -p "/run/cron"
  echo "$command" >"/run/cron/$cmd"
  while :; do
    eval "$command"
    sleep $interval
    [ -f "/run/cron/$cmd" ] || break
  done |& tee /data/logs/entrypoint.log
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__replace() {
  [ -n "$3" ] && [ -f "$3" ] || return 1
  grep -s -qR "$1" "$3" &>/dev/null && __sed "$1" "$2" "$3" || return 0
  grep -s -qR "$2" "$3" && printf '%s\n' "Changed $1 to $2 in $3" && return 0 || {
    printf '%s\n' "Failed to change $1 in $3" >&2 && return 2
  }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_replace() {
  [ -n "$3" ] && [ -e "$3" ] || return 1
  grep -s -qR "$1" "$3" &>/dev/null || return 0
  find "$3" -type f -not -path '.git*' -exec sed -i "s|$1|$2|g" {} \;
  grep -s -qR "$2" "$3" && printf '%s\n' "Changed $1 to $2 in $3" && return 0 || {
    printf '%s\n' "Failed to change $1 in $3" >&2 && return 2
  }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__file_copy() {
  [ -n "$1" ] && [ -e "$1" ] || return 1
  [ -n "$1" ] && [ -n "$2" ] && [ -e "$1" ] && cp -Rf "$1" "$2" &>/dev/null
  [ -e "$1" ] && [ -e "$2" ] && printf '%s\n' "Copied: $1 > $2" && return 0 || {
    printf '%s\n' "Copy failed: $1 < $2" >&2 && return 2
  }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_service_user() {
  local create_user="$1"
  local create_home_dir="$2"
  local create_gid="${USER_GID:-${USER_UID:-${3:-10000}}}"
  local create_home_dir="${create_home_dir:-/home/$create_user}" set_home_dir=""
  [ "$ENTRYPOINT_FIRST_RUN" = "no" ] || return 0
  [ -n "$SERVICE_USER" ] || [ "$SERVICE_USER" != "root" ] || return 0
  if ! grep -s -q "$create_user" "/etc/groups"; then
    echo "creating system group $create_user"
    addgroup -g $create_gid -S $create_user &>/dev/null
  fi
  if ! grep -s -q "$create_user" "/etc/passwd"; then
    echo "creating system user $create_user"
    adduser -u $create_gid -D -h "$create_home_dir" -g $create_user $create_user &>/dev/null
    grep -q "$create_user" "/etc/passwd" "/etc/groups" && set_home_dir="$home_dir" && exitStatus=0 || exitStatus=1
  fi
  [ $exitStatus -eq 0 ] && export WORK_DIR="${set_home_dir:-}"
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
      cat <<EOF | tee "$create_env" &>/dev/null
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
    if [ ! -f "/config/ssmtp/ssmtp.conf" ]; then
      cat <<EOF | tee "/config/ssmtp/ssmtp.conf" &>/dev/null
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
      cp -Rf "/config/ssmtp/." "/etc/ssmtp/"
      echo "Done setting up ssmtp"
    fi

    ################# postfix relay setup
  elif [ -n "$(type -P 'postfix')" ]; then
    [ -d "/config" ] || mkdir -p "/config"
    [ -d "/etc/postfix" ] || mkdir -p "/etc/postfix"
    [ -f "/etc/postfix/main.cf" ] && rm -Rf "/etc/postfix/main.cf"
    if [ ! -f "/config/postfix/main.cf" ]; then
      cat <<EOF | tee "/config/postfix/main.cf" &>/dev/null
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
      cp -Rf "/config/postfix/." "/etc/postfix/"
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
  [ -d "$1/health" ] || mkdir -p "$1/health"
  [ -f "$1/health/index.txt" ] || echo 'ok' >"$1/health/index.txt"
  [ -f "$1/health/index.json" ] || echo '{ "status": "ok" }' >"$1/health/index.json"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  file_dir
__initialize_replace_variables() {
  [ $# -eq 1 ] || return 1
  __find_replace "REPLACE_SERVER_NAME" "$HOSTNAME" "$1"
  __find_replace "REPLACE_DATA_DIR" "${DATA_DIR:-/data}" "$1"
  __find_replace "REPLACE_CONFIG_DIR" "${CONF_DIR:-/config}" "$1"
  __find_replace "REPLACE_SERVER_PORT" "${SERVICE_PORT:-80}" "$1"
  __find_replace "REPLACE_SERVER_SOFTWARE" "${CONTAINER_NAME:-docker}" "$1"
  __find_replace "REPLACE_SERVER_DIR" "${WWW_DIR:-/usr/share/webapps}" "$1"
  __find_replace "REPLACE_DATABASE_DIR" "${DATABASE_DIR:-/data/db/$SERVICE_NAME}" "$1"
  __find_replace "REPLACE_SERVER_WWW_DIR" "${WWW_ROOT_DIR:--/usr/share/webapps}" "$1"
  __find_replace "REPLACE_SERVER_ADMIN" "${SERVER_ADMIN:-root@${sysname:-$HOSTNAME}}" "$1"
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
__initialize_system_etc() {
  if [ -d "/config" ]; then
    if [ "$CONFIG_DIR_INITIALIZED" = "false" ]; then
      echo "Copying config files to system: /config > /etc"
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
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_www_root() {
  if [ "$DATA_DIR_INITIALIZED" = "false" ] && [ -n "$WWW_ROOT_DIR" ]; then
    if [ -d "$DEFAULT_DATA_DIR/data/htdocs" ]; then
      __is_dir_empty "$WWW_ROOT_DIR/" && cp -Rf "$DEFAULT_DATA_DIR/data/htdocs/." "$WWW_ROOT_DIR/" 2>/dev/null
    fi
  fi
  if [ -n "$WWW_ROOT_DIR" ]; then
    if [ -d "$DEFAULT_DATA_DIR/htdocs/www" ] && [ ! -d "$WWW_ROOT_DIR" ]; then
      mkdir -p "$WWW_ROOT_DIR" "$WWW_ROOT_DIR/health"
      cp -Rf "$DEFAULT_DATA_DIR/htdocs/www/." "$WWW_ROOT_DIR/"
      [ -f "$WWW_ROOT_DIR/health/index.txt" ] || echo "OK" >"$WWW_ROOT_DIR/health/index.txt"
      [ -f "$WWW_ROOT_DIR/health/index.json" ] || echo '{"status":"ok"}' >"$WWW_ROOT_DIR/health/index.json"
    fi
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
