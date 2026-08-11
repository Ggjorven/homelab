#!/bin/bash

# Jackett
cd /home/arr/jackett
docker compose --all-resources --env-file ../.env --env-file .env up -d
