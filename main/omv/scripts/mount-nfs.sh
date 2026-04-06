#!/bin/bash

# ======================
# CONFIG
# ======================
SERVER_IP="192.168.x.x"
SHARE_NAME="nas"
MOUNT_POINT="/mnt/nas"

# ======================
# SCRIPT
# ======================
echo "Waiting for NFS share $SERVER_IP:/export/$SHARE_NAME ..."
while true; do
    # Check if the NFS export is available on the server
    showmount -e "$SERVER_IP" 2>/dev/null | grep -q "/export/$SHARE_NAME"

    if [ $? -eq 0 ]; then
        echo "Share found! Mounting..."
        mount -t nfs "$SERVER_IP:/export/$SHARE_NAME" "$MOUNT_POINT"

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
