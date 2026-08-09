#!/bin/bash

# Certbot
cd /home/privnet/certbot
docker compose --env-file ../.env --env-file .env up -d
