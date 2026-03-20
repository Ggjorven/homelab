#!/bin/bash
# install.sh — Fetches stacks.sh from the target branch and installs all stacks.
# Usage: ./install.sh <username> [branch]

if [ -z "$1" ]; then
    echo "Usage: $0 <username> [branch]"
    exit 1
fi

USERNAME="$1"
BRANCH="${2:-main}"
BASE_DIR="/home/$USERNAME/docker"
BASE_URL="https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/docker"
STACKS_URL="$BASE_URL/scripts/stacks.sh"

echo "=== Install Script ==="
echo "User:   $USERNAME"
echo "Branch: $BRANCH"
echo "Base:   $BASE_DIR"
echo ""

# Fetch and source stacks.sh from the target branch
echo "Fetching stacks.sh from branch '$BRANCH'..."
STACKS_CONTENT="$(wget -qO- "$STACKS_URL")"
if [ $? -ne 0 ] || [ -z "$STACKS_CONTENT" ]; then
    echo "Error: Failed to fetch stacks.sh from:"
    echo "  $STACKS_URL"
    echo "Check the branch name and your network connection."
    exit 1
fi
echo "  ✓ stacks.sh fetched"
echo ""

eval "$STACKS_CONTENT"

if [ ${#STACKS[@]} -eq 0 ]; then
    echo "Error: No stacks defined in stacks.sh"
    exit 1
fi

echo "Stacks defined for branch '$BRANCH': ${#STACKS[@]}"
echo ""

# Create base directory if needed
mkdir -p "$BASE_DIR"

INSTALLED=0
SKIPPED=0
FAILED=0

for STACK in "${STACKS[@]}"; do
    STACK="${STACK//$'\r'/}"  # Strip carriage returns (CRLF fix)
    STACK_DIR="$BASE_DIR/$STACK"

    if [ -d "$STACK_DIR" ] && [ -f "$STACK_DIR/compose.yaml" ]; then
        while true; do
            read -rp "$STACK already installed. Overwrite? [y/n]: " ANSWER
            case "$ANSWER" in
                [Yy]) break ;;
                [Nn]) echo "  ~ Skipping $STACK"; ((SKIPPED++)); continue 2 ;;
                *) echo "  Please enter y or n." ;;
            esac
        done
    fi

    echo "Installing $STACK..."
    mkdir -p "$STACK_DIR"
    cd "$STACK_DIR" || { echo "  ✗ Failed to cd into $STACK_DIR"; ((FAILED++)); continue; }

    rm -f compose.yaml
    if wget -q "$BASE_URL/$STACK/compose.yaml"; then
        echo "  ✓ Installed successfully"
        ((INSTALLED++))
    else
        echo "  ✗ Failed to download compose.yaml"
        rmdir "$STACK_DIR" 2>/dev/null
        ((FAILED++))
    fi
done

echo ""
echo "=== Done ==="
echo "  Installed: $INSTALLED  |  Skipped: $SKIPPED  |  Failed: $FAILED"
