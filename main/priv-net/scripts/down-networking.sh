#!/bin/bash

# Networking
cd /home/media/networking
docker compose --env-file ../.env --env-file .env down
