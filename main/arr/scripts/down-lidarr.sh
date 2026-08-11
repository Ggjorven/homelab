#!/bin/bash

# Lidarr
cd /home/arr/lidarr
docker compose --env-file ../.env --env-file .env down
