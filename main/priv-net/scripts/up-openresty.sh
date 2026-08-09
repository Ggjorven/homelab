#!/bin/bash

# Openresty
cd /home/media/openresty
docker compose --env-file ../.env --env-file .env up -d
