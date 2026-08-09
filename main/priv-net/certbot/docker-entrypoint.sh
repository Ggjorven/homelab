#!/bin/sh
set -e

trap exit TERM;

# Make the credentials file based on env var
echo "dns_cloudflare_api_token = ${CF_API_TOKEN}" > /cloudflare.ini
chmod 600 /cloudflare.ini

# Renew loop
while :; do
	certbot renew
		--dns-cloudflare
		--dns-cloudflare-credentials /cloudflare.ini
		--post-hook "docker exec openresty openresty -s reload"; # (Hot)Reload openresty
	sleep 12h & wait $${!};
done
