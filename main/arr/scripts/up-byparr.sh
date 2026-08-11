#!/bin/bash

# Byparr
cd /home/arr/byparr
docker compose --all-resources --env-file ../.env --env-file .env up -d
