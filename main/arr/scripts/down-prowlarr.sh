#!/bin/bash

# Prowlarr
cd /home/arr/prowlarr
docker compose --env-file ../.env --env-file .env down
