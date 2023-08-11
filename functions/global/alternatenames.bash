#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071125-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  alternatenames.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 11:25 EDT
# @File              :  alternatenames.bash
# @Description       :  alternate package names
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
tf() {
  [ -f "$(builtin type -P tinyfigue 2>/dev/null)" ] ||
    [ -f "$(builtin type -P tf 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
httpd() {
  [ -f "$(builtin type -P httpd 2>/dev/null)" ] ||
    [ -f "$(builtin type -P apache2 2>/dev/null)" ] ||
    [ -f "$(builtin type -P apache 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cron() {
  [ -f "$(builtin type -P crond 2>/dev/null)" ] ||
    [ -f "$(builtin type -P cron 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grub() {
  [ -f "$(builtin type -P grub-install 2>/dev/null)" ] ||
    [ -f "$(builtin type -P grub2-install 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cowsay() {
  [ -f "$(builtin type -P cowsay 2>/dev/null)" ] ||
    [ -f "$(builtin type -P cowpatty 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
fortune() {
  [ -f "$(builtin type -P fortune 2>/dev/null)" ] ||
    [ -f "$(builtin type -P fortune-mod 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mlocate() {
  [ -f "$(builtin type -P locate 2>/dev/null)" ] ||
    [ -f "$(builtin type -P mlocate 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
xfce4() {
  [ -f "$(builtin type -P xfce4-about 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
xfce4-notifyd() {
  [ -f "$(builtin type -P xfce4-notifyd-config 2>/dev/null)" ] ||
    find /usr/lib* -name "xfce4-notifyd" -type f 2>/dev/null | grep -q . ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
imagemagick() {
  [ -f "$(builtin type -P convert 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
fdfind() {
  [ -f "$(builtin type -P fdfind 2>/dev/null)" ] ||
    [ -f "$(builtin type -P fd 2>/dev/null)" ] || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
speedtest() {
  [ -f "$(builtin type -P speedtest-cli 2>/dev/null)" ] ||
    [ -f "$(builtin type -P speedtest 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
neovim() {
  [ -f "$(builtin type -P nvim 2>/dev/null)" ] ||
    [ -f "$(builtin type -P neovim 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
chromium() {
  [ -f "$(builtin type -P chromium 2>/dev/null)" ] ||
    [ -f "$(builtin type -P chromium-browser 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
firefox() {
  [ -f "$(builtin type -P firefox-esr 2>/dev/null)" ] ||
    [ -f "$(builtin type -P firefox 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
powerline-status() {
  [ -f "$(builtin type -P powerline-config 2>/dev/null)" ] ||
    [ -f "$(builtin type -P powerline-daemon 2>/dev/null)" ] || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
gtk-2.0() {
  find /lib* /usr* -iname "*libgtk*2*.so*" -type f 2>/dev/null |
    grep -q . || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
gtk-3.0() {
  find /lib* /usr* -iname "*libgtk*3*.so*" -type f 2>/dev/null |
    grep -q . || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
transmission-remote-cli() {
  [ -f "$(builtin type -P transmission-remote-cli 2>/dev/null)" ] ||
    [ -f "$(builtin type -P transmission-remote 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
transmission() {
  [ -f "$(builtin type -P transmission-remote)" ] ||
    [ -f "$(builtin type -P transmission-remote-cli)" ] ||
    [ -f "$(builtin type -P transmission-remote-gtk)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
libvirt() {
  [ -f "$(builtin type -P libvirtd)" ] &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
qemu() {
  [ -f "$(builtin type -P qemu-img)" ] &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mongodb() {
  [ -f "$(builtin type -P mongod)" ] ||
    [ -f "$(builtin type -P mongodb)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
python() {
  [ -f "$(builtin type -P python)" ] ||
    [ -f "$(builtin type -P python2)" ] ||
    [ -f "$(builtin type -P python3)" ] &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
locate() {
  [ -f "$(builtin type -P locate 2>/dev/null)" ] ||
    [ -f "$(builtin type -P mlocate 2>/dev/null)" ] ||
    return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export -f cron mlocate xfce4 imagemagick fdfind speedtest neovim
export -f chromium firefox gtk-2.0 gtk-3.0 transmission transmission-remote-cli
export -f cowsay xfce4-notifyd grub powerline-status libvirt qemu mongodb python
export -f locate
