#!/bin/bash
for user in $(awk -F: '$3 >= 1000 {print $1}' "$1"); do
    for group in disk docker shadow; do
        getent group "$group" 2>/dev/null | grep -qw "$user" && echo "$user:$group"
    done
done
