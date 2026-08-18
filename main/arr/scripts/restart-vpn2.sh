#!/bin/bash

restart_if_running() {
    if [ "$(docker inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" = "true" ]; then
        docker restart "$1"
    fi
}

restart_if_running vpn2
restart_if_running slskd
