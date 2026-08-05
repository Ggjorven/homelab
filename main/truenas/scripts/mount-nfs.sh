#!/bin/bash

# ======================
# CONFIG
# ======================
SERVER_IP="172.20.xxx.xxx"
SHARE_PATH="/mnt/tank/PATH"
MOUNT_POINT="/mnt/nas"

# ======================
# SCRIPT
# ======================
echo "Waiting for NFS share $SERVER_IP:/$SHARE_PATH ..."
while true; do
    # Check if the NFS export is available on the server
    showmount -e "$SERVER_IP" 2>/dev/null | grep -q "$SHARE_PATH"

    if [ $? -eq 0 ]; then
        echo "Share found! Mounting..."
        mount -t nfs "$SERVER_IP:$SHARE_PATH" "$MOUNT_POINT"

        if [ $? -eq 0 ]; then
            echo "Mounted successfully."
            exit 0
        else
            echo "Mount failed. Retrying..."
        fi
    else
        echo "Share not available yet... retrying in 2s"
    fi

    sleep 2
done
