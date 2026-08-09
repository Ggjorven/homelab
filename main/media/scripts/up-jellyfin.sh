#!/bin/bash

# Jellyfin
cd /home/media/jellyfin
docker compose --env-file ../.env --env-file .env up -d
