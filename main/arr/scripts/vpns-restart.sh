#!/bin/bash

restart_if_running() {
    if [ "$(docker inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" = "true" ]; then
        docker restart "$1"
    fi
}

# VPN1
restart_if_running vpn1
restart_if_running byparr
restart_if_running qbittorrent
restart_if_running jackett
restart_if_running prowlarr
restart_if_running radarr
restart_if_running sonarr
restart_if_running lidarr
restart_if_running bazarr

# VPN2
restart_if_running vpn2
restart_if_running slskd
