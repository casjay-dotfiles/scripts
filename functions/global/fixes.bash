#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071007-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  fixes.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 10:07 EDT
# @File              :  fixes.bash
# @Description       :  OS based functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# macos fixes
case "$(uname -s)" in
Darwin)
  NETDEV="$(route get default 2>/dev/null | grep interface | awk '{print $2}')"
  vim="$(builtin type -P /usr/local/bin/vim 2>/dev/null || builtin type -P vim 2>/dev/null)"
  builtin type -P gsed &>/dev/null && sed="$(builtin type -P gsed 2>/dev/null)" || sed="$(builtin type -P sed 2>/dev/null)"
  builtin type -P gls &>/dev/null && lscmd="$(builtin type -P gls 2>/dev/null)" || lscmd="$(builtin type -P ls 2>/dev/null)"
  builtin type -P gdate &>/dev/null && datecmd="$(builtin type -P gdate 2>/dev/null)" || datecmd="$(builtin type -P date 2>/dev/null)"
  builtin type -P greadlink &>/dev/null && readlinkcmd="$(builtin type -P greadlink 2>/dev/null)" || readlinkcmd="$(builtin type -P readlink 2>/dev/null)"
  builtin type -P gbasename &>/dev/null && basenamecmd="$(builtin type -P basename 2>/dev/null)" || basenamecmd="$(builtin type -P basename 2>/dev/null)"
  builtin type -P gdircolors &>/dev/null && dircolorscmd="$(builtin type -P gdircolors 2>/dev/null)" || dircolorscmd="$(builtin type -P dircolors 2>/dev/null)"
  builtin type -P grealpath &>/dev/null && realpathcmd="$(builtin type -P grealpath 2>/dev/null)" || realpathcmd="$(builtin type -P realpath 2>/dev/null)"
  [ -n "$sed" ] || sed() { $sed "$@"; }
  [ -n "$datecmd" ] || date() { $datecmd "$@"; }
  [ -n "$readlinkcmd" ] || readlink() { $readlinkcmd "$@"; }
  [ -n "$basenamecmd" ] || basename() { $basenamecmd "$@"; }
  [ -n "$dircolorscmd" ] || dircolors() { $dircolorscmd "$@"; }
  [ -n "$realpathcmd" ] || realpath() { $realpathcmd "$@"; }
  alias ls='$lscmd '
  alias dircolors='gdircolors '
  ;;
Linux)
  NETDEV="$(ip route 2>/dev/null | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}')"
  sed="$(builtin type -P sed 2>/dev/null)"
  vim="$(builtin type -P vim 2>/dev/null || builtin type -P nvim || builtin type -P nano 2>/dev/null)"
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
