#!/bin/bash

# MeTube
cd /home/arr/metube
docker compose --env-file ../.env --env-file .env down
