#!/bin/sh

DOMAINS="vpn.example.com"
API_KEY="api_key"
PROXIED=true

IP=$(curl -4 -s https://checkip.amazonaws.com)
echo "IP: $IP"

OLD_IFS="$IFS"
IFS=','
for DOMAIN in $DOMAINS; do
  ROOT_DOMAIN="${DOMAIN#*.}"
  if [ "$ROOT_DOMAIN" = "$DOMAIN" ]; then
    ROOT_DOMAIN="$DOMAIN"
  fi

  echo "ROOT_DOMAIN: $ROOT_DOMAIN"

  ZONE_ID=$(curl -s "https://api.cloudflare.com/client/v4/zones?name=$ROOT_DOMAIN&per_page=1" \
  -H "Authorization: Bearer $API_KEY" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 | tr -d '\r\n')

  if [ -z "$ZONE_ID" ]; then
    echo "$DOMAIN: Could not find Zone ID, skipping"
    continue
  fi

  RECORD_INFO=$(curl -s "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$DOMAIN" \
    -H "Authorization: Bearer $API_KEY")

  RECORD_ID=$(echo "$RECORD_INFO" | grep -o '"id":"[^"]*' | cut -d'"' -f4)
  CURRENT_IP=$(echo "$RECORD_INFO" | grep -o '"content":"[^"]*' | cut -d'"' -f4)

  if [ -z "$RECORD_ID" ]; then
    echo "$DOMAIN: Record does not exist, creating..."
    RESULT=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
      -H "Authorization: Bearer $API_KEY" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"A\",\"name\":\"$DOMAIN\",\"content\":\"$IP\",\"ttl\":1,\"proxied\":$PROXIED}")
    echo "$RESULT"
    continue
  fi

  if [ "$CURRENT_IP" = "$IP" ]; then
    echo "$DOMAIN: No update needed ($IP)"
    continue
  fi

  RESULT=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$DOMAIN\",\"content\":\"$IP\",\"ttl\":1,\"proxied\":$PROXIED}")
  echo "$RESULT"

  echo "$DOMAIN: Updated -> $IP"
done
IFS="$OLD_IFS"
