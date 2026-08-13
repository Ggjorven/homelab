#!/bin/bash

STACK_USER="arr"
STACK_NAME="networking"

STACK_DIR="/home/$STACK_USER/$STACK_NAME"
COMPOSE_FILE="$SLSKD_DIR/compose.yaml"

if [[ ! -d "$STACK_DIR" ]]; then
    echo "[INFO] Directory '$STACK_DIR' does not exist. Skipping $STACK_NAME shutdown."
    exit 0
fi

if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "[INFO] Compose file '$COMPOSE_FILE' does not exist. Skipping $STACK_NAME shutdown."
    exit 0
fi

cd "$STACK_DIR"
docker compose --all-resources --env-file ../.env --env-file .env down
