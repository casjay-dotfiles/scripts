#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071031-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.com
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
    systemctl show -p ActiveState "$service" | cut -d'=' -f2 | grep -q ^active || { exitCode+=1 && false; }
  done
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_running "list of services to check"
__system_service_running() {
  local exitCode=0
  for service in "$@"; do
    if ! systemctl status $service 2>/dev/null | grep -Fq running; then
      exitCode+=1
    fi
  done
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_exists "servicename"
__system_service_exists() {
  local exitCode=0
  for service in "$@"; do
    if sudo systemctl list-unit-files | grep -qwF "$service"; then true; else false; fi
    exitCode+=$?
  done
  set --
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_enable "servicename"
__system_service_enable() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then "sudo systemctl enable --now -f $service" &>/dev/null; fi
    exitCode+=$?
  done
  set --
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_disable "servicename"
__system_service_disable() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then "sudo systemctl disable --now -f $service" &>/dev/null; fi
    exitCode+=$?
  done
  set --
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_start "servicename"
__system_service_start() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then "sudo systemctl start $service" &>/dev/null; fi
    exitCode+=$?
  done
  set --
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_stop "servicename"
__system_service_stop() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then "sudo systemctl stop $service" &>/dev/null; fi
    exitCode+=$?
  done
  set --
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#system_service_restart "servicename"
__system_service_restart() {
  local exitCode=0
  for service in "$@"; do
    if __system_service_exists "$service"; then "sudo systemctl restart $service" &>/dev/null; fi
    exitCode+=$?
  done
  set --
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
