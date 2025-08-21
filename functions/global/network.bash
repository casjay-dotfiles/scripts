#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071024-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  network.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 10:24 EDT
# @File              :  network.bash
# @Description       :  Network based functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__am_i_online() {
  curl -q --connect-timeout 1 --max-time 2 --fail --retry 0 -LSsfI https://1.1.1.1 2>/dev/null | grep -q 'server:.*cloudflare' && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__local_network() {
  if [ "$1" = "localhost" ] || [ "$1" = "$(hostname -s)" ] || [ "$1" = "$(hostname -f)" ] ||
    [[ "$1" =~ 10.*.*.* ]] || [[ "$1" =~ 192.168.*.* ]] || [[ "$1" =~ 172.16.*.* ]] || [[ "$1" =~ 127.*.*.* ]]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__local_sysname() {
  if [ "$1" = "localhost" ] || [ "$1" = "$(hostname -s)" ] || [ "$1" = "$(hostname -f)" ]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#gethostname ""
__gethostname() {
  hostname -f 2>/dev/null || hostnamectl 2>/dev/null | grep 'Static hostname' | awk -F ': ' '{print $2}' | grep '^' || hostnamecli 2>/dev/null || echo 'localhost'
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#hostname ""
__hostname() {
  hostname -s "${1:-$HOSTNAME}" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#domainname ""
__domainname() {
  hostname -d "${1:-$HOSTNAME}" 2>/dev/null || hostname -f "${1:-$HOSTNAME}" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#hostname2ip "hostname"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__hostname2ip() {
  getent ahosts "$1" | grep -v ':*:*:' | cut -d' ' -f1 | head -n1 || nslookup "$1" 2>/dev/null | grep -v '#|:*:*:' | grep Address: | awk '{print $2}' | grep ^ || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#ip2hostname "ipaddr"
__ip2hostname() {
  nslookup "$1" 2>/dev/null | grep -v ':*:*:' | grep Name: | awk '{print $2}' | head -n1 | grep ^ || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#netcat
netcat="$(builtin type -P nc 2>/dev/null || builtin type -P netcat 2>/dev/null || return 1)"
__netcat_test() { builtin type -P netcat &>/dev/null || printf_error "The program netcat is not installed"; }
__netcat_pids() { netstat -tupln 2>/dev/null | grep ":$1" | grep "$(__basename ${netcat:-nc})" | awk '{print $7}' | sed 's#'/"$(__basename ${netcat:-nc})"'##g' | grep '^'; }
# kill_netpid "port" "procname"
__kill_netpid() { netstatg "$1" | grep "$(__basename "$2")" | awk '{print $7}' | sed 's#/'$2'##g' && netstat -taupln | grep -qv "$1" || return 1; }
__netcat_kill() {
  pidof "$netcat" &>/dev/null && kill -s KILL "$(__netcat_pids "$1")" &>/dev/null
  netstat -taupln | grep -Fqv ":$1 " || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#__kill_server "port required" "print success" "print fail" "success message" "failed message"
__netcat_kill_server() {
  port="${1:?}"
  prints="${2:-printf_green}"
  printf="${3:-printf_red}"
  succ="${4:-Server has been stopped}"
  fail="${5:-Failed to stop}"
  __netcat_kill "${port}" >/dev/null 2>&1 &&
    ${prints} "${succ}" || ${printf} "${fail}"
  sleep 2
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__curl() { __am_i_online && curl --disable -LSsfk --connect-timeout 3 --retry 0 --fail "$@" 2>/dev/null || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__curl_exit() { EXIT=0 && return 0 || { EXIT=1 && return 1; }; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#curl_header "site" "code"
__curl_header() {
  curl --disable -LSIsk --connect-timeout 3 --retry 0 --max-time 2 "$1" 2>/dev/null | grep -E "HTTP/[0123456789]" | grep "${2:-200}" -n1 -q
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#curl_download "url" "file"
__curl_download() {
  curl --disable --create-dirs -LSsfk --connect-timeout 3 --retry 0 "$1" -o "$2" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#curl_version "url"
__curl_version() {
  curl --disable -LSsk --connect-timeout 3 --retry 1 "${1:-$REPORAW/version.txt}" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#curl_upload "file" "url"
__curl_upload() {
  curl -disable -LSsk --connect-timeout 3 --retry 1 --upload-file "$1" "$2" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#curl_api "API URL"
__curl_api() {
  curl --disable -LSsk --connect-timeout 3 --retry 1 "https://api.github.com/orgs/${1:-SCRIPTS_PREFIX}/repos?per_page=1000" 2>/dev/null
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#urlcheck "url"
__urlcheck() { curl --disable -LSsk --connect-timeout 2 --retry 1 --retry-delay 0 --output /dev/null --silent --head --fail "$1" 2>/dev/null && __curl_exit; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#urlverify "url"
__urlverify() { __urlcheck "$1" || __urlinvalid "$1"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#urlinvalid "url"
__urlinvalid() {
  if [ -z "$1" ]; then
    printf_red "Invalid URL"
  else
    printf_red "Can't find $1"
  fi
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
check_uri() {
  local url="$1"
  if echo "$url" | grep -q "http.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="http"
    return 0
  elif echo "$url" | grep -q "ftp.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="ftp"
    return 0
  elif echo "$url" | grep -q "git.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="git"
    return 0
  elif echo "$url" | grep -q "ssh.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="ssh"
    return 0
  else
    uri=""
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
is_url() { echo "$1" | grep -qE 'http://|ftp://|git://|https://'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# validate ip v4 address
__validateIP() {
  local ip=$1
  local stat=1
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=("$ip")
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 &&
      ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  return $stat
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#very simple function to ensure connection and jq exists
__api_test() {
  local message="${*:-}"
  if __am_i_online && builtin type -P jq &>/dev/null; then
    return 0
  else
    if [ -n "$message" ]; then printf_error "$message"; fi
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__generate_random_port() {
  __run() { cat /dev/urandom | od -N2 -An -i | awk -v f=2000 -v r=65000 '{printf "%i\n", f + r * $1 / 65536}'; }
  __number() { [[ $number -lt 65000 ]] && echo "$number" || number="$(__run)"; }
  number="$(__run)"
  while :; do
    if sudo netstat -taupln | awk '{print $4}' | grep -q "[0-9]:$number "; then
      number="$(__run)"
      exitCode=1
    else
      break
    fi
    sleep 0.1
  done
  __number
  return ${exitCode:-0}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#function to get network device
__getlipaddr() {
  local CHANGE_IP_VAR_DIR="" IFCONFIG""
  if [[ "$OSTYPE" =~ ^darwin ]]; then
    NETDEV="$(route get default 2>/dev/null | grep interface | awk '{print $2}')"
  else
    NETDEV="$(ip route 2>/dev/null | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}' | head -n1 | grep '^' || echo 'eth0')"
  fi
  IFCONFIG="$(builtin type -P /sbin/ifconfig || builtin type -P ifconfig)"
  if [ -f "$IFCONFIG" ]; then
    # net-tools package
    CURRENT_IP_4="$(/sbin/ifconfig $NETDEV 2>/dev/null | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed s/addr://g | head -n1 | grep '^')"
    CURRENT_IP_6="$(/sbin/ifconfig $NETDEV 2>/dev/null | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1 | grep '^')"
  else
    CURRENT_IP_4="$(ip -o -f inet address show $NETDEV | awk -F'/' '{print $1}' | awk '{print $NF}' | head -n 1 | grep '^')"
    CURRENT_IP_6="$(ip -o -f inet6 address show $NETDEV | awk -F'/' '{print $1}' | awk '{print $NF}' | head -n 1 | grep '^')"
  fi
  [ -n "$NETDEV" ] || NETDEV="lo"
  [ -n "$CURRENT_IP_4" ] || CURRENT_IP_4="127.0.0.1"
  [ -n "$CURRENT_IP_6" ] || CURRENT_IP_6="::1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
