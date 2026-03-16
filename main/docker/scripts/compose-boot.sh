#!/bin/bash

USERNAME="<username>"

BASE_DIR="/home/$USERNAME/docker"

STACKS=(
    "networkstack"
    "monitoringstack"
    "downloadstack"
    "arrstack"
    "mediastack"
    "musicstack"
    "tvstack"
    "sharestack"
    "gamingstack"
    "securitystack"
    "internetstack"
)

if [ ! -d "$BASE_DIR" ]; then
    echo "Error: Base directory $BASE_DIR not found."
    exit 1
fi

echo "Starting stacks for user: $USERNAME"
echo ""

for STACK in "${STACKS[@]}"; do
    STACK="${STACK//$'\r'/}"
    STACK_DIR="$BASE_DIR/$STACK"

    if [ -d "$STACK_DIR" ] && [ -f "$STACK_DIR/compose.yaml" ]; then
        echo "Starting $STACK..."
        cd "$STACK_DIR" || continue

        # networkstack uses --all-resources flag to initialize networks even when unused
        if [ "$STACK" = "networkstack" ]; then
            docker compose --all-resources up -d
        else
            docker compose up -d
        fi

        if [ $? -eq 0 ]; then
            echo "  ✓ $STACK started successfully"
        else
            echo "  ✗ Failed to start $STACK"
        fi
    else
        echo "  Skipping $STACK (directory or compose.yaml not found)"
    fi

    echo ""
done

echo "Done."

