# rewrite variables
[ -n "$HOST_NETWORK_ADDR" ] || HOST_NETWORK_ADDR="no"
[ "$HOST_NETWORK_ADDR" = "all" ] || HOST_NETWORK_ADDR="yes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SERVER_SHORT_DOMAIN="$(hostname -s 2>/dev/null | grep '^')"
SERVER_FULL_DOMAIN="$(hostname -d 2>/dev/null | grep '^' || echo 'home')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Variables - Do not change anything below this line
ENV_PORTS=""
DOCKER_OPTS=""
NGINX_LISTEN_OPTS=""
CONTAINER_LISTEN="127.0.0.1"
HOST_TIMEZONE="${TZ:-$TIMEZONE}"
DEFINE_LISTEN="${DEFINE_LISTEN:-}"
HOST_IP="${CURRENT_IP_4:-$(__local_lan_ip)}"
HOST_LISTEN_ADDR="${DEFINE_LISTEN:-$HOST_IP}"
CONTAINER_SHM_SIZE="${CONTAINER_SHM_SIZE:-64M}"
HOST_SERVICE_PORT="${CONTAINER_SERVICE_PORT:-}"
CONTAINER_HTTP_PROTO="${CONTAINER_HTTP_PROTO:-http}"
SET_HOSTNAME="${OPT_CONTAINER_HOSTNAME:-SET_HOSTNAME}"
CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-SET_HOSTNAME}"
HOST_NETWORK_TYPE="--network ${HOST_NETWORK_TYPE:-bridge}"
SET_DOMAINNAME="${OPT_CONTAINER_DOMAINNAME:-$SET_DOMAINNAME}"
POST_SHOW_FINISHED_MESSAGE="${POST_SHOW_FINISHED_MESSAGE:-}"
HOST_WEB_PORT="${CONTAINER_HTTPS_PORT:-$CONTAINER_HTTP_PORT}"
CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-$SET_DOMAINNAME}"
SET_USER_NAME="${CONTAINER_USER_NAME:-$GEN_SCRIPT_REPLACE_APPENV_NAME_USERNAME}"
SET_USER_PASS="${CONTAINER_USER_PASS:-$GEN_SCRIPT_REPLACE_APPENV_NAME_PASSWORD}"
CONTAINER_DOMAINNAME="${CONTAINER_DOMAINNAME:-$APPNAME.$SERVER_SHORT_DOMAIN.$SERVER_FULL_DOMAIN}"
echo "$CONTAINER_HOSTNAME" | grep -Fq '.' || CONTAINER_HOSTNAME="$APPNAME.$SERVER_SHORT_DOMAIN.$SERVER_FULL_DOMAIN"
[[ "$CONTAINER_DOMAINNAME" = server.* ]] && CONTAINER_HOSTNAME="$APPNAME.$SERVER_FULL_DOMAIN" || CONTAINER_HOSTNAME="${CONTAINER_HOSTNAME:-$APPNAME.$CONTAINER_DOMAINNAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Configure variables
[ -n "$CONTAINER_NAME" ] || CONTAINER_NAME="$(__name)"
[ "$HOST_NETWORK_ADDR" = "yes" ] && CONTAINER_PRIVATE="yes"
[ "$CONTAINER_HTTPS_PORT" = "" ] || CONTAINER_HTTP_PROTO="https"
[ "$CGROUP_ENABLED" = "yes" ] && ADDITIONAL_MOUNTS="$CGROUP_MOUNTS "
[ "$SET_USER_PASS" = "random" ] && CONTAINER_USER_PASS="$RANDOM_PASS"
[ "$HOST_ETC_HOSTS_FILE" = "yes" ] && ADDITIONAL_MOUNTS+="/etc/hosts:/usr/local/etc/hosts:ro "
[ "$DOCKER_SOCKET_ENABLED" = "yes" ] && ADDITIONAL_MOUNTS+="$DOCKER_SOCKET_MOUNT:/var/run/docker.sock "
[ "$DOCKER_CONFIG_ENABLED" = "yes" ] && ADDITIONAL_MOUNTS="$DOCKER_CONFIG_MOUNT:$DOCKER_CONFIG_TO_MOUNT:ro "
[ "$HOST_NETWORK_ADDR" = "yes" ] && DEFINE_LISTEN="127.0.0.1" && HOST_LISTEN_ADDR="127.0.0.1" || HOST_NETWORK_ADDR=""
[ "$HOST_NETWORK_ADDR" = "local" ] && DEFINE_LISTEN="127.0.0.1" && HOST_LISTEN_ADDR="127.0.0.1" || HOST_NETWORK_ADDR=""
[ "$HOST_NETWORK_ADDR" = "public" ] && DEFINE_LISTEN="0.0.0.0" && HOST_LISTEN_ADDR="$(__local_lan_ip)" || HOST_NETWORK_ADDR=""
[ "$HOST_NETWORK_ADDR" = "lan" ] && DEFINE_LISTEN="$(__local_lan_ip)" && HOST_LISTEN_ADDR="$(__local_lan_ip)" || HOST_NETWORK_ADDR=""
[ "$HOST_NETWORK_ADDR" = "docker" ] && DEFINE_LISTEN="$(__docker_gateway_ip)" && HOST_LISTEN_ADDR="$(__docker_gateway_ip)" || HOST_NETWORK_ADDR=""
[ "$HOST_RESOLVE_MOUNT" = "yes" ] && ADDITIONAL_MOUNTS+="$HOST_RESOLVE_MOUNT:/etc/resolv.conf " || HOST_RESOLVE_MOUNT=""
[ "$NGINX_SSL" = "yes" ] && [ -n "$NGINX_HTTPS" ] && NGINX_PORT="${NGINX_HTTPS:-443}" && NGINX_LISTEN_OPTS="ssl http2" || NGINX_PORT="${NGINX_HTTP:-80}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite variables
[ -n "$HUB_IMAGE_TAG" ] || HUB_IMAGE_TAG="latest"
[ -n "$HOST_TIMEZONE" ] || HOST_TIMEZONE="America/New_York"
[ -n "$HOST_WEB_PORT" ] && HOST_WEB_PORT="${HOST_WEB_PORT:-}"
[ -n "$CUSTOM_ARGUMENTS" ] && CUSTOM_ARGUMENTS="${CUSTOM_ARGUMENTS//,/ }"
[ -n "$DEFINE_LISTEN" ] && DEFINE_LISTEN="${DEFINE_LISTEN//:*/}" || DEFINE_LISTEN=""
[ -n "$CONTAINER_DOMAINNAME" ] && CUSTOM_ARGUMENTS+="--domainname $CONTAINER_DOMAINNAME "
[ -n "$CONTAINER_COMMANDS" ] && CONTAINER_COMMANDS="${CONTAINER_COMMANDS//,/ }" || CONTAINER_COMMANDS=""
[ -z "$CONTAINER_USER_NAME" ] || ADDITION_ENV+="${CONTAINER_ENV_USER_NAME:-username}=$CONTAINER_USER_NAME "
[ -z "$CONTAINER_USER_PASS" ] || ADDITION_ENV+="${CONTAINER_ENV_PASS_NAME:-password}=$CONTAINER_USER_PASS "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IS_PRIVATE="${HOST_WEB_PORT:-$CONTAINER_SERVICE_PORT}"
CLEANUP_PORT="${HOST_SERVICE_PORT:-$IS_PRIVATE}"
CLEANUP_PORT="${CLEANUP_PORT//\/*/}"
PRETTY_PORT="$CLEANUP_PORT"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if echo "$PRETTY_PORT" | grep -q ':.*.:'; then
  NGINX_PROXY_PORT="$(echo "$PRETTY_PORT" | grep ':.*.:' | awk -F':' '{print $2}' | grep '^')"
