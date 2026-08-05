#!/bin/bash

# Install dependencies
apt install smartmontools -y 

# Setup variables
INSTALL_DIR="/opt/scrutiny"
BIN_DIR="$INSTALL_DIR/bin"
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/AnalogJ/scrutiny/releases/latest | grep "browser_download_url.*scrutiny-collector-metrics-linux-amd64" | cut -d '"' -f 4)

# Create directories
mkdir -p $INSTALL_DIR
mkdir -p $BIN_DIR

# Download files
curl -L $LATEST_RELEASE_URL -o $BIN_DIR/scrutiny-collector-metrics-linux-amd64
chmod +x $BIN_DIR/scrutiny-collector-metrics-linux-amd64
