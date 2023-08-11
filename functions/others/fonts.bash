#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202207071405-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  fonts.bash --help
# @Copyright         :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created           :  Thursday, Jul 07, 2022 14:05 EDT
# @File              :  fonts.bash
# @Description       :  Functions for fonts
# @TODO              :
# @Other             :
# @Resource          :
# @sudo/root         :  no
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
generate_font_index() {
  printf_green "Updating the fonts in $FONTDIR"
  FONTDIR="${FONTDIR:-$SHARE/fonts}"
  fc-cache -f "$FONTDIR" &>/dev/null
}
