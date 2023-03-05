# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# web server configs
HTTPD_CONFIG_FILE="${HTTPD_CONFIG_FILE:-$(__find_httpd_conf)}"
NGINX_CONFIG_FILE="${NGINX_CONFIG_FILE:-$(__find_nginx_conf)}"
LIGHTTPD_CONFIG_FILE="${LIGHTTPD_CONFIG_FILE:-$(__find_lighttpd_conf)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
