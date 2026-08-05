#!/bin/bash

# =========================
# Initial configuration
# =========================
USERNAME="<username>" # ex. dockeruser
BRANCH="main"

BASE_DIR="/home/$USERNAME/docker"
BASE_URL="https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/docker"
STACKS_URL="$BASE_URL/scripts/stacks.sh"
# =========================

# =========================
# Stacks
# =========================
echo "Fetching stacks.sh from branch '$BRANCH'..."

STACKS_TMP="$(mktemp)"

if ! wget -qO "$STACKS_TMP" "$STACKS_URL" || [ ! -s "$STACKS_TMP" ]; then
    echo "Error: Failed to fetch stacks.sh from:"
    echo "  $STACKS_URL"
    echo "Check the branch name and your network connection."
    rm -f "$STACKS_TMP"
    exit 1
fi

source "$STACKS_TMP"

rm -f "$STACKS_TMP"

echo "  ✓ stacks.sh fetched"
echo ""

if [ ${#STACKS[@]} -eq 0 ]; then
    echo "Error: No stacks defined in stacks.sh"
    exit 1
fi
# =========================

# =========================
# Boot up
# =========================
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
# =========================
