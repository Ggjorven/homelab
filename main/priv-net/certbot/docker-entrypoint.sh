#!/bin/sh
set -e

# Validate required env vars
: "${CF_API_TOKEN:?CF_API_TOKEN is required}"
: "${LOCAL_DOMAIN:?LOCAL_DOMAIN is required}"
: "${EMAIL:?EMAIL is required}"

# Credentials file
CF_CREDENTIALS_FILE="/tmp/cloudflare.ini"
echo "dns_cloudflare_api_token = ${CF_API_TOKEN}" > "${CF_CREDENTIALS_FILE}"
chmod 600 "${CF_CREDENTIALS_FILE}"

# Reload file
RELOAD_OPENRESTY_FILE="/tmp/reload-openresty.sh"
cat > "${RELOAD_OPENRESTY_FILE}" << 'EOF'
#!/bin/sh
python3 -c "
import socket, sys
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect('/var/run/docker.sock')
sock.send(b'POST /containers/openresty/kill?signal=SIGHUP HTTP/1.1\r\nHost: localhost\r\nContent-Length: 0\r\nConnection: close\r\n\r\n')
response = sock.recv(4096).decode()
sock.close()
if '204' in response:
    print('[certbot] openresty reloaded successfully')
else:
    print('[certbot] unexpected response: ' + response.split('\r\n')[0])
    sys.exit(1)
" 2>/dev/null || echo '[certbot] openresty reload skipped (container not running)'
EOF
chmod +x "${RELOAD_OPENRESTY_FILE}"

# Initial certificate if none exists
CERT_PATH="/etc/letsencrypt/live/${LOCAL_DOMAIN}/fullchain.pem"

if [ ! -f "${CERT_PATH}" ]; then
    echo "[certbot] No certificate found for ${LOCAL_DOMAIN}, requesting initial cert..."
    certbot certonly \
        --dns-cloudflare \
        --dns-cloudflare-credentials "${CF_CREDENTIALS_FILE}" \
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
        --dns-cloudflare-credentials "${CF_CREDENTIALS_FILE}" \
		--post-hook "${RELOAD_OPENRESTY_FILE}"
    sleep 12h & wait $!
done
