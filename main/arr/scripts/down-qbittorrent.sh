#!/bin/bash

# QBitTorrent
cd /home/arr/qbittorrent
docker compose --env-file ../.env --env-file .env down
