#!/bin/bash

# VPN2
cd /home/arr/vpn2
docker compose --all-resources --env-file ../.env --env-file .env up -d
