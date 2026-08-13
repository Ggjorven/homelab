#!/bin/bash

STACK_USER="privnet"
STACK_NAME="certbot"

STACK_DIR="/home/$STACK_USER/$STACK_NAME"
COMPOSE_FILE="$STACK_DIR/compose.yaml"

if [[ ! -d "$STACK_DIR" ]]; then
    echo "[INFO] Directory '$STACK_DIR' does not exist. Skipping $STACK_NAME startup."
    exit 0
fi

if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "[INFO] Compose file '$COMPOSE_FILE' does not exist. Skipping $STACK_NAME startup."
    exit 0
fi

cd "$STACK_DIR"
docker compose --env-file ../.env --env-file .env up -d
