#!/bin/bash

SERVER_IP="172.20.105.10"
PROWLARR_API=""
RADARR_API=""
SONARR_API=""
LIDARR_API=""

is_running() {
    [ "$(docker inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" = "true" ]
}

if is_running prowlarr; then
    echo "Testing all indexers in Prowlarr."
    curl -X POST "http://$SERVER_IP:9696/api/v1/indexer/testall" -H "accept: */*" -H "X-Api-Key: $PROWLARR_API" -d ""
else
    echo "Prowlarr is not running, skipping."
fi

if is_running radarr; then
    echo "Testing all indexers in Radarr."
    curl -X POST "http://$SERVER_IP:7878/api/v3/indexer/testall" -H "accept: */*" -H "X-Api-Key: $RADARR_API" -d ""
else
    echo "Radarr is not running, skipping."
fi

if is_running sonarr; then
    echo "Testing all indexers in Sonarr."
    curl -X POST "http://$SERVER_IP:8989/api/v3/indexer/testall" -H "accept: */*" -H "X-Api-Key: $SONARR_API" -d ""
else
    echo "Sonarr is not running, skipping."
fi

if is_running lidarr; then
    echo "Testing all indexers in Lidarr."
    curl -X POST "http://$SERVER_IP:8686/api/v1/indexer/testall" -H "accept: */*" -H "X-Api-Key: $LIDARR_API" -d ""
else
    echo "Lidarr is not running, skipping."
fi
