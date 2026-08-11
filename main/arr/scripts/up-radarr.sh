#!/bin/bash

# Radarr
cd /home/arr/radarr
docker compose --all-resources --env-file ../.env --env-file .env up -d
