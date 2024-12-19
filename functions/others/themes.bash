generate_theme_index() {
  printf_green "Updating the theme index in $THEMEDIR"
  LISTARRAY="${*:-$APPNAME}"
  for index in $LISTARRAY; do
    THEMEDIR="${THEMEDIR:-$SHARE/themes}/${index:-}"
    if [ -d "$THEMEDIR" ]; then
      find "$THEMEDIR" -mindepth 0 -maxdepth 2 -type f,l,d -not -path "*/.git/*" 2>/dev/null | while read -r THEME; do
        if [ -f "$THEME/index.theme" ]; then
          builtin type -P gtk-update-icon-cache &>/dev/null && gtk-update-icon-cache -qf "$THEME"
        fi
      done
    fi
  done
}
