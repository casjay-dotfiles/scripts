cat <<EOF | tee
# Main function file
if [ -f "\$SRC_DIR/functions.bash" ]; then
  FUNCTIONS_DIR="\$SRC_DIR"
  . "\$FUNCTIONS_DIR/functions.bash"
elif [ -f "\$HOME/.local/bin/functions.bash" ]; then
  FUNCTIONS_DIR="\$HOME/.local/bin"
  . "\$FUNCTIONS_DIR/functions.bash"
else
  printf "\\t\\t\\033[0;31m%s \\033[0m\\n" "Couldn't source the functions file from \${FUNCTIONS_DIR:-\$SRC_DIR}"
  return 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - -
EOF
