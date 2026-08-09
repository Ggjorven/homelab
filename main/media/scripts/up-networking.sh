#!/bin/bash

# Networking
cd /home/media/networking
docker compose --all-resources --env-file ../.env --env-file .env up -d
