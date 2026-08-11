#!/bin/bash

# Bazarr
cd /home/arr/bazarr
docker compose --all-resources --env-file ../.env --env-file .env up -d
