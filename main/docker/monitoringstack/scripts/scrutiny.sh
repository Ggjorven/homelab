#!/bin/bash

# ======================
# CONFIG
# ======================
SCRUTINY_IP=http://192.168.xxx.xxx:8083 

# ======================
# SCRIPT
# ======================
/opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64 run --api-endpoint "$SCRUTINY_IP" 2>&1 | tee /var/log/scrutiny.log
