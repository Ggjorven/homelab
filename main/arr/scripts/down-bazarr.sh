#!/bin/bash

# Bazarr
cd /home/arr/bazarr
docker compose --env-file ../.env --env-file .env down
