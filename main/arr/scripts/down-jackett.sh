#!/bin/bash

# Jackett
cd /home/arr/jackett
docker compose --env-file ../.env --env-file .env down
