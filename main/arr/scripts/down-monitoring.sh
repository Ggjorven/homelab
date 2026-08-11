#!/bin/bash

# Certbot
cd /home/privnet/monitoring
docker compose --env-file ../.env --env-file .env down
