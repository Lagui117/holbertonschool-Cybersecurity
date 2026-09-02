#!/bin/bash
IFS='.' read -ra ip <<< "$1"; IFS='.' read -ra mk <<< "$2"; echo "$(( ip[0] & mk[0] )).$(( ip[1] & mk[1] )).$(( ip[2] & mk[2] )).$(( ip[3] & mk[3] ))"
