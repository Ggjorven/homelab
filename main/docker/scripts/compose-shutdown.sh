#!/bin/bash

USERNAME="<username>"

BASE_DIR="/home/$USERNAME/docker"

STACKS=(
	"internetstack"
	"securitystack"
	"gamingstack"
	"sharestack"
	"tvstack"
	"musicstack"
	"mediastack"
	"arrstack"
	"downloadstack"
	"monitoringstack"
	"networkstack"
)

if [ ! -d "$BASE_DIR" ]; then
    echo "Error: Base directory $BASE_DIR not found."
    exit 1
fi

echo "Shutting down stacks for user: $USERNAME"
echo ""

for STACK in "${STACKS[@]}"; do
    STACK="${STACK//$'\r'/}"
    STACK_DIR="$BASE_DIR/$STACK"

    if [ -d "$STACK_DIR" ] && [ -f "$STACK_DIR/compose.yaml" ]; then
        echo "Stopping $STACK..."
        cd "$STACK_DIR" || continue

        docker compose down

        if [ $? -eq 0 ]; then
            echo "  ✓ $STACK shutdown successfully"
        else
            echo "  ✗ Failed to start $STACK"
        fi
    else
        echo "  Skipping $STACK (directory or compose.yaml not found)"
    fi

    echo ""
done

echo "Done."


