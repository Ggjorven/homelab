#!/bin/sh

# =========================
# Initial configuration
# =========================
USERNAME="<username>" # ex. dockeruser
BASE_DIR="/home/$USERNAME/docker"

# =========================
# Pre-check
# =========================
for dir in networkstack downloadstack arrstack tvstack; do
    if [ ! -d "$BASE_DIR/$dir" ]; then
        echo "Missing stack: $BASE_DIR/$dir, please remove from script."
        exit 1
    fi
done

# =========================
# Down
# =========================
cd "$BASE_DIR/tvstack"
docker compose down dispatcharr

cd "$BASE_DIR/arrstack"
docker compose down jackett prowlarr

cd "$BASE_DIR/downloadstack"
docker compose down qbittorrent nzbget

cd "$BASE_DIR/networkstack"
docker compose down vpn1 flaresolverr

# =========================
# Up
# =========================
cd "$BASE_DIR/networkstack"
docker compose up -d vpn1 flaresolverr

cd "$BASE_DIR/downloadstack"
docker compose up -d qbittorrent nzbget

cd "$BASE_DIR/arrstack"
docker compose up -d jackett prowlarr

cd "$BASE_DIR/tvstack"
docker compose up -d dispatcharr