else
  NGINX_PROXY_PORT="$(echo "$PRETTY_PORT" | grep -v ':.*.:' | awk -F':' '{print $2}' | grep '^')"
fi
[ -n "$NGINX_PROXY_PORT" ] || NGINX_PROXY_PORT="$CLEANUP_PORT"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$HOST_NETWORK_TYPE" = "host" ] && HOST_NETWORK_TYPE="--net-host"
[ "$CONTAINER_TTY" = "yes" ] && DOCKER_OPTS+="--tty " || CONTAINER_TTY=""
[ "$CONTAINER_INTERACTIVE" = "yes" ] && DOCKER_OPTS+="--interactive " || CONTAINER_INTERACTIVE=""
[ "$CONTAINER_IS_PRIVILEGED" = "yes" ] && DOCKER_OPTS+="--privileged " || CONTAINER_IS_PRIVILEGED=""
[ "$CONTAINER_AUTO_DELETE" = "yes" ] && DOCKER_OPTS+="--rm " && CONTAINER_AUTO_RESTART="" || CONTAINER_AUTO_DELETE=""
[ -n "$CONTAINER_AUTO_RESTART" ] && DOCKER_OPTS+="--restart=$CONTAINER_AUTO_RESTART " || DOCKER_OPTS+="--restart=unless-stopped "
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$SET_USER_ID" = "yes" ]; then
  [ -n "$CONTAINER_USER_ID" ] && ADDITION_ENV+="PUID=$CONTAINER_USER_ID " || ADDITION_ENV+="PUID=$(id -u) "
  [ -n "$CONTAINER_GROUP_ID" ] && ADDITION_ENV+="PGID=$CONTAINER_GROUP_ID " || ADDITION_ENV+="PGID=$(id -g) "
