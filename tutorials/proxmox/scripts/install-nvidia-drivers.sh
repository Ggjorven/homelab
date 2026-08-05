#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------
# NOTE: This file was written with the help of an LLM (Claude)
# ------------------------------------------------------------

DRIVER_FILE="${1:?Usage: $0 <driver-file>}"
DRIVER_PATH="$(realpath ./${DRIVER_FILE})"

if [[ ! -f "${DRIVER_PATH}" ]]; then
    echo "Error: Driver installer file '${DRIVER_PATH}' not found."
    exit 1
fi

# --- Collect NVIDIA LXC IDs upfront ---
NVIDIA_IDS=()
for ID in $(pct list | awk 'NR>1 {print $1}'); do
    CONFIG="/etc/pve/lxc/${ID}.conf"
    if grep -qi "nvidia" "${CONFIG}"; then
        NVIDIA_IDS+=("$ID")
    fi
done

if [ ${#NVIDIA_IDS[@]} -eq 0 ]; then
    echo "==> No LXCs with NVIDIA devices found. Proceeding with host-only install."
fi

# --- Stop all NVIDIA LXCs before touching the driver ---
WAS_RUNNING=()
echo "==> Stopping NVIDIA LXCs before driver unload..."
for ID in "${NVIDIA_IDS[@]}"; do
    if [ "$(pct status "$ID" | awk '{print $2}')" = "running" ]; then
        echo "    Stopping LXC ${ID}..."
        pct stop "$ID"
        WAS_RUNNING+=("$ID")
    else
        echo "    LXC ${ID} already stopped, skipping."
    fi
done

# --- Unload existing NVIDIA kernel modules ---
echo "==> Unloading existing NVIDIA kernel modules..."
rmmod nvidia_drm     2>/dev/null || true
rmmod nvidia_modeset 2>/dev/null || true
rmmod nvidia_uvm     2>/dev/null || true
rmmod nvidia         2>/dev/null || true

# --- Host install ---
echo "==> Installing driver ${DRIVER_FILE} on host..."
chmod +x "${DRIVER_PATH}"
"${DRIVER_PATH}" --dkms --silent

# --- LXC installs ---
for ID in "${NVIDIA_IDS[@]}"; do
    CONFIG="/etc/pve/lxc/${ID}.conf"
    echo "==> Processing LXC ${ID}..."

    EXIT_CODE=0
    ROOTFS="/var/lib/lxc/${ID}/rootfs"

    (
        set -e
        pct mount "$ID" >/dev/null

        # Use /var/tmp/, nspawn masks /tmp/ with a fresh tmpfs
        cp "${DRIVER_PATH}" "${ROOTFS}/var/tmp/${DRIVER_FILE}"
        chmod +x "${ROOTFS}/var/tmp/${DRIVER_FILE}"

        # Setup User Namespace flags for Unprivileged Containers
        NSPAWN_ARGS=()
        if grep -qE "^unprivileged:\s*1" "${CONFIG}"; then
            OFFSET=$(grep -E "^lxc\.idmap:\s*u\s+0\s+" "${CONFIG}" | awk '{print $4}')
            SIZE=$(grep -E "^lxc\.idmap:\s*u\s+0\s+" "${CONFIG}" | awk '{print $5}')
            OFFSET="${OFFSET:-100000}"
            SIZE="${SIZE:-65536}"
            NSPAWN_ARGS+=("--private-users=${OFFSET}:${SIZE}")
            chown "${OFFSET}:${OFFSET}" "${ROOTFS}/var/tmp/${DRIVER_FILE}"
        fi

        echo "    Running driver installer via systemd-nspawn..."
        systemd-nspawn \
            --directory="${ROOTFS}" \
            "${NSPAWN_ARGS[@]}" \
            --quiet \
            -- bash -c "/var/tmp/${DRIVER_FILE} --no-kernel-module --silent && rm -f /var/tmp/${DRIVER_FILE}"
    ) || EXIT_CODE=$?

    # Always cleanup
    rm -f "${ROOTFS}/var/tmp/${DRIVER_FILE}" 2>/dev/null || true
    pct unmount "$ID" >/dev/null 2>&1 || true

    if [ "$EXIT_CODE" -ne 0 ]; then
        echo "    ERROR: Failed updating LXC ${ID} (Exit Code: ${EXIT_CODE})."
        echo "    Attempting to restart previously running LXCs before aborting..."
        for RID in "${WAS_RUNNING[@]}"; do
            pct start "$RID" 2>/dev/null || echo "    WARNING: Failed to restart LXC ${RID}."
        done
        exit "$EXIT_CODE"
    fi

    echo "    LXC ${ID} done."
done

# --- Restart LXCs that were originally running ---
echo "==> Restarting LXCs that were originally running..."
for ID in "${WAS_RUNNING[@]}"; do
    echo "    Starting LXC ${ID}..."
    pct start "$ID"
done

echo "==> All done."
