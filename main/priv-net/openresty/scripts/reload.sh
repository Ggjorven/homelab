#!/bin/sh
set -e

echo "[reload] Regenerating nginx templates in '${CONTAINER}'..."

# Same logic as in the custom docker-entrypoint.sh
docker exec "${CONTAINER}" sh -c '
  set -e
  for t in /etc/nginx/templates/*.template; do
    o="/etc/nginx/conf.d/$(basename "$t" .template)"
    envsubst "${NGINX_ENVSUBST_FILTER:-}" < "$t" > "$o"
    echo "[reload] regenerated $o"
  done
'

echo "[reload] Sending SIGHUP to '${CONTAINER}'..."
docker kill --signal=SIGHUP "${CONTAINER}"
echo "[reload] Done."
