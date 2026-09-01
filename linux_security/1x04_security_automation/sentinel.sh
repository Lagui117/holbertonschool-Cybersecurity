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

echo "Configuration loaded successfully"
echo "Monitoring ${#SERVICES[@]} services: ${SERVICES[*]}"
echo "Watching ${#FILES_TO_WATCH[@]} files: ${FILES_TO_WATCH[*]}"
