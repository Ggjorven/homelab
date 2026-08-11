#!/bin/bash

# Byparr
cd /home/arr/byparr
docker compose --env-file ../.env --env-file .env down