fi
CONTAINER_USER_ID=""
CONTAINER_GROUP_ID=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup display if enabled
if [ "$CONTAINER_DISPLAY" = "yes" ]; then
  ADDITION_ENV+="DISPLAY=:${DISPLAY//*:/} "
  ADDITIONAL_MOUNTS+="${HOST_X11_SOCKET:-/tmp/.X11-unix}:/tmp/.X11-unix "
  if [ -n "$HOST_X11_XAUTH" ] && [ -n "$CONTAINER_X11_XAUTH" ]; then
    ADDITIONAL_MOUNTS+="$HOST_X11_XAUTH:$CONTAINER_X11_XAUTH "
  fi
fi
HOST_X11_XAUTH=""
CONTAINER_DISPLAY=""
CONTAINER_X11_XAUTH=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$WEB_SERVER_AUTH" = "yes" ]; then
  CONTAINER_USER_NAME="${CONTAINER_USER_NAME:-root}"
  CONTAINER_USER_PASS="${CONTAINER_USER_PASS:-$RANDOM_PASS}"
  SET_USER_NAME="$CONTAINER_USER_NAME"
  SET_USER_PASS="$CONTAINER_USER_PASS"
  [ -d "/etc/nginx/auth" ] || mkdir -p "/etc/nginx/auth"
  if [ ! -f "/etc/nginx/auth/$APPNAME" ] && [ -n "$(builtin type -P htpasswd)" ]; then
    if ! grep -q "$CONTAINER_USER_NAME"; then
      printf_yellow "Creating auth /etc/nginx/auth/$APPNAME"
      htpasswd -b -c "/etc/nginx/auth/$APPNAME" "$CONTAINER_USER_NAME" "$CONTAINER_USER_PASS" &>/dev/null
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
# Auto create web server
if [ "$WEB_SERVER" = "yes" ]; then
  WEB_SERVER_IP="$(__docker_gateway_ip)"
  WEB_SERVER_PORT="${WEB_SERVER_PORT//,/ }"
  CONTAINER_HTTP_PORT=""
  CONTAINER_HTTPS_PORT=""
  for web_ports in $WEB_SERVER_PORT; do
    RANDOM_PORT="$(__rport)"
    TYPE="$(echo "$web_ports" | awk -F '/' '{print $NF}' | grep '^' || echo '')"
    SET_WEB_PORT="$WEB_SERVER_IP:$RANDOM_PORT"
    #[ -n "$TYPE" ] &&
    # CONTAINER_ADD_CUSTOM_LISTEN+="$WEB_SERVER_IP:$RANDOM_PORT:$web_ports/$TYPE " ||
    CONTAINER_ADD_CUSTOM_LISTEN+="$WEB_SERVER_IP:$RANDOM_PORT:$web_ports "
  done
  [ "$WEB_SSL_ENABLE" = "yes" ] && CONTAINER_HTTP_PROTO="https" || CONTAINER_HTTP_PROTO="http"
  NGINX_PROXY_PORT="$(echo "$CONTAINER_ADD_CUSTOM_LISTEN" | tr ' ' '\n' | awk -F':' '{print $1":"$2}' | awk -F ':' '{print $1":"$2}' | head -n1)"
  CLEANUP_PORT="$NGINX_PROXY_PORT"
  CLEANUP_PORT="${CLEANUP_PORT//\/*/}"
  PRETTY_PORT="$CLEANUP_PORT"
  NGINX_PROXY_PORT="$PRETTY_PORT"
  CONTAINER_HOSTNAME="$HOST_LISTEN_ADDR"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_LINK=""
