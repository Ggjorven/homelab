#!/bin/bash

# MeTube
cd /home/arr/metube
docker compose --all-resources --env-file ../.env --env-file .env up -d
