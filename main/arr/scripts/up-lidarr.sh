#!/bin/bash

# Lidarr
cd /home/arr/lidarr
docker compose --all-resources --env-file ../.env --env-file .env up -d
