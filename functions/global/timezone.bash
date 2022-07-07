#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070951-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.com
# @License           :  WTFPL
# @ReadME            :  timezone.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 09:51 EDT
# @File              :  timezone.bash
# @Description       :  TimeZone functions
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "/etc/timezone" ]; then
  TIMEZONE="$(cat /etc/timezone)"
  TZ="$TIMEZONE"
else
  TIMEZONE="America/New_York"
  TZ="$TIMEZONE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export TIMEZONE TZ
