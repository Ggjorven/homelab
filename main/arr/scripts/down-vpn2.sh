#!/bin/bash

# VPN2
cd /home/arr/vpn2
docker compose --env-file ../.env --env-file .env down
