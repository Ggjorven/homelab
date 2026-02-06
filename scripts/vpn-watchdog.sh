#!/bin/bash

# VPN Watchdog Script for PIA (Private Internet Access)

# How often to check the VPN status (in seconds)
CHECK_INTERVAL=10

while true; do
    # Get the current VPN connection state
    CONNECTION_STATE=$(piactl get connectionstate)

    if [[ "$CONNECTION_STATE" != "Connected" ]]; then
        echo "$(date) - VPN not connected (state: $CONNECTION_STATE). Attempting to connect..."
        
		# Try to connect
        piactl connect
        
		# Wait a few seconds for the connection to establish
        sleep 2
    else
        echo "$(date) - VPN is connected."
    fi

    # Wait before checking again
    sleep $CHECK_INTERVAL
done
