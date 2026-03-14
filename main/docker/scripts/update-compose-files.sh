#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

BASE_DIR="/home/$1/docker"
BASE_URL="https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker"

STACKS=(
	"networkstack",
	"monitoringstack",
	"downloadstack",
	"arrstack",
	"mediastack",
	"musicstack",
	"tvstack",
	"sharestack",
	"gamingstack",
	"securitystack",
	"internetstack"
)

if [ -f "/lxc/scripts/compose-shutdown.sh" ]; then
    echo "Running compose-shutdown.sh..."
    bash /lxc/scripts/compose-shutdown.sh
else
    echo "Skipping shutdown (compose-shutdown.sh not found)"
fi

echo ""

for STACK in "${STACKS[@]}"; do
    STACK="${STACK//$'\r'/}"  # Strip carriage returns (CRLF fix)
    STACK_DIR="$BASE_DIR/$STACK"

    if [ -d "$STACK_DIR" ]; then
        echo "Updating $STACK..."
        cd "$STACK_DIR" || continue

        rm -f compose.yaml
        wget -q "$BASE_URL/$STACK/compose.yaml"

        if [ $? -eq 0 ]; then
            echo "  ✓ $STACK updated successfully"
        else
            echo "  ✗ Failed to download compose.yaml for $STACK"
        fi
    else
        echo "  Skipping $STACK (directory not found)"
    fi
done

echo "Done."
