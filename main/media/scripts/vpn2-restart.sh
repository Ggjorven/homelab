#!/bin/sh

# =========================
# Initial configuration
# =========================
USERNAME="<username>" # ex. dockeruser
BASE_DIR="/home/$USERNAME/docker"

# =========================
# Pre-check
# =========================
for dir in networkstack downloadstack; do
    if [ ! -d "$BASE_DIR/$dir" ]; then
        echo "Missing stack: $BASE_DIR/$dir, please remove from script."
        exit 1
    fi
done

# =========================
# Down
# =========================
cd "$BASE_DIR/downloadstack"
docker compose down slskd

cd "$BASE_DIR/networkstack"
docker compose down vpn2

# =========================
# Up
# =========================
cd "$BASE_DIR/networkstack"
docker compose up -d vpn2

cd "$BASE_DIR/downloadstack"
docker compose up -d slskd
