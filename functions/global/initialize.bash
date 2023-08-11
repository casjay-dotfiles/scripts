#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071035-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  initialize.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 10:35 EDT
# @File              :  initialize.bash
# @Description       :  initialize check
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fail if git, curl, wget are not installed
if ! builtin type -P git &>/dev/null; then
  echo -e "\033[0;31mAttempting to install git\033[0m"
  if builtin type -P brew &>/dev/null; then
    brew install -f git &>/dev/null
  elif builtin type -P apt &>/dev/null; then
    apt install -yy -q git &>/dev/null
  elif builtin type -P pacman &>/dev/null; then
    pacman -S --noconfirm git &>/dev/null
  elif builtin type -P yum &>/dev/null; then
    yum install -yy -q git &>/dev/null
  elif builtin type -P choco &>/dev/null; then
    choco install git -y &>/dev/null
    if builtin type -P git &>/dev/null; then
      echo -e "\033[0;31mGit was not installed\033[0m"
      exit 1
    fi
  else
    echo -e "\033[0;31mGit is not installed\033[0m"
    exit 1
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