CONTAINER_LINK="${CONTAINER_LINK//,/ }"
for link in $CONTAINER_LINK; do
  [ "$link" = " " ] && link=""
  if [ -n "$link" ]; then
    SET_LINK+="--link $link "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_LABELS=""
ADDITION_LABELS="${ADDITION_LABELS//,/ }"
for label in $ADDITION_LABELS; do
  [ "$label" = " " ] && label=""
  if [ -n "$label" ]; then
    SET_LABELS+="--label $label "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_CAP=""
ADD_CAPABILITIES="${ADD_CAPABILITIES//,/ }"
for cap in $ADD_CAPABILITIES; do
  [ "$cap" = " " ] && cap=""
  if [ -n "$cap" ]; then
    SET_CAP+="--cap-add $cap "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_SYSCTL=""
ADD_SYSCTL="${ADD_SYSCTL//,/ }"
for sysctl in $ADD_SYSCTL; do
  [ "$sysctl" = " " ] && sysctl=""
  if [ -n "$sysctl" ]; then
    SET_SYSCTL+="--sysctl $sysctl "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_ENV=""
OPT_ENV_VAR="${OPT_ENV_VAR//,/ }"
ADDITION_ENV="${ADDITION_ENV//,/ }"
if [ -n "$OPT_ENV_VAR" ]; then
  for env in $OPT_ENV_VAR; do
    SET_ENV+="--env $env "
  done
fi
for env in $ADDITION_ENV; do
  [ "$env" = " " ] && env=""
  if [ -n "$env" ]; then
    SET_ENV+="--env $env "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_DEV=""
ADDITION_DEVICES="${ADDITION_DEVICES//,/ }"
for dev in $ADDITION_DEVICES; do
  [ "$dev" = " " ] && dev=""
  if [ -n "$dev" ]; then
    echo "$dev" | grep -q ':' || dev="$dev:$dev"
    SET_DEV+="--device $dev "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_MNT=""
