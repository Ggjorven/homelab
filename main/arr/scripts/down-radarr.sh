#!/bin/bash

# Radarr
cd /home/arr/radarr
docker compose --env-file ../.env --env-file .env down
