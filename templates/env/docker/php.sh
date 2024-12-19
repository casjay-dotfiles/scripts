# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# php settings
PHP_VERSION="${PHP_VERSION//php/}"
PHP_INI_DIR="${PHP_INI_DIR:-$(__find_php_ini)}"
PHP_BIN_DIR="${PHP_BIN_DIR:-$(__find_php_bin)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
