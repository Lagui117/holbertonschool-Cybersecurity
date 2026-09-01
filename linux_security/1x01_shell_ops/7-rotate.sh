#!/bin/bash
if [ ! -d "$1" ]; then
    exit 1
fi
mkdir -p "$1/backups"
for f in "$1"/*.log; do
    size=$(stat -c%s "$f")
    if [ "$size" -gt 1024 ]; then
        gzip "$f"
        mv "$f.gz" "$1/backups/"
    else
        echo "Skipping small file: $(basename $f)"
    fi
done
