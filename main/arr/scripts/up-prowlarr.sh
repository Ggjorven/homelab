#!/bin/bash

# Prowlarr
cd /home/arr/prowlarr
docker compose --all-resources --env-file ../.env --env-file .env up -d
