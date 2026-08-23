	#!/bin/sh
set -e

CONTAINER_NAME=openresty

echo "[reload] Regenerating nginx templates in '${CONTAINER_NAME}'..."

# Same logic as in the custom docker-entrypoint.sh
docker exec "${CONTAINER_NAME}" sh -c '
  set -e
  for t in /etc/nginx/templates/*.template; do
    o="/etc/nginx/conf.d/$(basename "$t" .template)"
    envsubst "${NGINX_ENVSUBST_FILTER:-}" < "$t" > "$o"
    echo "[reload] regenerated $o"
  done
'

echo "[reload] Sending SIGHUP to '${CONTAINER_NAME}'..."
docker kill --signal=SIGHUP "${CONTAINER_NAME}"
echo "[reload] Done."
