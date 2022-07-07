generate_icon_index() {
  printf_green "Updating the icon cache in $ICONDIR"
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  fc-cache -f "$ICONDIR" &>/dev/null
  gtk-update-icon-cache -q -t -f "$ICONDIR" &>/dev/null
}
