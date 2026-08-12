#!/bin/bash

# Networking
cd /home/arr/networking
docker compose --all-resources --env-file ../.env --env-file .env down
