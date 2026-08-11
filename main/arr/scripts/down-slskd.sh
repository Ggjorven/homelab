#!/bin/bash

# Slskd
cd /home/arr/slskd
docker compose --env-file ../.env --env-file .env down
