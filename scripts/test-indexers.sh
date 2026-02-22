#!/bin/bash

# ======================
# CONFIG
# ======================
SERVER_IP="192.168.x.x"
PROWLARR_API=""
RADARR_API=""
SONARR_API=""
LIDARR_API=""
DELAY=900 # seconds

# ======================
# SCRIPT
# ======================
while true; do
	echo "Testing all indexers in Prowlarr."
	curl -X "POST" "http://$SERVER_IP:9696/api/v1/indexer/testall" -H "accept: */*" -H "X-Api-Key: $PROWLARR_API" -d ""

	echo "Testing all indexers in Radarr."
	curl -X "POST" "http://$SERVER_IP:7878/api/v3/indexer/testall" -H "accept: */*" -H "X-Api-Key: $RADARR_API" -d ""

	echo "Testing all indexers in Sonarr."
	curl -X "POST" "http://$SERVER_IP:8989/api/v3/indexer/testall" -H "accept: */*" -H "X-Api-Key: $SONARR_API" -d ""

	echo "Testing all indexers in Lidarr."
	curl -X "POST" "http://$SERVER_IP:8686/api/v1/indexer/testall" -H "accept: */*" -H "X-Api-Key: $LIDARR_API" -d ""

    echo "Sleeping for $DELAY seconds."
    sleep $DELAY 
done
