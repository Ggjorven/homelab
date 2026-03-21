#!/bin/bash

# =========================
# Initial configuration
# =========================
echo "=========================="
echo "===== Update Script ====="
echo "=========================="
read -rp "Username: " -e -i "dockeruser" USERNAME </dev/tty
read -rp "Branch: " -e -i "main" BRANCH </dev/tty
echo ""

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

UPDATE_ALL_STACKS=false
while true; do
	read -rp "Update all stacks? [y/n]: " UPDATE_ALL_STACKS </dev/tty
	echo ""

	case "$UPDATE_ALL_STACKS" in
		[Yy]) UPDATE_ALL_STACKS=true; break ;;
		[Nn]) UPDATE_ALL_STACKS=false; break ;;
		*) echo "  Please enter y or n." ;;
	esac
done
# =========================

# =========================
# Docker
# =========================
UPDATED=0
SKIPPED=0
FAILED=0

for STACK in "${STACKS[@]}"; do
    STACK="${STACK//$'\r'/}"
    STACK_DIR="$BASE_DIR/$STACK"

	# Ask to install stacks that are currently not installed
    if [ ! -d "$STACK_DIR" ] || [ ! -f "$STACK_DIR/compose.yaml" ]; then
		read -rp "$STACK not installed. Install $STACK? [Y/n]: " INSTALL_ANSWER </dev/tty
		
		if [[ "${INSTALL_ANSWER,,}" == "n" ]]; then
			echo "  ~ Skipping $STACK"
			((SKIPPED++))
			continue
		fi

		echo ""
    fi

    echo "Updating $STACK..."

	mkdir -p "$STACK_DIR"

	# compose.yaml
    rm -f "$STACK_DIR/compose.yaml"

    if ! wget -qO "$STACK_DIR/compose.yaml" "$BASE_URL/$STACK/compose.yaml"; then
        echo "  ✗ Failed to download compose.yaml"
        ((FAILED++))
        continue
    fi
    echo "  ✓ compose.yaml updated"

    # .env template 
	ENV_TMP="$(mktemp)"
    if ! wget -qO "$ENV_TMP" "$BASE_URL/$STACK/.env" || [ ! -s "$ENV_TMP" ]; then
        echo "  ✗ Failed to download .env template for $STACK"
        rm -f "$ENV_TMP"
        ((FAILED++))
        continue
    fi
    echo "  ✓ .env template fetched"
    echo ""

    # Load existing .env values
    declare -A EXISTING_VALS
    if [ -f "$STACK_DIR/.env" ]; then
        while IFS='=' read -r key val || [ -n "$key" ]; do
            [[ -z "$key" || "$key" =~ ^# ]] && continue
            key="${key//$'\r'/}"
            val="${val//$'\r'/}"
            EXISTING_VALS["$key"]="$val"
        done < "$STACK_DIR/.env"
    fi

    # Load template default values
    declare -A TEMPLATE_DEFAULTS
    while IFS='=' read -r key val || [ -n "$key" ]; do
        [[ -z "$key" || "$key" =~ ^# ]] && continue
        key="${key//$'\r'/}"
        val="${val//$'\r'/}"
        TEMPLATE_DEFAULTS["$key"]="$val"
    done < "$ENV_TMP"

    # Merge: build new .env from template structure
    echo "Configuring .env"
    OUTPUT_LINES=()

    while IFS= read -r line || [ -n "$line" ]; do
        line="${line//$'\r'/}"

        # Blank lines and comments — preserve unchanged
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            OUTPUT_LINES+=("$line")
            continue
        fi

        # KEY=value lines
        if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)= ]]; then
            KEY="${BASH_REMATCH[1]}"
            TEMPLATE_DEFAULT="${TEMPLATE_DEFAULTS[$KEY]}"

            # Check for # REQUIRED and strip it from the template default
            REQUIRED=false
            if [[ "$TEMPLATE_DEFAULT" == *"# REQUIRED"* ]]; then
                REQUIRED=true
                TEMPLATE_DEFAULT="${TEMPLATE_DEFAULT%%# REQUIRED*}"
                TEMPLATE_DEFAULT="${TEMPLATE_DEFAULT%"${TEMPLATE_DEFAULT##*[! ]}"}"
            fi

            if [ -n "${EXISTING_VALS[$KEY]+_}" ]; then
                # Key exists in current .env — keep the existing value silently
                VALUE="${EXISTING_VALS[$KEY]}"
            else
                # New key not present in current .env
                if [ "$REQUIRED" = true ]; then
                    while true; do
                        read -rp "  [NEW] $KEY: " -e -i "$TEMPLATE_DEFAULT" USER_VAL </dev/tty
                        VALUE="${USER_VAL:-$TEMPLATE_DEFAULT}"
                        if [ -n "$VALUE" ] && [ "$VALUE" != "$TEMPLATE_DEFAULT" ]; then
                            break
                        fi
                        echo "  ! $KEY is required."
                    done
                elif [ -n "$TEMPLATE_DEFAULT" ]; then
                    read -rp "  [NEW] $KEY: " -e -i "$TEMPLATE_DEFAULT" USER_VAL </dev/tty
                    VALUE="${USER_VAL:-$TEMPLATE_DEFAULT}"
                else
                    read -rp "  [NEW] $KEY: " USER_VAL </dev/tty
                    VALUE="$USER_VAL"
                fi
            fi

            OUTPUT_LINES+=("$KEY=$VALUE")
        else
            OUTPUT_LINES+=("$line")
        fi
    done < "$ENV_TMP"

    rm -f "$ENV_TMP"

	# Append user-added keys not present in the template
    for KEY in "${!EXISTING_VALS[@]}"; do
        if [ -z "${TEMPLATE_DEFAULTS[$KEY]+_}" ]; then
            OUTPUT_LINES+=("$KEY=${EXISTING_VALS[$KEY]}")
        fi
    done

    # Write the merged .env
    {
        for out_line in "${OUTPUT_LINES[@]}"; do
            printf '%s\n' "$out_line"
        done
    } > "$STACK_DIR/.env"

    echo ""
    echo "  ✓ .env merged"
    echo "  ✓ $STACK updated successfully"
    echo ""

    unset EXISTING_VALS
    unset TEMPLATE_DEFAULTS
    ((UPDATED++))
done
# =========================

echo "========== Done =========="
echo "  Updated: $UPDATED  |  Skipped: $SKIPPED  |  Failed: $FAILED"
echo "  See: https://github.com/Ggjorven/homelab/tree/$BRANCH/main/docker"
