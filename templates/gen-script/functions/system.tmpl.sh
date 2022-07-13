cat <<EOF | tee
# Import functions
CASJAYSDEVDIR="\${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="\${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="\${SCRIPTSAPPFUNCTFILE:-testing.bash}"
SCRIPTSFUNCTURL="\${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/$GEN_SCRIPT_GIT_DEFAULT_BRANCH/functions}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "\$PWD/\$SCRIPTSFUNCTFILE" ]; then
  . "\$PWD/\$SCRIPTSFUNCTFILE"
elif [ -f "\$SCRIPTSFUNCTDIR/\$SCRIPTSFUNCTFILE" ]; then
  . "\$SCRIPTSFUNCTDIR/\$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: \$SCRIPTSFUNCTDIR/\$SCRIPTSFUNCTFILE" 1>&2
  exit 90
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# user system devenv dfmgr dockermgr fontmgr iconmgr pkmgr systemmgr thememgr wallpapermgr
\${default_type:-system}_install
__options "\$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
EOF
