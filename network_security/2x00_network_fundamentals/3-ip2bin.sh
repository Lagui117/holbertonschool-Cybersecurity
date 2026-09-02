#!/bin/bash
IFS='.' read -ra o <<< "$1"; r=""; for i in "${o[@]}"; do b=$(printf "%08d" $(echo "obase=2; $i" | bc)); [ -z "$r" ] && r="$b" || r="$r.$b"; done; echo "$r"
