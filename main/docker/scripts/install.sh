#!/bin/bash

# =========================
# Initial configuration
# =========================
read -rp "Linux user's username': " USERNAME

BRANCH="${1:-main}"
BASE_DIR="/home/$USERNAME/docker"
BASE_URL="https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/docker"
STACKS_URL="$BASE_URL/scripts/stacks.sh"

echo "===== Install Script ====="
echo "User:   $USERNAME"
echo "Branch: $BRANCH"
echo "Base:   $BASE_DIR"
echo "=========================="
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
# Docker
# =========================
mkdir -p "$BASE_DIR"

INSTALLED=0
SKIPPED=0
FAILED=0

for STACK in "${STACKS[@]}"; do
    STACK="${STACK//$'\r'/}"
    STACK_DIR="$BASE_DIR/$STACK"

    # Handle already-installed stacks
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

    read -rp "Install $STACK? [Y/n]: " INSTALL_ANSWER </dev/tty
    if [[ "${INSTALL_ANSWER,,}" == "n" ]]; then
        echo "  ~ Skipping $STACK"
        ((SKIPPED++))
        continue
    fi

    echo "Installing $STACK..."
    mkdir -p "$STACK_DIR"

    rm -f "$STACK_DIR/compose.yaml"
    if ! wget -qO "$STACK_DIR/compose.yaml" "$BASE_URL/$STACK/compose.yaml"; then
        echo "  ✗ Failed to download compose.yaml"
        ((FAILED++))
        continue
    fi
    echo "  ✓ compose.yaml downloaded"

    # Download .env into a temp file
    ENV_TMP="$(mktemp)"
    if ! wget -qO "$ENV_TMP" "$BASE_URL/$STACK/.env" || [ ! -s "$ENV_TMP" ]; then
        echo "  ✗ Failed to download .env for $STACK"
        rm -f "$ENV_TMP" "$STACK_DIR/compose.yaml"
        ((FAILED++))
        continue
    fi
    echo "  ✓ .env downloaded"

    # Read default values from the downloaded template
    declare -A EXISTING_VALS
    while IFS='=' read -r key val || [ -n "$key" ]; do
        # Skip blank lines and comments
        [[ -z "$key" || "$key" =~ ^# ]] && continue
        # Strip carriage returns
        key="${key//$'\r'/}"
        val="${val//$'\r'/}"
        EXISTING_VALS["$key"]="$val"
    done < "$ENV_TMP"

    # Prompt user for each KEY= line in the template; preserve comments/blanks as-is
    echo ""
    echo "  --- Configuring .env for $STACK ---"
	echo "  Format: MY_VAR (default=DEFAULT): <your-input>"
	echo "  ---                             ---"
    OUTPUT_LINES=()

    while IFS= read -r line || [ -n "$line" ]; do
        line="${line//$'\r'/}"  # Strip carriage returns

        # Blank lines and comments — preserve unchanged
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            OUTPUT_LINES+=("$line")
            continue
        fi

        # KEY=value lines — everything up to the first = is the key
        if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)= ]]; then
            KEY="${BASH_REMATCH[1]}"
            DEFAULT="${EXISTING_VALS[$KEY]}"

            # Check for # REQUIRED and strip it from the default value
            REQUIRED=false
            if [[ "$DEFAULT" == *"# REQUIRED"* ]]; then
                REQUIRED=true
                DEFAULT="${DEFAULT%%# REQUIRED*}"    # Strip # REQUIRED and anything after
                DEFAULT="${DEFAULT%"${DEFAULT##*[! ]}"}"  # Trim trailing whitespace
            fi

            if [ "$REQUIRED" = true ]; then
                while true; do
                    read -rp "  $KEY (default=$DEFAULT, required): " USER_VAL </dev/tty
                    VALUE="${USER_VAL:-$DEFAULT}"
                    if [ "$VALUE" != "$DEFAULT" ] && [ -n "$VALUE" ]; then
                        break
                    fi
                    echo "  ! $KEY is required — enter a value other than the placeholder"
                done
            elif [ -n "$DEFAULT" ]; then
                read -rp "  $KEY (default=$DEFAULT): " USER_VAL </dev/tty
                VALUE="${USER_VAL:-$DEFAULT}"
            else
                read -rp "  $KEY: " USER_VAL </dev/tty
                VALUE="$USER_VAL"
            fi
            OUTPUT_LINES+=("$KEY=$VALUE")
        else
            # Preserve any other lines as-is
            OUTPUT_LINES+=("$line")
        fi
    done < "$ENV_TMP"
    rm -f "$ENV_TMP"

    # Write final .env — one element per line, no trailing newline issues
    {
        for out_line in "${OUTPUT_LINES[@]}"; do
            printf '%s\n' "$out_line"
        done
    } > "$STACK_DIR/.env"

    echo ""
    echo "  ✓ .env configured"
    echo "  ✓ $STACK installed successfully"
    unset EXISTING_VALS
    ((INSTALLED++))
done
# =========================

echo ""
echo "===== Done ====="
echo "  Installed: $INSTALLED  |  Skipped: $SKIPPED  |  Failed: $FAILED"
