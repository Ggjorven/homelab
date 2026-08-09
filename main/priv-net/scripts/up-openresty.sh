#!/bin/bash

# Openresty
cd /home/privnet/openresty
docker compose --env-file ../.env --env-file .env up -d
