# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -o pipefail -x$DEBUGGER_OPTIONS || set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__rm() { [ -f "$1" ] && rm -Rf "${1:?}"; }
__cd() { [ -d "$1" ] && builtin cd "$1" || return 1; }
__netstat() { [ -f "$(type -P netstat)" ] && netstat "$@" || return 10; }
__curl() { curl -q -sfI --max-time 3 -k -o /dev/null "$@" &>/dev/null || return 10; }
__find() { find "$1" -mindepth 1 -type ${2:-f,d} 2>/dev/null | grep '^' || return 10; }
__no_exit() { exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"; }
__pcheck() { [ -n "$(which pgrep 2>/dev/null)" ] && pgrep -o "$1" &>/dev/null || return 10; }
__ps() { [ -f "$(type -P ps)" ] && ps "$@" 2>/dev/null | grep -Fw " ${1:-$GEN_SCRIPT_REPLACE_APPNAME}" || return 10; }
__pgrep() { __pcheck "${1:-GEN_SCRIPT_REPLACE_APPNAME}" || __ps "${1:-$GEN_SCRIPT_REPLACE_APPNAME}" | grep -qv ' grep' || return 10; }
__get_ip6() { ip a 2>/dev/null | grep -w 'inet6' | awk '{print $2}' | grep -vE '^::1|^fe' | sed 's|/.*||g' | head -n1 | grep '^' || echo ''; }
__get_ip4() { ip a 2>/dev/null | grep -w 'inet' | awk '{print $2}' | grep -vE '^127.0.0' | sed 's|/.*||g' | head -n1 | grep '^' || echo '127.0.0.1'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_php_bin() { find -L '/usr'/*bin -maxdepth 4 -name 'php-fpm*' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_php_ini() { find -L '/etc' -maxdepth 4 -name 'php.ini' 2>/dev/null | head -n1 | sed 's|/php.ini||g' | grep '^' || echo ''; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_nginx_conf() { find -L '/etc' -maxdepth 4 -name 'nginx.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_lighttpd_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'lighttpd.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_cherokee_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'cherokee.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_caddy_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'caddy.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_httpd_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'httpd.conf' -o -iname 'apache2.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_mysql_conf() { find -L '/etc' -maxdepth 4 -type f -name 'my.cnf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_pgsql_conf() { find -L '/var/lib' '/etc' -maxdepth 8 -type f -name 'postgresql.conf' 2>/dev/null | head -n1 | grep '^' || echo ''; }
__find_mongodb_conf() { return; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__random_password() { cat "/dev/urandom" | tr -dc '[0-9][a-z][A-Z]@$' | head -c${1:-14} && echo ""; }
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
    [ "$SSL_CERT_BOT" = "true" ] || { export SSL_CERT_BOT="" && return 10; }
    [ -n "$CERT_BOT_MAIL" ] || echo "The variable CERT_BOT_MAIL is not set" && return 1
    [ -n "$DOMAINNAME" ] || echo "The variable DOMAINNAME is not set" && return 1
    for domain in $$CERTBOT_DOMAINS; do
      [ -n "$domain" ] && ADD_CERTBOT_DOMAINS="-d $domain "
    done
    certbot $options --agree-tos -m $CERT_BOT_MAIL certonly --webroot \
      -w "${WWW_ROOT_DIR:-/data/htdocs/www}" $ADD_CERTBOT_DOMAINS \
      --put-all-related-files-into "$SSL_DIR" -key-path "$SSL_KEY" -fullchain-path "$SSL_CERT"
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
  www_dir="${WWW_ROOT_DIR:-/data/htdocs/www}"
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
  local home="${PGSQL_CONFIG_FILE:-$(__find_pgsql_conf)}"
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
  [ -f "$3" ] || return
  grep -s -q "$1" "$3" &>/dev/null || return
  sed -i 's|'$1'|'$2'|g' "$3" &>/dev/null
  grep -s -q "$2" "$3" && printf '%s\n' "Changed $1 to $2 in $3" && return 0 || {
    printf '%s\n' "Failed to change $1 in $3" && return 10
  }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__file_copy() {
  [ -e "$1" ] || return
  [ -n "$1" ] && [ -n "$2" ] && [ -e "$1" ] && cp -Rf "$1" "$2" &>/dev/null
  [ -e "$1" ] && [ -e "$2" ] && printf '%s\n' "Copied: $1 > $2" && return 0 || {
    printf '%s\n' "Copy failed: $1 < $2"
    return 1
  }
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_service_user() {
  local create_user="$1" create_gid="$1"
  local create_home_dir="/opt/$create_user" set_home_dir=""
  [ "$ENTRYPOINT_FIRST_RUN" = "no" ] || return 0
  [ -n "$SERVICE_USER" ] || [ "$SERVICE_USER" != "root" ] || return 0
  if ! grep -q "$create_user" "/etc/passwd"; then
    echo "creating system user $create_user"
    addgroup -g ${create_gid} -S $create_user &>/dev/null
    adduser -u ${create_gid} -D -h "$create_home_dir" -g $create_user $create_user &>/dev/null
    grep -q "$create_user" "/etc/passwd" "/etc/groups" && set_home_dir="$home_dir" && exitStatus=0 || exitStatus=0
  fi
  WORKDIR="${set_home_dir:-}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__create_env() {
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
  local exitCode=0 prog=""
  local cmdExec="${*:-bash -l}"
  prog="$(type -P "${1:-bash}" 2>/dev/null)"
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
  { [ "$1" = "" ] && shift 1; } || { [ "$1" = " " ] && shift 1; }
  [ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -o pipefail -x$DEBUGGER_OPTIONS || set -o pipefail
  local basename=""
  local init_pids=""
  local init_dir="${1:-/usr/local/etc/docker/init.d}"
  mkdir -p "/tmp" "/run" "/run/init.d"
  chmod -R 777 "/tmp" "/run" "/run/init.d"
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
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__setup_mta() {
  local exitCode=0
  local relay_port="${EMAIL_RELAY//*:/}"
  local relay_server="${EMAIL_RELAY//:*/}"
  local local_hostname="${FULL_DOMAIN_NAME:-}"
  local account_user="${SERVER_ADMIN//@*/}"
  local account_domain="${EMAIL_DOMAIN//*@/}"
  echo "$EMAIL_RELAY" | grep '[0-9][0-9]' || relay_port="465"

  ################# sSMTP relay setup
  if [ -n "$(type -P 'ssmtp')" ] || [ -d "/etc/ssmtp" ] || [ -d "/config/ssmtp" ]; then
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
    fi

    ################# postfix relay setup
  elif [ -n "$(type -P 'postfix')" ] || [ -d "/config/postfix" ] || [ -d "/etc/postfix" ]; then
    [ -d "/etc/postfix" ] || mkdir -p "/etc/postfix"
    [ -f "/etc/postfix/main.cf" ] && rm -Rf "/etc/postfix/main.cf"
    if [ ! -f "/config/postfix/main.cf" ]; then
      cat <<EOF | tee "/config/postfix/main.cf" &>/dev/null
# postfix configuration.
smtpd_banner = \$myhostname ESMTP email server
compatibility_level = 2
alias_maps = hash:/etc/postfix/aliases
alias_database = hash:/etc/postfix/aliases
mynetworks = /etc/postfix/mynetworks
transport_maps = hash:/etc/postfix/transport
virtual_alias_maps = hash:/etc/postfix/virtual
relay_domains = hash:/etc/postfix/mydomains, regexp:/etc/postfix/mydomains.pcre
tls_random_source = dev:/dev/urandom
smtp_use_tls = yes
smtpd_use_tls = yes
smtpd_tls_session_cache_database = btree:/etc/postfix/smtpd_scache
smtpd_tls_exclude_ciphers = aNULL, eNULL, EXPORT, DES, RC4, MD5, PSK, aECDH, EDH-DSS-DES-CBC3-SHA, EDH-RSA-DES-CBC3-SHA, KRB5-DES, CBC3-SHA
smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, defer_unauth_destination
mydestination =
inet_interfaces = all
append_dot_mydomain = yes
myorigin = $local_hostname
myhostname = $local_hostname
local_transport=error: local delivery disabled
relayhost = [$relay_server]:$relay_port
inet_protocols = ipv4

EOF
    fi
    touch "/config/postfix/aliases" "/config/postfix/mynetworks" "/config/postfix/transport"
    touch "/config/postfix/mydomains.pcre" "/config/postfix/mydomains" "/config/postfix/virtual"
    if [ -f "/config/postfix/main.cf" ] && [ ! -f "/run/init.d/postfix.pid" ]; then
      SERVICES_LIST+="postfix "
      cp -Rf "/config/postfix/." "/etc/postfix/"
      postmap "/etc/postfix/aliases" "/etc/postfix/mynetworks" "/etc/postfix/transport" &>/dev/null
      postmap "/etc/postfix/mydomains.pcre" "/etc/postfix/mydomains" "/etc/postfix/virtual" &>/dev/null
      __exec_command postfix "/etc/postfix/main.cf" &
      [ $? -eq 0 ] && touch "/run/init.d/postfix.pid" || exitCode=1
    fi
  fi
  [ -f "/root/dead.letter" ] && rm -Rf "/root/dead.letter"
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set variables from function calls
SET_RANDOM_PASS="${SET_RANDOM_PASS:-$(__random_password 14)}"
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end of functions
