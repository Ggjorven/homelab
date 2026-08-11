#!/bin/bash

# Networking
cd /home/privnet/networking
docker compose --env-file ../.env --env-file .env down
