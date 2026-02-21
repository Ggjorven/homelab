#!/bin/bash

cd /docker
docker compose -f gluetun.yaml pull
docker compose -f gluetun.yaml up --force-recreate --build -d
docker image prune -f
