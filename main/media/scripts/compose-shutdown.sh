#!/bin/bash

# Jellyfin
cd /home/media/jellyfin
docker compose down

# Monitoring
cd /home/media/monitoring
docker compose down

# Networking
cd /home/media/networking
docker compose down
