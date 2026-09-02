#!/bin/bash

CONFIG_FILE="./sentinel.conf"

LOG_FILE="/var/log/sentinel.log"

log() {
    local component="$1"
    local target="$2"
    local status="$3"
    local details="$4"
    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
    printf '{"timestamp":"%s","component":"%s","target":"%s","status":"%s","details":"%s"}\n' \
        "$timestamp" "$component" "$target" "$status" "$details" >> "$LOG_FILE"
}

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
            log "SERVICE" "$svc" "OK" "$svc is running"
        else
            if eval "$svc" > /dev/null 2>&1; then
                log "SERVICE" "$svc" "FIXED" "Restarted service"
            else
                log "SERVICE" "$svc" "ERROR" "Failed to restart service"
            fi
        fi
    done
}

check_integrity() {
    for file in "${FILES_TO_WATCH[@]}"; do
        local base=$(basename "$file")
        local golden="/var/backups/sentinel/${base}.gold"

        if [ ! -f "$golden" ]; then
            log "INTEGRITY" "$file" "ERROR" "Golden copy not found"
            continue
        fi

        local hash_current=$(md5sum "$file" | awk '{print $1}')
        local hash_golden=$(md5sum "$golden" | awk '{print $1}')

        if [ "$hash_current" = "$hash_golden" ]; then
            log "INTEGRITY" "$file" "OK" "$file integrity verified"
        else
            cp "$golden" "$file"
            log "INTEGRITY" "$file" "FIXED" "Restored $file"
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
            log "PORT" "$port" "ALERT" "Killed rogue process on port $port"
        fi
    done
}

check_services
check_integrity
check_ports
