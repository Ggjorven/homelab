#!/bin/bash

echo "Connecting to PIA VPN..."
piactl connect

echo "Waiting for VPN to connect..."
while [[ "$(piactl get connectionstate)" != "Connected" ]]; do
  sleep 1
  piactl connect
done

echo "PIA VPN connected."
