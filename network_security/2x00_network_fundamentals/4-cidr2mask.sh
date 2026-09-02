#!/bin/bash
mask=$(( 0xFFFFFFFF << (32 - $1) & 0xFFFFFFFF )); echo "$(( mask >> 24 )).$(( mask >> 16 & 255 )).$(( mask >> 8 & 255 )).$(( mask & 255 ))"
