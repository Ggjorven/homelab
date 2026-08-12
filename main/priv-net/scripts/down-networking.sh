#!/bin/bash

# Networking
cd /home/privnet/networking
docker compose --all-resources --env-file ../.env --env-file .env down
