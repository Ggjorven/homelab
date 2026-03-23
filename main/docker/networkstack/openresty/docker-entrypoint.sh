#!/bin/sh

set -e

# Process all template files
for template in /etc/nginx/templates/*.template; do
    output="/usr/local/openresty/nginx/conf/conf.d/$(basename "${template}" .template)"
    echo "Processing template: ${template} -> ${output}"
    envsubst "${NGINX_ENVSUBST_FILTER:-}" < "${template}" > "${output}"
done

exec /usr/local/openresty/bin/openresty -g "daemon off;"
