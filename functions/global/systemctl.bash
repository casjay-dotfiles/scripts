#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071031-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  systemctl.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 10:31 EDT
# @File              :  systemctl.bash
# @Description       :  systemctl functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
############################################################
# 🔍 __system_service_active: check if services are active
############################################################
__system_service_active() {
  local exitCode=0
  for service in "$@"; do
    if ! systemctl is-active --quiet "$service"; then
      ((exitCode++))
    fi
  done
  return $exitCode
}

############################################################
# 🏃 __system_service_running: check if services are running
############################################################
__system_service_running() {
  local exitCode=0
  for service in "$@"; do
    if ! systemctl status "$service" 2>/dev/null | grep -Fq 'running'; then
      ((exitCode++))
    fi
  done
  return $exitCode
}

############################################################
# 🔎 __system_service_exists: verify services exist
############################################################
__system_service_exists() {
  local exitCode=0
  for service in "$@"; do
    if ! systemctl list-unit-files --type=service | awk '{print $1}' | grep -q "^${service}\.service$"; then
      ((exitCode++))
    fi
  done
  return $exitCode
}

############################################################
# ✅ __system_service_enable: enable and start services
############################################################
__system_service_enable() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then
      sudo systemctl enable --now -f "$service" &>/dev/null || ((exitCode++))
    else
      ((exitCode++))
    fi
  done
  return $exitCode
}

############################################################
# 🚫 __system_service_disable: disable and stop services
############################################################
__system_service_disable() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then
      sudo systemctl disable --now -f "$service" &>/dev/null || ((exitCode++))
    else
      ((exitCode++))
    fi
  done
  return $exitCode
}

############################################################
# ▶️ __system_service_start: start services
############################################################
__system_service_start() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then
      sudo systemctl start "$service" &>/dev/null || ((exitCode++))
    else
      ((exitCode++))
    fi
  done
  return $exitCode
}

############################################################
# ⏹️ __system_service_stop: stop services
############################################################
__system_service_stop() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then
      sudo systemctl stop "$service" &>/dev/null || ((exitCode++))
    else
      ((exitCode++))
    fi
  done
  return $exitCode
}

############################################################
# 🔄 __system_service_restart: restart services
############################################################
__system_service_restart() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then
      sudo systemctl restart "$service" &>/dev/null || ((exitCode++))
    else
      ((exitCode++))
    fi
  done
  return $exitCode
}

############################################################
# 🧰 __manage_service: enable and (re)start a service safely
############################################################
__manage_service() {
  local svc="$1"
  if ! systemctl list-unit-files --type=service | grep -q "^${svc}\.service"; then
    printf "${RED}❌ Service '%s' does not exist.${NC}\n" "$svc"
    return 1
  fi

  if ! systemctl is-enabled --quiet "$svc"; then
    if ! sudo systemctl enable "$svc"; then
      printf "${RED}❌ Failed to enable service '%s'.${NC}\n" "$svc"
      return 1
    else
      printf "${GREEN}✅ Enabled service '%s'.${NC}\n" "$svc"
    fi
  else
    printf "${BLUE}ℹ️  Service '%s' already enabled.${NC}\n" "$svc"
  fi

  if systemctl is-active --quiet "$svc"; then
    if ! sudo systemctl restart "$svc"; then
      printf "${RED}❌ Failed to restart service '%s'.${NC}\n" "$svc"
      __show_service_errors "$svc"
      return 1
    else
      printf "${GREEN}🔄 Restarted service '%s'.${NC}\n" "$svc"
    fi
  else
    if ! sudo systemctl start "$svc"; then
      printf "${RED}❌ Failed to start service '%s'.${NC}\n" "$svc"
      __show_service_errors "$svc"
      return 1
    else
      printf "${GREEN}▶️  Started service '%s'.${NC}\n" "$svc"
    fi
  fi
}

############################################################
# 🪵 __show_service_errors: display recent error messages
############################################################
__show_service_errors() {
  local svc="$1"
  printf "${YELLOW}🪵 Recent error messages for %s:${NC}\n" "$svc"
  echo "------------------------------------------------------------"
  journalctl -u "$svc" -p err -n 10 --no-pager --output=cat |
    grep -vE 'Starting|Started|Stopped|status=0/SUCCESS' |
    sed -E "s/^/  ❗ /"
  echo "------------------------------------------------------------"
}
