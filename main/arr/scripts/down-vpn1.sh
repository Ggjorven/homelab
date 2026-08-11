#!/bin/bash

# VPN1
cd /home/arr/vpn1
docker compose --env-file ../.env --env-file .env down
