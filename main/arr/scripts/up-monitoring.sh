#!/bin/bash

# Monitoring
cd /home/privnet/monitoring
docker compose --env-file ../.env --env-file .env up -d
