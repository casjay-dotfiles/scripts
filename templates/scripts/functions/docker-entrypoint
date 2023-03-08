# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -o pipefail -x$DEBUGGER_OPTIONS || set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__rm() { [ -f "$1" ] && rm -Rf "${1:?}"; }
__cd() { [ -d "$1" ] && builtin cd "$1" || return 1; }
__ps() { [ -f "$(type -P ps)" ] && ps "$@" || return 10; }
__netstat() { [ -f "$(type -P netstat)" ] && netstat "$@" || return 10; }
__curl() { curl -q -sfI --max-time 3 -k -o /dev/null "$@" &>/dev/null || return 10; }
__find() { find "$1" -mindepth 1 -type ${2:-f,d} 2>/dev/null | grep '^' || return 10; }
__pcheck() { [ -n "$(which pgrep 2>/dev/null)" ] && pgrep -x "$1" &>/dev/null || return 10; }
__pgrep() { __pcheck "${1:-GEN_SCRIPT_REPLACE_APPNAME}" || __ps aux 2>/dev/null | grep -Fw " ${1:-$GEN_SCRIPT_REPLACE_APPNAME}" | grep -qv ' grep' || return 10; }
__get_ip6() { ip a 2>/dev/null | grep -w 'inet6' | awk '{print $2}' | grep -vE '^::1|^fe' | sed 's|/.*||g' | head -n1 | grep '^' || echo ''; }
__get_ip4() { ip a 2>/dev/null | grep -w 'inet' | awk '{print $2}' | grep -vE '^127.0.0' | sed 's|/.*||g' | head -n1 | grep '^' || echo '127.0.0.1'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_php_bin() { find -L '/usr'/*bin -maxdepth 4 -name 'php-fpm*' 2>/dev/null | grep '^' || echo ''; }
__find_php_ini() { find -L '/etc' -maxdepth 4 -name 'php.ini' 2>/dev/null | sed 's|/php.ini||g' | grep '^' || echo ''; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_nginx_conf() { find -L '/etc' -maxdepth 4 -name 'nginx.conf' 2>/dev/null | grep '^' || echo ''; }
__find_httpd_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'httpd.conf' -o -iname 'apache2.conf' 2>/dev/null | grep '^' || echo ''; }
__find_lighttpd_conf() { find -L '/etc' -maxdepth 4 -type f -iname 'lighttpd.conf' -o -iname 'apache2.conf' 2>/dev/null | grep '^' || echo ''; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__find_mysql_conf() { find -L '/etc' -maxdepth 4 -type f -name 'my.cnf' 2>/dev/null | grep '^' || echo ''; }
__find_pgsql_conf() { find -L '/var/lib' '/etc' -maxdepth 8 -type f -name 'postgresql.conf' 2>/dev/null | grep '^' || echo ''; }
__find_mongodb_conf() { return; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__random_password() { cat "/dev/urandom" | tr -dc '[0-9][a-z][A-Z]@$' | head -c${1:-14} && echo ""; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__setup_ssl() {
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
  if [ -f "/config/bin/certbot.sh" ]; then
    "/config/bin/certbot.sh"
  elif [ -f "/etc/named/certbot.sh" ]; then
    "/etc/named/certbot.sh"
  else
    local options="${1:-create}" && shift 1
    domain_list="$DOMAINNAME www.$DOMAINNAME mail.$DOMAINNAME $CERTBOT_DOMAINS"
    [ -f "/config/env/ssl.sh" ] && . "/config/env/ssl.sh"
    [ "$SSL_CERT_BOT" = "true" ] && [ -f "$(type -P certbot)" ] || { export SSL_CERT_BOT="" && return 10; }
    [ -n "$CERT_BOT_MAIL" ] || echo "The variable CERT_BOT_MAIL is not set" && return 1
    [ -n "$DOMAINNAME" ] || echo "The variable DOMAINNAME is not set" && return 1
    for domain in $$CERTBOT_DOMAINS; do
      [ -n "$domain" ] && ADD_CERTBOT_DOMAINS="-d $domain "
    done
    certbot $options --agree-tos -m $CERT_BOT_MAIL certonly --webroot \
      -w "${WWW_ROOT_DIR:-/data/htdocs/www}" \
      $ADD_CERTBOT_DOMAINS --put-all-related-files-into "$SSL_DIR" \
      -key-path "$SSL_KEY" -fullchain-path "$SSL_CERT" && __setup_ssl
  fi
  return $?
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
    __setup_ssl
    return 0
  else
    return 2
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_apache() {
  local etc_dir="/etc/${1:-apache2}"
  local conf_dir="/config/${1:-apache2}"
  local www_dir="${WWW_ROOT_DIR:-/data/htdocs/www}"
  #
  apache_bin="$(type -P 'httpd' || type -P 'apache2')"
  [ -e "$conf_dir" ] && [ -n "$apache_bin" ] || return 0
  echo "Initializing apache web server in $conf_dir"
  [ -d "$etc_dir" ] || mkdir -p "$etc_dir"
  [ -d "$etc_dir/conf.d" ] && rm -R "$etc_dir/conf.d"/*
  [ -d "$conf_dir" ] && cp -Rf "$conf_dir/." "$etc_dir/"
  if [ "$SSL_ENABLED" = "true" ]; then
    __file_copy "$conf_dir/httpd.ssl.conf" "$etc_dir/httpd.conf"
    __file_copy "$conf_dir/vhosts.d/default.ssl.conf" "$etc_dir/vhosts.d/default.ssl.conf"
  else
    for ssl_conf in "$conf_dir/httpd.ssl.conf" "$etc_dir/vhosts.d/default.ssl.conf"; do
      [ -n "$ssl_conf" ] && [ -f "$ssl_conf" ] && rm -Rf "$ssl_conf"
    done
  fi
  [ -d "$www_dir" ] || mkdir -p "$www_dir"
  __replace "SERVER_PORT" "${SERVICE_PORT:-80}" "$etc_dir/httpd.conf"
  __replace "SERVER_NAME" "${SERVER_NAME:-$HOSTNAME}" "$etc_dir/httpd.conf"
  __replace "SERVER_PORT" "${SERVICE_PORT:-80}" "$etc_dir/vhosts.d/default.conf"
  __replace "SERVER_ADMIN" "${SERVER_ADMIN:-root@$SERVER_NAME}" "$etc_dir/httpd.conf"
  [ -f "$www_dir/www/index.php" ] && __replace "SERVER_SOFTWARE" "apache" "$www_dir/www/index.php"
  [ -f "$www_dir/www/index.html" ] && __replace "SERVER_SOFTWARE" "apache" "$www_dir/www/index.html"
  if [ -z "$PHP_BIN_DIR" ]; then
    [ -f "$www_dir/www/info.php" ] && echo "PHP support is not enabled" >"$www_dir/www/info.php"
    [ -f "$etc_dir/conf.d/php-fpm.conf" ] && echo "# PHP support is not enabled" >"$etc_dir/conf.d/php-fpm.conf"
  fi
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_nginx() {
  local etc_dir="/etc/${1:-nginx}"
  local conf_dir="/config/${1:-nginx}"
  local www_dir="${WWW_ROOT_DIR:-/data/htdocs}"
  #
  nginx_bin="$(type -P 'nginx')"
  [ -e "$conf_dir" ] && [ -n "$nginx_bin" ] || return 0
  echo "Initializing nginx web server in $conf_dir"
  [ -d "$etc_dir" ] || mkdir -p "$etc_dir"
  [ -d "$conf_dir" ] && cp -Rf "$conf_dir/." "$etc_dir/"
  if [ "$SSL_ENABLED" = "true" ]; then
    __file_copy "/config/nginx/nginx.ssl.conf" "/etc/nginx/nginx.ssl.conf"
  else
    [ -n "$ssl_conf" ] && [ -f "$ssl_conf" ] && rm -Rf "/etc/nginx/nginx.ssl.conf"
  fi
  __replace "SERVER_PORT" "${SERVICE_PORT:-80}" "$etc_dir/nginx.conf"
  __replace "SERVER_PORT" "${SERVICE_PORT:-80}" "$etc_dir/vhosts.d/nginx.conf"
  [ -f "$www_dir/www/index.php" ] && __replace "SERVER_SOFTWARE" "nginx" "$www_dir/www/index.php"
  [ -f "$www_dir/www/index.html" ] && __replace "SERVER_SOFTWARE" "nginx" "$www_dir/www/index.html"
  if [ -z "$PHP_BIN_DIR" ]; then
    [ -f "$www_dir/www/info.php" ] && echo "PHP support is not enabled" >"$www_dir/www/info.php"
    [ -f "$etc_dir/conf.d/php-fpm.conf" ] && echo "# PHP support is not enabled" >"$etc_dir/conf.d/php-fpm.conf"
  fi
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_php() {
  local etc_dir="/etc/${1:-php}"
  local conf_dir="/config/${1:-php}"
  php_bin="$(type -P "${PHP_BIN_DIR:-$(__find_php_bin)}")"
  #
  [ -e "$conf_dir" ] && [ -n "$php_bin" ] || return 0
  echo "Initializing php in $conf_dir"
  if [ -n "$PHP_VERSION" ] && [ ! -d "/etc/php" ]; then
    [ -d "/etc/php" ] && rm -Rf "/etc/php"
    if [ -d "/etc/php${PHP_VERSION}" ]; then
      ln -sf "/etc/php${PHP_VERSION}" "/etc/php"
    fi
  fi
  [ -d "$etc_dir" ] || mkdir -p "$etc_dir"
  [ -d "$conf_dir" ] && cp -Rf "$conf_dir/." "$etc_dir/"
  [ -d "$conf_dir/conf.d" ] && rm -R $etc_dir/conf.d/*
  [ "$etc_dir" = "/etc/php" ] || ln -sf "$etc_dir" "/etc/php"
  [ -d "/config/php" ] && cp -Rf "/config/php/." "$PHP_INI_DIR"
  [ -f "$www_dir/www/index.php" ] && __replace "SERVER_SOFTWARE" "php" "$www_dir/www/index.php"
  [ -f "$www_dir/www/index.html" ] && __replace "SERVER_SOFTWARE" "php" "$www_dir/www/index.html"
  if [ -z "$PHP_BIN_DIR" ]; then
    [ -f "$www_dir/www/info.php" ] && echo "PHP support is not enabled" >"$www_dir/www/info.php"
  fi
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
  [ -f "/config/secure/mysql_root_pass" ] && root_pass="$(<"/config/secure/mysql_root_pass")"
  mysqld_bin="$(type -P 'mysqld')"
  [ -e "$conf_dir" ] && [ -n "$mysqld_bin" ] || return 0
  echo "Initializing mysql database server in $conf_dir"
  rm -Rf "/etc/my.*" "/etc/mysql"
  [ -d "$etc_dir" ] || mkdir -p "$etc_dir"
  [ -d "$conf_dir" ] && cp -Rf "$conf_dir/." "$etc_dir/"
  [ -d "$db_dir" ] || mysql_install_db --datadir=$db_dir --user=$db_user &>/dev/null
  chown -Rf $db_user:$db_user $db_dir
  if [ -n "$user_db" ]; then
    mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $user_db;
CREATE USER '$user_name'@'%' IDENTIFIED BY '$pass';
GRANT ALL PRIVILEGES ON $user_db.* TO '$user_db'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
  fi
  [ -n "$user_name" ] && echo "mysql user name is: $user_name"
  [ -n "$user_pass" ] && echo "mysql user pass is: $user_pass"
  [ -n "$root_pass" ] && echo "mysql root pass is: $root_pass"
  sleep 5
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_mongodb() {
  local home="${MONGODB_CONFIG_FILE:-$(__find_mongodb_conf)}"
  local user_pass="${MONGO_INITDB_ROOT_PASSWORD:-$_ROOT_PASSWORD}"
  local user_name="${INITDB_ROOT_USERNAME:-root}"
  VCAP_APP_HOST="${VCAP_APP_HOST:-0.0.0.0}"
  VCAP_APP_PORT="${VCAP_APP_PORT:-19054}"
  SERVICE_PORT="${ME_CONFIG_MONGODB_SERVER:-$VCAP_APP_PORT}"
  ME_CONFIG_EDITORTHEME="${ME_CONFIG_EDITORTHEME:-dracula}"
  ME_CONFIG_MONGODB_URL="${ME_CONFIG_MONGODB_URL:-mongodb://127.0.0.1:27017}"
  ME_CONFIG_MONGODB_ENABLE_ADMIN="${ME_CONFIG_MONGODB_ENABLE_ADMIN:-true}"
  ME_CONFIG_BASICAUTH_USERNAME="${ME_CONFIG_BASICAUTH_USERNAME:-}"
  ME_CONFIG_BASICAUTH_PASSWORD="${ME_CONFIG_BASICAUTH_PASSWORD:-}"
  ME_CONFIG_BASICAUTH_USERNAME_FILE="${ME_CONFIG_BASICAUTH_USERNAME_FILE:-}"
  ME_CONFIG_BASICAUTH_PASSWORD_FILE="${ME_CONFIG_BASICAUTH_PASSWORD_FILE:-}"
  ME_CONFIG_MONGODB_ADMINUSERNAME_FILE="${ME_CONFIG_MONGODB_ADMINUSERNAME_FILE:-}"
  ME_CONFIG_MONGODB_ADMINPASSWORD_FILE="${ME_CONFIG_MONGODB_ADMINPASSWORD_FILE:-}"
  ME_CONFIG_MONGODB_AUTH_USERNAME_FILE="${ME_CONFIG_MONGODB_AUTH_USERNAME_FILE:-}"
  ME_CONFIG_MONGODB_AUTH_PASSWORD_FILE="${ME_CONFIG_MONGODB_AUTH_PASSWORD_FILE:-}"
  ME_CONFIG_MONGODB_CA_FILE="${ME_CONFIG_MONGODB_CA_FILE:-}"
  VCAP_APP_HOST="${VCAP_APP_HOST:-0.0.0.0}"
  VCAP_APP_PORT="${VCAP_APP_PORT:-19054}"
  [ -n "$user_name" ] && echo "mongodb user name is: $user_name"
  [ -n "$user_pass" ] && echo "mongodb user pass is: $user_pass"
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_postgres() {
  local home="${PGSQL_CONFIG_FILE:-$(__find_pgsql_conf)}"
  local user_pass="${POSTGRES_PASSWORD:-$POSTGRES_ROOT_PASSWORD}"
  local user_name="${POSTGRES_USER:-root}"
  [ -f "/config/secure/pgsql_root_pass" ] && root_pass="$(<"/config/secure/pgsql_root_pass")"

  [ -n "$user_name" ] && echo "postgresql user name is: $user_name"
  [ -n "$user_pass" ] && echo "postgresql user pass is: $user_pass"
  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__init_couchdb() {
  export PATH="/opt/couchdb/bin:$PATH"
  local home="${PGSQL_CONFIG_FILE:-$(__find_pgsql_conf)}"
  local user_pass="${COUCHDB_PASSWORD:-$SET_RANDOM_PASS}"
  local user_name="${COUCHDB_USER:-root}"

  if [ "$DATA_DIR_INITIALIZED" = "false" ]; then
    {
      sleep 60
      echo "Creating the default databases"
      __curl -X PUT "http://127.0.0.1:5984/_users" &>/dev/null &&
        echo "Created database _users"
      __curl -X PUT "http://127.0.0.1:5984/_replicator" &>/dev/null &&
        echo "Created database _replicator"
      __curl -X PUT "http://127.0.0.1:5984/_global_changes" &>/dev/null &&
        echo "Created database _global_changes"
      echo ""
    } >"/dev/stdout" &
  fi
  [ -d "/data/couchdb" ] || mv -f "/opt/couchdb/data" "/data/couchdb"
  [ -d "/opt/couchdb/data" ] && rm -Rf "/opt/couchdb/data"
  ln -sf "/data/couchdb" "/opt/couchdb/data" 2>/dev/null
  touch "/opt/couchdb/etc/local.d/docker.ini" 2>/dev/null
  chown -Rf couchdb:couchdb "/data/couchdb" "/opt/couchdb" 2>/dev/null

  [ -n "$user_name" ] && echo "postgresql user name is: $user_name"
  [ -n "$user_pass" ] && echo "postgresql user pass is: $user_pass"

  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show available init functions
__init_help() {
  echo '
__init_apache
__init_nginx
__init_php
__init_mysql
__init_mongodb
__init_postgres
__init_couchdb
__certbot
__setup_ssl
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
__cron() {
  local interval="$1" && shift 1
  local command="$*"
  while :; do
    eval "$command"
    sleep $interval
  done
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
  [ -f "/usr/local/share/template-files/config/env.sample" ] || return 0
  for create_env in "/usr/local/etc/docker/env/default.sh" "${envFile[@]}"; do
    dir="$(dirname "$create_env")"
    [ -d "$dir" ] || mkdir -p "$dir"
    if [ -n "$create_env" ] && [ ! -f "$create_env" ]; then
      cat <<EOF | tee "$create_env" &>/dev/null
$(<"/usr/local/share/template-files/config/env.sample")
EOF
    fi
    [ -f "$create_env" ] || envStatus=$((1 + envStatus))
  done
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
        (eval "$init" 2>/dev/stderr >/dev/stdout &)
        initStatus=$(($? + initStatus))
        sleep 30
      fi
    done
  fi
  return $initStatus
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

  if [ -d "/etc/ssmtp" ] || [ -d "/config/ssmtp" ]; then
    # sSMTP relay setup
    [ -d "/etc/ssmtp" ] && rm -Rf "/etc/ssmtp" || return 0
    [ -d "/config/ssmtp" ] || mkdir -p "/config/ssmtp"
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
    # if [ -f "/config/ssmtp/ssmtp.conf" ] && [ ! -f "/run/init.d/ssmtp.pid" ]; then
    # SERVICES_LIST+="ssmtp "
    # cp -Rf "/config/ssmtp/." "/etc/ssmtp/"
    # __exec_command ssmtp "/etc/ssmtp/ssmtp.conf" &
    # [ $? -eq 0 ] && touch "/run/init.d/ssmtp.pid" || exitCode=1
    # fi
    # postfix relay setup
  elif [ -d "/config/postfix" ] || [ -d "/etc/postfix" ]; then
    cat <<EOF | tee "/config/postfix/main.cf" &>/dev/null
# postfix configuration.
smtpd_banner = \$myhostname ESMTP CasjaysDev mail
compatibility_level = 2
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mynetworks = /etc/postfix/mynetworks
transport_maps = hash:/etc/postfix/transport
virtual_alias_maps = hash:/etc/postfix/virtual
relay_domains = hash:/etc/postfix/mydomains, regexp:/etc/postfix/mydomains.pcre
tls_random_source = dev:/dev/urandom
smtp_use_tls = yes
smtpd_use_tls = yes
smtpd_tls_session_cache_database = btree:/etc/postfix/smtpd_scache
smtpd_tls_dh1024_param_file = /etc/ssl/dhparam/1024.pem
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
    touch "/etc/aliases" "/etc/postfix/mynetworks" "/etc/postfix/transport"
    touch "/etc/postfix/mydomains.pcre" "/etc/postfix/mydomains" "/etc/postfix/virtual"
    postmap "/etc/aliases" "/etc/postfix/mynetworks" "/etc/postfix/transport" &>/dev/null
    postmap "/etc/postfix/mydomains.pcre" "/etc/postfix/mydomains" "/etc/postfix/virtual" &>/dev/null
    if [ -f "/config/postfix/main.cf" ] && [ ! -f "/run/init.d/postfix.pid" ]; then
      SERVICES_LIST+="postfix "
      cp -Rf "/config/postfix/." "/etc/postfix/"
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
export CONTAINER_IP4_ADDRESS CONTAINER_IP6_ADDRESS
export PHP_INI_DIR PHP_BIN_DIR HTTPD_CONFIG_FILE
export NGINX_CONFIG_FILE MYSQL_CONFIG_FILE PGSQL_CONFIG_FILE
export ENTRYPOINT_FIRST_RUN SET_RANDOM_PASS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export the functions
export -f __setup_ssl __certbot __create_ssl_cert __init_apache __init_nginx
export -f __init_php __init_mysql __init_mongodb __init_postgres __init_couchdb
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end of functions