ADDITIONAL_MOUNTS="${ADDITIONAL_MOUNTS//,/ }"
for mnt in $ADDITIONAL_MOUNTS; do
  [ "$mnt" = "" ] && mnt=""
  [ "$mnt" = " " ] && mnt=""
  if [ -n "$mnt" ]; then
    echo "$mnt" | grep -q ':' || port="$mnt:$mnt"
    SET_MNT+="--volume $mnt "
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_PORT=""
OPT_PORT_VAR="${OPT_PORT_VAR//,/ }"
SET_LISTEN="${DEFINE_LISTEN//:*/}"
if [ -n "$OPT_PORT_VAR" ]; then
  for port in $OPT_PORT_VAR; do
    if [ "$port" != "" ] && [ "$port" != " " ]; then
      echo "$port" | grep -q ':' || port="${port//\/*/}:$port"
      SET_PORT+="--publish $port "
    fi
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET_SERVER_PORTS="$CONTAINER_HTTP_PORT $CONTAINER_HTTPS_PORT $CONTAINER_SERVICE_PORT $CONTAINER_ADD_CUSTOM_PORT"
SET_SERVER_PORTS="${SET_SERVER_PORTS//,/ }"
for port in $SET_SERVER_PORTS; do
  if [ "$port" != " " ] && [ -n "$port" ]; then
    echo "$port" | grep -q ':' || port="${port//\/*/}:$port"
    if [ "$CONTAINER_PRIVATE" = "yes" ] && [ "$port" = "${IS_PRIVATE//\/*/}" ]; then
      HOST_LISTEN_ADDR="$CONTAINER_LISTEN"
      SET_PORT+="--publish $CONTAINER_LISTEN:$port "
    elif [ -n "$SET_LISTEN" ]; then
      SET_PORT+="--publish $SET_LISTEN$port "
    else
      SET_PORT+="--publish $port "
    fi
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CONTAINER_ADD_CUSTOM_LISTEN="${CONTAINER_ADD_CUSTOM_LISTEN//,/ }"
if [ -n "$CONTAINER_ADD_CUSTOM_LISTEN" ]; then
  for list in $CONTAINER_ADD_CUSTOM_LISTEN; do
    echo "$list" | grep -q ':' || list="${list//\/*/}:$list"
    SET_PORT+="--publish $list "
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL setup
NGINX_PROXY_URL=""
PROXY_HTTP_PROTO="http"
if [ "$NGINX_SSL" = "yes" ]; then
  [ "$SSL_ENABLED" = "yes" ] && PROXY_HTTP_PROTO="https"
  if [ "$PROXY_HTTP_PROTO" = "https" ]; then
    NGINX_PROXY_URL="$PROXY_HTTP_PROTO://$HOST_LISTEN_ADDR:$NGINX_PROXY_PORT"
    if [ -f "$HOST_SSL_CRT" ] && [ -f "$HOST_SSL_KEY" ]; then
      [ -f "$CONTAINER_SSL_CA" ] && ADDITIONAL_MOUNTS+="$HOST_SSL_CA:$CONTAINER_SSL_CA "
      ADDITIONAL_MOUNTS+="$HOST_SSL_CRT:$CONTAINER_SSL_CRT "
      ADDITIONAL_MOUNTS+="$HOST_SSL_KEY:$CONTAINER_SSL_KEY "
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
  cp -Rf "$INSTDIR/rootfs/." "$DATADIR/"
  find "$DATADIR" -name ".gitkeep" -type f -exec rm -rf {} \; &>/dev/null
fi
if [ -f "$DATADIR/.installed" ]; then
  date +'Updated on %Y-%m-%d at %H:%M' >"$DATADIR/.installed"
else
  date +'installed on %Y-%m-%d at %H:%M' >"$DATADIR/.installed"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main progam
CONTAINER_HOSTNAME="${HOST_LISTEN_ADDR//:*/}"
ENV_PORTS+="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | grep ':.*.:' | awk -F ':' '{print $1":"$3}')"
ENV_PORTS+="$(echo "$SET_WEB_PORT" | tr ' ' '\n' | grep -v ':.*.:' | awk -F ':' '{print $1":"$2}')"
ENV_PORTS="$(echo "$ENV_PORTS" | tr ' ' '\n' | sort -u | grep '^')"
ENV_PORTS="${ENV_PORTS//--publish/}"
EXECUTE_PRE_INSTALL="docker stop $CONTAINER_NAME;docker rm -f $CONTAINER_NAME"
EXECUTE_DOCKER_CMD="docker run -d --name=$CONTAINER_NAME $SET_LABELS $SET_LINK --shm-size=$CONTAINER_SHM_SIZE $DOCKER_OPTS $SET_CAP $SET_SYSCTL --hostname $CONTAINER_HOSTNAME --env TZ=$HOST_TIMEZONE --env ENV_PORTS=\"$ENV_PORTS\" --env TIMEZONE=$HOST_TIMEZONE $SET_ENV $SET_DEV $SET_MNT $SET_PORT $CUSTOM_ARGUMENTS $HOST_NETWORK_TYPE $HUB_IMAGE_URL:$HUB_IMAGE_TAG $CONTAINER_COMMANDS"
EXECUTE_DOCKER_CMD="${EXECUTE_DOCKER_CMD//  / }"
if cmd_exists docker-compose && [ -f "$INSTDIR/docker-compose.yml" ]; then
  printf_yellow "Installing containers using docker-compose"
  sed -i 's|REPLACE_DATADIR|'$DATADIR'' "$INSTDIR/docker-compose.yml"
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
    printf '#!/usr/bin/env bash\n\n%s\n%s\n\n' "$EXECUTE_PRE_INSTALL" "$EXECUTE_DOCKER_CMD" >"$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
    [ -f "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME" ] && chmod -Rf 755 "$DOCKERMGR_CONFIG_DIR/scripts/$CONTAINER_NAME"
  fi
  if __sudo "$EXECUTE_DOCKER_SCRIPT" 1>/dev/null 2>"${TMP:-/tmp}/$APPNAME.err.log"; then
    rm -Rf "${TMP:-/tmp}/$APPNAME.err.log"
  else
    ERROR_LOG="true"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
