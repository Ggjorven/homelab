#!/bin/bash

# ======================
# CONFIG
# ======================
SERVER_IP="192.168.x.x"
SHARE_NAME="shared"
MOUNT_POINT="/mnt/nas"
CREDENTIALS="/root/.smbcred"
SMB_VERSION="3.0"

# ======================
# SCRIPT
# ======================
echo "Waiting for SMB share //$SERVER_IP/$SHARE_NAME ..."

while true; do
    # Check if server and share respond
    smbclient -L //$SERVER_IP -A "$CREDENTIALS" -g 2>/dev/null | grep -q "^Disk|$SHARE_NAME"
    
    if [ $? -eq 0 ]; then
        echo "Share found! Mounting..."
        mount -t cifs //$SERVER_IP/$SHARE_NAME "$MOUNT_POINT" \
            -o credentials="$CREDENTIALS",vers="$SMB_VERSION",sec=ntlmssp
        
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

