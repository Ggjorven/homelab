#!/bin/bash

# VPN1
cd /home/arr/vpn1
docker compose --all-resources --env-file ../.env --env-file .env up -d
