#!/bin/sh
set -e

# Validate required env vars
: "${CF_API_TOKEN:?CF_API_TOKEN is required}"
: "${LOCAL_DOMAIN:?LOCAL_DOMAIN is required}"
: "${EMAIL:?EMAIL is required}"

# Credentials file
echo "dns_cloudflare_api_token = ${CF_API_TOKEN}" > /cloudflare.ini
chmod 600 /cloudflare.ini

# Initial certificate if none exists
CERT_PATH="/etc/letsencrypt/live/${LOCAL_DOMAIN}/fullchain.pem"

if [ ! -f "${CERT_PATH}" ]; then
    echo "[certbot] No certificate found for ${LOCAL_DOMAIN}, requesting initial cert..."
    certbot certonly \
        --dns-cloudflare \
        --dns-cloudflare-credentials /cloudflare.ini \
        -d "${LOCAL_DOMAIN}" \
        -d "*.${LOCAL_DOMAIN}" \
        --email "${EMAIL}" \
        --agree-tos --no-eff-email --non-interactive
    echo "[certbot] Initial certificate obtained."
else
    echo "[certbot] Certificate already exists for ${LOCAL_DOMAIN}, skipping initial request."
fi

# Renewal loop
trap exit TERM
while :; do
    certbot renew \
        --dns-cloudflare \
        --dns-cloudflare-credentials /cloudflare.ini \
		--post-hook "/reload-openresty.sh"
    sleep 12h & wait $!
done
