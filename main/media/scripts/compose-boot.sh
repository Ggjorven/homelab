#!/bin/bash

# Network
cd /home/media/network
docker compose --all-resources up -d

# Monitoring
cd /home/media/monitoring
docker compose up -d

# Jellyfin
cd /home/media/jellyfin
docker compose up -d
