#!/bin/bash

# Slskd
cd /home/arr/slskd
docker compose --all-resources --env-file ../.env --env-file .env up -d
