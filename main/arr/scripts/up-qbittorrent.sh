#!/bin/bash

# QBitTorrent
cd /home/arr/qbittorrent
docker compose --all-resources --env-file ../.env --env-file .env up -d
