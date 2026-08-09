#!/bin/bash

# Monitoring
cd /home/media/monitoring
docker compose --env-file ../.env --env-file .env down
