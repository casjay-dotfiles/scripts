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
#system_service_active "list of services to check"
__system_service_active() {
  local exitCode=0
  for service in "$@"; do
    systemctl show -p ActiveState "$service" | cut -d'=' -f2 | grep -q ^active || { exitCode=$(exitCode++) && false; }
  done
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_running "list of services to check"
__system_service_running() {
  local exitCode=0
  for service in "$@"; do
    ! systemctl status $service 2>/dev/null | grep -Fq running || exitCode=$((exitCode++))
  done
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_exists "servicename"
__system_service_exists() {
  local exitCode=0
  for service in "$@"; do
    sudo systemctl list-unit-files 2>&1 | awk '{print $1}' | grep -q "^$service\." || exitCode=$((exitCode++))
  done
  set --
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_enable "servicename"
__system_service_enable() {
  local exitCode=0
  for service in "$@"; do
    __system_service_exists "$service" && sudo systemctl enable --now -f $service &>/dev/null || exitCode=$((exitCode++))
  done
  set --
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_disable "servicename"
__system_service_disable() {
  local exitCode=0
  for service in "$@"; do
    __system_service_exists "$service" && sudo systemctl disable --now -f $service &>/dev/null || exitCode=$((exitCode++))
  done
  set --
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_start "servicename"
__system_service_start() {
  local exitCode=0
  for service in "$@"; do
    __system_service_exists "$service" && sudo systemctl start $service &>/dev/null || exitCode=$((exitCode++))
  done
  set --
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_stop "servicename"
__system_service_stop() {
  local exitCode=0
  for service in "$@"; do
    __system_service_exists "$service" && sudo systemctl stop $service &>/dev/null || exitCode=$((exitCode++))
  done
  set --
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_restart "servicename"
__system_service_restart() {
  local exitCode=0
  for service in "$@"; do
    __system_service_exists "$service" && sudo systemctl restart $service &>/dev/null || exitCode=$((exitCode++))
  done
  set --
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
