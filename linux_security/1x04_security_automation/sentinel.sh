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

check_integrity() {
    for file in "${FILES_TO_WATCH[@]}"; do
        local base=$(basename "$file")
        local golden="/var/backups/sentinel/${base}.gold"

        if [ ! -f "$golden" ]; then
            echo "ERROR: Golden copy not found for $file"
            continue
        fi

        local hash_current=$(md5sum "$file" | awk '{print $1}')
        local hash_golden=$(md5sum "$golden" | awk '{print $1}')

        if [ "$hash_current" = "$hash_golden" ]; then
            echo "OK: $file integrity verified"
        else
            cp "$golden" "$file"
            echo "FIXED: Restored $file"
        fi
    done
}

check_ports() {
    local ports=$(ss -tlnp | awk 'NR>1 {split($4,a,":"); print a[length(a)]}')

    for port in $ports; do
        local allowed=false

        for ap in "${ALLOWED_PORTS[@]}"; do
            if [ "$port" = "$ap" ]; then
                allowed=true
                break
            fi
        done

        if [ "$allowed" = false ]; then
            fuser -k "${port}/tcp" > /dev/null 2>&1
            echo "ALERT: Killed rogue process on port $port"
        fi
    done
}

check_services
check_integrity
check_ports
