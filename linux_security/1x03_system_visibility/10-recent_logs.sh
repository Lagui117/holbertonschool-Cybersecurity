#!/bin/bash
awk -v d="$(date -d '30 minutes ago' '+%s')" '/sshd/{cmd="date -d \""$1" "$2" "$3"\" +%s"; cmd|getline t; close(cmd); if(t>=d)print}' "$1"
