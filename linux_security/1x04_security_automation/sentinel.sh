#!/bin/bash

CONFIG_FILE="./sentinel.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

if [ ${#SERVICES[@]} -eq 0 ]; then
    echo "Error: SERVICES is not defined or empty"
    exit 1
fi

if [ ${#FILES_TO_WATCH[@]} -eq 0 ]; then
    echo "Error: FILES_TO_WATCH is not defined or empty"
    exit 1
fi

check_services() {
    for svc in "${SERVICES[@]}"; do
        if pgrep -f "$svc" > /dev/null 2>&1; then
            echo "OK: $svc is running"
        else
            if eval "$svc" > /dev/null 2>&1; then
                echo "FIXED: Restarted $svc"
            else
                echo "ERROR: Failed to restart $svc"
            fi
        fi
    done
}

check_services
