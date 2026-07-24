#!/bin/sh

set -e

mkdir -p /etc/nginx/conf.d/

# Check if any templates exist
if ! ls /etc/nginx/templates/*.template > /dev/null 2>&1; then
    echo "No templates found in /etc/nginx/templates/"
    ls -la /etc/nginx/templates/ || echo "Directory does not exist!"
    exit 1
fi

for template in /etc/nginx/templates/*.template; do
    output="/etc/nginx/conf.d/$(basename "${template}" .template)"
    echo "Processing template: ${template} -> ${output}"
    envsubst "${NGINX_ENVSUBST_FILTER:-}" < "${template}" > "${output}"
done

exec /usr/local/openresty/bin/openresty -g "daemon off;"
