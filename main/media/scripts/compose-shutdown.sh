#!/bin/bash

# Jellyfin
cd /home/media/jellyfin
docker compose down

# Monitoring
cd /home/media/monitoring
docker compose down

# Network
cd /home/media/network
docker compose down