set -x
[ ! -f "$INSTDIR/nginx/proxy.conf" ] && NGINX_UPDATE_CONF="yes"
if [ "$NGINX_PROXY" = "yes" ]; then
  if [ "$NGINX_UPDATE_CONF" = "yes" ] && [ -f "$INSTDIR/nginx/proxy.conf" ]; then
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
set +x
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
run_postinst() {
  dockermgr_run_post
  [ -w "/etc/hosts" ] || return 0
  if ! grep -sq "$CONTAINER_HOSTNAME" "/etc/hosts"; then
    if [ -n "$PRETTY_PORT" ]; then
      if [ $(hostname -d 2>/dev/null | grep '^') = 'home' ]; then
        echo "$HOST_LISTEN_ADDR     $APPNAME.home" | sudo tee -a "/etc/hosts" &>/dev/null
      else
        echo "$HOST_LISTEN_ADDR     $APPNAME.home" | sudo tee -a "/etc/hosts" &>/dev/null
        echo "$HOST_LISTEN_ADDR     $CONTAINER_HOSTNAME" | sudo tee -a "/etc/hosts" &>/dev/null
      fi
    fi
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
SET_PORT="${SET_PORT//--publish/}"
HOST_WEB_PORT="${HOST_WEB_PORT//--publish/}"
if docker ps -a | grep -qs "$APPNAME"; then
  printf_yellow "The DATADIR is in $DATADIR"
  printf_cyan "$APPNAME has been installed to $INSTDIR"
  if [ -z "$PRETTY_PORT" ]; then
    printf_yellow "This container does not have services configured"
  else
    for service in $SET_PORT; do
      if [ "$service" != "--publish" ]; then
        service="${service//\/*/}"
        set_service="$(echo "$service" | tr ' ' '\n' | awk -F ':' '{$NF}' | grep '^' || echo "$service")"
        set_listen="$(echo "$service" | tr ' ' '\n' | grep ':.*.*:' | awk -F ':' '{print $1":"$2}' | grep '^' || echo "$service")"
        set_listen+="$(echo "$service" | tr ' ' '\n' | grep -v ':.*.*:' | awk -F ':' '{print $1":"$2}' | grep '^' || echo "$service")"
        listen="${set_listen//0.0.0.0/$HOST_LISTEN_ADDR}"
        printf_blue "$service is running on: $listen"
      fi
    done
    if [ "$service" != "--publish" ]; then
      service="${service//\/*/}"
      set_service="$(echo "$service" | tr ' ' '\n' | awk -F ':' '{$NF}' | grep '^' || echo "$service")"
      set_listen="$(echo "$service" | tr ' ' '\n' | grep ':.*.*:' | awk -F ':' '{print $1":"$2}' | grep '^' || echo "$service")"
      set_listen+="$(echo "$service" | tr ' ' '\n' | grep -v ':.*.*:' | awk -F ':' '{print $1":"$2}' | grep '^' || echo "$service")"
      listen="${set_listen//0.0.0.0/$HOST_LISTEN_ADDR}"
      printf_blue "$service is running on: $listen"
    fi
  fi
  [ -z "$SET_USER_NAME" ] || printf_cyan "Username is:  $SET_USER_NAME"
  [ -z "$SET_USER_PASS" ] || printf_purple "Password is:  $SET_USER_PASS"
  __show_post_message
  [ -z "$POST_SHOW_FINISHED_MESSAGE" ] || printf_green "$POST_SHOW_FINISHED_MESSAGE"
else
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
