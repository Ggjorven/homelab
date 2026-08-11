#!/bin/bash

# Monitoring
cd /home/arr/monitoring
docker compose --all-resources --env-file ../.env --env-file .env up -d
