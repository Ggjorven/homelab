#!/bin/bash

# Sonarr
cd /home/arr/sonarr
docker compose --all-resources --env-file ../.env --env-file .env up -d
