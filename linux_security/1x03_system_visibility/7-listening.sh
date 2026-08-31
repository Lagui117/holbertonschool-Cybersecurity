#!/bin/bash
ss -t4ln | awk '{print $4}' | awk -F: '{print $2}' | sort -n
