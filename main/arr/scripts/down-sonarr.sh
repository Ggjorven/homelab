#!/bin/bash

# Sonarr
cd /home/arr/sonarr
docker compose --env-file ../.env --env-file .env down
