#!/bin/bash
ss -lnt4 | awk '{print $4}' | awk -F: '{print $2}' | sort -n
