#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207070951-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
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
if [ -n "$TIMEZONE" ]; then
  TZ="$TIMEZONE"
elif [ -n "$TZ" ]; then
  TIMEZONE="$TZ"
else
  TIMEZONE="America/New_York"
  TZ="$TIMEZONE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export TIMEZONE TZ
